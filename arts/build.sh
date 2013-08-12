#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=arts
version=1.5.7
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=arts-1.5.7-oldapi.patch
patch[1]=arts-1.4.0-oldaudio.patch
patch[2]=arts-1.5.7-srandom.patch
patch[3]=arts-1.5.7-socklen_t.patch
patch[4]=arts-1.4.0-sched.patch
patch[5]=arts-1.5.0-check_tmp_dir.patch
patch[6]=arts-1.5.0-assert.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/qt-3.3/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/qt-3.3/lib -Wl,-rpath,/usr/tgcware/qt-3.3/lib"
configure_args=(--prefix=$prefix --enable-libsuffix= --disable-rpath --disable-pie --with-extra-includes=/usr/tgcware/include --with-extra-libs=/usr/tgcware/lib)

autonuke=0

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
