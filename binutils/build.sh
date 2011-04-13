#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=binutils
version=2.21
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/binutils/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

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
    ${__rm} -f ld ld.bfd strip

    # Not strictly needed for 6.2 so don't ship them
    irix62 && ${__rm} -f ar nm objcopy

    # Turn the rest into symlinks
    for p in as objdump ranlib; do
	${__ln} -sf ${prefix}/mips-sgi-${os}/bin/$p $p
    done

    # Make compat symlink for gcc packages (on 6.2)
    irix62 && ${__ln} -s ${prefix}/mips-sgi-${os}/bin/as gas

    # convert hardlink to save space
    setdir ../mips-sgi-${os}/bin
    ${__ln} -sf ${prefix}/mips-sgi-${os}/bin/ld ld.bfd
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
