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
version=4.3.0
pkgver=2
#source[0]=$topdir-$version.tar.bz2
source[0]=gcc-4.3.0.tar.bz2
# If there are no patches, simply comment this
patch[0]=gcc-4.3-posix95-fix.patch
patch[1]=gcc-4.3.0-include-sched_h.patch
patch[2]=gcc-4.2.0-libgomp-posix95.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
defprefix=$prefix
prefix=/usr/tgcware/$topdir-$version
__configure="../$topsrcdir/configure"
make_build_target="bootstrap"

gnuld="--with-gnu-ld --with-ld=/usr/tgcware/bin/gld"
gnuas="--with-gnu-as --with-as=/usr/tgcware/bin/gas"
langs="--enable-languages=c,c++,fortran,objc,obj-c++"
withada=0
withjava=0
gas=0
gld=0

datestamp()
{
    date +%Y%m%d%H%M
}

global_config_args="--prefix=$prefix --with-local-prefix=$prefix --disable-nls --with-libiconv-prefix=/usr/tgcware --with-gmp=/usr/tgcware --with-mpfr=/usr/tgcware"

if [ "$_os" = "irix53" ]; then
    export CONFIG_SHELL=/bin/ksh
    #export CC="cc -Wf,-XNg1500"
    export CC="/usr/tgcware/gcc-3.4.6/bin/gcc"
    gas=1
    gld=1
    withada=0
    withjava=0
    objdir=cccfoo_gtools
    [ $withada -eq 1 ] && export GNAT_ROOT=$HOME/gcc-3.4.0-20040204-mips-sgi-irix5.3 # Location of gnatbind
    configure_args="$global_config_args --enable-shared=libstdc++ $gnuas $gnuld"
fi
if [ "$_os" = "irix62" ]; then
    #configure_args="$global_config_args --disable-multilib --enable-shared=libstdc++"
    #export CC='cc -n32 -mips3'
    #configure_args="$global_config_args --enable-shared=libstdc++"
    #configure_args="$global_config_args --enable-shared --enable-threads=posix95"
    configure_args="$global_config_args --enable-threads=single --disable-libgomp"
    export CC=/usr/tgcware/gcc-4.2.1/bin/gcc
    export CONFIG_SHELL=/usr/tgcware/bin/bash
    withada=1
    gas=1
    #objdir=cccfooa_gas
    objdir=all_gas_nothreads
    [ $withada -eq 1 ] && export GNAT_ROOT=/usr/tgcware/gcc-4.2.1/bin
    [ $withjava -eq 1 ] && configure_args="$configure_args --with-system-zlib --enable-java-awt=gtk"
fi

if [ $gas -eq 1 -o $gld -eq 1 ]; then
#    configure_args="$configure_args --with-build-time-tools=$srcdir/tools"
#    setdir $srcdir
#    ${MKDIR} tools
#    setdir tools
#    for tool in nm ar ranlib objdump as strip
#    do
#	$LN -sf /usr/tgcware/bin/g${tool} ${tool}
#    done
#    #$LN -sf /bin/ld .
##    export PATH=/usr/tgcware/mips-sgi-$os/bin:$PATH
   : export NM=/usr/tgcware/bin/gnm
   : export AR=/usr/tgcware/bin/gar
   : export RANLIB=/usr/tgcware/bin/granlib
   : export OBJDUMP=/usr/tgcware/bin/gobjdump
   : export NM_FOR_TARGET=/usr/tgcware/bin/gnm
   : export AR_FOR_TARGET=/usr/tgcware/bin/gar
   : export RANLIB_FOR_TARGET=/usr/tgcware/bin/granlib
   : export OBJDUMP_FOR_TARGET=/usr/tgcware/bin/gobjdump
fi
[ $withada -eq 1 ] && langs="$langs,ada"
[ $withjava -eq 1 ] && langs="$langs,java"
[ $gas -eq 1 ] && configure_args="$configure_args $gnuas"
[ $gld -eq 1 ] && configure_args="$configure_args $gnuld"
configure_args="$configure_args $langs"

# Define abbreviated version number
abbrev_ver=$(echo $version|${__sed} -e 's/\.//g')

reg prep
prep()
{
    datestamp
    generic_prep
    datestamp
}

reg build
build()
{
    datestamp
    setdir source
    mkdir -p ../$objdir
    echo "$__configure $configure_args"
    generic_build ../$objdir
    datestamp
}

reg install
install()
{
    clean stage
    lprefix=/usr/tgcware
    setdir $srcdir/$objdir
    ${__make} DESTDIR=$stagedir install
    ${__rm} -f ${stagedir}${prefix}/${_infodir}/dir
    custom_install=1
    generic_install
    ${__find} ${stagedir} -name '*.la' -print | ${__xargs} ${__rm} -f

    # Turn all the hardlinks in bin into symlinks
    setdir ${stagedir}${prefix}/${_bindir}
    for i in c++ mips-sgi-${os}-c++ mips-sgi-${os}-g++
    do
	${__ln} -sf g++ $i
    done
    for i in mips-sgi-${os}-gcc mips-sgi-${os}-gcc-$version
    do
	${__ln} -sf gcc $i
    done
    ${__ln} -sf gfortran mips-sgi-${os}-gfortran
    doc COPYING* MAINTAINERS NEWS
    ${__mv} ${stagedir}${prefix}/${_sharedir} ${stagedir}${lprefix}
}

reg check
check()
{
    setdir source
    setdir ../$objdir
    #$MAKE_PROG -k check
    ${__make} -k RUNTESTFLAGS="--target_board='unix{,-mabi=32,-mabi=64}'" check
}

reg pack
pack()
{
    __configure="configure"
    iprefix=$topdir-$version
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
    setdir $srcdir
    ${__rm} -rf $objdir
    ${__rm} -rf tools
}

###################################################
# No need to look below here
###################################################
build_sh $*
