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
topdir=mc
version=4.6.1
pkgver=2
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=mc-4.6.1-snprintf.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --with-screen=ncurses --disable-rpath"
[ "$_os" = "irix62" ] && ac_overrides="ac_cv_lib_sun_getmntent=no ac_cv_lib_gen_getmntent=no ac_cv_lib_socket_socket=no"

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
    doc AUTHORS COPYING FAQ NEWS MAINTAINERS TODO README
    # Cleanup stage
    ${__rm} -rf ${stagedir}${prefix}/${_libdir}
    ${__rmdir} ${stagedir}${prefix}/${_sbindir}
    ${__rm} -rf ${stagedir}${prefix}/${_mandir}/{es,hu,it,man8,pl,ru,sr}
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
