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
topdir=sudo
version=1.6.8p12
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=sudo-1.6.8p12-mansect.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
configure_args="$configure_args --sysconfdir=$prefix/${_sysconfdir} --with-logging=syslog --with-logfac=auth --with-editor=/bin/vi --with-env-editor --with-ignore-dot --with-insults --with-all-insults --with-timedir=/var/run"
ac_overrides="sudo_cv_func_isblank=no"

topinstalldir=/
pkgdefprefix=${prefix:1}

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
    doc BUGS HISTORY LICENSE README TODO
    echo "$pkgdefprefix/${_sysconfdir}/sudoers config(suggest)" > $metadir/ops
    $RM -f ${stagedir}${prefix}/libexec/*.la
    $MKDIR -p ${stagedir}/var/run
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
