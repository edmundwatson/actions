#!/bin/bash

set -e
lsb_release -a
cd /jenkins/workspace/BIO-X/HeartWare
git clean -xdf && git submodule foreach git clean -xdf

rm -rf /jenkins/workspace/BIO-X/build-HeartWare2
mkdir -p /jenkins/workspace/BIO-X/build-HeartWare2
cd /jenkins/workspace/BIO-X/build-HeartWare2

/opt/qt5/bin/qmake /jenkins/workspace/BIO-X/HeartWare
make -j $(nproc)
QT_QPA_PLATFORM=offscreen make check -k -j1
