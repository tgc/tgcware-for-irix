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
topdir=openldap
version=2.3.21
pkgver=2
source[0]=$topdir-$version.tgz
# If there are no patches, simply comment this
patch[0]=openldap-2.3.21-find-needs-print.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

[ "$_os" = "irix53" ] && patch[1]=openldap-2.3.21-pcreposix.patch

# Global settings
export CC=gcc
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir} --disable-slapd --disable-slurpd'
[ "$_os" = "irix62" ] && ac_overrides="ac_cv_func_inet_ntop=no"

reg prep
prep()
{
    generic_prep
    if [ "$_os" = "irix53" ]; then
	setdir source
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
    doc ANNOUNCEMENT CHANGES COPYRIGHT LICENSE
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
