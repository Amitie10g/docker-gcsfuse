FROM golang:alpine AS builder
ARG GCSFUSE_VERSION=0.27.0
RUN apk --update --no-cache add git fuse fuse-dev;
RUN go get -d github.com/googlecloudplatform/gcsfuse
RUN go install github.com/googlecloudplatform/gcsfuse/tools/build_gcsfuse
RUN build_gcsfuse ${GOPATH}/src/github.com/googlecloudplatform/gcsfuse /tmp ${GCSFUSE_VERSION}

FROM alpine:latest
RUN apk add --no-cache fuse ca-certificates

COPY --from=builder /tmp/bin/gcsfuse /usr/bin
COPY --from=builder /tmp/sbin/mount.gcsfuse /usr/sbin
RUN ln -s /usr/sbin/mount.gcsfuse /usr/sbin/mount.fuse.gcsfuse

copy /root/ /
