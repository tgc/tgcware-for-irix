#!/usr/local/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=qt-x11-free
version=3.3.4
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=qt-3.3.4-irix6.2-glfix.patch

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# Hardcode new prefix
qt=qt-3.3
prefix=$prefix/$qt
qtdir=$prefix
plugins_style="-qt-style-cde -qt-style-motifplus -qt-style-platinum -qt-style-sgi -qt-style-windows -qt-style-compact -qt-imgfmt-png -qt-imgfmt-jpeg -qt-imgfmt-mng"
set_configure_args '\
    -platform irix-g++ \
    -prefix $qtdir \
    -release \ 
    -shared \
    -qt-gif \
    -system-zlib \
    -system-libpng \
    -system-libmng \
    -system-libjpeg \
    -thread \
    -no-ipv6 \
    -no-exceptions \
    -I/usr/local/include \
    -L/usr/local/lib \
    -R/usr/local/lib \
    -L$qtdir/${_libdir} \
    -R$qtdir/${_libdir} \
    $plugin_style'

# Manpages uses .so style linking but the autoformatter doesn't handle that
catman=0

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    setdir source
    export QTDIR=`pwd`
    export LD_LIBRARYN32_PATH="$QTDIR/lib"
    export PATH="$QTDIR/bin:$PATH"
    export QTDEST=$qtdir
    
    # don't use rpath
    perl -pi -e "s|-Wl,-rpath,|-L|" mkspecs/*/qmake.conf

    # Argh! It asks a question before running configure :(
    echo $(_upls $configure_args)
   # echo yes | ./configure -v $(_upls $configure_args)
    $MAKE_PROG
    echo "HUSK ./configure ER UDKOMMENTERET!"
}

reg install
install()
{
    export QTDIR=`pwd`
    export LD_LIBRARYN32_PATH="$QTDIR/lib"
    export PATH="$QTDIR/bin:$PATH"
    export QTDEST=$qtdir
    
    generic_install INSTALL_ROOT

    setdir source

    # Clean up at bit
    $MAKE_PROG -C tutorial clean
    $MAKE_PROG -C examples clean

    # don't include Makefiles of qt examples/tutorials
    $FIND examples -name "Makefile" | $XARGS $RM -f
    $FIND tutorial -name "Makefile" | $XARGS $RM -f

    doc FAQ LICENSE.QPL README* changes*
    doc examples tutorial
    # Let's put pkgconfig in an accessible place for easy use
    $MKDIR -p ${stagedir}${topinstalldir}/${_libdir}/pkgconfig
    pushd ${stagedir}${topinstalldir}/${_libdir}/pkgconfig
    $LN -sf ../../$qt/${_libdir}/pkgconfig/* .
    popd
    ${MV} ${stagedir}${prefix}/doc/* ${stagedir}${prefix}/${_vdocdir}
    ${RMDIR} ${stagedir}${prefix}/doc
    ${MV} ${stagedir}${prefix}/${_sharedir} ${stagedir}${topinstalldir}
    # Add manpages
    ${MKDIR} -p ${stagedir}${prefix}/${_mandir}
    ${CP} -fR doc/man/* ${stagedir}${prefix}/${_mandir}

    # Fix bogus symlink
    ${RM} -f ${stagedir}${prefix}/mkspecs/irix-g++/irix-g++

    # Fix up a few filenames that gendist can't handle
    for i in "Dialog_with_Buttons_(Bottom).ui" "Dialog_with_Buttons_(Right).ui"
    do
	${MV} ${stagedir}${prefix}/templates/$i ${stagedir}${prefix}/templates/`echo $i|$SED -e 's/(/_/' -e 's/)/_/'`
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
