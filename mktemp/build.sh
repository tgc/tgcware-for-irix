#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=mktemp
version=1.5
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

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
    clean stage
    setdir source
    ${GINSTALL} -D -m 0555 -s mktemp ${stagedir}${prefix}/bin/mktemp
    ${GINSTALL} -D -m 0444 mktemp.man ${stagedir}${prefix}/${_mandir}/man1/mktemp.1
    custom_install=1
    generic_install
    doc README RELEASE_NOTES LICENSE
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
