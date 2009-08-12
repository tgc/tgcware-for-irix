#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# Copyright (C) 2003-2009 Tom G. Christensen <tgc@jupiterrise.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Written by Tom G. Christensen <tgc@jupiterrise.com>.

# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=curl
version=7.19.6
pkgver=1
source[0]=http://curl.haxx.se/download/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=curl-7.17.1-pkgconfig.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
mipspro=1
export CC=cc
if irix53; then
    export CPP="cc -acpp -E"
    NO_RQS="-Wl,-no_rqs"
fi
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-static=no --enable-http --enable-ftp --enable-file --disable-ldap --enable-manual --disable-ipv6 --enable-cookies --enable-crypto --with-egd-socket=/var/run/egd-pool --with-libidn"
make_check_target="test"

reg prep
prep()
{
    generic_prep
    # We can't use inet_pton on Irix 6.2 even though it's in libc.
    setdir source
    ${__gsed} -i '/inet_pton \\/d' configure
    # Disable building/installing examples, they depend on snprintf
    ${__gsed} -i 's/examples//' docs/Makefile.in
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
    doc CHANGES COPYING README* RELEASE-NOTES docs/FAQ docs/FEATURES docs/BUGS \
      docs/MANUAL docs/RESOURCES docs/TODO docs/TheArtOfHttpScripting \
      docs/examples/*.c docs/examples/Makefile.example docs/INTERNALS \
      docs/CONTRIBUTE

    # Install libcurl.m4
    ${__install} -D -m 644 docs/libcurl/libcurl.m4 ${stagedir}${prefix}/${_sharedir}/aclocal/libcurl.m4

    # Install curl binary
    # This is a terrible hack but libtool won't install it because libcurl
    # was not in it's final destination :(
    ${__rm} -f ${stagedir}${prefix}/${_bindir}/curl
    ${__install} -D -m 755 src/.libs/curl ${stagedir}${prefix}/${_bindir}/curl
}

reg check
check()
{
    generic_check
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
