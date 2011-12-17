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
topdir=libao
version=1.1.0
pkgver=1
source[0]=http://downloads.xiph.org/releases/ao/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libao-1.1.0-oldirix.patch
patch[1]=libao-1.1.0-needs-trio.patch
patch[2]=libao-0.8.6-trio-include.patch
#patch[1]=libao-0.8.6-irixcheck.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --mandir=${prefix}/${_mandir} --disable-esd'

reg prep
prep()
{
    generic_prep
    libtoolize -f
    aclocal
    automake -a -c
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
    doc TODO README CHANGES COPYING AUTHORS
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/ao/plugins-2/lib*.la
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
