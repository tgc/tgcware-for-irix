#!/usr/local/bash/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=gcc2
version=2.95.3
pkgver=2
source[0]=gcc-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="GNU GCC" 

topsrcdir=gcc-$version
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
    $srcdir/$topsrcdir/configure --prefix=$prefix --with-gnu-as --with-as=/usr/local/bin/as --enable-shared --enable-languages=c,c++ --disable-nls
    $MAKE_PROG bootstrap
}

reg install
install()
{
    setdir $srcdir/objdir
    $MAKE_PROG prefix=$stagedir install
    setdir stage
    mkdir gcc-$version
    mv * gcc-$version
    mkdir lib
    cp gcc-$version/lib/libstdc++*.so.* lib
}

reg pack
pack()
{
    topinstalldir=/usr/local
    catman=0
    subsysconf=$metadir/subsys.conf
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
