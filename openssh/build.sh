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
version=3.8.1p1
pkgver=4
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
    [ ! "$(gcc --version)" == "2.95.3" ] && LDFLAGS="-static-libgcc -Wl,-rpath,/usr/local/lib -L/usr/local/lib"
    export CPPFLAGS="-I/usr/local/include/openssl"
    configure_args="--prefix=$prefix --sysconfdir=$prefix/${_sysconfdir}/ssh --datadir=$prefix/${_sharedir}/openssh --with-prngd-socket=/var/run/egd-pool --with-default-path=$prefix:/usr/bsd:/usr/bin --with-mantype=man --disable-suid-ssh --without-rsh --with-privsep-user=sshd --with-superuser-path=/usr/sbin:/usr/bsd:/sbin:/usr/bin:/bin:/etc:/usr/etc:/usr/bin/X11:$prefix"
    setdir source
    ./configure $configure_args
    $MAKE_PROG
}

reg install
install()
{
    clean stage
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

    custom_install=1
    generic_install
    doc CREDITS ChangeLog INSTALL LICENCE OVERVIEW README README.privsep README.smartcard RFC.nroff TODO WARNING.RNG

    $RM -f $metadir/ops
    setdir ${stagedir}${prefix}/${_sysconfdir}/ssh
    for i in *; do $CP $i $i.default; echo "${prefix#/*}/${_sysconfdir}/ssh/$i config(noupdate)" >> $metadir/ops; done
    $MKDIR ${_docdir}/samples
    $MV *.default ${_docdir}/samples
    $MKDIR ${_docdir}/contrib
    $CP $metadir/privsep-user-setup.sh ${_docdir}/contrib
}

reg pack
pack()
{
    (setdir ${stagedir}${prefix}/${_mandir}; fix_man)
    lprefix=${prefix#/*}
    metainstroot=$prefix
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
