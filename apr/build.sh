#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=apr
version=1.3.8
pkgver=1
source[0]=http://mirrors.dotsrc.org/apache/apr/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=apr-1.3.5-fix-testsuite.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
aprver=1
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-static --includedir=${prefix}/${_includedir}/apr-${aprver} --with-installbuilddir=${prefix}/${_libdir}/apr-${aprver}/build --with-egd=/var/run/egd-pool"
irix53 && configure_args="$configure_args --disable-threads"

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
    ${__make} dox
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
    doc CHANGES LICENSE NOTICE docs/APRDesign.html docs/canonical_filenames.html docs/incomplete_types docs/non_apr_programs
    ${__mkdir} -p ${stagedir}${prefix}/${_vdocdir}/html
    ${__install} -m 644 $srcdir/$topsrcdir/docs/dox/html/* ${stagedir}${prefix}/${_vdocdir}/html
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/apr.exp
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
