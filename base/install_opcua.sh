#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/epics_versions.sh
. $EPICS_IN_DOCKER/opcua_versions.sh

opcua_release_url=https://github.com/epics-modules/opcua/releases/download/v${OPCUA_VERSION}
opcua_release_file=IOC_opcua-${OPCUA_VERSION}_Base-${EPICS_BASE_VERSION}_debian${DEBIAN_VERSION%.*}.tar.gz
lnls-get-n-unpack -l $opcua_release_url/$opcua_release_file

mv binaryOpcuaIoc opcua
install_module -i opcua OPCUA "
EPICS_BASE
"

EPICS_HOST_ARCH=`perl ${EPICS_BASE_PATH}/lib/perl/EpicsHostArch.pl`
ln -s ${EPICS_MODULES_PATH}/opcua/{opcuaIocApp/libopcua.so.0.9,lib/${EPICS_HOST_ARCH}/libopcua.so}
