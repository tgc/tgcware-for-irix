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
topdir=gawk
version=3.1.5
pkgver=1
source[0]=$topdir-$version.tar.bz2
source[1]=$topdir-$version-ps.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global options
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

reg prep
prep()
{
    generic_prep
    unpack 1
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
    doc AUTHORS COPYING FUTURES LIMITATIONS NEWS POSIX.STD PROBLEMS README
    setdir source
    cd doc
    for i in *.ps
    do
	${GINSTALL} -m 444 $i ${stagedir}${prefix}/${_vdocdir}
    done

    # Nuke redundant hardlinks
    ${RM} -f ${stagedir}${prefix}/${_bindir}/*-3.1.5
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
