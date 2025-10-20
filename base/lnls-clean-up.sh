#!/usr/bin/env bash

files=(
    /opt/epics-in-docker/install*sh
    /opt/epics-in-docker/*patch
)

rm ${files[@]}
