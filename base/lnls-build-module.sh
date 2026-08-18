#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh

mkdir -p ${EPICS_MODULES_PATH}/${REPONAME}
(
    shopt -s dotglob
    mv * ${EPICS_MODULES_PATH}/${REPONAME}
)
install_module ${EPICS_MODULES_PATH}/${REPONAME} ${MODULE_NAME} "*"
