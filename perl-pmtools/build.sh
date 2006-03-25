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
topdir=pmtools
version=1.01
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
perlpkgname="$(echo $pkgdir|sed -e 's/-/_/g')"
__configure="perl"
configure_args="Makefile.PL"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build_perl
}

reg install
install()
{
    generic_install_perl
    doc README Changes
}

reg pack
pack()
{
    generic_pack_perl
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN pkgdef"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
