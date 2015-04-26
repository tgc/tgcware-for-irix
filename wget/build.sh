#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=wget
version=1.15
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/wget/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=wget-1.11.3-types.patch
#patch[1]=wget-1.12-bogus-prototypes.patch
#patch[2]=wget-1.12-no-decl-after-stmt.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
mipspro=1
CC=cc
if [ "$_os" = "irix53" ]; then
  NO_RQS="-Wl,-no_rqs"
#  CC=gcc
#  mipspro=0
fi
export CC=$CC
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
ac_overrides="ac_cv_lib_socket_socket=no"
configure_args+=(--with-ssl=openssl)

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
    doc COPYING AUTHORS README NEWS
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
