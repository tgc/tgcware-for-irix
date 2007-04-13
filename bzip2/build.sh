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
topdir=bzip2
version=1.0.3
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=bzip2-1.0.3-soname.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $MAKE_PROG -f Makefile LDFLAGS="-Wl,-rpath,/usr/tgcware/lib"
    $MAKE_PROG -f Makefile-libbz2_so CC="gcc -Wl,-rpath,/usr/tgcware/lib"
}

reg install
install()
{
    clean stage
    setdir source
    ${MKDIR} -p ${stagedir}${prefix}/{${_bindir},${_mandir}/man1,${_libdir},${_includedir}}
    ${GINSTALL} -m 755 bzlib.h ${stagedir}${prefix}/${_includedir}
    ${GINSTALL} -m 755 libbz2.so.1.0.3 ${stagedir}${prefix}/${_libdir}
    ${GINSTALL} -m 755 libbz2.a ${stagedir}${prefix}/${_libdir}
    ${GINSTALL} -m 755 bzip2-shared  ${stagedir}${prefix}/${_bindir}/bzip2
    ${GINSTALL} -m 755 bzip2recover bzgrep bzdiff bzmore ${stagedir}${prefix}/${_bindir}/
    ${GINSTALL} -m 644 bzip2.1 bzdiff.1 bzgrep.1 bzmore.1 ${stagedir}${prefix}/${_mandir}/man1/
    ${LN} -s bzip2 ${stagedir}${prefix}/${_bindir}/bunzip2
    ${LN} -s bzip2 ${stagedir}${prefix}/${_bindir}/bzcat
    ${LN} -s bzdiff ${stagedir}${prefix}/${_bindir}/bzcmp
    ${LN} -s bzmore ${stagedir}${prefix}/${_bindir}/bzless
    ${LN} -s libbz2.so.1.0.3 ${stagedir}${prefix}/${_libdir}/libbz2.so.1
    ${LN} -s libbz2.so.1.0.3 ${stagedir}${prefix}/${_libdir}/libbz2.so.1.0
    ${LN} -s libbz2.so.1 ${stagedir}${prefix}/${_libdir}/libbz2.so
    ${LN} -s bzip2.1 ${stagedir}${prefix}/${_mandir}/man1/bzip2recover.1
    ${LN} -s bzip2.1 ${stagedir}${prefix}/${_mandir}/man1/bunzip2.1
    ${LN} -s bzip2.1 ${stagedir}${prefix}/${_mandir}/man1/bzcat.1
    ${LN} -s bzdiff.1 ${stagedir}${prefix}/${_mandir}/man1/bzcmp.1
    ${LN} -s bzmore.1 ${stagedir}${prefix}/${_mandir}/man1/bzless.1

    doc LICENSE CHANGES README README.COMPILATION.PROBLEMS Y2K_INFO
    custom_install=1
    generic_install
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
