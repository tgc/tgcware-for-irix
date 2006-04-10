#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
# BuildRequires: gawk
###########################################################
# Check the following 4 variables before running the script
topdir=samba
version=3.0.22
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=samba-3.0.11-ld.patch
patch[1]=samba-3.0.13-header.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -rpath /usr/tgcware/lib"

configure_args='\
	--with-manpages-langs=en \
	--with-libsmbclient \
	--with-ldap \
	--with-ads \
	--with-cups \
	--prefix=$prefix \
	--with-lockdir=${prefix}/var/locks \
	--with-piddir=${prefix}/var/run \
	--with-privatedir=${prefix}/${_sysconfdir}/samba \
	--with-logfilebase=${prefix}/var/log/samba \
	--with-libdir=${prefix}/${_libdir}/samba \
	--with-configdir=${prefix}/${_sysconfdir}/samba \
	--with-swatdir=${prefix}/${_sharedir}/swat \
	--with-libiconv=/usr/tgcware \
	'

ac_overrides="samba_stat_hires=no"

topinstalldir=/
pkgdefprefix=usr/tgcware
subsysconf=$metadir/subsys.conf

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build source
}

reg install
install()
{
    generic_install DESTDIR source

    # Move shared libraries to where clients can find it
    ${MV} ${stagedir}${prefix}/${_libdir}/samba/libsmbclient.so ${stagedir}${prefix}/${_libdir}
    ${MV} ${stagedir}${prefix}/${_libdir}/samba/libmsrpc.so ${stagedir}${prefix}/${_libdir}

    # Create extra directories
    ${MKDIR} -p ${stagedir}/${_sysconfdir}/init.d
    ${MKDIR} -p ${stagedir}/${_sysconfdir}/rc0.d
    ${MKDIR} -p ${stagedir}/${_sysconfdir}/rc2.d
    ${MKDIR} -p ${stagedir}/${_sysconfdir}/config
    ${MKDIR} -p ${stagedir}${prefix}/var/locks
    ${MKDIR} -p ${stagedir}${prefix}/var/locks/winbindd_privileged
    ${MKDIR} -p ${stagedir}${prefix}/var/run
    ${MKDIR} -p ${stagedir}${prefix}/var/run/winbindd
    ${MKDIR} -p ${stagedir}${prefix}/${_sysconfdir}/samba

    # Install initscripts
    ${GINSTALL} -m 755 ${metadir}/samba.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_samba
    ${GINSTALL} -m 755 ${metadir}/winbind.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_winbind
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_winbind K36tgc_winbind)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_winbind S82tgc_winbind)
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_samba K37tgc_samba)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_samba S81tgc_samba)

    # Create default options file
    cat << EOF > ${stagedir}/${_sysconfdir}/config/tgc_samba.options
# Put options for smbd, nmbd and winbindd here
#SMBDOPTIONS=
#NMBDOPTIONS=
#WINBINDDOPTIONS=
EOF

    # Create default lmhosts files
    echo "127.0.0.1 localhost" > ${stagedir}${prefix}/${_sysconfdir}/samba/lmhosts

    # Turn services "off" by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_samba
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_winbind

    # Preserve existing settings
    echo "${_sysconfdir}/config/tgc_samba config(noupdate)" > $metadir/ops
    echo "${_sysconfdir}/config/tgc_winbind config(noupdate)" >> $metadir/ops
    echo "${_sysconfdir}/config/tgc_samba.options config(suggest)" >> $metadir/ops
    echo "${pkgdefprefix}/${_sysconfdir}/samba/smb.conf config(suggest)" >> $metadir/ops
    echo "${pkgdefprefix}/${_sysconfdir}/samba/lmhosts config(suggest)" >> $metadir/ops

    # Add SWAT enable/disable scripts to doc/scripts
    ${MKDIR} -p ${stagedir}${prefix}/${_vdocdir}/scripts
    ${GINSTALL} -m 755 ${srcdir}/${topsrcdir}/packaging/SGI/*swat.sh ${stagedir}${prefix}/${_vdocdir}/scripts

    # Misc files
    ${GINSTALL} -m 755 ${srcdir}/${topsrcdir}/source/script/mksmbpasswd.sh ${stagedir}${prefix}/${_bindir}
    ${GINSTALL} -m 755 ${srcdir}/${topsrcdir}/packaging/SGI/smbprint ${stagedir}${prefix}/${_bindir}
    ${GINSTALL} -m 644 ${srcdir}/${topsrcdir}/examples/smb.conf.default ${stagedir}${prefix}/${_sysconfdir}/samba/smb.conf

    # Nuke unneeded manpages
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man1/editreg.1*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man1/log2pcap.1*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man1/smbsh.1*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man7/pam_winbind.7*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man8/mount.cifs.8*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man8/smbmnt.8*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man8/smbmount.8*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man8/smbumount.8*
    ${RM} -f ${stagedir}${prefix}/${_mandir}/man8/umount.cifs.8*

    doc README COPYING Manifest
    doc WHATSNEW.txt Roadmap
    doc docs/REVISION docs/Samba-Developers-Guide.pdf docs/Samba-Guide.pdf
    doc docs/Samba-HOWTO-Collection.pdf docs/THANKS docs/history
    doc docs/htmldocs
    doc docs/registry
    doc examples/autofs examples/LDAP examples/libsmbclient examples/misc examples/printer-accounting
    doc examples/printing
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN ops"
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
