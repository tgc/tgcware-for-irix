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
topdir=popt
version=1.7
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    export CPPFLAGS="-I/usr/local/include"
    export LDFLAGS="-L/usr/local/lib"
    set_configure_args "--prefix=$prefix --with-libiconv-prefix=/usr/local -with-libintl-prefix=/usr/local"
    setdir source
    ./configure $configure_args
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
