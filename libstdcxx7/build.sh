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
  pkgver=7
else
  topdir=libstdcxx_7
  version=1
  pkgver=2
fi
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
irix62 && gcc=4.3.4 && version=$gcc
irix53 && gcc=3.4.6

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
    echo "BuildRequires: tgc_gcc $gcc"
    clean stage
    ${__mkdir} -p ${stagedir}${prefix}/$_libdir
    [ "$_os" = "irix62" ] && libsuffix=32
    (cd $prefix/gcc-$gcc/${_libdir}${libsuffix}; ${__tar} -cf - libstdc++.so.7*) |
    (cd ${stagedir}${prefix}/${_libdir}; ${__tar} -xvpf -)

    # fix up relnotes
    ${__sed} -e "s/@@GCCVER@@/$gcc/" ${metadir}/relnotes > ${metadir}/relnotes.$_os.txt
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
