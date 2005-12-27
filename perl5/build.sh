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
topdir=perl
version=5.8.7
pkgver=1
source[0]=perl-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=perl-5.8.7-irix6-gcc34.patch
patch[1]=perl-5.8.7-telldir.patch
patch[2]=perl-5.8.7-shm.patch
patch[3]=perl-5.8.7-dbm.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# We need to fix the .packlist if we want to convert and compress
# the manpages :(
catman=0
gzman=0
check_ac=0
prefix=$prefix/perl-$version
__configure="sh Configure"
configure_args="-Dcc='cc -n32' -Dprefix=$prefix -Dmyhostname=localhost -Dcf_email='irixpkg@jupiterrise.com' -Dperladmin=root@localhost -Dinstallprefix=${stagedir}${prefix} -Dman3ext=3pm -Uinstallusrbinperl -Dpager='/usr/bin/more' -Dlocincpth='/usr/tgcware/BerkeleyDB.4.3/include /usr/tgcware/include' -Dloclibpth='/usr/tgcware/BerkeleyDB.4.3/lib /usr/tgcware/lib' -des"
mipspro=1

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $__configure -Dcc='cc -n32' -Dprefix=$prefix -Dmyhostname=localhost -Dcf_email='irixpkg@jupiterrise.com' -Dperladmin=root@localhost -Dinstallprefix=${stagedir}${prefix} -Dman3ext=3pm -Uinstallusrbinperl -Dpager='/usr/bin/more' -Dlocincpth='/usr/tgcware/BerkeleyDB.4.3/include /usr/tgcware/include' -Dloclibpth='/usr/tgcware/BerkeleyDB.4.3/lib /usr/tgcware/lib' -des
    $MAKE_PROG LDDLFLAGS="-shared -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -L/usr/tgcware/BerkeleyDB.4.3/lib -Wl,-rpath,/usr/tgcware/BerkeleyDB.4.3/lib"
    $MAKE_PROG test
}

reg install
install()
{
    generic_install UNKNOWN
    new_perl_lib=${stagedir}${prefix}/lib/$version
    new_arch_lib=${stagedir}${prefix}/lib/$version/`uname -m`-irix
    new_perl_flags="export LD_LIBRARY_PATH=$new_arch_lib/CORE; export PERL5LIB=$new_perl_lib;"
    new_perl="${stagedir}${prefix}/bin/perl"
    echo "new_perl = $new_perl"
    # fix the packlist and friends
    $new_perl -i -p -e "s|$stagedir||g;" ${stagedir}${prefix}/lib/$version/`uname -m`-irix/.packlist
    for i in ${stagedir}${prefix}/bin/*
    do
	if [ ! -z "`head -1 $i|grep perl`" ]; then
	    $new_perl -i -p -e "s|$stagedir||g;" $i
	fi
    done
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
