#!/usr/bin/env bash
#
# Download and extract tarball archive from the network.

set -eu

case "$1" in
    -r) dest=/ ;;
    -l) dest=. ;;
    *) >&2 echo "Invalid extraction mode: must be either root (-r) or local (-l)."
       exit 1;
    ;;
esac

shift

for url; do
    download_dir=$(mktemp -d)

    echo Downloading "$url"...
    wget -P $download_dir -o /tmp/wget.log "$url" || (cat /tmp/wget.log && false)
    tar --no-same-owner -xf $download_dir/* -C $dest
    rm -rf $download_dir /tmp/wget.log
done
