#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=xsnow
version=1.42
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=xsnow-1.42-misc.patch
patch[1]=xsnow-1.42-snprintf.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="xsnow"

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
    SNPRINTF_FILES="bsd-snprintf.c config.h includes.h"
    setdir source
    for i in $SNPRINTF_FILES
    do
	cp ../$i .
    done
    xmkmf -a
    $MAKE_PROG CC=gcc CCOPTIONS="-I/usr/local/include" XPMLIB="-L/usr/local/lib -lXpm" LDPOSTLIB= STD_INCLUDES=
}

reg install
install()
{
    mkdir -p $stagedir$prefix/bin
    mkdir -p $stagedir$prefix/man/man1
    setdir source
    cp xsnow $stagedir$prefix/bin
    cp xsnow.man $stagedir$prefix/man/man1/xsnow.1
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
