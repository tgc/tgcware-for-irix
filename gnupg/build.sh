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
topdir=gnupg
version=1.4.0
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -rpath /usr/local/lib"

RNG="--enable-static-rnd=egd --with-egd-socket=/var/run/egd-pool"

set_configure_args '--prefix=$prefix --enable-nls --disable-rpath $RNG'

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
    doc AUTHORS COPYING NEWS PROJECTS README THANKS TODO
    ${MV} ${stagedir}${prefix}/${_sharedir}/${name}/* ${stagedir}${prefix}/${_vdocdir}
    ${MV} ${stagedir}${prefix}/${_vdocdir}/options.skel ${stagedir}${prefix}/${_sharedir}/${name}/
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
