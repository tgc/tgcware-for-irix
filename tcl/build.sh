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
topdir=tcl
version=8.4.12
pkgver=1
source[0]=$topdir$version-src.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="--prefix=$prefix --disable-symbols --enable-man-symlinks"
topsrcdir=$topdir$version

majorver="${version%.*}"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build unix
}

reg install
install()
{
    generic_install DESTDIR unix
    doc license.terms changes README
    setdir ${stagedir}${prefix}/${_bindir}
    ${LN} -s tclsh${majorver} tclsh
    setdir ${stagedir}${prefix}/${_libdir}
    ${LN} -s libtcl${majorver}.so libtcl.so

    # Grab headers
    ${MKDIR} -p ${stagedir}${prefix}/${_includedir}/tcl-private/{generic,unix}
    setdir ${srcdir}/${topsrcdir}
    ${FIND} generic unix -name "*.h" -print | ${TAR} -T - -cf - | (cd ${stagedir}${prefix}/${_includedir}/tcl-private; ${TAR} -xvBpf -)
    ( cd ${stagedir}${prefix}/${_includedir}
	for i in *.h ; do
	    [ -f ${stagedir}${prefix}/${_includedir}/tcl-private/generic/$i ] && ln -sf ../../$i ${stagedir}${prefix}/${_includedir}/tcl-private/generic ;
	done
    )

    # Cleanup references to the build
    $GSED -i "s|${srcdir}/${topsrcdir}/unix|${prefix}/${_libdir}|" ${stagedir}${prefix}/${_libdir}/tclConfig.sh
    $GSED -i "s|${srcdir}/${topsrcdir}|${prefix}/${_includedir}/tcl-private|" ${stagedir}${prefix}/${_libdir}/tclConfig.sh
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
