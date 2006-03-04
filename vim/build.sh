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
topdir=vim
version=6.4
pkgver=2
source[0]=$topdir-6.4.tar.bz2
# If there are no patches, simply comment this
patch[0]= # Dummy
patch[1]= #6.4.001 only for extras
patch[2]=6.4.002
patch[3]=6.4.003
patch[4]=6.4.004
patch[5]=6.4.005
patch[6]=6.4.006
patch[7]=6.4.007
patch[8]=6.4.008

# Helper var
patchcount=${#patch[@]}

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# We need to override this
topsrcdir=vim64
patchdir=$srcfiles/vim-6.4-patches
export CFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
# What gui should we build?
gui=motif
configure_args='--prefix=$prefix --enable-gui=$gui --with-features=huge --with-compiledby="<irixpkg@jupiterrise.com>" --enable-multibyte --disable-netbeans'
configlog=src/auto/config.log

# Custom subsystems...
subsysconf=$metadir/subsys.conf

ignore_deps="tgc_perl5"


reg prep
prep()
{
    clean source
    unpack 0
    for ((i=0; i<patchcount; i++))
    do
	patch $i -p0
    done
}

reg build
build()
{
    # First build a gui version
    gui=motif
    generic_build
    # Save the gui binary for later
    setdir source
    ${CP} src/vim src/gvim
    setdir source
    $MAKE_PROG clean
    gui="no --with-x=no"
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    setdir source
    ${CP} src/gvim ${stagedir}${prefix}/${_bindir}
    setdir ${stagedir}${prefix}/${_bindir}
    ${LN} -s gvim gvimdiff
    ${LN} -s gvim gview
    setdir ${stagedir}${prefix}/${_mandir}/man1
    ${LN} -s vim.1 gvim.1
    ${LN} -s vim.1 gview.1
    ${LN} -s vimdiff.1 gvimdiff.1
    custom_install=1
    generic_install DESTDIR
    doc README.txt
    setdir ${stagedir}${prefix}/${_sharedir}/vim/vim64/lang/
    ${MV} "menu_chinese(gb)_gb.936.vim" "menu_chinese_gb__gb.936.vim"
    ${MV} "menu_chinese(taiwan)_taiwan.950.vim" "menu_chinese_taiwan__taiwan.950.vim"
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
