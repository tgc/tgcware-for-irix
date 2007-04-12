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
topdir=trio
version=1.12
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=trio-1.12-automake.patch
patch[1]=trio-1.10-needtrio.m4.patch
patch[2]=trio-1.10-header.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CC=cc
mipspro=1
[ "$_os" = "irix53" ] && mipspro=2

reg prep
prep()
{
    generic_prep
    setdir source
    libtoolize --copy
    aclocal-1.9
    automake-1.9 --foreign --add-missing --copy
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
    doc README CHANGES html
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
