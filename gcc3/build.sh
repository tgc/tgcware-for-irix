#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=gcc
version=3.4.3
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gcc-3.4.3-genfixes.patch
patch[1]=gcc-3.4.3-iconv.patch
patch[2]=gcc-3.4.3-iconv-rpath.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Define abbreviated version number
abbrev_ver=$(echo $version|$SED -e 's/\.//g')

prefix=/usr/local/$topdir-$version

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

reg prep
prep()
{
    generic_prep
    # Regenerate configure to include libiconv fixes
    setdir source
    cd gcc
    autoreconf # 2.59
    cd ../libjava
    autoreconf # 2.59
}

reg build
build()
{
    global_config_args="--prefix=$prefix --with-local-prefix=$prefix --enable-languages=c,c++ --disable-nls --disable-shared --with-libiconv-prefix=/usr/local"
    if [ "$_os" = "irix53" ]; then
	export CONFIG_SHELL=/bin/ksh
	configure_args="$global_config_args"
    fi
    if [ "$_os" = "irix62" ]; then
	configure_args="$global_config_args --disable-multilib"
	export CC='/usr/people/tgc/bin/cc -n32 -mips3'
    fi
    # fix up releasenotes
    set_configure_args "$configure_args"
    setdir $srcdir
    mkdir -p objdir
    setdir $srcdir/objdir
    $srcdir/$topsrcdir/configure $configure_args
    $MAKE_PROG bootstrap
}

reg install
install()
{
    clean stage
    lprefix=/usr/local
    setdir $srcdir/objdir
    $MAKE_PROG INSTALL=$GINSTALL DESTDIR=$stagedir install
    $RM -f ${stagedir}${prefix}/${_infodir}/dir
    custom_install=1
    generic_install
}

reg pack
pack()
{
    iprefix=$topdir-$version
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
    setdir $srcdir
    ${RM} -rf objdir
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
