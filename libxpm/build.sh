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
topdir=xpm
version=3.4k
pkgver=9
source[0]=xpm-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libxpm-3.4k-shlib.patch
patch[1]=libxpm-3.4k-sxpm.patch
patch[2]=libxpm-3.4k-cxpm.patch
patch[3]=libxpm-3.4k-s_popen.patch
patch[4]=
patch[5]=libxpm-3.4k-sxpm-shlibs.patch
patch[6]=patch-aa
patch[7]=patch-ab
patch[8]=patch-ac
patch[9]=patch-ad
patch[10]=patch-ae
patch[11]=patch-af
patch[12]=patch-ag
patch[13]=patch-ah
patch[14]=patch-ai
patch[15]=patch-aj
patch[16]=patch-ak
patch[17]=patch-al
patch[18]=patch-am
patch[19]=patch-an
patch[20]=patch-ao
patch[21]=patch-ap
patch[22]=patch-aq
patch[23]=patch-ar
patch[24]=patch-as
patch[25]=libxpm-3.4k-trio.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    ${__make} -f Makefile.noX INCLUDES="-I. -I.. -I../lib -I${prefix}/${_includedir}"
}

reg install
install()
{
    clean stage
    setdir source
    ${__make} INSTALL=${__install} DESTDIR=$stagedir -f Makefile.noX install
    ${__make} INSTALL=${__install} DESTDIR=$stagedir -f Makefile.noX install.man
    setdir ${stagedir}${prefix}/${_libdir}
    ln -s libXpm.so.4.11 libXpm.so.4
    ln -s libXpm.so.4.11 libXpm.so
    doc doc/xpm.PS.gz FAQ.html README.html COPYRIGHT
    custom_install=1
    generic_install
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
