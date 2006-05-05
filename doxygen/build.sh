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
topdir=doxygen
version=1.4.5
pkgver=1
source[0]=$topdir-$version.src.tar.gz
# If there are no patches, simply comment this
patch[0]=doxygen-1.4.5-rpath.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix $prefix --perl /usr/tgcware/bin/perl --docdir ${prefix}${_sharedir}/doc --platform irix-g++ --shared --release"
[ "$_os" != "irix53" ] && configure_args="$configure_args --with-doxywizard --dot /usr/tgcware/bin/dot"
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
