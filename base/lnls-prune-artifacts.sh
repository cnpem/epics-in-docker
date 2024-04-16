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

find_shared_libraries() {
    elf_files=$(find_elf_executables $@)

    echo "$elf_files" | grep -E "\.so(.[0-9]+)*$" | sort -u
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

prune_directories() {
    local targets="$1"
    local keep_paths="$2"

    remove_dirs=$(filter_out_paths "$targets" "$keep_paths")

    while read -r remove_dir; do
        # if we already removed it because of its parent directory, move on to
        # the next.
        [ ! -d "$remove_dir" ] && continue

        size=$(du -hs "$remove_dir" | cut -f 1)

        echo "Removing directory '$remove_dir' ($size)..."
        rm -rf "$remove_dir"
    done <<< "$remove_dirs"
}

prune_module_directories() {
    module=$1

    module_dirs=$(find $module -type d)
    keep_paths=$(cat << EOF
$(find_shared_libraries $module)
$(find $module -type f -regex ".*\.\(cmd\|db\|template\|req\|substitutions\)" -printf "%h\n" | sort -u)
EOF
    )

    prune_directories "$module_dirs" "$keep_paths"
}

clean_up_epics_modules() {
    targets=$(echo $@ | sed -E "s|\s+|\n|g")

    all_modules=$(get_all_epics_modules)
    used_modules=$(get_used_epics_modules $targets)

    keep_paths=$(printf "$targets\n$used_modules")
    prune_directories "$all_modules" "$keep_paths"

    # Filter out targets to provide a way to disable module pruning in special
    # cases
    prune_dirs=$(filter_out_paths "$used_modules" "$targets")

    for dir in $prune_dirs; do
        echo "Pruning module '$dir'..."
        prune_module_directories $dir
    done
}

remove_static_libraries() {
    for target; do
        libs=$(find $target -type f -name *.a)

        if [ -n "$libs" ]; then
            size=$(du -hsc $libs | tail -n 1 | cut -f 1)

            echo "Removing static libraries from $target ($size)"
            rm -f $libs
        fi
    done
}

remove_unused_shared_libraries() {
    target_libs=$(find_shared_libraries $@)
    linked_libs=$(find_linked_libraries $@)
    remove_libs=$(find_shared_libraries /opt /usr/local)

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
remove_static_libraries /opt /usr/local
remove_unused_shared_libraries $@
