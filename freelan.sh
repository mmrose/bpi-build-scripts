#!/bin/sh
VERSION=2.0

# install dependencies
sudo aptitude install scons python libssl-dev libcurl4-openssl-dev libboost-system-dev \
    libboost-thread-dev libboost-program-options-dev libboost-filesystem-dev \
    libboost-iostreams-dev

cd /storage/temp
curl -L https://github.com/freelan-developers/freelan/archive/$VERSION.tar.gz | tar xz

cd freelan-$VERSION

# build
scons

# install
sudo mv /opt/bin/freelan /opt/bin/freelan.old
sudo cp /storage/temp/freelan-$VERSION/install/bin/freelan /opt/bin/freelan
sudo chown root:root /opt/bin/freelan
