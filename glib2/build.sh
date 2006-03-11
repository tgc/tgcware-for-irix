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
topdir=glib
version=2.8.6
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export PERL=/usr/tgcware/bin/perl
export PERL_PATH=/usr/tgcware/bin/perl
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --with-libiconv=gnu'
# Override getpwuid_r checking
# The configure test fails but the system does have a POSIX compatible
# getpwuid_r and AFAIK it does work but needs -lpthread for the implementation.
ac_overrides="ac_cv_func_posix_getpwuid_r=yes"

reg prep
prep()
{
    generic_prep
    setdir source
    $GSED -i '/^Libs/s/$/ -lpthread/' glib-2.0.pc.in
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
    ${GSED} -i 's|local/perl|tgcware/perl|' ${stagedir}${prefix}/${_bindir}/glib-mkenums
    doc NEWS README COPYING
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
