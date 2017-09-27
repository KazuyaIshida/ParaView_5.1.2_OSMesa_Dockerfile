# This Dockerfile creates the Docker image of ParaView (v5.1.2) with OSMesa Libraies.

# FROM CentOS
FROM centos:latest

# MAINTAINER is ishidakauya
MAINTAINER ishidakazuya

# ADD the shellscript for install
ADD install.sh /root
ADD install_osmesa.sh /root

# Install ParaView with OSMesa
RUN yum -y update \
&& yum -y install mpich mpich-devel gcc gcc-c++ make git autoconf automake libtool python-devel bison bison-devel flex flex-devel boost boost-devel zlib zlib-devel zlib-static mesa-libGLU mesa-libGLU-devel mesa-libOSMesa-devel \
&& cd /root \
&& curl -O https://mesa.freedesktop.org/archive/12.0.3/mesa-12.0.3.tar.gz \
&& tar -xvf mesa-12.0.3.tar.gz \
&& mv /root/install_osmesa.sh /root/mesa-12.0.3 \
&& cd /root/mesa-12.0.3 \
&& bash install_osmesa.sh \
&& cp -rf /root/mesa-12.0.3/include/* /usr/include \
&& git clone https://github.com/FFmpeg/FFmpeg /root/FFmpeg \
&& cd /root/FFmpeg \
&& ./configure --disable-x86asm --enable-shared \
&& make -j8 \
&& make install \
&& cd /root \
&& curl -O https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz \
&& tar -xvf cmake-3.6.2.tar.gz \
&& cd /root/cmake-3.6.2 \
&& ./configure \
&& gmake -j8 \
&& gmake install \
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
&& rm -rf /root/build \
&& rm -rf /root/ParaView_src \
&& rm -rf /root/cmake-3.6.2 \
&& rm -rf /root/FFmpeg \
&& rm -rf /root/mesa-12.0.3 \
&& rm /root/cmake-3.6.2.tar.gz \
&& rm /root/mesa-12.0.3.tar.gz \
&& yum -y remove gcc gcc-c++ make git autoconf automake libtool bison bison-devel flex flex-devel \
&& yum clean all \
&& mkdir /usr/local/ParaView_5.1.2 \
&& mv /root/include /usr/local/ParaView_5.1.2 \
&& mv /root/bin /usr/local/ParaView_5.1.2 \
&& mv /root/lib /usr/local/ParaView_5.1.2 \
&& mv /root/share /usr/local/ParaView_5.1.2

# Set PATH
ENV PATH=$PATH:/usr/lib64/mpich/bin:/usr/local/ParaView_5.1.2/bin

# EXPOSE Port 11111
EXPOSE 11111

# CMD is /bin/bash
CMD /bin/bash

