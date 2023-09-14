#!/bin/sh

set -ex

lnls-get-n-unpack -l https://epics-controls.org/download/base/base-${EPICS_BASE_VERSION}.tar.gz

mv base-${EPICS_BASE_VERSION} ${EPICS_BASE_PATH}
make -j ${JOBS} -C ${EPICS_BASE_PATH} install
make -C ${EPICS_BASE_PATH} clean
