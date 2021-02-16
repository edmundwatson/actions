#!/bin/bash

set -e
lsb_release -a
cd /github/workspace
git clean -xdf && git submodule foreach git clean -xdf

rm -rf /github/build-HeartWare
mkdir -p /github/build-HeartWare
cd /github/build-HeartWare

/opt/qt5/bin/qmake  /github/workspace
make -j $(nproc)
QT_QPA_PLATFORM=offscreen make check -k -j1
