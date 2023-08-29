#!/usr/bin/env bash

set -ex

. /opt/epics/install-functions.sh

install_github_module mdavidsaver pvxs PVXS $PVXS_VERSION "
EPICS_BASE
"

install_github_module epics-modules sequencer SNCSEQ $SEQUENCER_VERSION "
EPICS_BASE
"

install_github_module epics-modules calc CALC $CALC_VERSION "
EPICS_BASE
SNCSEQ
"

# Build asyn without seq since it's only needed for testIPServer
install_github_module epics-modules asyn ASYN $ASYN_VERSION "
EPICS_BASE
CALC
"

install_github_module paulscherrerinstitute StreamDevice STREAM $STREAMDEVICE_VERSION "
EPICS_BASE
ASYN
CALC
"

install_github_module epics-modules busy BUSY $BUSY_VERSION "
EPICS_BASE
ASYN
"

install_github_module epics-modules autosave AUTOSAVE $AUTOSAVE_VERSION "
EPICS_BASE
"

install_github_module epics-modules sscan SSCAN $SSCAN_VERSION "
EPICS_BASE
SNCSEQ
"

download_github_module ChannelFinder recsync $RECCASTER_VERSION
install_module recsync/client RECCASTER "
EPICS_BASE
"

install_github_module epics-modules ipac IPAC $IPAC_VERSION "
EPICS_BASE
"

install_github_module epics-modules caPutLog CAPUTLOG $CAPUTLOG_VERSION "
EPICS_BASE
"

install_github_module brunoseivam retools RETOOLS $RETOOLS_VERSION "
EPICS_BASE
"
