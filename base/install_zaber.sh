#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/zaber_versions.sh

ZML_DIR=${EPICS_MODULES_PATH}/motorZaberMotion/zaberMotionSupport
ZML_ZIP=${ZML_DIR}/ZaberMotionCppSupport-${ZABER_MOTION_LIBRARY_VERSION}.zip
ZML_URL="https://www.zaber.com/support/software-downloads.php?product=zml_cpp_support&version=${ZABER_MOTION_LIBRARY_VERSION}"

download_from_github zabertech motorZaberMotion $ZABER_MOTION_VERSION

wget -O "${ZML_ZIP}" "${ZML_URL}"
unzip -q -o "${ZML_ZIP}" -d "${ZML_DIR}"
rm -f "${ZML_ZIP}"

cp -a ${ZML_DIR}/ZaberMotionCppSupport/lib/linux_x64/* /usr/local/lib/
cp -r ${ZML_DIR}/ZaberMotionCppSupport/include/zaber/motion/* /usr/local/include/

sed -i '/zaberMotionSupport/s/^/# /' motorZaberMotion/Makefile
install_module motorZaberMotion MOTOR_ZABER_MOTION "
EPICS_BASE
ASYN
MOTOR
"
