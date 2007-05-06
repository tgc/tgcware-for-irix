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
topdir=postfix
version=2.2.10
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

[ "$_os" = "irix62" ] && patch[0]=postfix-2.2.10-sa_len.patch

# Global settings
export CC=gcc
export CCARGS="-I/usr/tgcware/include -DHAS_PCRE -DNO_IPV6 -DDEF_CONFIG_DIR=\\\"${prefix}/${_sysconfdir}/postfix\\\""
export AUXLIBS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -lpcre"
no_configure=1

lprefix=${prefix#/*}

# users
postfix_uid=189
postfix_gid=189
postfix_user=postfix
postfix_group=postfix
postdrop_group=postdrop
maildrop_group=postdrop
maildrop_gid=190
# dirs
varspoolprefix=
postfix_config_dir=${_sysconfdir}/postfix
postfix_daemon_dir=libexec/postfix
postfix_command_dir=${_sbindir}
postfix_queue_dir=var/spool/postfix
postfix_doc_dir=${_vdocdir}
postfix_sample_dir=${postfix_doc_dir}/samples
postfix_readme_dir=${postfix_doc_dir}/README_FILES

reg prep
prep()
{
    generic_prep
}

reg build
build()
{

    setdir source
    $MAKE_PROG -f Makefile.init makefiles
    unset CCARGS AUXLIBS
    generic_build
}

reg install
install()
{
    clean stage
    $RM -f $metadir/ops
    setdir source
    sh postfix-install -non-interactive \
	install_root=${stagedir} \
	config_directory=${prefix}/${postfix_config_dir} \
	daemon_directory=${prefix}/${postfix_daemon_dir} \
	command_directory=${prefix}/${postfix_command_dir} \
	queue_directory=${varspoolprefix}/${postfix_queue_dir} \
	sendmail_path=${prefix}/${postfix_command_dir}/sendmail \
	newaliases_path=${prefix}/${_bindir}/newaliases \
	mailq_path=${prefix}/${_bindir}/mailq \
	mail_owner=$postfix_user \
	setgid_group=$maildrop_group \
	manpage_directory=${prefix}/${_mandir} \
	sample_directory=${prefix}/${postfix_sample_dir} \
	readme_directory=${prefix}/${postfix_readme_dir} || exit 1

    for i in active bounce corrupt defer deferred flush incoming private saved maildrop public pid saved trace; do
	$MKDIR -p ${stagedir}${varspoolprefix}/${postfix_queue_dir}/$i
    done
    
    # install performance benchmark tools by hand
    for i in smtp-sink smtp-source ; do
      $GINSTALL -c -m 755 bin/$i ${stagedir}${prefix}/${postfix_command_dir}/
      $GINSTALL -c -m 755 man/man1/$i.1 ${stagedir}${prefix}/${_mandir}/man1/
    done

    # Fix up postfix-files to leave out manpages, documentation etc. 
    $GSED -i '/sample_directory/d' ${stagedir}${prefix}/${postfix_config_dir}/postfix-files
    $GSED -i '/html_directory/d' ${stagedir}${prefix}/${postfix_config_dir}/postfix-files
    $GSED -i '/readme_directory/d' ${stagedir}${prefix}/${postfix_config_dir}/postfix-files
    $GSED -i '/manpage_directory/d' ${stagedir}${prefix}/${postfix_config_dir}/postfix-files

    # install qshape
    mantools/srctoman - auxiliary/qshape/qshape.pl > qshape.1
    $GINSTALL -c qshape.1 ${stagedir}${prefix}/${_mandir}/man1/qshape.1
    $GINSTALL -c auxiliary/qshape/qshape.pl ${stagedir}${prefix}/${postfix_command_dir}/qshape
    $GSED -i '/#!/s|bin|tgcware/bin|' ${stagedir}${prefix}/${postfix_command_dir}/qshape

    # Install initscript
    $MKDIR -p ${stagedir}/${_sysconfdir}/init.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc0.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/rc2.d
    $MKDIR -p ${stagedir}/${_sysconfdir}/config

    $CP $metadir/postfix.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_postfix
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_postfix
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; $LN -sf ../init.d/tgc_postfix K02tgc_postfix)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; $LN -sf ../init.d/tgc_postfix S99tgc_postfix)
    # Don't run by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_postfix
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_postfix config(noupdate)" >> $metadir/ops
    $GSED -i "s/@@PREFIX@@/$varspoolprefix/g" ${stagedir}/${_sysconfdir}/init.d/tgc_postfix
    [ "$_os" = "irix53" ] && mailservice=mail || mailservice=sendmail
    $GSED -i "s/@@MAILSERVICE@@/$mailservice/" ${stagedir}/${_sysconfdir}/init.d/tgc_postfix

    # protect configfiles
    for file in access canonical generic header_checks main.cf makedefs.out master.cf relocated transport virtual aliases
    do
	echo "${lprefix}/${postfix_config_dir}/$file config(suggest)" >> $metadir/ops
    done

    # Add pre-install script
    $MKDIR -p ${stagedir}${prefix}/${_vdocdir}/contrib
    $SED -e "s;@@POSTFIX_UID@@;$postfix_uid;" \
	-e "s;@@POSTFIX_GID@@;$postfix_gid;" \
	-e "s;@@POSTFIX_USER@@;$postfix_user;" \
	-e "s;@@POSTFIX_GROUP@@;$postfix_group;" \
	-e "s;@@MAILDROP_GROUP@@;$maildrop_group;" \
	-e "s;@@MAILDROP_GID@@;$maildrop_gid;" \
	-e "s;@@POSTFIX_QUEUE_DIR@@;$varspoolprefix/$postfix_queue_dir;" \
	$metadir/preinstall.sh > ${stagedir}${prefix}/${_vdocdir}/contrib/preinstall.sh
    chmod 755 ${stagedir}${prefix}/${_vdocdir}/contrib/preinstall.sh
    echo "${lprefix}/${_vdocdir}/contrib/preinstall.sh postop(${prefix}/${_vdocdir}/contrib/preinstall.sh)" >> $metadir/ops
    # Run set-permissions after installation
    echo "${lprefix}/${_sbindir}/postfix exitop(${prefix}/${_sbindir}/postfix set-permissions)" >> $metadir/ops

    custom_install=1
    generic_install

    doc RELEASE_NOTES COMPATIBILITY AAAREADME html
}

reg pack
pack()
{
    metainstalldir=$prefix
    topinstalldir=/
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
