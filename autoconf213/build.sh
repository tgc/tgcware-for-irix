#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=autoconf213
version=2.13
pkgver=2
source[0]=autoconf-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=   #autoconf-2.12-race.patch - use /bin/mktemp
patch[1]=autoconf-2.13-mawk.patch
patch[2]=autoconf-2.13-notmp.patch
patch[3]=autoconf-2.13-c++exit.patch
patch[4]=autoconf-2.13-headers.patch
patch[5]=autoconf-2.13-autoscan.patch
patch[6]=autoconf-2.13-exit.patch
patch[7]=autoconf-2.13-wait3test.patch
patch[8]=autoconf-2.13-make-defs-62361.patch
patch[9]=autoconf-2.13-versioning.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="GNU Autoconf"

topsrcdir=autoconf-$version

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
    ./configure --prefix=$prefix --program-suffix=-$version --disable-nls
    $MAKE_PROG
}

reg install
install()
{
    generic_install prefix
    # standards*.info belongs with binutils...
    $RM -f $stagedir/info/standards*
    $MV $stagedir/info/autoconf.info $stagedir/info/$topdir.info
    $GZIP -9nf $stagedir/info/*.info
    doc AUTHORS COPYING NEWS README TODO
}

reg pack
pack()
{
    shortroot=1
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
