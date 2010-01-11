#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=libpcap
version=0.9.4
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libpcap-shared.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
major=0
minor=9
subminor=4

reg prep
prep()
{
    generic_prep
    setdir source
    $GSED -e "/^MAJOR/s|\$(LIBMAJOR)|$major|" -e "/^MINOR/s|\$(LIBMINOR)|$minor|" -e "/^SUBMINOR/s|\$(LIBSUBMINOR)|$subminor|" Makefile.in > Makefile.in.new
    $MV Makefile.in.new Makefile.in
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
    doc LICENSE CHANGES CREDITS TODO
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
