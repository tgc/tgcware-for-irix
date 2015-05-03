#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=Python
version=2.7.1
pkgver=1
source[0]=http://www.python.org/ftp/python/$version/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=Python-2.4.2-tgcware.patch
patch[1]=Python-2.4.3-irix-shared.patch
patch[2]=Python-2.7.1-linker.patch
patch[3]=Python-2.7.1-ncurses.patch
patch[4]=Python-2.7.1-irixld.patch
patch[5]=Python-2.7.1-mmap.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
# -L. is hack to link with the yet to be installed libpython.so
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L."
export CC=gcc
export CXX=g++
export LDSHARED="$CC -shared -all"
unset SGI_ABI
ac_overrides="ac_cv_lib_socket_socket=no"
configure_args="$configure_args --enable-shared --disable-ipv6 --with-system-expat"

reg prep
prep()
{
    generic_prep
    setdir source
#    irix53 && ${__gsed} -i 's/N32//' configure.in
    irix62 && ${__gsed} -i '/set_version/ s/SHLIBS)/SHLIBS) -lpthread/g' Makefile.pre.in
    # defeat autoconf version check
    ${__gsed} -i '/^version_required/ s/([0-9.]*)/(2.68)/' configure.in
    autoreconf
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
