#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=groff
version=1.18.1
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=groff-1.18.1-Imakefile.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="GNU Groff"

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
    ./configure --prefix=/usr/local
    $MAKE_PROG
    (cd doc && makeinfo groff.texinfo)
    cd src/xditview
    xmkmf -a # Produces kinda broken makefiles using -mips2 -32 :(
    make CC=cc CCOPTIONS="-xansi -n32 -mips3 -woff 1116,1174" LDPOSTLIB=
}

reg install
install()
{
    generic_install prefix
    setdir source
    cd src/xditview
    make DESTDIR=$stagedir install
    setdir stage
    rm -f info/dir
    mv usr/bin/* bin
    mv usr/lib/* lib
    rm -rf usr
}

reg pack
pack()
{
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
