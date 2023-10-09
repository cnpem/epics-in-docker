ARG DEBIAN_VERSION=11.7

FROM ghcr.io/cnpem/lnls-debian-11-epics-7:v0.3.0 AS build-image

FROM debian:${DEBIAN_VERSION}-slim AS base

ARG RUNDIR
ARG ENTRYPOINT=/bin/bash
ARG RUNTIME_PACKAGES
ARG RUNTIME_TAR_PACKAGES

RUN apt update -y && \
    apt install -y --no-install-recommends \
        libreadline8 \
        busybox \
        netcat-openbsd \
        procserv \
        wget \
        $RUNTIME_PACKAGES && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build-image /usr/local/bin/lnls-get-n-unpack /usr/local/bin/lnls-get-n-unpack
RUN lnls-get-n-unpack -r $RUNTIME_TAR_PACKAGES && \
    ldconfig

WORKDIR ${RUNDIR}

RUN ln -s ${ENTRYPOINT} ./entrypoint

ENTRYPOINT ["./entrypoint"]


FROM base AS no-build

COPY --from=build-image /opt /opt


FROM build-image AS build-stage

ARG REPONAME
ARG BUILD_PACKAGES
ARG BUILD_TAR_PACKAGES

RUN if [ -n "$BUILD_PACKAGES" ]; then \
        apt update && \
        apt install -y --no-install-recommends $BUILD_PACKAGES; \
    fi
RUN lnls-get-n-unpack -r $BUILD_TAR_PACKAGES

WORKDIR /opt/${REPONAME}

COPY . .

RUN cp /opt/epics/RELEASE configure/RELEASE
RUN rm -rf .git/


FROM build-stage AS dynamic-build

ARG JOBS=1
ARG RUNDIR

RUN make distclean && make -j ${JOBS} && make clean && make -C ${RUNDIR}


FROM base AS dynamic-link

COPY --from=dynamic-build /opt /opt


FROM build-stage AS static-build

ARG JOBS=1
ARG RUNDIR

RUN echo STATIC_BUILD=YES >> configure/CONFIG_SITE.local

RUN make distclean && make -j ${JOBS} && make clean && make -C ${RUNDIR}


FROM base AS static-link

ARG REPONAME

COPY --from=static-build /opt/${REPONAME} /opt/${REPONAME}
