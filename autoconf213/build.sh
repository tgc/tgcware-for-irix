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
topdir=autoconf
version=2.13
pkgver=3
source[0]=autoconf-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=   #autoconf-2.12-race.patch - use /bin/mktemp
patch[1]=autoconf-2.13-mawk.patch
patch[2]=autoconf-2.13-notmp.patch
patch[3]=autoconf-2.13-c++exit.patch
patch[4]=autoconf-2.13-headers.patch
patch[5]=autoconf-2.13-autoscan.patch
patch[6]=autoconf-2.13-exit.patch
patch[7]=autoconf-2.13-wait3test.patch
patch[8]=autoconf-2.13-make-defs-62361.patch
patch[9]=autoconf-2.13-versioning.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
shortroot=1
set_configure_args '--prefix=$prefix --program-suffix=-$version'

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
    generic_install prefix
    ${RM} -rf ${stagedir}${prefix}/${_infodir}
    doc AUTHORS COPYING NEWS README TODO
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
