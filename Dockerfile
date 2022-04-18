# syntax=docker/dockerfile:1.4

FROM fedora:rawhide

RUN dnf update -y
RUN dnf install \
            ca-certificates cpio curl less bsdtar \
            openssl pkgdiff python3 rpm zsh zstd -y && \
    dnf clean all && rm -f /root/*.log && rm -rf /root/*.cfg

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY base16-atelier-heath.sh /etc/base16-atelier-heath.sh
COPY ls.colors /etc/lscolors
COPY zsh.rc /root/.zshrc

WORKDIR /root
SHELL ["/usr/bin/zsh"]
CMD ["/usr/bin/zsh"]
