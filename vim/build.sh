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
version=7.0
pkgver=1
source[0]=$topdir-7.0.tar.bz2
# If there are no patches, simply comment this
# Generate patchlist like this:
# num=0; for i in `grep -v Win32 README  |grep -v \(extra|awk '{ print $2 }'|grep 7.0`; do echo "patch[$num]=$i"; let num=num+1; done
patch[0]=7.0.001
patch[1]=7.0.002
patch[2]=7.0.003
patch[3]=7.0.004
patch[4]=7.0.006
patch[5]=7.0.007
patch[6]=7.0.008
patch[7]=7.0.009
patch[8]=7.0.010
patch[9]=7.0.011
patch[10]=7.0.012
patch[11]=7.0.013
patch[12]=7.0.014
patch[13]=7.0.015
patch[14]=7.0.016
patch[15]=7.0.017
patch[16]=7.0.018
patch[17]=7.0.019
patch[18]=7.0.020
patch[19]=7.0.021
patch[20]=7.0.022
patch[21]=7.0.023
patch[22]=7.0.024
patch[23]=7.0.025
patch[24]=7.0.026
patch[25]=7.0.029
patch[26]=7.0.030
patch[27]=7.0.031
patch[28]=7.0.033
patch[29]=7.0.034
patch[30]=7.0.035

# Helper var
patchcount=${#patch[@]}

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# We need to override this
topsrcdir=vim70
patchdir=$srcfiles/vim-${version}-patches
patch_prefix="-p2"
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
    generic_prep
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
    setdir ${stagedir}${prefix}/${_sharedir}/vim/vim70/lang/
    ${MV} "menu_chinese(gb)_gb.936.vim" "menu_chinese_gb__gb.936.vim"
    ${MV} "menu_chinese(taiwan)_taiwan.950.vim" "menu_chinese_taiwan__taiwan.950.vim"
    $RM -rf ${stagedir}${prefix}/${_mandir}/{fr,it,pl,ru}*
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
