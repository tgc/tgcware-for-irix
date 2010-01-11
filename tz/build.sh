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
topdir=tz
version=2009k
pkgver=1 # Increase for each lettered release within the same year!
source[0]=ftp://elsie.nci.nih.gov/pub/${topdir}code${version}.tar.gz
source[1]=ftp://elsie.nci.nih.gov/pub/${topdir}data${version}.tar.gz
# If there are no patches, simply comment this
patch[0]=tz2004g-makefile.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
# Irix 5.3 needs an extra define
[ "$_os" = "irix53" ] && CDEF="-D_XOPEN_SOURCE"
export CC="gcc"
# hackish for the sake of relnotes mostly
__configure="${__make}"
# Note that REDO=right_only disables strict POSIX compatibility since leap-seconds are counted
configure_args="CC=$CC TOPDIR=$prefix TZDIR=/usr/lib/locale/TZ ETCDIR=$prefix/$_bindir REDO=right_only"
check_ac=0

reg prep
prep()
{
    fetch_source 0
    fetch_source 1
    clean source
    # No topleveldir in the tarballs :(
    ${__mkdir} -p $srcdir/tz-$version
    setdir $srcdir/tz-$version
    ${__gzip} -dc $srcfiles/$(get_source_filename 0) | ${__tar} -xf -
    ${__gzip} -dc $srcfiles/$(get_source_filename 1) | ${__tar} -xf -
    patch 0
    ${__gsed} -i "/^CFLAGS/s/=.*/=$CDEF/" Makefile
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
    ${__make} $configure_args DESTDIR=$stagedir install
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
