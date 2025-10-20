#!/usr/bin/env bash

scripts=(
    /opt/epics-in-docker/install*sh
    /opt/epics-in-docker/*patch
)

rm ${scripts[@]}
