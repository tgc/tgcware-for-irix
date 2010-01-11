#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=pango
version=1.26.0
pkgver=1
source[0]=http://ftp.gnome.org/pub/GNOME/sources/pango/1.26/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=pango-1.20.5-fix-initializers.patch
#patch[1]=pango-1.20.5-no-libtool-rpath.patch
patch[0]=pango-1.26.0-no-stdint_h.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
#export CC=cc
#mipspro=1

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
    # Done, now install
    generic_install DESTDIR
    doc NEWS README COPYING AUTHORS
    # Add empty pango.modules so that the package will own it (it's filled out by ops)
    touch ${stagedir}${prefix}/${_sysconfdir}/pango/pango.modules
    echo "${_bindir}/pango-querymodules exitop(${prefix}/${_bindir}/pango-querymodules > ${prefix}/${_sysconfdir}/pango/pango.modules)" > $metadir/ops

    # libtool won't install these because of DESTDIR
    ${__install} -m755 pango/.libs/pango-querymodules ${stagedir}${prefix}/${_bindir}
    ${__install} -m755 pango-view/.libs/pango-view ${stagedir}${prefix}/${_bindir}

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
    META_CLEAN="$META_CLEAN ops"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
