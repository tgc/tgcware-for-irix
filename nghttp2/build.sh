#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=nghttp2
version=0.3.2
pkgver=1
source[0]=https://github.com/tatsuhiro-t/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions
# Global settings
mipspro=1
export CC=cc
export CPPFLAGS="-I/usr/tgcware/include/openssl -I/usr/tgcware/include"
export LDFLAGS="-Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/lib $NO_RQS"
configure_args+=(--enable-maintainer-mode=no --disable-static)

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
