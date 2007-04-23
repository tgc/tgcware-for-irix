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
topdir=expect
version=5.43.0
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --with-tcl=${prefix}/${_libdir} --with-tclinclude=${prefix}/${_includedir}/tcl-private --with-tkinclude=${prefix}/${_includedir}/tk-private --with-tk=${prefix}/${_libdir} --enable-gcc --enable-shared"

topsrcdir=$topdir-${version%.*}
majorver=5.43

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
    generic_install INSTALL_ROOT
    setdir ${stagedir}${prefix}/${_libdir}
    ${LN} -s libexpect${majorver}.so libexpect.so
    doc FAQ README HISTORY

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
