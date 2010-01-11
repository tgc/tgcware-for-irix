#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gcc
version=3.4.6
pkgver=7
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gcc-3.4.3-genfixes.patch
patch[1]=gcc-3.4.3-iconv.patch
patch[2]=gcc-3.4.3-iconv-rpath.patch
patch[3]=gcc-3.4.6-no_rqs.patch
#patch[3]=gcc-3.4.6-md5.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
prefix=/usr/tgcware/$topdir-$version
__configure="../$topsrcdir/configure"
make_build_target=bootstrap

[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"

MY_LDFLAGS="$NO_RQS -Wl,-rpath,/usr/tgcware/lib"

# Default GNU tools
gnuld="--with-gnu-ld --with-ld=/usr/tgcware/bin/gld"
gnuas="--with-gnu-as --with-as=/usr/tgcware/bin/gas"
# What languages should we build?
langs="--enable-languages=c"
withcc=1
withfortran=1
withobjc=1
withada=0
withjava=0

# Should we be using GNU binutils?
gas=0
gld=0

# Set objdir
objdir=cccfoa_ntools

# Default configure arguments for all platforms
global_config_args="--prefix=$prefix --with-local-prefix=$prefix --disable-nls --with-libiconv-prefix=/usr/tgcware --enable-shared"
# Platform specific settings
if [ "$_os" = "irix53" ]; then
    export CONFIG_SHELL=/bin/ksh
    platform_configure_args=""
    withada=0
    objdir=cccfo_ntools_ldflags
    gas=0
    compiler_path=/usr/tgcware/gcc-3.4.6/bin
    if [ $withada -eq 1 ]; then
	export CC=$HOME/gcc-3.4.0-20040204-mips-sgi-irix5.3/bin/gcc
	export GNAT_ROOT=$HOME/gcc-3.4.0-20040204-mips-sgi-irix5.3
	export compiler_path="$HOME/gcc-3.4.0-20040204-mips-sgi-irix5.3/bin"
    fi
    export CC=$compiler_path/gcc
fi
if [ "$_os" = "irix62" ]; then
    #export CC='/usr/people/tgc/bin/cc -n32 -mips3'
    #mipspro=1
    compiler_path=/usr/tgcware/gcc-3.4.6/bin
    if [ $withada -eq 1 ]; then
	# We need a gcc that understands ada and a gnatbind
	#export compiler_path=$HOME/gcc-3.4-20031105-mips-sgi-irix6.2-bin/bin
	#export GNAT_ROOT=$HOME/gcc-3.4-20031105-mips-sgi-irix6.2-bin/bin
	#export PATH=$PATH:$HOME/gcc-3.4-20031105-mips-sgi-irix6.2-bin/bin
	export GNAT_ROOT=/usr/tgcware/gcc-3.4.6/bin
    fi
    export CC=$compiler_path/gcc
    platform_configure_args="--disable-multilib"
fi
# End of platform specific settings now setup the final configure_args
[ $withcc -eq 1 ] && langs="$langs,c++"
[ $withfortran -eq 1 ] && langs="$langs,f77"
[ $withobjc -eq 1 ] && langs="$langs,objc"
[ $withada -eq 1 ] && langs="$langs,ada"
[ $withjava -eq 1 ] && langs="$langs,java"
[ $gas -eq 1 ] && global_config_args="$global_config_args $gnuas"
[ $gld -eq 1 ] && global_config_args="$global_config_args $gnuld"

# For GNU tools we need a few extras
#if [ $gld -eq 1 -o $gas -eq 1 ]; then
#    export NM=/usr/tgcware/bin/gnm
#    export AR=/usr/tgcware/bin/gar
#    export RANLIB=/usr/tgcware/bin/granlib
#    export NM_FOR_TARGET=/usr/tgcware/bin/gnm
#    export AR_FOR_TARGET=/usr/tgcware/bin/gar
#    export RANLIB_FOR_TARGET=/usr/tgcware/bin/granlib
#fi

# Finally
configure_args="$global_config_args $langs $platform_configure_args"

# Make sure our desired host compiler is first in the path
# This mostly matters for the Ada builds where using gnatbind
# from the wrong release will fail
PATH=$compiler_path:$PATH

# Define abbreviated version number
abbrev_ver=$(echo $version|${__sed} -e 's/\.//g')

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
    ${__mkdir} -p ../$objdir
    echo "$__configure $configure_args"
    setdir $srcdir/$objdir
    ${__configure} $configure_args
    if [ "$_os" = "irix53" ]; then
	# Hack it up to add no_rqs and proper rpath.
	${__sed} -i "/^archive_cmds=/ s;so_locations;so_locations $MY_LDFLAGS;" mips-sgi-${os}/libobjc/libtool
	${__sed} -i "/^archive_cmds=/ s;so_locations;so_locations $MY_LDFLAGS;" mips-sgi-${os}/libf2c/libtool
    fi
    ${__make} BOOT_LDFLAGS="$MY_LDFLAGS" LDFLAGS="$MY_LDFLAGS" $make_build_target
    if [ "$withada" -eq 1 ]; then
	setdir $srcdir/$objdir
	${__make} -C gcc gnatlib
	${__make} -C gcc gnattools
    fi
}

reg install
install()
{
    clean stage
    lprefix=/usr/tgcware
    setdir $srcdir/$objdir
    ${__make} INSTALL=${__install} DESTDIR=$stagedir LDFLAGS="$MY_LDFLAGS" BOOT_LDFLAGS="$MY_LDFLAGS" install
    ${__rm} -f ${stagedir}${prefix}/${_infodir}/dir
    custom_install=1
    generic_install
    ${__find} ${stagedir} -name '*.la' -print | ${__xargs} ${__rm} -f

    # Turn all the hardlinks in bin into symlinks
    setdir ${stagedir}${prefix}/${_bindir}
    for i in c++ mips-sgi-${os}-c++ mips-sgi-${os}-g++
    do  
	${__rm} -f $i
        ${__ln} -sf g++ $i
    done
    for i in mips-sgi-${os}-gcc mips-sgi-${os}-gcc-$version
    do  
	${__rm} -f $i
        ${__ln} -sf gcc $i
    done
    doc COPYING* BUGS FAQ MAINTAINERS NEWS
    ${__mv} ${stagedir}${prefix}/${_sharedir} ${stagedir}${lprefix}

    # make -no_rqs a default linker param
    setdir ${stagedir}${prefix}/lib/gcc/mips-sgi-${os}/$version
    ${__gsed} -i 's/_SYSTYPE_SVR4/_SYSTYPE_SVR4 -no_rqs/' specs
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
    ${__rm} -rf $objdir
}

###################################################
# No need to look below here
###################################################
build_sh $*
