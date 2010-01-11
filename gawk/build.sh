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
topdir=gawk
version=3.1.5
pkgver=3
source[0]=$topdir-$version.tar.bz2
source[1]=$topdir-$version-ps.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global options
export CC=cc
[ "$_os" = "irix62" ] && mipspro=1
if [ "$_os" = "irix53" ]; then
    mipspro=2
    NO_RQS="-Wl,-no_rqs "
fi
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

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
