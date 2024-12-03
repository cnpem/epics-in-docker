#!/bin/sh

set -eux

IOC=$1

echo "backing up configure/ files..."
# any of these files might not exist
cp -p configure/RELEASE /tmp || true
cp -p configure/CONFIG_SITE.local /tmp || true

restore_configure() {
  echo "restoring configure/ files..."

  # rm is necessary in case CONFIG_SITE.local didn't exist, otherwise
  # we might leave a file belonging to root around
  rm -f configure/CONFIG_SITE.local

  cp -p /tmp/RELEASE configure/ || true
  cp -p /tmp/CONFIG_SITE.local configure/ || true
}
trap restore_configure EXIT

echo "overwriting configure/ files..."
cp $EPICS_RELEASE_FILE configure/
cat << "EOF" > configure/CONFIG_SITE.local
STATIC_BUILD=YES
FULL_STATIC_BUILD=YES
USR_LDFLAGS = -static-pie
-include $(TOP)/configure/CONFIG_SITE.local.lnls-build-static-ioc
EOF

git config --global --add safe.directory $PWD

make_skip() {
  # :- is used so we don't error out if SKIP_CLEAN is undefined
  if [ -z "${SKIP_CLEAN:-}" ]; then
    make "$@"
  fi
}

make_skip distclean
make -j$(nproc)

version=$(git describe --tags)

echo $version > $IOC-version
cat << "EOF" > /tmp/globs
.git/
*.tar.gz
O.*/
EOF
# this trick is done so the resulting tarball has a root $IOC/ directory
(cd .. && tar caf $IOC/$IOC-${version}.tar.gz -X /tmp/globs $IOC/)
rm $IOC-version

make_skip distclean
