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
topdir=tz
version=2005n
pkgver=1
source[0]=${topdir}code${version}.tar.gz
source[1]=${topdir}data${version}.tar.gz
# If there are no patches, simply comment this
patch[0]=tz2004g-makefile.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# Irix 5.3 needs an extra define
[ "$_os" = "irix53" ] && CDEF="-D_XOPEN_SOURCE"
export CC="gcc $CDEF"
# hackisk for the sake of relnotes mostly
__configure="$MAKE_PROG"
# Note that REDO=right_only disables strict POSIX compatibility since leap-seconds are counted
configure_args="CC=$CC TOPDIR=$prefix TZDIR=/usr/lib/locale/TZ ETCDIR=$prefix/$_bindir REDO=right_only"
check_ac=0

reg prep
prep()
{
    clean source
    # No topleveldir in the tarballs :(
    ${MKDIR} -p $srcdir/tz-$version
    setdir $srcdir/tz-$version
    ${GZIP} -dc $srcfiles/${source[0]} | ${TAR} -xf -
    ${GZIP} -dc $srcfiles/${source[1]} | ${TAR} -xf -
    patch 0
}

reg build
build()
{
    generic_build
}

reg install
install()
{	
    clean stage
    setdir source
    $MAKE_PROG $configure_args DESTDIR=$stagedir install
    doc Theory README
    custom_install=1
    generic_install
}

reg pack
pack()
{
    topinstalldir=/usr
    iprefix=tgcware
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
