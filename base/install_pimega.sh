#!/usr/bin/env bash

set -ex

. /opt/epics/install-functions.sh

cd /opt/epics/modules

git clone --depth 1 --branch ${LIBSSCPIMEGA_VERSION} \
    https://github.com/cnpem/ssc-pimega

make -C ssc-pimega/c install

install_github_module cnpem NDSSCPimega NDSSCPIMEGA $NDSSCPIMEGA_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

ASYN=${EPICS_MODULES_PATH}/asyn
AREA_DETECTOR=${EPICS_MODULES_PATH}/areaDetector
ADCORE=${EPICS_MODULES_PATH}/areaDetector/ADCore
"

cd areaDetector

lnls-get-n-unpack -l http://10.30.1.74/packages/ad-pimega_${ADPIMEGA_VERSION}.tar.gz

echo "
EPICS_BASE=${EPICS_BASE_PATH}
" > ADPimega/configure/RELEASE.local

echo "ADPIMEGA=${EPICS_MODULES_PATH}/areaDetector/ADPimega" >> $EPICS_RELEASE_FILE

echo "BUILD_IOCS=YES" >> configure/CONFIG_SITE
cp $EPICS_RELEASE_FILE ADPimega/iocs/pimegaIOC/configure/RELEASE

make -C ADPimega
