#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=xpm
version=3.4k
pkgver=5
source[0]=xpm-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libxpm-3.4k-shlib.patch
patch[1]=libxpm-3.4k-sxpm.patch
patch[2]=libxpm-3.4k-cxpm.patch
patch[3]=xpm-3.4k-security-fixes.patch
patch[4]=xpm-3.4k-size-max.patch
patch[5]=libxpm-3.4k-sxpm-shlibs.patch

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
    setdir source
    $MAKE_PROG -f Makefile.noX DEFINES="-DNEEDS_SIZE_MAX"
}

reg install
install()
{
    clean stage
    setdir source
    $MAKE_PROG INSTALL=/usr/local/bin/install DESTDIR=$stagedir -f Makefile.noX install
    $MAKE_PROG INSTALL=/usr/local/bin/install DESTDIR=$stagedir -f Makefile.noX install.man
    setdir $stagedir$prefix/lib
    ln -s libXpm.so.4.11 libXpm.so.4
    ln -s libXpm.so.4.11 libXpm.so
    doc doc/xpm.PS.gz FAQ.html README.html
    custom_install=1
    generic_install
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
