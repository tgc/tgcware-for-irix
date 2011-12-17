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
topdir=rdesktop
version=1.7.0
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=rdesktop-1.7.0-trio.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

[ "$_os" = "irix53" ] && patch[1]=rdesktop-1.4.1-no-CODESET.patch

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --with-openssl=$prefix --with-egd-socket=/var/run/egd-pool --with-sound=libao --with-libiconv-prefix=$prefix"

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9
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
    doc COPYING README doc
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
