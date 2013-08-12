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
topdir=vorbis-tools
version=1.2.0
pkgver=1
source[0]=http://downloads.xiph.org/releases/vorbis/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=vorbis-tools-1.1.1-needstrio.patch
patch[1]=vorbis-tools-1.1.1-include.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--enable-nls --with-libiconv-prefix=/usr/tgcware)
ac_overrides='ac_cv_lib_socket_socket=no'

reg prep
prep()
{
    generic_prep
    libtoolize -f
    aclocal -I m4
    automake
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
    doc COPYING AUTHORS
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
