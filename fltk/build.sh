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
topdir=fltk
version=1.1.7
pkgver=1
source[0]=$topdir-$version-source.tar.bz2
# If there are no patches, simply comment this
patch[0]=fltk-1.1.6-fontconfig.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args=(--prefix=$prefix --enable-shared --enable-thread --enable-xft)

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
    doc ANNOUNCEMENT CHANGES COPYING CREDITS README
    # Clean up the madness :(
    ${RM} -rf ${stagedir}${prefix}/${_mandir}/cat*
    ${MV} ${stagedir}${prefix}/${_docdir}/${topdir} ${stagedir}${prefix}/${_vdocdir}/html
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
