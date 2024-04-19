ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION

ARG JOBS

RUN apk add --no-cache \
    bash \
    g++ \
    libevent-dev \
    libevent-static \
    libtirpc-dev \
    libtirpc-static \
    linux-headers \
    make \
    musl-dev \
    ncurses-terminfo \
    patch \
    perl \
    rpcsvc-proto \
    gcc \
    meson \
    re2c \
    readline-dev \
    readline-static

COPY lnls-get-n-unpack.sh /usr/local/bin/lnls-get-n-unpack
COPY lnls-run.sh /usr/local/bin/lnls-run

ARG EPICS_BASE_VERSION
ENV EPICS_BASE_PATH /opt/epics/base
ENV EPICS_MODULES_PATH /opt/epics/modules
ENV EPICS_RELEASE_FILE /opt/epics/RELEASE

WORKDIR /opt/epics
COPY install-functions.sh .

COPY backport-epics-base-musl.patch .
COPY install_epics.sh .
RUN ./install_epics.sh

ARG PVXS_VERSION
ARG SEQUENCER_VERSION
ARG CALC_VERSION
ARG ASYN_VERSION
ARG STREAMDEVICE_VERSION
ARG BUSY_VERSION
ARG AUTOSAVE_VERSION
ARG SSCAN_VERSION
ARG RECCASTER_VERSION
ARG IPAC_VERSION
ARG CAPUTLOG_VERSION
ARG RETOOLS_VERSION
ARG ETHER_IP_VERSION

WORKDIR ${EPICS_MODULES_PATH}
COPY caputlog-waveform-fix.patch .
COPY install_modules.sh .
RUN NEEDS_TIRPC=YES ./install_modules.sh
