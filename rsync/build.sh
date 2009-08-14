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
topdir=rsync
version=3.0.6
pkgver=1
source[0]=http://www.samba.org/ftp/rsync/src/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
configure_args='--prefix=${prefix} --mandir=${prefix}/${_mandir} --with-rsyncd-conf=${prefix}/${_sysconfdir}/rsyncd.conf --disable-ipv6 --disable-acl-support'
export CC=cc
if [ "$_os" = "irix62" ]; then
    ac_overrides="ac_cv_func_inet_pton=no ac_cv_func_inet_ntop=no"
    mipspro=1
fi
if [ "$_os" = "irix53" ]; then
    mipspro=0
    export CC=gcc
    NO_RQS="-Wl,-no_rqs"
fi
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

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
    doc NEWS README TODO COPYING
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
