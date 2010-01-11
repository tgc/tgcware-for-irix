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
topdir=krb5
version=1.4.4
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=2006-002-patch.txt
patch[1]=krb5-1.4.3-CVE-2007-0957-prelim.patch
patch[2]=krb5-1.6-CVE-2007-0956-prelim.patch
patch[3]=krb5-1.6-CVE-2007-1216-prelim.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
patch_prefix="-p0"
export PERL="/usr/tgcware/bin/perl"
kerbdir=krb5
prefix=${prefix}/${kerbdir}
configure_args='--prefix=$prefix --without-krb4 --disable-ipv6 --disable-thread-support'
ac_overrides="ac_cv_func_inet_pton=no ac_cv_func_inet_ntop=no"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build src
}

reg install
install()
{
    ${GSED} -i '/^INSTALL_SETUID/s/ -o root//g' ${srcdir}/${topsrcdir}/src/clients/ksu/Makefile
    generic_install DESTDIR src
    ${MKDIR} -p ${stagedir}${topinstalldir}/${_bindir}
    ${MV} ${stagedir}${prefix}/${_bindir}/krb5-config ${stagedir}${topinstalldir}/${_bindir}
    # Fix manpage name
    ${MV} ${stagedir}${prefix}/${_mandir}/man5/.k5login.5 ${stagedir}${prefix}/${_mandir}/man5/dot.k5login.5
    (
	setdir ${stagedir}${prefix}/${_mandir}/man8
	${RM} -f kadmin.local.8
	$LN -s kadmin.8 kadmin.local.8
    )
    (
	setdir source
	cd doc
# Info files are somewhat broken
#	for i in *.texinfo; do
#	    makeinfo $i
#	done
#	${MKDIR} -p ${stagedir}${topinstalldir}/${_infodir}
#	${GINSTALL} -m 644 *.info ${stagedir}${topinstalldir}/${_infodir}
	${MKDIR} -p ${stagedir}${topinstalldir}/${_vdocdir}/html
	${GINSTALL} -m 644 *.ps ${stagedir}${topinstalldir}/${_vdocdir}
	${GINSTALL} -m 644 *.html ${stagedir}${topinstalldir}/${_vdocdir}/html
    )

    # Fix rpath flag in krb5-config
    ${GSED} -i "/^RPATH_FLAG/s/=.*/='-rpath '/g" ${stagedir}${topinstalldir}/${_bindir}/krb5-config
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
