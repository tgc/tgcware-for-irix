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
pkgver=4
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
patch[31]=7.0.036
patch[32]=7.0.037
patch[33]=7.0.038
patch[34]=7.0.039
patch[35]=7.0.040
patch[36]=7.0.041
patch[37]=7.0.042
patch[38]=7.0.043
patch[39]=7.0.044
patch[40]=7.0.046
patch[41]=7.0.047
patch[42]=7.0.048
patch[43]=7.0.049
patch[44]=7.0.050
patch[45]=7.0.051
patch[46]=7.0.052
patch[47]=7.0.053
patch[48]=7.0.054
patch[49]=7.0.055
patch[50]=7.0.056
patch[51]=7.0.058
patch[52]=7.0.059
patch[53]=7.0.060
patch[54]=7.0.061
patch[55]=7.0.062
patch[56]=7.0.063
patch[57]=7.0.064
patch[58]=7.0.066
patch[59]=7.0.067
patch[60]=7.0.068
patch[61]=7.0.069
patch[62]=7.0.070
patch[63]=7.0.071
patch[64]=7.0.072
patch[65]=7.0.073
patch[66]=7.0.075
patch[67]=7.0.076
patch[68]=7.0.077
patch[69]=7.0.078
patch[70]=7.0.079
patch[71]=7.0.080
patch[72]=7.0.081
patch[73]=7.0.082
patch[74]=7.0.083
patch[75]=7.0.084
patch[76]=7.0.085
patch[77]=7.0.086
patch[78]=7.0.087
patch[79]=7.0.088
patch[80]=7.0.089
patch[81]=7.0.090
patch[82]=7.0.091
patch[83]=7.0.092
patch[84]=7.0.093
patch[85]=7.0.094
patch[86]=7.0.095
patch[87]=7.0.096
patch[88]=7.0.097
patch[89]=7.0.098
patch[90]=7.0.099
patch[91]=7.0.100
patch[92]=7.0.101
patch[93]=7.0.102
patch[94]=7.0.103
patch[95]=7.0.104
patch[96]=7.0.105
patch[97]=7.0.106
patch[98]=7.0.107
patch[99]=7.0.109
patch[100]=7.0.110
patch[101]=7.0.111
patch[102]=7.0.112
patch[103]=7.0.113
patch[104]=7.0.114
patch[105]=7.0.115
patch[106]=7.0.116
patch[107]=7.0.117
patch[108]=7.0.118
patch[109]=7.0.119
patch[110]=7.0.120
patch[111]=7.0.121
patch[112]=7.0.122
patch[113]=7.0.123
patch[114]=7.0.124
patch[115]=7.0.125
patch[116]=7.0.126
patch[117]=7.0.127
patch[118]=7.0.128
patch[119]=7.0.129
patch[120]= #7.0.132 - improperly tagged - depends on 130 which is (extra)
patch[121]=7.0.133
patch[122]=7.0.134
patch[123]=7.0.135
patch[124]=7.0.136
patch[125]=7.0.137
patch[126]=7.0.139
patch[127]=7.0.140
patch[128]=7.0.141
patch[129]=7.0.142
patch[130]=7.0.143
patch[131]=7.0.144
patch[132]=7.0.145
patch[133]=7.0.146
patch[134]=7.0.147
patch[135]=7.0.148
patch[136]=7.0.149
patch[137]=7.0.150
patch[138]=7.0.151
patch[139]=7.0.152
patch[140]=7.0.153
patch[141]=7.0.154
patch[142]=7.0.155
patch[143]=7.0.157
patch[144]=7.0.158
patch[145]=7.0.159
patch[146]=7.0.160
patch[147]=7.0.162
patch[148]=7.0.163
patch[149]=7.0.164
patch[150]=7.0.165
patch[151]=7.0.166
patch[152]=7.0.167
patch[153]=7.0.168
patch[154]=7.0.169
patch[155]=7.0.172
patch[156]=7.0.173
patch[157]=7.0.174
patch[158]=7.0.175
patch[159]=7.0.176
patch[160]=7.0.177
patch[161]=7.0.178
patch[162]=7.0.179
patch[163]=7.0.181
patch[164]=7.0.182
patch[165]=7.0.183
patch[166]=7.0.184
patch[167]=7.0.185
patch[168]=7.0.186
patch[169]=7.0.187
patch[170]=7.0.188
patch[171]=7.0.189
patch[172]=7.0.190
patch[173]=7.0.191
patch[174]=7.0.192
patch[175]=7.0.193
patch[176]=7.0.194
patch[177]=7.0.195
patch[178]=7.0.196
patch[179]=7.0.199
patch[180]=7.0.200
patch[181]=7.0.201
patch[182]=7.0.202
patch[183]=7.0.203
patch[184]=7.0.204
patch[185]=7.0.205
patch[186]=7.0.206
patch[187]=7.0.207
patch[188]= #7.0.208 - VMS only
patch[189]=7.0.209
patch[190]=7.0.210
patch[191]=7.0.211
patch[192]=7.0.212
patch[193]=7.0.213
patch[194]=7.0.214
patch[195]=7.0.216
patch[196]=7.0.217
patch[197]=7.0.218
patch[198]=7.0.219
patch[199]=7.0.220
patch[200]=7.0.221
patch[201]=7.0.222
patch[202]=7.0.223
patch[203]=7.0.224

# Helper var
patchcount=${#patch[@]}

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# We need to override this
topsrcdir=vim70
patchdir=$srcfiles/vim-${version}-patches
patch_prefix="-p0"
export CFLAGS="-I/usr/tgcware/include"
export LDFLAGS="-L/usr/tgcware/lib -Wl,-rpath,/usr/tgcware/lib"
# What gui should we build?
gui=motif
configure_args='--prefix=$prefix --enable-gui=$gui --with-features=huge --enable-multibyte --disable-perlinterp --disable-pythoninterp --disable-tclinterp --with-compiledby="<irixpkg@jupiterrise.com>" --disable-netbeans'
configlog=src/auto/config.log

export CC=cc
export CFLAGS=-O2
[ "$_os" = "irix62" ] && mipspro=1
[ "$_os" = "irix53" ] && mipspro=2

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
