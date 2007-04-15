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
topdir=libwmf
version=0.2.8.4
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libwmf-0.2.8.4-system-trio.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

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
    ${RM} -f configure.in
    ${RM} -rf src/extra/trio
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
    ${RM} -f ${stagedir}${prefix}/${_libdir}/gtk-2.0/*/loaders/*.{a,la}
    doc CREDITS COPYING ChangeLog
    ${MV} ${stagedir}${prefix}/${_sharedir}/doc/libwmf/* ${stagedir}${prefix}/${_vdocdir}
    ${RMDIR} ${stagedir}${prefix}/${_sharedir}/doc/libwmf

    # Add ops
    echo "lastop exitop(${prefix}/${_bindir}/gdk-pixbuf-query-loaders > ${prefix}/${_sysconfdir}/gtk-2.0/gdk-pixbuf.loaders)" > $metadir/ops
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
