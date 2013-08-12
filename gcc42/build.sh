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
version=4.2.4
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gcc-4.2.0-libgomp-posix95.patch
patch[1]=gcc-4.2.4-newgas.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
defprefix=$prefix
prefix=/usr/tgcware/$topdir-$version
__configure="../$topsrcdir/configure"
make_build_target="bootstrap"

gnuld="--with-gnu-ld --with-ld=/usr/tgcware/bin/gld"
gnuas="--with-gnu-as --with-as=/usr/tgcware/bin/gas"
langs="--with-gmp=/usr/tgcware --with-mpfr=/usr/tgcware --enable-languages=c,c++,fortran,objc,obj-c++"
withada=0
withjava=0
gas=0
gld=0

global_config_args="--prefix=$prefix --with-local-prefix=$prefix --disable-nls --with-libiconv-prefix=/usr/tgcware"

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
    configure_args+=(--enable-shared=libstdc++ $gnuas $gnuld)
fi
if [ "$_os" = "irix62" ]; then
    #configure_args+=(--disable-multilib --enable-shared=libstdc++)
    #export CC='/usr/people/tgc/bin/cc -n32 -mips3'
    configure_args+=(--enable-shared=libstdc++)
    #export CC=/usr/tgcware/gcc-3.4.6/bin/gcc
    export CONFIG_SHELL=/bin/ksh
    withada=1
    gas=1
    objdir=cccfooa_gas
    #[ $withada -eq 1 ] && export GNAT_ROOT=/usr/tgcware/gcc-3.4.6/bin
    [ $withjava -eq 1 ] && configure_args+=(--with-system-zlib --enable-java-awt=gtk)
fi

[ $withada -eq 1 ] && langs="$langs,ada"
[ $withjava -eq 1 ] && langs="$langs,java"
[ $gas -eq 1 ] && configure_args+=($gnuas)
[ $gld -eq 1 ] && configure_args+=($gnuld)
configure_args+=($langs)

# Define abbreviated version number
abbrev_ver=$(echo $version | ${__tr} -d '.')

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    mkdir -p ../$objdir
    generic_build ../$objdir
}

reg install
install()
{
    clean stage
    lprefix=/usr/tgcware
    setdir $srcdir/$objdir
    ${__make} INSTALL=$GINSTALL DESTDIR=$stagedir install
    ${__rm} -f ${stagedir}${prefix}/${_infodir}/dir
    custom_install=1
    generic_install
    ${__find} ${stagedir} -name '*.la' -print | ${__xargs} ${__rm} -f

    # Turn all the hardlinks in bin into symlinks
    setdir ${stagedir}${prefix}/${_bindir}
    for i in c++ mips-sgi-${os}-c++ mips-sgi-${os}-g++
    do
	${__ln} -sf ${prefix}/${_bindir}/g++ $i
    done
    for i in mips-sgi-${os}-gcc mips-sgi-${os}-gcc-$version
    do
	${__ln} -sf ${prefix}/${_bindir}/gcc $i
    done
    $LN -sf ${prefix}/${_bindir}/gfortran mips-sgi-${os}-gfortran
    doc COPYING* BUGS FAQ MAINTAINERS NEWS
    $MV ${stagedir}${prefix}/${_sharedir} ${stagedir}${lprefix}
}

reg check
check()
{
    setdir source
    setdir ../$objdir
    ${__make} -k RUNTESTFLAGS="--target_board='unix{-mabi=n32,-mabi=32,-mabi=64}'" check
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
    ${RM} -rf $objdir
    ${RM} -rf tools
}

###################################################
# No need to look below here
###################################################
build_sh $*
