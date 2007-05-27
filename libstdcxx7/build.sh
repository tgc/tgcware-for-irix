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
topdir=libstdcxx7
version=7
pkgver=5
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
gcc=4.2.0
[ "$_os" = "irix53" ] && gcc=3.4.6

reg prep
prep()
{
    : nothing to prep
}

reg build
build()
{
    : nothing to build
}

reg install
install()
{
    echo "BuildRequires: tgc_gcc $gcc"
    clean stage
    $MKDIR -p ${stagedir}${prefix}/$_libdir
    $CP -pR $prefix/gcc-$gcc/${_libdir}32/libstdc++.so.7* ${stagedir}${prefix}/$_libdir
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
