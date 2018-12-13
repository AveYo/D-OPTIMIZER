goto="init" /* " GetLaunchOptions prefixed with / or - "
:"init" 2018.12.12: fixed not listing launch options containing -
@echo off &setlocal &mode 80,8 &color 70 &title %~n0 by AveYo v1.3
echo   GetLaunchOptions grabs -strings from exe and dll files
echo   Simplified usage after first run:
echo  -^> Right-click game folder -^> Send to -^> GetLaunchOptions
rem call :install &rem uncomment to update APPDATA script if new version is released
if not exist "%APPDATA%\AveYo\strings2.exe" call :install
if not exist "%APPDATA%\Microsoft\Windows\SendTo\GetLaunchOptions.bat" call :install
set "game=" &if exist "%~1\*" set "game=%~1"
:: powershell openfolderdialog snippet
set "o=[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");"
set "f=$ofd=New-Object System.Windows.Forms.FolderBrowserDialog;$ofd.rootfolder="MyComputer";"
set "d=[void]$ofd.ShowDialog(); $ofd.SelectedPath;"
set "ps_openfolderdialog=%o:"=\"%%f:"=\"%%d:"=\"%"
if not defined game for /f "delims=" %%a in ('powershell -c "%ps_openfolderdialog%"') do set "game=%%a"
if not exist "%game%" color 4f &echo. &echo ERROR! Invalid "%game%" folder selected.. &pause &exit
:: defines
set "numchars=4"
for /f %%c in ('copy /z "%~dpf0" nul') do set "`CR=%%c"
set "regex=^[\-/][aA-Z][^|<>(){}?@#&%%!=+.,:;/'`\[\]\$\*\^\~\"\\]*$"
:: process game folder
echo. &echo GAMEPATH = %game%
pushd "%game%"
del /f/s/q _LAUNCHOPTIONS_ >nul 2>nul &rmdir /s/q _LAUNCHOPTIONS_ >nul 2>nul &mkdir _LAUNCHOPTIONS_ >nul 2>nul
set "outpath=%game%\_LAUNCHOPTIONS_"
echo ;%~n0 by AveYo v1.1 - https://pastebin.com/bhQrywES >"%outpath%\@LAUNCH_OPTIONS.ini"
for /f "delims=" %%a in ('dir /a:-D /b /s *.exe,*.dll') do (
 pushd "%%~dpa"
 call "%APPDATA%\AveYo\strings2.exe" "%%~nxa" -l %numchars% -nh>"%outpath%\%%~nxa.txt"
 pushd "%outpath%"
 cd.>launchoptions.tmp
 for /f %%s in ('findstr /B /I /R /C:"%%regex%%" "%%~nxa.txt"') do call :launchoptions "%%s"
 if defined sz echo.>>@LAUNCH_OPTIONS.ini &echo/[%%~a]>>@LAUNCH_OPTIONS.ini
 if defined sz sort /REC 65535 launchoptions.tmp >>@launch_options.ini
)
pushd "%~dp0"
del /f /q "%outpath%\launchoptions.tmp" >nul 2>nul
if not exist "%outpath%\*.txt" color 0e
if exist "%outpath%\*.txt" start "" notepad "%outpath%\@LAUNCH_OPTIONS.ini" &timeout /t 5 >nul 2>nul
if not exist "%outpath%\*.txt" del /f/s/q "%outpath%" >nul 2>nul &rmdir /s/q "%outpath%" >nul 2>nul
endlocal &goto :eof
:launchoptions
setlocal enableextensions enabledelayedexpansion
set "lo=%~1" &call set "lo=!lo:%%`CR%%=!"
if not "!lo!"=="-" echo/!lo!>>launchoptions.tmp
set "sz=" &for %%k in (launchoptions.tmp) do set "sz=%%~zk"
if "%sz%0"=="00" set "sz="
endlocal &set "sz=%sz%" &goto :eof
:install
set "res=strings2.ex_" &set "strings2=%APPDATA%\AveYo\strings2.exe" &md "%APPDATA%\AveYo\" >nul 2>nul &pushd "%APPDATA%\AveYo\"
copy /y "%~f0" "%APPDATA%\AveYo\" >nul 2>nul &copy /y "%~f0" "%APPDATA%\Microsoft\Windows\SendTo\GetLaunchOptions.bat" >nul 2>nul
if not exist "%strings2%" cscript.exe //nologo //e:JScript "%~f0" &expand -R "%res%" >nul 2>nul &del /f /q "%res%"
if not exist "%strings2%" color cf &echo ERROR! %APPDATA%\AveYo\strings2.exe not found &timeout /t 10 &endlocal &exit
goto :eof
:: batch binary resource attached with RES2BATCH v2.0b - compact, highlight friendly, optimized ascii encoder
:res85_decoder */
var fn="strings2.ex_", res="\
::O}bZg00000cPan)00000EC2ui000000!5a50RR91tONi6NdN?[0RRIP09XJ300000005Oj[gg,Bb98cPZfA2cE*gOS0D;u1K%+5ySX|RAjRO?i0000YQ_z[j01g1V!\
::Ng35ZgQMal6.AwLC9bd_r[ILavJBlQ*NXDMX*qy$JM?g[twGfb,%nUxF=`i$$N~ue0Y4e-;AeGcsc(Pr9D9qkOnNbHE=AezpY-h)2jM{7)`Z`82~US1KoEV|R0-42`\
::F*j[M}tYt6Gz7gk+#+Nl!QL|uKBjQEk{i{c1THu_jRmW[.KYy5N?=Y_}9s7Pf,uq_[7cMT+3M]4(lOY%^R`q[]s6{)aPyKmY_n0Dx,L2+Vo5mRy.,Vnl?mc%7-T4`Z\
::M]!Fv[qZp6%g2bUvABn|0scR4IENA[Czty-Aj9r7$9J!%-eJSNz8^Sf.9J}R-t{ZZ$U{0ywgd,bKp$b_)L=#AL4c#`c%qxDW=zPm1Fby;~`Y91SUkN_E|;*c}|$6rX\
::Yeb.}#V-I6Jux-ofdJQK`#7;)EF]y|6;Y1WR?Up)[A4kO^}o_oOJ^Jy,t~Z^Sn^KeGq3|^bNnpb19R~4z;oH7XIDt-aF[^VU(~rKCcAvZ%=qI{thxuR~EcX)Uyy9Ul\
::,62I5!3$gq$gEQL,A~;CBq_VOeSYKL]p#_m.k5i,cw0kHcdG+tq=*RK9~{y6x-!Ay$]5YObCw[#jcs*Cxx4AzoAc5+$`1(yM=HJ5YTdRmFV^^O5GUGwZc][Q6`$L1|\
::-6c]U9U~MrPbYh(,#e*L}^ofYkZxURZVwC#nXa6C-MPme*i6ZzaSV6-3[BqJhAjhlhil4f+cgjKupwwxvegxvVmN?vUm7S4z*lXR,231Ipl3c.dva3KJV%O3]vYl8!\
::fVil`S*qtQhllbulxso3CU=J}hikQc7F#KxQ+8Ldp%-gIp+hE]W)7Ff^3eC}*3_kkU4f)xiJ~Op,0bW%gjs]BvrpC9%Y6CZgo;.tsN_pTJVaPqBm;c),SYsuNo?Ks7\
::||IC$DEd=8}[Zt]T)ogK;[.^b=VtiaSyGqhA3o-+*3Qx;#-,nm.!Rpe9%2YrbTYJ1%JFUSqXqT[Lk?Am.GN^zTULw3HuWaEM#3+_$u2r8%?d~FUD}Z3b]i}#e7{-$y\
::9UW)^qiu8}nZD8e;H9dtZS0yLB3dycvt;SqkuC,2b!236GXs,{HzOr]~Er#teHB34gR?0hOyfb77M;$kH7D#aH6{9iNOjkm37(=-1mznA}J}_;tvFXA{vML1NOQ2}Z\
::F}y~7^cIWJ8)*8,Aa?[He)da_?nZVX?pWr-g7Qq_#u-njTwZtU[ZRYHKn!Fe{RUodi!u%1W-b6XvNe#s,G4`qcZUkGXgi7-W9*tF;tM7~DZ21oU;RX5ZuY_f{%`F_O\
::Q}9%abpwl,c)]}CEQ^#qV}[*EannYQA)*bh-._64$_|TJH$]3N_NIDhW,0kmULM|GV8RdMFbg,9_#Hwyo;41]0wNdbN5mKSP6qz|!Mp%{~W9|4(Zi$r-Fp5Tc.hx;a\
::OEGhlM5=y{qbIB#M~6a^`PI[#=0j;PocaINg7,rTCk;h{5N$Dyn}4.=h?{8znZ=-GWdSI)SmGJ6xy)HNd-vhm9DKI=2WZTNZ1q^i7EacSh|j87MEZ]rsoK_K_SP?en\
::8PZ|gq]TZ6n5rx{0qTsIrk.!E|v=?nq=Q(br,c9ez3Sq_`P8qkC_{adEhQN|K8Sj`[u+J}PhsR_i)=,T[4w691%t)vqXb5XEt|Z+q4F_4#{r0KkEZt;zZViA;jJ9ao\
::D7^u9y}|FkI2sgya*V5H%UP.%jfBGgkpuzo=N{4c5lfUgUIzuW8WJxhPj!-57rY-N+,$`]8q7q`l[3(2}wH}}41+oc1n7M3oqUEi]+`D08E^?4OGs#9k?ATz9H]t2a\
::ZGRspBM+y8lx1]bVJi$v--}z757rF?R2gHLjY-]);)T?.-71lU5xd.?yh^Y%quQ;o?0k#cCKZK#)3(KxB[K~uXOR.o|q%Yg%LmY%G+2%|AmbeGXK3K}Oz?g.m[-z{t\
::C2?}i7gl*]clTjF-60RU=sKjnhgGYD(tc[LQNgqL%[Z{YRE,1EwiJbN=uFXGo%bNnx]NWVT8Z8x[GoA83u_w[QlDJSuvIImw,3OfqldmMO6RY*OTCzM;x`qkRoTJFZ\
::SuhaB,nBYlxL)yb.1FprCqxo_MX4Iv~Z6-;-hy=[viHRi6lM2_fuxQp?kbzWU9R$_,01me$OKPrfUV3h|r;sK1p]9yLux4f~v!Fu}(=-gm$8.lv(`hGqxUo-vNYI{y\
::]4I=IXD-p`Q#vZ[~GsV,vQ4TJh-t;%WUJ$d$5yd#[3=9?*|SRBL!|tzT|q3?Ry$z^?kwWa!TUb61w{oOzL_Wt7._Lu[)CX1ck2,,+5oMM{%rt,2N7xb*xKU=d4Qu`e\
::5jpJzZY,lKT#3%Q8,Ap~-A6s3Psddou2-23-*8ELq({)^6l{8`8d|oj0NZEf,L$bbC$7G].b7-2qwKJ)](]TXKo#h-)Y8nJ_[P,2Q-LrF*I;;5m[[g(;#)X_44?CTV\
::Kydh*hl,L{i;ZqZOj7D|Q_M5cfw#w9W[%to}GQz_ScPMrVwI-+1d,mTo8CTlA(-}CBGu2)f_=~13RoQr4GSrXByeMua-1~(audQ%l5|-GPzi$5DQu0Ggf3tsE|dPT{\
::bv}LY5$WlSUO*;sRl,3J7glQhgS5K5,Ou*EJrxb7)H=XlNNi`w4v3%*zm6IaY`g^t_=E7#[f%ASB#pY4Qe=*xblSQaMFA[XL#QiVjr%Wi;dt*dI`l4g}aJMB`!bzMl\
::2ZwIXn8Icq!m[#j+ciAl*#DxIT4{iabS151#cNd?C)kOQIl3j2bl5V5tpPLu$`(?bb,_yODQG*|89g{p7y,i4FQ5d!GL(^M3n(U,c2KEbH%}2l~qDya|puE^kV!4w5\
::TyjaH+F^Z$oq.M`(dT{eo0Q+mnQPkaWDYZ*hv+k*Jr8lIAQv`sl0zC^UeKD1FHx,*OwRh=#]r)bMF4zR,jw}Q2^7pTRw{I{0mx$zD*)OMQxlv11kI{1nN%L9FBNKN-\
::27#RKkG)Xm=%.U?!}vgzpbXmTuN60R![agMydN|lVsmNe)#m{cn6}GP|VXfDb%W8=u^K[a}c;s.CIV02DevX$XJ1Mg~JmMY*Jsb6]u_z9WAf[wRMX1)k=6;^{q{V54\
::PTd.vqAnA1={u+ix[wX0[UzL^_)V$!grdYK,)aP`*u[41J9|c%]p117?B^A6OJ=7zH7LOQlSYjX,r#kBKtL40ZzQJbzKT+2^{=dedu2WEx2Kl1vRG]utW~4cgv5ltQ\
::vZ!+EY$j}JlGeBD+_xXu[]ui1[;K?ufmqD-V[HX30ykFTAm+`*#ij=+oyI+$lT+)GbgdnrI!I.6recKsxDCI,k`PV+GSjhi!Ets4Kynh7}7t}4wg`A3{uq_CPQJS4x\
::2=|)U7B+J?G4$eh.q3Hae}woC[(qM)9OOl=i#Eo3AT%{q[}6[mY%!G(#4zf6$P4+oCr4D%8wtrfOKeTM#4}BXBq^UnK[X%T?tt_p6zLsptHyKS^cRQMEY~(VlSETv7\
::#~a~m1625IH^]vYPdAgVp(yK^yKMxh^rA+8S}FoWxwQHAoO5Q8y`yI=+Atk]r`=O%W8;?2(1$$DQ#wB6so0^NG3?SL1b5~Bw9D0PWZh?v{;|}5noXj|0#g^5v*1JfH\
::(#Z1_FT8CU,B4v]^f+x4!iLab.wF`dVFI(6pZLGLj7=oWW,YZ$i;Iq0cYQS$7Y]gOLKazfxU[1)dnzbYdj|_J{{yuIeL?OXL.3qEpL(bkW%dr!lf2t%moe*M7UPsiA\
::=plvfqkJS#_37Hq^I1Qum;ek)xYz9-^4KG8^QMjjr#;.OCkd4!|d^KQ=D)rq+z2JB9wmFWIObw)oqL#1$ZsoUjKl6h(D`9b+]H`wzZr;okAjB-MC(W{9dsym2_b3v(\
::uBT-S4nfO;lXd~P4vZ_YV$S=hcS+ykW9!}I2PY4[_Gk?8|2S--y?P?McMK;GOVDt(;aY5M}K~-Z7wqMmkN17c.6P(!5v,$|9D-wZtp4=oK1OrR!XywyM#rJwqndBXp\
::3)xNGo=BV#]^r.{-_pW4raG[*O$sN#)}aEs(2Khb)ezmgSIAf-d]PoR=g$%uwCcErjVClDTEzBFGDV{wiRkJ)`BQB+oNlqPyv_T+M!_5yk+]p{sbdAbs|5jEU^}CQM\
::$oBUE5L|;OYK(F~p61oma5Sb%2a+F(?V+8aNHr2~RhO2yU~p{Au[I5Bi|Ms~mF5HAMLtV_y1JQj*{e[FXXwQf+-ChjBgS^h6%*HiO(!I4uWhpidx%hCM=ijiQgkuCe\
::JFqSawms8[`oy#tSDUUrxlWRcv.h+Ix.aj!Z3rBvk{eKR)CK1W]$28Lp)vP.c=m_U[^SBI6Vh3|p,rTI7-3)ZHFI-`-8X#{wd.q[FWEQ}^%nM~GmT^}{Q7e6cr*Tq6\
::74w$2Z?*#cb.5IniFsgC.z)4yohc+8-Q*xHjR~EU=m0GH_(a6c+X)_d^-o+qU+*scwM(Mjnn17eh#k,1*Htf{hUhhtQMkO%=K3-JGsV.U..B-Z_D.qM3Tr0Lo{0.WQ\
::PN%%y0Hg2C.dRJXi!.LM(Q{|M1vj?2~My9luVh.MdT3pd(HK.}{GQ|P5*}9|m8.[Hb,=Zqk6}YTJyaZmxJO,sNQJsesQb(b;fA{|?),HE?~z_P4ivDp3dwxf)0jQ27\
::NwwvK4.3Pk6aEIZPVas[_eHYqk=UyM6WR4H0?j])mx+UDz2BzUmsqbrE,,*,g;ig!d8V.PCTo{B*s3-CB]-,sI`S=7`kg.zeug7R=Zok-{^%JR;$4tiyjCN5hVG[uD\
::tf^E_ce)DrZ*#f33G#wS(eQ[4-_GGNcJ=B*FXg^`?|{]d]XUl5uV*~L}Q$LlsW]8`,^yi8$9-PiZRIT0buAn?K{$pK3r-;bf0A(e#rWtM1$t]V6jy6I;d8h)X}V#t{\
::tf^k96w0Q|y7OV?N#.[!yS89Qp1AvD[QcKi~(v$?|di[RdAh_kk*Oq9(Ob9NK4-c*]Xi,hBZHy0-]qOeSpTjN]qCXwlSl1Fqv)s}Q%_zGGXi,vc7;x#Ci_|)a-eucx\
::lF*{E?[l^-FFQJ|o;VIUR7Ahd_HTlCnZpO]CNa^R0ed9U|)[_plemK0mUc7_m1C(1bGWX9;G8.[2^Fcl(VwyI+$K_^EQ26Pl0RgzMtB!S(q%www{bRr^=^d#^R6ylM\
::Z;PKVS8P^cdR+-s~+.T%tfDD)DV,D;!om+px7p)I%4!Qlm9ojovH}^LnxrnpWIA|e?yPaF3L(aZLUitNVLQY|HWs^rmWazL~8#4a(FwXk_TBvnn,6X1O3S5(fHq?go\
::(!^CZCohh$VGkK{W=7J3BT=NbyD6WVSeRBLmwTCQ*Kc=a*)ri[S.35~St!eJo$inpAi8IGzAEPkO`lwCrp8b;}C0juXd8^pWg9-_D#%i9!}S,EUeRyGKOy4lsHM3{i\
::^dg]%wff5=jKTiE-|DUh{Sss0HlAp*%KM5D=W=t,k!w(a=-koBV^x;07n1RP%AY`^]f-BTv^POuU4w+H1T;y8dkk{F6KXBOAdQ}kYlD3O]H^4dKR7l8eTEdc}uHDi^\
::c%`^-=,qXkWs*8}SC=VyL3;5#VjDe~ybW8WOE+AKwDbDglcSWZ0hUSf}W3]nt}$dEhqPrzZTm5p0s^i6QsU5rzxFmV,+pa,gdqIbjE.oC6Ru1ci1yx-PJCXWqQtl3E\
::RB$d*EZCIUI3Pj;|;ItwbfJ!7Vj1KB#Kx!v#c.+U#X[Qj]eRd]eu`mm-!mevOV=L#_8Bl}SDfWtM,}()Rrfhna-KTofOEjHfK!OX7pRJc1[b]y(;SVY9u?q+*%55sJ\
::#FGE3a[IUGh4e!?KkvwmfoiFKoOcKEZ#Mt.LpsUi30b;s.ZvMz_+$Q%v0*hnUgt(dr+*rOKO]!#^Zn(miOOb7il(EO^2`?ZrN5wV`a]7c5nh3n_xi763^CtF-~Qfli\
::H+H+Yh75qgJEtwAiM~g`yE1.UiKbu?Z6X!JCK5s0mU2D-RVDx7boQz$Q$,{EFLPr~)Zp*|~+]h]y_).r}~6TUrCec9Z3RxM?%ES3fvI}Y+ZRvt!4BOj1QLPh%cs9B3\
::YqT;^66,bEbJ8;*sOCP)z,_5#6uU*5qC)^!wts;50a26Z}qghj=Ga|T]CRCabc}s~+C1ir{Tf!tO)0Z2TEh_NXTT=bO22Xo|tD4Y6g}uf;sl9__7rsw+,Ney~6[l3M\
::M]kg3kOzPr?pQW,erR2Dn)rH!BYZ[W#8+L^?70uMmOGN$Ql[~TAShj-J[jx0CV%3`Y{*;q20Vy.U*Q`GWmd)Z2_HZ^KTnVcWTeH`hAZ(a+sBOHz*^-mX(M9.7C.as1\
::bR{R8]GOfyUrNyI]|2{KCw?o75[2A?CLi%NNi01s*(I34DtoL`JkxY~hHs),X*_6obXSM^k{z4?HBuVs}}ORnVXu`6-G7{+J,eIyR=TdaSezT=+2DJ0H{P^um^hZjP\
::_NdeYG5uoX05I=cx](+}R4Wq]S[.(Ksul%3uIV2,L0[MOpU-2.+by9gR=YL1CEZp8o_E!BP)J%lI.b6+BSHuDlKvemu6!ne|4p?$C]9|A5=z#u|%iuYHf[x.A*IKzN\
::2{9uh{[57[pj4k4IRrki9RK%a-%[-_tXr*^HO0F[gYk_](W,0Xysizzmbn,{t|~6t_gIif{IH+*dzVY#6`Iv.cyaLM)4V^ED^ALH%DBdLe}1.=+(pO~?t|^A#~*(~D\
::872xiO*1b^V^UOG7Y;$~cd-8kI9dI`T(XFLE$L47b}TT!ih)AXauA203piD1_$}Rj0r43u1i]i];cI1u}}Il|Nb09nz,Ibfo28M(eYhUGg*vg]70].I?DL,hE1}bd^\
::]$IVV8z~%7hnnb=r7NB^jEfhCL=#J4yUCvEu[+zW.fNLxVjxg6]lWWemZh.Ru;x9Q%lKfwjHe9.HoQc!QzS]^sgNfRZAEg,LD7%y0m^7B6UP3xvivGHD{!xFdQ4?g5\
::InG+^a;Wotj];S=v$)oeg{Nd]f#5|1F(t7$kiP85={MyqNMx!=|83m3v)=fIv+OUgBc_N_)DTdgq{iS*4-((Q_ilp9_S3P|r-S~rF^zVclh[Kn?Zi|93WK8uORuZ08\
::|kaX-N?#2ekW,d0X)%%e,Ai%wIoAqPg~r9yy%^`D]y.%H6|nev5QV!Von0wT6wtL=s~Z~5NVO!9]T52[wOC1zV2nDT9jDn%KKI-L7(aUlWFFfON_R4jpk`;OZ{WhY]\
::HYBr{{,L-{O2R2Cx0qyD9e#]O+NL)u^n#3Ndo;EX.7Hb+Dm2Cd;;^!37sFGKZD2yTyujPLm.W77$Ihxr4uVa(LJO}u=z4TCUnx;+3m#JNvWH?Ud!9Gug622}qIeALM\
::PO%%ILL{pkB!eijyfR12,TznE?}NF$jOl,oi01DIh=V)?K0X1tL8GwOkI-T(U}PupT4LrU;s^ow]WF]Z$hd7H6Ff2o+Zjq*ZBl?!c[P}pn3*=9`rulABC%uSU|LY~o\
::*OizEARj34vY%$wle!E0cR|$+Y.apt5+1m*umK;h~XgjSJ6c%p,TE#d0-CKw4?vMJ-mQUeBL;sF?hP_=c%evN7M(ak%ct$INa1cv9KR.KO^.vd|ekQuX[PoIEA?N`P\
::ZLCkak3,g5cF~SJCeIR-5rxF{^UauVP`y$lMVvNC(kY!_DK($}[QI=h^uQ;1Ygm52{_#OiKlbliHJqF*$!{Pix~U5~uJ6`zi_Y_Pz_tiOF^?)Ev4L,~sNJKWjHaIUo\
::B#MKPGBYOdYM$({a*B`#{5l0NE*`~Ot.MQ,gXhXL(m*WbZo*Fhl-_DEKwv.Hul5cDS2cHX(N2Y%a;OleJWUPQLwCTC=DrTp3[Jpopd]O#MmgHJYsxwuuAOK-oG`b+o\
::3uwEN=)vb8N++dbJ_AdoErljQ|)X}?(b?%|nq{5{9rIBnJ*Rbk46E{Cg.B?+v4^wj[oY)1Qxfbs=5!L4rXP2GA7;bKv_g9pl7{|5+;{-^,nf0o^)II6fkn!Cz4lcEA\
::n54BN)?k~!Ke5CXxR$O06nHL.[kgBiR1]vFoy06hpjfH0WDV2]Z?2Q-w23$U%YW{5QuJiuB33LCH{kYvC`7o|.JO5l`.0S=T|40u1{9KbOE;CnlQwpMQJK1(e~2ti=\
::.(jZ+.IJ?Yy[)ZA6aba|(Xq7XX;jN|XfL,X6r%CQ0gJKS$TK9nYz|G^!-wOO(%|=V1u;Z4tbYFU^gM4Uzt84?Q4%_-Xf8YR{l|,vjZq+^258GwyNWZ(3tpX6?e*8TE\
::XIN+4L`mc906aK0|4c$2,pVsyZs%G.}qrIe(rV9]$Z#eTU+m[v+DTBbiK%0G{P0)rqTRL!q^(3|%n|JmbKv5pLpYh0El1)ha-xp+Rmr0,0-`x%LnWG?8zBOxpBn$oY\
::4qnK!D|))Erb=$?B;hwX9r!]Q`|w!J`jR`tlKTr;ZS[dk.[o`VVgCVFOO#0sS+|CHcd^MNCnhKPtzQ4QIRs`D;6lhlG}mp?|GhAd`G1fA#XUzo,+~sNM[~LVZIX^%W\
::w8k!Ns9ev[,?i2moM|3I;#FGu5|yOETh$+~2Z_g6DLKrY3B6vX-E;nofY+0u%oX*jFovNy{A1GSdy^7}1,`F=*IOn440hPIanV{-1O`kO|-D99=qhE2=t0Soz[C#C)\
::.5w%|};G8NK1q?]_LP)h7I1+2RJUt51m[eqG}(jDzh%e`tHmQhflT#Qa=R;9^(D|kQOIPnTZWn8[}s|2Ks^Hp9%tYSBWpqgeK-3$Mr9hl=0F345o|+|$vS;T^Y9nF{\
::Yv~]68]}PP4ykJ?f*,zzOvnssiUF^w8OyXwbO6iw0A|Z8VJGJt;BlS+ZT~segw4K)7^WJZ6Hj(yX-Q(cd?,=.a4CqOeG|BaZ6w2t}TuIEzOO~TVlGD^-sbJC0az(|a\
::?fUnGREL~jS,W-gR_uOgC||ucbk,d9Nt).$#e~fJcwVPdh1!$6ZgMv9GPhTc7Sf|xoTHKQtqrb#ZSPr~U#!u)kA~VU=0fk-^+;iN0NH~,6P)jxF^l_?p?!Cd?vn6`I\
::IBz`q8p{Nppw*Dc]eZ=|W,%[L%?aHpN-w,GVC[XGf4fao[Ch0^Q.qyfjoNRVp6nMvM9a9f+{!J3}V6,PVyS*N9YT,LaxN2s5)e#6[ZaHY#[]_}TFK36{mdqnEt9pLW\
::V`|w,DPmHVvv0oDG_4lAp8W(mFT*fM6SnT,cXCE_G$s(mwt+9|bJBUa%02Q!}Ax[~k`f9f4nSh,c7_k19muq}swfrPqdO9*%1iTjzN_dSfBBlWLmarG#{fgsX{2O45\
::?RNlmze-8?*gUoU~rE)iW2V_Yy5^bs.;eKoo^Bu$seu_jwnw55n,$2*~4SQU^WE0e#?M.fr]{54qcA=`YS7;EjND{+s9w^OcA72MQEhGS?YXRwTy)B|W~GioXL8m$z\
::+{kuKdLLrJIeB|.G,=4~$T|($)MvYeLLv?tqt=?l;=mcD%KuW$XFdteQN4VVdjyKV.MkjzZ?{eajo9?~8NOE_;9Ui,Nd#1%B4w?!48U]Zsh1.X1,I~SDdVOc%T3wr7\
::(a(Ys=TXH$*qXGqdKeqrtJ`5yb^!X*oL4[$,#YJ{3+mjr%[cs|MMUB(lfmvda7umFQTetFs*w~8?o!zn+MZpv^HCXr+jmX3g;~Ae?Bz]GR[QHuS2^ra^r4JPMRJ6*q\
::0*eGRbJ)mke$Wkz}(u$l,X6=U#y$krxf`C+_X#pbP8ia]vd{Ll5]V-Ro!_Ket5}]tA[MUf87VEaQ4RPgF+zdYb4qrSP6RN(TulB+35e!,v6?LERDL8W8XK#Ufzp094\
::qj!{DNbVSzoPn#!nsHaKP[3|$NBPYgTQG%t~wiBN5k~R_(n^$Bip0}[-=YH,,g{ZPp-fC,;h1H+(e%iqptWk)rIK2QXQBuuQDd]pD0hF`_S-tg4AtqpnK_Eh)[.bF7\
::fFJC,=NrY,]EsSZ2{u34VgN`zRl(lmB]3e(QgYpZ$RwVwU-+Ty(NW`0CAmMl{Sp|s3rSv#,hWpe3UTR=o{^=U(Fs*J^Zx(C8(4Hc]X*4A=m}+{ak-bnM42x%.z=01;\
::I8wHDAoD98L|9!)jeBpjf[hApP*_R#ewuVlFJ=`TsfJFD_a[=Hc0WfWod]7hs=K.cPwYZB}O1G*l0lWl|M6,eWIo27=;1=2r,=lp`6]vvsT3.~zGi0iiS4Q*J(u!Y`\
::wOTZa;r*ncUza^3vNVkKChBn7f=?{JpmEHfNV(M$*L.8{29jSo5NP.#CJe52MaC;[i-W;q*AzK]#XYZEpfG(+meBgawu1U-0F2XcsSm_|KUCxyfu!wT(Akz8b4|3IG\
::N67Z;S,o^oRV6M09yp^0lF4GoR[uM#K6C^pwFlmj5dK3f(kC^?q4f^08])J-Ox2`U9$-=ZmHV7Qniw;P,Jpk95BJDYuh0ECseX[fdB,e]TJuoypsgtXHtuFhEyk1=t\
::O.SYS%x_HiJH6}yIm4#`QbhNw)b|WrP4qi-|R-sH%0W5FW;U#`arNu{S)(FGUSMyt2$|Gw%6cJ0Tm2_)Ut[htefWqP.O=sFcIPkDu%iv-EBbd+Dke|wPzaCmTFU)8~\
::_-+H1p.*rj[g{+xQ1;DKs[_3K,8J[}t6($J%RM{XqRYInCqiHb#.$6G8x(q]_qW}{Z~?TZme}w|lHkvOvlUr=i*%0KF_Hi5kss-d|9dMAH_fA{j#,g6eOf)nG?qhhL\
::1,D`Rsy?6uJ6c6ZrQ;_{lF~1R*m%DW|fpfiVIHj]4lI,aB{sO_l5[9nCI|bqKROR;t6=bV3EGd7Qaz%j9w?+)*%CF1vjLG55CC)RKQX?2gJ_w)TIF6AMbSnJ$#U$7g\
::*~.MbA`8!n*p]n(,wMES|E(wJ*Rzc3*TiZ8KIek4#4WU;O,n#ULOZwOYQiNtJt9HMGA(sIZ_]Ygk.d`%HB1[i0yBFne]Q2vbq%cVad.[5$|r%XZHS`*U3GV6NHk[VK\
::Vz4HeY5T|akMbAcSeRGKIx3[lG}0s^|{TF_#a,TF!R~#B`xN3?J8!$hDE#G4$0i+CO(DnbHO~qlBKgjZabB60Gn$r5`(ya35ABxh[5=_h,L*_LS=hUiYrMTnjS9cUh\
::6ei,!$2*fbwuPyV^kkp0*56f7[Gk4A=KgTDq3t=m_bq^0va#xvrs*#{0Yu(AxG|WdM,~G5Tb,A(h7*bT5]YWs{;Kmz0v0t]N};95hSgL;MjbIjflPC{9)3OYH{Y0K8\
::K%5%iRfRCndK6[~U1ik,)n3[[FZr.oT9{|}}(^h%qE{zw9DB%0PM+)8Qdz.+JfLX-*zZ;7m1[9)rK+(~87Q,.Nt]QY]t;5Gg9dBCMV3E_swdiI1Un!(Q6W?A-$6qyJ\
::P+nepqzIA+e23_=#.6{z?cZ?UpCNUV(o)c)zw}iZ.iOwGt)wN8cuPfyOl*d5++v{#f_9*y.Tqg9(.IC1kvVqq`Cz5t8%Fv{zqoR-?l+cIs?jbSv{]HCN9.%~+ipGyw\
::zV14p+uLl,ErYGK2-c-ZM%b`mWM=~%x*6p0su$Jpb1-+E%`;*E2#+`*VE_x3^oqK6Pb+6dvDgB9l.E*QDNS#0ni!`DlIX8*4vjkgy;UBcmy5)+QoNR-2ydAmV5*X+U\
::RLSLLKi*Mn]c(eXc{SBwfj+mI=0tc=w!9+T~%M1x][Uk;|b5*cjLgsx~?!i8z07$FXvh)y_?Ur,vKNAJ9yDS$mUhO*Mc(jo9bOmxsS2qbbPC.L-kb0x]cT6hVj_9md\
::$wWJh#c1zW-)-puJ3;-8k|YK6VS%|)=sOJnIv;.8I=T-AS5Z-.yhQNbqrpPv,o8.VF(-qaQ5o0X#7H,hMQ9HH;TZ#5`!I6([t~|,Z+Aa*!U.y|Djt;z7.V)4ik`yO6\
::|B)_b(,N.*eg[Jw$yyE9(HQ*j~bwa*fZ?Zfq~?xN$z+p2kT#!VXqAIi=NIUY1;5^9m#;.xTMbPFu5e[Ss`g05.65afw-i3l!;rQ?gQAqv$5w3.Y_Cau,`)ZRCvA,+Q\
::UT-W-Kf~N7MS2,0z%aZ7,V%XkWG8oYvcFM..xWO-vr{9a7[JsX$+;3*A}e3;{_sD6Q%,JWxA]I`ml{X+*gE*A0I{yD,u3bx+wS8$D?IG5QVj7j2o4W)[bZ!1(|5byJ\
::2!!_-,a8VP(cKodNa6qb+M{j]7BSuJjIMxb]6e_2r,7e~yiO${Oz$yCotxmi4pYW6%w=s|CS]HaCSt!a2VT4Vj{te,%wNF$8jGN.}FbRclw]AMwscp1zOiS!{CFR4t\
::Q~Yh}uple7e%,cp+$(oVaYH*|K#CGnJc(dA5egZd#g)%Cip!^P3rn?wkHe7H(QuKJ5QOzOv7FDo$V0!E,cN7m~n,[Bu59aP^PYnaj4da8CC33eZ17`)JW`+I9B3p[W\
::RMdqx3VY|z53,uy(4.ic~5C$5aw;=JphRNK*D?jKO7+RxZ][vV37Rp;uu,PTlCLcam`AX47}9[([XvWd_KXZjVA5zjwwfkv3?=b5=Yr}cL{}YCkvEx5l4f=nJAuV4G\
::6EF%c_xi-O65bj.|UFdY+(.y-LyppiOVb[-)=cL3FHAn^R;fh.9}rDj^%Mv}V]my*PnnkUBwiy}tLhU4BD^,$Ouq}[F#yYA=gr+=!t-RP(Imx#vh_,kt,H#76}=b$)\
::cgvCbfqSy]zRi?bap38N+x3kcbfHh+8qJDd_rmwn#G2B7z3;]{k0ty0rpgYJu=dB{}5FZ]!_g;[SlLf^RGQNN[(^?Jz0P|Lyq55I*u}Q)qgm*Ew6NeL?6I(Diznow8\
::FAGMK7,$AhV_P!OVPT9gkMCn!3^!4v13.l*dNY8T?lv`Ic+(h!lDxjs=8FPzYPo2pqZ=Mlotn.]z76A_$?jfKp77[7$~)2i#)~#9q3%vKNPZ=82ZMtU2OtZechGmBa\
::q.=8a[Kbge2$lLMuou^G.B-=}R5Zb]KX|tXncr.pvbd]FXC|(c*RHPPpl#R6Tn0y7pcF}FW#GQj02$#GL|B4GxQmK.{B{NR=dz7$^GSXwozNSttQYKj-u7BNrrC8yu\
::Yu;HT}*fldmajN}QkN,.Nsd2KP7jMt}{ZxNahF#(}J6A({7Z1Lj[F#5ga[jyaHy)-El}v4)PTcO9e{{vjwi.t-g0OnFS^NwG_$hu.DCkb4k4ik$*i[fn3jx.8S,)}L\
::tj#G!QZ#;)QwKjX+j4!qNZ#{OM=^h5X0]!8Mv;b[`40fW;!,He4G9+tlX63$#cZXgwaVjhGCfrAD)j6si_)5urJaB[+39laxWgdHhI;W{ok_S-vlI53G0b;=ZI*lyT\
::$9t}oDhvFgekbUSLiVb1x.?b0kHa5Wr3Z)a?fyoEEgP)|d6,Y(,a05H.=ZPC[FSvflJm5U]Ja9XJTL4;(qZB).sNF_f0^tw~G#MXB5O2YL?B#A$_7nK1XkLge;r8%F\
::Y[Ecf-`ncKgW+wBkp4hF[R3H{o$dg,{y?rc$Z+h2J~TemKidz%hX4j.pU*$MCio)yLWo5`SRVpJ5{3bWiA3EaRtX$)6Xprtgx!.UL~ue$Fp}(iIMFyUIbk$WImIxt$\
::RV=+c=7T28);q)f)^$VST3k]UaH5-G3A_Z;r8cGraWVwLC{k0wPbK$YVy#8Ysxij?Q2S6?Pn=%oATbyZ#Qp7js2.{Id4[~9X?^u{}g+^H~9vClLogKI*sro9I?YM}Q\
::.|,FAL1V^WpU2av^hYd_gSWw!%oFQ~i}AE;K(ffCg3!ec_HMKFuG72ObAH57rLY7FQ7^*0bD]3?)%N-48d?.h?TJvbT;RKp;;(}K%?A[^a,\
".replace(/[\\:\s]/gm,""); r85='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz?.,;-_+=|{}[]()*^%$#!`~'.split('');
d85={}; for(var i=85;i--;) d85[r85[i]]=i; p85=[]; for(var i=5;i--;) p85[i]=Math.pow(85,i);
z='00000000'; pad=(res.length%5)||5; res+='~~~~~'.slice(pad); pad=10-2*pad; a=res.match(/.{1,5}/g);
for(var l=a.length;l--;){n=0;for(j=5;j--;)n+=d85[a[l].charAt(j)]*p85[4-j];a[l]=z.slice(n.toString(16).length)+n.toString(16)};
res85dec=(pad>0)?a.join('').slice(0,-pad):a.join('');WSH.Echo(' RES2BATCH: extracting '+fn);
xe=WSH.CreateObject('Microsoft.XMLDOM').createElement('bh');as=WSH.CreateObject('ADODB.Stream');as.Mode=3;as.Type=1;as.Open();
xe.dataType='bin.hex';xe.text=res85dec;as.Write(xe.nodeTypedValue);as.SaveToFile(fn,2);as.Close();
