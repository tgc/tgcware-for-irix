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
topdir=postfix
version=2.8.2
pkgver=1
source[0]=ftp://ftp.acat.se/official/$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CC=gcc
export CCARGS="-I/usr/tgcware/include -DUSE_TLS -DHAS_PCRE -DNO_IPV6 -DDEF_CONFIG_DIR=\\\"${prefix}/${_sysconfdir}/postfix\\\""
export AUXLIBS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -lpcre -lssl -lcrypto"
no_configure=1
useautodir=0

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
    ${__make} -f Makefile.init makefiles
    unset CCARGS AUXLIBS
    generic_build
}

reg install
install()
{
    clean stage
    ${__rm} -f $metadir/ops
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
	${__mkdir} -p ${stagedir}${varspoolprefix}/${postfix_queue_dir}/$i
    done
    
    # install performance benchmark tools by hand
    for i in smtp-sink smtp-source ; do
      ${__install} -c -m 755 bin/$i ${stagedir}${prefix}/${postfix_command_dir}/
      ${__install} -c -m 755 man/man1/$i.1 ${stagedir}${prefix}/${_mandir}/man1/
    done

    # Fix up postfix-files to leave out manpages, documentation etc. 
    ${__gsed} -i '/sample_directory/d' ${stagedir}${prefix}/${postfix_daemon_dir}/postfix-files
    ${__gsed} -i '/html_directory/d' ${stagedir}${prefix}/${postfix_daemon_dir}/postfix-files
    ${__gsed} -i '/readme_directory/d' ${stagedir}${prefix}/${postfix_daemon_dir}/postfix-files
    ${__gsed} -i '/manpage_directory/d' ${stagedir}${prefix}/${postfix_daemon_dir}/postfix-files

    # install qshape
    mantools/srctoman - auxiliary/qshape/qshape.pl > qshape.1
    ${__install} -c qshape.1 ${stagedir}${prefix}/${_mandir}/man1/qshape.1
    ${__install} -c auxiliary/qshape/qshape.pl ${stagedir}${prefix}/${postfix_command_dir}/qshape
    ${__gsed} -i '/#!/s|bin|tgcware/bin|' ${stagedir}${prefix}/${postfix_command_dir}/qshape

    # Install initscript
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/init.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/rc0.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/rc2.d
    ${__mkdir} -p ${stagedir}/${_sysconfdir}/config

    ${__cp} $metadir/postfix.init.irix ${stagedir}/${_sysconfdir}/init.d/tgc_postfix
    chmod 755 ${stagedir}/${_sysconfdir}/init.d/tgc_postfix
    (setdir ${stagedir}/${_sysconfdir}/rc0.d; ${__ln} -sf ../init.d/tgc_postfix K02tgc_postfix)
    (setdir ${stagedir}/${_sysconfdir}/rc2.d; ${__ln} -sf ../init.d/tgc_postfix S99tgc_postfix)
    # Don't run by default
    echo "off" > ${stagedir}/${_sysconfdir}/config/tgc_postfix
    # Preserve existing on/off setting
    echo "${_sysconfdir}/config/tgc_postfix config(noupdate)" >> $metadir/ops
    ${__gsed} -i "s/@@PREFIX@@/$varspoolprefix/g" ${stagedir}/${_sysconfdir}/init.d/tgc_postfix
    [ "$_os" = "irix53" ] && mailservice=mail || mailservice=sendmail
    ${__gsed} -i "s/@@MAILSERVICE@@/$mailservice/" ${stagedir}/${_sysconfdir}/init.d/tgc_postfix

    # protect configfiles
    for file in access canonical generic header_checks main.cf makedefs.out master.cf relocated transport virtual aliases
    do
	echo "${lprefix}/${postfix_config_dir}/$file config(suggest)" >> $metadir/ops
    done

    # Add pre-install script
    ${__mkdir} -p ${stagedir}${prefix}/${_vdocdir}/contrib
    ${__gsed} -e "s;@@POSTFIX_UID@@;$postfix_uid;" \
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
