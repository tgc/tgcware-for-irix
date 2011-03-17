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
topdir=m4
version=1.4.16
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/m4/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=m4-1.4.16-attribute.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CC=cc
mipspro=1
[ "$_os" = "irix53" ] && export NO_RQS="-Wl,-no_rqs"
irix62 && export CFLAGS="-O1"
export CPPFLAGS="-I$prefix/include"
export LDFLAGS="$NO_RQS -L$prefix/lib -Wl,-rpath,$prefix/lib"

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

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    doc ChangeLog NEWS README COPYING THANKS
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
