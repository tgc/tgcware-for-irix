#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=pcre
version=5.0
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export LDFLAGS="-Wl,-rpath,$prefix/lib -L.libs"
export CFLAGS="-g -O2 -Wl,-rpath,$prefix/lib -L.libs"

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
    setdir source
    ${MKDIR} .libs
    generic_build
    # Workaround libtool problems...
    setdir source
    ${SED} -e "s# libpcre.la# -L$srcdir/$topsrcdir/.libs libpcre.la#g" libpcreposix.la > libpcreposix.la.new
    ${MV} libpcreposix.la.new libpcreposix.la
}

reg install
install()
{
    generic_install DESTDIR
    doc NEWS AUTHORS ChangeLog LICENCE
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
