#!/usr/bin/env bash

set -eu


filter_out_dirs() {
    list="$1"
    exclude_list="$2"

    for item in $exclude_list; do
        dir=$item

        while [ "$dir" != "/" ]; do
            list=$(echo "$list" | grep -xv $dir)

            dir=$(dirname $dir)
        done
    done

    echo "$list"
}

find_elf_executables() {
    targets=$@

    while read -r executable; do
        read -r -N 4 trailer < "$executable"

        # Output only ELF binaries
        if [ "$trailer" = $'\x7fELF' ]; then
            echo $executable
        fi
    done < <(find $targets -type f -executable)
}

find_linked_libraries() {
    executables=$(find_elf_executables $@)

    # Depend on the glibc-specific behavior of supporting multiple executables
    # to be queried at once
    linked=$(ldd $executables 2>/dev/null | grep '=>')

    # We grep out not found libraries, since they cannot be kept if we don't
    # know where they are.
    #
    # Final binary may be actually runnable, since rpath of another binary may
    # pull those not found libraries
    found="$(echo "$linked" | grep -v "not found")"

    # Get their full path
    libs=$(echo "$found"| cut -d'>' -f 2 | cut -d' ' -f 2)

    echo "$libs" | sort -u
}

get_used_epics_modules() {
    epics_libs=$(find_linked_libraries $@)
    modules=$(get_all_epics_modules)

    unused_modules=$(filter_out_dirs "$modules" "$epics_libs")

    filter_out_dirs "$modules" "$unused_modules"
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
    used_libs=$(find_linked_libraries $@)

    remove_libs=$(find_elf_executables /opt /usr/local)
    remove_libs=$(echo "$remove_libs" | grep -E "*.so(.[0-9]+)*$" | sort -u)

    for lib in $used_libs; do
        remove_libs=$(echo "$remove_libs" | grep -vx $lib)
    done

    for lib in $remove_libs; do
        size=$(du -hs $lib | cut -f 1)

        echo "Removing shared library '$lib' ($size)"
        rm -f ${lib%.so*}.so*
    done
}

remove_unused_epics_modules() {
    targets=$@

    unused_modules=$(get_all_epics_modules)
    used_modules=$(get_used_epics_modules $targets)

    keep_dirs="$targets $used_modules"

    for module in $(filter_out_dirs "$unused_modules" "$keep_dirs"); do
        # if we already removed it because of its top-level repository or
        # because it is an IOC, move on to the next.
        [ ! -d $module ] && continue

        size=$(du -hs $module | cut -f 1)

        echo "Removing module '$module' ($size)..."
        rm -rf $module
    done
}

remove_unused_epics_modules $@
remove_static_libs /opt
remove_unused_shared_libs $@
