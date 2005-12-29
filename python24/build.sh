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
version=2.4.2
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=Python-2.4.2-tgcware.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/BerkeleyDB.4.3/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/BerkeleyDB.4.3/lib -Wl,-rpath,/usr/tgcware/BerkeleyDB.4.3/lib"
export CC=gcc
export CXX=g++
export LDSHARED="$CC -shared -all"
unset SGI_ABI
ac_overrides="ac_cv_lib_socket_socket=no"
configure_args="--prefix=$prefix --enable-shared --disable-ipv6"

reg prep
prep()
{
    generic_prep
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
