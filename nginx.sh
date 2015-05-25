#!/bin/sh
VERSION=1.9.0

curl -L http://nginx.org/download/nginx-$VERSION.tar.gz | tar xz -C /tmp

cd /tmp/nginx-$VERSION

./configure --prefix=/etc/nginx \
            --sbin-path=/opt/bin/nginx \
            --conf-path=/etc/nginx/nginx.conf \
            --pid-path=/var/run/nginx.pid \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --with-http_ssl_module

make
sudo make install

# cleanup
rm -rf /tmp/nginx-$VERSION
