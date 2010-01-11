#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=WindowMaker
version=0.80.1
pkgver=3
source[0]=$topdir-$version.tar.gz
source[1]=libdockapp-0.4.0.tar.gz
# If there are no patches, simply comment this
patch[0]=WindowMaker-0.80.1-width-height.patch
patch[1]=WindowMaker-appicon_captions_maxprotect.patch
patch[2]=WindowMaker-fpo-80.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="WindowMaker"
pkgcat="application"
pkgvendor="http://www.windowmaker.org"
pkgdesc="A NeXTstep like WindowManager"

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
    export LDFLAGS="-Wl,-rpath,$prefix/lib"
    setdir source
    ./configure --prefix=$prefix --disable-nls --with-appspath=$prefix/lib/GNUstep
    $MAKE_PROG
}

reg install
install()
{
    generic_install DESTDIR
    # remove sk manpages (bogus location too!)
    rm -rf $stagedir$prefix/man/sk
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
