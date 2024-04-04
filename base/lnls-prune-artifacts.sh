#!/usr/bin/env bash

set -eu


get_used_epics_modules() {
    targets=$@

    executables=$(find $targets -type f -executable)

    # Depend on the glibc-specific behavior of supporting multiple executables
    # to be queried at once
    libs="$(ldd $executables 2>/dev/null)"

    epics_libs=$(echo "$libs" | grep -oE "$EPICS_MODULES_PATH/.*/*.so")

    for epics_lib in $epics_libs; do
        # Take module top directory by stripping out the default library
        # location lib/<archicture>/<library-name>
        echo ${epics_lib%/lib/*/*lib*so}
    done | sort -u
}

get_all_epics_modules() {
    release_defs=$(grep = ${EPICS_RELEASE_FILE} | cut -d'=' -f 2)

    echo "$release_defs" | grep $EPICS_MODULES_PATH
}

remove_unused_epics_modules() {
    targets=$@

    used_modules=$(get_used_epics_modules $targets)

    for module in $(get_all_epics_modules); do
        if [[ -d $module && ! $used_modules =~ "$module" ]]; then
            size=$(du -hs $module | cut -f 1)

            echo "Removing module '$module' ($size)..."
            rm -rf $module
        fi
    done
}

remove_unused_epics_modules $@
