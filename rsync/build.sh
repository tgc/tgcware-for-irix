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
topdir=rsync
version=2.6.9
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CPPFLAGS="-I/usr/tgcware/include"
configure_args='--prefix=${prefix} --mandir=${prefix}/${_mandir} --with-rsyncd-conf=${prefix}/${_sysconfdir}/rsyncd.conf --disable-ipv6'
[ "$_os" = "irix62" ] && ac_overrides="ac_cv_func_inet_pton=no ac_cv_func_inet_ntop=no"

[ "$_os" = "irix53" ] && export CC=cc && mipspro=2
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
}

reg install
install()
{
    generic_install DESTDIR
    doc NEWS README TODO COPYING
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
