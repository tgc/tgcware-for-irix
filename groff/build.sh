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
topdir=groff
version=1.19.2
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=groff-1.19-inttypes-irix53.patch
patch[1]=groff-1.19.2-nroff-shell.patch
patch[2]=groff-1.19.2-getopt.patch
patch[3]=groff-1.19.2-path.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
# This package has a shallow stagedir
shortroot=1
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --with-x=no"
# Glem alt om mipspro, det bygger fint men programmerne virker ikke
#export CC=gcc
#export CXX=g++
#[ "$_os" = "irix53" ] && export CXX=g++ && mipspro=2
#[ "$_os" = "irix62" ] && mipspro=1

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
    generic_install prefix
    doc ChangeLog NEWS PROBLEMS PROJECTS TODO COPYING LICENSE
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
