#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=cairo
version=1.8.4
pkgver=1
source[0]=http://cairographics.org/releases/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=cairo-1.8.4-trio.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-xlib-xrender=no --disable-static"
export CC=cc
mipspro=1

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.10 -I build
    automake-1.10 -gnu
    autoheader
    autoconf
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    doc README NEWS COPYING*
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
