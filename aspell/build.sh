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
topdir=aspell
version=0.60.2
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=aspell-0.60.2-trio.patch
patch[1]=aspell-0.60.2-includes.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"
set_configure_args '--prefix=$prefix --enable-docdir=$prefix/${_vdocdir} --disable-nls'

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9 -I m4
    autoheader
    autoconf
    cd gen
    # trio.h includes config.h to pick up autoconf defines
    ${LN} -s settings.h config.h
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
    ${RM} -f ${stagedir}${prefix}/${_libdir}/${topdir}-0.60/*.la
    ${MV} ${stagedir}${prefix}/${_libdir}/${topdir}-0.60/*spell ${stagedir}${prefix}/${_bindir}
    doc COPYING README
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
