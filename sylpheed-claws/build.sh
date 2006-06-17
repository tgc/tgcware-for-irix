#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=sylpheed-claws
version=2.3.0
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=sylpheed-claws-2.2.0-maxdname.patch
patch[1]=sylpheed-claws-2.2.0-socket_h.patch
patch[2]=sylpheed-claws-2.2.0-morechecks.patch
patch[3]=sylpheed-claws-2.2.0-setenv.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-gnomeprint --enable-ldap"
ac_overrides="ac_cv_lib_socket_bind=no"

reg prep
prep()
{
    generic_prep
    setdir source
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

reg install
install()
{
    generic_install DESTDIR
    doc README RELEASE_NOTES TODO AUTHORS COPYING
    setdir ${stagedir}${prefix}/${_libdir}/$topdir
    $RM -f *.la *.a
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
