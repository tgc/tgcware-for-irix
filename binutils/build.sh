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
version=2.18
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CONFIG_SHELL=/bin/ksh
configure_args="--prefix=$prefix --program-prefix=g --disable-nls"

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
    $RM -f ${stagedir}${prefix}/${_mandir}/man1/g{dlltool,nlmconv,windres}*
    doc COPYING*
    setdir ${stagedir}${prefix}/${_libdir}
    ${__mv} ../lib32/*.a .
    ${__rmdir} ../lib32
    # Convert hardlinks to symlinks
    setdir ${stagedir}${prefix}/${_bindir}
    for p in ar as ld nm objcopy objdump ranlib strip; do
	${__ln} -sf ${prefix}/mips-sgi-${os}/bin/$p g$p
    done
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
