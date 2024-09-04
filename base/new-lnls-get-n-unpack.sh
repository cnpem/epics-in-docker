#!/usr/bin/env bash
#
# Download and extract archive from the network.

set -eu

help () {
    echo    "lnls-get-n-unpack: download and extract archive from the network"
    echo -e "Usage: lnls-get-n-unpack <extraction_mode> <URL1> <1SHA256SUM> [URL2] [2SHA256SUM] [...] [URLN] [NSHA256SUM]\n"
    echo    "Extraction mode:"
    echo    "  -l extracts to local directory (./)"
    echo    "  -r extracts to root directory (/)"
    echo    "URL:"
    echo    "  url to download source from."
    echo    "SHA256SUM:"
    echo    "  Reference sha256 hash to compare url download with."
    exit $1;
}

check_arguments () {

    # No arguments = call help and exit.
    if [ -z ${1+nothing} ]; then
        help 0;
    fi

    # if -h is anywhere arguments list, call help and exit.
    for arg in "$@"; do
        if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
            help 0;
        fi
    done

    # Check extraction mode
    case "$1" in
        -r) dest=/ ;;
        -l) dest=. ;;
        *) >&2 echo "Invalid extraction mode: must be either root (-r) or local (-l)."
        exit 1;
        ;;
    esac

    # Check if we have odd number of arguments (extraction_mode + N*url + N*sha256sum)
    if [ $(( $# % 2 )) -ne 1 ]; then
        >&2 echo "ERROR: Even number of arguments detected. Something is wrong."
        help 1;
        exit 1
    fi

}

check_arguments ${@}