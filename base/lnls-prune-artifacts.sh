#!/usr/bin/env bash

set -eu

target_paths=$@


get_used_epics_modules() {
    targets=$@

    executables=$(find $targets -type f -executable -print)
    libs="$(ldd $executables 2>/dev/null)"

    modules=()
    epics_libs=$(echo "$libs" | grep -oE "$EPICS_MODULES_PATH/.*/*.so")
    for lib in $epics_libs; do
        module=${lib%/lib/*/*lib*so}
        echo $module
    done | sort | uniq
}

get_all_epics_modules() {
    release_defs=$(cat ${EPICS_RELEASE_FILE} | grep = | cut -d'=' -f 2)

    modules="$(echo "$release_defs" | grep $EPICS_MODULES_PATH)"

    echo "$modules"
}

remove_static_libs() {
    for target; do
        libs=$(find $target -type f -name *.a -print)

        if [ -n "$libs" ]; then
            size=$(du -hsc $libs | tail -n 1 | cut -f 1)

            echo "Removing static libraries from $target ($size)"
            rm -f $libs
        fi
    done
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

remove_unused_epics_modules $target_paths
remove_static_libs /opt
