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
topdir=zlib
version=1.2.5
pkgver=1
source[0]=http://zlib.net/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=zlib-1.2.5-irixcc.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
configure_args=(--shared --prefix=$prefix) 
check_ac=0
shortroot=1
mipspro=1
export CC=cc
make_check_target=test

reg prep
prep()
{
    generic_prep

    setdir source
    ${__gsed} -i 's/^off64_t/no_off64_t/' configure
    irix53 && ${__gsed} -i '/woff,84/ s/shared/shared -Wl,-no_rqs/' configure
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
    doc README ChangeLog minigzip.c example.c FAQ doc
    ${__mv} ${stagedir}${prefix}/share/${_mandir} ${stagedir}${prefix}
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/libz.a
}

reg check
check()
{
    generic_check
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
