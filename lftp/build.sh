#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions

###########################################################
# Check the following 4 variables before running the script
topdir=lftp
version=3.4.3
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=lftp-3.4.3-nameser_h.patch
patch[1]=lftp-3.4.3-system-trio.patch
patch[2]=lftp-3.4.3-prefer-ncurses.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --enable-shared --enable-static=no --with-gnutls --without-openssl --with-libiconv-prefix=/usr/tgcware --with-libintl-prefix=/usr/tgcware'

reg prep
prep()
{
    generic_prep
    aclocal-1.9 -I m4 -I /usr/tgcware/share/aclocal
    automake-1.9
    autoheader
    autoconf
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
    doc NEWS FEATURES FAQ README TODO COPYING THANKS
    ${RM} -rf ${stagedir}${prefix}/${_libdir}
    chmod 644 ${stagedir}${prefix}/${_sharedir}/lftp/*
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
