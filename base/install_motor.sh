#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/motor_versions.sh

download_from_github epics-modules motor ${MOTOR_VERSION} ${MOTOR_SHA256}

cd motor/modules

download_from_github epics-motor motorMotorSim ${MOTORSIM_VERSION} ${MOTORSIM_SHA256}

download_from_github epics-motor motorPIGCS2 $PIGCS2_VERSION $PIGCS2_SHA256
download_from_github cnpem motorNewport $NEWPORT_VERSION $NEWPORT_SHA256
download_from_github epics-motor motorParker $PARKER_VERSION $PARKER_SHA256

module_releases="
MOTOR=${EPICS_MODULES_PATH}/motor
MOTOR_MOTORSIM=${EPICS_MODULES_PATH}/motor/modules/motorMotorSim
MOTOR_NEWPORT=${EPICS_MODULES_PATH}/motor/modules/motorNewport
MOTOR_PARKER=${EPICS_MODULES_PATH}/motor/modules/motorParker
MOTOR_PIGCS2=${EPICS_MODULES_PATH}/motor/modules/motorPIGCS2
"
echo "$module_releases" >> ${EPICS_RELEASE_FILE}

cd ../configure

get_module_path "
EPICS_BASE
ASYN
SNCSEQ
BUSY
IPAC
" > RELEASE.local

echo "
BUILD_IOCS=NO
" > CONFIG_SITE.local

cd ..

make -j${JOBS}
make clean

cd $EPICS_MODULES_PATH

download_from_github dls-controls pmac $PMAC_VERSION $PMAC_SHA256

rm pmac/configure/RELEASE.local.linux-x86_64
rm pmac/configure/RELEASE.linux-x86_64.Common
rm pmac/configure/CONFIG_SITE.linux-x86_64.Common

echo "
BUILD_IOCS=NO
USE_GRAPHICSMAGICK=NO

SSH             = YES
SSH_LIB         = $(pkg-config --variable=libdir libssh2)
SSH_INCLUDE     = $(pkg-config --cflags-only-I libssh2)

WITH_BOOST = NO
" >> pmac/configure/CONFIG_SITE

JOBS=1 install_module pmac PMAC "
EPICS_BASE
ASYN
CALC
MOTOR
BUSY
"
