#!/usr/local/bin/bash

# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=automake14
version=1.4-p6
pkgver=4
source[0]=automake-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=automake-1.4-libtoolize.patch
patch[1]=automake-1.4-subdir.patch
patch[2]=automake-1.4-backslash.patch
patch[3]=automake-1.4-tags.patch
patch[4]=automake-1.4-subdirs-89656.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="GNU Automake"

topsrcdir=automake-$version

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
    autoreconf-2.57
    ./configure --prefix=/usr/local --disable-nls
    $MAKE_PROG
}

reg install
install()
{
    generic_install DESTDIR
    $RM -rf $stagedir$prefix/info
    $RM -f $stagedir$prefix/bin/aclocal $stagedir$prefix/bin/automake
    setdir source
    $MKDIR -p info
    $CP automake.info* info
    $GZIP -9nf info/*
    doc AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS TODO info
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
