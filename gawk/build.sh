#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=gawk
version=3.1.3
pkgver=2
source[0]=$topdir-$version.tar.bz2
source[1]=$topdir-$version-ps.tar.gz
# If there are no patches, simply comment this
patch[0]=gawk-3.1.0-shutup.patch
patch[1]=gawk-3.1.3-fix1.patch
patch[2]=gawk-3.1.3-fix2.patch
patch[3]=gawk-3.1.3-fix3.patch
patch[4]=gawk-3.1.3-fix4.patch
patch[5]=gawk-3.1.3-fix5.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="GNU Awk"

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

reg prep
prep()
{
    generic_prep
    unpack 1
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    $RM -f $stagedir$prefix/info/dir
    INSTALL="/usr/local/bin/install -c -D"
    setdir source
    cd doc
    for i in *.ps
    do
	$INSTALL -m 444 $i $stagedir$prefix/doc/$topdir-$version/$i
    done
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
