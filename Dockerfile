FROM golang:stretch AS builder
ARG GCSFUSE_VERSION=0.27.0

RUN apt-get update && \
    apt-get install -y git libfuse-dev && \
    go get -d github.com/googlecloudplatform/gcsfuse && \
    go install github.com/googlecloudplatform/gcsfuse/tools/build_gcsfuse && \
    build_gcsfuse ${GOPATH}/src/github.com/googlecloudplatform/gcsfuse /tmp ${GCSFUSE_VERSION}

FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs, thelamer"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

RUN echo "***** installing required packages ****" && \
    apt-get update -y && \
    apt-get install -y \
      fuse \
      ca-certificates && \
    echo "**** cleanup ****" && \
    apt-get clean -y && \
    rm -rf \
      /tmp/* \
      /var/lib/apt/lists/* \
     /var/tmp/*

COPY /root/ /
COPY --from=builder /tmp/bin/gcsfuse /usr/bin
COPY --from=builder /tmp/sbin/mount.gcsfuse /usr/sbin
RUN ln -s mount.gcsfuse /usr/sbin/mount.fuse.gcsfuse
