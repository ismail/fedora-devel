# syntax=docker/dockerfile:1.4

FROM fedora:rawhide

RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf
RUN dnf update -y && dnf clean all

RUN dnf install --setopt=tsflags=nodocs \
        bmon bsdtar ca-certificates clang clang-tools-extra compiler-rt cpio \
        curl gcc gcc-c++ gdb git golang iproute less libasan libcxx-devel \
        llvm mtr openssl pkgdiff python3.11 openssh-clients procps \
        rpm rubygem-pry strace vim zsh zstd -y && \
    dnf clean all && rm -f /root/*.log && rm -rf /root/*.cfg

ARG GOSU_VERSION=1.14
ARG TARGETPLATFORM

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; fi \
    && curl -sS -L https://github.com/tianon/gosu/releases/download/"$GOSU_VERSION"/gosu-"$ARCHITECTURE" | install /dev/stdin /usr/local/bin/gosu

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY files/ /
RUN  chmod 0755 /entrypoint
ENTRYPOINT ["/entrypoint"]
