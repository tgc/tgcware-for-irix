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
topdir=nano
version=1.2.5
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

[ "$_os" = "irix53" ] && patch[0]=nano-1.2.5-regex.patch
[ "$_os" = "irix53" ] && patch[1]=nano-1.2.5-usleep.patch

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/include/ncurses"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --enable-all --with-libiconv-prefix=$prefix --with-glib-prefix=$prefix"

reg prep
prep()
{
    generic_prep
    if [ "$_os" = "irix53" ]; then
	setdir source
	aclocal-1.9 -I m4
	automake-1.9 --gnu
	autoheader
	autoconf
    fi
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
    doc COPYING NEWS
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
