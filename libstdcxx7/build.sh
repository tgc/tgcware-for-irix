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
topdir=libstdcxx_7
version=1
pkgver=1
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
gcc=4.3.4
[ "$_os" = "irix53" ] && gcc=3.4.6
version=$gcc

reg prep
prep()
{
    : nothing to prep
}

reg build
build()
{
    : nothing to build
}

reg install
install()
{
    echo "BuildRequires: tgc_gcc $gcc"
    clean stage
    ${__mkdir} -p ${stagedir}${prefix}/$_libdir
    [ "$_os" = "irix62" ] && libsuffix=32
    (cd $prefix/gcc-$gcc/${_libdir}${libsuffix}; ${__tar} -cf - libstdc++.so.7*) |
    (cd ${stagedir}${prefix}/${_libdir}; ${__tar} -xvpf -)

    # fix up relnotes
    ${__sed} -e "s/@@GCCVER@@/$gcc/" ${metadir}/relnotes > ${metadir}/relnotes.$_os.txt
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN relnotes.$_os.txt"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
