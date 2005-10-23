#!/usr/local/bin/bash

# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=automake
version=1.7.9
pkgver=3
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export PERL=/usr/tgcware/bin/perl

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
    ${RM} -rf ${stagedir}${prefix}/${_infodir}
    ${RM} -f ${stagedir}${prefix}/${_bindir}/{automake,aclocal}
    doc AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS TODO
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
