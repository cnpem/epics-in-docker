ARG BUILD_STAGE_VERSION=v0.2.0
ARG DEBIAN_VERSION=11.7

FROM ghcr.io/cnpem/lnls-debian-11-epics-7:${BUILD_STAGE_VERSION} AS build-stage

ARG REPONAME
ARG BUILD_PACKAGES

RUN if [ -n "$BUILD_PACKAGES" ]; then apt update && apt install $BUILD_PACKAGES; fi

WORKDIR /opt/${REPONAME}

COPY . .

RUN cp /opt/epics/RELEASE configure/RELEASE


FROM debian:${DEBIAN_VERSION}-slim as base

ARG RUNDIR
ARG ENTRYPOINT=/bin/bash
ARG RUNTIME_PACKAGES

RUN apt update -y && \
    apt install -y --no-install-recommends \
        libreadline8 \
        busybox \
        netcat-openbsd \
        procserv \
        $RUNTIME_PACKAGES && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR ${RUNDIR}

RUN ln -s ${ENTRYPOINT} ./entrypoint

ENTRYPOINT ["./entrypoint"]


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
