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
topdir=findutils
version=4.2.27
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=findutils-4.2.27-mbchar.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --disable-rpath --with-libiconv-prefix=/usr/tgcware --with-lintl-prefix=/usr/tgcware"

if [ "$_os" = "irix53" ]; then
    export CC=cc
    mipspro=2
fi

reg prep
prep()
{
    generic_prep
    aclocal-1.9 -I gnulib/m4 -I m4
    automake-1.9 --gnits
    autoconf
    autoheader
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
    ${RMDIR} ${stagedir}${prefix}/var
    doc AUTHORS COPYING NEWS README THANKS TODO
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
