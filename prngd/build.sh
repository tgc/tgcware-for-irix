#!/usr/local/bash/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=prngd
version=0.9.27
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=prngd-irix53-support.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc

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
	setdir source
	make CC=gcc CFLAGS="-O3 -Wall -DIRIX53" DEFS='-DRANDSAVENAME=\"/usr/local/etc/prngd/prngd-seed\" -DCONFIGFILE=\"/usr/local/etc/prngd/prngd.conf\"'
	$MAKE_PROG
}

reg install
install()
{
	clean stage
	setdir source
	mkdir -p $stagedir/sbin
	mkdir -p $stagedir/etc/prngd
	mkdir -p $stagedir/man/man1
	cp prngd $stagedir/sbin
	cp prngd.man $stagedir/man/man1/prngd.1
	cp contrib/IRIX-53/prngd.conf.irix-53 $stagedir/etc/prngd/prngd.conf
	chmod 744 $stagedir/sbin/prngd
	chmod 644 $stagedir/man/man1/*
	cp $metadir/prngd.init.irix $stagedir/etc/prngd/prngd.init-sample
	cp $metadir/postinstall.irix $stagedir/etc/prngd/postinstall.irix
	cp $metadir/postremove.irix $stagedir/etc/prngd/postremove.irix
	echo "Please fill me up!" > $stagedir/etc/prngd/prngd-seed
}

reg pack
pack()
{
	clean meta
	setdir stage
	create_idb
	cp $metadir/prngd.idb.fixed $metadir/prngd.idb
	create_spec
	make_dist shortroot
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
