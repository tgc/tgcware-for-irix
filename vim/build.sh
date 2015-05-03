#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=vim
version=7.3
pkgver=1
source[0]=$topdir-$version.tar.bz2
# If there are no patches, simply comment this
# Generate patchlist like this:
# num=0; for i in `grep -v Win32 README  |grep -v \(extra|awk '{ print $2 }'|grep 7.1`; do echo "patch[$num]=$i"; let num=num+1; done

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
# We need to override this
topsrcdir=vim73
patchdir=$srcfiles/vim-${version}-patches
patch_prefix="-p0"
# Augment version based on patchlevel
pver=$(cd $patchdir && ls ${version}*|sort -n|tail -1)
real_version=$version
version=$pver
mipspro=1
export CC=cc
export CPPFLAGS="-I/usr/tgcware/include"
# What gui should we build?
gui=motif
configure_args=(--prefix=$prefix --mandir=$prefix/man --enable-gui=$gui --with-features=huge --enable-multibyte --disable-perlinterp --disable-pythoninterp --disable-tclinterp --with-compiledby="<irixpkg@jupiterrise.com>" --disable-netbeans)
configlog=src/auto/config.log

if [ "$_os" = "irix53" ]; then
    NO_RQS="-Wl,-no_rqs"
fi

export LDFLAGS="$NO_RQS -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"

# Custom subsystems...
subsysconf=$metadir/subsys.conf

ignore_deps="tgc_perl5"


reg prep
prep()
{
    generic_prep
    # Patch
    setdir source
    for p in $(ls $patchdir/${real_version}*);
    do
      echo "Applying patch $p"
      ${__patch} -Es $patch_prefix < $p
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
    ${__cp} src/vim src/gvim
    setdir source
    ${__make} clean
    gui="no --with-x=no"
    generic_build
}

reg install
install()
{
    generic_install DESTDIR
    setdir source
    ${__cp} src/gvim ${stagedir}${prefix}/${_bindir}
    setdir ${stagedir}${prefix}/${_bindir}
    ${__ln} -s gvim gvimdiff
    ${__ln} -s gvim gview
    setdir ${stagedir}${prefix}/${_mandir}/man1
    ${__ln} -s vim.1 gvim.1
    ${__ln} -s vim.1 gview.1
    ${__ln} -s vimdiff.1 gvimdiff.1
    custom_install=1
    generic_install DESTDIR
    doc README.txt
    setdir ${stagedir}${prefix}/${_sharedir}/vim/vim72/lang/
    ${__mv} "menu_chinese(gb)_gb.936.vim" "menu_chinese_gb__gb.936.vim"
    ${__mv} "menu_chinese(taiwan)_taiwan.950.vim" "menu_chinese_taiwan__taiwan.950.vim"
    ${__rm} -rf ${stagedir}${prefix}/${_mandir}/{fr,it,pl,ru}*
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
