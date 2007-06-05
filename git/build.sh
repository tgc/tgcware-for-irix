#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=git
version=1.5.2.1
pkgver=1
source[0]=$topdir-$version.tar.bz2
source[1]=$topdir-manpages-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=git-1.5.2.1-shell.patch
patch[1]=git-1.5.2.1-flags.patch
patch[2]=git-1.5.2.1-trio.patch
patch[3]=git-1.5.2.1-unsetenv.patch
patch[4]=git-1.5.2.1-strtoumax.patch
patch[5]=git-1.5.2.1-socklen_t.patch
patch[6]=git-1.5.2.1-perl.patch
patch[7]=git-1.5.2.1-symlink.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=gcc

reg prep
prep()
{
    generic_prep
    setdir source
    ${MAKE_PROG} configure
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
    setdir ${stagedir}${prefix}/${_mandir}
    ${TAR} -xjf $srcfiles/${source[1]}
    doc COPYING Documentation/RelNotes-${version}.txt README
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
