#!/usr/bin/env bash

set -Eeu

# Filter out from the $1 list of paths any exact match of a parent directory
# from any path in the $2 exclude list.
#
# Both list are treated as newline-separated strings, and must consist
# exclusively of absolute paths.
filter_out_paths() {
    list="$1"
    exclude_list="$2"

    while read -r path; do
        if [ "${path:0:1}" != "/" ]; then
            >&2 echo "error: filter_out_paths() expects absolute paths, but got '$path'"
            exit 1
        fi

        while [ "$path" != "/" ]; do
            list=$(echo "$list" | grep -xv "$path")

            path=$(dirname "$path")
        done
    done <<< "$exclude_list"

    echo "$list"
}

find_elf_executables() {
    targets=$@

    # Loop on entire lines to properly handle filenames with spaces
    while read -r executable; do
        read -r -N 4 magic < "$executable"

        # Output only ELF binaries
        if [ "$magic" = $'\x7fELF' ]; then
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
    # pull those not-found libraries
    found="$(echo "$linked" | grep -v "not found")"

    # Get their full path
    libs=$(echo "$found" | cut -d' ' -f 3)

    echo "$libs" | sort -u
}

get_all_epics_modules() {
    release_defs=$(grep = ${EPICS_RELEASE_FILE} | cut -d'=' -f 2)

    echo "$release_defs" | grep $EPICS_MODULES_PATH
}

get_used_epics_modules() {
    linked_libs=$(find_linked_libraries $@)
    all_modules=$(get_all_epics_modules)

    unused_modules=$(filter_out_paths "$all_modules" "$linked_libs")

    filter_out_paths "$all_modules" "$unused_modules"
}

remove_unused_epics_modules() {
    targets=$(echo $@ | sed -E "s|\s+|\n|g")

    all_modules=$(get_all_epics_modules)
    used_modules=$(get_used_epics_modules $targets)

    keep_dirs="$targets $used_modules"
    unused_modules=$(filter_out_paths "$all_modules" "$keep_dirs")

    # Assume module paths do not contain spaces, as we mostly control them
    for module in $unused_modules; do
        # if we already removed it because of its top-level repository or
        # because it is an IOC, move on to the next.
        [ ! -d $module ] && continue

        size=$(du -hs $module | cut -f 1)

        echo "Removing module '$module' ($size)..."
        rm -rf $module
    done
}

remove_unused_epics_modules $@