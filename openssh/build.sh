#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=openssh
version=3.9p1
pkgver=6
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Custom subsystems...
subsysconf=$metadir/subsys.conf

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    export LDFLAGS="-Wl,-rpath,/usr/local/lib -L/usr/local/lib"
    export CPPFLAGS="-I/usr/local/include/openssl -I/usr/local/include"
    export ENTROPY="--with-prngd-socket=/var/run/egd-pool"
    set_configure_args '--prefix=$prefix --sysconfdir=$prefix/${_sysconfdir}/ssh --datadir=$prefix/${_sharedir}/openssh --with-prngd-socket=/var/run/egd-pool --with-default-path=$prefix:/usr/bsd:/usr/bin --with-mantype=man --disable-suid-ssh --without-rsh --with-privsep-user=sshd --with-privsep-path=/var/empty/sshd --with-superuser-path=/usr/sbin:/usr/bsd:/sbin:/usr/bin:/bin:/etc:/usr/etc:/usr/bin/X11:$prefix $ENTROPY'

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

reg all
all()
{
    for METHOD in $METHODS 
    do
	case $METHOD in
	     all*|*clean) ;;
	     *) $METHOD
		;;
	esac
    done

}

reg
usage() {
    echo Usage $0 "{"$(echo $METHODS | tr " " "|")"}"
    exit 1
}

OK=0
for METHOD in $*
do
    METHOD=" $METHOD *"
    if [ "${METHODS%$METHOD}" == "$METHODS" ] ; then
	usage
    fi
    OK=1
done

if [ $OK = 0 ] ; then
    usage;
fi

for METHOD in $*
do
    ( $METHOD )
done
