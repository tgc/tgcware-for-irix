#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=perl
version=5.8.5
pkgver=3
source[0]=perl-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=perl-5.8.5-irix6-gcc34.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Custom prefix
prefix=/usr/local/perl-$version

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
    sh Configure -Dcc=gcc -Dprefix=$prefix -Dmyhostname=localhost -Dcf_by='Tom G. Christensen <irixpkg@jupiterrise.com>' -Dperladmin=root@localhost -Dinstallprefix=${stagedir}${prefix} -Dman3ext=3pm -Uinstallusrbinperl -Dpage='/usr/bin/more' -des
    $MAKE_PROG LDDLFLAGS="-shared -L/usr/local/lib -Wl,-rpath,/usr/local/lib"
    $MAKE_PROG test
}

reg install
install()
{
    generic_install UNKNOWN
    new_perl_lib=${stagedir}${prefix}/lib/$version
    new_arch_lib=${stagedir}${prefix}/lib/$version/`uname -m`-irix
    new_perl_flags="export LD_LIBRARY_PATH=$new_arch_lib/CORE; export PERL5LIB=$new_perl_lib;"
    new_perl="${stagedir}${prefix}/bin/perl"
    echo "new_perl = $new_perl"
    # fix the packlist and friends
    $new_perl -i -p -e "s|$stagedir||g;" ${stagedir}${prefix}/lib/$version/`uname -m`-irix/.packlist
    for i in ${stagedir}${prefix}/bin/*
    do
	if [ ! -z "`head -1 $i|grep perl`" ]; then
	    $new_perl -i -p -e "s|$stagedir||g;" $i
	fi
    done
}

reg pack
pack()
{
    # We need to fix the .packlist if we want to convert and compress
    # the manpages :(
    catman=0
    gzman=0
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
