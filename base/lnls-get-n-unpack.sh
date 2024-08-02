#!/usr/bin/env bash
#
# Download and extract archive from the network.

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
    wget -P $download_dir "$url" &> /tmp/wget.log || (cat /tmp/wget.log && false)

    filename=$(basename $download_dir/*)

    if [[ ${filename,,} == *".zip" ]]; then
        unzip -qo $download_dir/$filename -d $dest
    else
        tar --no-same-owner -xf $download_dir/$filename -C $dest
    fi

    rm -rf $download_dir /tmp/wget.log
done
