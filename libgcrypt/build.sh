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
topdir=libgcrypt
version=1.4.4
pkgver=1
source[0]=ftp://ftp.gnupg.org/gcrypt/libgcrypt/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=libgcrypt-1.4.4-trio.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
configure_args+=(--disable-dev-random --enable-random=egd --with-egd-socket=/var/run/egd-pool)
ac_overrides="ac_cv_lib_socket_socket=no"
#[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib $NO_RQS"

reg prep
prep()
{
    generic_prep
    aclocal-1.10 -I m4
    automake-1.10
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
    doc NEWS README README.apichanges THANKS TODO COPYING* AUTHORS
}

reg check
check()
{
    generic_check
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
