#!/usr/bin/env bash
#
# Download and extract archive from the network.

set -eu

help () {
    echo    "lnls-get-n-unpack: download and extract archive from the network"
    echo -e "Usage: lnls-get-n-unpack <extraction_mode> <URL1> [URL2] [...] [URLN]\n"
    echo    "Extraction mode:"
    echo    "  -l extracts to local directory (./)"
    echo    "  -r extracts to root directory (/)"
    echo    "URL:"
    echo    "  url to download source from."
    exit 0
}

check_arguments() {

    # No arguments = call help and exit.
    if [ "$#" -eq 0 ]; then
        help
    fi

    # if -h is anywhere arguments list, call help and exit.
    for arg in "$@"; do
        if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
            help
        fi
    done

    case "$1" in
        -r) dest=/ ;;
        -l) dest=. ;;
        *) >&2 echo "Invalid extraction mode: must be either root (-r) or local (-l)."
        exit 1
        ;;
    esac

}

download () {

    shift # Throw extraction mode argument away

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

check_arguments ${@}
download ${@}
