#!/bin/sh

set -ex

. /opt/epics/install-functions.sh

lnls-get-n-unpack -l https://epics-controls.org/download/base/base-${EPICS_BASE_VERSION}.tar.gz
mv base-${EPICS_BASE_VERSION} ${EPICS_BASE_PATH}

patch -d ${EPICS_BASE_PATH} -Np1 < backport-epics-base-musl.patch
patch -d ${EPICS_BASE_PATH} -Np1 < epics-base-static-linking.patch

if [ -n "$COMMANDLINE_LIBRARY" ]; then
    echo "COMMANDLINE_LIBRARY = $COMMANDLINE_LIBRARY" > ${EPICS_BASE_PATH}/configure/CONFIG_SITE.local
fi

install_module base EPICS_BASE
