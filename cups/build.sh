#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=cups
version=1.1.23
pkgver=1
source[0]=$topdir-$version-source.tar.bz2
# If there are no patches, simply comment this
patch[0]=cups-1.1.23-pkg.patch
patch[1]=cups-1.1.23-libdir.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"
export DSOFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"

catman=0
gzman=0
topinstalldir=/
pkgdefprefix=usr/local

reg prep
prep()
{
    generic_prep
    autoconf
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install BUILDROOT
    doc CHANGES.txt CGI.txt ENCRYPTION.txt LICENSE.txt README.txt
    ${RM} -rf ${stagedir}${prefix}/${_mandir}/man*
    ${RM} -rf ${stagedir}${prefix}/${_mandir}/*/man*

    # Make cups available when doing chkconfig list and don't start automatically
    ${MKDIR} -p ${stagedir}/${_sysconfdir}/config
    echo "off" >${stagedir}/${_sysconfdir}/config/cups
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
