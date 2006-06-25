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
topdir=glib
version=1.2.10
pkgver=10
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=glib-1.2.10-gcc34.patch
patch[1]=glib-1.2.10-underquoted.patch
patch[2]=glib-1.2.10-autoconf25x.patch
patch[3]=glib-1.2.10-realloc.patch
patch[4]=glib-1.2.10-dlopen.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CC=gcc
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --enable-static=no'
if [ "$_os" = "irix62" ]; then
    export CC=cc
    mipspro=1
fi

reg prep
prep()
{
    generic_prep
    setdir source
    $RM -f acinclude.m4
    $RM -f ltconfig ltmain.sh
    libtoolize -f -c
    aclocal-1.4
    automake-1.4
    autoconf
    autoheader
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
    doc NEWS README COPYING AUTHORS
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
