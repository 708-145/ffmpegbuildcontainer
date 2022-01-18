#This is a sample Image
# docker build -t ffmpeg:latest .
## docker run --entrypoint=/bin/bash -it ffmpeg
## docker run -it ffmpeg
# docker run -d ffmpeg
# docker build -t ffmpeg:latest .; docker rm xyz; docker run -d --name=xyz -v /tmp:/temp -v `pwd`:/result ffmpeg

FROM ubuntu 
#FROM redhat/ubi8
MAINTAINER ffmpeg_c@ntainer.com 

#RUN apt-get update && apt-get install -y autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev libgnutls28-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev meson ninja-build pkg-config texinfo wget yasm zlib1g-dev nasm libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev libunistring-dev

COPY build.sh /root/build.sh
# execute build script which copies out the binaries to /result
#CMD ["/root/build.sh",""]

# result copy example
COPY result.sh /root/result.sh
CMD ["/root/result.sh",""]

# interactive
#ENTRYPOINT ["/bin/bash"]
#CMD ["ls","/root"]
