#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# Copyright (C) 2003-2009 Tom G. Christensen <tgc@jupiterrise.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Written by Tom G. Christensen <tgc@jupiterrise.com>.

# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=openssh
version=5.3p1
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/OpenBSD/OpenSSH/portable/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Custom subsystems...
subsysconf=$metadir/subsys.conf

# Global settings
mipspro=1
export CC=cc
configure_args="--prefix=$prefix --sysconfdir=$prefix/${_sysconfdir}/ssh --datadir=$prefix/${_sharedir}/openssh --mandir=$prefix/${_mandir} --with-default-path=$prefix/bin:/usr/bsd:/usr/bin --with-mantype=man --with-privsep-user=sshd --with-privsep-path=/var/empty/sshd --with-superuser-path=/usr/sbin:/usr/bsd:/sbin:/usr/bin:/bin:/etc:/usr/etc:/usr/bin/X11:$prefix/bin --with-prngd-socket=/var/run/egd-pool"
if [ "$_os" = "irix53" ]; then
    export CC=gcc
    mipspro=0
fi
[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
export CPPFLAGS="-I/usr/tgcware/include/openssl -I/usr/tgcware/include"
export LDFLAGS="-Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/lib $NO_RQS"
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
    doc CREDITS ChangeLog INSTALL LICENCE OVERVIEW README* PROTOCOL* TODO WARNING.RNG

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
