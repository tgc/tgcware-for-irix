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
topdir=gnutls
version=1.2.11
pkgver=2
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gnutls-1.2.10-shutrdwr.patch
patch[1]=gnutls-1.2.10-vsnprintf.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

[ "$_os" = "irix53" ] && patch[2]=gnutls-1.2.10-mapfailed.patch
[ "$_os" = "irix53" ] && patch[3]=gnutls-1.2.10-siginterrupt.patch
[ "$_os" = "irix53" ] && patch[4]=gnutls-1.2.10-inet_pton.patch

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-openssl-compatibility"
ac_overrides="ac_cv_func_inet_ntop=no"

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
    doc AUTHORS COPYING COPYING.LIB NEWS README THANKS
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
