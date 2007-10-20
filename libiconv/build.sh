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
topdir=libiconv
version=1.11
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=libiconv-1.11-noiconv.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export LDFLAGS="-L$prefix/lib -Wl,-rpath,$prefix/lib"
configure_args='--prefix=$prefix --mandir=$prefix/${_mandir} --enable-extra-encodings'

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
    doc NOTES ChangeLog DESIGN NEWS
    # Nuke "html" manpages :(
    ${RM} -rf ${stagedir}${prefix}/${_docdir}/$topdir
    ${RM} -rf ${stagedir}${prefix}/${_docdir}/iconv*.html
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
