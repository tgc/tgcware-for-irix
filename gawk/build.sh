#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=gawk
version=3.1.4
pkgver=1
source[0]=$topdir-$version.tar.bz2
source[1]=$topdir-$version-ps.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global options
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

reg prep
prep()
{
    generic_prep
    unpack 1
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    doc AUTHORS COPYING FUTURES LIMITATIONS NEWS POSIX.STD PROBLEMS README
    setdir source
    cd doc
    for i in *.ps
    do
	${GINSTALL} -m 444 $i ${stagedir}${prefix}/${_vdocdir}
    done

    # Nuke redundant hardlinks
    ${RM} -f ${stagedir}${prefix}/${_bindir}/*-3.1.4
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
