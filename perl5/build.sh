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
topdir=perl
version=5.8.8
pkgver=2
source[0]=perl-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=perl-5.8.7-irix6-gcc34.patch
patch[1]=perl-5.8.7-telldir.patch
patch[2]=perl-5.8.7-shm.patch
patch[3]=perl-5.8.7-dbm.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
check_ac=0
__configure="sh Configure"
configure_args="-Dcc='gcc' -Darchname=${cpu}-irix -Dprefix=$prefix -Dmyhostname=localhost -Dcf_by='Tom G. Christensen' -Dcf_email='irixpkg@jupiterrise.com' -Dperladmin=root@localhost -Dinstallprefix=${stagedir}${prefix} -Dman3ext=3pm -Uinstallusrbinperl -Dpager='/usr/bin/more' -Dlocincpth='/usr/tgcware/include' -Dloclibpth='/usr/tgcware/lib' -des -Dinc_version_list='5.8.7 5.8.8'"
[ "$_os" = "irix53" ] && NO_RQS="-Wl,-no_rqs"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    $__configure -Dcc='gcc' -Darchname=${cpu}-irix -Dprefix=$prefix -Dmyhostname=localhost -Dcf_by='Tom G. Christensen' -Dcf_email='irixpkg@jupiterrise.com' -Dperladmin=root@localhost -Dinstallprefix=${stagedir}${prefix} -Dman3ext=3pm -Uinstallusrbinperl -Dpager='/usr/bin/more' -Dlocincpth='/usr/tgcware/include' -Dloclibpth='/usr/tgcware/lib' -des -Dinc_version_list='5.8.7 5.8.8'
    ${__make} LDDLFLAGS="-shared -L/usr/tgcware/lib -rpath /usr/tgcware/lib" CLDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
}

reg check
check()
{
    setdir source
    ${__make} test
}

reg install
install()
{
    generic_install UNKNOWN
    new_perl_lib=${stagedir}${prefix}/lib/$version
    new_arch_lib=${stagedir}${prefix}/lib/$version/${cpu}-irix
    new_perl_flags="export LD_LIBRARY_PATH=$new_arch_lib/CORE; export PERL5LIB=$new_perl_lib;"
    new_perl="${stagedir}${prefix}/bin/perl"
    echo "new_perl = $new_perl"
    # fix the packlist and friends
    $new_perl -i -p -e "s|$stagedir||g;" ${stagedir}${prefix}/lib/perl5/$version/${cpu}-irix/.packlist
    $new_perl -i -p -e "s|$stagedir||g;" ${stagedir}${prefix}/lib/perl5/$version/${cpu}-irix/Config.pm
    $new_perl -i -p -e "s|$stagedir||g;" ${stagedir}${prefix}/lib/perl5/$version/${cpu}-irix/Config_heavy.pl
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
