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
topdir=gettext
version=0.14.5
pkgver=3
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
set_configure_args '--prefix=$prefix --mandir=$prefix/${_mandir} --with-libiconv-prefix=/usr/tgcware'

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
    doc NEWS README
    # Fix up these 4 manpages to use symlinks instead of nroff include style
    setdir ${stagedir}${prefix}/${_mandir}/man3
    ${RM} -f dcgettext.3 dcngettext.3 dgettext.3 dngettext.3
    ${LN} -s gettext.3 dcgettext.3
    ${LN} -s ngettext.3 dcngettext.3
    ${LN} -s gettext.3 dgettext.3
    ${LN} -s ngettext.3 dngettext.3
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
