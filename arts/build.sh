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
topdir=arts
version=1.4.0
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=arts-1.4.0-sgiaudio.patch
patch[1]=arts-1.4.0-oldaudio.patch
patch[2]=arts-1.4.0-srandom.patch
patch[3]=arts-1.4.0-socklen_t.patch
patch[4]=arts-1.4.0-sched.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include -I/usr/local/qt-3.3/include"
export LDFLAGS="-L/usr/local/lib -rpath /usr/local/lib -L/usr/local/qt-3.3/lib -rpath /usr/local/qt-3.3/lib"
set_configure_args '--prefix=$prefix --disable-rpath'

autonuke=0

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
    # For some reason libgsl.so and libgslpp.so is not installed
    ${CP} $srcdir/$topsrcdir/flow/gslpp/.libs/libgslpp.so.1.0 ${stagedir}${prefix}/${_libdir}
    ${CP} $srcdir/$topsrcdir/flow/gsl/.libs/libgsl.so.1.0 ${stagedir}${prefix}/${_libdir}
    ${CP} $srcdir/$topsrcdir/libltdl/.libs/libltdlc.so.1.0 ${stagedir}${prefix}/${_libdir}
    setdir ${stagedir}${prefix}/${_libdir}
    for i in libgsl libgslpp libltdlc
    do
	 ${LN} -s ${i}.so.1.0 ${i}.so.1
	 ${LN} -s ${i}.so.1.0 ${i}.so
    done
    do_strip
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
