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
version=3.4.1
pkgver=3
source[0]=$topdir-$version.tar.bz2

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# If there are no patches, simply comment this
#patch[0]=

# Define abbreviated version number
abbrev_ver=$(echo $version|$SED -e 's/\.//g')

topinstalldir=/usr/local/$topdir-$version
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
    # Default to mips3, n32 ABI. No other ABI's available (--disable-multilib turns off o32 & n64)
    configure_args="--prefix=$prefix --enable-languages=c,c++ --disable-nls --disable-multilib"
    setdir $srcdir
    mkdir -p objdir
    setdir $srcdir/objdir
    $srcdir/$topsrcdir/configure $configure_args
    $MAKE_PROG bootstrap
    # Horrible horrible hack for Irix 6.2...
    echo "#undef MN_NAME_PAT" > $srcdir/objdir/gcc/fixinc/machname.h
    $MAKE_PROG bootstrap
}

reg install
install()
{
    lprefix=/usr/local
    setdir $srcdir/objdir
    $MAKE_PROG DESTDIR=$stagedir install
    $MKDIR ${stagedir}${lprefix}/${_libdir}
    $CP ${stagedir}${lprefix}/gcc-$version/$_libdir/*.so.* ${stagedir}${lprefix}/${_libdir}
    setdir ${stagedir}${lprefix}/${_libdir}
    $LN -sf libstdc++.so.7.1 libstdc++.so.7
    $RM -f ${stagedir}${prefix}/${_infodir}/dir
}

reg pack
pack()
{
    topinstalldir=/usr/local
    iprefix=$topdir-$version
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
