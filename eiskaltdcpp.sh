#!/bin/sh
# backup existing
sudo mv /opt/bin/eiskaltdcpp-daemon /opt/bin/eiskaltdcpp-daemon.old
# download current master
curl -L https://github.com/eiskaltdcpp/eiskaltdcpp/archive/master.tar.gz | tar xz -C /tmp
cd /tmp/eiskaltdcpp-master
# build and install
mkdir -p builddir && cd builddir
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/eiskaltdcpp \
    -DNO_UI_DAEMON=ON \
    -DJSONRPC_DAEMON=ON \
    -DLOCAL_JSONCPP=ON \
    -DUSE_QT=OFF \
    -DFREE_SPACE_BAR_C=OFF \
    -DLINK=STATIC \
    -Dlinguas="" \
    ..
make
sudo mv eiskaltdcpp-daemon/eiskaltdcpp-daemon /opt/bin
# clean up
rm -rf /tmp/eiskaltdcpp-master
