FROM ghcr.io/cnpem/lnls-debian-11-epics-7 AS BUILD_STAGE

ARG JOBS=1
ARG REPONAME
ARG RUNDIR

WORKDIR /opt/${REPONAME}

COPY . .
RUN echo STATIC_BUILD=YES >> configure/CONFIG_SITE.local

RUN make distclean && make -j ${JOBS} && make clean && make -C ${RUNDIR}

FROM debian:11.7-slim

ARG REPONAME
ARG RUNDIR
ARG ENTRYPOINT

RUN apt update -y && apt install -y --no-install-recommends busybox netcat-openbsd procserv && apt clean && rm -rf /var/lib/apt/lists/*
COPY --from=BUILD_STAGE /opt/${REPONAME} /opt/${REPONAME}

WORKDIR ${RUNDIR}

RUN if [ -n "${ENTRYPOINT}" ]; then ln -s ${ENTRYPOINT} ./entrypoint; else ln -s /bin/bash ./entrypoint; fi

ENTRYPOINT ["./entrypoint"]
