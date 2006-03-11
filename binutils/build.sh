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
topdir=binutils
version=2.16.1
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CONFIG_SHELL=/bin/ksh
configure_args="--prefix=$prefix --program-prefix=g"

reg prep
prep()
{
    generic_prep
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
#    $RM -f ${stagedir}${prefix}/${_bindir}/ld
#    $RM -f ${stagedir}${prefix}/${_infodir}/dir
#    $RM -f ${stagedir}${prefix}/${_bindir}/c++filt
#    $RM -f ${stagedir}${prefix}/${_libdir}/*.la
    $RM -f ${stagedir}${prefix}/${_mandir}/man1/g{dlltool,nlmconv,windres}*
    doc README
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
