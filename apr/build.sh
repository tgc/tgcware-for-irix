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
topdir=apr
version=1.2.8
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
aprver=1
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --includedir=${prefix}/${_includedir}/apr-${aprver} --with-installbuilddir=${prefix}/${_libdir}/apr-${aprver}/build --with-egd=/var/run/egd-pool"

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
    $MAKE_PROG dox
}

reg install
install()
{
    generic_install DESTDIR
    doc CHANGES LICENSE NOTICE docs/APRDesign.html docs/canonical_filenames.html docs/incomplete_types docs/non_apr_programs
    $MKDIR -p ${stagedir}${prefix}/${_vdocdir}/html
    $GINSTALL -m 644 $srcdir/$topsrcdir/docs/dox/html/* ${stagedir}${prefix}/${_vdocdir}/html
    $RM -f ${stagedir}${prefix}/${_libdir}/apr.exp
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
