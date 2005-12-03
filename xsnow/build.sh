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
topdir=xsnow
version=1.42
pkgver=5
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=xsnow-1.42-misc.patch
patch[1]=xsnow-1.42-trio.patch
patch[2]=xsnow-1.42-ldpostlib.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
configure_args="-n32 -mips3 -a"
__configure="xmkmf"
mipspro=1
check_ac=0

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

reg install
install()
{
    clean stage
    mkdir -p ${stagedir}${prefix}/${_bindir}
    mkdir -p ${stagedir}${prefix}/${_mandir}/man1
    setdir source
    cp xsnow ${stagedir}${prefix}/${_bindir}
    cp xsnow.man ${stagedir}${prefix}/${_mandir}/man1/xsnow.1
    doc README
    custom_install=1
    generic_install
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
