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
topdir=libxml2
version=2.6.17
pkgver=2
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=testapi-libxml_h.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export LDFLAGS="-L$prefix/lib -Wl,-rpath,$prefix/lib"
export CPPFLAGS="-I$prefix/include"

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
    doc README NEWS TODO TODO_SCHEMAS
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
