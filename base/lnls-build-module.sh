#!/bin/sh

set -ex

. $EPICS_IN_DOCKER/install-functions.sh

mkdir -p ${EPICS_MODULES_PATH}/${REPONAME}
mv * ${EPICS_MODULES_PATH}/${REPONAME}
install_module ${EPICS_MODULES_PATH}/${REPONAME} ${MODULE_NAME} "*"
