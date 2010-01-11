#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=cairo
version=1.8.8
pkgver=1
source[0]=http://cairographics.org/releases/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=cairo-1.8.4-trio.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-xlib-xrender=no --disable-static"

reg prep
prep()
{
    generic_prep
    setdir source
    # Force linking with -lpthread
    if irix62; then
	${__gsed} -i '/^libcairo_la_LIBADD/s@\(.*\)@\1 -lpthread@' src/Makefile.am
	# Users of libcairo must link with pthread to resolve pthread_* symbols
	${__gsed} -i '/Libs:/s@\(.*\)@\1 -lpthread@' src/cairo.pc.in
    fi
    aclocal -I build
    automake --gnu
    autoheader
    autoconf
}

reg build
build()
{
    generic_build
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
    doc README NEWS COPYING*
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
