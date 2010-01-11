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
topdir=mutt
version=1.4.2.3
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include -I/usr/tgcware/include/ncurses"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --enable-imap --enable-pop --with-ssl --with-curses=/usr/tgcware"

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
    ${__mkdir} -p ${stagedir}${prefix}/${_sharedir}/doc
    ${__mv} ${stagedir}${prefix}/doc/mutt ${stagedir}${prefix}/${_vdocdir}
    ${__rmdir} ${stagedir}${prefix}/doc
    echo "${_sysconfdir}/Muttrc config(noupdate)" > $metadir/ops
    echo "${_sysconfdir}/mime.types config(noupdate)" >> $metadir/ops
    #doc README README.SSL COPYRIGHT GPL ChangeLog NEWS
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
