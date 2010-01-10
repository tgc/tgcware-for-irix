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
topdir=binutils
version=2.20
pkgver=2
source[0]=ftp://ftp.sunet.se/pub/gnu/binutils/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CONFIG_SHELL=/bin/ksh
configure_args="$configure_args --disable-nls --disable-werror"

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
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man1/{dlltool,nlmconv,windres,windmc}*
    doc COPYING*
    setdir ${stagedir}${prefix}/${_libdir}
    if [ -d ../lib32 ]; then
	${__mv} ../lib32/*.a .
	${__rmdir} ../lib32
    fi

    setdir ${stagedir}${prefix}/${_bindir}
    # Remove known not working
    ${__rm} -f ld strip

    # Not strictly needed for 6.2 so don't ship them
    irix62 && ${__rm} -f ar nm objcopy

    # Turn the rest into symlinks
    for p in $(ls 2>/dev/null); do
	${__ln} -sf ${prefix}/mips-sgi-${os}/bin/$p $p
    done

    # Make compat symlink for gcc packages (on 6.2)
    irix62 && ${__ln} -s ${prefix}/mips-sgi-${os}/bin/as gas
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
