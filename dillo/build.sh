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
topdir=dillo
version=0.8.6
pkgver=3
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=dillo-0.8.6-linkorder.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--disable-dlgui)
[ "$_os" = "irix53" ] && configure_args+=(--disable-threaded-dns)

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
    ${__gsed} -i 's|/usr/bin/perl|/usr/tgcware/bin/perl|' ${stagedir}${prefix}/${_bindir}/dpidc
    doc ChangeLog COPYING AUTHORS README
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
