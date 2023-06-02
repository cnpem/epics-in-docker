#!/usr/bin/env bash

set -ex

install_module() {
    module_name=$1
    release_content="$2"

    cd $module_name
    echo "$release_content" > configure/RELEASE

    make -j${JOBS} install
    make clean

    cd -
}

# Install module from GitHub tagged versions or URL
install_github_module() {
    github_org=$1
    module_name=$2
    tag=$3
    release_content="$4"

    # Download release code
    wget https://github.com/$github_org/$module_name/archive/refs/tags/$tag.tar.gz
    tar -xf $tag.tar.gz
    rm $tag.tar.gz

    mv $module_name-$tag $module_name

    install_module $module_name "$release_content"
}

# Build seq first since it doesn't depend on anything
wget "http://www-csr.bessy.de/control/SoftDist/sequencer/releases/seq-$SEQUENCER_VERSION.tar.gz"
tar -xf seq-$SEQUENCER_VERSION.tar.gz
rm seq-$SEQUENCER_VERSION.tar.gz
mv seq-$SEQUENCER_VERSION seq
install_module seq "
EPICS_BASE = ${EPICS_BASE_PATH}
"

install_github_module epics-modules calc R${CALC_VERSION} "
EPICS_BASE = ${EPICS_BASE_PATH}

SEQ = ${EPICS_MODULES_PATH}/seq
"

# Build asyn without seq since it's only needed for testIPServer
install_github_module epics-modules asyn R$ASYN_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

CALC = ${EPICS_MODULES_PATH}/calc
"

install_github_module paulscherrerinstitute StreamDevice $STREAMDEVICE_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

ASYN = ${EPICS_MODULES_PATH}/asyn
CALC = ${EPICS_MODULES_PATH}/calc
"

install_github_module epics-modules autosave R$AUTOSAVE_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}
"
