#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
# BuildRequires: freetype2 expat zlib
###########################################################
# Check the following 4 variables before running the script
topdir=fontconfig
version=2.6.0
pkgver=1
source[0]=http://fontconfig.org/release/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=cc
mipspro=1
configure_args="$configure_args --with-confdir=$prefix/${_sysconfdir} --with-docdir=${prefix}/${_docdir}/${topdir}-${version} --with-cache-dir=$prefix/var/cache/fontconfig"

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
    ${__mkdir} -p ${stagedir}${prefix}/var/cache/fontconfig
    doc README COPYING
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
