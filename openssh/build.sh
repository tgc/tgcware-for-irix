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
topdir=openssh
version=4.7p1
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Custom subsystems...
subsysconf=$metadir/subsys.conf

# Global settings
export CC=cc
export LDFLAGS="-Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/lib"
export CPPFLAGS="-I/usr/tgcware/include/openssl -I/usr/tgcware/include"
configure_args='--prefix=$prefix --sysconfdir=$prefix/${_sysconfdir}/ssh --datadir=$prefix/${_sharedir}/openssh --mandir=$prefix/${_mandir} --with-default-path=$prefix:/usr/bsd:/usr/bin --with-mantype=man --disable-suid-ssh --without-rsh --with-privsep-user=sshd --with-privsep-path=/var/empty/sshd --with-superuser-path=/usr/sbin:/usr/bsd:/sbin:/usr/bin:/bin:/etc:/usr/etc:/usr/bin/X11:$prefix/bin --with-prngd-socket=/var/run/egd-pool'
mipspro=1
if [ "$_os" = "irix53" ]; then
    export CC=gcc
    mipspro=0
fi
# It uses ac_cv_lib_gen_dirname=yes but that is okay
check_ac=0

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
    clean stage
    $RM -f $metadir/ops

    setdir source
    $MAKE_PROG DESTDIR=${stagedir} install-nokeys
    $MKDIR -p ${stagedir}/${_sysconfdir}/init.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc0.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc2.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/config

    # Install initscript
    $CP $metadir/sshd.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_sshd
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_sshd
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_sshd K02tgc_sshd)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_sshd S98tgc_sshd)
    # Don't run by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_sshd
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_sshd config(noupdate)" >> $metadir/ops

    custom_install=1
    generic_install
    doc CREDITS ChangeLog INSTALL LICENCE OVERVIEW README README.privsep README.smartcard RFC.nroff TODO WARNING.RNG

    setdir ${stagedir}${prefix}/${_sysconfdir}/ssh
    for i in *; do $CP $i $i.default; echo "${prefix#/*}/${_sysconfdir}/ssh/$i config(noupdate)" >> $metadir/ops; done
    setdir ${stagedir}${prefix}
    $MKDIR ${_docdir}/${topdir}-${version}/samples
    $MV ${_sysconfdir}/ssh/*.default ${_docdir}/${topdir}-${version}/samples
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
