#!/usr/bin/env bash

set -eu


get_linked_libraries() {
    targets=$@

    executables=$(find $targets -type f -executable)

    # Depend on the glibc-specific behavior of supporting multiple executables
    # to be queried at once
    libs="$(ldd $executables 2>/dev/null | grep '=>' | cut -d'=' -f 1)"

    for lib in $libs; do
        # Strip version from soname so that we match any version of the library
        # in use
        echo ${lib%.so*}.so
    done | sort -u
}

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

remove_static_libs() {
    for target; do
        libs=$(find $target -type f -name *.a)

        if [ -n "$libs" ]; then
            size=$(du -hsc $libs | tail -n 1 | cut -f 1)

            echo "Removing static libraries from $target ($size)"
            rm -f $libs
        fi
    done
}

remove_unused_shared_libs() {
    targets=$@

    used_libs=$(get_linked_libraries $targets)

    remove_libs=$(find /opt /usr/local -type f -executable -name *.so*)
    remove_libs=$(echo "$remove_libs" | grep -E "*.so(.[0-9]+)*$" | sort -u)

    for lib in $used_libs; do
        remove_libs=$(echo "$remove_libs" | grep -v $lib)
    done

    for lib in $remove_libs; do
        size=$(du -hs $lib | cut -f 1)

        echo "Removing shared library '$lib' ($size)"
        rm -f $lib
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

remove_unused_epics_modules $@
remove_static_libs /opt
remove_unused_shared_libs $@
