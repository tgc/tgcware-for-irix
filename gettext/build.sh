#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=gettext
version=0.14.1
pkgver=4
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Define script functions and register them
METHODS=""
reg() {
    METHODS="$METHODS $1"
}

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    export LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"
    set_configure_args '--prefix=$prefix --mandir=$prefix/${_mandir} --with-libiconv-prefix=/usr/local'
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    ${RM} -f ${stagedir}${prefix}/${_infodir}/dir
    ${RM} -f ${stagedir}${prefix}/${_libdir}/charset.alias
    doc NEWS README
    # Fix up these 4 manpages to use symlinks instead of nroff include style
    setdir ${stagedir}${prefix}/${_mandir}/man3
    ${RM} -f dcgettext.3 dcngettext.3 dgettext.3 dngettext.3
    ${LN} -s gettext.3 dcgettext.3
    ${LN} -s ngettext.3 dcngettext.3
    ${LN} -s gettext.3 dgettext.3
    ${LN} -s ngettext.3 dngettext.3
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

reg all
all()
{
    for METHOD in $METHODS 
    do
	case $METHOD in
	     all*|*clean) ;;
	     *) $METHOD
		;;
	esac
    done

}

reg
usage() {
    echo Usage $0 "{"$(echo $METHODS | tr " " "|")"}"
    exit 1
}

OK=0
for METHOD in $*
do
    METHOD=" $METHOD *"
    if [ "${METHODS%$METHOD}" == "$METHODS" ] ; then
	usage
    fi
    OK=1
done

if [ $OK = 0 ] ; then
    usage;
fi

for METHOD in $*
do
    ( $METHOD )
done
