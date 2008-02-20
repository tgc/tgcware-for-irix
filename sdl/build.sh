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
topdir=SDL
version=1.2.11
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=sdl-1.2.9-dmedia.patch
patch[1]=sdl-1.2.11-ifdef.patch
patch[2]=sdl-1.2.11-nofvisi.patch
patch[3]=sdl-1.2.11-ogl10.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

[ "$_os" = "irix53" ] && patch[4]=sdl-1.2.11-oldX.patch
#[ "$_os" = "irix53" ] && patch[5]=sdl-1.2.11-force-pth.patch

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-x11-shared=no --enable-dga=no"
#[ "$_os" = "irix53" ] && configure_args="$configure_args --enable-pth"

[ -r $prefix/${_includedir}/X11/extensions/dpms.h ] && { echo "found X.org dpms.h - this will f*ck up the build" ; exit 1 ;}

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
    doc COPYING README-SDL.txt BUGS CREDITS
    ${__cp} -pr ${srcdir}/${topsrcdir}/docs/html ${stagedir}${prefix}/${_vdocdir}
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
