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
topdir=bash
version=4.0
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/bash/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]= #
patch[1]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-001
patch[2]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-002
patch[3]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-003
patch[4]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-004
patch[5]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-005
patch[6]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-006
patch[7]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-007
patch[8]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-008
patch[9]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-009
patch[10]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-010
patch[11]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-011
patch[12]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-012
patch[13]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-013
patch[14]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-014
patch[15]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-015
patch[16]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-016
patch[17]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-017
patch[18]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-018
patch[19]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-019
patch[20]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-020
patch[21]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-021
patch[22]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-022
patch[23]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-023
patch[24]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-024
patch[25]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-025
patch[26]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-026
patch[27]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-027
patch[28]=ftp://ftp.sunet.se/pub/gnu/bash/bash-4.0-patches/bash40-028

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
patchdir=$
patch_prefix=-p2

export CPPFLAGS="-I/usr/tgcware/include"
export CC=cc
mipspro=1
irix53 && NO_RQS="-Wl,-no_rqs"
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

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
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
