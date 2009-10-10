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
topdir=sqlite
version=3.6.18
pkgver=1
source[0]=http://www.sqlite.org/${topdir}-${version}.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/include/readline"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-static --enable-threadsafe=no --disable-tcl"

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

reg check
check()
{
    setdir source
    ${__make} -k test
}

reg install
install()
{
    generic_install DESTDIR

    setdir source
    # Install sqlite3 binary
    # This is a terrible hack but libtool won't install it because libsqlite3
    # was not in it's final destination :(
    ${__rm} -f ${stagedir}${prefix}/${_bindir}/sqlite3
    ${__install} -D -m 755 .libs/sqlite3 ${stagedir}${prefix}/${_bindir}/sqlite3

    # install manpage
    ${__mkdir} -p ${stagedir}${prefix}/${_mandir}/man1
    ${__install} -m644 sqlite3.1 ${stagedir}${prefix}/${_mandir}/man1
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
