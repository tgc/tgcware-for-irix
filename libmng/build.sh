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
topdir=libmng
version=1.0.9
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir}"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    # We need sed, automake, autoconf and libtool for this one
    setdir source
    $GSED -i "s/\r//" unmaintained/autogen.sh
    $GSED -i "s/\.\/configure/#\.\/configure/" unmaintained/autogen.sh
    $GSED -i "/^aclocal/s|aclocal|aclocal-1.9|" unmaintained/autogen.sh
    $GSED -i "/^automake/s|automake|automake-1.9|" unmaintained/autogen.sh
    $SHELL unmaintained/autogen.sh
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    doc doc/libmng.txt doc/doc.readme doc/*.png
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
