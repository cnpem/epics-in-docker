#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/motor_versions.sh

git clone --depth 1 --branch ${MOTOR_VERSION} \
    https://github.com/epics-modules/motor

cd motor/modules

git submodule update --init --depth 1 -j ${JOBS} \
    motorMotorSim

git submodule update --init -j ${JOBS} \
    motorPIGCS2

git -C motorPIGCS2 checkout ${PIGCS2_VERSION}

rm -rf .git

module_releases="
MOTOR=${EPICS_MODULES_PATH}/motor
MOTOR_MOTORSIM=${EPICS_MODULES_PATH}/motor/modules/motorMotorSim
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

install_module -i modules/motorPIGCS2/iocs/pigcs2IOC PIGCS2 "
EPICS_BASE
ASYN
MOTOR
SNCSEQ
"

cd $EPICS_MODULES_PATH

download_from_github dls-controls pmac $PMAC_VERSION

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

download_from_github cnpem motorParker $PARKER_VERSION
install_module motorParker MOTOR_PARKER "
EPICS_BASE
ASYN
MOTOR
"
install_module -i motorParker/iocs/parkerIOC PARKER "
EPICS_BASE
ASYN
MOTOR
MOTOR_PARKER
"
