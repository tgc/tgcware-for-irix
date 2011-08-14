#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
if [ "$(uname -r)" = "5.3" ]; then
  # Can't use 'updates' on IRIX 5.3, so no renaming/re-versioning possible :(
  topdir=libstdcxx7
  version=7
  pkgver=8
else
  topdir=libstdcxx_7
  version=1
  pkgver=3
fi
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
irix62 && gccver=4.5.2 && gccdir=gcc45 && version=$gccver
irix53 && gccver=4.5.3 && gccdir=gcc45

reg prep
prep()
{
    : nothing to prep
}

reg build
build()
{
    : nothing to build
}

reg install
install()
{
    echo "BuildRequires: tgc_gcc $gccver"
    clean stage
    ${__mkdir} -p ${stagedir}${prefix}/$_libdir
    [ "$_os" = "irix62" ] && libsuffix=32
    (cd $prefix/$gccdir/${_libdir}${libsuffix}; ${__tar} -cf - libstdc++.so.7*) |
    (cd ${stagedir}${prefix}/${_libdir}; ${__tar} -xvpf -)
    # cleanup
    ${__rm} -f ${stagedir}${prefix}/${_libdir}/*.py

    # fix up relnotes
    ${__sed} -e "s/@@GCCVER@@/$gccver/g" ${metadir}/relnotes.${_os} > ${metadir}/relnotes.$_os.txt
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN relnotes.$_os.txt"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
