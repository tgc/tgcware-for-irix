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
topdir=audiofile
version=0.2.6
pkgver=5
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=audiofile-examples-irix62.patch
patch[1]=audiofile-0.2.6-underquoted.patch
patch[2]=audiofile-0.2.6-trio.patch
patch[3]=audiofile-0.2.6-old-dmedia.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

[ "$_os" = "irix53" ] && patch[4]=audiofile-0.2.6-irix53.patch

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

reg prep
prep()
{
    generic_prep
    setdir source
    $RM -f ltmain.sh
    libtoolize -f -c
    aclocal-1.9
    automake-1.9 -c -f
    autoconf
    autoheader
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
    doc README NEWS NOTES ACKNOWLEDGEMENTS COPYING*
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
