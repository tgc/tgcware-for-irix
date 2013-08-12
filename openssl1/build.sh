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
topdir=openssl
version=1.0.0k
pkgver=9
source[0]=http://www.openssl.org/source/$topdir-$version.tar.gz
# If there are no patches, simply comment this
patch[0]=openssl-1.0.0a-no-multilib.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
ignore_deps="tgc_perl5.sw.base"
check_ac=0
__configure="./Configure"
configure_args=(--prefix=$prefix --openssldir=$prefix/ssl zlib shared)
mipspro=1
if [ "$_os" == "irix53" ]; then
    configure_args+=(irix-cc)
fi
if [ "$_os" == "irix62" ]; then
    configure_args+=(irix-mips3-cc)
fi
make_check_target=test

reg prep
prep()
{
    generic_prep
    setdir source
    # Hack that will allow the testsuite to run
    ${__gsed} -i "/eval \$rld_var/ s|/usr/lib|${prefix}/${_libdir}:/usr/lib|g" util/shlib_wrap.sh
}

reg build
build()
{
    setdir source
    $__configure "${configure_args[@]}"
    if [ "$_os" == "irix53" ]; then
	${__gsed} -i '/^CFLAG=/s;.*=;CFLAG=-Olimit 3000 -I/usr/tgcware/include;' Makefile
	${__gsed} -i '/EX_LIBS/s;-lz;-Wl,-no_rqs -L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -lz;' Makefile
	${__make} SHARED_LDFLAGS="-Wl,-no_rqs -Wl,-rpath,${prefix}/${_libdir}" depend
	${__make} SHARED_LDFLAGS="-Wl,-no_rqs -Wl,-rpath,${prefix}/${_libdir}"
    else
	# Disable IPv6 on IRIX 6.2
	${__gsed} -i 's/AF_INET6/DISABLE_AF_INET6/g' e_os.h
	${__gsed} -i '/^CFLAG=/s;.*=;CFLAG=-I/usr/tgcware/include;' Makefile
	${__gsed} -i '/EX_LIBS/s;-lz;-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib -lz;' Makefile
	${__make} SHARED_LDFLAGS="-Wl,-rpath,${prefix}/${_libdir}" depend
	${__make} SHARED_LDFLAGS="-Wl,-rpath,${prefix}/${_libdir}"
    fi
}

reg check
check()
{
    generic_check
}

reg install
install()
{
    clean stage
    setdir source
    ${__make} INSTALL_PREFIX=$stagedir MANDIR=${prefix}/${_mandir} install
    setdir ${stagedir}${prefix}/${_mandir}
    for j in $(${__ls} -1d man?)
    do
        cd $j
        for manpage in *
        do
            if [ -L "${manpage}" ]; then
                TARGET=`${__ls} -l "${manpage}" | ${__awk} '{ print $NF }'`
                ${__ln} -sf "${TARGET}"ssl "${manpage}"ssl
                ${__rm} -f "${manpage}"
            else
                ${__mv} "$manpage" "$manpage""ssl"
            fi
        done
        cd ..
    done
    doc README CHANGES FAQ INSTALL LICENSE NEWS
    chmod 755 ${stagedir}${prefix}/${_libdir}/*.so.*
    chmod 755 ${stagedir}${prefix}/${_libdir}/engines/*.so
    custom_install=1
    generic_install INSTALL_PREFIX
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
