FROM ubuntu:latest

ARG qt_version=v5.12.5
ARG qt_modules=qtbase,qtxmlpatterns,qtdeclarative,qtquickcontrols2,qtgraphicaleffects,qtimageformats,qt3d,qtsvg,qtmultimedia,qtserialport,qttools
ARG DEBIAN_FRONTEND=noninteractive

USER root
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y build-dep qtbase-opensource-src && \
    apt-get -y install git-core \
               wget cmake git-core git build-essential libssl-dev libassimp-dev \
               libmysqlcppconn-dev libgtest-dev \
               libfontconfig1 \
	       mono-complete  libcurl4 curl unzip \
               ca-certificates software-properties-common python \
               libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev

# Install GitVersion
RUN curl -Ls https://github.com/GitTools/GitVersion/releases/download/5.3.7/gitversion-ubuntu.18.04-x64-5.3.7.tar.gz -o tmp.tar.gz \ 
  && tar -xzf  tmp.tar.gz -C /bin \
  && rm tmp.tar.gz

RUN mkdir /build
WORKDIR /build

RUN git config --global user.name "Cellink CI Builder" && git config --global user.email "ci-builder@cellink.com" && \
    git clone git://code.qt.io/qt/qt5.git /build/qt5 && \
    cd /build/qt5 && git checkout ${qt_version} && ./init-repository -module-subset=${qt_modules} && \
    git submodule foreach git checkout ${qt_version}

WORKDIR /build/qt5
RUN ./configure -opensource -confirm-license -prefix /opt/qt5 -nomake examples -nomake tests -no-feature-statx -no-use-gold-linker && \
    make -j28 && make install && cd / && rm -rf /build

RUN apt-get -y install libmoo-perl
RUN apt-get -y install libboost-thread-dev libboost-system-dev libboost-filesystem-dev
RUN apt-get -y install libmodule-build-perl libextutils-cppguess-perl liblocal-lib-perl
RUN apt-get -y install libencode-locale-perl

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]