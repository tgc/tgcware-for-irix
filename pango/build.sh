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
topdir=pango
version=1.8.0
pkgver=2
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib"

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
    # We need to fix up some libtool garbage before installing :(
    setdir source
    cd pango
    perl -pi -e 's|Wl,/usr/people/tgc/build/athena-buildpkg/buildpkg/pango/src/pango-1.8.0/pango/.libs:|Wl,|g' pango-querymodules
    # Done, now install
    generic_install DESTDIR
    doc NEWS README
    # Add empty pango.modules so that the package will own it (it's filled out by ops)
    touch ${stagedir}${prefix}/${_sysconfdir}/pango/pango.modules
}

reg pack
pack()
{
    echo "lastop exitop(${prefix}/${_bindir}/pango-querymodules > ${prefix}/${_sysconfdir}/pango/pango.modules)" > $metadir/ops
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
