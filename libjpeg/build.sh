#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=libjpeg
version=6b
pkgver=5
source[0]=jpegsrc.v6b.tar.gz
# If there are no patches, simply comment this
patch[0]=jpeg-c++.patch
patch[1]=libjpeg-6b-arm.patch
patch[2]=libjpeg-6b-soname.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

shortroot=1
topsrcdir=jpeg-$version
set_configure_args '--prefix=$prefix --disable-static --enable-shared'

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
    export LDFLAGS='-rpath /usr/local/lib'
    export INSTALL="/usr/local/bin/install -c -D"
    setdir source
    ./configure $(_upls $configure_args)
    LD_LIBRARY_PATH=$PWD $MAKE_PROG test
    $MAKE_PROG
}

reg install
install()
{
    generic_install prefix
    doc README usage.doc
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
