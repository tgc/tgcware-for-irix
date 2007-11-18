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
version=7.1
pkgver=1
source[0]=$topdir-7.1.tar.bz2
# If there are no patches, simply comment this
# Generate patchlist like this:
# num=0; for i in `grep -v Win32 README  |grep -v \(extra|awk '{ print $2 }'|grep 7.1`; do echo "patch[$num]=$i"; let num=num+1; done
patch[0]=7.1.001
patch[1]=7.1.002
patch[2]=7.1.004
patch[3]=7.1.005
patch[4]=7.1.006
patch[5]=7.1.008
patch[6]=7.1.009
patch[7]=7.1.010
patch[8]=7.1.011
patch[9]=7.1.012
patch[10]=7.1.013
patch[11]=7.1.014
patch[12]=7.1.015
patch[13]=7.1.016
patch[14]=7.1.017
patch[15]=7.1.018
patch[16]=7.1.019
patch[17]=7.1.020
patch[18]=7.1.022
patch[19]=7.1.023
patch[20]=7.1.024
patch[21]=7.1.025
patch[22]=7.1.026
patch[23]=7.1.027
patch[24]=7.1.028
patch[25]=7.1.029
patch[26]=7.1.030
patch[27]=7.1.031
patch[28]=7.1.032
patch[29]=7.1.033
patch[30]=7.1.034
patch[31]=7.1.035
patch[32]=7.1.036
patch[33]=7.1.037
patch[34]=7.1.038
patch[35]=7.1.039
patch[36]=7.1.040
patch[37]=7.1.042
patch[38]=7.1.043
patch[39]=7.1.044
patch[40]=7.1.045
patch[41]=7.1.046
patch[42]=7.1.047
patch[43]=7.1.048
patch[44]=7.1.049
patch[45]=7.1.050
patch[46]=7.1.051
patch[47]=7.1.052
patch[48]=7.1.053
patch[49]=7.1.054
patch[50]=7.1.055
patch[51]=7.1.056
patch[52]=7.1.057
patch[53]=7.1.058
patch[54]=7.1.059
patch[55]=7.1.060
patch[56]=7.1.061
patch[57]=7.1.062
patch[58]=7.1.063
patch[59]=7.1.064
patch[60]=7.1.066
patch[61]=7.1.067
patch[62]=7.1.068
patch[63]=7.1.069
patch[64]=7.1.071
patch[65]=7.1.073
patch[66]=7.1.074
patch[67]=7.1.075
patch[68]=7.1.076
patch[69]=7.1.078
patch[70]=7.1.079
patch[71]=7.1.081
patch[72]=7.1.082
patch[73]=7.1.083
patch[74]=7.1.084
patch[75]=7.1.085
patch[76]=7.1.086
patch[77]=7.1.087
patch[78]=7.1.089
patch[79]=7.1.090
patch[80]=7.1.093
patch[81]=7.1.094
patch[82]=7.1.095
patch[83]=7.1.096
patch[84]=7.1.097
patch[85]=7.1.098
patch[86]=7.1.099
patch[87]=7.1.101
patch[88]=7.1.102
patch[89]=7.1.103
patch[90]=7.1.104
patch[91]=7.1.105
patch[92]=7.1.106
patch[93]=7.1.107
patch[94]=7.1.109
patch[95]=7.1.111
patch[96]=7.1.112
patch[97]=7.1.113
patch[98]=7.1.114
patch[99]=7.1.115
patch[100]=7.1.116
patch[101]=7.1.117
patch[102]=7.1.118
patch[103]=7.1.119
patch[104]=7.1.120
patch[105]=7.1.121
patch[106]=7.1.122
patch[107]=7.1.125
patch[108]=7.1.127
patch[109]=7.1.130
patch[110]=7.1.131
patch[111]=7.1.132
patch[112]=7.1.133
patch[113]=7.1.136
patch[114]=7.1.137
patch[115]=7.1.138
patch[116]=7.1.139
patch[117]=7.1.140
patch[118]=7.1.141
patch[119]=7.1.142
patch[120]=7.1.143
patch[121]=7.1.144
patch[122]=7.1.145
patch[123]=7.1.147
patch[124]=7.1.148
patch[125]=7.1.149
patch[126]=7.1.150
patch[127]=7.1.151
patch[128]=7.1.152
patch[129]=7.1.153
patch[130]=7.1.154
patch[131]=7.1.155
patch[132]=7.1.156

# Helper var
patchcount=${#patch[@]}

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# We need to override this
topsrcdir=vim71
patchdir=$srcfiles/vim-${version}-patches
patch_prefix="-p0"
export CC=cc
export CPPFLAGS="-I/usr/tgcware/include"
# What gui should we build?
gui=motif
configure_args='--prefix=$prefix --enable-gui=$gui --with-features=huge --enable-multibyte --disable-perlinterp --disable-pythoninterp --disable-tclinterp --with-compiledby="<irixpkg@jupiterrise.com>" --disable-netbeans'
configlog=src/auto/config.log

[ "$_os" = "irix62" ] && mipspro=1
if [ "$_os" = "irix53" ]; then
    mipspro=2
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
    setdir ${stagedir}${prefix}/${_sharedir}/vim/vim71/lang/
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
