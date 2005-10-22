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
topdir=glib
version=1.2.10
pkgver=6
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=glib-1.2.10-gcc34.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CC=cc
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -rpath /usr/tgcware/lib"
configure_args='--prefix=$prefix --enable-static=no'
mipspro=1

# Override getpwuid_r checking
ac_overrides="ac_cv_func_getpwuid_r=yes"

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
