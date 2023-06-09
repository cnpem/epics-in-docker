ARG BUILD_STAGE_VERSION=v0.2.0
ARG DEBIAN_VERSION=11.7

FROM ghcr.io/cnpem/lnls-debian-11-epics-7:${BUILD_STAGE_VERSION} AS BUILD_STAGE

ARG JOBS=1
ARG REPONAME
ARG RUNDIR
ARG BUILD_PACKAGES

WORKDIR /opt/${REPONAME}

COPY . .
RUN echo STATIC_BUILD=YES >> configure/CONFIG_SITE.local && cp /opt/epics/RELEASE configure/RELEASE

RUN if [ -n "$BUILD_PACKAGES" ]; then apt update && apt install $BUILD_PACKAGES; fi

RUN make distclean && make -j ${JOBS} && make clean && make -C ${RUNDIR}

FROM debian:${DEBIAN_VERSION}-slim

ARG REPONAME
ARG RUNDIR
ARG ENTRYPOINT=/bin/bash
ARG RUNTIME_PACKAGES

RUN apt update -y && apt install -y --no-install-recommends libreadline8 busybox netcat-openbsd procserv $RUNTIME_PACKAGES && apt clean && rm -rf /var/lib/apt/lists/*
COPY --from=BUILD_STAGE /opt/${REPONAME} /opt/${REPONAME}

WORKDIR ${RUNDIR}

RUN ln -s ${ENTRYPOINT} ./entrypoint

ENTRYPOINT ["./entrypoint"]
