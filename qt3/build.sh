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
topdir=qt-x11-free
version=3.3.8
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=qt-3.3.4-irix6.2-glfix.patch
patch[1]=qt-3.1.0-makefile.patch
patch[2]=qt-uic-nostdlib.patch
patch[3]=qt-x11-free-3.3.5-gcc4-buildkey.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
# Hardcode new prefix
qt=qt-3.3
prefix=$prefix/$qt
final_qtdir=$prefix
#plugins_style="-qt-style-cde -qt-style-motifplus -qt-style-platinum -qt-style-sgi -qt-style-windows -qt-style-compact -qt-imgfmt-png -qt-imgfmt-jpeg -qt-imgfmt-mng"
#plugins_style="-qt-imgfmt-png -qt-imgfmt-jpeg -qt-imgfmt-mng"
configure_args=(\
    -platform irix-g++ \
    -prefix $final_qtdir \
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
    -no-g++-exceptions \
    -qt-imgfmt-png \
    -qt-imgfmt-jpeg \
    -qt-imgfmt-mng \
    -I/usr/tgcware/include \
    -L/usr/tgcware/lib \
    -R/usr/tgcware/lib \
    -L$final_qtdir/${_libdir} \
    -R$final_qtdir/${_libdir})

reg prep
prep()
{
    generic_prep
    # Add -rpath to qmake build
    setdir source
    $GSED -i '/^LFLAGS/s;\(.*\);\1 -Wl,-rpath,/usr/tgcware/lib;' qmake/Makefile.unix
    # Make sure capability tests are linked with rpath (so they can find libstdc++)
    setdir config.tests
    for i in $($FIND . -name '*.pro')
    do
	echo "LIBS+=-Wl,-rpath,/usr/tgcware/lib" >> $i
    done
}

reg build
build()
{
    echo "Build started: $(date)"
    setdir source
    export QTDIR=`pwd`
    export LD_LIBRARYN32_PATH="$QTDIR/lib"
    export PATH="$QTDIR/bin:$PATH"
    export QTDEST=$final_qtdir
    
    # Argh! It asks a question before running configure :(
    echo "${configure_args[@]}"
    echo yes | ./configure -v "${configure_args[@]}"
    # Remove troublesome and uneeded -rpath from Makefiles before building
    $GSED -i '/^LFLAGS/s;\(.*mt.so.3\).*;\1;' src/Makefile
    cd tools
    $FIND . -name 'Makefile' | $GREP -v examples | $XARGS $GSED -i '/^LFLAGS/s;\(.*buffer=1000\).*;\1;'
    cd ..
    # First build qmake
    $MAKE_PROG src-qmake
    # Build moc
    $MAKE_PROG src-moc
    # Build libqt
    $MAKE_PROG sub-src
    # Build tools
    $MAKE_PROG sub-tools UIC="$QTDIR/bin/uic -nostdlib -L $QTDIR/plugins"
    echo "Build ended: $(date)"
}

reg install
install()
{
    export QTDIR=`pwd`
    export LD_LIBRARYN32_PATH="$QTDIR/lib"
    export PATH="$QTDIR/bin:$PATH"
    export QTDEST=$final_qtdir
    
    generic_install INSTALL_ROOT

    setdir source

    # Clean up at bit
    $MAKE_PROG -C tutorial clean
    $MAKE_PROG -C examples clean

    $FIND examples -name Makefile | xargs perl -pi -e 's|\.\./\.\.|\$\(QTDIR\)|'
    $FIND tutorial -name Makefile | xargs perl -pi -e 's|\.\./\.\.|\$\(QTDIR\)|'
    $FIND examples -name '*.pro' | xargs $GSED -i '/^DEPENDPATH/s|\.\./\.\./include|$\(QTDIR\)/include|'

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
