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
topdir=gaim
version=1.5.0
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gaim-1.5.0-trio.patch
patch[1]=gaim-1.5.0-gnutls.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-gnutls=yes --enable-nss=no --disable-gevolution"

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9
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
    doc COPYING COPYRIGHT AUTHORS NEWS README
    $FIND ${stagedir} -name '.packlist' -o -name 'perllocal.pod' -o -name '*.bs' | $XARGS -i $RM -f {}
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
