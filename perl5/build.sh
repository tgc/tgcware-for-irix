#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=perl5
version=5.6.1
pkgver=1
source[0]=perl-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${HOME}/buildpkg/scripts/buildpkg.functions

# Fill in pkginfo values if necessary
# using pkgname,name,pkgcat,pkgvendor & pkgdesc
name="Perl"

topsrcdir=perl-$version
topinstalldir=/usr/local/perl-$version
prefix=$topinstalldir

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
	sh Configure -Dcc=gcc -Dprefix=/usr/local/perl-5.6.1 -Uinstallusrbinperl -des	
	$MAKE_PROG
	$MAKE_PROG test
}

reg install
install()
{
	echo "Unable to install this direcly to a staging area"
	echo "Will attempt installation to $prefix"
	clean stage
	setdir source
	$MAKE_PROG install
	setdir stage
	mkdir -p $stagedir$prefix
	mv $prefix $stagedir/usr/local
	$STRIP $stagedir$prefix/bin/perl
	$STRIP $stagedir$prefix/bin/perl5.6.1
	$STRIP $stagedir$prefix/bin/a2p
	chown -R tgc:user *
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
