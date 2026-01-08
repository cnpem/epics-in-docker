#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/modules_versions.sh

install_from_github epics-base pvxs PVXS $PVXS_VERSION $PVXS_SHA256 "
EPICS_BASE
"

download_from_github epics-base p4p $P4P_VERSION $P4P_SHA256
echo PYTHON=python3 >> p4p/configure/CONFIG_SITE
install_module p4p P4P "
EPICS_BASE
PVXS
"
echo 'python3*/linux*/' > p4p/.lnls-keep-paths

install_from_github epics-modules sequencer SNCSEQ $SEQUENCER_VERSION $SEQUENCER_SHA256 "
EPICS_BASE
"

install_from_github epics-modules calc CALC $CALC_VERSION $CALC_SHA256 "
EPICS_BASE
"

# Build asyn without seq since it's only needed for testIPServer
install_from_github epics-modules asyn ASYN $ASYN_VERSION $ASYN_SHA256 "
EPICS_BASE
CALC
"

install_from_github epics-modules modbus MODBUS $MODBUS_VERSION $MODBUS_SHA256 "
EPICS_BASE
ASYN
"

install_from_github paulscherrerinstitute StreamDevice STREAM $STREAMDEVICE_VERSION $STREAMDEVICE_SHA256 "
EPICS_BASE
ASYN
CALC
"

install_from_github epics-modules busy BUSY $BUSY_VERSION $BUSY_SHA256 "
EPICS_BASE
ASYN
"

install_from_github epics-modules autosave AUTOSAVE $AUTOSAVE_VERSION $AUTOSAVE_SHA256 "
EPICS_BASE
"

install_from_github epics-modules sscan SSCAN $SSCAN_VERSION $SSCAN_SHA256 "
EPICS_BASE
SNCSEQ
"

download_from_github ChannelFinder recsync $RECCASTER_VERSION $RECCASTER_SHA256
mv recsync recsync-root
mv recsync-root/client recsync
rm -r recsync-root
install_module recsync RECCASTER "
EPICS_BASE
"

install_from_github epics-modules ipac IPAC $IPAC_VERSION $IPAC_SHA256 "
EPICS_BASE
"

install_from_github epics-modules caPutLog CAPUTLOG $CAPUTLOG_VERSION $CAPUTLOG_SHA256 "
EPICS_BASE
"

install_from_github brunoseivam retools RETOOLS $RETOOLS_VERSION $RETOOLS_SHA256 "
EPICS_BASE
"

install_from_github -i epics-modules ether_ip ETHER_IP $ETHER_IP_VERSION $ETHER_IP_SHA256 "
EPICS_BASE
"

install_from_github epics-modules iocStats DEVIOCSTATS $IOCSTATS_VERSION $IOCSTATS_SHA256 "
EPICS_BASE
"

JOBS=1 install_from_github slac-epics-modules ipmiComm IPMICOMM $IPMICOMM_VERSION $IPMICOMM_SHA256 "
EPICS_BASE
ASYN
"

download_from_github epics-modules pyDevSup $PYDEVSUP_VERSION $PYDEVSUP_SHA256
echo PYTHON=python3 >> pyDevSup/configure/CONFIG_SITE
install_module pyDevSup PYDEVSUP "
EPICS_BASE
"
echo 'python3*/linux*/' > pyDevSup/.lnls-keep-paths

mkdir snmp
cd snmp
lnls-get-n-unpack -l https://groups.frib.msu.edu/controls/files/epics-snmp-$SNMP_VERSION.zip \
    $SNMP_SHA256
cd ..
install_module -i snmp SNMP "
EPICS_BASE
"

install_from_github epics-modules scaler SCALER $SCALER_VERSION $SCALER_SHA256 "
EPICS_BASE
ASYN
"

install_from_github -i epics-modules mca MCA $MCA_VERSION $MCA_SHA256 "
EPICS_BASE
CALC
SSCAN
BUSY
SCALER
SNCSEQ
AUTOSAVE
ASYN
MCA
"

download_from_github ISISComputingGroup EPICS-lakeshore $LAKESHORE_VERSION $LAKESHORE_SHA256
mv EPICS-lakeshore/lakeshore336 .
rm -r EPICS-lakeshore
install_module lakeshore336 LAKESHORE "
EPICS_BASE
"

install_from_github DiamondLightSource lakeshore340 LAKESHORE340 $LAKESHORE340_VERSION $LAKESHORE340_SHA256 "
EPICS_BASE
ASYN
CALC
STREAM
"

download_from_github cnpem rgamv2 $RGAMV2_VERSION $RGAMV2_SHA256
rm -r rgamv2/etc && rm -r rgamv2/rgamv2App/opi
install_module rgamv2 RGAMV2 "
EPICS_BASE
ASYN
"

download_from_github epics-modules twincat-ads $TWINCAT_ADS_VERSION $TWINCAT_ADS_SHA256
download_from_github Beckhoff ADS $ADS_VERSION $ADS_SHA256
rmdir twincat-ads/BeckhoffADS && mv ADS twincat-ads/BeckhoffADS
install_module twincat-ads ADS "
EPICS_BASE
ASYN
"

download_from_github open62541 open62541 $OPEN62541_VERSION $OPEN62541_SHA256
mkdir open62541/build
cd open62541/build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=OFF -DUA_ENABLE_ENCRYPTION=OPENSSL ..
make -j$JOBS
make install
cd ../../
rm -rf open62541

download_from_github epics-modules opcua $OPCUA_VERSION $OPCUA_SHA256
cat << EOF > opcua/configure/CONFIG_SITE.local
OPEN62541=/usr/local/lib
OPEN62541_DEPLOY_MODE=SYSTEM
OPEN62541_USE_CRYPTO=YES
OPEN62541_USE_XMLPARSER=YES
EOF
rm -rf opcua/exampleTop
install_module opcua OPCUA "
EPICS_BASE
"

install_from_github DiamondLightSource elcomat3000 ELCOMAT3000 $ELCOMAT3000_VERSION $ELCOMAT3000_SHA256 "
EPICS_BASE
ASYN
"
