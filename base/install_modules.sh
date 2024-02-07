#!/usr/bin/env bash

set -ex

. /opt/epics/install-functions.sh

install_github_module mdavidsaver pvxs PVXS $PVXS_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}
"

# Build seq first since it doesn't depend on anything
lnls-get-n-unpack -l "https://static.erico.dev/seq-$SEQUENCER_VERSION.tar.gz"
mv seq-$SEQUENCER_VERSION seq
install_module seq SNCSEQ "
EPICS_BASE = ${EPICS_BASE_PATH}
"

install_github_module epics-modules calc CALC $CALC_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

SNCSEQ = ${EPICS_MODULES_PATH}/seq
"

# Build asyn without seq since it's only needed for testIPServer
install_github_module epics-modules asyn ASYN $ASYN_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

CALC = ${EPICS_MODULES_PATH}/calc
"

install_github_module paulscherrerinstitute StreamDevice STREAM $STREAMDEVICE_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

ASYN = ${EPICS_MODULES_PATH}/asyn
CALC = ${EPICS_MODULES_PATH}/calc
"

install_github_module epics-modules busy BUSY $BUSY_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

ASYN = ${EPICS_MODULES_PATH}/asyn
"

install_github_module epics-modules autosave AUTOSAVE $AUTOSAVE_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}
"

install_github_module epics-modules sscan SSCAN $SSCAN_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

SNCSEQ = ${EPICS_MODULES_PATH}/seq
"

download_github_module ChannelFinder recsync $RECCASTER_VERSION
install_module recsync/client RECCASTER "
EPICS_BASE = ${EPICS_BASE_PATH}
"

install_github_module epics-modules ipac IPAC $IPAC_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}
"

install_github_module epics-modules caPutLog CAPUTLOG $CAPUTLOG_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}
"

install_github_module brunoseivam retools RETOOLS $RETOOLS_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}
"
