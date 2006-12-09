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
topdir=httpd
version=2.2.3
pkgver=2
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
flavour=httpd22
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix/$flavour --with-apr=${prefix}/bin/apr-1-config --with-apr-util=${prefix}/bin/apu-1-config --with-pcre --with-z=${prefix} --with-mpm=prefork --enable-modules=all --enable-mods-shared=all --enable-suexec --with-suexec --with-suexec-uidmin=500 --with-suexec-gidmin=20 --enable-ssl --with-ssl --enable-proxy --enable-cache --enable-mem-cache --enable-file-cache --enable-disk-cache --enable-ldap --enable-authnz-ldap --enable-cgid --enable-authn-anon --enable-authn-alias"

reg prep
prep()
{
    generic_prep
    setdir source
    $RM -rf srclib/{apr,apr-util,pcre}
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
    doc ABOUT_APACHE CHANGES LICENSE NOTICE VERSIONING README 

    setdir source
    $MKDIR -p ${stagedir}/${_sysconfdir}/init.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc0.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc2.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/config

    # Install initscript
    $CP $metadir/httpd.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_${flavour}
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_$flavour
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_${flavour} K02tgc_${flavour})
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_${flavour} S99tgc_${flavour})
    # Don't run by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_${flavour}
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_$flavour config(noupdate)" >> $metadir/ops
    # Default empty options file
    touch ${stagedir}/${_sysconfdir}/config/tgc_${flavour}.options
    echo "${_sysconfdir}/config/tgc_${flavour}.options config(noupdate)" >> $metadir/ops

    setdir ${stagedir}${prefix}/$flavour/conf
    for i in httpd.conf mime.types magic extra/*
    do
	echo "${prefix#/*}/$flavour/conf/$i config(noupdate)" >> $metadir/ops
    done

    ${GSED} -i "s/@@FLAVOUR@@/$flavour/g;s|@@BASEPATH@@|${prefix}/${flavour}|g" ${stagedir}/${_sysconfdir}/init.d/tgc_${flavour}
}

reg pack
pack()
{
    lprefix=${prefix#/*}
    iprefix=$lprefix/$flavour
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
