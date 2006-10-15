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
topdir=bash
version=3.2
pkgver=1
source[0]=bash-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
patchdir=$srcfiles
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --disable-rpath"
export CC=cc
[ "$_os" = "irix62" ] && mipspro=1
[ "$_os" = "irix53" ] && mipspro=2

reg prep
prep()
{
    generic_prep
# No patches for 3.2 yet
#    clean source
#    unpack 0
#    for ((i=0; i<patchcount; i++))
#    do
#	patch $i -p0
#    done
    setdir source
    $RM -f po/ru.po
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
    doc AUTHORS CHANGES COMPAT NEWS POSIX RBASH README COPYING
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
