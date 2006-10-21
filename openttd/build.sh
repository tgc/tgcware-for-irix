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
topdir=openttd
version=0.4.8
pkgver=1
source[0]=$topdir-$version-source.tar.bz2
# If there are no patches, simply comment this
patch[0]=openttd-0.4.5-compat.patch
patch[1]=openttd-0.4.7-pause.patch
patch[2]=openttd-0.4.8-makefile.patch
patch[3]=openttd-0.4.8-sa_len.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CC=gcc
configure_args="CC=gcc CFLAGS=\"-I/usr/tgcware/include -I/usr/tgcware/include/SDL\" INSTALL=1 PREFIX=$prefix BINARY_DIR=${_bindir} USE_HOMEDIR=1 ICON_DIR=${_sharedir}/pixmaps LDFLAGS=\"-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -ltrio\" DATA_DIR=share/openttd PERSONAL_DIR=.openttd"
__configure=$MAKE_PROG

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $MAKE_PROG CC=gcc CFLAGS="-I/usr/tgcware/include -I/usr/tgcware/include/SDL" INSTALL=1 PREFIX=$prefix BINARY_DIR=${_bindir} USE_HOMEDIR=1 ICON_DIR=${_sharedir}/pixmaps LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -ltrio" DATA_DIR=share/openttd PERSONAL_DIR=.openttd VERBOSE=1
}

reg install
install()
{
    generic_install DESTDIR
    doc COPYING readme.txt
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
