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
topdir=glib
version=2.18.2
pkgver=2
source[0]=http://ftp.gnome.org/pub/gnome/sources/glib/2.18/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=glib-2.18.2-no-pthread.patch
patch[1]=glib-2.18.2-no-func.patch
patch[2]=glib-2.18.2-non_constant_initializer_fix.patch
patch[3]=glib-2.18.2-no-variadic-macros.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export PERL=/usr/tgcware/bin/perl
export PERL_PATH=/usr/tgcware/bin/perl
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --with-pcre=system --with-libiconv=gnu"
# Don't build with pth on 5.3
[ "$_os" = "irix53" ] && configure_args="$configure_args --with-threads=none"
# SGI cc has a nasty a habit of ignoring the #error directive
# For IRIX 5.3 we can use the old GNU ANSI preprocesser as a workaround
[ "$_os" = "irix53" ] && export CPP="cc -acpp -E"
# For MIPSpro we use -diag_error 1035 to make #error work properly
[ "$_os" = "irix62" ] && extra_cc_args="-diag_error 1035"
export CC="cc $extra_cc_args"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
    setdir source
    ${__make} README
}

reg install
install()
{
    generic_install DESTDIR
    ${__gsed} -i 's|local/perl|tgcware/perl|' ${stagedir}${prefix}/${_bindir}/glib-mkenums
    doc NEWS README COPYING
}

reg check
check()
{
    generic_check
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
