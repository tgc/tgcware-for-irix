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
topdir=libetpan
version=0.48
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libetpan-0.45-trio.patch
patch[1]=libetpan-0.45-typo.patch
patch[2]=libetpan-0.45-ldflags.patch
patch[3]=libetpan-0.47-cppflags.patch
patch[4]=libetpan-0.47-triolib.patch
patch[5]=libetpan-0.45-trio-includes.patch
patch[6]=libetpan-0.45-setenv.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-static --with-openssl=no --with-gnutls --disable-ipv6"

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9
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
    doc COPYRIGHT NEWS TODO ChangeLog
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
