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
topdir=wget
version=1.11.4
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/wget/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=wget-1.11.3-types.patch
patch[1]=wget-1.11.4-test_h.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
mipspro=1
export CC=cc
[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
ac_overrides="ac_cv_lib_socket_socket=no"
make_check_target="test"

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
