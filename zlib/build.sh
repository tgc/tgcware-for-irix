#!/usr/local/bash/bin/bash
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
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=zlib-1.1.4-vsnprintf.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

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
    export LDSHARED="gcc -shared -static-libgcc"
    setdir source
    ./configure --prefix=$prefix
    $MAKE_PROG test
    ./configure --shared --prefix=$prefix
    $MAKE_PROG test
}

reg install
install()
{
    generic_install prefix
    setdir source
    $MKDIR -p ${stagedir}/${_mandir}/man3
    $CP zlib.3 ${stagedir}/${_mandir}/man3
    $CP libz.a ${stagedir}/${_libdir}
    doc README ChangeLog algorithm.txt minigzip.c example.c
    setdir stage
    $MV ${_includedir} ${_libdir} ${_mandir} ${stagedir}${prefix}
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
