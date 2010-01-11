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
topdir=diffutils
version=2.8.1
pkgver=7
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=diffutils-2.8.1-gettextize.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.10 -I m4
    automake-1.10 --gnu
    autoconf
    autoheader
    # Ugly hack
    setdir $srcdir
    ${__ln} -s ${srcdir}/${topsrcdir}/config .
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
    ${__rm} -f ${stagedir}${prefix}/${_infodir}/dir
    doc NEWS THANKS AUTHORS COPYING
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
    ${__rm} -f ${srcdir}/config
}

###################################################
# No need to look below here
###################################################
build_sh $*
