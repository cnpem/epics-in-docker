#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/epics_versions.sh
. $EPICS_IN_DOCKER/twincat_ads_versions.sh

git clone --recursive --depth 1 --branch ${TWINCAT_ADS_VERSION} \
    https://github.com/epics-modules/twincat-ads

mv twincat-ads ads-modules

install_module ads-modules ADS "
EPICS_BASE
ASYN
"

mkdir ads-ioc && cd ads-ioc
yes ads | ${EPICS_BASE_PATH}/bin/linux-x86_64/makeBaseApp.pl -i -t ioc
cd ..

cp -r ads-modules/adsExApp ads-ioc/adsExApp
cp ads-modules/startup/* ads-ioc/iocBoot/iocads/
rm ads-ioc/iocBoot/iocads/st.cmd

install_module -i ads-ioc ADS_IOC "
EPICS_BASE
ASYN
ADS
"
