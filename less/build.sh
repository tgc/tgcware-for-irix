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
topdir=less
version=409
pkgver=1
source[0]=$topdir-$version.tar.gz
source[1]=lesspipe.sh
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CC=cc
mipspro=1
if [ "$_os" = "irix53" ]; then
    mipspro=2
    export LDFLAGS="-Wl,-no_rqs"
fi
configure_args="$configure_args --with-editor=/bin/vi"

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
    generic_install DESTDIR
    ${__install} -m 755 ${srcdir}/${source[1]} ${stagedir}${prefix}/${_bindir}
    doc NEWS LICENSE README COPYING
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
