ARG DEBIAN_VERSION=12.9

FROM ghcr.io/cnpem/lnls-debian-epics-7:v0.13.0-dev AS build-image

FROM debian:${DEBIAN_VERSION}-slim AS base

ARG DEBIAN_VERSION

ARG RUNDIR
ARG ENTRYPOINT=/usr/local/bin/lnls-run
ARG RUNTIME_PACKAGES
ARG RUNTIME_TAR_PACKAGES
ARG RUNTIME_PIP_PACKAGES

ARG PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH=$PATH

LABEL br.lnls.epics-in-docker.version="v0.13.0-dev"
LABEL br.lnls.epics-in-docker.debian.version=${DEBIAN_VERSION}

COPY --from=build-image /etc/apt/apt.conf.d/90-disable-sandbox.conf /etc/apt/apt.conf.d/90-disable-sandbox.conf

RUN apt update -y && \
    apt install -y --no-install-recommends \
        libreadline8 \
        libtirpc3 \
        busybox \
        netcat-openbsd \
        procserv \
        $([ -n "$RUNTIME_PIP_PACKAGES" ] && echo pip) \
        $RUNTIME_PACKAGES && \
    busybox --install && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build-image /usr/local/lib /usr/local/lib
COPY --from=build-image /usr/local/bin/lnls-get-n-unpack /usr/local/bin/lnls-get-n-unpack
RUN lnls-get-n-unpack -r $RUNTIME_TAR_PACKAGES && \
    ldconfig
RUN if [ -n "$RUNTIME_PIP_PACKAGES" ]; then \
        pip install --break-system-packages $RUNTIME_PIP_PACKAGES; \
    fi

COPY --from=build-image /usr/local/bin/lnls-run /usr/local/bin/lnls-run

WORKDIR ${RUNDIR}

RUN ln -s ${ENTRYPOINT} ./entrypoint

ENTRYPOINT ["./entrypoint"]


FROM build-image AS pruned-build

ARG APP_DIRS
ARG RUNDIR
ARG SKIP_PRUNE

RUN if [ "$SKIP_PRUNE" != 1 ]; then lnls-prune-artifacts ${APP_DIRS} ${RUNDIR}; fi


FROM base AS no-build

ARG SKIP_PRUNE
ARG APP_DIRS
ARG RUNDIR

LABEL br.lnls.epics-in-docker.skip-prune=${SKIP_PRUNE}
LABEL br.lnls.epics-in-docker.app-dirs=${APP_DIRS}
LABEL br.lnls.epics-in-docker.rundir=${RUNDIR}
LABEL br.lnls.epics-in-docker.target="no-build"

COPY --from=pruned-build /opt /opt


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

RUN cp $EPICS_RELEASE_FILE configure/RELEASE
RUN rm -rf .git/


FROM build-stage AS dynamic-build

ARG JOBS=1
ARG APP_DIRS
ARG RUNDIR
ARG SKIP_TESTS
ARG SKIP_PRUNE

RUN lnls-build-ioc

RUN if [ "$SKIP_PRUNE" != 1 ]; then lnls-prune-artifacts ${APP_DIRS} ${PWD} ${RUNDIR}; fi


FROM base AS dynamic-link

ARG SKIP_PRUNE
ARG APP_DIRS
ARG RUNDIR

LABEL br.lnls.epics-in-docker.skip-prune=${SKIP_PRUNE}
LABEL br.lnls.epics-in-docker.app-dirs=${APP_DIRS}
LABEL br.lnls.epics-in-docker.rundir=${RUNDIR}
LABEL br.lnls.epics-in-docker.target="dynamic-link"

COPY --from=dynamic-build /opt /opt


FROM build-stage AS static-build

ARG JOBS=1
ARG RUNDIR
ARG SKIP_TESTS

RUN echo STATIC_BUILD=YES >> configure/CONFIG_SITE

RUN lnls-build-ioc


FROM base AS static-link

ARG REPONAME

LABEL br.lnls.epics-in-docker.target="static-link"

COPY --from=static-build /opt/${REPONAME} /opt/${REPONAME}
