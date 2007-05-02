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
topdir=cmus
version=2.0.2
pkgver=2
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=cmus-2.0.2-irix.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --disable-arts"
__configure="bash configure"
check_ac=0

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
#    generic_build
    setdir source
    $__configure $configure_args
    $MAKE_PROG V=2
}

reg install
install()
{
    generic_install DESTDIR
    doc AUTHORS COPYING README
    $MV ${stagedir}${prefix}/${_sharedir}/doc/cmus/* ${stagedir}${prefix}/$_vdocdir
    $RMDIR ${stagedir}${prefix}/${_sharedir}/doc/cmus
    $MV ${stagedir}${prefix}/${_sharedir}/man ${stagedir}${prefix}
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
