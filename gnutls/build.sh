#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gnutls
version=2.8.5
pkgver=1
source[0]=ftp://ftp.gnutls.org/pub/gnutls/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --disable-static --disable-ld-version-script --disable-openssl-compatibility --disable-guile"
ac_overrides="ac_cv_func_inet_ntop=no ac_cv_func_inet_pton=no"

irix53 && patch[0]=gnutls-2.8.3-missing-siginterrupt.patch

reg prep
prep()
{
    generic_prep
    if irix53; then
	setdir source
	# We must "massage" libtool to not try and use the exported_symbol
	# and exports_file options since its use provokes an error from ld
	# export* and hidden* options are mutually exclusive so this will make
	# the linker error out in the feature test
	${__gsed} -i '/LDFLAGS.*\${wl}-exported_symbol/ s;exported_symbol;exported_symbol \${wl}foo \${wl}-hidden_symbol;' configure
	${__gsed} -i '/LDFLAGS.*\${wl}-exported_symbol/ s;exported_symbol;exported_symbol \${wl}foo \${wl}-hidden_symbol;' lib/configure
	${__gsed} -i '/LDFLAGS.*\${wl}-exported_symbol/ s;exported_symbol;exported_symbol \${wl}foo \${wl}-hidden_symbol;' libextra/configure
    fi
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
    doc AUTHORS COPYING COPYING NEWS README THANKS

    # libtool won't install these because of DESTDIR
    for x in gnutls-serv gnutls-cli gnutls-cli-debug psktool srptool certtool
    do
	${__install} -m755 src/.libs/$x ${stagedir}${prefix}/${_bindir}
    done
    custom_install=1
    generic_install DESTDIR
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
