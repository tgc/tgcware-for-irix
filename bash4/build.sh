#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=bash
real_version=4.0
patch_level=44
version=${real_version}.${patch_level}
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/bash/$topdir-$real_version.tar.gz
# If there are no patches, simply comment this
patch[0]= #
patch[1]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-001
patch[2]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-002
patch[3]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-003
patch[4]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-004
patch[5]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-005
patch[6]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-006
patch[7]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-007
patch[8]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-008
patch[9]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-009
patch[10]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-010
patch[11]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-011
patch[12]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-012
patch[13]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-013
patch[14]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-014
patch[15]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-015
patch[16]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-016
patch[17]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-017
patch[18]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-018
patch[19]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-019
patch[20]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-020
patch[21]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-021
patch[22]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-022
patch[23]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-023
patch[24]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-024
patch[25]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-025
patch[26]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-026
patch[27]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-027
patch[28]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-028
patch[29]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-029
patch[30]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-030
patch[31]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-031
patch[32]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-032
patch[33]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-033
patch[34]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-034
patch[35]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-035
patch[36]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-036
patch[37]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-037
patch[38]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-038
patch[39]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-039
patch[40]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-040
patch[41]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-041
patch[42]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-042
patch[43]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-043
patch[44]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-044

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
patchdir=$srcfiles
patch_prefix=-p0
topsrcdir=$topdir-$real_version

export CPPFLAGS="-I/usr/tgcware/include"
export CC=cc
mipspro=1
irix53 && NO_RQS="-Wl,-no_rqs"
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

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
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
