#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=grep
version=2.5.1a
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"
set_configure_args '--prefix=$prefix --enable-nls --with-libiconv-prefix=/usr/local'

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
    doc NEWS
    ${RM} -f ${stagedir}${prefix}/${_infodir}/dir
    # Symlink manpages don't use .so for references
    setdir ${stagedir}${prefix}/${_mandir}/man1
    ${RM} -f egrep.1 fgrep.1
    ${LN} -s grep.1 egrep.1
    ${LN} -s grep.1 fgrep.1
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
