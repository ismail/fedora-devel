# syntax=docker/dockerfile:1.4

FROM fedora:rawhide

ARG DOCKER_USER=idoenmez
ARG GOSU_VERSION=1.14
ARG TARGETPLATFORM

RUN groupadd "$DOCKER_USER" && adduser "$DOCKER_USER" -g "$DOCKER_USER"

RUN dnf update -y && dnf install --setopt=install_weak_deps=0 \
            ca-certificates cpio curl krb5-workstation less bsdtar \
            openssl pkgdiff python3 openssh-clients procps rpm watchman zsh zstd -y && \
    rm -f /root/*.log && rm -rf /root/*.cfg

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; fi \
    && curl -sS -L https://github.com/tianon/gosu/releases/download/"$GOSU_VERSION"/gosu-"$ARCHITECTURE" | install /dev/stdin /usr/local/bin/gosu

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY entrypoint /entrypoint
COPY base16-atelier-heath.sh /etc/base16-atelier-heath.sh
COPY ls.colors /etc/lscolors
COPY zsh.rc /etc/zsh/zlogin

RUN chmod 0755 /entrypoint && sed "s/\$DOCKER_USER/$DOCKER_USER/g" -i /entrypoint

ENTRYPOINT ["/entrypoint"]
