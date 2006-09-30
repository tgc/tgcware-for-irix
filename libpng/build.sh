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
topdir=libpng
version=1.2.12
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=libpng-1.2.12-makefile.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    ${CP} scripts/makefile.sggcc Makefile
    $GSED -i "/^prefix/s;=.*;=${prefix};" Makefile
    $MAKE_PROG 
}

reg install
install()
{
    clean stage
    mkdir -p ${stagedir}${prefix}
    setdir source
    $MAKE_PROG DESTDIR=$stagedir install
    custom_install=1
    generic_install
    doc CHANGES README TODO example.c libpng.txt
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
