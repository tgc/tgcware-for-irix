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
topdir=neon
version=0.29.0
pkgver=1
source[0]=http://webdav.org/neon/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --with-ssl=gnutls --with-egd=/var/run/egd-pool --disable-static --enable-shared --enable-ld-version-script=no"

reg prep
prep()
{
    generic_prep
    if irix53; then
        setdir source
        # We must "massage" libtool to not try and use the exported_symbol
        # and exports_file options since its use provokes an error from ld
        # export* and hidden* options are mutually exclusive so this will make
        # the linker error out in the feature test
        ${__gsed} -i '/LDFLAGS.*\${wl}-exported_symbol/ s;exported_symbol;exported_symbol \${wl}foo \${wl}-hidden_symbol;' configure
    fi
}

reg build
build()
{
    generic_build
}

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    doc AUTHORS BUGS NEWS README THANKS TODO src/COPYING.LIB test/COPYING
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
