ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}

ARG JOBS

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -y && \
    apt install -y --no-install-recommends \
        build-essential \
        git \
        libreadline-dev \
        libxml2-dev \
        re2c \
        wget \
        ca-certificates

ARG EPICS_BASE_VERSION
ENV EPICS_BASE_PATH /opt/epics/base
ENV EPICS_MODULES_PATH /opt/epics/modules

WORKDIR /opt/epics
COPY install_epics.sh .
RUN ./install_epics.sh

ARG SEQUENCER_VERSION
ARG CALC_VERSION
ARG ASYN_VERSION
ARG STREAMDEVICE_VERSION
ARG BUSY_VERSION
ARG AUTOSAVE_VERSION
ARG SSCAN_VERSION
ARG AREA_DETECTOR_VERSION

WORKDIR ${EPICS_MODULES_PATH}
COPY install_modules.sh .
RUN ./install_modules.sh

COPY nanohttp_stream.patch .
COPY install_area_detector.sh .
RUN ./install_area_detector.sh
