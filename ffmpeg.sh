#!/bin/sh
FFMPEG_VERSION=2.8.5
YASM_VERSION=1.3.0

# install deps
sudo aptitude -y install \
autoconf automake build-essential libass-dev libfreetype6-dev \
libtheora-dev libtool libvorbis-dev pkg-config texi2html zlib1g-dev \
libao-dev libgcrypt11-dev libfreetype6-dev libfaad-dev libmad0-dev libjson0-dev
# prepare build folders
mkdir -p /storage/temp/ffmpeg/sources
mkdir -p /storage/temp/ffmpeg/build
mkdir -p /storage/temp/ffmpeg/bin
# h264
sudo aptitude -y install libx264-dev
# mp3
sudo aptitude -y install libmp3lame-dev
# webm
sudo aptitude -y install libogg-dev libvorbis-dev libvpx-dev
# compile
cd /storage/temp/ffmpeg/sources

# yasm
wget http://www.tortall.net/projects/yasm/releases/yasm-$YASM_VERSION.tar.gz
tar xzvf yasm-$YASM_VERSION.tar.gz
cd yasm-$YASM_VERSION
./configure --prefix="/storage/temp/ffmpeg/build" --bindir="/storage/temp/ffmpeg/bin"
make -j 2
make install
make distclean

wget https://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.gz
tar xzf ffmpeg-$FFMPEG_VERSION.tar.gz
cd ffmpeg-$FFMPEG_VERSION
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
make -j 2
make install
# copy bin (backup old)
sudo mv /opt/bin/ffmpeg /opt/bin/ffmpeg.old
sudo mv /opt/bin/ffprobe /opt/bin/ffprobe.old
sudo cp /storage/temp/ffmpeg/bin/ffmpeg  /opt/bin
sudo cp /storage/temp/ffmpeg/bin/ffprobe /opt/bin
# cleanup
rm -rf /storage/temp/ffmpeg
