#!/usr/local/bash/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=gcc
version=3.3
pkgver=1
source[0]=gcc-3.3.tar.bz2

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# If there are no patches, simply comment this
#patch[0]=$srcfiles/gcc-3.1-3.1.1.diff
#patch[1]=$srcfiles/gcc-3.1.1-3.2.diff
#patch[2]=$srcfiles/gcc-3.2-3.2.1.diff
#patch[3]=$srcfiles/gcc-3.2.1-3.2.2.diff
#patch[3]=$srcfiles/gcc-3.2.2-3.2.3.diff


# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="GNU GCC" 
pkgname=$pkgprefixgcc33

topinstalldir=/usr/local/gcc-$version
prefix=$topinstalldir

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
    setdir $srcdir
    mkdir -p objdir
    setdir $srcdir/objdir
    $srcdir/$topsrcdir/configure --prefix=$prefix --enable-languages=c,c++ --disable-nls
    $MAKE_PROG bootstrap
}

reg install
install()
{
    generic_install DESTDIR
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
