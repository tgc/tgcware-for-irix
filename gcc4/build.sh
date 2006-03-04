#!/usr/local/bin/bash
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
version=4.0.2
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
prefix=/usr/tgcware/$topdir-$version
__configure="../configure"
make_build_target=

global_config_args="--prefix=$prefix --with-local-prefix=$prefix --disable-nls --with-libiconv-prefix=/usr/tgcware --disable-shared"
if [ "$_os" = "irix53" ]; then
    export CONFIG_SHELL=/bin/ksh
    #export CC="cc -Wf,-XNg1500"
    export CC="/usr/tgcware/gcc-3.4.5/bin/gcc"
    export NM=/usr/tgcware/bin/gnm
    export AR=/usr/tgcware/bin/gar
    export RANLIB=/usr/tgcware/bin/granlib
    export NM_FOR_TARGET=/usr/tgcware/bin/gnm
    export AR_FOR_TARGET=/usr/tgcware/bin/gar
    export RANLIB_FOR_TARGET=/usr/tgcware/bin/granlib
#    export GNAT_ROOT=$HOME/gcc-3.4.0-20040204-mips-sgi-irix5.3 # Location of gnatbind
    configure_args="$global_config_args --with-gnu-as --with-as=/usr/tgcware/bin/gas --with-gnu-ld --with-ld=/usr/tgcware/bin/gld --enable-languages=c,c++"
#    configure_args="$global_config_args --enable-languages=c,c++"
fi
if [ "$_os" = "irix62" ]; then
    configure_args="$global_config_args --disable-multilib --enable-languages=c,c++ --disable-shared"
    export CC='/usr/people/tgc/bin/cc -n32 -mips3'
fi

objdir=ccc_gtools

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
    mkdir -p $objdir
    #setdir $srcdir/$objdir
    #$srcdir/$topsrcdir/configure $configure_args
    #$MAKE_PROG bootstrap
    generic_build $objdir
    #setdir source
    #setdir $objdir
    ##../configure $configure_args
    #$MAKE_PROG
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
    ${RM} -rf $objdir
}

###################################################
# No need to look below here
###################################################
build_sh $*
