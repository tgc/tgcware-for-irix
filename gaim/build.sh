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
topdir=gaim
version=2.0.0beta6
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gaim-2.0.0-trio.patch
patch[1]=gaim-2.0.0-gnutls.patch
patch[2]=gaim-2.0.0-shutrdwr.patch
patch[3]=gaim-2.0.0-maxdname.patch
patch[4]=gaim-2.0.0-gnulib.patch
patch[5]=gaim-2.0.0-zephyr-needs-gnulib.patch
patch[6]=gaim-2.0.0-missing-X11.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/include/ncurses"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-gnutls=yes --enable-nss=no --disable-gevolution"
ac_overrides="ac_cv_func_inet_ntop=no"

reg prep
prep()
{
    generic_prep
    setdir source
    $RM -f gtk/getopt*
    $RM -f console/getopt*
    aclocal-1.9 -I m4macros -I gl/m4
    automake-1.9
    autoheader
    autoconf

    # We can't use the non-blocking DNS resolver code
    $GSED -i 's/__unix__/__lunix__/g' libgaim/dnsquery.c
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    MAKE_PROG="make SHELL=/usr/tgcware/bin/bash"
    generic_install DESTDIR
    doc COPYING COPYRIGHT AUTHORS NEWS README
    $FIND ${stagedir} -name '.packlist' -o -name 'perllocal.pod' -o -name '*.bs' | $XARGS -i $RM -f {}
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
