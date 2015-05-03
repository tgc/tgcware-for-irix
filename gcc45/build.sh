#!/usr/tgcware/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gcc
version=4.5.4
pkgver=1
source[0]=ftp://ftp.sunet.se/pub/gnu/gcc/releases/$topdir-$version/$topdir-$version.tar.bz2
# If there are no patches, simply comment this
patch[0]=gcc-4.3.0-include-sched_h.patch
patch[1]=gcc-4.5.3-libgomp-pthreads.patch
patch[2]=gcc-4.3.2-setrunon_np.patch
patch[3]=gcc-4.5.2-no-ipv6.patch
patch[4]=gcc-4.5.2-fix-stdint_h.patch
patch[5]=gcc-4.5.3-iris5-hidden_symbol.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Custom subsystems...
irix53 && subsysconf=$metadir/subsys.conf.53
irix62 && subsysconf=$metadir/subsys.conf.62

# Global settings
abbrev_ver=45
defprefix=$prefix
prefix=/usr/tgcware/${topdir}${abbrev_ver}
__configure="../$topsrcdir/configure"
make_build_target="bootstrap"

asld="--with-gnu-as --with-as=/usr/tgcware/bin/as --without-gnu-ld --with-ld=/usr/bin/ld"
langs="--enable-languages=c,ada,c++,fortran,objc,obj-c++"
withjava=0
gas=1

export CONFIG_SHELL=/usr/tgcware/bin/bash

configure_args=(--prefix=$prefix --with-local-prefix=$prefix --disable-nls --with-libiconv-prefix=/usr/tgcware --with-gmp=/usr/tgcware --with-mpfr=/usr/tgcware --with-mpc=/usr/tgcware --with-libelf=/usr/tgcware --enable-obsolete --enable-shared)

if [ "$_os" = "irix53" ]; then
    export CC="/usr/tgcware/gcc-3.4.6/bin/gcc"
    withjava=0
    objdir=all
    configure_args+=(--enable-libstdcxx-pch=no)
fi
if [ "$_os" = "irix62" ]; then
    configure_args+=(--enable-threads=posix95)
#    objdir=crpath_pthreads
#    make_build_target=""
#    configure_args+=(--disable-bootstrap)
#    langs="--enable-languages=c"
    objdir=all_pthreads
    [ $withjava -eq 1 ] && configure_args+=(--with-system-zlib --enable-java-awt=gtk)
fi

[ $withjava -eq 1 ] && langs="$langs,java"
configure_args+=($asld $langs)

# Bugs go here
configure_args+=(--with-bugurl=http://jupiterrise.com/tgcware)

# Override broken test
ac_overrides="gcc_cv_as_gnu_unique_object=no"

# Setup tools
# 'ar' is safe for both IRIX 5.3 (needs it unconditionally with GNU as)
# and IRIX 6.x.
# With GNU ar we should also use GNU ranlib
# objdump is also safe to use and configure uses it unconditionally for some tests
setdir $srcdir
${__mkdir} -p tools
setdir tools
for tool in ar ranlib objdump
do
    ${__ln} -sf /usr/tgcware/mips-sgi-$os/${tool} ${tool}
done
export PATH=$srcdir/tools:$PATH

reg prep
prep()
{
    generic_prep
    setdir source
    # Set bugurl and vendor version
    ${__gsed} -i "/BUGURL=.*bugs.html.*/ s|http://gcc.gnu.org/bugs.html|$gccbugurl|" gcc/configure
    ${__gsed} -i "/PKGVERSION=.*GCC.*/ s|GCC|$gccpkgversion|" gcc/configure
}

reg build
build()
{
    setdir source
    mkdir -p ../$objdir
    echo $__configure "${configure_args[@]}"
    generic_build ../$objdir
    #setdir ../$objdir
    #${__make}
}

reg install
install()
{
    clean stage
    lprefix=/usr/tgcware
    setdir $srcdir/$objdir
    ${__make} DESTDIR=$stagedir install
    ${__rm} -f ${stagedir}${prefix}/${_infodir}/dir
    custom_install=1
    generic_install
    ${__find} ${stagedir} -name '*.la' -print | ${__xargs} ${__rm} -f

    # Turn all the hardlinks in bin into symlinks
    setdir ${stagedir}${prefix}/${_bindir}
    for i in c++ mips-sgi-${os}-c++ mips-sgi-${os}-g++
    do
	${__ln} -sf g++ $i
    done
    for i in mips-sgi-${os}-gcc mips-sgi-${os}-gcc-$version
    do
	${__ln} -sf gcc $i
    done
    ${__ln} -sf gfortran mips-sgi-${os}-gfortran
    doc COPYING* MAINTAINERS NEWS
    ${__mv} ${stagedir}${prefix}/${_sharedir} ${stagedir}${lprefix}
    # Nuke python stuff
    ${__rm} -rf ${stagedir}${lprefix}/${sharedir}/${topdir}-${version}

    # Relocate man and info
    ${__mv} ${stagedir}${lprefix}/${_sharedir}/${_mandir} ${stagedir}${prefix}
    ${__mv} ${stagedir}${lprefix}/${_sharedir}/${_infodir} ${stagedir}${prefix}
}

reg check
check()
{
    setdir source
    setdir ../$objdir
    # Single ABI
    irix53 && ${__make} -k check
    # Three ABIs
    irix62 && ${__make} -k RUNTESTFLAGS="--target_board='unix{-mabi=n32,-mabi=32,-mabi=64}'" check
    #${__make} -k RUNTESTFLAGS="--target_board='unix{-mabi=n32,-mabi=32,-mabi=64}'" check-target-libstdc++-v3
}

reg pack
pack()
{
    # Custom pkgdef, yes should have been a var like subsysconf but is not...
    # We keep this here so that the 'cp' is only done when it matters
    irix53 && ${__rm} -f $metadir/pkgdef && ${__cp} -p $metadir/pkgdef.irix53 $metadir/pkgdef
    irix62 && ${__rm} -f $metadir/pkgdef && ${__cp} -p $metadir/pkgdef.irix62 $metadir/pkgdef
    __configure="configure"
    iprefix=${topdir}${abbrev_ver}
    generic_pack
}

reg distclean
distclean()
{
    META_CLEAN="$META_CLEAN pkgdef"
    clean distclean
    setdir $srcdir
    ${__rm} -rf $objdir
    ${__rm} -rf tools
}

###################################################
# No need to look below here
###################################################
build_sh $*
