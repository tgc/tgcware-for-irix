#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=x11vnc
version=0.9.3
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=x11vnc-0.8.1-shutrdwr.patch
patch[1]=x11vnc-0.9-trio.patch
patch[2]=x11vnc-0.9-shutwr.patch
patch[3]=x11vnc-0.9-trio-includes.patch
patch[4]=x11vnc-0.8.1-mapfailed.patch
patch[5]=x11vnc-0.9.3-usleep.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
ac_overrides="ac_cv_lib_socket_socket=no"
configure_args+=(--without-xkeyboard --x-libraries= --without-xfixes --without-xrandr --without-pthread)

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9
    automake-1.9
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
    doc COPYING AUTHORS NEWS README
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
