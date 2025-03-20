#!/bin/sh

set -eux

make distclean
make -j ${JOBS}

if [ "$SKIP_TESTS" != 1 ]; then
  make runtests
fi

make clean

make -C ${RUNDIR}

rm -rf .git/
