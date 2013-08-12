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
topdir=popt
version=1.7
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args=(--prefix=$prefix --with-libiconv-prefix=/usr/tgcware -with-libintl-prefix=/usr/tgcware)

reg prep
prep()
{
    generic_prep
    setdir source
}

reg build
build()
{
    setdir source
    $__configure "${configure_args[@]}"
    # configure/libtool support for gettext is completely broken, this'll make
    # sure we link with the right libraries
    ${SED} -e '/^LIBS\ =/ s/=/=\ -liconv\ -lintl/g' Makefile > Makefile.fixed
    ${CP} Makefile.fixed Makefile
    $MAKE_PROG
}

reg install
install()
{
    generic_install DESTDIR
    doc README CHANGES
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
