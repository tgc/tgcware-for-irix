#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gcc
version=4.3.4
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/gcc/releases/$topdir-$version/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gcc-4.3.0-include-sched_h.patch
patch[1]=gcc-4.3.3-libgomp-pthreads.patch
patch[2]=gcc-4.3.2-setrunon_np.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
defprefix=$prefix
prefix=/usr/tgcware/$topdir-$version
__configure="../$topsrcdir/configure"
make_build_target="bootstrap"

asld="--with-gnu-as --with-as=/usr/tgcware/bin/gas --without-gnu-ld --with-ld=/usr/bin/ld"
langs="--enable-languages=c,ada,c++,fortran,objc,obj-c++"
withjava=0

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
    withjava=0
    objdir=cccfoo_gtools
    [ $withada -eq 1 ] && export GNAT_ROOT=$HOME/gcc-3.4.0-20040204-mips-sgi-irix5.3 # Location of gnatbind
    configure_args="$global_config_args --enable-shared=libstdc++ $gnuas $gnuld"
fi
if [ "$_os" = "irix62" ]; then
    configure_args="$global_config_args --enable-shared --enable-threads=posix95"
    export CONFIG_SHELL=/usr/tgcware/bin/bash
    gas=1
    objdir=all_gas_pthreads
    #[ $withada -eq 1 ] && export GNAT_ROOT=/usr/tgcware/gcc-4.3.2/bin
    [ $withjava -eq 1 ] && configure_args="$configure_args --with-system-zlib --enable-java-awt=gtk"
fi

[ $withjava -eq 1 ] && langs="$langs,java"
configure_args="$configure_args $asld $langs"


# Setup tools
# 'ar' is safe for both IRIX 5.3 (needs it unconditionally with GNU as)
# and IRIX 6.x (needs it for running multi-abi testsuite, since IRIX ar
# will refuse to generate libtestc++.a with both 32bit and 64bit objs)
# With GNU ar we should also use GNU ranlib
setdir $srcdir
${__mkdir} -p tools
setdir tools
for tool in ar ranlib
do
    ${__ln} -sf /usr/tgcware/mips-sgi-$os/${tool} ${tool}
done
export PATH=$srcdir/tools:$PATH

#if [ $gas -eq 1 ]; then
#   export NM=/usr/tgcware/mips-sgi-$os/bin/nm
#   export AR=/usr/tgcware/mips-sgi-$os/bin/ar
#   export RANLIB=/usr/tgcware/mips-sgi-$os/bin/ranlib
#   export OBJDUMP=/usr/tgcware/mips-sgi-$os/bin/objdump
#   export NM_FOR_TARGET=/usr/tgcware/mips-sgi-$os/bin/nm
#   export AR_FOR_TARGET=/usr/tgcware/mips-sgi-$os/bin/ar
#   export RANLIB_FOR_TARGET=/usr/tgcware/mips-sgi-$os/bin/ranlib
#   export OBJDUMP_FOR_TARGET=/usr/tgcware/mips-sgi-$os/bin/objdump
#fi

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
    datestamp
    setdir source
    setdir ../$objdir
    ${__make} -k RUNTESTFLAGS="--target_board='unix{-mabi=n32,-mabi=32,-mabi=64}'" check
    datestamp
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
