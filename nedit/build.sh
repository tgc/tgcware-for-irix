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
topdir=nedit
version=5.5
pkgver=1
source[0]=$topdir-$version-src.tar.bz2
# If there are no patches, simply comment this
patch[0]=nedit-5.5-sgi.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
check_ac=0
no_configure=1
make_build_target=sgi
custom_install=1
[ "$_os" = "irix53" ] && mipspro=2
[ "$_os" = "irix62" ] && mipspro=1

reg prep
prep()
{
    generic_prep
    setdir source
    if [ "$_os" = "irix53" ]; then
	$GSED -i 's/\(CFLAGS=.*\)/\1 -DUSE_MOTIF_GLOB/' makefiles/Makefile.sgi
	$GSED -i 's/\(BIGGER_STRINGS=\)/\1 -Wf,-XNl10000/' makefiles/Makefile.sgi
    fi
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    clean stage
    $MKDIR -p ${stagedir}${prefix}/${_bindir}
    $MKDIR -p ${stagedir}${prefix}/${_mandir}/man1
    doc ReleaseNotes COPYRIGHT README
    setdir source
    $CP -p source/nedit ${stagedir}${prefix}/${_bindir}
    $CP -p source/nc ${stagedir}${prefix}/${_bindir}/ncl
    $CP -pr doc/html ${stagedir}${prefix}/${_vdocdir}
    $CP -p doc/NEdit.ad ${stagedir}${prefix}/${_vdocdir}/extras
    $CP -p doc/nc.man ${stagedir}${prefix}/${_mandir}/man1/ncl.1
    $CP -p doc/nedit.man ${stagedir}${prefix}/${_mandir}/man1/nedit.1
    $CP -p doc/nedit.doc ${stagedir}${prefix}/${_vdocdir}
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
