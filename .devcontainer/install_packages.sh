#!/bin/sh

sudo apt-get update
sudo apt-get install -qy \
    build-essential gcc g++ autoconf automake libtool bison flex gettext \
    patch texinfo wget git gawk curl lzma bc quilt \
    cpio unzip rsync python3 \
    sudo mc nano symlinks curl lzop unzip chrpath xz-utils minicom tmux \
    libncurses-dev libssl-dev swig pkgconf
