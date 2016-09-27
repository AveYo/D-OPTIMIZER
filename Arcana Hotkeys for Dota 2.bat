/* 2>nul & TITLE ARCANA HOTKEYS FOR DOTA2 - AVEYO`S D-OPTIMIZER V3
@echo off & cls & color 0B & call :set_dota

set "mod=lv"
::ren "%dota%\game\dota_%mod%" "dota_%mod%_" >nul 2>&1
md "%dota%\game\dota_%mod%" >nul 2>&1
cd /d "%dota%\game\dota_%mod%"

call :logo
call :wait 10 Starting

:: extract pak01_dir.vpk batch resource bundle
set "res=_pak01_dir.vpk"
cscript /nologo /e:JScript "%~f0" res85_decoder 0
expand -R -F:* "%res%" >nul 2>&1 &del /f /q "%res%"

:: panorama localization
xcopy /E/C/I/Q/H/R/K/Y/Z "%dota%\game\dota\panorama\localization\*.*" "%dota%\game\dota_%mod%\panorama\localization\" >nul 2>nul
cscript /nologo /e:JScript "%~f0" mod_panorama_localization "%dota%\game\dota_%mod%\panorama\localization\"

:: attempt to add -lv launch option (make a backup since regex can fail)
if not exist "%userdata%\config\backup_localconfig.vdf" copy /y "%userdata%\config\localconfig.vdf" "%userdata%\config\backup_localconfig.vdf" >nul 2>&1
cscript /nologo /e:JScript "%~f0" add_launch_options "%userdata%\config\localconfig.vdf" "-%mod%"

:: howto
call :howto

:: done!
call :end Finished!
exit
goto :eof

:set_dota
for /f "usebackq tokens=2* delims=_" %%A in (`reg query "HKCU\SOFTWARE\Valve\Steam" 2^>nul ^| find /i "SteamPath"`) do set "steampath=%%~A"
set "steampath=%steampath:~6%" &set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%steampath%\SteamApps\libraryfolders.vdf" call :end ! Cannot find Steam library!
for /f usebackq^ delims^=^"^ tokens^=4 %%A in (`findstr /v "%libfilter%" "%steampath%\SteamApps\libraryfolders.vdf"`) do (
if exist "%%A\steamapps\appmanifest_570.acf" if exist "%%A\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" set "libfs=%%A"
)
set "dotab=%steampath%\steamapps\common\dota 2 beta"
if defined libfs set "dotab=%libfs:\\=\%\steamapps\common\dota 2 beta"
set "dota=%dotab:/=\%"
if not exist "%dota%\game\dota\maps\dota.vpk" call :end ! Cannot find Dota 2!
cd /d "%dota%\game\dota\" >nul 2>&1
for /f delims^=^ eol^= %%b in ('dir /a:-d /b /o:d /t:w cache_*.soc 2^>nul') do set "usercache=%%~nb"
set "userdata=%steampath:/=\%\userdata\%usercache:cache_=%"
if not exist "%userdata%\config\localconfig.vdf" call :end ! Cannot find Dota 2 user data!
goto :eof
:wait
setlocal enabledelayedexpansion &if not defined x1337cr for /f %%a in ('copy /z "%~dpf0" nul') do set "x1337cr=%%a"
echo. & (for /l %%i in (%1,-1,1) do <NUL SET /P "=_%2 in %%i !x1337cr!" &ping -n 2 localhost >nul 2>&1) &endlocal &goto :eof
:end
(if "%1"=="!" COLOR 7c) & echo  %* & call :wait 30 Closing
exit
goto :eof
:logo
echo.
echo     _______             ______    ______    ________   __   ___  ___   __   ________   _______   ______
echo    ^|   __  \           /      \  ^|   _  \  ^|        ^| ^|  ^| ^|   \/   ^| ^|  ^| ^|       /  ^|   ____^| ^|   _  \
echo    ^|  ^|  ^|  ^|         ^|  ,~~,  ^| ^|  ^|_)  ^| '~~^|  ^|~~' ^|  ^| ^|  \  /  ^| ^|  ^| `~~~/  /   ^|  ^|__    ^|  ^|_)  ^|
echo    ^|  ^|  ^|  ^| AVEYO`S ^|  ^|  ^|  ^| ^|   ___/     ^|  ^|    ^|  ^| ^|  ^|\/^|  ^| ^|  ^|    /  /    ^|   __^|   ^|      /
echo    ^|  '~~'  ^|         ^|  '~~'  ^| ^|  ^|         ^|  ^|    ^|  ^| ^|  ^|  ^|  ^| ^|  ^|   /  /~~~, ^|  ^|____  ^|  ^|\  \
echo    ^|_______/           \______/  ^|__^|         ^|__^|    ^|__^| ^|__^|  ^|__^| ^|__^|  /_______^| ^|_______^| ^|__^| \__\ v3
echo.
echo    ARCANA HOTKEYS : Unified CastControl, Multiple Chatwheel Presets and Builder, Camera Actions, Panorama Keys
echo.
echo  Please close Steam before running this install script
goto :eof
:howto
echo.
echo                         -------------------------------------------------------------
echo                        ^|                 VERY IMPORTANT STEP NEXT!                   ^|
echo                        ^|  To activate ARCANA HOTKEYS, add Dota 2 Launch Option: -LV  ^|
echo                        ^|    (script made a naive attempt to add it for you)          ^|
echo                        ^|  To deactivate, simply remove the -LV Launch Option         ^|
echo                         -------------------------------------------------------------
goto :eof

*//* JScript library */
function add_launch_options(fn,opt) {
// vdf parser bugged, fallback to simple regex
  var MAX=131072, txt='', as=WSH.CreateObject("ADODB.Stream"); as.Mode=3; as.Open();
	as.Position=0; as.SetEOS(); as.Type=1; as.LoadFromFile(fn); as.Position=0; as.Type=2;as.Charset='utf-8'
  txt=''; while (!as.EOS) txt += as.ReadText(MAX); as.Position=0; as.SetEOS();
  var r0='(\"Software\"[\\S\\s]+\"Valve\"[\\S\\s]*\"Steam\"[\\S\\s]*\"apps\"[\\S\\s]*\"570\"[^}]*)';
  var r_search=new RegExp(r0+'(^[\t ]+\"LaunchOptions\"[\t ]+\")(.*-[lL][vV].*)(\".*$)','im');
	var r_change=new RegExp(r0+'(^[\t ]+\"LaunchOptions\"[\t ]+\")(.*)(\".*$)','im');
  var r_insert=new RegExp(r0+'(^[\t ]+\"LastPlayed.*$)','im'), newopt='$1$2\n\t\t\t\t\t\t\"LaunchOptions\"\t\t\" -lv \"';
  if (r_search.test(txt)) {
    WSH.Echo(' Dota 2 Launch Options: -LV already present!');
  } else {
    if (r_change.test(txt)) {
	    WSH.Echo(' Adding Dota 2 Launch Options: -LV');
			txt=txt.replace(r_change,'$1$2$3 -lv $4');
			as.WriteText(txt); as.SaveToFile(fn,2);
    }
		else if (r_insert.test(txt)) {
	    WSH.Echo(' Inserting Dota 2 Launch Options: -LV');
      txt=txt.replace(r_insert, newopt);
			as.WriteText(txt); as.SaveToFile(fn,2);
		}
  }
  as.Close();txt='';
}
function mod_panorama_localization(fpath) {
var regx={}, kr={}
, kf={'DOTA_Enable':'Enable','DOTA_Customize':'Customize','DOTA_HeroLoadout_ArcanaFilterName':'Arcana'
,'dota_settings_hotkeys':'Hotkeys','dota_settings_enable_quickcast':'Enable Quickcast'}
, kv={'DOTA_Keybind_MMO':'ARCANA HOTKEYS'
,'dota_settings_enable_quickcast':'Unified CastControl'
,'DOTA_Hotkeys_Tooltip_Quickcast':'<font color=\\"#00C5F6\\"><b>UNIFIED CASTCONTROL</b></font><br>\
Toggle QuickCast globally with ALT + CTRL<br>Press ESC then F10 for more help<br><br>\
ALT + #Key = Smart SelfCast (hold to Cast)<br>MOD + #Key = QuickLearn Ability <b>once</b>,<br>\
then inverse CastControl until MOD freed<br><br>MOD + U = QuickLearn Stats<br>MOD + T = AutoCast All<br>\
<br><font color=\\"#F60000\\">REQUIRED - DO NOT DISABLE !</font>'
,'DOTA_Hotkeys_Tooltip_Quickcast_Items':'<font color=\\"#00C5F6\\"><b>UNIFIED CASTCONTROL</b></font><br>\
Toggle QuickCast globally with ALT + CTRL<br>Press ESC then F10 for more help<br><br>\
ALT + #Key = Smart SelfCast (hold to Cast)<br>MOD + #Key = ManualCast Item <b>once</b>,<br>\
then inverse CastControl until MOD freed<br><br><font color=\\"#F60000\\">REQUIRED - DO NOT DISABLE !</font>'
,'dota_settings_quickcast':'Overrides'
,'dota_settings_autocast':'Overrides'
,'DOTA_Hotkeys_Tooltip_AbilityQuickcast':'<font color=\\"#00C5F6\\"><b>ARCANA HOTKEYS</b></font><br>\
Replaces explicit Quickcast binds<br>Press ESC then F10 for more help<br><br>MOD + #Key actions:<br>\
#1 Chatwheel Builder - Reset to defaults<br>#2 Chatwheel Builder - Switch phrase 6<br>\
#3 Chatwheel Builder - Switch phrase 5<br>#4 Chatwheel Builder - Switch phrase 7<br>\
#5 Chatwheel Builder - Switch phrase 4<br>#6 Chatwheel Builder - Switch phrase 0<br><br>\
<font color=\\"#C0C0C0\\">Re-binding these anywhere disables<br>dual-action #Key / MOD + #Key</font>\
<br><font color=\\"#F60000\\">Not available under Legacy Keys</font>'
,'DOTA_Hotkeys_Tooltip_Autocast':'<font color=\\"#00C5F6\\"><b>ARCANA HOTKEYS</b></font><br>\
Replaces explicit Autocast binds<br>Press ESC then F10 for more help<br><br>MOD + #Key actions:<br>\
#1 Chatwheel Builder - Switch phrase 3<br>#2 Chatwheel Builder - Switch phrase 2<br>\
#3 Chatwheel Builder - Switch phrase 1<br>#4 Multiple Chatwheels - Prev presets 8-1<br>\
#5 Multiple Chatwheels - Next presets 1-8<br>#6 Multiple Chatwheels - Lite presets 1-4<br><br>\
<font color=\\"#C0C0C0\\">Re-binding these anywhere disables<br>dual-action #Key / MOD + #Key</font>\
<br><font color=\\"#F60000\\">Not available under Legacy Keys</font>'
,'DOTA_Hotkeys_Tooltip_ItemQuickcast':'<font color=\\"#00C5F6\\"><b>ARCANA HOTKEYS</b></font><br>\
Replaces explicit Quickcast binds<br>Press ESC then F10 for help<br><br>MOD + #Key actions:<br>\
#1 Select Hero<br>#2 AutoCast All<br>#3 QuickLearn Stats <br>\
#4 Force Rightclick Attack<br>#5 Smart Targeted Attack<br>#6 Unified CTRL Orders<br><br>\
<font color=\\"#C0C0C0\\">Re-binding these anywhere disables<br>dual-action #Key / MOD + #Key</font>'
,'dota_settings_phrases':'Customize Arcana Hotkeys'
,'dota_chatwheel_label_Care'          :'MODIFIER (MOD): Overridden actions'
,'dota_chatwheel_label_GetBack'       :'UNIFIED CASTCONTROL: QuickCast toggle'
,'dota_chatwheel_label_NeedWards'     :'CHATWHEEL PRESETS: +MouseWheel 8x +J/K/B 4x'
,'dota_chatwheel_label_Stun'          :'SELECTED CAMERA: Follow, Center on release'
,'dota_chatwheel_label_Help'          :'CHASE CAMERA: Same as double-click portrait'
,'dota_chatwheel_label_Push'          :'LOCK CAMERA: On / Off toggle'
,'dota_chatwheel_label_GoodJob'       :'LOCK SCREEN: Window + EdgePan toggle'
,'dota_chatwheel_label_Missing'       :'CAMERA POSITIONS PRESET: 1-2Runes 3Mid 4Rosh..'
,'dota_chatwheel_label_Missing_Top'   :'ADVANCED SETTINGS PRESET: DoubleTap, Minimap..'
,'dota_chatwheel_label_Missing_Mid'   :'SHOW HELP/MENU: Open GUI straight from game'
,'dota_chatwheel_label_Missing_Bottom':'RETURN TO GAME: Close panorama/console/panels'
,'dota_settings_quickcast_onkeydown':'Enable Quickcast'
};  //:'SOUND VOLUME : Mute / Half / Max toggle'
	for (k in kf) regx[k]=new RegExp('^([ \t]*\"'+k+'\"[ \t]+\")(.*)(\"\\s*)$','gm');
	for (k in kv) regx[k]=new RegExp('^([ \t]*\"'+k+'\"[ \t]+\")(.*)(\"\\s*)$','gm'); // cache dynamic regex
  var MAX=131072, txt='', magic='\"dota\"', as=WSH.CreateObject("ADODB.Stream"); as.Mode=3; as.Open(); // cache read+write file stream
  var fs=WSH.CreateObject("Scripting.FileSystemObject"), files = new Enumerator(fs.GetFolder(fpath).Files); // cache list of files in fpath
  WSH.Stdout.Write(' Patching language files ');
  while (!files.atEnd()) {
  	var fn=files.item().name; as.Position=0; as.SetEOS(); as.Type=1; as.LoadFromFile(fpath+fn); as.Position=0; as.Type=2; // load stream
    WSH.Stdout.Write('.'); //WSH.Echo(fn);
		as.Charset='utf-16'; txt = as.ReadText(magic.length*2);if (txt.indexOf(magic)<0) {as.Position=0; as.Charset='utf-8'}; // check encoding
    as.Position=0; txt=''; while (!as.EOS) txt += as.ReadText(MAX); // read stream into txt
		for (f in kf) {var rez=regx[f].exec(txt); kr[f] = (rez==null) ? kf[f] : rez[2];}
    kv['dota_settings_quickcast_onkeydown']=kr['dota_settings_enable_quickcast'];
//    kv['dota_settings_enable_quickcast']=kr['DOTA_Enable']+' '+kr['DOTA_HeroLoadout_ArcanaFilterName']+' '+kr['dota_settings_hotkeys'];
//    kv['dota_settings_phrases']=kr['DOTA_Customize']+' '+kr['DOTA_HeroLoadout_ArcanaFilterName']+' '+kr['dota_settings_hotkeys'];
		for (k in kv) txt=txt.replace(regx[k],'$1'+kv[k]+'$3'); // mod panorama GUI
    as.Position=0; as.SetEOS(); as.WriteText(txt); as.SaveToFile(fpath+fn,2); txt=''; files.moveNext(); // save file and load another
	}
  as.Close(); WSH.Echo(' Done!');
}

