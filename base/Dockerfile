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
        libtirpc-dev \
        re2c \
        unzip \
        wget \
        python3-dev \
        cython3 \
        python3-numpy \
        ca-certificates

COPY lnls-get-n-unpack.sh /usr/local/bin/lnls-get-n-unpack
COPY lnls-run.sh /usr/local/bin/lnls-run

ENV EPICS_IN_DOCKER /opt/epics-in-docker
RUN mkdir $EPICS_IN_DOCKER

COPY install-functions.sh $EPICS_IN_DOCKER

ENV EPICS_BASE_PATH /opt/epics/base
ENV EPICS_MODULES_PATH /opt/epics/modules
ENV EPICS_RELEASE_FILE $EPICS_IN_DOCKER/RELEASE

WORKDIR /opt/epics

COPY epics-base-static-linking.patch $EPICS_IN_DOCKER
COPY epics_versions.sh install_epics.sh $EPICS_IN_DOCKER
RUN $EPICS_IN_DOCKER/install_epics.sh

WORKDIR ${EPICS_MODULES_PATH}

COPY backport-ipmicomm.patch ipmicomm.patch caputlog-waveform-fix.patch $EPICS_IN_DOCKER
COPY modules_versions.sh install_modules.sh $EPICS_IN_DOCKER
RUN NEEDS_TIRPC=YES $EPICS_IN_DOCKER/install_modules.sh

COPY backport-adsupport-nanohttp.patch $EPICS_IN_DOCKER
COPY area_detector_versions.sh install_area_detector.sh $EPICS_IN_DOCKER
RUN $EPICS_IN_DOCKER/install_area_detector.sh

COPY motor_versions.sh install_motor.sh $EPICS_IN_DOCKER
RUN $EPICS_IN_DOCKER/install_motor.sh

ARG DEBIAN_VERSION
COPY opcua_versions.sh install_opcua.sh $EPICS_IN_DOCKER
RUN $EPICS_IN_DOCKER/install_opcua.sh
