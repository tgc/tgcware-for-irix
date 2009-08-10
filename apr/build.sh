#!/bin/bash
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
topdir=apr
version=1.3.8
pkgver=1
source[0]=http://mirrors.dotsrc.org/apache/apr/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=apr-1.3.5-fix-testsuite.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
aprver=1
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-static --includedir=${prefix}/${_includedir}/apr-${aprver} --with-installbuilddir=${prefix}/${_libdir}/apr-${aprver}/build --with-egd=/var/run/egd-pool"
irix53 && configure_args="$configure_args --disable-threads"

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
    ${__make} dox
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
    doc CHANGES LICENSE NOTICE docs/APRDesign.html docs/canonical_filenames.html docs/incomplete_types docs/non_apr_programs
    ${__mkdir} -p ${stagedir}${prefix}/${_vdocdir}/html
    ${__install} -m 644 $srcdir/$topsrcdir/docs/dox/html/* ${stagedir}${prefix}/${_vdocdir}/html
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/apr.exp
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
