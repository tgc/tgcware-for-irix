#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=libungif
version=4.1.0b1
pkgver=2
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=libungif-4.1.0-stdarg.patch
patch[1]=libungif-CVS.patch
patch[2]=libungif-4.1.0b1-include.patch
patch[3]=libungif-4.1.0b1-gif2iris.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="libungif"

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
    # we need automake & aclocal, prepare temporary links in $HOME/bin
    ln -s /usr/local/bin/automake-1.6 $HOME/bin/automake
    ln -s /usr/local/bin/aclocal-1.6 $HOME/bin/aclocal
    export LDFLAGS="-Wl,-rpath,/usr/local/lib"
    export CXXFLAGS="-L/usr/local/lib"
    setdir source
    autoreconf-2.57 --install --force
    ./configure --prefix=$prefix
    $MAKE_PROG
    rm -f $HOME/bin/automake
    rm -f $HOME/bin/aclocal
}

reg install
install()
{
    generic_install DESTDIR
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
