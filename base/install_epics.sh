#!/bin/sh

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/epics_versions.sh

lnls-get-n-unpack -l https://epics-controls.org/download/base/base-${EPICS_BASE_VERSION}.tar.gz
mv base-${EPICS_BASE_VERSION} ${EPICS_BASE_PATH}

patch -d ${EPICS_BASE_PATH} -Np1 < $EPICS_IN_DOCKER/epics-base-static-linking.patch

if [ -n "$COMMANDLINE_LIBRARY" ]; then
    echo "COMMANDLINE_LIBRARY = $COMMANDLINE_LIBRARY" > ${EPICS_BASE_PATH}/configure/CONFIG_SITE.local
fi

if [ "$USE_CCACHE" = 1 ]; then
    printf "CC=/usr/local/bin/gcc\nCCC=/usr/local/bin/g++\n" >> ${EPICS_BASE_PATH}/configure/CONFIG.gnuCommon
fi

install_module base EPICS_BASE
