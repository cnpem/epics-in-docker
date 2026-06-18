ARG ALPINE_VERSION=3.23.4

FROM alpine:$ALPINE_VERSION

ARG JOBS

ARG CCACHE_DIR=/ccache
ARG CCACHE_STATSLOG=/tmp/ccache.statslog

RUN apk add --no-cache \
    bash \
    cmake \
    ccache \
    git \
    g++ \
    libevent-dev \
    libevent-static \
    libnet-dev \
    libpcap-dev \
    libtirpc-dev \
    libtirpc-static \
    libusb-dev \
    libusb-compat-dev \
    libxml2-dev \
    libxml2-static \
    linux-headers \
    make \
    musl-dev \
    ncurses-terminfo \
    net-snmp-dev \
    openssl-dev \
    openssl-libs-static \
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
    py3-setuptools \
    cython \
    py3-numpy-dev && \
    for p in gcc g++; do ln -vs /usr/bin/ccache /usr/local/bin/$p; done

COPY lnls-get-n-unpack.sh /usr/local/bin/lnls-get-n-unpack
COPY lnls-run.sh /usr/local/bin/lnls-run

ENV EPICS_IN_DOCKER=/opt/epics-in-docker
RUN mkdir $EPICS_IN_DOCKER

COPY install-functions.sh $EPICS_IN_DOCKER

ENV EPICS_BASE_PATH=/opt/epics/base
ENV EPICS_MODULES_PATH=/opt/epics/modules
ENV EPICS_RELEASE_FILE=$EPICS_IN_DOCKER/RELEASE

WORKDIR /opt/epics

COPY epics-base-static-linking.patch $EPICS_IN_DOCKER
COPY epics_versions.sh install_epics.sh $EPICS_IN_DOCKER
RUN --mount=type=cache,target=/ccache/ USE_CCACHE=1 COMMANDLINE_LIBRARY=READLINE_NCURSES $EPICS_IN_DOCKER/install_epics.sh

WORKDIR ${EPICS_MODULES_PATH}

COPY modules_versions.sh install_modules.sh $EPICS_IN_DOCKER
RUN --mount=type=cache,target=/ccache/ NEEDS_TIRPC=YES $EPICS_IN_DOCKER/install_modules.sh

RUN ccache --show-log-stats && \
    for p in gcc g++; do ln -vsf /usr/bin/$p /usr/local/bin/$p; done

COPY lnls-build-static-ioc.sh /usr/local/bin/lnls-build-static-ioc
