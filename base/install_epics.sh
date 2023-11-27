#!/bin/sh

set -ex

. /opt/epics/install-functions.sh

lnls-get-n-unpack -l https://epics-controls.org/download/base/base-${EPICS_BASE_VERSION}.tar.gz
mv base-${EPICS_BASE_VERSION} ${EPICS_BASE_PATH}

patch -d ${EPICS_BASE_PATH} -Np1 < backport-epics-base-musl.patch

install_module base EPICS_BASE
