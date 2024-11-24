#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/cagateway_versions.sh

install_from_github epics-modules pcas PCAS $PCAS_VERSION $PCAS_SHA256 "
EPICS_BASE
"

install_from_github epics-extensions ca-gateway CA_GATEWAY $CA_GATEWAY_VERSION $CA_GATEWAY_SHA256 "
EPICS_BASE
PCAS
CAPUTLOG
"
