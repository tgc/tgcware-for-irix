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
topdir=xmms
version=1.2.10
pkgver=5
source[0]=$topdir-$version.tar.bz2
source[1]=xmmsskins-1.0.tar.gz
# If there are no patches, simply comment this
patch[0]=xmms-underquoted.patch
patch[1]=xmms-1.2.10-xmms-xpm.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CC=cc
mipspro=1
if [ "$_os" = "irix62" ]; then
    export CFLAGS="-O3"
fi
configure_args+=(--enable-static=no --disable-rpath --disable-oss --with-ogg=/usr/tgcware --with-vorbis=/usr/tgcware --with-esd-prefix=/usr/tgcware)

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
    doc AUTHORS COPYING ChangeLog FAQ INSTALL NEWS TODO README
    setdir $stagedir
    #$FIND . -name '*.la' | $XARGS $RM -f
    ${__mkdir} -p ${stagedir}${prefix}/${_sharedir}/xmms/Skins
    setdir ${stagedir}${prefix}/${_sharedir}/xmms/Skins
    ${__tar} xzf $srcfiles/${source[1]}
    ${__install} -D -m0644 $srcdir/$topdir-$version/xmms/xmms_logo.xpm ${stagedir}${prefix}/${_sharedir}/pixmaps/xmms_logo.xpm
    ${__install} -D -m0644 $srcdir/$topdir-$version/xmms/xmms.xpm ${stagedir}${prefix}/${_sharedir}/pixmaps/xmms.xpm
    ${__install} -D -m0644 $srcdir/$topdir-$version/xmms/xmms_mini.xpm ${stagedir}${prefix}/${_sharedir}/pixmaps/mini/xmms.xpm
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
