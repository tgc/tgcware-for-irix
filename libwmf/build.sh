#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=libwmf
version=0.2.8.4
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libwmf-0.2.8.4-system-trio.patch
patch[1]=libwmf-0.2.8.4-realloc.patch
patch[2]=libwmf-0.2.8.4-intoverflow.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
[ "$_os" = "irix62" ] && xlib=/usr/lib32 || xlib=/usr/lib
configure_args="--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir} --with-libxml2 --with-sysfontmap=${prefix}/${_sharedir}/fonts/fontmap --with-gsfontmap=${prefix}/${_sharedir}/ghostscript/8.15/lib/Fontmap --with-gsfontdir=${prefix}/${_sharedir}/fonts/default/ghostscript --x-libraries=$xlib"

META_CLEAN="$META_CLEAN ops"

reg prep
prep()
{
    generic_prep
    setdir source
    # This broken piece of crap software has *both* configure.ac and configure.in :(
    ${__rm} -f configure.in
    ${__rm} -rf src/extra/trio
    libtoolize --force --copy
    aclocal-1.9
    automake-1.9 -a -c
    autoheader
    autoconf
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
    ${__rm} -rf ${stagedir}${prefix}/${_libdir}/gtk-2.0
    doc CREDITS COPYING ChangeLog
    ${__mv} ${stagedir}${prefix}/${_sharedir}/doc/libwmf/* ${stagedir}${prefix}/${_vdocdir}
    ${__rmdir} ${stagedir}${prefix}/${_sharedir}/doc/libwmf
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
