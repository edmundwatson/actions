#!/bin/bash

set -e
lsb_release -a

NR_CPUS=$(nproc)

cd /github/workspace
ls

./bootstrap
./configure

make -j ${NR_CPUS}

make check
TESTS_OK=$?

exit ${TESTS_OK}