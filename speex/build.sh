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
topdir=speex
version=1.0.4
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=speex-1.0.4-getopt.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"

set_configure_args '--prefix=$prefix --mandir=${prefix}/${_mandir}'

reg prep
prep()
{
    generic_prep
    aclocal # 1.7.x is ok
    automake # ditto
    autoconf # 2.49+
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
    doc AUTHORS README TODO
    ${MV} ${stagedir}${prefix}/${_sharedir}/man ${stagedir}${prefix}
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
