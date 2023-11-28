download_github_module() {
    github_org=$1
    module_name=$2
    commit=$3

    lnls-get-n-unpack -l https://github.com/$github_org/$module_name/archive/$commit.tar.gz

    mv $module_name-$commit $module_name
}

install_module() {
    module_name=$1
    dependency_name=$2
    release_content="$3"

    cd $module_name
    echo "$release_content" > configure/RELEASE

    make -j${JOBS} install
    make clean

    echo ${dependency_name}=${PWD} >> ${EPICS_RELEASE_FILE}

    cd -
}

# Install module from GitHub tagged versions or URL
install_github_module() {
    github_org=$1
    module_name=$2
    dependency_name=$3
    tag=$4
    release_content="$5"

    download_github_module $github_org $module_name $tag
    install_module $module_name $dependency_name "$release_content"
}
