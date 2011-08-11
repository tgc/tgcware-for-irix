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
topdir=pcre
version=7.8
pkgver=2
source[0]=http://downloads.sourceforge.net/pcre/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=pcre-7.8-no-linker-alias.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-unicode-properties"
export CXX=g++
export CC=cc
mipspro=1

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
    ${__rm} -f ${stagedir}${prefix}/${_docdir}/${topdir}/pcre*
    ${__mv} ${stagedir}${prefix}/${_docdir}/${topdir} ${stagedir}${prefix}/${_vdocdir}
}

reg check
check()
{
    generic_check
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
