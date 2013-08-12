#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=ncurses
version=5.6
pkgver=3
source[0]=ftp://ftp.sunet.se/pub/gnu/ncurses/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=ncurses-5.5-destdir.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args=(--prefix=$prefix --with-shared --without-debug --disable-rpath --with-manpage-format=normal --with-manpage-symlinks --enable-symlinks --without-ada --with-libtool)

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
    doc NEWS INSTALL TO-DO ANNOUNCE AUTHORS
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
