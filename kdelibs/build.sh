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
topdir=kdelibs
version=3.4.0
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=kdelibs-3.4.0-srandom.patch
patch[1]=kdelibs-3.4.0-trio.patch
patch[2]=kdelibs-3.4.0-maxdname.patch
patch[3]=kdelibs-3.4.0-undef_inet.patch
patch[4]=kdelibs-3.4.0-socklen_t.patch
patch[5]=kdelibs-3.4.0-ksocklen_t.patch
patch[6]=kdelibs-3.4.0-getnameinfo.patch
patch[7]=kdelibs-3.4.0-in_addr_t.patch
patch[8]=kdelibs-3.4.0-nameclash.patch
patch[9]=kdelibs-3.4.0-shutrdwr.patch
patch[10]=kdelibs-3.4.0-noconfig.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include -I/usr/local/qt-3.3/include"
export LDFLAGS="-Wl,-v -L/usr/local/lib -Wl,-rpath,/usr/local/lib -L/usr/local/qt-3.3/lib -Wl,-rpath,/usr/local/qt-3.3/lib" 
set_configure_args '--prefix=$prefix --disable-rpath --with-extra-includes=/usr/local/include --with-extra-libs=/usr/local/lib'

# Because of a build error the QT tools currently need LD_LIBRARYN32 path to
# find libqt*
export LD_LIBRARYN32_PATH=/usr/local/qt-3.3/lib

autonuke=0

reg prep
prep()
{
    generic_prep
    aclocal-1.9
    autoheader
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
    generic_install DESTDIR
    setdir ${stagedir}$prefix}/${_sharedir}/config
    ${MV} "40 Colors" 40_Colors
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
