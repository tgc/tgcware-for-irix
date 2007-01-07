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
topdir=cairo
version=1.2.6
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]= #cairo-1.0.2-nostdint.patch
patch[1]=cairo-1.0.2-trio.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9
    autoheader
    autoconf
    # ARGH! somehow X_LIBS is being translated into /usr/lib on Irix 6.2
    [ "$_os" = "irix62" ] && sed -i '/-lX11/s|$X_LIBS|-L/usr/lib32|g' configure
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
    doc README NEWS COPYING* TODO
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
