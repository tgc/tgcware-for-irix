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
topdir=aspell
version=0.60.5
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=aspell-0.60.2-trio.patch
patch[1]=aspell-0.60.2-includes.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args=(--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir} --enable-docdir=$prefix/${_vdocdir})

reg prep
prep()
{
    generic_prep
    setdir source
    aclocal-1.9 -I m4
    automake-1.9
    autoconf
    autoheader
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
    ${GSED} -i 's|/usr/bin/perl|/usr/tgcware/bin/perl|' ${stagedir}${prefix}/${_bindir}/aspell-import
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
