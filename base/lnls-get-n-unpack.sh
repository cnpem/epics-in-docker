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
    echo "  Reference sha256 hash to compare url download with."
    exit $1
}

parse_arguments() {
    if [ "$#" -eq 0 ]; then
        help
    fi

    # Check extraction mode
    case "$1" in
        -r) dest=/ ;;
        -l) dest=. ;;
        *)
            echo >&2 "Invalid extraction mode: must be either root (-r) or local (-l)."
            exit 1
            ;;
    esac

    # Check if we have odd number of arguments (extraction_mode + N*url + N*sha256sum)
    if [ $(($# % 2)) -ne 1 ]; then
        echo >&2 "ERROR: Even number of arguments detected. Something is wrong."
        help 1
    fi

    # Throw extraction mode argument away
    shift
    echo "$dest $@"
}

shacheck() {
    downloaded_file=$1
    sha=$2
    url=$3

    if ! echo $sha $downloaded_file | sha256sum -c; then
        echo "ERROR: SHA $sha for URL $url does not match."
        exit 1
    fi
}

download() {
    dest=$1
    shift

    while [ $# -gt 1 ]; do
        url=$1
        sha=$2
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

        shift 2
    done
}

args=$(parse_arguments ${@})
download ${args}
