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
topdir=kdelibs
version=3.5.2
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=kdelibs-3.4.0-srandom.patch
patch[1]=kdelibs-3.4.0-trio.patch
patch[2]= #kdelibs-3.4.0-maxdname.patch
patch[3]= #kdelibs-3.4.0-undef_inet.patch
patch[4]=kdelibs-3.4.0-socklen_t.patch
patch[5]=kdelibs-3.4.0-ksocklen_t.patch
patch[6]=kdelibs-3.4.0-getnameinfo.patch
patch[7]=kdelibs-3.4.0-in_addr_t.patch
patch[8]=kdelibs-3.4.0-nameclash.patch
patch[9]=kdelibs-3.4.0-shutrdwr.patch
patch[10]=kdelibs-3.4.0-noconfig.patch
patch[11]=kdelibs-3.5.2-netdb.patch
patch[12]=kdelibs-3.5.2-chownroot.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/qt-3.3/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/qt-3.3/lib -Wl,-rpath,/usr/tgcware/qt-3.3/lib" 
configure_args='--prefix=$prefix --disable-rpath --with-extra-includes=/usr/tgcware/include --with-extra-libs=/usr/tgcware/lib --enable-libsuffix='
ac_overrides="ac_cv_func_inet_pton=no ac_cv_func_inet_ntop=no"

autonuke=0

reg prep
prep()
{
    generic_prep
    aclocal-1.9
    automake-1.9 --foreign
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
