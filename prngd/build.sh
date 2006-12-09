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
topdir=prngd
version=0.9.29
pkgver=8
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=prngd-irix53-support.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
no_configure=1
CC=gcc
cflags_os="-O3 -Wall -DIRIX62"

if [ "$_os" == "irix53" ]; then
    CC=cc
    cflags_os="-O2 -fullwarn -DIRIX53"
    mipspro=2
fi
__configure="make"
configure_args="CC=$CC CFLAGS=\\\"$cflags_os\\\" DEFS=\\\"-DRANDSAVENAME=\\\"${prefix}/${_sysconfdir}/prngd/prngd-seed\\\" -DCONFIGFILE=\\\"${prefix}/${_sysconfdir}/prngd/prngd.conf\\\"\\\""

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    #generic_build
    setdir source
    $MAKE_PROG CC=$CC CFLAGS="$cflags_os" DEFS="-DRANDSAVENAME=\\\"${prefix}/${_sysconfdir}/prngd/prngd-seed\\\" -DCONFIGFILE=\\\"${prefix}/${_sysconfdir}/prngd/prngd.conf\\\""
}

reg install
install()
{
    clean stage
    setdir source
    $MKDIR -p ${stagedir}/${_sysconfdir}/init.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc0.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc2.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/config
    $MKDIR -p ${stagedir}${prefix}/${_sbindir}
    $MKDIR -p ${stagedir}${prefix}/${_sysconfdir}/prngd
    $MKDIR -p ${stagedir}${prefix}/${_mandir}/man1
    $CP prngd ${stagedir}${prefix}/${_sbindir}
    $CP prngd.man ${stagedir}${prefix}/${_mandir}/man1/prngd.1
    chmod 744 ${stagedir}${prefix}/${_sbindir}/prngd
    chmod 644 ${stagedir}${prefix}/${_mandir}/man1/*
    echo "Please fill me up!" > ${stagedir}${prefix}/${_sysconfdir}/prngd/prngd-seed

    # Install entropy gathering script
    $CP contrib/IRIX-53/prngd.conf.irix-53 ${stagedir}${prefix}/${_sysconfdir}/prngd/prngd.conf

    # Install initscript
    $CP $metadir/prngd.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_prngd
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_prngd
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_prngd K05tgc_prngd)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_prngd S95tgc_prngd)
    # And set it up to run at boot
    echo "on" > ${stagedir}/${_sysconfdir}/config/tgc_prngd
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_prngd config(noupdate)" > $metadir/ops

    # Adjust prngd path in initscript
    $GSED -i "/^PRNGD_BIN/s|=.*|=${prefix}/${_sbindir}/prngd|" ${stagedir}/${_sysconfdir}/init.d/tgc_prngd

    # Dont overwrite prngd-seed on upgrade
    echo "${prefix#/*}/${_sysconfdir}/prngd/prngd-seed config(noupdate)" >> $metadir/ops

    doc 00DESIGN 00README 00README.gatherers ChangeLog

    custom_install=1
    generic_install
}

reg pack
pack()
{
    (setdir ${stagedir}${prefix}/${_mandir}; fix_man)
    lprefix=${prefix#/*}
    topinstalldir="/"
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
