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
topdir=bash
version=3.0
pkgver=1
source[0]=bash-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=bash30-001
patch[1]=bash30-002
patch[2]=bash30-003
patch[3]=bash30-004
patch[4]=bash30-005
patch[5]=bash30-006
patch[6]=bash30-007
patch[7]=bash30-008
patch[8]=bash30-009
patch[9]=bash30-010
patch[10]=bash30-011
patch[11]=bash30-012
patch[12]=bash30-013
patch[13]=bash30-014
patch[14]=bash30-015
patch[15]=bash30-016

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
patchdir=$srcfiles
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=cc
configure_args="--prefix=$prefix --disable-rpath"
mipspro=1

reg prep
prep()
{
    clean source
    unpack 0
    for ((i=0; i<patchcount; i++))
    do
	patch $i -p0
    done
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
    ${RM} -f ${stagedir}${prefix}/${_infodir}/dir
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
