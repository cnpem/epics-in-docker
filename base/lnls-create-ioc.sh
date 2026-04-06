#!/bin/sh

set -eux

IOC_NAME="$REPONAME"

for var in IOC_DBDS IOC_LIBS; do
    eval value=\${$var-}
    if [ -z "$value" ]; then
        echo "ERROR: Environment variable $var is not defined."
        exit 1
    fi
done

INITIAL_FILES=$(ls -A)

# Use makeBaseApp to create IOC directory structure
${EPICS_BASE_PATH}/bin/linux-x86_64/makeBaseApp.pl -t ioc -p ${IOC_NAME} -u root ${IOC_NAME}
${EPICS_BASE_PATH}/bin/linux-x86_64/makeBaseApp.pl -i -t ioc -p ${IOC_NAME} -u root ${IOC_NAME}

# Modify src/Makefile with database and libraries dependency.
MAKEFILE="${IOC_NAME}App/src/Makefile"

echo "TOP=../..

include \${TOP}/configure/CONFIG
include \${PYDEVSUP}/configure/CONFIG_PY

PROD_NAME += $IOC_NAME
PROD_IOC += \${PROD_NAME}

DBD += \${PROD_NAME}.dbd

\${PROD_NAME}_DBD += base.dbd
" > "$MAKEFILE"

for dbd in $IOC_DBDS; do
    echo "\${PROD_NAME}_DBD += $dbd" >> "$MAKEFILE"
done

echo "
\${PROD_NAME}_DBD += pvxsIoc.dbd
\${PROD_NAME}_DBD += reccaster.dbd
\${PROD_NAME}_DBD += asSupport.dbd
\${PROD_NAME}_DBD += caPutJsonLog.dbd
\${PROD_NAME}_DBD += devIocStats.dbd
\${PROD_NAME}_DBD += retools.dbd
\${PROD_NAME}_LIBS += pvxsIoc
\${PROD_NAME}_LIBS += reccaster
\${PROD_NAME}_LIBS += autosave
\${PROD_NAME}_LIBS += caPutLog
\${PROD_NAME}_LIBS += devIocStats
\${PROD_NAME}_LIBS += retools
" >> "$MAKEFILE"

for lib in $IOC_LIBS; do
    echo "\${PROD_NAME}_LIBS += $lib" >> "$MAKEFILE"
done

echo "
\${PROD_NAME}_SRCS += \${PROD_NAME}_registerRecordDeviceDriver.cpp
\${PROD_NAME}_SRCS_DEFAULT += \${PROD_NAME}Main.cpp
" >> "$MAKEFILE"

if [ "${IS_IOC_AREADETECTOR:-false}" = "true" ]; then
    echo "include \${ADCORE}/ADApp/commonDriverMakefile" >> "$MAKEFILE"
fi

echo "
\${PROD_NAME}_LIBS += \${EPICS_BASE_IOC_LIBS}

include \${TOP}/configure/RULES
" >> "$MAKEFILE"

# Modify database file in Db/Makefile
if [ -n "${IOC_DBS:-}" ]; then
    MAKEFILE="${IOC_NAME}App/Db/Makefile"

    echo "TOP=../..

    include \${TOP}/configure/CONFIG
    " > "$MAKEFILE"

    for db in $IOC_DBS; do
        echo "DB_INSTALLS += $db" >> "$MAKEFILE"
    done

    echo "
    include \${TOP}/configure/RULES
    " >> "$MAKEFILE"
fi

# Copy command file(s) or directory(ies)
if [ -n "${IOC_CMDS:-}" ]; then
    for cmd in $IOC_CMDS; do
        cp -r "$cmd" "iocBoot/ioc$IOC_NAME"
    done
fi

# Cleaning files copied during initialization
for f in $INITIAL_FILES; do
    rm -rf -- "$f"
done
