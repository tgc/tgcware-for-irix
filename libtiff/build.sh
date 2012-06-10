#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=tiff
version=3.9.6
pkgver=1
source[0]=ftp://ftp.remotesensing.org/pub/libtiff/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=tiff-3.9.6-trio.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
[ "$_os" = "irix62" ] && xlib=/usr/lib32 || xlib=/usr/lib
configure_args='--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir} --with-zlib-include-dir=/usr/tgcware/include --with-zlib-lib-dir=/usr/tgcware/lib --with-jpeg-include-dir=/usr/tgcware/include --with-jpeg-lib-dir=/usr/tgcware/lib --disable-cxx --x-libraries=$xlib'

reg prep
prep()
{
    generic_prep
    # "Fix" libtool
    setdir source
    ${__gsed} -i 's/fast_install=no/fast_install=yes/g' configure
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
    doc COPYRIGHT
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
