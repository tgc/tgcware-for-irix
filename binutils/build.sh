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
topdir=binutils
version=2.19
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/binutils/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CONFIG_SHELL=/bin/ksh
configure_args="$configure_args --disable-nls --disable-werror"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man1/{dlltool,nlmconv,windres,windmc}*
    doc COPYING*
    setdir ${stagedir}${prefix}/${_libdir}
    if [ -d ../lib32 ]; then
	${__mv} ../lib32/*.a .
	${__rmdir} ../lib32
    fi

    setdir ${stagedir}${prefix}/${_bindir}
    # Remove known not working
    ${__rm} -f as ld strip

    # These might work but are not needed, rename them with g prefix
    ${__rm} -f ar nm objcopy ranlib

    # We leave objdump as it works well enough for our ldd replacement
    for p in objdump; do
	${__ln} -sf ${prefix}/mips-sgi-${os}/bin/$p $p
    done

    # Make compat symlink for gcc packages (on 6.2)
    ${__ln} -s ${prefix}/mips-sgi-${os}/bin/as gas
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
