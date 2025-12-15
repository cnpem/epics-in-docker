#!/bin/sh

set -eux

if [ -z "$IOC_NAME" ]; then
    echo "ERROR: The environment variable IOC_NAME is not defined."
    exit 1
fi

# is used to create ioc directory.
${EPICS_BASE_PATH}/bin/linux-x86_64/makeBaseApp.pl -t ioc -p ${IOC_NAME} -u root ${IOC_NAME}
${EPICS_BASE_PATH}/bin/linux-x86_64/makeBaseApp.pl -i -t ioc -p ${IOC_NAME} -u root ${IOC_NAME}

# Create src/Makefile with database and libraries dependency.
MAKEFILE="${IOC_NAME}App/src/Makefile"

rm -f $MAKEFILE

echo "TOP=../..

include \$(TOP)/configure/CONFIG

PROD_IOC += $IOC_NAME
DBD += $IOC_NAME.dbd
" >> "$MAKEFILE"

for dbd in $IOC_DBD; do
    echo "\${PROD_IOC}_DBD += $dbd" >> "$MAKEFILE"
done

for lib in $IOC_LIB; do
    echo "\${PROD_IOC}_LIBS += $lib" >> "$MAKEFILE"
done

echo "
\${PROD_IOC}_SRCS += ${IOC_NAME}_registerRecordDeviceDriver.cpp
\${PROD_IOC}_SRCS_DEFAULT += ${IOC_NAME}Main.cpp

\${PROD_IOC}_LIBS += \$(EPICS_BASE_IOC_LIBS)

include \$(TOP)/configure/RULES
" >> "$MAKEFILE"

# Create database file in Db/Makefile
MAKEFILE="${IOC_NAME}App/Db/Makefile"

rm -f $MAKEFILE

echo "TOP=../..

include \$(TOP)/configure/CONFIG
" >> "$MAKEFILE"

for db in $IOC_DB; do
    echo "DB_INSTALLS += $db" >> "$MAKEFILE"
done

echo "
include \$(TOP)/configure/RULES
" >> "$MAKEFILE"

# Copy command file
for cmd in $IOC_CMD; do
    cp $cmd iocBoot/ioc$IOC_NAME
done
