#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=zip
version=2.31
pkgver=3
source[0]=${topdir}231.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
shortroot=1
[ "$_os" = "irix62" ] && mipspro=1
[ "$_os" = "irix53" ] && mipspro=2

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    ${__ln} -s unix/Makefile Makefile
    ${__make} generic
}

reg install
install()
{
    export INSTALL=cp
    generic_install prefix
    doc README BUGS TODO WHATSNEW WHERE LICENSE
    doc proginfo/algorith.txt
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
