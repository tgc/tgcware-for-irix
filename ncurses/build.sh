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
topdir=ncurses
version=5.4
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Set new configure args
set_configure_args '--prefix=$prefix --with-shared --without-debug --with-install-prefix=${stagedir} --with-manpage-symlinks --without-curses-h --disable-rpath --enable-symlinks --with-manpage-format=normal --with-libtool'

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    export LD="ld -n32 -rpath $prefix"
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    doc NEWS INSTALL TO-DO ANNOUNCE
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
