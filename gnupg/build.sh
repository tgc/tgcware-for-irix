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
topdir=gnupg
version=1.4.9
pkgver=1
source[0]=ftp://ftp.gnupg.org/gcrypt/gnupg/$topdir-$version.tar.bz2
# If there are no patches, simply comment this

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# BuildRequires: readline, libz, gettext, iconv, openldap, libbz2
# Global settings
mipspro=1
export CC=cc
[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"
[ "$_os" = "irix53" ] && gzinfo=0 # gzipping the gnupg1.info file hangs compress during gendist :(
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
RNG="--enable-static-rnd=egd --with-egd-socket=/var/run/egd-pool"
configure_args="$configure_args --disable-rpath --disable-card-support $RNG"
[ "$_os" = "irix62" ] && ac_overrides="ac_cv_header_pthread_h=no"

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

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    doc AUTHORS COPYING NEWS PROJECTS README THANKS TODO
    ${__mv} ${stagedir}${prefix}/${_sharedir}/${name}/* ${stagedir}${prefix}/${_vdocdir}
    ${__mv} ${stagedir}${prefix}/${_vdocdir}/options.skel ${stagedir}${prefix}/${_sharedir}/${name}/
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
