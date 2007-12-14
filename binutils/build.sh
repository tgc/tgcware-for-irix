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
pkgver=5
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
export CONFIG_SHELL=/bin/ksh
configure_args="$configure_args --disable-nls"

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
    # Convert hardlinks to symlinks
    setdir ${stagedir}${prefix}/${_bindir}
    ${__rm} -f as ld
    for p in ar nm objcopy objdump ranlib strip; do
	${__ln} -sf ${prefix}/mips-sgi-${os}/bin/$p $p
    done

    # Make compat symlink for gcc packages < 4.2.2 on 6.2
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
