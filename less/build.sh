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
topdir=less
version=382
pkgver=2
source[0]=$topdir-$version.tar.gz
source[1]=lesspipe.sh
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --with-editor=/bin/vi"
# Don't build with ncurses even if found
ac_overrides="ac_cv_lib_ncurses_initscr=no"

shortroot=1

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    ${__configure} $configure_args
    ${SED} -e '/^LIBS/ s/LIBS =.*/LIBS = -lcurses/g' Makefile > Makefile.new
    ${MV} Makefile.new Makefile
    $MAKE_PROG
}

reg install
install()
{
    generic_install prefix
    ${GINSTALL} -m 755 ${srcdir}/${source[1]} ${stagedir}${prefix}/${_bindir}
    doc NEWS LICENSE
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
