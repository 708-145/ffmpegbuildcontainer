# Watch video: https://youtu.be/qLw6ZWUXy7U

#sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
#apt-get install -y gcc-11

#Require for Compiler
#apt-get install -y autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev libgnutls28-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev meson ninja-build pkg-config texinfo wget yasm zlib1g-dev

#Require for FFmpeg
#apt-get install nasm libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev libunistring-dev

## -O3

## build in /tmp
mkdir ~/ffmpeg_sources
cd ~/ffmpeg_sources

#libaom
cd ~/ffmpeg_sources
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom
mkdir -p aom_build
cd aom_build
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom 
PATH="$HOME/bin:$PATH" make -j `nproc`
make install

#libsvtav1
cd ~/ffmpeg_sources
git -C SVT-AV1 pull 2> /dev/null || git clone https://github.com/AOMediaCodec/SVT-AV1.git
mkdir -p SVT-AV1/build
cd SVT-AV1/build
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF ..
PATH="$HOME/bin:$PATH" make -j `nproc`
make install

#ffmpeg --> use git clone
cd ~/ffmpeg_sources
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libsvtav1 \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
PATH="$HOME/bin:$PATH" make -j `nproc`
make install

## upx

cd ~/ffmpeg_sources/ffmpeg
./ffmpeg -version
./ffmpeg -h encoder=libaom-av1
./ffmpeg -h encoder=libsvtav1
