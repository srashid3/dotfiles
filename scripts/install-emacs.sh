#!/bin/bash

EMACS_VERSION=28.2

cd ~

# Enable Source Packages
sudo sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
sudo apt update

# Install Dependencies
sudo apt install build-essential
sudo apt build-dep emacs

# Download Emacs
wget "https://ftp.gnu.org/pub/gnu/emacs/emacs-${EMACS_VERSION}.tar.gz"
tar -xzvf "emacs-${EMACS_VERSION}.tar.gz"

# Configure Build
cd "emacs-${EMACS_VERSION}"
mkdir build && cd build
../configure

# Install
sudo make
sudo make install
