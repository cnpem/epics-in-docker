#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/zaber_versions.sh

ZML_URL="https://www.zaber.com/support/software-downloads.php?product=zml_cpp_support&version=${ZABER_MOTION_LIBRARY_VERSION}"

download_from_github zabertech motorZaberMotion $ZABER_MOTION_VERSION $ZABER_MOTION_SHA256

(
    cd /tmp
    lnls-get-n-unpack -l "${ZML_URL}" $ZABER_MOTION_LIBRARY_SHA256
    cp -a ZaberMotionCppSupport/lib/linux_x64/* /usr/local/lib/
    cp -r ZaberMotionCppSupport/include/zaber /usr/local/include/
    ldconfig
)

sed -i '/zaberMotionSupport/s/^/# /' motorZaberMotion/Makefile
install_module motorZaberMotion MOTOR_ZABER_MOTION "
EPICS_BASE
ASYN
MOTOR
"
