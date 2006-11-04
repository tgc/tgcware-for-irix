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
topdir=Python
version=2.4.4
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=Python-2.4.2-tgcware.patch
patch[1]=Python-2.4.3-irix-shared.patch
patch[2]=Python-2.4.3-linker.patch
patch[3]=Python-2.4.4-ncurses.patch
patch[4]=Python-2.4.3-irixld.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=gcc
export CXX=g++
export LDSHARED="$CC -shared -all"
unset SGI_ABI
ac_overrides="ac_cv_lib_socket_socket=no"
configure_args="$configure_args --enable-shared --disable-ipv6"

reg prep
prep()
{
    generic_prep
    setdir source
    autoheader
    autoconf
}

reg build
build()
{
    generic_build
}

reg test
test()
{
    setdir source
    $MAKE_PROG test
}

reg install
install()
{
    generic_install DESTDIR
    doc README LICENSE Misc/NEWS
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
