ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION

ARG JOBS

RUN apk add --no-cache \
    bash \
    git \
    g++ \
    libevent-dev \
    libevent-static \
    libnet-dev \
    libpcap-dev \
    libtirpc-dev \
    libtirpc-static \
    libusb-dev \
    linux-headers \
    make \
    musl-dev \
    ncurses-terminfo \
    net-snmp-dev \
    patch \
    perl \
    rpcsvc-proto \
    gcc \
    meson \
    re2c \
    readline-dev \
    readline-static \
    ncurses-static \
    python3-dev \
    py3-numpy-dev

COPY lnls-get-n-unpack.sh /usr/local/bin/lnls-get-n-unpack
COPY lnls-run.sh /usr/local/bin/lnls-run

ARG EPICS_BASE_VERSION
ENV EPICS_BASE_PATH /opt/epics/base
ENV EPICS_MODULES_PATH /opt/epics/modules
ENV EPICS_RELEASE_FILE /opt/epics/RELEASE

WORKDIR /opt/epics
COPY install-functions.sh .

COPY backport-epics-base-musl.patch .
COPY epics-base-static-linking.patch .
COPY install_epics.sh .
RUN COMMANDLINE_LIBRARY=READLINE_NCURSES ./install_epics.sh

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
ARG IOCSTATS_VERSION
ARG IPMICOMM_VERSION
ARG PYDEVSUP_VERSION
ARG SNMP_VERSION
ARG SCALER_VERSION
ARG MCA_VERSION

WORKDIR ${EPICS_MODULES_PATH}
COPY backport-ipmicomm.patch .
COPY ipmicomm.patch .
COPY caputlog-waveform-fix.patch .
COPY install_modules.sh .
RUN NEEDS_TIRPC=YES ./install_modules.sh

COPY lnls-build-static-ioc.sh /usr/local/bin/lnls-build-static-ioc
