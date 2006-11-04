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
topdir=openntpd
version=3.9p1
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=openntpd-3.7p1-nochown.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --with-privsep-user=_ntp --with-privsep-path=/var/empty/ntpd'
ac_overrides="ac_cv_func_inet_pton=no"

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
    $MKDIR -p ${stagedir}/${_sysconfdir}/init.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc0.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc2.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/config

    # Install initscript
    $CP $metadir/ntpd.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_ntpd
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_ntpd
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_ntpd K02tgc_ntpd)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_ntpd S99tgc_ntpd)
    # Don't run by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_ntpd
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_ntpd config(noupdate)" > $metadir/ops

    echo "${prefix#/*}/${_sysconfdir}/ntpd.conf config(noupdate)" >> $metadir/ops; 

    custom_install=1
    generic_install
    doc CREDITS LICENCE README
    setdir ${stagedir}${prefix}
    $MKDIR ${_docdir}/${topdir}-${version}/contrib
    $CP $metadir/privsep-user-setup.sh ${_docdir}/${topdir}-${version}/contrib
}

reg pack
pack()
{
    lprefix=${prefix#/*}
    metainstalldir=$prefix
    topinstalldir=/
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
