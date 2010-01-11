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
topdir=libexif
version=0.6.13
pkgver=2
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=libexif-0.6.13-trio.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir} --disable-rpath"

reg prep
prep()
{
    generic_prep
    setdir source
    ${CP} /usr/tgcware/share/aclocal/needtrio.m4 m4m
    ${CP} /usr/tgcware/share/aclocal/gettext.m4 m4m
    ${CP} /usr/tgcware/share/aclocal/iconv.m4 m4m
    aclocal-1.8 -I m4m
    automake-1.8
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
    doc COPYING README NEWS
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
