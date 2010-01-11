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
topdir=dhcp
version=3.0.5
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=dhcp-3.0.5-irix.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
configure_args=""
check_ac=0
# No good way around this
PATH=$(echo $PATH | sed -e 's/gcc//g')
subsysconf=$metadir/subsys.conf
CC=cc
mipspro=1

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    cat <<EOF > site.conf
VARDB=${prefix}/${_sysconfdir}/dhcp
VARRUN=/var/run
USERBINDIR=${prefix}/${_bindir}
BINDIR=${prefix}/${_sbindir}
CLIENTBINDIR=${prefix}/${_sbindir}
ADMMANDIR=${prefix}/${_mandir}/man8
FFMANDIR=${prefix}/${_mandir}/man5
LIBMANDIR=${prefix}/${_mandir}/man3
USRMANDIR=${prefix}/${_mandir}/man1
LIBDIR=${prefix}/${_libdir}
INCDIR=${prefix}/${_includedir}
ETC=${prefix}/${_sysconfdir}
EOF
    cat <<EOF >>includes/site.h
#define _PATH_DHCPD_DB          "${prefix}/${_sysconfdir}/dhcp/dhcpd.leases"
#define _PATH_DHCLIENT_DB       "${prefix}/${_sysconfdir}/dhcp/dhclient.leases"
#define _PATH_DHCPD_CONF        "${prefix}/${_sysconfdir}/dhcpd.conf"
#define _PATH_DHCPD_PID         "/var/run/dhcpd.pid"
EOF
    $CP includes/site.h .
    generic_build
}

reg install
install()
{
    generic_install DESTDIR

    $MKDIR -p ${stagedir}/${_sysconfdir}/{init.d,rc0.d,rc2.d,config}

    # Install initscript
    $CP $metadir/dhcpd.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_dhcpd
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_dhcpd
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_dhcpd K02tgc_dhcpd)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_dhcpd S99tgc_dhcpd)
    # Don't run by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_dhcpd
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_dhcpd config(noupdate)" > $metadir/ops

    : > ${stagedir}${prefix}/${_sysconfdir}/dhcpd.conf
    echo "${prefix#/*}/${_sysconfdir}/dhcpd.conf config(noupdate)" >> $metadir/ops; 

    custom_install=1
    generic_install
    doc LICENSE README RELNOTES site.h site.conf
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
