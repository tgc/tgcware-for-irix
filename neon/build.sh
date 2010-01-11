#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=neon
version=0.29.0
pkgver=1
source[0]=http://webdav.org/neon/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
configure_args="$configure_args --with-ssl=gnutls --with-egd=/var/run/egd-pool --disable-static --enable-shared --enable-ld-version-script=no"

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
    doc AUTHORS BUGS NEWS README THANKS TODO src/COPYING.LIB test/COPYING
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
