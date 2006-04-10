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
version=4.1.0
pkgver=3
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
defprefix=$prefix
prefix=/usr/tgcware/$topdir-$version
__configure="../$topsrcdir/configure"
make_build_target="bootstrap"

gnuld="" # "--with-gnu-ld --with-ld=/usr/tgcware/bin/gld"
gnuas="--with-gnu-as --with-as=/usr/tgcware/bin/gas"
langs="--with-gmp=/usr/tgcware --with-mpfr=/usr/tgcware --enable-languages=c,c++,fortran,objc,obj-c++"
withada=1
[ $withada -eq 1 ] && langs="$langs,ada"

objdir=cccfooa_gas

global_config_args="--prefix=$prefix --with-local-prefix=$prefix --disable-nls --with-libiconv-prefix=/usr/tgcware $langs"

if [ "$_os" = "irix53" ]; then
    export CONFIG_SHELL=/bin/ksh
    #export CC="cc -Wf,-XNg1500"
    export CC="/usr/tgcware/gcc-3.4.5/bin/gcc"
    [ $withada -eq 1 ] && export GNAT_ROOT=$HOME/gcc-3.4.0-20040204-mips-sgi-irix5.3 # Location of gnatbind
    configure_args="$global_config_args --disable-shared $gnuas $gnuld"
fi
if [ "$_os" = "irix62" ]; then
    configure_args="$global_config_args --disable-multilib $gnuas --enable-shared=libstdc++"
    #export CC='/usr/people/tgc/bin/cc -n32 -mips3'
    export CC=/usr/tgcware/gcc-3.4.6/bin/gcc
    export GNAT_ROOT=/usr/tgcware/gcc-3.4.6/bin
fi

if [ -n "$gnuas" -o -n "$gnuld" ]; then
   export NM=/usr/tgcware/bin/gnm
   export AR=/usr/tgcware/bin/gar
   export RANLIB=/usr/tgcware/bin/granlib
   export NM_FOR_TARGET=/usr/tgcware/bin/gnm
   export AR_FOR_TARGET=/usr/tgcware/bin/gar
   export RANLIB_FOR_TARGET=/usr/tgcware/bin/granlib
fi

# Define abbreviated version number
abbrev_ver=$(echo $version|$SED -e 's/\.//g')

reg prep
prep()
{
    generic_prep
#    # Regenerate configure to include libiconv fixes
#    setdir source
#    cd gcc
#    autoreconf # 2.59
#    cd ../libjava
#    autoreconf # 2.59
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
    $MAKE_PROG INSTALL=$GINSTALL DESTDIR=$stagedir install
    $RM -f ${stagedir}${prefix}/${_infodir}/dir
    custom_install=1
    generic_install
    gcclibdir=${stagedir}${prefix}/${_libdir}32
    deflibdir=${stagedir}${defprefix}/${_libdir}
    $RM -f ${gcclibdir}/*.la

    ############### begin
    # This should be handled in a seperate gcc runtime package
    # to avoid deps on the versioned gcc package
    #$MKDIR -p ${deflibdir}
    #$MV ${gcclibdir}/libstdc++.so.* ${deflibdir}
    #$MV ${gcclibdir}/libgcc_s.so.1 ${deflibdir}/libgcc_s-${version}.so.1
    #setdir ${gcclibdir}
    #$LN -sf ../../${_libdir}/libstdc++.so.7.7 libstdc++.so
    #$LN -sf ../../${_libdir}/libgcc_s-${version}.so.1 libgcc_s.so
    #$LN -sf ../../${_libdir}/libgcc_s.so.1 libgcc_s.so
    #setdir ${deflibdir}
    #$LN -sf libgcc_s-${version}.so.1 libgcc_s.so.1
    #################### end
    
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
    $LN -sf gfortran mips-sgi-${os}-gfortran
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
}

###################################################
# No need to look below here
###################################################
build_sh $*
