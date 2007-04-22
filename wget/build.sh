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
topdir=wget
version=1.10.2
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=wget-1.10.2-trio.patch
patch[1]=wget-1.10.2-m4include.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
ac_overrides="ac_cv_lib_socket_socket=no"

reg prep
prep()
{
    generic_prep
    ${CP} /usr/tgcware/share/aclocal/needtrio.m4 m4
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
    doc COPYING AUTHORS README NEWS
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
