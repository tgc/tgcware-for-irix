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
topdir=libpng
version=1.2.24
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=libpng-1.2.22-tgcware.patch
patch[1]=libpng-1.2.22-trio.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

[ "$_os" = "irix53" ] && patch[2]=libpng-1.2.22-norqs.patch

# Global settings
configure_args="-f scripts/makefile.sgi"
__configure="$(basename ${__make})"
[ "$_os" = "irix62" ] && mipspro=1
[ "$_os" = "irix53" ] && mipspro=2

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    ${__cp} scripts/makefile.sgi Makefile
    ${__gsed} -i "/^prefix/s;=.*;=${prefix};" Makefile
    ${__make} 
}

reg install
install()
{
    clean stage
    ${__mkdir} -p ${stagedir}${prefix}
    setdir source
    ${__make} DESTDIR=$stagedir install
    custom_install=1
    generic_install
    doc CHANGES README TODO example.c libpng-$version.txt
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
