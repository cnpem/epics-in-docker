#!/usr/bin/env bash

set -ex

. $EPICS_IN_DOCKER/install-functions.sh
. $EPICS_IN_DOCKER/area_detector_versions.sh

download_from_github areaDetector areaDetector \
    ${AREA_DETECTOR_VERSION} ${AREA_DETECTOR_SHA256}

cd areaDetector

download_from_github areaDetector ADAravis ${ADARAVIS_VERSION} ${ADARAVIS_SHA256}

download_from_github areaDetector ADGenICam ${ADGENICAM_VERSION} ${ADGENICAM_SHA256}

download_from_github areaDetector ADSimDetector \
    ${ADSIMDETECTOR_VERSION} ${ADSIMDETECTOR_SHA256}

download_from_github areaDetector ADSupport ${ADSUPPORT_VERSION} ${ADSUPPORT_SHA256}

download_from_github areaDetector ADCore ${ADCORE_VERSION} ${ADCORE_SHA256}

download_from_github areaDetector ADEiger $ADEIGER_VERSION $ADEIGER_SHA256
patch -d ADEiger -Np1 < ${EPICS_IN_DOCKER}/adeiger-remove-lz4.patch
patch -d ADEiger -Np1 < ${EPICS_IN_DOCKER}/adeiger-stream2-ub.patch
patch -d ADEiger -Np1 < ${EPICS_IN_DOCKER}/adeiger-fix-tmexternal.patch

echo 'ADSupport/lib/linux*/libHDF5*plugin.so' > .lnls-keep-paths

cd configure

module_releases="
AREA_DETECTOR=${EPICS_MODULES_PATH}/areaDetector
ADARAVIS=${EPICS_MODULES_PATH}/areaDetector/ADAravis
ADEIGER=${EPICS_MODULES_PATH}/areaDetector/ADEiger
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

WITH_BOOST=YES
BOOST_EXTERNAL=YES

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

(
    cd $(mktemp -d)
    ${EPICS_MODULES_PATH}/areaDetector/ADCore/bin/*/plugin-test
    rm -rf $PWD
)

cd ..

install_from_github epics-modules xspress3 XSPRESS3 $XSPRESS3_VERSION $XSPRESS3_SHA256 "
EPICS_BASE
ASYN
AREA_DETECTOR
ADSUPPORT
ADCORE
"
