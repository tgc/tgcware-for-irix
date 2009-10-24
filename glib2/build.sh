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
topdir=glib
version=2.20.5
pkgver=1
source[0]=http://ftp.gnome.org/pub/gnome/sources/glib/2.20/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=glib-2.18.2-no-pthread.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export PERL=/usr/tgcware/bin/perl
export PERL_PATH=/usr/tgcware/bin/perl
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --with-pcre=system --with-libiconv=gnu"
# Don't build with pth on 5.3
[ "$_os" = "irix53" ] && configure_args="$configure_args --with-threads=none"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
    setdir source
    ${__make} README
}

reg install
install()
{
    generic_install DESTDIR
    ${__gsed} -i 's|local/perl|tgcware/perl|' ${stagedir}${prefix}/${_bindir}/glib-mkenums
    doc NEWS README COPYING
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
