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
topdir=libjpeg
version=6b
pkgver=7
source[0]=jpegsrc.v6b.tar.gz
# If there are no patches, simply comment this
patch[0]=jpeg-c++.patch
patch[1]=libjpeg-6b-arm.patch
patch[2]=libjpeg-6b-soname.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
check_ac=0
shortroot=1
mipspro=1
topsrcdir=jpeg-$version
configure_args='--prefix=$prefix --disable-static --enable-shared'
export LDFLAGS='-rpath /usr/tgcware/lib'
export INSTALL="/usr/tgcware/bin/install -c -D"
export CC=cc

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $__configure $(_upls $configure_args)
    LD_LIBRARY_PATH=$PWD $MAKE_PROG test
    $MAKE_PROG
}

reg install
install()
{
    generic_install prefix
    doc README usage.doc
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
