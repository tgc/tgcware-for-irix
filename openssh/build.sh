#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=openssh
version=6.5p1
pkgver=1
source[0]=http://ftp.openbsd.dk/pub/OpenBSD/OpenSSH/portable/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Needs some patches for IRIX 5.3
if irix53; then
    patch[0]=0001-IRIX-5.3-IDO-compiler-needs-BROKEN_READV_COMPARISON.patch
    patch[1]=0002-Include-sys-param.h-to-get-MAXPATHLEN-defined.patch
    patch[2]=0003-Workaround-for-IRIX-5.3-header-issues.patch
fi

# Custom subsystems...
subsysconf=$metadir/subsys.conf

# Global settings
mipspro=1
CC=cc
configure_args=(--prefix=$prefix --sysconfdir=$prefix/${_sysconfdir}/ssh --datadir=$prefix/${_sharedir}/openssh --mandir=$prefix/${_mandir} --with-default-path=$prefix/bin:/usr/bsd:/usr/bin --with-mantype=man --with-privsep-user=sshd --with-privsep-path=/var/empty/sshd --with-superuser-path=/usr/sbin:/usr/bsd:/sbin:/usr/bin:/bin:/etc:/usr/etc:/usr/bin/X11:$prefix/bin --with-prngd-socket=/var/run/egd-pool)
[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
export CPPFLAGS="-I/usr/tgcware/include/openssl -I/usr/tgcware/include"
export LDFLAGS="-Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/lib $NO_RQS"
export CC=$CC
# It uses ac_cv_lib_gen_dirname=yes but that is okay
check_ac=0
ac_overrides="ac_cv_func_inet_ntop=no ac_cv_func___b64_ntop=no ac_cv_func___b64_pton=no"
useautodir=0

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

reg check
check()
{
    setdir source
    export TEST_SSH_TRACE=yes
    ${__make} tests
}

reg install
install()
{
    clean stage
    ${__rm} -f $metadir/ops

    setdir source
    ${__make} DESTDIR=${stagedir} install-nokeys
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/init.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/rc0.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/rc2.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/config

    # Install initscript
    ${__cp} $metadir/sshd.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_sshd
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_sshd
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; ${__ln} -sf ../init.d/tgc_sshd K02tgc_sshd)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; ${__ln} -sf ../init.d/tgc_sshd S98tgc_sshd)
    # Don't run by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_sshd
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_sshd config(noupdate)" >> $metadir/ops

    custom_install=1
    generic_install
    doc CREDITS ChangeLog INSTALL LICENCE OVERVIEW README* PROTOCOL* TODO

    setdir ${stagedir}${prefix}/${_sysconfdir}/ssh
    for i in *; do ${__cp} $i $i.default; echo "${prefix#/*}/${_sysconfdir}/ssh/$i config(noupdate)" >> $metadir/ops; done
    setdir ${stagedir}${prefix}
    ${__mkdir} ${_docdir}/${topdir}-${version}/samples
    ${__mv} ${_sysconfdir}/ssh/*.default ${_docdir}/${topdir}-${version}/samples
    ${__mkdir} ${_docdir}/${topdir}-${version}/contrib
    ${__cp} $metadir/privsep-user-setup.sh ${_docdir}/${topdir}-${version}/contrib
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
