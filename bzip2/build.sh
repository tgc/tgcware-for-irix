#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# The concept of "method" registering and the logic that implements it was shamelessly
# stolen from jhlj's Compile.sh script :)
#
# Check the following 4 variables before running the script
topdir=bzip2
version=1.0.2
pkgver=7
source[0]=$topdir-$version.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

shortroot=1 # Shallow stagedir

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
    setdir source
    $MAKE_PROG -f Makefile LDFLAGS="-rpath /usr/local/lib"
    $MAKE_PROG -f Makefile-libbz2_so CC="gcc -rpath /usr/local/lib"
}

reg install
install()
{
    clean stage
    setdir source
    ${MKDIR} -p ${stagedir}/{${_bindir},${_mandir}/man1,${_libdir},${_includedir}}
    ${GINSTALL} -m 755 bzlib.h ${stagedir}/${_includedir}
    ${GINSTALL} -m 755 libbz2.so.1.0.2 ${stagedir}/${_libdir}
    ${GINSTALL} -m 755 libbz2.a ${stagedir}/${_libdir}
    ${GINSTALL} -m 755 bzip2-shared  ${stagedir}/${_bindir}/bzip2
    ${GINSTALL} -m 755 bzip2recover bzgrep bzdiff bzmore ${stagedir}/${_bindir}/
    ${GINSTALL} -m 644 bzip2.1 bzdiff.1 bzgrep.1 bzmore.1 ${stagedir}/${_mandir}/man1/
    ${LN} -s bzip2 ${stagedir}/${_bindir}/bunzip2
    ${LN} -s bzip2 ${stagedir}/${_bindir}/bzcat
    ${LN} -s bzdiff ${stagedir}/${_bindir}/bzcmp
    ${LN} -s bzmore ${stagedir}/${_bindir}/bzless
    ${LN} -s libbz2.so.1.0.2 ${stagedir}/${_libdir}/libbz2.so.1.0
    ${LN} -s libbz2.so.1.0 ${stagedir}/${_libdir}/libbz2.so
    ${LN} -s bzip2.1 ${stagedir}/${_mandir}/man1/bzip2recover.1
    ${LN} -s bzip2.1 ${stagedir}/${_mandir}/man1/bunzip2.1
    ${LN} -s bzip2.1 ${stagedir}/${_mandir}/man1/bzcat.1
    ${LN} -s bzdiff.1 ${stagedir}/${_mandir}/man1/bzcmp.1
    ${LN} -s bzmore.1 ${stagedir}/${_mandir}/man1/bzless.1

    doc LICENSE CHANGES README README.COMPILATION.PROBLEMS Y2K_INFO
    custom_install=1
    generic_install
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
