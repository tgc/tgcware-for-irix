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
version=1.19
pkgver=12
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=groff-1.18.1-Imakefile.patch
patch[1]=groff-1.19-inttypes-irix53.patch
patch[2]=groff-1.19-nroff-shell.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

# This package has a shallow stagedir
shortroot=1

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    export LDFLAGS="-L/usr/local/lib -rpath /usr/local/lib"
    generic_build
    setdir source
    (cd doc && makeinfo groff.texinfo)
    cd src/xditview
    xmkmf -a # Produces kinda broken makefiles using -mips2 -32 :(
    if [ "$_os" == "irix53" ]; then
	$MAKE_PROG CC=cc CCOPTIONS="-xansi -32 -mips1" LDPOSTLIB=
    else
	$MAKE_PROG CC=cc CCOPTIONS="-xansi -n32 -mips3 -woff 1116,1174" LDPOSTLIB=
    fi
}

reg install
install()
{
    generic_install prefix
    setdir source
    cd src/xditview
    $MAKE_PROG DESTDIR=$stagedir install
    setdir stage
    ${RM} -f info/dir
    ${MV} usr/bin/* bin
    ${MV} usr/lib/* lib
    ${RM} -rf usr
    ${MV} bin/X11/* bin
    ${RMDIR} bin/X11
    custom_install=1
    generic_install
    doc ChangeLog NEWS PROBLEMS PROJECTS TODO
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
