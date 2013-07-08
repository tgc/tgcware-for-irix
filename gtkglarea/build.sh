#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gtkglarea
version=1.2.3
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=gtkglarea-1.2.3-fix-underquoting.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
CPPFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -Wl,-rpath,$prefix/lib"

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

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    doc README AUTHORS COPYING ChangeLog docs/gtkglarea.txt docs/gdkgl.txt docs/HOWTO.txt
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
