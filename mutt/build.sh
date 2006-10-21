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
topdir=mutt
version=1.4.2.2i
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/include/ncurses"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --enable-imap --enable-pop --with-ssl --with-ncurses=/usr/tgcware/include/ncurses"

topsrcdir=$topdir-1.4.2.2

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
    $MKDIR -p ${stagedir}${prefix}/doc/mutt ${stagedir}${prefix}/${_sharedir}/doc
    $MV ${stagedir}${prefix}/doc/mutt ${stagedir}${prefix}/${_vdocdir}
    ${RMDIR} ${stagedir}${prefix}/doc
    echo "${_sysconfdir}/Muttrc config(noupdate)" > $metadir/ops
    echo "${_sysconfdir}/mime.types config(noupdate)" >> $metadir/ops
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN ops"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
