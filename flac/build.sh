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
topdir=flac
version=1.1.2
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=flac-1.1.2-snprintf.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"

set_configure_args '--prefix=$prefix --disable-rpath'

reg prep
prep()
{
    generic_prep
    # The libiconv stuff is broken :(
    # This needs GNU sed with inplace editing!
    $FIND . -name 'Makefile.in' -print|$XARGS -n 1 $GSED -i 's/@LIBICONV@/@LTLIBICONV@/g'
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
    doc COPYING* AUTHORS README
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
