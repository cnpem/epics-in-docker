#!/usr/bin/env bash

set -ex

install_module() {
    module_name=$1
    dependency_name=$2
    release_content="$3"

    cd $module_name
    echo "$release_content" > configure/RELEASE

    make -j${JOBS} install
    make clean

    cd -

    echo ${dependency_name}=${EPICS_MODULES_PATH}/${module_name} >> ${EPICS_MODULES_PATH}/../RELEASE
}

# Install module from GitHub tagged versions or URL
install_github_module() {
    github_org=$1
    module_name=$2
    dependency_name=$3
    tag=$4
    release_content="$5"

    # Download release code
    wget https://github.com/$github_org/$module_name/archive/refs/tags/$tag.tar.gz
    tar -xf $tag.tar.gz
    rm $tag.tar.gz

    mv $module_name-$tag $module_name

    install_module $module_name $dependency_name "$release_content"
}

echo EPICS_BASE=${EPICS_BASE_PATH} > ${EPICS_MODULES_PATH}/../RELEASE

# Build seq first since it doesn't depend on anything
wget "http://www-csr.bessy.de/control/SoftDist/sequencer/releases/seq-$SEQUENCER_VERSION.tar.gz"
tar -xf seq-$SEQUENCER_VERSION.tar.gz
rm seq-$SEQUENCER_VERSION.tar.gz
mv seq-$SEQUENCER_VERSION seq
install_module seq SNCSEQ "
EPICS_BASE = ${EPICS_BASE_PATH}
"

install_github_module epics-modules calc CALC $CALC_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}

SEQ = ${EPICS_MODULES_PATH}/seq
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

install_github_module epics-modules autosave AUTOSAVE $AUTOSAVE_VERSION "
EPICS_BASE = ${EPICS_BASE_PATH}
"
