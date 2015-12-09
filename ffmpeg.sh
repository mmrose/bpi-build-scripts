#!/bin/sh
# install deps
sudo apt-get -y --force-yes install \
autoconf automake build-essential libass-dev libfreetype6-dev \
libtheora-dev libtool libvorbis-dev pkg-config texi2html zlib1g-dev \
libao-dev libgcrypt11-dev libfreetype6-dev libfaad-dev libmad0-dev libjson0-dev
# prepare build folders
mkdir -p /storage/temp/ffmpeg/sources
mkdir -p /storage/temp/ffmpeg/build
mkdir -p /storage/temp/ffmpeg/bin
# h264
sudo apt-get install libx264-dev
# mp3
sudo apt-get install libmp3lame-dev
# webm
sudo apt-get install libogg-dev libvorbis-dev libvpx-dev
# compile
cd /storage/temp/ffmpeg/sources

# yasm
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="/storage/temp/ffmpeg/build" --bindir="/storage/temp/ffmpeg/bin"
make
make install
make distclean

wget http://ffmpeg.org/releases/ffmpeg-2.7.tar.gz
tar xzf ffmpeg-2.7.tar.gz
cd ffmpeg-2.7
PKG_CONFIG_PATH="/storage/temp/ffmpeg/build/lib/pkgconfig" ./configure \
    --prefix="/storage/temp/ffmpeg/build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I/storage/temp/ffmpeg/build/include" \
    --extra-ldflags="-L/storage/temp/ffmpeg/build/lib" \
    --bindir="/storage/temp/ffmpeg/bin" \
    --enable-gpl \
    --enable-libass \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-nonfree
make
make install
# copy bin (backup old)
sudo mv /opt/bin/ffmpeg /opt/bin/ffmpeg.old
sudo mv /opt/bin/ffprobe /opt/bin/ffprobe.old
sudo cp /storage/temp/ffmpeg/bin/ffmpeg  /opt/bin
sudo cp /storage/temp/ffmpeg/bin/ffprobe /opt/bin
# cleanup
#rm -rf /storage/temp/ffmpeg