// What is this? it's the main part of the mod in vpk format
function res85_decoder(id) {
fn=fn85[id];res=res85[id];r85='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz?.,;-_+=|{}[]()*^%$#!`~'.split('');
d85={}; for(var i=85;i--;) d85[r85[i]]=i; p85=[]; for(var i=5;i--;) p85[i]=Math.pow(85,i); res=res.replace(/[\\:\s]/gm,"");
z='00000000'; pad=(res.length%5)||5; res+='~~~~~'.slice(pad); pad=10-2*pad; a=res.match(/.{1,5}/g);
for(var l=a.length;l--;){n=0;for(j=5;j--;)n+=d85[a[l].charAt(j)]*p85[4-j];a[l]=z.slice(n.toString(16).length)+n.toString(16)};
res85dec=(pad>0)?a.join('').slice(0,-pad):a.join('');WSH.Echo(' RES2BATCH: extracting '+fn);
xe=WSH.CreateObject('Microsoft.XMLDOM').createElement('bh');as=WSH.CreateObject('ADODB.Stream');as.Mode=3;as.Type=1;as.Open();
xe.dataType='bin.hex';xe.text=res85dec;as.Write(xe.nodeTypedValue);as.SaveToFile(fn,2);as.Close();
}
fn85=[],res85=[]; // Made with Res2Batch by AveYo v2.1
fn85[0]="_pak01_dir.vpk";res85[0]="\
::O}bZg00000ltusm00000EC2ui000000!5a50RR91x-.0KN-o{]2mk#W+2#}n000000025k$)VkdaA9jOF[+e9axQjoYXHBF{yEzK0DxP7fQ(p3GW`x?L^N[S0050xp\
::lL8q5NO842nlRI{qt);NtU|;{AS06w-W_|(FnDkn$F7,;cZg#olCc6(o0VAecV8Zc)k+G5U]9Jgb|AC2mId0)^E-{3{Cht2tWX4W_sIV0KpCcEExWNG$50Yy+(eR2J\
::(E,Hda$YHjO(8niKIrsx[8!E^PGRwwEu._b~J07g__A)HwbjTKhRQ5Nc5G]Zph~Xy)o1?xf6X;Q[~_T7Dds0]CxjdB[.RD?{Wo2U#X`{gy^DNT-LcMx}oi?)yqT#eJ\
::=a5-+thgCaP9dpCXW%wMbz$!R7*y`dWPCU[V#Zf5pwWacKxmuxTHUM`0?(QWmu[dVsjwruK51G20bT17-EVcby)2oX%[q*WQ;g|d(*DCUJAL4ZL30s}Q10wsZh%xOL\
::#Z(Bi?U|VkzQFfwGRj4t)y}3EEN}E`dNM~TVa]aq7-_KmZTFI;3u!Ney;~iA3MOlB_*T{5_|Wa)vIQ|*+{uv*A3qL]kxHek_z,N9Pj5ISEzX,+b[NxQQ#XeCo!DUr5\
::KUF,FZA2NYQK)yzJV!]B?)yp9[QHH5(N;[C,,,R,bIm;N--6G3f3|F^e*dLQbj|U%m`^Cfo{-k67%05CpZd#bV$ET;k!2mvQ`T.BBBC]jo{$v#;PmTy}Uo(watPWuF\
::._l!eq-1wW{o;tinfuQ=|8L^n358bwpOEjOm93UwMl2!tkxn#E+%yeJHw+j,i?T[Yt2X{LbXeUIy.FL2^YyUt6[m`,v_a2_I_!}8Ef*LMQ^E2x~}-bMcZnNx-NBr,X\
::jwHOw^5Pb_9gmwWw9aX1UG5S86F$W-8mXg]_j3z1-;AAa,-aRUb9kp]QU8FZ^aTwGd5NScZvDu.*fDE}=oGLTsrDF!Jv,jh.}d-NBHrC07=7EDS#=BudKq_X7%b=+K\
::^I2-EQEC6}sAUZa-FRaKr;M]chlqS;M3T$~44woUcA9Vs]3xm!hgb.3[68bukX$Px#Xw6c`7kS;z}o1CgjSk$%yJ{66pzLF;|L1?1J?6YN6FJKLf[=qC_S=BQ_GphG\
::htvl9!oYVW%^{HU_EOBg[$722s=445t{Rg}~H?0ODj;`4xbn1_^qoUC-dNxH_ARm+?sM]`0g]*K|k6m9s1M59?t4G2HI]j1DbTMkyGq0*FN42$ve9znSWg#bJ,$zn_\
::;X_?j(1*$awTf.2.*cPTNLA(VR)#sp|f.a?N-V!{st(uzxSLi!-bIay|MDv6x7N8_9n-Y(?Frh%HBogYpwQKzspPzREL2_(;+ZmU%kzzlf?Wig_o;lR3C1);Y6smaI\
::wWOH#iLxjw6j[592WPB=MjprT20U1=5x-.R=R%,^{^3ppIx6)k~4lthC~{lv9HZaDnVrn#(p|$45m71uga0gZB46qWp.ui^6tvSvoWycD+tg!1h{O|BOAFC;R=7(ZH\
::n3AW3y%H.X2f%_b=)jgVsh}g([z!V7~^7F[gD+uE6KeRadMRuUb8lAsrwiJc8HpF!cf8t~*8qBdO5NE7?`h]c3_eTCc6u_]TY]HdW;5Ps.PPf#dZs$O#deg`22Lu5O\
::auF*I)CE^!i7E}kk[+Wo,.+^xpU8Euu)dW}{R3ZrY4rLldo4N_kNt_li^wYiN`A6Wg!CbDs`kA#HVGpRR;%f-C4RV^^jASoU{L,9N2Yg5Pi[^F]M*uW{oX3g6aR)~g\
::#o09hlnq1,dZ*n#D*3tj?+5m45c9}65)zU`[S6r=.)|--Ta?Zk]RxfhS+C0[rFjuOre=CM{Zgt|r(zbS8P[_mpRuCy4TmSECxxhX[,Td4VG5+t1il`ZwYEf7eldeAY\
::Q#7n|rzT5OzTR!`a`64jh*aPQU2SnWFJlM,LL5]|#1w)%I[%]l+?yR!MJ9;HTRTTfWpE![ZkD2({)-6KfcNdzy!kvHB4dS.p2XX;Nw)5ew*`;Fqg66*sZzAMtoqRM|\
::hv+vG,rM2M=2Ch;Y!XEEJYGZz}-wTYT4;Ymig_7V5HK~CETf4%G0a5oA36clL|{J+|mm1+39MGwpC-aczt0V1t%I_7o=`kkdEoIQj`?P(Y%A8J!qS,yJ)j)w*Nx89D\
::r?*yE#lJ8kG[|WXYvb6Ox-iMwsB5B)laE+`nXx8jYn_U.k`kO~GMB|O3xF.b2T[PGgULB#7^Xa7(JnG)=u1;pm~w2IO7;}i[YduF8OEbgLWp*Flo)jv`*HkR5x|Hs.\
::;`p==Os|qlRu(Kff;lu936G1P,U{w)paB0)TGfiut;o,{,dj0Z-UJbc1u0VF$[M{h-PB0LX`fE=;4IUa`=aoji%LhMM(iu{-N(8u*keP7C#DZAG0W4cY=s7bnEDMcD\
::{N%p!{?zN(hKzCL2F}.8CXskXmgd97!r3sQ#a3^;Fa1*h%BOG-fWrT5`|]VpJlch-GX~^Z+WfZY9%}kIn=]HQzcdBEsIvjjv*5{BzPnR%[bT7+iC-$tajz_Z.-AgeX\
::N0f9iC-q!Iq+F4LPa~65;T8{2_]v)$VoD=XOq]r6Ng~V5qDysanX3e|{1bSvY4*#tcKWRKSGo_USH9Zl=f-!CZ83t*!I,4*,]qGiOzJaQQcad`F00AxKk{T|O9qJ}p\
::ZFRtrP^`nZBf];HABH3Sfi*REmC%y)j]F?H,{rdrqj6C2P7YvY$!tA8zsOcaP!C_j5}oY?fAF{KF?b6nuWv$G^xxavgNX=;GN1rTd9d%.l1B;G-ivCz$nv7WGU8)c}\
::zqgT)Q2B#8N^p%st8^JaJ-OT|p*RPjN4F3G[!}qmW|a8ZJwPpf9%6]iOs)$st1[ms*O^Yn0ZsvR3WK$IHcjMBll1#zn(;_u]Bayq,!z7e4DKvOS;]hB-=,+,_mNQ}z\
::jo%0$g#+2J!#r;`X*(N}.X,1aKnUey-q9Ti;E(zZCD}[qp9T,CSe1_C|)spQO1C_JWTZ?gLXU|K|5(FmgYam.W$|Y3jv$g+c;uUEF7k2j,-V$F18+#tGc5aWw{,r]3\
::EXz%Vx=*2(vw5iospODId;gyB([23m(y5E^p940}nws0WjKjx`u)9~1C4GY!}++3mwt+$1cN`)j-wPdy~rCm;OC6}DP]gJ0eq_EbyS((]*,T.}IXU.rR5%Gc*HGxQz\
::(_D?-8,qX?4+_Xet{Q^W29=_uUMGGLd#M$;EK050_lmK.XPcOAHHnqAzV8ouX!0^H+_kH{7bOimJX_z}SCjWbR_z;P5xncJOKi.BTVQR-pU%(q)j-%(8?]0i9Y*hfU\
::|%yxGorjQ|_(*jy)|TD)a-2tIXGyV2rcPMih9H{$GmuBIH)Xm;T6LpotbI8_a0l8lA5+c.RS1kSuFrK33J).C0+7QQ9]cSn!,X9%=fls;K~xS*~GD4tnnyc6g5tDwB\
::pN4JKZ=c,K3yd5yK4brY1#MmM55=B]5~8N=sOBK=UAvv1;m$ZDB=akmfl%ZPAs8JVtWVfqJo.BS`+OLTPC?rpuPZ+=M`s7^)Vs..a4sSJt!7b;S?V=eOu?4]C~G-fK\
::s[a[b;[T?ngP[C+O4)LX5G9-9!N!7(nHn)C|v|)5(aLC|~pmK,i,rNxIJkM1PrVRTJ7A|epECpvz`8u!TGt9%Or+~Xzk4d(}^NZufw,qt|;n3AqTbVz;e%qCo%%(0M\
::EvDDd;DRP1(QDfF4}EVtQ8H)%?I`=])dgV$YoD6`T+]v)9^SKaXSG2lxnUAUHdMu5U-qf;+8h=x96jVLG-+f91=?[fQ0azvQX{yD{=)JYWdhE6DdQr!*%*T)fji4xW\
::Dpm?2}.Z!Uve}|Qn,PF?GH$COUw%j,)X`hG8d$5$6A^uU=}d7F+JAurh4yO}rn5c]VH}.Ik__3iYjKYkErIia1WUWt3j8xUW[Nds%ojv9;N70ej=W9z=7iql9Y;3DU\
::b^SUd|KIvgf4t63$wrpEsP)5PSxe8]BnnjX~=)X=Z1E+3_9Idje{wlSL,r9t)?b8x=;I]jEXs$sCkOqi8|6~X^8.]ElP?V{~nz7BikV00hV7P3XJUg-U?)I-4.wzs?\
::h+khYeV90,1)T=3^O3+nFQOSvRA2Pv#Ey=cSG+$Lk,6tmmiGOPeAvn!bad%C6!8?d.O3_rwB9iEn|;.(#{QTFwjCno]fJ*OHJer$2)f.}p4CN{,vEu8O6{?F4Mgw~6\
::~uy}?TF)EyQ*XkvF)giDBrJjcy+tt9Ov{)$c~+){q-B,j]ua#5E[kpQ9s}*Wfi]IDRQ?Nmtvc8f}_EdkGOaIB#Wfx0,wQ)S=qEmc{EQSQse+atuQ%82Vdzh5-$S2r!\
::D60^8jw35yAc$BkSHX8;=5}3Jrb$my8zR$VLW|vt25,bU-DP|?A.=n.!FB0Ce{0qsscy[bOT%v#fs4GIgthp8Wi?[Tj+L)(o{2dd;Fdmj0)d`ntBRdIj*^`%yTYPmx\
::7nwVJ04]1LM}lXSa7x*Jh]{nI(^5uCu;f!{8Q9s+TbW40%4+M9];S|%b$7XvC1qvi+8b$hmYU7b*D.7)=8qZM[;]R6AEhdnD}G{sI;O)LAhzP$uAJdQqeN1aZto]JA\
::J(_^qUU!O^WOe{0;t$`]^i6_0;-dmg%W_*$cseTN^KFo}f#FGmifXyAv6uP}hmYvQC+=oJls0[N7u7d#,fo0VYVdlf_HNitHXMu!5,-N?Cbpa-,6EA*}qrk;3zYC5t\
::*$d?rbwGUTDHrko`YA^_+C{{%|6gm^0B{E!b$f}]Rx%+)[7?whMDLpir`d{)x|ga~mBE8R$tyZLXFS9Q(luqoJerzp4x7881?D4wc`8w_hSMHiQy7FmMDM3($rSg9q\
::RN*IidQfDj{sM|69lMDSpM1dxVE5DB[J*Zqp2g,!^lxKv?I+Ol!26^jCoPVgw(uRK(#mLvC+D=sEq#BPU^Yi{54)eDY,-BT~.qwfIXYG14WYm]!Q4F2kR,i[O~mXZ=\
::dkk!4~R.;Wfpb!$)KjxfTl9r$%g4.Ejd!pDXKK,fFm8-{~FC~thO`h,pu#g(Tu;mzl.P2du+G)YU|~d8pJb99Ab44E50,7X%CWh$;hRy8DO-18uD|o760[X]~gW+#A\
::9k{Y+#kUKXYZIi=CP)+,kEbUZuB]5efw)gs8nDOt_fW#eD;Z}mUR$c0lcb(NDkYcl?L{R[]VLChk]jW,bL?j3(Uk[gNp$H.GL7.1c+1_WVD7qy8.ZSe7PP+Xo8bGbU\
::q{*6+N^{2SiINbfmIsaCrypCn_j;Xk~-FD{K.7?t^KNjXVo=_6TPoz4tG$Qmg)zNuR1B2Oedwm$0G$z6;;LGPiQRZ|e|*-1jF09m2z}lQPI})#5l6~x7q{J_Jia[Gs\
::$7JUnEkEJp5`zH+^(iK-mI.zPYR6ZBS[Hdubk!Au041jgPGX)MZFI[]UmuC0_4cI2ds,Lw`|0f(Zl%,b*2J;NNQr5=?;p313;~X.P%dW8i;x[[;~)Zs9$LRkvQbmah\
::Ai,FkYqvioJvvuy8;nX5}dv+-?(9uwV1pmR%51PHDs4;JDksjbGlt9nJ!E[`zrd,*^F3Z$`RT5gx6S9VD8cr|dHu;k0rum}lvxFh9yjf%*-o{vQCeUx(w63wDP=02y\
::0;B+bgwzhkL)|c9)0Q;vEDgz#42$FOccR[Y!*hPAq71P#B.R723J}[sB^ib=6bgoN[TfRzNlNP*kP2%_rXY3GfEt%m;dF]uRu]yMI.tXv3F(DAMg{_I[IP8uWga]~a\
::5I75{L|5nZ9WMzF.Lyvh7d#8i*UT2y6CQ`cLhvtu51}U1e7q|{5yNZn_ZLL$YMx78CL`NlOUi%?OR3H5{3E+i)}=4]JYoGmlsuT2BmX(s-Pt8(w1ixReI5BUap^hsE\
::N^z#n5)ecrnWzoE{.7s_a9$XfAZJDj6Uk?jY^JzjscH(j#,m[unBC?Hx1iMOUaU(U;yBTNzy=k)%sedl1pUqVhd.24J+s1aBQ3~Ndrwyaajw1Q7D._Qd-Aydl%O{33\
::[F;0`~SFW6`c|!7JnQYGWz(h{Sx7z;rH3y,R*0I,]u-pt[m%k}O`rCr#[g}1N{i+h$r2)QO#Wg`48T,U%=f*Fg8GHB=0cbJe6jqmwG?8(VJd3NWUwrgSQ0-nrnxAW;\
::LEj=h0*pbl28c^WB|8]#^tgHeRxGx+{*Sd)x%M]d(XTzf!g{X-QS;2u%ErOjE)WxVdC(!eD]rr~;$VW6a7Hz,ht24vYj_edkQvjVK_Qzscsj9{JzQ*hP$3Mn3bs(dS\
::x0Q8MJ-rBYh.p{a|GVJ%PQ}iW!+-9U+JVV*sXfg3eNy,q]h^qa37+tgk4.b74qsS.sD-Rfv6ZfIDutErV6{4s;%,o)=9bI]aZd8qRTDzN)cX-.0q0Xa]mPxG(|pVUV\
::Tko6,y)+G?I`ng]s=d}_q1o(V5.eMS1v-VcU_nQQZJv*ZRC5B.BUnzR}W[37T~`wlqShQ}[s##,[dbor=Hj)N9]a7k06YKy2LSx~Y`zH,ey.fO|P`K]0fjhe0^Q!Y2\
::XfnTRKIlKOI4uUm2l#?{Vp.j*W5hTs~%oNkhd[-c|wfO]fDk#V3QqKq!9YB%U*WN5}pL%5*]Nm6E[vNbLa{nz#w6Q)dC;o_SZ^}*W8*xRSOd~$hd$Dt^`j?IwvO^ut\
::1_WX_+.d]tKic)?hfc=i^humX+LDJSis!uz{MjG+#wuc;p|P1(g;`HdVkA{TVyjwW3XPKF]o$u+u|PG].-4e4(LT58w|DHdWvg4)#Cnc^l],m66rn3JMvbth7+N}vq\
::~{YNuTl)5u(Y.oQ*=N;[$.4xi[HtM[+a8uKPl_LHn*Nt_`ah.5eduo]%dS1i*dWiag_q`hb$V=!*Vd`%p%,d4^$0t5yih!e2=Av!p0hv(6G9D)o?VYrT+LlOZYn^]k\
::LH;,d(LuXU$$rD$#+_cBM((N!eK3{n|=GX]P%j%n{s~ET2iBcgSg`L`w%mLy)uEdxhA*]x)bT`[IGv_nC]7jZK5FYc_U^yPi{`pT7bprXg5Q;rf$YxD(**4QCc=uJj\
::70yPu5M~nwciAD{FGI?1NCwX5?(C|vFgqKXgiT+ljpiS87THpw7yX0k|aYL!0a-R}$TC%M}NH4p7`MkPuu1N.IbV84,gmx7-~}sV;=6~Izy$k2GO?05hYrR[?OXzW7\
::}u%-(v|E^n%JA97{Aa=8}$vb8`wDbw]{h]V9Ut|HX3qMm51xo]=EZ|Kx-$D*ex.q8wa1xL%64k%tRwD?x7z2pSKy2(ql)D=e4+A2IDz;%K2tRoPBseA7u(76`vZql7\
::Cpf.H=oW7A~e;K){6bXZ,I~Ew!kaVa}%OH!Cf_p4*R$jd$xX4RJQ|nAZy1kn8}-os;j4U=.Sg$3Gb)2E,uaVC``nJYyzxB-dn}uc|7bR2roOYSjo+pC)ng.uYX#]Yi\
::2JJhHmwp5`I6yv=}?E15+^JFid7kqsB{].wQgWPE}i-f2fl02GGaPQI$X0Dw^s,ydSW+n9M6$$QzIH8Jijzf1gZJn1ZGCp0xZyoa7n))r2ti?MUi.O+=ui#Vec8Dhe\
::kDs-{2za+;nH%VtS0#PBcjhH}Von-)[-m|,l75=Z;D2xfg7T%^.44cAcfn_4~IN}70GX^n;q!k8i3($yf-(8TUd#PfMGX#=oOz[gu96{Yd*ELr*KqfdF2.HCOBr5,k\
::irSb0L}?QsQ-UqZi^4b9DO^ng7h7uLmg;-$SDlDGeZe3piPRiXe[xUD1EIV)#xAC.BkKOLe1+d`I!,bH%}]}-XrEidML8J2)15[YI8^)?%2l-%z{hmzma_HezD?m!O\
::}%_qob2+MD^GMHU+U8m7sj84Q}5UpQK8m}^5Q~%hW]OJC#5e;{-wBXL#$AzbiO[!N^%E,Oq]13IyLHaxl2^OhfXm?v_%z#a+iZIlTW*cNCKmqS34,mQ~BVA{63v{fZ\
::wV{s3x=r$)Y28(BVQW3(Q!}ORl8QkICS1^5Pe4F+igc8d+$29#+%kDc6pi$XuJzDKw2Gz#iugXXn$JfJ*nUOoa$JkMAcZ?K3_mW%0%dDNk(vxc[pWk_z7I%wkpgpUL\
::S$D+CPJm#iw-mZ;$TnG6d)RGP|H.[L!KU5ycq]tX2!amP~tF%wE#bii+|9+[D}7,2J^lCK2r]F7_fLAx9fEk1YX+*jjn}7`hV5)9%6P7dZ^DZ!RJEo]-,hE9QF}FLI\
::J-KB2_ypCxPIulMAQ{]1S,DpFSaJ!xAcrKnYrwo=d{CLc`=`0gFW;wCBgHM9$mWB*kDGH(v$DyMvcnP9.jf3a0#Dpb2^_$HPxP~-YAp{EITC3~JVg~ugamOS-8t?]V\
::-},r*j2Oy;Tsvm-?W6nOx8wtxFoeRhH}bJxK?w,vPx_t.slAgbP~*`H2!I[=Htjni6ifY7Kh,f,gF1%k6W1^07Z9ufJ-vgH%L`aJf;9%B=r{BIbD+R*bKs(W[!dSZv\
::lO`--,s4`F4yYvuQ0*qmxk^2{6cckfSN`?pu,F;]?g|(mm#4e[Hk_HM8%I!{7?|M?G1?NHy$-)33)v{Eh_}WGk4x#tvt6x4J$eHSEL$=m-Bl?xx_b|2y[_Sbanww78\
::~N5R%$AI|b-%kK{lX[cXQ-1ajtYOQ7g|q=c6eip`wYPt,}K!08$x2WGS,|T)$}Ws*C.Uc,MUmy|X^pR%A;5kh~iPq8)D6Q!M41J5darf7jj]Uryc(Di5q$9eUF-)[M\
::e=r1l=cLm_l$bPFE73Ta4_^KfR?MLM2$?9,0V9hz_);r~Imnuh*yIG2Y76q]Xe1v}9C?4N?$hXo9pm?Sndnumc1K,nLF1e;v-0=`qZAOOhAVF7(UWe7mz%ppFpSB6~\
::8C*]wc-s%xfeHLKe?*S3l%bsoUYaY;q-{Rktnqax{dXKpQ8D7mNEQjOxvXsBq*778`?n3LyK9B0^eycJbi%199Q7H^8z`CCQbLD]^ZfN*cclUL+^owjt)#LXum]IL{\
::J]ldQ5sx^iat`k_Gtu_ED*D]i2WbbRslaC*|hhnmXZONB|Kp;rzhfV;8G?gWZ0Nud.3=rm1vq4r;+td{u$orJ4bAfagw|g#s4glxdcKxqOHGRmIZ9GQo[p;36{rk1O\
::_v0AY~hQ_D!DW1MW~;-o,.9nv*5R}}x6za95e17y7MtSujLh!|^W*z-Eu[V3(D6MVoMz?GWX5n3R+h.rx?1$JzO=T1nYBoN,m.2[h`(p_k8;*2kujw!JnK{EX|D=e8\
::YhtvgX0!mq?a8srTl]#[Oz$seW0s[Q*x*gIDyz1U?iN1+6,Q}P);bH1JMTSuKf2TLNbl]Bs]oL0#^W%TkjRf#`uznfX6DTe,U4^*T7Na3py5F(ni}L.MzQc+Fc2rwb\
::Xwy5KQ*3?mY?0F97caSV3hF|(H_ans!-i0oe^N89Gxm,8n[sA~~fOsA]n*`AaLiqc;3}Q6nbFBFthN4Q(erFdF`Zxt5Sw$6pD)#V0qggeY1sRZ-K0S]pRusq6n9CY;\
::N-$#z[0`s53#[ArcgO7HI5E7O1IRLRb7E9#FvGL6Afn!sn9FT0J(N7i4ZoeEvzfD,Ze$`fYm,-1Y=oVMLY$pLtcC6lGz;iXFF?b1DM$e|]{g7B4FqcbaHs,Yw(}Z4t\
::}|c1Ba7r97P6q(q(7c}i9e5Z;gAW6?00KOAM]{L3f-m(s43QubxasiWuo|Vh44c3v1E[Id_Jj{-Xjg`]f#M9)C#kUElJNChLmL0AIEe,Ut}KDf-ElVi;gU[Quu|?`3\
::EcKSO-X-_zPW6(ovg7Eit!Dq4xFJA(mYX(vOHv[YSA9G4QON=D0NNI?#54rH=^F~+_xWUe9*`WxW3Dl7Ih%cP0%(Ox$7aMc!,T?M%IE+R?y^L+`dB12wL?%?1)H}cv\
::3zopcF)4b3i71l2;z(81N7J6gUc[1y8~?0F]x4jqZKhg`W,fQW?PS1FWy,Vl^lhg)s_)5QQu8%P_hna2GxU+;?E]%WfpLBqEG7RFe6{%s[EhNfYM0u5qIMzRoJQ]0n\
::-nu9.P+PEn)7Hh]RU-8zZCGH%7eT+-,(u40PD{ozT!xZuEZwrc86{wtCrI]$h`#Ny1;2Rn4(c;6du%l#1WM`ZKt_|PI_$^jTAS=DedmCpw}|Fu_%fA}W^=87`#(u+y\
::!52!K.)z.PuQC}88v$_QNL9b#`}X+jbzXZ|cgmkiBQT7~q.}8vFrbeE7[eZLltgnP)(;Et~8,rI_e3i.=Tp}5w-?9Bd=R;H~{O05}(GW;|cJ|T[(eXQvhTr;6GrH4%\
::9v?-^GaFyVx~I4ty+SRt|hO8ARr]`LW9|^q^2Y`M4mHpJ^wv7`Pa3a.F81Ab.{$o(Wx9IpUx^P34-%t0Imlbc0g~p(l(c6S;qQq`ki)qHd=~9QFGmIaZUX[i1;aMjq\
::Q|h_#,BOigprxERvy6kO5d+p;z-b(t|cEUhWeHIE;S)lZ1UvsB{{TF{.|Kox4[g85FfAs0NYSUu2nlB_B18w9ol4dP_z-pOB3l%S}4xXo$X+?x;r-0{BT]OibZai?+\
::co}{g2GYG+6SKz])LdZf+Rv}0+W$X1C^6jLZ_sokrYlig0dQ{fEqz^SM;lbi[$)gGK$Om0?O1%6J_O#_kxZzh4c%1S_{oF^Hq7,lR)j$s-3ZxJA7*z}BXU$q3fh41L\
::C_{OOw?3P-KrdcaHPa8J^JnA*pT+o?VizFjpOaqM#CN~d4dWW+ik-dt_IK~0NZ9~`$Vf%Twc8S,tr5QBj65KfIvD9ktJ4+roOZk+kp%Qam;N+QpQMj1Ek1qbHlkSq{\
::|k?zS6f.eN{uYUXwaoyM8F=pK~8vF|3s5Ij*v,Gm]Z9$7h)|oBgfO8C9-He!)I6]m2|*x=J;+1P59-iRa4(!+L2OfcsgO32n0m,-^cr|kAkOrg-_m)Sb}kX]+}0Kb+\
::+?akBrPRo2sQg5^LuiQmP]zNpv6|%FXpReNu{nmou4FPjcgUAew|SGS^1~^mS,9|0dlVgswFr[KNA1;9QJ!yHWS!6L}v_W`BcoyCGQgieEp_1AJDg7O%~]e}LFk.Qo\
::OISOeVyy^499w%7cE0=lgl3B_n15Az}fr;-)yiyc+mCd-ljYD$oc5{zr?9AhL7}EPj7Npnxsz!Zg+Of}04H*_cJ,b6CP^e)Cwarv?=k9=L}.NIU9e}.W$c=e9)4I_.\
::(oIo`$G]h]t~zf-NPva54QpJHq`V%Ao~pa3mR**S[^!R~7?^]=XZyeqR(~dKY.5lpzA^Iu85)pwX0?x#)XLcjHqhL.8w_$}8V2_,d}L2l*!4fA$W6#Uhk.i_~{MKH{\
::Bb|)D5,wk*Zz2Q{{Q^CytQs9_yVk8LrSliz]#TPK8]|JRRpBWwwdyHX_G9;^`%GrF3VdTs`gLbp$xinbAUbw?i(BWyE*XZc4s%Y;_Xkgx[JS0febkgx|G9|[ho61wC\
::ADsv?]2HocHzycyHXof50jUd,H|symNpnt[02-6-Y?DPVIgb7S5f4!%fmoVX==MQhKJm84ix$!}8%07Jc-*HzOiZ^Z,EPw;X7D.(xvyed]A)G,!UPA#hYXG3d4d]9Y\
::?5tQ%+Pv,Re,c?I5L_wTLW(.#bMYu5{zB8{LAv{ZB^3.hgtx1xORz[#PC}FQd-4#h)GjL{poX{w;-ox6eY[X?pH~khIM`E[y8w87c5s1E$gT?7oYZ=J}3O-]*CITq{\
::A*+?S%[59l|=AA5Gn4d0*$~jXeR2ZqFJD+ie%D-Dw^hasc2c*r]n_jor}(x$zk[Fz{EBPALrZ1.zx)l#w_5u}wpa$9F~^anlC.5zX.P=#f-|or#SfPZ%Y;F-P(D|ws\
::Gi_c8isU*zhvE]xMl[07+a.;?CFxftPb0SiX*cd^BK#gdB|GI95H.2ONmnF=(s#tOpX9}mXP#hj$;*E{#foFX2HZiPV.s4syS5M,FuuqVZy1lZ*e#R4(z6;;gFiVIP\
::Bl?V-0PL`TtEA5L7oN28fB$kkZcjtT1eT%J9[#~?bjjS_dg{L25%}Y9FUbBF~$BLFoKNJ?,%}wHqjpFu4N-#D$z_K{$2._Bh0Cw=y=^AAbFWM~5,]+#(Oi4,uxf0gr\
::abK,rQz.fZ7]Omk[%z8UoBaVY(8LlvJh]AfEO_h!M^$Z?vPKS0P(}4ZXgF~ElT#Hoky;Ac_E;R#L?|zg.6UP8}}74v5s1LPegHLm6%k~-y6}}O7X[%QKGSbtljWtq-\
::btEPiADwwvkkSEzkp%Gc9=~3#h|Ri#ys$lEdUyj75rdIX|?7whgdT[*}Dnh_%Z^vsnU^4.L|^pm7_Db0oQO?!PJxU(,BB.s0Kht~2x$6q0D.vr2ug7)cwi2Cd_R03x\
::f2H;poh$uI{kZ9}ek2m(*6fx%D{DN[liwb;soBNC5t200I]8X3%0~od-BJq#4`kb$Qc1F)J]4ld=W7#qr$ZM|],4t9-qV_7O$uXZ#,s6aKH1ykK`G5gwE{{*+jQDdS\
::PfH1rI8`1OQAPK!]wzIP5DIE^ydYzT-$Q3ijXNMQjhazlHOv4^q*0]60VUM{=rk)E]EHRV*(Vh%KAxP^Fs~*WzPnrAD(LJGm~y*7do;c%;{]A+,O3Zj*1X,nwU`Ng=\
::XD(`;55xt;miw_*brrmx^ib!K7GN0hY032)..}a{|~?SXLG}3;Q=NJuZ8wj)3sL%CuiLlHg=5QTCglKhNmM2rI?auL3p0|nPUBM`aNR=l|jbW;MDUb4%mOtZYZw[#L\
::IKBl82eS{ukW,va_%yC2N2$$hVw$?;zZ4nq(D%9`w|q}W^T=7{dJuJYg1V;g)Vg,2sM?=!N1U;7Zz%XA(JR55SvoS$;8$cCok.E4Wj+.j5ad{KM$eY5=^)Q=p4?4ZC\
::x0jNnaJp!g*mG5l$EA0]D2`QfO=+KdpTK;*jZ}L(VrI#x,x)o2f;VKy{fvQ2?|EPra%5km=u{aU..C={W]2eQqgReus~C_pDFy;ldjM`!O#L]Z.N;L))9bN#aV4k5i\
::j|oLFb|_~c1L}jL6bB685S!,c~3LBV,3mviI!+=4YL%Z?i[ba[NlZgwhGlB85V5yr5%0E3Ss2Qeo5`7CBjqh!G2-_G48~o0beK6KP^3tuh5z4PaGz)XJ|Xzy)%9~2(\
::%81Rs1s*SI.gaxtbq2hfUG!#DDFy[aXkL6._Cn;.%ZDz8gel4Hq{tBO(pH5tsnnbpXzcgpO#}f`%kx=yvzHct?vK2LLeJ,RYp,00000v(??aZJ|]Q00000#s4bF]SV\
::vchB#mX00000000I60MGyc4FCYJ000#R0Dunwok3faUqEl^fKf3f-ngWQ*Zj_V*ojacpHUH%qm4K%X{uaXf*7ys84gCy=M7]9TQq.Ct+J(3zXGxwxu1c}3ky)zew%+\
::{017)}88DrB^KcXm}i$G4Hk#2mmD$n#EY.oq9^BsBrc$_g3]]w($gqI*(m3-A*%VxU,r|A0ZkD9MpD98rt+0-`MKXgSgU,fBd}kL]dHkbr3YLWsffJZSFi$=i08nfI\
::51UL7IB[tf}0ZqAC(|EC005YO000000000000000Zyf|qX]S*G4g-yyxDKEI00000003Yf00000000310Pp!|0002n008#`TrPn.VEG5m8A9#GoPj0`z?)Ga0GzRP}\
::8I,QyFNv?FU9x(sU%v1D~[vjI!qc0rMSDED|a~n^_*OGNT|[1I.[5o2`dxNcp?#81WjuLfA}G(=*sg*|V+6e(Iy,34SisP0018V3BdCu+DT;M?GkYDiJ+u?%J0^{kP\
::p2dJ=tT35yIRgpU1;ZWwNk}ivxJ42_gQyG?X=M(][j4]v.ok1LIIP231|!X_DQdiw3OwPv^Y]K7,h_}?sbyR{6zR%Lql`7pVZ%IcLrmm,au!n*QKx]UWk-9yBsTCoB\
::5Eag0V9t8mCTkk?}(.flGr48g+A0RS!ejfxrcE!GkrXy-L|6W;B)Z$8n)P^rP2qge6DG7)N(_O4cJp}JU^r..Vu^56*f?,=M17;fg1HUI.)00000xB=~b08jt$0000\
::0008=!qW6VbMMoGI03{kaL{0+r00000000L74-1}fjNTmp8X?l($[^h(00000=.Q-+008A(WSY#9Q]|.5L%%`|-l9.?[6$^ZiU$zxMVj)1is0{A%D-z{Q.8WQuXgxq\
::.?eSJ6J`T~I9aCz.w5*!oF_j(,s;FZnJR,e-i`Z5^HN]rbW!m2l~qb7VN%5umYWa*lC)`(x2n$4luOJuqym}EfipTXYm7o^fyBHTjoKwcfj-ZJu5mMaGx}1WPL6R},\
::ygIjuNp]*+fJPK_xyI}A=2?]blW8LO6V)`3njydbdp~qw0}+-RfOjpBMBy.j^Zv*3n2uvQ#7E8NyR;ttW[qyFb(=OUMJ);E#GbWaO;a(tfJbOg;Z;okhr5RTYD0sNM\
::{h!d!837kSq~7egyP`o!!pETnG{BVMMqX+}lJn*(Ux$lFGxS2,BCq62$IO;36f9R%M9[a7raPlLr4NJ`DAWYLA%AL]GFFUu8~6bA+k,)mI*3b2S~I9lFT^i`v;L-(K\
::aCN;uF]#nnhDZ9XpzxAeluP`C`Jl`VHb0DvU!(3c!Z^AQ)N8VZFFN6D1lX$pQ~[QH;9x9Nq^K=WFX?FiGljc`K(0Hi7|;dHX138fm95UM?Q5=O_eq1RR.sSh4U;GP.\
::Y72DLxNZyW,|(f=^R|[VW^ozkZR.--$G$HXV#)~^!pd$=ll]vX`57DEvfzs[?2#_%x--GI[GnGj;LMkU0$W`-8cm-c-qM;59T).g7,L5[PcKZ,NlH~P$LrEOlgi^0?\
::.9Aqxes21[k8qIBy4abK)R3)=GVaL1Ba~U53x8P*-b5m3[.iHDIB{eQl#zKf7Z.FIbfPM;=!ZXNz{bAOs~D9qFHHHNSxpu)zD%i,.VQLF{fg#rHX?v+Q,Q2T1d-U5%\
::nj9qQlH(7TSsf2U7AaCIgLqm+*S2M,w};YO0]EMPGTs9+ZSg_{GoOtwsES.M0HK=wgM(YmmIe}GMafW7r?uB;Pu}B=AXUXRiJi{C^?1v]UbFZdIP=2}8~o)QVPSAoZ\
::7L}$BPt9J|lLIODqE3D^TSEomi5l36Db`N*]9(Q2qir#7]C}O493_Qg74|+`.]TyGLA]HXVraOD*uvL)+B}2-ekIO1YdT3=?ZRRvtK$8DEq;sd{LG#%=qFHWsY`)K`\
::D8VD_nPlW~58rM_6P%u*g)E2Tfu+2YoajQXA[g[Tspm8tOdh,]`g^ul11InpMpowU.hPlW$mO5V,sqMJ0SX_I`qf~F,sR;}$iCKvFsSfURG*CJdWUG[^.uphE,6?*#\
::vwo}eoRcVW{0$y=]F#hJGrSTU!P-t9=n]5W)R-A74f9V2W5lHQ3,pzBEQ[zYJkXT%Oy|lrKrSzu0g}|URut1FzwjyXs-NX(L5#pt5YiyDRw~m{A_)W)Vq5*5[A$(fR\
::Q[Y29c!~GMwI*G2^Rkhq-,Zt9Rva+!_z.0MS6y%1p+TqsZ^Ur5+~ZT29u{|)CG#;hSLH6tL;}}f8Epm-Sdsoln4,+2dy}3_kun`cYi0#4nVgkB_r3)uVLO!%|2mS[4\
::gM++0eGyozJti+R9%PePUwEMgHhzoRKAm;FC.aNd?=s1qF2vo6U#uK.Tu+iXcIQV?V^`lO0`E;IKE1ad8ApT$YT6^a*I]{rj-uN=GyeTL#1Z#r=KPi3UwMNDqS*wGy\
::[0CvK|M_NI*2]R|uWB9IgQ)AWim1dOXv)62MYn#5Pp)l#_.dp$?_J2[a1YlUiLR1ODHYqKjPU$U0Aq?IsRiU^?NefMM#ZNX-~hHdz$g6h*W!Z72#F[SA[~sTSNfV!|\
::(NJIm)2;6k+2Q{.]stC,t+iz0aXejh.j(9I?,NkQ0~jREt#y3#1=I14iQWGT1N_?h=ZpRNz#{gpg)m2=;s3ptYtPSdXXuP8cst-HVKA[c,q(mufs7|Iw8TWLtT,vcU\
::tMg4wJI+G*cnyfQ19^#!74TMX^#`^GdC}Q}s,!N%.7bcTa1X~-=H1?1+hN84klZ)RXHmF[|DWn8|O[en{Avmc^8Oe;eN|EQ%SDEL,D$V{E%nsj%t7*9}jKu)e6T`_n\
::rPPZH1mEk]5O)FksXm]M;1(4|X^(Q^YH=k{9yTBnv5gDiqZ0aPdyv2qjX~gCsYdc=_!3I-Do`u3IdLJE#ua]i[|%;?g)|8}70ZLPHl)i0FErt{AmuVk)(E8L^WIfR;\
::7WH6WdXa`*=Dj3,9n(0OPBU2Qm1k3[xkpmRSIM-+MZkc83-R-]wP*]Uq*1-nO[dLA9ZAfPBxXo(Co9IUSK93aom-Ms_(,+0[475IBSUrZK-XE7U$Oc-+o.9gi-#Dqu\
::B(nb|CKp_xS8$VbaPP(M0X[)SyO3Mt6))f9~z7qw{IF.0u_9620TWDPa27.foj}}R3HhySDqjZ|Z*,l`942=,DLJDdWoJ|=RN8pBRFMZSX^aE+3{i-$Ix^^r)ls[0{\
::zWe2A3U.I_{Jgy$isY93+r9ECem5+*ZRETs~cyV)$3)KDy=eVm0.(j.[hj)fCXL9ZrO3fGVx[=#?#E,lu~jhDWpi;$qH_?L7.D?c-srJn!bIypIpg1xnt76bXbsZt[\
::ZaNke+3qydO6Jt*$OP0A4Kafc2})Z*8I~lV0RwobLmS7-._nGpDvcqd(2TS.Sw1h~csz$HNZ?JA;jp.fEyTD#!IB#S%cG1G+VceJ,s9+i4z+~]7Py_ziPG2lgu2{_B\
::lUMUvT}9TBW8jyE(WPDXyK`-L=UDtD^ffImg!4x+*`xZPA3y6Sf*#C*CM.$+}!7{T,onqyU~e3rTr0mvpu~gsD7k$V+xw!$*,dIwi1^%dX$vgD6j)c3Whg)?BF{_fY\
::-gj+Dko65*uUM2}*hN|X`6G2d.bND7XAUAqQk+gq[fluE1P#OS[y{|DaPypuPhT?u9h5?mNz(OTH4w(U7llnnm;4L{fH=Ipq*j-h0T7]9EjM`MlzjWmYkfJ*m$7H#e\
::2ikb}=pDeHtCIf|`T?LX$XPLQ7sW(WEdrBSr-j{ozVNW+uM2001F[m}QJgV1a?w0FbCOzcji50D?y]VPBZsQimiCU.I^(A?R^0C9+Icd^?AIIXcFQo%m54CqrcY|E}\
::Jy}^NQSp)`[1bVMYkB7l*~L+R+3|)q[X+f6^JlvGmL;0,AZnMm1G6G*vY5J`ubD^Nt-1PTrS0H6cb#ufP}{}o?W)}=Rfx;jOQ{}Kz#)0+$k%;9nEiJG6bF!R5UoPI.\
::en4bUuMFXnh6Nmuy1^%*P05kvq00000njcUg06]VhfKUKn0RSNV00000000934-VSFo-x!C00000#Q+BBP{$R-YE2#pt;|1XHIWRcCXxZQMAD,v=|2=6_-}+x[7VB5\
::D6Tlot#{U~MPK$*qffAu4bieNWsLy||6#Qo^JZX.00031F8Sj-##UR[}f83jn.*~U7hjpD;,?h3G3AGPV05SRZnXOlqu59*jCBcty1wBd.cL^`C!}mC0001PfDYCGI\
::RL9;IpaTEA!oSX6iXiIO1`g$S.MqJ?Nz#,*abSOp?FgHIS}3kOlt8q|_7$+%5|YP]HdGTKzRTF7ytkO00000WdH{$ADW8M^,suqa3]r-000000000000000b^t_qbH\
::`]mZUq2[00000F.z2$0l+y5Gg%FYEfapHH=oVqVg1air!hpcjA1#gW~iMsT^tMj03?eZ4gh{qZszk,PbWNv1_*kj}7HNR582Z9m^tPT4U52}^5y?W}b)|#CxaO;?ex\
::1jGLuWDldGmOGFMb+X3WY]yqTHFJyVC7A_$Q1hvYWoW;T|X?i$87qkhJ5A7}#!nX;$G,TT5m-{oi5LjrbYo+M8`olv`.S3g6oL)f}Ils6Ce(DTy%_0ZH+_8_{|a~ow\
::Q^g+5qpa|8jpfiTwJUsS)04D,d00000000008TC5mfcc(7^aBnU8*2.o4=+?pk01a500000002Q7CdJYl17HB8000004=|n(Guzi,u-c9X]CIaGOm((d-_1TM|F2-E\
::J8NWaXU+uTteJW4K9k|iva7mhn0FF)CMt7-UW|UJVxu5s(WMEA0][b$oQepOe])WSMX{#7uU[ijMR2C.lyPVxF7873[Jh)|b]7tHiFiMBJauXh)!yOvIwNzZ1i?!lc\
::R1oK^oM#VxM;nw274zoj^Tk}]KqRr;{oS}L_9%tXUhHqW-Ght5QPH_A*)fX-8+Vdna-TiX0?rs5hZ!!Nf-DiO6e[Be|rl`qlF^OMO$KiG{O!5enDd[V=5Q$Cho.x|}\
::Y*E6Gea;XzAiot]!ODI4lbpc,Y~tre=jOOYkhAjxXWV[A4jH}c%d403fCS0000000930cqng?0Ym55kNW*9xK$cA,Za^`aH+g$oAjnt[rL5sC!_1c(ZOaVnwhLI]1D\
::IYR9S4t+XH2b9nYhJJ-GY5{?XQ3bbv]][8,[)+t`^rZ,k}6q[BL~HpQUrcJGzgtgtNhb)ZZT%$7zBFdsTbZkrClD+zG%i2a-{9sBrxm!Jb)s]K62[7Ywt,r6[2A0CS\
::eQ,L)KU5ne+oNCcd^cTczk)lq!Puz?}H]1^0S};gqY,tw,6VpJtxUFI`?|d-.!JiPG{jL-7M`fjBV2k58uQ8BR,Ik!H5cSL(0L$5aI!u}(D]sextCSAH?1}NQ{R2(8\
::j$(M~?(=F$sccE#GejVv-GYWM^Fst4RHvEXcB_lTv8M)Q^F.o%*c4Y+#2%u5Azr{Uxpf.F5SGu2Lxj8H(~{.k2!+58{HU1!R17E06tH(TvSOkSfB)(Yu.SI7*Tg+{Q\
::h!C9?sF;[b.sTvkldyOFqxe6#Kjf[*]!owK?7!xUpJpA;aN,~hrE.(M|g}_}ftUTIc$|a4C#Uh=J723]CO90h?#5`OP30`cEZ^eupqwNy-V3OrNLNIxJ9g6ppPi,Vz\
::-$jY70;IMaGvdJyR?8Il[QPb}CmsNq(#=$0u^;zT]MjKj$hTQOTB~*BV-A{d7Q3IZ5+b!M$FOF*M?H]*{9,s{KLxKWBQ}Qya?qn{e!d$O~{l!C]${KluOU{,.!$u[7\
::OX2paT^,eyqG{ddu0W3h-Aj?UJ!k+F}Q[|S#e52tt])_e{]ZulybCFwfwI-U9%JP#Hx}F]tC#B(U=6ok8}Bx#4p;Ck!!93{xXf~RqIvEMI]X7Q(MLM9S[q}]nyy)?b\
::z8yW,nWiNalNPCZ2,yAYruO2i1s-BsH^g2R)HRYO1pgCJXB*ZbSSjO1|P2b6P_8?8k[)qEA,,S?ueKeB9LrmYQ8-?X;yQF84iK[$}Erq~_w20!0WqRu~*}za+6ok5m\
::6t!{Ha5!FN7V_p!?DtbT|?tLPn?1}`g^L]Fu%6JvtOTxF|UU~7oW3t-|xpOyDH5K~kE($j#YPh`n)v(qe}H`pVTQ#84B7s(dfUt_.J~RJ06[Llv^FLS_]V!Nf0;XMQ\
::;3Khy]MMHpX`e|GT?}UBCdhkM2STb,9H^(kxQ+e%i)t5S(`-hcH6w)MNhXzyLwo!631Qp72kD6eNO92$zUlE-)]oaq8(ZusQ}sl;%`.g7iqJ)EiQ.slp$FzSf4wD}Y\
::=$ADcW7)i}9C{N[W4CVx[Kk^efuJOvEpJb*GUH3Q3[!+!6x|d`|?W46?|G%pA4xJ7j,+8)hVOmt6;aE,gpcyIto4UEA.hJ8BdzS)loC?S2TDLs5}~5Zlx#_ZDBhYwz\
::GTZkRTRYgq4L0$00Avv-(0|5Vmtop,C67oi;yt+X^4*k[FHq-~YuyQsBplC8R[J$WV^XXHdcVbe{CWVJaK[4tg4r%%grkKcC~D{D#WSjK`SK}4^^?;40,*6]wLsz]g\
::~ws2UcUaTYWF*YqBv2l;[3suWf}BohpR.0^?M1Nnjtt*oEpT7H=pQ67Jt.d|+-xqWpoFYbke^jzo_.*e5EFJFu(DoHEaW;FKBa;}-gEs$~pwV4G8Yd7C1ZMemX9r(}\
::RrFeVO)TukHk-8vV9I77T-R._4Txr6KisPIS]M9QCqd$t;a1sWikKkAj7.qB#F-wcbYl)DCPv.Xli$!ng)[;Mc+M]l_*VEi{kW+ES2s$5U9Q;Ko64?;knEfIHz3}dR\
::4Zuw{q8b0D+|M9ztWSw9W?$sS}zCavEHe55O=ov}|f!hkXbxLPHyGkIB*(WI^^^-ttPu)$5z72_ZSAroc_d(luWBNH0B`|I2m207^^|mBY]1#iSv5r^VYEw,+mX6PK\
::IL~{8EzO[E^S`w^_P0|S.ek5]N2FQGA%%DZkP76q`,[p?DPQYB_{lE,aq=dwg8ULp)dPzv6Q3_iH~ok9GZ1Ym2_tHkQE%J`%6=$;9[pL.Fpg.EM^b%=8$7Uph6?HpH\
::jZy)iY_,n9cx$abBiroq,3USBvQ,Nx=7wv;!w*5Dh%V#~rnC2?f}tf6%hO2`nn8Y8oHWBgS_$)*|k.HT.Wj;X-Tm*GbJjoDtpPBgGC;c%4G5s7z!T,O#Xyfv?9A)~K\
::DhpJSZUZkx-tmN.5hS6Y=z0vgh|Fj!i7Tog!hrNbstKQm[fASszc(gfxF8P%+V]|d7LzrXZ;Qx0RS8BlGb6B_7M9XQcA5m%P2|dPO]*6fsk.ei`[e4fef%8)N8P=Y3\
::Nq;v$DW$5$%!v#1;d(4_y#Siuf-Bb|kRCkZwZ%}.hKZl^y~SC7.SSaos-[!E|b.D2]}11g8Fr+Ltz{z?XH.;;=mQc2^Wk)Xm,*[HQ(e6FZ=Q-3s1B.*G}Vfcu*[8]7\
::UkQEs$8C[a]8[c2|dcSahzGpr$m3.cGSenvW?IITU=|p+h^Z)=91jG9}NMPIJOEgdZD;cdaGXbxu)+2ytZ]p|!;hQvhMDU^u2Mg_%An9IIXgfGu4j2*kOBxr))y$|{\
::Tk2j2qp_w#Ba}(m}l.Y#o1E[Zz|?ClceGMc.vzy!D]O=Myhchg+Ogjt?ckH`4-G$[4f;m%p={A{sEY=tp?kVxL!t97KZ(NyDQLgvdhe8iW.4rqphhPvjDI1h3vr;7n\
::4-+;3cC=v5ya|^5rj%S1Ji#HOPR7=G$R4;Bx+EvRS^DBrt_]QXz3W,R5)eJ^bBEZ2ljXV._MUt$Ghl6M;!.[nml-}3ljqo1j!v8v0x.je;knkT~Dh*|Ku{2c7Ux?6a\
::9ZuAcEyK_r.).9(7h8xapqLy`}=NdxGPVzr#FHoGO9ecf)V!yTr,3#WwUR-7ui%TKm]Xvo^iuk8NuX7Vu4Nm,MozT38,`i|aRP03e2_gi0G$;3_8zBt1M80`U{hFJ`\
::}z[F]M3.HK%%#Q={J8W#%qknK,Kh0}sUHtH-fB9qT|LcJ})2j(_+3nGwOkm5)T}nclp48$H!]!2FBVnib1Obz.qeFdUyRi7h`qCmHd.ZCv,am7Vi})(?|WUyYH?[~v\
::hrY=gq(O1XMDk*ZXh];Q;=~.AHy2fTCJ#XLW+M,F7~Thv48Z2w_KXw[)QOTfUkpniK([]9O`#DbP;e)au1iJFto`%6`AYhZA9Xire%2Ks;4A[{zLS2sH?(TOeS2ksV\
::ouu8ZtpOQRm!{?Xyv3PjndQBk^#RP*$o+Rb?tDakiO;Q21I4-p|Gw}aU-(8^NeNnr?_+(tDdj*4!];{Fezv|i.fdGvMG^up|sC%iweo%+AIrMuCCT8D%.8QG{Dny%J\
::W)F}3=lO|7|mDtoJTJfA{WJ_VI,3xEz+b4RA0*i?8LdIx)oZ?~yc]pD!=*4ya52X{;duyfHnopauSUyB2uqV]MtQP1WFE~)_Xde[qW5dHT(zrT7vW1m6;d|;$.(`Hu\
::[xwtnaCAu.sPcQE,i$yklDK=L$r,xJ?nKPC+#EJA`*`jaxlTrjX]r~Hbt]+^F+yTU1yxGx_s]6o0+=%I[)L`s+N)SiH(Tr)!.Q.GAt8|_WE(7$5jRbp6H+zwjhJ5G[\
::.P3wdHJaI~$%P5t*Z7%#O*(rk7$vS6WOSf.O1s(P;y`1dqyF~wU46cE[o1chR8zXDYr4x8H5Cm)u6(n+{0.7Do2pBzK=,!i^hL,=eZqCI,lq3J0KH!-H=nGvj;w*cE\
::hCiOWN~^EjcKr5IacHlbu4b;wXxjl;6-R_(HYE.}S}O7j3uu_[7LNcKC_#7?rDtR-0^D~{}|er;5hkS(2=#cu4~$`RyVLCc1(_l#~T}+fEBXE]GWf({dV*ROTDQ5N3\
::BHB]BB.%UqrWSW~6o7e+Lk}-Hg8!wj%,=0s8N+P|)4SFFe[*sYUzCIa9(Pzf9CsvyiD%=u%Fb;97M~4}hecbnoh{|)Zqy[yg9T=Dj%p(0Rk?ud8KW)2wMK(V%TO9;Y\
::w7(`.XyohkvXN4I(}}Q*vcrk}0cHOpFc7ue|lu8=P.g{B7(=80nu%w[f]s_U}7K1jCH#{{I)hP=+EOr=n^,,;-AA$7qW+J9Mu|A[*|8Cv,Aj*i;qY1Z(ZtsSTHIUEk\
::8m_aXfV%M{-JJ^HkbPMU|5mi2Kv).12-|b;mOJGq.XL`lK]y)CSwYStW[F}jqbHwPzNG=|?6CH-!Bex*Zu5)Zqhdx[K5iO36eL*Bz4CM(,(.K^G)#nhZo%En+S7blJ\
::QxxIV5i8S(wFgfNTay0hR8hS51pjnrI$$~rL=+(8J}|ddI?*SFjoY[N7u=WfQ-;x#I3{P1{7rGF;k-dks_e,.qXzPJHzoOvU2~nKC87j{e(RdHj(})Wb#d!{F8D8Z=\
::m7+lh=yO!JTyru-0ib=xsWb?m2?siy5ZSZ_[a`C?XZp%Vqf{~84iLZ%x8y7lIw#l^[nGG#WFo]v`,a`Uq5zXQr6,T%p{a*mn[M{;dyKj$[d0Qdh4V[uPOD[,-[(l7;\
::B!f;8b+kjTLSkZ|3?LpXp4wbd1X7cf*yXQ9Q40*+*]Ftlfe~#o8BNv#,08f{#[5eMunosp+SGDAWrh6H#G3w$hKS#Fnv_uTfQ)hvmGt8R1`44vk1XJL)l#}4Y%KAx+\
::cVm9_(ke!Zmye4ER92l4{OAhS1vYKPZm*~6Z25pvebV^AGL9Y{%[kH)OJCe*vDqwQoQ6Mst6bE%t6]+%9zS=xah_Ml1Y)aE`FlVC{BT;Ct6_obRS}=NZJ5Mrd_v35}\
::.rCQ(5^7=$OU;i$n_])|WMXS|fcDF.y\
"
if (WSH.Arguments(0)=='res85_decoder') res85_decoder(WSH.Arguments(1));
if (WSH.Arguments(0)=='mod_panorama_localization') mod_panorama_localization(WSH.Arguments(1));
if (WSH.Arguments(0)=='add_launch_options') add_launch_options(WSH.Arguments(1),WSH.Arguments(2));

