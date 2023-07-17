#!/usr/bin/env bash

set -ex

git clone --depth 1 --branch ${AREA_DETECTOR_VERSION} \
    https://github.com/areaDetector/areaDetector

cd areaDetector

git submodule update --init --depth 1 -j ${JOBS} \
    ADSimDetector \
    ADSupport \
    ADCore

cd configure

module_releases="
AREA_DETECTOR=${EPICS_MODULES_PATH}/areaDetector
ADSIMDETECTOR=${EPICS_MODULES_PATH}/areaDetector/ADSimDetector
ADSUPPORT=${EPICS_MODULES_PATH}/areaDetector/ADSupport
ADCORE=${EPICS_MODULES_PATH}/areaDetector/ADCore
"

echo "$module_releases" >> ${EPICS_MODULES_PATH}/../RELEASE

echo "
EPICS_BASE=${EPICS_BASE_PATH}

$module_releases

ASYN=${EPICS_MODULES_PATH}/asyn
BUSY=${EPICS_MODULES_PATH}/busy
SSCAN=${EPICS_MODULES_PATH}/sscan
" > RELEASE.local

ln -s RELEASE.local RELEASE_PRODS.local
ln -s RELEASE.local RELEASE_LIBS.local

echo "
BUILD_IOCS=NO

WITH_BOOST=NO

WITH_PVA=YES
WITH_QSRV=YES

WITH_BLOSC=YES
BLOSC_EXTERNAL=NO

WITH_BITSHUFFLE=NO
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

XML2_EXTERNAL=YES
XML2_LIB=$(pkg-config --variable=libdir libxml-2.0)
XML2_INCLUDE=$(pkg-config --cflags-only-I libxml-2.0 | sed -e "s|-I||g")

WITH_ZLIB=YES
ZLIB_EXTERNAL=NO
" > CONFIG_SITE.local

cd -

git apply --directory ADSupport ${EPICS_MODULES_PATH}/nanohttp_stream.patch

make -j${JOBS}
make clean
