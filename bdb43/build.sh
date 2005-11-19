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
topdir=db
version=4.3.29
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
bdbdir=BerkeleyDB.4.3
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/$bdbdir/lib -Wl,-rpath,/usr/tgcware/$bdbdir/lib"
export CC=gcc
configure_args='--prefix=$prefix/$bdbdir --enable-compat185'

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    setdir build_unix
    ../dist/configure $(_upls $configure_args)
    $MAKE_PROG
}

reg install
install()
{
    clean stage
    setdir source
    setdir build_unix
    $MAKE_PROG DESTDIR=${stagedir} install
    custom_install=1
    generic_install DESTDIR
    ${RM} -f ${stagedir}${prefix}/${bdbdir}/${_libdir}/*.la
    doc LICENSE README
    ${MV} ${stagedir}${prefix}/${_sharedir} ${stagedir}${prefix}/${bdbdir}
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
