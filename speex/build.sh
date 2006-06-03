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
topdir=speex
version=1.0.5
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=speex-1.0.4-getopt.patch
patch[1]=speex-1.0.5-underquoted.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --mandir=${prefix}/${_mandir} --with-ogg-dir=$prefix'

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9 # 1.7.x is ok
    automake-1.9 # ditto
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
    doc AUTHORS README TODO COPYING
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
