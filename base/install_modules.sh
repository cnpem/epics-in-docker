#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/modules_versions.sh

install_from_github epics-base pvxs PVXS $PVXS_VERSION "
EPICS_BASE
" \
$PVXS_SHA256

download_from_github epics-base p4p $P4P_VERSION $P4P_SHA256
echo PYTHON=python3 >> p4p/configure/CONFIG_SITE
install_module p4p P4P "
EPICS_BASE
PVXS
"
echo 'python3*/linux*/' > p4p/.lnls-keep-paths

install_from_github epics-modules sequencer SNCSEQ $SEQUENCER_VERSION "
EPICS_BASE
" \
$SEQUENCER_SHA256

install_from_github epics-modules calc CALC $CALC_VERSION "
EPICS_BASE
" \
$CALC_SHA256

# Build asyn without seq since it's only needed for testIPServer
install_from_github epics-modules asyn ASYN $ASYN_VERSION "
EPICS_BASE
CALC
" \
$ASYN_SHA256

install_from_github epics-modules modbus MODBUS $MODBUS_VERSION "
EPICS_BASE
ASYN
" \
$MODBUS_SHA256

install_from_github paulscherrerinstitute StreamDevice STREAM $STREAMDEVICE_VERSION "
EPICS_BASE
ASYN
CALC
" \
$STREAMDEVICE_SHA256

install_from_github epics-modules busy BUSY $BUSY_VERSION "
EPICS_BASE
ASYN
" \
$BUSY_SHA256

install_from_github epics-modules autosave AUTOSAVE $AUTOSAVE_VERSION "
EPICS_BASE
" \
$AUTOSAVE_SHA256

install_from_github epics-modules sscan SSCAN $SSCAN_VERSION "
EPICS_BASE
SNCSEQ
" \
$SSCAN_SHA256

download_from_github ChannelFinder recsync $RECCASTER_VERSION $RECCASTER_SHA256
mv recsync recsync-root
mv recsync-root/client recsync
rm -r recsync-root
install_module recsync RECCASTER "
EPICS_BASE
"

install_from_github epics-modules ipac IPAC $IPAC_VERSION "
EPICS_BASE
" \
$IPAC_SHA256

download_from_github epics-modules caPutLog $CAPUTLOG_VERSION $CAPUTLOG_SHA256
patch -d caPutLog -Np1 < $EPICS_IN_DOCKER/caputlog-waveform-fix.patch
install_module caPutLog CAPUTLOG "
EPICS_BASE
"

install_from_github brunoseivam retools RETOOLS $RETOOLS_VERSION "
EPICS_BASE
" \
$RETOOLS_SHA256

install_from_github -i epics-modules ether_ip ETHER_IP $ETHER_IP_VERSION "
EPICS_BASE
" \
$ETHER_IP_SHA256

install_from_github  epics-modules iocStats DEVIOCSTATS $IOCSTATS_VERSION "
EPICS_BASE
" \
$IOCSTATS_SHA256

download_from_github slac-epics-modules ipmiComm $IPMICOMM_VERSION $IPMICOMM_SHA256
patch -d ipmiComm -Np1 < $EPICS_IN_DOCKER/backport-ipmicomm.patch
patch -d ipmiComm -Np1 < $EPICS_IN_DOCKER/ipmicomm.patch
JOBS=1 install_module ipmiComm IPMICOMM "
EPICS_BASE
ASYN
"

download_from_github mdavidsaver pyDevSup $PYDEVSUP_VERSION $PYDEVSUP_SHA256
echo PYTHON=python3 >> pyDevSup/configure/CONFIG_SITE
install_module pyDevSup PYDEVSUP "
EPICS_BASE
"
echo 'python3*/linux*/' > pyDevSup/.lnls-keep-paths

mkdir snmp
cd snmp
lnls-get-n-unpack -l https://groups.nscl.msu.edu/controls/files/epics-snmp-$SNMP_VERSION.zip \
$SNMP_SHA256
cd ..
install_module -i snmp SNMP "
EPICS_BASE
"

install_from_github epics-modules scaler SCALER $SCALER_VERSION "
EPICS_BASE
ASYN
" \
$SCALER_SHA256

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
" \
$MCA_SHA256

download_from_github ISISComputingGroup EPICS-lakeshore $LAKESHORE_VERSION $LAKESHORE_SHA256
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
" \
$LAKESHORE340_SHA256
