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
topdir=pidgin
version=2.0.1
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=pidgin-2.0.0-trio.patch
patch[1]=pidgin-2.0.0-gnutls.patch
patch[2]=pidgin-2.0.0-shutrdwr.patch
patch[3]=pidgin-2.0.0-maxdname.patch
patch[4]=pidgin-2.0.0-gnulib.patch
patch[5]=pidgin-2.0.0-zephyr-needs-gnulib.patch
patch[6]=pidgin-2.0.0-missing-X11.patch
patch[7]=pidgin-2.0.1-natpmp-fixes.patch
patch[8]=pidgin-2.0.0-finch-configh.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/include/ncurses"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args+=(--enable-gnutls=yes --enable-nss=no --disable-gevolution)
ac_overrides="ac_cv_func_inet_ntop=no"

reg prep
prep()
{
    generic_prep
    setdir source
    $RM -f pidgin/getopt*
    $RM -f finch/getopt*
    aclocal-1.9 -I m4macros -I gl/m4
    automake-1.9
    autoheader
    autoconf

    # We can't use the non-blocking DNS resolver code
    $GSED -i 's/__unix__/__lunix__/g' libpurple/dnsquery.c
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
    setdir $stagedir
    $MV auto ${stagedir}${prefix}/${_libdir}/perl5/5.8.8/mips3-irix/
    $MKDIR -p ${stagedir}${prefix}/${_mandir}/man3
    $MV *pm ${stagedir}${prefix}/${_mandir}/man3
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
