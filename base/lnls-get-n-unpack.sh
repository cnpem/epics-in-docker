#!/usr/bin/env bash
#
# Download and extract archive from the network.

set -eu

help() {
    echo "lnls-get-n-unpack: download and extract archive from the network"
    echo -e "Usage: lnls-get-n-unpack <extraction_mode> <URL1> <SHA256SUM1> [<URL2> <SHA256SUM2> ...]\n"
    echo "Extraction mode:"
    echo "  -l extracts to local directory (./)"
    echo "  -r extracts to root directory (/)"
    echo "URL:"
    echo "  url to download source from."
    echo "SHA256SUM:"
    echo "  expected sha256sum of downloaded content."
    exit ${1:-0}
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
            help 1
            ;;
    esac

    # Throw extraction mode argument away
    shift

    # Check if we have an even number of arguments (N * (url + sha256sum))
    if [ $(($# % 2)) -ne 0 ]; then
        echo >&2 "ERROR: mismatched number of URL and hash arguments."
        help 1
    fi

    echo "$dest $@"
}

shacheck() {
    downloaded_file=$1
    sha=$2
    url=$3

    if ! echo $sha $downloaded_file | sha256sum -c; then
        computed=$(sha256sum $downloaded_file | cut -d ' ' -f 1)
        echo >&2 "ERROR: checksum mismatch for '$url': expected '$sha', computed '$computed'."
        exit 1
    fi
}

download() {
    dest=$1
    shift

    while [ $# -gt 1 ]; do
        url=$1
        sha=$2
        shift 2

        download_dir=$(mktemp -d)
        echo Downloading "$url"...
        wget -P $download_dir "$url" &> /tmp/wget.log || (cat /tmp/wget.log && false)
        filename=$(basename $download_dir/*)

        shacheck $download_dir/$filename $sha $url

        if [[ ${filename,,} == *".zip" ]]; then
            unzip -qo $download_dir/$filename -d $dest
        else
            tar --no-same-owner -xf $download_dir/$filename -C $dest
        fi

        rm -rf $download_dir /tmp/wget.log
    done
}

args=$(parse_arguments $@)
download $args
