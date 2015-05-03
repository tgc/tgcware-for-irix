#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=vice
version=2.4
pkgver=2
source[0]=http://prdownloads.sourceforge.net/vice-emu/releases/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=vice-2.4-old-sgi-openGL.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -Wl,-rpath,$prefix/lib"
ac_overrides="ac_cv_lib_socket_gethostbyname=no ac_cv_lib_bsd_gethostbyname=no ac_cv_lib_bsd_gettimeofday=no"
configure_args+=(--enable-sdlui)
export CC=cc
export CXX=CC
mipspro=1

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

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    ${__mkdir} -p ${stagedir}${prefix}/share/doc
    ${__mv} ${stagedir}${prefix}/${_libdir}/vice/doc ${stagedir}${prefix}/${_vdocdir}
    ${__mv} ${stagedir}${prefix}/${_infodir}/vice.txt ${stagedir}${prefix}/${_vdocdir}
    doc README
    ${__rm} -f ${stagedir}${prefix}/${_vdocdir}/vice.{guide,chm,inf,info,hlp}
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
