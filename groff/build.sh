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
topdir=groff
version=1.19.1
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=groff-1.18.1-Imakefile.patch
patch[1]=groff-1.19-inttypes-irix53.patch
patch[2]=groff-1.19-nroff-shell.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# This package has a shallow stagedir
shortroot=1
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
    setdir source
    (cd doc && makeinfo groff.texinfo)
    cd src/xditview
    xmkmf -a # Produces kinda broken makefiles using -mips2 -32 :(
    if [ "$_os" == "irix53" ]; then
	$MAKE_PROG CC=cc CCOPTIONS="-xansi -32 -mips1" LDPOSTLIB=
    else
	$MAKE_PROG CC=cc CCOPTIONS="-xansi -n32 -mips3 -woff 1116,1174" LDPOSTLIB=
    fi
}

reg install
install()
{
    generic_install prefix
    setdir source
    cd src/xditview
    $MAKE_PROG DESTDIR=$stagedir install
    setdir ${stagedir}${prefix}
    ${RM} -f info/dir
    ${MV} ../lib/* lib
    ${MV} ../bin/X11/* bin
    ${RMDIR} ../bin/X11
    ${RMDIR} ../bin
    ${RMDIR} ../lib
    custom_install=1
    generic_install
    doc ChangeLog NEWS PROBLEMS PROJECTS TODO COPYING LICENSE
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
