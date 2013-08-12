#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=Python
version=2.4.6
pkgver=2
source[0]=http://www.python.org/ftp/python/2.4.6/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=Python-2.4.2-tgcware.patch
patch[1]=Python-2.4.3-irix-shared.patch
patch[2]=Python-2.4.3-linker.patch
patch[3]=Python-2.4.4-ncurses.patch
patch[4]=Python-2.4.3-irixld.patch
patch[5]=Python-2.4.3-cppflags.patch
patch[6]=Python-2.4.3-ldflags.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=gcc
export CXX=g++
export LDSHARED="$CC -shared -all"
unset SGI_ABI
ac_overrides="ac_cv_lib_socket_socket=no"
configure_args+=(--enable-shared --disable-ipv6)

reg prep
prep()
{
    generic_prep
    setdir source
    irix53 && ${__gsed} -i 's/N32//' configure.in
    irix62 && ${__gsed} -i '/set_version/ s/SHLIBS)/SHLIBS) -lpthread/g' Makefile.pre.in
    autoheader
    autoconf
}

reg build
build()
{
    generic_build
}

reg check
check()
{
    setdir source
    ${__make} test
}

reg install
install()
{
    generic_install DESTDIR
    doc README LICENSE Misc/NEWS
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
