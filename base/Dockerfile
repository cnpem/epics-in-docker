FROM debian:11.7

ARG JOBS

ENV DEBIAN_FRONTEND noninteractive

RUN apt update -y && \
    apt install -y --no-install-recommends \
        build-essential \
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
ARG AUTOSAVE_VERSION

WORKDIR ${EPICS_MODULES_PATH}
COPY install_modules.sh .
RUN ./install_modules.sh
