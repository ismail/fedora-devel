# syntax=docker/dockerfile:1.4

FROM fedora:rawhide

ARG GOSU_VERSION=1.14
ARG TARGETPLATFORM

RUN echo "fastestmirror=true\ninstall_weak_deps=false" >> /etc/dnf/dnf.conf

RUN dnf update -y && dnf install \
            bsdtar ca-certificates clang compiler-rt cpio curl gcc gcc-c++ gdb less \
            llvm libasan openssl pkgdiff python3 openssh-clients procps rpm zsh zstd -y && \
    rm -f /root/*.log && rm -rf /root/*.cfg

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; fi \
    && curl -sS -L https://github.com/tianon/gosu/releases/download/"$GOSU_VERSION"/gosu-"$ARCHITECTURE" | install /dev/stdin /usr/local/bin/gosu

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY files/ /
RUN  chmod 0755 /entrypoint
ENTRYPOINT ["/entrypoint"]
