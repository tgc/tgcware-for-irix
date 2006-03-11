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
topdir=lua
version=5.1
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=lua-5.1-irix.patch
patch[1]=lua-5.1-shared.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
make_build_target=irix
shortroot=1
no_configure=1
check_ac=0

reg prep
prep()
{
    generic_prep
    setdir source
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install INSTALL_TOP
    setdir ${stagedir}${prefix}/${_libdir}
    $LN -s liblua.so.5.1 liblua.so.5
    $LN -s liblua.so.5.1 liblua.so
    doc COPYRIGHT README HISTORY doc/lua.css doc/manual.html doc/logo.gif doc/contents.html
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
