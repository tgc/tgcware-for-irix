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
topdir=flex
version=2.5.4a
pkgver=5
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=flex-2.5.4a-skel.patch
patch[1]=flex-2.5.4a-gcc3.patch
patch[2]=flex-2.5.4a-gcc31.patch
patch[3]=flex-2.5.4a2.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
shortroot=1
topsrcdir=$topdir-2.5.4

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    autoconf
    generic_build
}

reg install
install()
{
    generic_install prefix
    doc COPYING NEWS
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
