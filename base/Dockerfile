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
ARG EPICS_BASE_SHA256
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
ARG PVXS_SHA256
ARG SEQUENCER_SHA256
ARG CALC_SHA256
ARG ASYN_SHA256
ARG MODBUS_SHA256
ARG STREAMDEVICE_SHA256
ARG BUSY_SHA256
ARG AUTOSAVE_SHA256
ARG SSCAN_SHA256
ARG RECCASTER_SHA256
ARG IPAC_SHA256
ARG CAPUTLOG_SHA256
ARG RETOOLS_SHA256
ARG ETHER_IP_SHA256
ARG IOCSTATS_SHA256
ARG IPMICOMM_SHA256
ARG PYDEVSUP_SHA256
ARG SNMP_SHA256
ARG SCALER_SHA256
ARG MCA_SHA256

COPY backport-ipmicomm.patch .
COPY ipmicomm.patch .
COPY caputlog-waveform-fix.patch .
COPY install_modules.sh .
RUN ./install_modules.sh

ARG AREA_DETECTOR_VERSION
ARG NDSSCPIMEGA_VERSION
ARG LIBSSCPIMEGA_VERSION
ARG NDSSCPIMEGA_SHA256
ARG LIBSSCPIMEGA_SHA256

COPY backport-adsupport-nanohttp.patch .
COPY install_area_detector.sh .
RUN ./install_area_detector.sh

ARG MOTOR_VERSION
ARG PIGCS2_VERSION
ARG PMAC_VERSION
ARG PMAC_SHA256

COPY install_motor.sh .
RUN ./install_motor.sh

ARG DEBIAN_VERSION
ARG OPCUA_VERSION
ARG OPCUA_SHA256

COPY install_opcua.sh .
RUN ./install_opcua.sh
