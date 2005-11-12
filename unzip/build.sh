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
topdir=unzip
version=5.52
pkgver=2
source[0]=${topdir}552.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global options
shortroot=1
mipspro=1

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    ${LN} -s unix/Makefile Makefile
    $MAKE_PROG sgi
}

reg install
install()
{
    generic_install prefix
    doc README BUGS LICENSE ToDo
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
