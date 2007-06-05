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
topdir=kdebase
version=3.5.7
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=kdebase-3.5.7-srandom.patch
patch[1]=kdebase-3.5.7-getloadavg.patch
patch[2]=kdebase-3.5.2-opengl.patch
patch[3]=kdebase-3.4.0-lastlog.patch
patch[4]=kdebase-3.5.7-socklen_t.patch
patch[5]=kdebase-3.5.7-include-config.h.patch
patch[6]=kdebase-3.5.7-ksysguardd.patch
patch[7]=kdebase-3.5.7-rtld_next.patch
patch[8]=kdebase-3.5.7-missing-libx11.patch
patch[9]=kdebase-3.5.7-kdefakes.patch
patch[10]=kdebase-3.5.7-nochown.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/qt-3.3/include" 
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/qt-3.3/lib -Wl,-rpath,/usr/tgcware/qt-3.3/lib"
configure_args='--prefix=$prefix --disable-rpath --disable-pie --with-java=/usr/java --with-extra-includes=/usr/tgcware/include:/usr/java/include/irix --with-extra-libs=/usr/tgcware/lib --enable-libsuffix= --with-samba'

[ "$_os" = "irix62" ] && ac_overrides="ac_cv_lib_gen_getspent=no"
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
