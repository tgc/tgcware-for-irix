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
version=7.2
pkgver=1
source[0]=$topdir-$version.tar.bz2
source[1]=$topdir-${version}-extra.tar.gz
source[2]=$topdir-${version}-lang.tar.gz
# If there are no patches, simply comment this
# Generate patchlist like this:
# num=0; for i in `grep -v Win32 README  |grep -v \(extra|awk '{ print $2 }'|grep 7.1`; do echo "patch[$num]=$i"; let num=num+1; done
patch[0]= #empty
patch[1]=7.2.001
patch[2]=7.2.002
patch[3]=7.2.003
patch[4]=7.2.004
patch[5]=7.2.005
patch[6]=7.2.006
patch[7]=7.2.007
patch[8]=7.2.008
patch[9]=7.2.009
patch[10]=7.2.010
patch[11]=7.2.011
patch[12]=7.2.012
patch[13]=7.2.013
patch[14]=7.2.014
patch[15]=7.2.015
patch[16]=7.2.016
patch[17]=7.2.017
patch[18]=7.2.018
patch[19]=7.2.019
patch[20]=7.2.020
patch[21]=7.2.021
patch[22]=7.2.022
patch[23]=7.2.023
patch[24]=7.2.024
patch[25]=7.2.025
patch[26]=7.2.026
patch[27]=7.2.027
patch[28]=7.2.028
patch[29]=7.2.029
patch[30]=7.2.030
patch[31]=7.2.031
patch[32]=7.2.032
patch[33]=7.2.033
patch[34]=7.2.034
patch[35]=7.2.035
patch[36]=7.2.036
patch[37]=7.2.037
patch[38]=7.2.038
patch[39]=7.2.039
patch[40]=7.2.040
patch[41]=7.2.041
patch[42]=7.2.042
patch[43]=7.2.043
patch[44]=7.2.044
patch[45]=7.2.045
patch[46]=7.2.046
patch[47]=7.2.047
patch[48]=7.2.048
patch[49]=7.2.049
patch[50]=7.2.050
patch[51]=7.2.051
patch[52]=7.2.052
patch[53]=7.2.053
patch[54]=7.2.054
patch[55]=7.2.055
patch[56]=7.2.056
patch[57]=7.2.057
patch[58]=7.2.058
patch[59]=7.2.059
patch[60]=7.2.060
patch[61]=7.2.061
patch[62]=7.2.062
patch[63]=7.2.063
patch[64]=7.2.064
patch[65]=7.2.065
patch[66]=7.2.066
patch[67]=7.2.067
patch[68]=7.2.068
patch[69]=7.2.069
patch[70]=7.2.070
patch[71]=7.2.071
patch[72]=7.2.072
patch[73]=7.2.073
patch[74]=7.2.074
patch[75]=7.2.075
patch[76]=7.2.076
patch[77]=7.2.077
patch[78]=7.2.078
patch[79]=7.2.079
patch[80]=7.2.080
patch[81]=7.2.081
patch[82]=7.2.082
patch[83]=7.2.083
patch[84]=7.2.084
patch[85]=7.2.085
patch[86]=7.2.086
patch[87]=7.2.087
patch[88]=7.2.088
patch[89]=7.2.089
patch[90]=7.2.090
patch[91]=7.2.091
patch[92]=7.2.092
patch[93]=7.2.093
patch[94]=7.2.094
patch[95]=7.2.095
patch[96]=7.2.096
patch[97]=7.2.097
patch[98]=7.2.098
patch[99]=7.2.099
patch[100]=7.2.100
patch[101]=7.2.101
patch[102]=7.2.102
patch[103]=7.2.103
patch[104]=7.2.104
patch[105]=7.2.105
patch[106]=7.2.106
patch[107]=7.2.107
patch[108]=7.2.108
patch[109]=7.2.109
patch[110]=7.2.110
patch[111]=7.2.111
patch[112]=7.2.112
patch[113]=7.2.113
patch[114]=7.2.114
patch[115]=7.2.115
patch[116]=7.2.116
patch[117]=7.2.117
patch[118]=7.2.118
patch[119]=7.2.119
patch[120]=7.2.120
patch[121]=7.2.121
patch[122]=7.2.122
patch[123]=7.2.123
patch[124]=7.2.124
patch[125]=7.2.125
patch[126]=7.2.126
patch[127]=7.2.127
patch[128]=7.2.128
patch[129]=7.2.129
patch[130]=7.2.130
patch[131]=7.2.131
patch[132]=7.2.132
patch[133]=7.2.133
patch[134]=7.2.134
patch[135]=7.2.135
patch[136]=7.2.136
patch[137]=7.2.137
patch[138]=7.2.138
patch[139]=7.2.139
patch[140]=7.2.140
patch[141]=7.2.141
patch[142]=7.2.142
patch[143]=7.2.143
patch[144]=7.2.144
patch[145]=7.2.145
patch[146]=7.2.146
patch[147]=7.2.147
patch[148]=7.2.148
patch[149]=7.2.149
patch[150]=7.2.150
patch[151]=7.2.151
patch[152]=7.2.152
patch[153]=7.2.153
patch[154]=7.2.154
patch[155]=7.2.155
patch[156]=7.2.156
patch[157]=7.2.157
patch[158]=7.2.158
patch[159]=7.2.159
patch[160]=7.2.160
patch[161]=7.2.161
patch[162]=7.2.162
patch[163]=7.2.163
patch[164]=7.2.164
patch[165]=7.2.165
patch[166]=7.2.166
patch[167]=7.2.167
patch[168]=7.2.168
patch[169]=7.2.169
patch[170]=7.2.170
patch[171]=7.2.171
patch[172]=7.2.172
patch[173]=7.2.173
patch[174]=7.2.174
patch[175]=7.2.175
patch[176]=7.2.176
patch[177]=7.2.177
patch[178]=7.2.178
patch[179]=7.2.179
patch[180]=7.2.180
patch[181]=7.2.181
patch[182]=7.2.182
patch[183]=7.2.183
patch[184]=7.2.184
patch[185]=7.2.185
patch[186]=7.2.186
patch[187]=7.2.187
patch[188]=7.2.188
patch[189]=7.2.189
patch[190]=7.2.190
patch[191]=7.2.191
patch[192]=7.2.192
patch[193]=7.2.193
patch[194]=7.2.194
patch[195]=7.2.195
patch[196]=7.2.196
patch[197]=7.2.197
patch[198]=7.2.198
patch[199]=7.2.199
patch[200]=7.2.200
patch[201]=7.2.201
patch[202]=7.2.202
patch[203]=7.2.203
patch[204]=7.2.204
patch[205]=7.2.205
patch[206]=7.2.206
patch[207]=7.2.207
patch[208]=7.2.208
patch[209]=7.2.209
patch[210]=7.2.210
patch[211]=7.2.211
patch[212]=7.2.212
patch[213]=7.2.213
patch[214]=7.2.214
patch[215]=7.2.215
patch[216]=7.2.216
patch[217]=7.2.217
patch[218]=7.2.218
patch[219]=7.2.219
patch[220]=7.2.220
patch[221]=7.2.221
patch[222]=7.2.222
patch[223]=7.2.223
patch[224]=7.2.224
patch[225]=7.2.225
patch[226]=7.2.226
patch[227]=7.2.227
patch[228]=7.2.228
patch[229]=7.2.229
patch[230]=7.2.230
patch[231]=7.2.231
patch[232]=7.2.232
patch[233]=7.2.233
patch[234]=7.2.234
patch[235]=7.2.235
patch[236]=7.2.236
patch[237]=7.2.237
patch[238]=7.2.238
patch[239]=7.2.239
patch[240]=7.2.240
patch[241]=7.2.241
patch[242]=7.2.242
patch[243]=7.2.243
patch[244]=7.2.244
patch[245]=7.2.245

# Helper var
patchcount=${#patch[@]}

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
# We need to override this
topsrcdir=vim72
patchdir=$srcfiles/vim-${version}-patches
patch_prefix="-p0"
mipspro=1
export CC=cc
export CPPFLAGS="-I/usr/tgcware/include"
# What gui should we build?
gui=motif
configure_args='--prefix=$prefix --mandir=$prefix/man --enable-gui=$gui --with-features=huge --enable-multibyte --disable-perlinterp --disable-pythoninterp --disable-tclinterp --with-compiledby="<irixpkg@jupiterrise.com>" --disable-netbeans'
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
    #generic_prep
# Can't use generic_prep because we need to unpack all sources
# before patching
    unpack 0
    unpack 1
    unpack 2
    local numpatch=${#patch[@]}
    local i=0
    while [ $i -lt $numpatch ]
    do
	patch $i $patch_prefix
	let i=i+1
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
