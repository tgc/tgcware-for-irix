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
topdir=tk
version=8.4.16
pkgver=2
source[0]=$topdir$version-src.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
configure_args="--prefix=$prefix --disable-symbols --enable-man-symlinks --with-tcl=${prefix}/${_libdir}"
topsrcdir=$topdir$version
export CC=cc
if [ "$_os" = "irix53" ]; then
    NO_RQS="-Wl,-no_rqs"
    mipspro=2
fi
[ "$_os" = "irix62" ] && mipspro=1

export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"     

majorver="${version%.*}"

reg prep
prep()
{
    generic_prep
    setdir $srcdir/$topsrcdir/unix
    [ "$_os" = "irix53" ] && ${__gsed} -i 's/SHLIB_LD="ld -shared -rdata_shared"/SHLIB_LD="ld -no_rqs -shared -rdata_shared"/' configure

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
    ${__ln} -s wish${majorver} wish
    setdir ${stagedir}${prefix}/${_libdir}
    ${__ln} -s libtk${majorver}.so libtk.so

    # Grab headers
    ${__mkdir} -p ${stagedir}${prefix}/${_includedir}/tk-private/{generic,unix}
    setdir ${srcdir}/${topsrcdir}
    ${__find} generic unix -name "*.h" -print | ${__tar} -T - -cf - | (cd ${stagedir}${prefix}/${_includedir}/tk-private; ${__tar} -xvBpf -)
    ( cd ${stagedir}${prefix}/${_includedir}
	for i in *.h ; do
	    [ -f ${stagedir}${prefix}/${_includedir}/tk-private/generic/$i ] && ln -sf ../../$i ${stagedir}${prefix}/${_includedir}/tk-private/generic ;
	done
    )

    # Cleanup references to the build
    ${__gsed} -i "s|${srcdir}/${topsrcdir}/unix|${prefix}/${_libdir}|" ${stagedir}${prefix}/${_libdir}/tkConfig.sh
    ${__gsed} -i "s|${srcdir}/${topsrcdir}|${prefix}/${_includedir}/tk-private|" ${stagedir}${prefix}/${_libdir}/tkConfig.sh
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
