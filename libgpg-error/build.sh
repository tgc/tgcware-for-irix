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
topdir=libgpg-error
version=1.7
pkgver=1
source[0]=ftp://ftp.gnupg.org/gcrypt/libgpg-error/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=libgpg-error-1.5-trio.patch
patch[1]=libgpg-error-1.7-inline.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
configure_args=(--prefix=$prefix --enable-nls --disable-rpath --with-libiconv-prefix=/usr/tgcware --with-libintl-prefix=/usr/tgcware)
export CC=cc
mipspro=1
[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib $NO_RQS"

reg prep
prep()
{
    generic_prep
    aclocal-1.9 -I m4
    automake-1.9
    autoheader
    autoconf
}

reg build
build()
{
    generic_build
}

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    doc README NEWS COPYING* AUTHORS ChangeLog
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
