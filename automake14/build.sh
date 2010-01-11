#!/usr/local/bin/bash

# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=automake
version=1.4-p6
pkgver=5
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=automake-1.4-libtoolize.patch
patch[1]=automake-1.4-subdir.patch
patch[2]=automake-1.4-backslash.patch
patch[3]=automake-1.4-tags.patch
patch[4]=automake-1.4-subdirs-89656.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export PERL=/usr/tgcware/bin/perl

reg prep
prep()
{
    generic_prep
    setdir source
    autoreconf
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
