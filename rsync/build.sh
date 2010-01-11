#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=rsync
version=3.0.6
pkgver=1
source[0]=http://www.samba.org/ftp/rsync/src/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
configure_args='--prefix=${prefix} --mandir=${prefix}/${_mandir} --with-rsyncd-conf=${prefix}/${_sysconfdir}/rsyncd.conf --disable-ipv6 --disable-acl-support'
export CC=cc
if [ "$_os" = "irix62" ]; then
    ac_overrides="ac_cv_func_inet_pton=no ac_cv_func_inet_ntop=no"
    mipspro=1
fi
if [ "$_os" = "irix53" ]; then
    mipspro=0
    export CC=gcc
    NO_RQS="-Wl,-no_rqs"
fi
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

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

reg check
check()
{
    generic_check
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
