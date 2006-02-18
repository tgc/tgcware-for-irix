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
topdir=m4
version=1.4.4
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CC=cc
mipspro=1
[ "$_os" = "irix53" ] && mipspro=2

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
    #clean stage
    #setdir source
    #${MKDIR} -p ${stagedir}${prefix}
    #$MAKE_PROG prefix=${stagedir}${prefix} INSTALL_DATA="$GINSTALL -c -m644" install
    #custom_install=1
    doc ChangeLog NEWS README
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
