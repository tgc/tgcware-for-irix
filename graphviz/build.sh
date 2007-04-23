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
topdir=graphviz
version=2.6
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
ac_overrides="ac_cv_lib_gen_basename=no"

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
    ${MKDIR} -p ${stagedir}${prefix}/${_vdocdir}
    ${RM} -f ${stagedir}${prefix}/${_libdir}/graphviz/*.la
    ${MV} ${stagedir}${prefix}/${_sharedir}/graphviz/doc/* ${stagedir}${prefix}/${_vdocdir}
    ${RMDIR} ${stagedir}${prefix}/${_sharedir}/graphviz/doc
    ${RM} -f ${stagedir}${prefix}/${_libdir}/graphviz/pkgIndex.tcl
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
