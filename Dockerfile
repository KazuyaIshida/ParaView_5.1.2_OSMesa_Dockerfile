# This Dockerfile creates an image of "ParaView_5.1.2 with OSMesa, MPICH, Python and FFmpeg".

# FROM CentOS
FROM centos:latest

# MAINTAINER is ishidakauya
MAINTAINER ishidakazuya

# ADD the script for installtion of ParaView
ADD install.sh /root

# Update, install and download the sourcecode
RUN yum -y update \
&& yum -y install mpich mpich-devel gcc gcc-c++ make git autoconf automake libtool python-devel numpy bison bison-devel flex flex-devel llvm llvm-devel boost boost-devel zlib zlib-devel zlib-static mesa-libGLU mesa-libGLU-devel mesa-libOSMesa-devel \
&& cd / \
&& curl -O https://mesa.freedesktop.org/archive/12.0.3/mesa-12.0.3.tar.gz \
&& tar -xvf mesa-12.0.3.tar.gz \
&& rm -f mesa-12.0.3.tar.gz
ADD install_mesa.sh /mesa-12.0.3
WORKDIR /mesa-12.0.3
RUN bash install_mesa.sh \
&& git clone https://github.com/FFmpeg/FFmpeg /FFmpeg \
&& cd /FFmpeg \
&& ./configure --disable-yasm --enable-shared \
&& make -j8 \
&& make install \
&& rm -rf /FFmpeg \
&& cd / \
&& curl -O https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz \
&& tar -xvf cmake-3.6.2.tar.gz \
&& rm -f cmake-3.6.2.tar.gz \
&& cd /cmake-3.6.2 \
&& ./configure \
&& gmake -j8 \
&& gmake install \
&& rm -rf /cmake-3.6.2 \
&& cd /root \
&& git clone https://github.com/Kitware/ParaView.git /root/ParaView_src \
&& mkdir /root/build \
&& mv /root/install.sh /root/build \
&& cd /root/ParaView_src \
&& git config submodule.VTK.url https://github.com/Kitware/VTK.git \
&& git checkout v5.1.2 \
&& git submodule init \
&& git submodule update \
&& cd /root/build \
&& bash install.sh \
&& rm -rf /root/ParaView_src \
&& rm -rf /root/build \
&& yum -y remove gcc gcc-c++ git make \
&& yum clean all

# Set PATH
ENV PATH=$PATH:/usr/lib64/mpich/bin

# CMD is /bin/bash
CMD /bin/bash

