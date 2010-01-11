#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=glib
version=2.20.5
pkgver=1
source[0]=http://ftp.gnome.org/pub/gnome/sources/glib/2.20/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=glib-2.18.2-no-pthread.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export PERL=/usr/tgcware/bin/perl
export PERL_PATH=/usr/tgcware/bin/perl
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --with-pcre=system --with-libiconv=gnu"
# Don't build with pth on 5.3
[ "$_os" = "irix53" ] && configure_args="$configure_args --with-threads=none"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
    setdir source
    ${__make} README
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
    ${__gsed} -i 's|local/perl|tgcware/perl|' ${stagedir}${prefix}/${_bindir}/glib-mkenums
    doc NEWS README COPYING

    # Libtool won't install these because of DESTDIR
    ${__install} -m755 gobject/.libs/gobject-query ${stagedir}${prefix}/${_bindir}
    ${__install} -m755 gobject/.libs/glib-genmarshal ${stagedir}${prefix}/${_bindir}
    ${__install} -m755 glib/.libs/gtester ${stagedir}${prefix}/${_bindir}

    # Rerun strip etc.
    custom_install=1
    generic_install DESTDIR
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
