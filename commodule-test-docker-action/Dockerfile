FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

# We need to change to root to be able to install with apt-get
USER root
ENV TZ=Europe/Stockholm

RUN apt-get update && apt-get install -y \
    autoconf \
    autotools-dev \
    build-essential \
    cmake \
    git \
    libboost-system-dev \
    libboost-all-dev \
    libgtest-dev \
    libmysqlcppconn-dev \
    libssl-dev \
    libtool \
    sqlite3 \
    wget

# Install GitVersion
RUN apt-get -y install  mono-complete  libcurl3 curl unzip

RUN curl -Ls https://github.com/GitTools/GitVersion/releases/download/5.3.7/gitversion-debian.9-x64-5.3.7.tar.gz -o tmp.tar.gz \ 
  && tar -xzf  tmp.tar.gz -C /bin \
  && rm tmp.tar.gz

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /com-module-deps
WORKDIR /com-module-deps

ENV PAHO_MQTT_C_VERSION 1.2.0
RUN wget https://github.com/eclipse/paho.mqtt.c/archive/v${PAHO_MQTT_C_VERSION}.tar.gz
RUN tar xvf v${PAHO_MQTT_C_VERSION}.tar.gz
WORKDIR paho.mqtt.c-${PAHO_MQTT_C_VERSION}
RUN make
RUN make install

RUN mkdir -p /paho-mqtt-cpp
WORKDIR /paho-mqtt-cpp
RUN wget https://github.com/eclipse/paho.mqtt.cpp/archive/v1.0.1.tar.gz
RUN tar xvf v1.0.1.tar.gz -C .
RUN cmake ./paho.mqtt.cpp-1.0.1 -DPAHO_WITH_SSL=TRUE -DPAHO_BUILD_DOCUMENTATION=FALSE -DPAHO_BUILD_STATIC=TRUE -DPAHO_BUILD_SHARED=FALSE -DPAHO_MQTT_C_PATH=../paho.mqtt.c/ -DPAHO_MQTT_C_LIB=../paho.mqtt.c/src/libpaho.mqtt3as-static.a
RUN make
RUN make install

RUN mkdir -p /google-test
WORKDIR /google-test
ENV GOOGLETEST_VERSION 1.8.0
RUN wget https://github.com/google/googletest/archive/release-${GOOGLETEST_VERSION}.tar.gz
RUN tar xvf release-${GOOGLETEST_VERSION}.tar.gz
WORKDIR googletest-release-${GOOGLETEST_VERSION}
RUN mkdir build
WORKDIR build
RUN cmake ../
RUN make
RUN make install

ENV user=jenkins
ENV group=jenkins
ENV uid=1000
ENV gid=1000
ENV JENKINS_HOME /var/jenkins_home

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
#
# We run this container from a Jenkins container, lets make sure that we have
# the same permissions
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Switch to user jenkins
USER jenkins

WORKDIR /

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
