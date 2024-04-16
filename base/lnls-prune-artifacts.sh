#!/usr/bin/env bash

set -Eeu

filter_out_paths() {
    list="$1"
    exclude_list="$2"

    for path in $exclude_list; do
        if [ "${path:0:1}" != "/" ]; then
            >&2 echo "error: filter_out_paths() expects absolute paths, but got '$path'"
            exit 1
        fi

        while [ "$path" != "/" ]; do
            list=$(echo "$list" | grep -xv $path)

            path=$(dirname $path)
        done
    done

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

find_shared_libs() {
    libs=$(find_elf_executables $@)

    echo "$libs" | grep -E "*.so(.[0-9]+)*$" | sort -u
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

prune_module_dirs() {
    module=$1

    keep_paths="
        $(find_shared_libs $module)
        $(find $module -type f -regex ".*\.\(db\|template\|req\)" -printf "%h\n" | sort -u)
    "

    while read -r candidate; do
        [ -d $candidate ] || continue

        if [[ ! $keep_paths =~ "$candidate".* ]]; then
            size=$(du -hs $candidate | cut -f 1)

            printf "Removing directory '$candidate' ($size)...\n"
            rm -rf $candidate
        fi
    done < <(find $module -type d)
}

clean_up_epics_modules() {
    targets=$@

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

    prune_dirs=$(filter_out_paths "$used_modules" "$targets")

    for dir in $prune_dirs; do
        echo "Pruning module '$dir'..."
        prune_module_dirs $dir
    done

    prune_module_dirs $EPICS_BASE_PATH
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
    target_libs=$(find_shared_libs $@)
    linked_libs=$(find_linked_libraries $@)
    remove_libs=$(find_shared_libs /opt /usr/local)

    for lib in $target_libs $linked_libs; do
        remove_libs=$(echo "$remove_libs" | grep -vx $lib)
    done

    for lib in $remove_libs; do
        size=$(du -hs $lib | cut -f 1)

        echo "Removing shared library '$lib' ($size)"
        rm -f ${lib%.so*}.so*
    done
}

clean_up_epics_modules $@
remove_static_libs /opt
remove_unused_shared_libs $@
