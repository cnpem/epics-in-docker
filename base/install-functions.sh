if [ "$JOBS" -eq "-1" ]; then
    JOBS=$(nproc)
    echo "Setting JOBS to $JOBS" >&2
fi

get_module_path() {
    for module in $@; do
        if [ -n "$module" ]; then
            grep -E "^$module=" $EPICS_RELEASE_FILE
        fi
    done
}

download_from_github() {
    github_org=$1
    module_name=$2
    commit=$3
    sha=$4

    lnls-get-n-unpack -l https://github.com/$github_org/$module_name/archive/$commit.tar.gz $sha

    # GitHub tarballs for tags starting with 'v' don't include that 'v'
    commit=${commit#v}
    mv $module_name-$commit $module_name
}

install_module() {
    is_ioc=false
    if [ "$1" = "-i" ]; then
        is_ioc=true
        shift
    fi

    module_name=$1
    dependency_name=$2
    release_modules="$3"

    cd $module_name

    echo ${dependency_name}=${PWD} >> ${EPICS_RELEASE_FILE}

    get_module_path "$release_modules" > configure/RELEASE

    if [ -n "$NEEDS_TIRPC" ]; then
        echo "TIRPC=YES" >> configure/CONFIG_SITE
    fi

    make -j${JOBS} install
    make clean
    if $is_ioc; then
        make -C iocBoot
    fi

    cd -
}

# Install module from GitHub tagged versions or URL
install_from_github() {
    flag_ioc=""
    if [ "$1" = "-i" ]; then
        flag_ioc=$1
        shift
    fi

    github_org=$1
    module_name=$2
    dependency_name=$3
    tag=$4
    sha=$5
    release_content="$6"

    download_from_github $github_org $module_name $tag $sha
    install_module $flag_ioc $module_name $dependency_name "$release_content"
}
