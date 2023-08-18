#!/usr/bin/env bash

set -ex

git clone --depth 1 --branch ${MOTOR_VERSION} \
    https://github.com/epics-modules/motor

cd motor/modules

git submodule update --init --depth 1 -j ${JOBS} \
    motorMotorSim

module_releases="
MOTOR=${EPICS_MODULES_PATH}/motor
MOTOR_MOTORSIM=${EPICS_MODULES_PATH}/motor/modules/motorMotorSim
"
echo "$module_releases" >> ${EPICS_MODULES_PATH}/../RELEASE

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
