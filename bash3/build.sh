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
topdir=bash
version=3.2
pkgver=3
source[0]=bash-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=bash32-001
patch[1]=bash32-002
patch[2]=bash32-003
patch[3]=bash32-004
patch[4]=bash32-005
patch[5]=bash32-006
patch[6]=bash32-007
patch[7]=bash32-008
patch[8]=bash32-009
patch[9]=bash32-010
patch[10]=bash32-011
patch[11]=bash32-012
patch[12]=bash32-013
patch[13]=bash32-014
patch[14]=bash32-015
patch[15]=bash32-016
patch[16]=bash32-017
patch[17]=bash32-018
patch[18]=bash32-019
patch[19]=bash32-020
patch[20]=bash32-021
patch[21]=bash32-022
patch[22]=bash32-023
patch[23]=bash32-024
patch[24]=bash32-025

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
patchdir=$srcfiles
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-rpath"
export CC=cc
[ "$_os" = "irix62" ] && mipspro=1
if [ "$_os" = "irix53" ]; then
    mipspro=2
    LDFLAGS="-Wl,-no_rqs $LDFLAGS"
fi
patch_prefix="-p0"

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
    doc AUTHORS CHANGES COMPAT NEWS POSIX RBASH README COPYING
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