//  AVEYO's D-OPTIMIZER V3 - 2016 (cc)                                                                                  3.0a
//  Introducing ARCANA HOTKEYS : Unified CastControl, Multiple Chatwheel Presets and Builder, Camera Actions, Panorama Keys
//
//  Important notice to Valve (most definitely rhetorical):
//  - Instead of killing legit scripts that bring mostly ergonomic features, why not hunt down actual, reactive cheats from the Ensage family instead - it's been years! Just follow the money...
//  - You've killed autoexec.cfg months ago, and still haven't delivered on GUI alternatives for many features that users have developed and got used to over the years.
//  - But why do that in the first place?! How hard is to parse a +/- alias and just block multiple distinct abilities+items? Armlet toggling? it should have been nerfed years ago on the backend.
//  - Feel free to kill this, too, but for the love of our Lord, don't VAC users running an unmodified copy of this "sensitive" dotakeys vpk mod
//    Hashes available at http://steamcommunity.com/sharedfiles/filedetails/?id=408986743
//
//  Important notice to Modders:
//  - While this is not strictly VAC-safe, it should be as long as there are no multiple [distinct] abilities/items per [single] hotkey.
//  - Invoke, duel, blink-call, bear-recall and any other ability and/or item combo scripts will always be illegal!
//  - Please refrain from doing any of that, you will only lead to this being killed too, like autoexec.cfg was.
//  - D-OPTIMIZER does not condone cheating in any way so don't even ask about it!
//
