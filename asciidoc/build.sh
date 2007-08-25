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
topdir=asciidoc
version=8.2.2
pkgver=1
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=asciidoc-8.2.2-tgcware.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    :
}

reg install
install()
{
    clean stage
    setdir source
    ${__install} -d -m0755 ${stagedir}${prefix}/${_sysconfdir}/asciidoc/{docbook-xsl,filters,images/icons,javascripts,stylesheets}/
    ${__install} -p -m0644 *.conf ${stagedir}${prefix}/${_sysconfdir}/asciidoc/
    ${__install} -p -m0644 filters/*.conf ${stagedir}${prefix}/${_sysconfdir}/asciidoc/filters/
    ${__install} -p -m0755 filters/*.py ${stagedir}${prefix}/${_sysconfdir}/asciidoc/filters/
    ${__install} -p -m0644 docbook-xsl/*.xsl ${stagedir}${prefix}/${_sysconfdir}/asciidoc/docbook-xsl/
    ${__install} -p -m0644 stylesheets/*.css ${stagedir}${prefix}/${_sysconfdir}/asciidoc/stylesheets/
    ${__install} -p -m0644 javascripts/*.js ${stagedir}${prefix}/${_sysconfdir}/asciidoc/javascripts/
    ${__cp} -pR images/ ${stagedir}${prefix}/${_sysconfdir}/asciidoc/

    ${__install} -Dp -m0755 asciidoc.py ${stagedir}${prefix}/${_bindir}/asciidoc
    ${__install} -Dp -m0755 a2x ${stagedir}${prefix}/${_bindir}/a2x
    ${__install} -Dp -m0644 doc/asciidoc.1 ${stagedir}${prefix}/${_mandir}/man1/asciidoc.1
    ${__install} -Dp -m0644 doc/a2x.1 ${stagedir}${prefix}/${_mandir}/man1/a2x.1

    ${__install} -d -m0755 ${stagedir}${prefix}/${_datadir}/asciidoc/
    ${__cp} -pR javascripts/ images/ stylesheets/ ${stagedir}${prefix}/${_datadir}/asciidoc/

    ### Fix symlinks in examples/
    ${__install} -d -m0755 symlinks/
    ${__ln_s} -f ${prefix}/${_sysconfdir}/asciidoc/filters/ symlinks/filters
    ${__ln_s} -f ${prefix}/${_sysconfdir}/asciidoc/images/ symlinks/images
    ${__ln_s} -f ${prefix}/${_sysconfdir}/asciidoc/javascripts/ symlinks/javascripts
    ${__ln_s} -f ${prefix}/${_sysconfdir}/asciidoc/stylesheets/ symlinks/stylesheets

    doc BUGS* CHANGELOG* COPYING COPYRIGHT INSTALL* README*
    doc doc/ examples/ symlinks/* vim/
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
