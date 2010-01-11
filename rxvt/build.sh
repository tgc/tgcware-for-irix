#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=rxvt
version=2.7.8
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=rxvt-2.7.6-utmp98.patch
#patch[1]=rxvt-2.7.6-i18nrc.patch
#patch[2]=rxvt-2.7.6-font.patch
#patch[3]=rxvt-2.7.5-gtoggle.patch
#patch[4]=rxvt-2.7.6-xim.patch
#patch[5]=rxvt-2.7.6-utmp98-2.patch
#patch[6]=rxvt-2.7.8-kp.patch
patch[0]=rxvt-2.7.8-security.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="RXVT"

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
    export LDFLAGS="-L/usr/local/lib -rpath /usr/local/lib"
    setdir source
    ./configure --enable-utmp --enable-wtmp --enable-xterm-scroll --enable-24bit --with-x
    $MAKE_PROG
}

reg install
install()
{
    generic_install DESTDIR
    mkdir -p $stagedir$prefix/share/rxvt
    cp $srcdir/$topsrcdir/doc/etc/rxvt.terminfo $stagedir$prefix/share/rxvt
}

reg pack
pack()
{
    clean meta
    setdir $stagedir$prefix
    create_idb
    cp $metadir/$topdir.idb.fixed $metadir/$topdir.idb
    create_spec
    make_dist
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
