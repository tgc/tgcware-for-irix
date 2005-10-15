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
topdir=diffutils
version=2.8.1
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

reg prep
prep()
{
    generic_prep
    setdir source
    ${RM} -f m4/gettext.m4
    aclocal -I ./m4 -I /usr/tgcware/share/aclocal
    automake --gnu
    autoconf
    # Ugly hack
    setdir $srcdir
    $LN -s ${srcdir}/${topsrcdir}/config .
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
    $RM -f ${stagedir}${prefix}/${_infodir}/dir
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
    $RM -f ${srcdir}/config
}

###################################################
# No need to look below here
###################################################
build_sh $*
