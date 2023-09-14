#!/usr/bin/env sh

set -eu

. /opt/epics/install-functions.sh

cd $EPICS_MODULES_PATH/areaDetector

lnls-get-n-unpack -l http://download.lnls.br/packages/ad-pimega_${ADPIMEGA_VERSION}.tar.gz

echo "BUILD_IOCS=YES" >> ADPimega/configure/CONFIG_SITE
cat $EPICS_RELEASE_FILE >> ADPimega/iocs/pimegaIOC/configure/RELEASE

install_module ADPimega ADPIMEGA "
EPICS_BASE=${EPICS_BASE_PATH}

ASYN=${EPICS_MODULES_PATH}/asyn
AREA_DETECTOR=${EPICS_MODULES_PATH}/areaDetector
ADCORE=${EPICS_MODULES_PATH}/areaDetector/ADCore
ADSUPPORT=${EPICS_MODULES_PATH}/areaDetector/ADSupport
"
