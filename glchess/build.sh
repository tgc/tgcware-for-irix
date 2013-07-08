#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=glchess
version=0.4.7
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=glchess-0.4.7-use-g_snprintf.patch
patch[1]=glchess-0.4.7-missing-time_h.patch
patch[2]=glchess-0.4.7-use-sgi-ogl-extensions.patch
patch[3]=glchess-0.4.7-missing-string_h.patch
patch[4]=glchess-0.4.7-fix-global-glchessrc-location.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -Wl,-rpath,$prefix/lib"

reg prep
prep()
{
    generic_prep
    setdir source
    ./autogen.sh
    # Fix glchessrc
    ${__gsed} -i "s|/usr/local/share/games/|$prefix/${_sharedir}/|g" glchessrc
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
    setdir source
    for d in src textures man; do
	cd $d
	${__make} install DESTDIR=$stagedir
	cd ..
    done
    doc AUTHORS COPYING
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
