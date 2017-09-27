#!/bin/bash

# This script install OSMesa with Gallium llvmpipe.
# First, "sed" is executed to prevent some errors.
# Second, "autogen.sh" is executed with the flugs.
# Finally, "make -j8" and "make install" are executed.

sed -i "/pthread-stubs/d" configure.ac
sed -i "/seems to be moved/s/^/: #/" bin/ltmain.sh

bash autogen.sh --disable-xvmc \
                --disable-glx \
                --disable-dri \
                --with-dri-drivers= \
                --with-gallium-drivers=swrast \
                --enable-texture-float \
                --disable-egl \
                --with-egl-platforms= \
                --enable-gallium-osmesa \
                --enable-gallium-llvm=yes \
                --enable-llvm-shared-libs \
                --disable-gles1 \
                --disable-gles2 \
                --prefix=

make -j8
make install

