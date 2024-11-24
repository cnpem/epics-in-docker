#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/epics_versions.sh
. $EPICS_IN_DOCKER/opcua_versions.sh

opcua_release_url=https://github.com/epics-modules/opcua/releases/download/v${OPCUA_VERSION}
opcua_release_file=BDIST_opcua-${OPCUA_VERSION}_Base-${EPICS_BASE_VERSION}_debian${DEBIAN_VERSION%.*}.tar.gz
lnls-get-n-unpack -l $opcua_release_url/$opcua_release_file $OPCUA_SHA256
rm HOW_TO.md

mv opcuaBinaryDist opcua-module
install_module opcua-module OPCUA "
EPICS_BASE
"

mv opcuaExampleIoc opcua
install_module -i opcua OPCUA_IOC "
EPICS_BASE
OPCUA
"
