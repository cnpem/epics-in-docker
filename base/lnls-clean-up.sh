#!/usr/bin/env bash

files=(
    /opt/epics-in-docker/install*sh
    /opt/epics-in-docker/*patch
    /usr/local/bin/lnls-*
)

keep_list=(
    /usr/local/bin/lnls-run
)

for file in ${files[@]}; do
    if ! echo ${keep_list[@]} | grep -qx "$file" -; then
        rm $file
    fi
done
