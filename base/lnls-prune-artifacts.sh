#!/usr/bin/env bash

set -Eeu

# Filter out from the $1 list of paths any exact match of a parent directory
# from any path in the $2 exclude list.
#
# Both lists are treated as newline-separated strings, and must consist
# exclusively of absolute paths (except for empty lines which are ignored).
filter_out_paths() {
    list=$(echo "$1" | grep -v '^$')
    exclude_list=$(echo "$2" | grep -v '^$')

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

# Output the set $1 difference to another set $2
compute_set_difference() {
    sort $1 $2 $2 | uniq -u
}

find_elf_executables() {
    targets=$@

    # Loop on entire lines to properly handle filenames with spaces
    while read -r file; do
        read -r -N 4 magic < "$file"

        # Output only ELF binaries
        if [ "$magic" = $'\x7fELF' ]; then
            echo $file
        fi
    done < <(find $targets -type f)
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

    echo $EPICS_BASE_PATH
}

get_used_epics_modules() {
    linked_libs=$(find_linked_libraries $@)
    all_modules=$(get_all_epics_modules)

    unused_modules=$(filter_out_paths "$all_modules" "$linked_libs")

    compute_set_difference <(echo "$all_modules") <(echo "$unused_modules")
}

# Traverse ancestor directories of each provided path, and concatenate all
# their .lnls-keep-paths defined entries as absolute paths.
get_defined_paths_to_keep() {
    for path; do
        if [ "${path:0:1}" != "/" ]; then
            >&2 echo "error: get_defined_paths_to_keep() expects absolute paths, but got '$path'"
            exit 1
        fi

        while true; do
            keep_path_file="$path/.lnls-keep-paths"

            if [ -f "$keep_path_file" ]; then
                keep_paths=$(cat "$keep_path_file")

                for keep_path in $keep_paths; do
                    # output it as an absolute path
                    realpath "$path"/$keep_path
                done
            fi

            [ "$path" == "/" ] && break

            path=$(dirname $path)
        done
    done | sort -u
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
$(get_defined_paths_to_keep $module)
EOF
    )

    prune_directories "$module_dirs" "$keep_paths"
}

clean_up_epics_modules() {
    targets=$(echo $@ | sed -E "s|\s+|\n|g")

    all_modules=$(get_all_epics_modules)
    used_modules=$(get_used_epics_modules $targets)
    cat << EOF
===
Used EPICS modules
===
$used_modules
===
EOF

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

    keep_paths="$target_libs $linked_libs"
    keep_paths="$keep_paths $(get_defined_paths_to_keep $remove_libs)"

    for lib in $remove_libs; do
        size=$(du -hs $lib | cut -f 1)

        # if library is not found inside any $keep_paths, remove it
        if find $keep_paths -path "$lib" -exec false {} + 2> /dev/null; then
            echo "Removing shared library '$lib' ($size)..."

            rm -f ${lib%.so*}.so*
        else
            echo "Keeping shared library '$lib' ($size)..."
        fi
    done
}

clean_up_epics_modules $@
remove_static_libraries /opt /usr/local
remove_unused_shared_libraries $@
