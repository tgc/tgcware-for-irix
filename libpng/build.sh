#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=libpng
version=1.2.5
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="PNG support library"

# Build system is *horrible* for libpng
# The makefile for IRIX/gcc is broken
# I will not attempt to fix it, just
# build with MIPS pro instead
ZLIBLIB="/usr/local/lib"
ZLIBINC="/usr/local/include"
CC="cc -rpath /usr/local/lib"
ABI="-n32"

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
    cp scripts/makefile.sgi Makefile
    $MAKE_PROG ZLIBLIB="$ZLIBLIB" ZLIBINC="$ZLIBINC" CC="$CC" ABI="$ABI"
}

reg install
install()
{
    mkdir -p $stagedir$prefix
    setdir source
    $MAKE_PROG DESTDIR=$stagedir ABI="-n32" install
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
