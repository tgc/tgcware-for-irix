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
topdir=flac
version=1.2.1
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=flac-1.2.1-needstrio.patch
patch[1]=flac-1.2.1-no-stdint_h.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

[ "$_os" = "irix53" ] && patch[2]=flac-1.2.1-missing_fseeko_ftello.patch

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args='--prefix=$prefix --mandir=${prefix}/${_mandir} --infodir=${prefix}/${_infodir} --disable-rpath --disable-xmms-plugin --enable-static=no'

reg prep
prep()
{
    generic_prep
    libtoolize -f
    aclocal-1.10 -I m4
    automake-1.10
    autoheader
    autoconf
    # The libiconv stuff is broken :(
    # This needs GNU sed with inplace editing!
    ${__find} . -name 'Makefile.in' -print | ${__xargs} -n1 ${__gsed} -i 's/@LIBICONV@/@LTLIBICONV@/g'
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
    doc COPYING* AUTHORS README
    # Libtool installed its shellscript wrapper instead of the actual binary :(
    ${__install} -m755 ${srcdir}/${topsrcdir}/src/metaflac/.libs/metaflac ${stagedir}${prefix}/${_bindir}/metaflac
    ${__install} -m755 ${srcdir}/${topsrcdir}/src/flac/.libs/flac ${stagedir}${prefix}/${_bindir}/flac
    # This is a bit ugly, but we need to rerun the strip function normally called from generic_install
    do_strip
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
