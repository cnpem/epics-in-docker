#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/modules_versions.sh

install_from_github epics-base pvxs PVXS $PVXS_VERSION "
EPICS_BASE
"

download_from_github epics-base p4p $P4P_VERSION
echo PYTHON=python3 >> p4p/configure/CONFIG_SITE
install_module p4p P4P "
EPICS_BASE
PVXS
"
echo 'python3*/linux*/' > p4p/.lnls-keep-paths

install_from_github epics-modules sequencer SNCSEQ $SEQUENCER_VERSION "
EPICS_BASE
"

install_from_github epics-modules calc CALC $CALC_VERSION "
EPICS_BASE
"

# Build asyn without seq since it's only needed for testIPServer
install_from_github epics-modules asyn ASYN $ASYN_VERSION "
EPICS_BASE
CALC
"

install_from_github epics-modules modbus MODBUS $MODBUS_VERSION "
EPICS_BASE
ASYN
"

install_from_github paulscherrerinstitute StreamDevice STREAM $STREAMDEVICE_VERSION "
EPICS_BASE
ASYN
CALC
"

install_from_github epics-modules busy BUSY $BUSY_VERSION "
EPICS_BASE
ASYN
"

install_from_github epics-modules autosave AUTOSAVE $AUTOSAVE_VERSION "
EPICS_BASE
"

install_from_github epics-modules sscan SSCAN $SSCAN_VERSION "
EPICS_BASE
SNCSEQ
"

download_from_github ChannelFinder recsync $RECCASTER_VERSION
mv recsync recsync-root
mv recsync-root/client recsync
rm -r recsync-root
install_module recsync RECCASTER "
EPICS_BASE
"

install_from_github epics-modules ipac IPAC $IPAC_VERSION "
EPICS_BASE
"

install_from_github epics-modules caPutLog CAPUTLOG $CAPUTLOG_VERSION "
EPICS_BASE
"

install_from_github brunoseivam retools RETOOLS $RETOOLS_VERSION "
EPICS_BASE
"

install_from_github -i epics-modules ether_ip ETHER_IP $ETHER_IP_VERSION "
EPICS_BASE
"

install_from_github epics-modules iocStats DEVIOCSTATS $IOCSTATS_VERSION "
EPICS_BASE
"

JOBS=1 install_from_github slac-epics-modules ipmiComm IPMICOMM $IPMICOMM_VERSION "
EPICS_BASE
ASYN
"

download_from_github epics-modules pyDevSup $PYDEVSUP_VERSION
echo PYTHON=python3 >> pyDevSup/configure/CONFIG_SITE
install_module pyDevSup PYDEVSUP "
EPICS_BASE
"
echo 'python3*/linux*/' > pyDevSup/.lnls-keep-paths

mkdir snmp
cd snmp
lnls-get-n-unpack -l https://groups.frib.msu.edu/controls/files/epics-snmp-$SNMP_VERSION.zip
cd ..
install_module -i snmp SNMP "
EPICS_BASE
"

install_from_github epics-modules scaler SCALER $SCALER_VERSION "
EPICS_BASE
ASYN
"

install_from_github -i epics-modules mca MCA $MCA_VERSION "
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

download_from_github ISISComputingGroup EPICS-lakeshore $LAKESHORE_VERSION
mv EPICS-lakeshore/lakeshore336 .
rm -r EPICS-lakeshore
install_module lakeshore336 LAKESHORE "
EPICS_BASE
"

install_from_github DiamondLightSource lakeshore340 LAKESHORE340 $LAKESHORE340_VERSION "
EPICS_BASE
ASYN
CALC
STREAM
"

download_from_github cnpem rgamv2 $RGAMV2_VERSION
rm -r rgamv2/etc && rm -r rgamv2/rgamv2App/opi
install_module rgamv2 RGAMV2 "
EPICS_BASE
ASYN
"

download_from_github epics-modules twincat-ads $TWINCAT_ADS_VERSION
download_from_github Beckhoff ADS $ADS_VERSION
rmdir twincat-ads/BeckhoffADS && mv ADS twincat-ads/BeckhoffADS
install_module twincat-ads ADS "
EPICS_BASE
ASYN
"

download_from_github open62541 open62541 $OPEN62541_VERSION
mkdir open62541/build
cd open62541/build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=OFF -DUA_ENABLE_ENCRYPTION=OPENSSL ..
make -j$JOBS
make install
cd ../../
rm -rf open62541

download_from_github epics-modules opcua $OPCUA_VERSION
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

install_from_github epics-modules ip IP $IP_VERSION "
EPICS_BASE
SNCSEQ
ASYN
"
