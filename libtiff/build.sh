#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=libtiff
version=3.5.7
pkgver=3
source[0]=tiff-v$version.tar.gz
# If there are no patches, simply comment this
patch[0]=libtiff-v3.5.5-buildroot.patch
patch[1]=tiff-v3.5-shlib.patch
patch[2]=libtiff-v3.5.4-codecs.patch
patch[3]=libtiff-v3.5.7-include.patch
patch[4]=libtiff-v3.5.7-exit.patch
patch[5]=libtiff-v3.5.7-shlib.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="Tiff support library"

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

topsrcdir=tiff-v$version
subsysconf=$metadir/subsys.conf

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    sed -e "s;@STAGEROOT@;${stagedir};g" port/install.sh.in > port/install.sh.in.new;
    mv port/install.sh.in.new port/install.sh.in 
    CDPATH=""
    unset CDPATH
    export GCOPTS="-g -rpath $prefix/lib"
    export INSTALL='${SHELL} ../port/install.sh'
    ./configure << EOF
6
sysv-source-cat
yes
EOF
    (cd libtiff; ln -s libtiff.so.3.5 libtiff.so.3)
    (cd libtiff; ln -s libtiff.so.3.5 libtiff.so)
    $MAKE_PROG
    cp man/*.1 man/apps
}

reg install
install()
{
    mkdir -p $stagedir$prefix
    setdir source
    $MAKE_PROG install
    setdir $stagedir$prefix
    cd lib
    mv libtiff.so libtiff.so.3.5
    ln -s libtiff.so.3.5 libtiff.so.3
    ln -s libtiff.so.3.5 libtiff.so
    rm -rf ../man/cat1/apps
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
