#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=lzo
version=2.02
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-shared"
[ "$_os" = "irix62" ] && export CC=cc && mipspro=1

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
    $MAKE_PROG check
}

reg install
install()
{
    generic_install DESTDIR
    ${__install} -D -m 755 $srcdir/$topsrcdir/examples/.libs/lzopack ${stagedir}${prefix}/${_bindir}/lzopack
    doc AUTHORS BUGS COPYING NEWS THANKS doc
    custom_install=1
    generic_install
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
