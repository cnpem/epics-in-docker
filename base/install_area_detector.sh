#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/area_detector_versions.sh

git clone --depth 1 --branch ${AREA_DETECTOR_VERSION} \
    https://github.com/areaDetector/areaDetector

cd areaDetector

git submodule update --init --depth 1 -j ${JOBS} \
    ADAravis \
    ADGenICam \
    ADSimDetector \
    ADSupport \
    ADCore

rm -rf .git

echo 'ADSupport/lib/linux*/libHDF5*plugin.so' > .lnls-keep-paths

cd configure

module_releases="
AREA_DETECTOR=${EPICS_MODULES_PATH}/areaDetector
ADARAVIS=${EPICS_MODULES_PATH}/areaDetector/ADAravis
ADGENICAM=${EPICS_MODULES_PATH}/areaDetector/ADGenICam
ADSIMDETECTOR=${EPICS_MODULES_PATH}/areaDetector/ADSimDetector
ADSUPPORT=${EPICS_MODULES_PATH}/areaDetector/ADSupport
ADCORE=${EPICS_MODULES_PATH}/areaDetector/ADCore
"

echo "$module_releases" >> ${EPICS_RELEASE_FILE}

get_module_path "
EPICS_BASE
ASYN
BUSY
SSCAN
" > RELEASE.local
echo "$module_releases" >> RELEASE.local

ln -s RELEASE.local RELEASE_PRODS.local
ln -s RELEASE.local RELEASE_LIBS.local

echo "
BUILD_IOCS=NO

WITH_BOOST=NO

WITH_PVA=YES
WITH_QSRV=YES

WITH_BLOSC=YES
BLOSC_EXTERNAL=NO

WITH_BITSHUFFLE=YES
BITSHUFFLE_EXTERNAL=NO

WITH_GRAPHICSMAGICK=NO

WITH_HDF5=YES
HDF5_EXTERNAL=NO

WITH_JSON=YES
JSON_EXTERNAL=NO

WITH_JPEG=YES
JPEG_EXTERNAL=NO

WITH_NETCDF=YES
NETCDF_EXTERNAL=NO

WITH_NEXUS=YES
NEXUS_EXTERNAL=NO

WITH_OPENCV=NO

WITH_SZIP=YES
SZIP_EXTERNAL=NO

WITH_TIFF=YES
TIFF_EXTERNAL=YES
TIFF_LIB=$(pkg-config --variable=libdir libtiff-4)
TIFF_INCLUDE=$(pkg-config --cflags-only-I libtiff-4 | sed -e "s|-I||g")

XML2_EXTERNAL=YES
XML2_LIB=$(pkg-config --variable=libdir libxml-2.0)
XML2_INCLUDE=$(pkg-config --cflags-only-I libxml-2.0 | sed -e "s|-I||g")

WITH_ZLIB=YES
ZLIB_EXTERNAL=NO

GLIB_INCLUDE=$(pkg-config --cflags-only-I glib-2.0 | sed -e "s|-I||g")
ARAVIS_INCLUDE=$(pkg-config --cflags-only-I aravis-0.8 | sed -e "s|-I||g")
" > CONFIG_SITE.local

cd -

make -j${JOBS}
make clean

cd ..

download_from_github cnpem ssc-pimega $LIBSSCPIMEGA_VERSION $LIBSSCPIMEGA_SHA256
make -C ssc-pimega/c install
rm -rf ssc-pimega

install_from_github cnpem NDSSCPimega NDSSCPIMEGA $NDSSCPIMEGA_VERSION $NDSSCPIMEGA_SHA256 "
EPICS_BASE
ASYN
AREA_DETECTOR
ADCORE
"
