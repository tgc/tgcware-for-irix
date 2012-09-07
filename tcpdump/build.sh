#!/usr/tgcware/bin/bash
#
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=tcpdump
version=4.3.0
pkgver=2
source[0]=http://www.tcpdump.org/release/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=tcpdump-4.2.1-timeval.patch
patch[1]=tcpdump-4.3.0-default-snaplen.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-ipv6"

reg prep
prep()
{
    generic_prep
    setdir source
    # We need to prevent the detection of inet_ntop and inet_pton since
    # they're broken on IRIX 6.2
    ${__gsed} -i 's/inet_ntop(AF/inet_ntop_broken(AF/;s/inet_pton(AF/inet_pton_broken(AF/' configure
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
    doc CREDITS LICENSE
    ${__rm} ${stagedir}${prefix}/${_sbindir}/tcpdump.*
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
