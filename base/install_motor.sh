#!/usr/bin/env bash

set -e

. /opt/epics/install-functions.sh

git clone --depth 1 --branch ${MOTOR_VERSION} \
    https://github.com/epics-modules/motor

cd motor/modules

git submodule update --init --depth 1 -j ${JOBS} \
    motorMotorSim

module_releases="
MOTOR=${EPICS_MODULES_PATH}/motor
MOTOR_MOTORSIM=${EPICS_MODULES_PATH}/motor/modules/motorMotorSim
"
echo "$module_releases" >> ${EPICS_RELEASE_FILE}

cd ../configure

echo "
EPICS_BASE=${EPICS_BASE_PATH}
ASYN=${EPICS_MODULES_PATH}/asyn
SNCSEQ=${EPICS_MODULES_PATH}/seq
BUSY=${EPICS_MODULES_PATH}/busy
IPAC=${EPICS_MODULES_PATH}/ipac
" > RELEASE.local

echo "
BUILD_IOCS=NO
" > CONFIG_SITE.local

cd ..

make -j${JOBS}
make clean

cd $EPICS_MODULES_PATH

download_github_module dls-controls pmac $PMAC_VERSION

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
EPICS_BASE=${EPICS_BASE_PATH}
ASYN=${EPICS_MODULES_PATH}/asyn
CALC=${EPICS_MODULES_PATH}/calc
MOTOR=${EPICS_MODULES_PATH}/motor
BUSY=${EPICS_MODULES_PATH}/busy
"
