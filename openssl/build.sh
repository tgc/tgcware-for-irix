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
topdir=openssl
version=0.9.8a
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
ignore_deps="tgc_perl5.sw.base"
check_ac=0
__configure="./Configure"
mipspro=1
shared_args="--prefix=$prefix --openssldir=$prefix/ssl zlib shared"
[ "$_os" == "irix53" ] && configure_args="irix-mips1-gcc $shared_args"
[ "$_os" == "irix62" ] && configure_args="irix-mips3-cc $shared_args"
#set_configure_args="$configure_args"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $__configure $configure_args
    $GSED -i '/EX_LIBS/s;-lz;-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -lz;' Makefile
    $GSED -i '/^CFLAG=/s;.*=;CFLAG= -I/usr/tgcware/include;' Makefile
    $MAKE_PROG SHARED_LDFLAGS="-Wl,-rpath,${prefix}/${_libdir}" depend
    $MAKE_PROG SHARED_LDFLAGS="-Wl,-rpath,${prefix}/${_libdir}"
}

reg install
install()
{
    clean stage
    setdir source
    $MAKE_PROG INSTALL_PREFIX=$stagedir MANDIR=${prefix}/${_mandir} install
    setdir ${stagedir}${prefix}/${_mandir}
    for j in $($LS -1d man?)
    do
        cd $j
        for manpage in *
        do
            if [ -L "${manpage}" ]; then
                TARGET=`$LS -l "${manpage}" | $AWK '{ print $NF }'`
                $LN -sf "${TARGET}"ssl "${manpage}"ssl
                $RM -f "${manpage}"
            else
                $MV "$manpage" "$manpage""ssl"
            fi
        done
        cd ..
    done
    doc README CHANGES FAQ INSTALL LICENSE NEWS
    custom_install=1
    generic_install INSTALL_PREFIX
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
build_sh $*
