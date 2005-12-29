#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=doxygen
version=1.4.5
pkgver=1
source[0]=$topdir-$version.src.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
configure_args="--prefix $prefix --perl /usr/tgcware/bin/perl --docdir ${prefix}${_sharedir}/doc --platform irix-g++ --dot /usr/tgcware/bin/dot --with-doxywizard --shared --release"
check_ac=0
shortroot=1

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
    setdir source
    $MAKE_PROG docs
}

reg install
install()
{
    generic_install INSTALL
    doc LICENSE LANGUAGE.HOWTO README examples html
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
