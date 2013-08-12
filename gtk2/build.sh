#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gtk+
version=2.16.6
pkgver=1
source[0]=http://ftp.gnome.org/pub/gnome/sources/gtk+/2.16/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gtk+-2.16.6-use-g_snprintf.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--disable-visibility)

reg prep
prep()
{
    generic_prep
    setdir source
    ${__gsed} -i 's/hardcode_into_libs=yes/hardcode_into_libs=no/g' configure
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
    doc NEWS README COPYING
    ${__mkdir} -p ${stagedir}${prefix}/${_sysconfdir}/gtk-2.0
    touch ${stagedir}${prefix}/${_sysconfdir}/gtk-2.0/gdk-pixbuf.loaders
    touch ${stagedir}${prefix}/${_sysconfdir}/gtk-2.0/gtk.immodules
    # Add ops
    echo "${_bindir}/gdk-pixbuf-query-loaders exitop(${prefix}/${_bindir}/gdk-pixbuf-query-loaders > ${prefix}/${_sysconfdir}/gtk-2.0/gdk-pixbuf.loaders)" > $metadir/ops
    echo "${_bindir}/gtk-query-immodules-2.0 exitop(${prefix}/${_bindir}/gtk-query-immodules-2.0 > ${prefix}/${_sysconfdir}/gtk-2.0/gtk.immodules)" >> $metadir/ops

    # libtool won't install these because of DESTDIR
    ${__install} -m755 gdk-pixbuf/.libs/gdk-pixbuf-csource ${stagedir}${prefix}/${_bindir}
    ${__install} -m755 gdk-pixbuf/.libs/gdk-pixbuf-query-loaders ${stagedir}${prefix}/${_bindir}
    ${__install} -m755 gtk/.libs/gtk-query-immodules-2.0 ${stagedir}${prefix}/${_bindir}
    ${__install} -m755 gtk/.libs/gtk-update-icon-cache ${stagedir}${prefix}/${_bindir}
    ${__install} -m755 demos/gtk-demo/.libs/gtk-demo ${stagedir}${prefix}/${_bindir}

    custom_install=1
    generic_install DESTDIR
}

reg check
check()
{
    generic_check
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN ops"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
