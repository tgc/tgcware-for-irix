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
topdir=gtk+
version=2.6.1
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"

META_CLEAN="$META_CLEAN ops"

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
    doc NEWS README
    ${MKDIR} -p ${stagedir}${prefix}/${_sysconfdir}/gtk-2.0
    touch ${stagedir}${prefix}/${_sysconfdir}/gtk-2.0/gdk-pixbuf.loaders
    touch ${stagedir}${prefix}/${_sysconfdir}/gtk-2.0/gtk.immodules
}

reg pack
pack()
{
    # Add ops
    echo "lastop exitop(${prefix}/${_bindir}/gdk-pixbuf-query-loaders > ${prefix}/${_sysconfdir}/gtk-2.0/gdk-pixbuf.loaders && ${prefix}/${_bindir}/gtk-query-immodules-2.0 > ${prefix}/${_sysconfdir}/gtk-2.0/gtk.immodules)" > $metadir/ops
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
