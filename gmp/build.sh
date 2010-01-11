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
topdir=gmp
version=4.3.1
pkgver=2
source[0]=ftp://ftp.sunet.se/pub/gnu/gmp/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gmp-4.2.4-use-ldflags-during-configure.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --enable-cxx --with-readline=no"
if [ "$_os" = "irix62" ]; then
    mipspro=1
    export ABI=n32
    export CC=cc
    export CXX=g++
    export CXXFLAGS="-O2 -mabi=$ABI"
fi

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

reg check
check()
{
    setdir source
    ${__make} -k check
}

reg install
install()
{
    generic_install DESTDIR
    doc AUTHORS COPYING COPYING.LIB NEWS README
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
