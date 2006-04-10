#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gcc
version=3.4.6
pkgver=5
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gcc-3.4.3-genfixes.patch
patch[1]=gcc-3.4.3-iconv.patch
patch[2]=gcc-3.4.3-iconv-rpath.patch
patch[3]=gcc-3.4.6-md5.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
prefix=/usr/tgcware/$topdir-$version
__configure="../configure"
make_build_target=bootstrap

# Default GNU tools
gnuld="--with-gnu-ld --with-ld=/usr/tgcware/bin/gld"
gnuas="--with-gnu-as --with-as=/usr/tgcware/bin/gas"
# What languages should we build?
langs="--enable-languages=c"
withcc=1
withfortran=1
withobjc=1
withada=1
withjava=0

# Should we be using GNU binutils
gas=0
gld=0

# Set objdir
objdir=cccfoa_ntools

# Default configure arguments for all platforms
global_config_args="--prefix=$prefix --with-local-prefix=$prefix --disable-nls --with-libiconv-prefix=/usr/tgcware --enable-shared=libstdc++"
# Platform specific settings
if [ "$_os" = "irix53" ]; then
    export CONFIG_SHELL=/bin/ksh
    platform_configure_args=""
fi
if [ "$_os" = "irix62" ]; then
    #export CC='/usr/people/tgc/bin/cc -n32 -mips3'
    #mipspro=1
    if [ $withada -eq 1 ]; then
	# We need a gcc that understands ada and a gnatbind
	#export CC=$HOME/gcc-3.4-20031105-mips-sgi-irix6.2-bin/bin/gcc
	#export GNAT_ROOT=$HOME/gcc-3.4-20031105-mips-sgi-irix6.2-bin/bin
	#export PATH=$PATH:$HOME/gcc-3.4-20031105-mips-sgi-irix6.2-bin/bin
	export CC=gcc
	export GNAT_ROOT=/usr/tgcware/gcc-3.4.6/bin
    fi
    platform_configure_args="--disable-multilib"
fi
# End of platfor specific settings now setup the final configure_args
[ $withcc -eq 1 ] && langs="$langs,c++"
[ $withfortran -eq 1 ] && langs="$langs,f77"
[ $withobjc -eq 1 ] && langs="$langs,objc"
[ $withada -eq 1 ] && langs="$langs,ada"
[ $withjava -eq 1 ] && langs="$langs,java"
[ $gas -eq 1 ] && global_config_args="$global_config_args $gnuas"
[ $gld -eq 1 ] && global_config_args="$global_config_args $gnuld"
# For GNU tools we need a few extras
if [ $gld -eq 1 -o $gas -eq 1 ]; then
    export NM=/usr/tgcware/bin/gnm
    export AR=/usr/tgcware/bin/gar
    export RANLIB=/usr/tgcware/bin/granlib
    export NM_FOR_TARGET=/usr/tgcware/bin/gnm
    export AR_FOR_TARGET=/usr/tgcware/bin/gar
    export RANLIB_FOR_TARGET=/usr/tgcware/bin/granlib
fi

# Finally
configure_args="$global_config_args $langs $platform_configure_args"

# Define abbreviated version number
abbrev_ver=$(echo $version|$SED -e 's/\.//g')

reg prep
prep()
{
    generic_prep
    # Regenerate configure to include libiconv fixes
    setdir source
    (cd gcc && autoconf)
    (cd libjava && autoconf-2.13)
}

reg build
build()
{
    setdir source
    mkdir -p $objdir
    generic_build $objdir
    setdir $srcdir/$topsrcdir/$objdir
    $MAKE_PROG -C gcc gnatlib
    $MAKE_PROG -C gcc gnattools
}

reg install
install()
{
    clean stage
    lprefix=/usr/tgcware
    setdir $srcdir/$topsrcdir/$objdir
    $MAKE_PROG INSTALL=$GINSTALL DESTDIR=$stagedir install
    $RM -f ${stagedir}${prefix}/${_infodir}/dir
    custom_install=1
    generic_install
    gcclibdir=${stagedir}${prefix}/${_libdir}32
    $RM -f ${gcclibdir}/*.la

    # Turn all the hardlinks in bin into symlinks
    setdir ${stagedir}${prefix}/${_bindir}
    for i in c++ mips-sgi-${os}-c++ mips-sgi-${os}-g++
    do  
        $LN -sf g++ $i
    done
    for i in mips-sgi-${os}-gcc mips-sgi-${os}-gcc-$version
    do  
        $LN -sf gcc $i
    done
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
}

###################################################
# No need to look below here
###################################################
build_sh $*
