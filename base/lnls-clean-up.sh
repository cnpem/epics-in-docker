#!/usr/bin/env bash

files=(
    /opt/epics-in-docker/install*sh
    /opt/epics-in-docker/*patch
    /usr/local/bin/lnls-*
    /usr/local/lib/cmake
    /usr/local/lib/pkgconfig
    /usr/local/*
)

keep_list=(
    /usr/local/bin/lnls-run
    /usr/local/bin
    /usr/local/sbin
    /usr/local/lib
    /usr/local/libexec
    /usr/local/etc
)

for file in ${files[@]}; do
    if ! printf "%s\n" "${keep_list[@]}" | grep -qx "$file" -; then
        rm -rv $file
    fi
done
