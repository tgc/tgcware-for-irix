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
topdir=kdelibs
version=3.5.7
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=kdelibs-3.4.0-in_addr_t.patch
patch[1]=kdelibs-3.4.0-nameclash.patch
patch[2]=kdelibs-3.4.0-shutrdwr.patch
patch[3]=kdelibs-3.4.0-noconfig.patch
patch[4]=kdelibs-3.5.2-netdb.patch
patch[5]=kdelibs-3.5.2-setuid.patch
patch[6]=kdelibs-3.5.6-srandom.patch
patch[7]=kdelibs-3.5.7-dcop-use-kdefakes.patch
patch[8]=kdelibs-3.5.7-socklen_t.patch
patch[9]=kdelibs-3.5.7-noisinf.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/qt-3.3/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/qt-3.3/lib -Wl,-rpath,/usr/tgcware/qt-3.3/lib" 
configure_args='--prefix=$prefix --disable-rpath --disable-pie --with-extra-includes=/usr/tgcware/include --with-extra-libs=/usr/tgcware/lib --enable-libsuffix='
ac_overrides="ac_cv_func_inet_pton=no ac_cv_func_inet_ntop=no"

autonuke=0

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
