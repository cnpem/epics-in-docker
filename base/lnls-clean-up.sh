#!/usr/bin/env bash

scripts=(
    /opt/epics-in-docker/install*sh
    /opt/epics-in-docker/*patch
    /usr/local/bin/lnls-*
    $BASH_SOURCE
)

keep_list=(
    /usr/local/bin/lnls-run
)

for script in ${scripts[@]}; do
    if ! echo ${keep_list[@]} | grep -qx "$script" -; then
        rm $script
    fi
done
