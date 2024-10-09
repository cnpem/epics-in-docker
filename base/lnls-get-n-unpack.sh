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

shacheck() {

    download_dir=$1
    sha=$2
    url=$3

    downloaded_file=$(find $download_dir -type f)
    if [[ $(echo $downloaded_file | wc -w) -ne 1 ]]; then
        echo "ERROR: Download of $url is yielding something different than one single file."
        echo "Don't know how to proceed. Exiting..."
        exit 1
    fi

    if ! echo $sha $downloaded_file | sha256sum -c; then
        echo "ERROR: SHA $sha for URL $url does not match."
        exit 1
    fi

}

download () {

    shift # Throw extraction mode argument away

    while [[ $# -gt 1 ]]; do
    url=$1
    sha=$2
    download_dir=$(mktemp -d)

    echo Downloading "$url"...
    wget -P $download_dir "$url" &> /tmp/wget.log || (cat /tmp/wget.log && false)

    filename=$(basename $download_dir/*)
    shacheck $download_dir $sha $url

    if [[ ${filename,,} == *".zip" ]]; then
        unzip -qo $download_dir/$filename -d $dest
    else
        tar --no-same-owner -xf $download_dir/$filename -C $dest
    fi

    rm -rf $download_dir /tmp/wget.log

    shift 2
    done

}

check_arguments ${@}
download ${@}