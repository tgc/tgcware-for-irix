#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=libpcap
version=1.3.0
pkgver=2
source[0]=http://www.tcpdump.org/release/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libpcap-1.3.0-broken-SIOCGIFMTU.patch
patch[1]=libpcap-1.3.0-irix-shared.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=cc
mipspro=1
configure_args+=(--disable-ipv6)

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
    doc LICENSE CHANGES CREDITS TODO
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
