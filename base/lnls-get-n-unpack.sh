#!/usr/bin/env bash
#
# Download and extract archive from the network.

set -eu

help() {
    echo "lnls-get-n-unpack: download and extract archive from the network"
    echo -e "Usage: lnls-get-n-unpack <extraction_mode> <URL1> [<URL2>...]\n"
    echo "Extraction mode:"
    echo "  -l extracts to local directory (./)"
    echo "  -r extracts to root directory (/)"
    echo "URL:"
    echo "  url to download source from."
    exit 0
}

parse_arguments() {
    if [ "$#" -eq 0 ]; then
        help
    fi

    case "$1" in
        -r) dest=/ ;;
        -l) dest=. ;;
        *)
            echo >&2 "Invalid extraction mode: must be either root (-r) or local (-l)."
            exit 1
            ;;
    esac

    # Throw extraction mode argument away
    shift
    echo "$dest $@"
}

download() {
    dest=$1
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
}

args=$(parse_arguments ${@})
download ${args}
