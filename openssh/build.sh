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
version=3.7.1p2
pkgver=5
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="OpenSSH"

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
    export CPPFLAGS="-I/usr/local/include/openssl"
    setdir source
    ./configure --prefix=$prefix --sysconfdir=$prefix/etc/ssh --with-prngd-socket=/var/run/egd-pool --with-default-path=/usr/local/bin:/usr/bsd:/usr/bin --with-mantype=cat --disable-suid-ssh --without-rsh --with-privsep-user=sshd --with-superuser-path=/usr/sbin:/usr/bsd:/sbin:/usr/bin:/bin:/etc:/usr/etc:/usr/bin/X11:/usr/local/bin
    $MAKE_PROG
}

reg install
install()
{
    clean stage
    setdir source
    $MAKE_PROG DESTDIR=$stagedir install-nokeys
    setdir $stagedir$prefix/etc/ssh
    for i in *; do mv $i $i.default; done
    cp -p $metadir/sshd.init.irix $stagedir/usr/local/etc/ssh/sshd.init-sample
    cp -p $metadir/postinstall.irix $stagedir$prefix/etc/ssh/postinstall.irix
    cp -p $metadir/postremove.irix $stagedir$prefix/etc/ssh/postremove.irix
    chmod 744 $stagedir$prefix/etc/ssh/postremove.irix
    chmod 744 $stagedir$prefix/etc/ssh/postinstall.irix
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
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
