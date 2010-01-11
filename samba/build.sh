#!/usr/tgcware/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
# BuildRequires: gawk
###########################################################
# Check the following 4 variables before running the script
topdir=samba
version=3.0.28
pkgver=5
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=samba-3.0.28-irix-ld-argorder.patch
patch[1]=samba-3.0.28-replace-pread_pwrite.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -rpath /usr/tgcware/lib"

configure_args="--with-manpages-langs=en --with-libsmbclient \
		--prefix=$prefix --mandir=${prefix}/${_mandir} \
		--with-lockdir=${prefix}/var/locks --with-piddir=${prefix}/var/run \
		--with-privatedir=${prefix}/${_sysconfdir}/samba \
		--with-logfilebase=${prefix}/var/log/samba \
		--with-libdir=${prefix}/${_libdir}/samba \
		--with-configdir=${prefix}/${_sysconfdir}/samba \
		--with-swatdir=${prefix}/${_sharedir}/swat \
		--with-libiconv=/usr/tgcware"

if [ "$_os" = "irix53" ]; then
    patch[2]=samba-3.0.28-use-included-fnmatch.patch
    ac_overrides="ac_cv_func__pread=no ac_cv_func_pread=no ac_cv_func__pwrite=no ac_cv_func_pwrite=no samba_stat_hires=no samba_cv_fpie=no"
    configure_args="$configure_args --with-ldap=no --with-ads=no --with-cups=no"
fi
if [ "$_os" = "irix62" ]; then
    patch[2]=samba-3.0.11-ld.patch
    patch[3]=samba-3.0.25a-no-tcp.h.patch
    ac_overrides="samba_stat_hires=no samba_cv_fpie=no"
    configure_args="$configure_args --with-ldap --with-ads --with-cups"
fi

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
    ${__mv} ${stagedir}${prefix}/${_libdir}/samba/libsmbclient.so ${stagedir}${prefix}/${_libdir}
    ${__mv} ${stagedir}${prefix}/${_libdir}/samba/libmsrpc.so ${stagedir}${prefix}/${_libdir}

    # Create extra directories
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/init.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/rc0.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/rc2.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/config
    ${__mkdir} -p ${stagedir}${prefix}/var/locks
    ${__mkdir} -p ${stagedir}${prefix}/var/locks/winbindd_privileged
    ${__mkdir} -p ${stagedir}${prefix}/var/run
    ${__mkdir} -p ${stagedir}${prefix}/var/run/winbindd
    ${__mkdir} -p ${stagedir}${prefix}/${_sysconfdir}/samba

    # Install initscripts
    ${__install} -m 755 ${metadir}/samba.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_samba
    ${__install} -m 755 ${metadir}/winbind.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_winbind
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; ${__ln} -sf ../init.d/tgc_winbind K36tgc_winbind)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; ${__ln} -sf ../init.d/tgc_winbind S82tgc_winbind)
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; ${__ln} -sf ../init.d/tgc_samba K37tgc_samba)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; ${__ln} -sf ../init.d/tgc_samba S81tgc_samba)

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
    ${__mkdir} -p ${stagedir}${prefix}/${_vdocdir}/scripts
    ${__install} -m 755 ${srcdir}/${topsrcdir}/packaging/SGI/*swat.sh ${stagedir}${prefix}/${_vdocdir}/scripts

    # Misc files
    ${__install} -m 755 ${srcdir}/${topsrcdir}/source/script/mksmbpasswd.sh ${stagedir}${prefix}/${_bindir}
    ${__install} -m 755 ${srcdir}/${topsrcdir}/packaging/SGI/smbprint ${stagedir}${prefix}/${_bindir}
    ${__install} -m 644 ${srcdir}/${topsrcdir}/examples/smb.conf.default ${stagedir}${prefix}/${_sysconfdir}/samba/smb.conf

    # Fix up configfile paths
    ${__gsed} -i "s;log file = .*;log file = ${prefix}/var/log/samba/log.%m;" ${stagedir}${prefix}/${_sysconfdir}/samba/smb.conf

    # Nuke unneeded manpages
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man1/editreg.1*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man1/log2pcap.1*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man1/smbsh.1*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man7/pam_winbind.7*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man8/mount.cifs.8*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man8/smbmnt.8*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man8/smbmount.8*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man8/smbumount.8*
    ${__rm} -f ${stagedir}${prefix}/${_mandir}/man8/umount.cifs.8*

    doc README COPYING Manifest
    doc WHATSNEW.txt Roadmap
    doc docs/REVISION docs/Samba3-Developers-Guide.pdf docs/Samba3-ByExample.pdf
    doc docs/Samba3-HOWTO.pdf docs/THANKS docs/history
    doc docs/htmldocs
    doc docs/registry
    doc examples/autofs examples/LDAP examples/libsmbclient examples/misc examples/printer-accounting
    doc examples/printing

    ${__mkdir} -p ${stagedir}${prefix}/var/log/samba
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
