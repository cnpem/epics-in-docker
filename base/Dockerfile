ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}

ARG JOBS

ENV DEBIAN_FRONTEND noninteractive

# Disable APT sandbox so that single UID restriction is satisfied in systems
# without subuid and subgid configured.
RUN echo 'APT::Sandbox::User "root";' > /etc/apt/apt.conf.d/90-disable-sandbox.conf

RUN apt update -y && \
    apt install -y --no-install-recommends \
        build-essential \
        git \
        libaravis-dev \
        libevent-dev \
        libnet-dev \
        libpcap-dev \
        libreadline-dev \
        libssh2-1-dev \
        libtiff-dev \
        libusb-1.0-0-dev \
        libxml2-dev \
        libsnmp-dev \
        libssl-dev \
        re2c \
        unzip \
        wget \
        python3-dev \
        python3-numpy \
        ca-certificates

COPY lnls-get-n-unpack.sh /usr/local/bin/lnls-get-n-unpack
COPY lnls-run.sh /usr/local/bin/lnls-run

WORKDIR /opt/epics
COPY install-functions.sh .

ARG EPICS_BASE_VERSION
ENV EPICS_BASE_PATH /opt/epics/base
ENV EPICS_MODULES_PATH /opt/epics/modules
ENV EPICS_RELEASE_FILE /opt/epics/RELEASE

COPY backport-epics-base-musl.patch .
COPY epics-base-static-linking.patch .
COPY install_epics.sh .
RUN ./install_epics.sh

WORKDIR ${EPICS_MODULES_PATH}

ARG PVXS_VERSION
ARG SEQUENCER_VERSION
ARG CALC_VERSION
ARG ASYN_VERSION
ARG MODBUS_VERSION
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

COPY backport-ipmicomm.patch .
COPY ipmicomm.patch .
COPY caputlog-waveform-fix.patch .
COPY install_modules.sh .
RUN ./install_modules.sh

ARG AREA_DETECTOR_VERSION
ARG NDSSCPIMEGA_VERSION
ARG LIBSSCPIMEGA_VERSION

COPY backport-adsupport-nanohttp.patch .
COPY install_area_detector.sh .
RUN ./install_area_detector.sh

ARG MOTOR_VERSION
ARG PIGCS2_VERSION
ARG PMAC_VERSION

COPY install_motor.sh .
RUN ./install_motor.sh

ARG DEBIAN_VERSION
ARG OPCUA_VERSION

COPY install_opcua.sh .
RUN ./install_opcua.sh
