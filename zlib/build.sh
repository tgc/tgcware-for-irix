#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=zlib
version=1.1.4
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=zlib-1.1.4-use_cc.patch
patch[1]=zlib-1.1.4-vsnprintf.patch

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
	export CC=gcc
	export CFLAGS="-Wall -ansi -O3"
	setdir source
	./configure --shared --prefix=$prefix
	$MAKE_PROG test
}

reg install
install()
{
    generic_install prefix
	setdir source
	mkdir -p $stagedir/man/man3
	cp zlib.3 $stagedir/man/man3
	mkdir -p $stagedir/doc/$topdir-$version
	for i in "README ChangeLog algorithm.txt minigzip.c example.c"
	do
		cp $i $stagedir/doc/$topdir-$version
	done
}

reg pack
pack()
{
    generic_pack shortroot
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
