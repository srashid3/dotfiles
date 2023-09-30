#!/usr/bin/bash

EMACS_VERSION=28.2

cd ~

# enable source code
sudo sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
sudo apt update

# install dependencies
sudo apt install build-essential
sudo apt build-dep emacs

# download emacs
wget "https://ftp.gnu.org/pub/gnu/emacs/emacs-${EMACS_VERSION}.tar.gz"
tar -xzvf "emacs-${EMACS_VERSION}.tar.gz"

# configure build
cd "emacs-${EMACS_VERSION}"
mkdir build && cd build
../configure

# make and install
sudo make
sudo make install
