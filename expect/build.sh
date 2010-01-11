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
topdir=expect
version=5.43.0
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=expect-5.43-no-rpath.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CC=$(_upls $(${__sed} -n '/^TCL_CC=/s/.*=//p' /usr/tgcware/lib/tclConfig.sh))
if [ "$CC" = "cc" ]; then # tcl was built with cc
    mipspro=1
    # Can't include both inttypes.h and sys/types.h on 5.3 with cc
    [ "$_os" = "irix53" ] && ac_overrides="ac_cv_header_inttypes_h=no"
    [ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
else
    withgcc='--enable-gcc'
fi
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

configure_args="--prefix=$prefix --with-tcl=${prefix}/${_libdir} --with-tclinclude=${prefix}/${_includedir}/tcl-private --with-tkinclude=${prefix}/${_includedir}/tk-private --with-tk=${prefix}/${_libdir} --enable-shared $with_gcc"

shortroot=1
topsrcdir=$topdir-${version%.*}
majorver=5.43

reg prep
prep()
{
    generic_prep
    sleep 1
    touch configure
}

reg build
build()
{
    generic_build
}

reg install
install()
{
    generic_install prefix
    setdir ${stagedir}${prefix}/${_libdir}
    ${__ln} -s libexpect${majorver}.so libexpect.so
    ${__rm} -f ${_libdir}/expect-${majorver}/*.a
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
