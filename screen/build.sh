#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=screen
version=4.0.2
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=screen-4.0.2-makefile-madness.diff

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

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
    configure_args="$(_upls $configure_args)"
    setdir source
    ./configure $configure_args
    # We hardcode LIBS to avoid linking with unneeded -lcrypt -lsun
    $MAKE_PROG LIBS="-lcurses -lelf"
}

reg install
install()
{
    generic_install DESTDIR
    setdir source
    $CP terminfo/screeninfo.src ${stagedir}${prefix}/share/${topdir}
    $MKDIR -p ${stagedir}${prefix}/etc
    $CP etc/etcscreenrc ${stagedir}${prefix}/etc/screenrc
    # Add two useful hacks to screenrc
    cat << EOF >> ${stagedir}${prefix}/etc/screenrc
# special xterm hardstatus: use the window title.
termcapinfo xterm 'hs:ts=\E]2;:fs=\007:ds=\E]2;screen\007'

hardstatus string "[screen %n%?: %t%?] %h"
EOF
    $RM -f ${stagedir}${prefix}/${_infodir}/dir
    doc NEWS README doc/README.DOTSCREEN doc/FAQ
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
