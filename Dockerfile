ARG BUILD_STAGE_VERSION=v0.1.0
ARG DEBIAN_VERSION=11.7

FROM ghcr.io/cnpem/lnls-debian-11-epics-7:${BUILD_STAGE_VERSION} AS BUILD_STAGE

ARG JOBS=1
ARG REPONAME
ARG RUNDIR

WORKDIR /opt/${REPONAME}

COPY . .
RUN echo STATIC_BUILD=YES >> configure/CONFIG_SITE.local && cp /opt/epics/RELEASE configure/RELEASE

RUN make distclean && make -j ${JOBS} && make clean && make -C ${RUNDIR}

FROM debian:${DEBIAN_VERSION}-slim

ARG REPONAME
ARG RUNDIR
ARG ENTRYPOINT=/bin/bash

RUN apt update -y && apt install -y --no-install-recommends busybox netcat-openbsd procserv && apt clean && rm -rf /var/lib/apt/lists/*
COPY --from=BUILD_STAGE /opt/${REPONAME} /opt/${REPONAME}

WORKDIR ${RUNDIR}

RUN ln -s ${ENTRYPOINT} ./entrypoint

ENTRYPOINT ["./entrypoint"]
