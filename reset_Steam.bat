@set @v=2019.03.21 /*
@echo off &color 4f &title Reset STEAM settings by AveYo v%@v:/*=%
echo.
echo      ---------------------------------------------------------------------
echo     :        Reset Steam configuration for the last logged on user        :
echo     :---------------------------------------------------------------------:
echo     :  If any issues, right-click script and click Run as administrator   :
echo     :                                                                     :
echo     :  WARNING! Steam must be closed so that config file can be modified  :
echo      ---------------------------------------------------------------------
echo.
:: Detect Steam path
call :set_steam
echo STEAMDATA: %STEAMDATA%
timeout /t 10
if not defined STEAMDATA echo ERROR! User profile not found, cannot reset Steam options & goto :done
:: Kill Steam
taskkill /im Steam.exe /t /f >nul 2>nul & timeout /t 1 >nul & del /f /q "%STEAMPATH%\.crash" >nul 2>nul & timeout /t 1 >nul
color 1f
:: Edit Steam config file
pushd "%STEAMDATA%\config" & copy /y localconfig.vdf localconfig.vdf.bak >nul
cscript //E:JScript //nologo "%~f0" reset_Steam "localconfig.vdf" "%STEAMID%"
:: Remove registry settings
for %%i in (BigPictureInForeground, DPIScaling, DWriteEnable, H264HWAccel, Rate) do (
 reg delete "HKCU\Software\Valve\Steam" /v %%i /f >nul 2>nul
) 
:done
:: [Optional] Restart Steam with fast options
set l1=-silent -console -forceservice -single_core -windowed -manuallyclearframes 0 -nodircheck -norepairfiles -noverifyfiles
set l2=-nocrashmonitor -nocrashdialog -vrdisable -nofriendsui -skipstreamingdrivers +"@AllowSkipGameUpdate 1 -
start "Steam" "%STEAMPATH%\Steam.exe" %l1% %l2%
:: Done!
pushd "%~dp0"
call :end Done
exit/b

::------------------------------------------------------------------------------------------------------------------------------
:: Utility functions
::------------------------------------------------------------------------------------------------------------------------------
:set_steam [OUTPUTS] STEAMPATH STEAMDATA STEAMID                                      AveYo : Override detection below if needed
set "STEAMPATH=D:\Steam"
if not exist "%STEAMPATH%\Steam.exe" call :reg_query STEAMPATH "HKCU\SOFTWARE\Valve\Steam" "SteamPath"
set "STEAMDATA=" & if defined STEAMPATH for %%# in ("%STEAMPATH%") do set "STEAMPATH=%%~dpnx#"
if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry
call :reg_query ACTIVEUSER "HKCU\SOFTWARE\Valve\Steam\ActiveProcess" "ActiveUser" & set/a "STEAMID=ACTIVEUSER" >nul 2>nul
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
if not defined STEAMDATA for /f "delims=" %%# in ('dir "%STEAMPATH%\userdata" /b/o:d/t:w/s 2^>nul') do set "ACTIVEUSER=%%~dp#"
if not defined STEAMDATA for /f "delims=\" %%# in ("%ACTIVEUSER:*\userdata\=%") do set "STEAMID=%%#"
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
exit/b
:reg_query [USAGE] call :reg_query ResultVar "HKCU\KeyName" "ValueName"
(for /f "skip=2 delims=" %%s in ('reg query "%~2" /v "%~3" /z 2^>nul') do set ".=%%s" & call set "%~1=%%.:*)    =%%") & exit/b
:end %1:Message[Delayed termination with status message - prefix with ! to signal failure]
echo. & if "%~1"=="!" ( color 0c & echo ERROR! %* & pause & exit ) else echo INFO: %* & pause & exit

rem End of batch code */

//------------------------------------------------------------------------------------------------------------------------------
// Utility JS functions - callable independently
//------------------------------------------------------------------------------------------------------------------------------
reset_Steam=function(fn, steamid){
  var keys=["streaming_v2", "Broadcast", "friends", "Software/Valve/Steam/Apps", "WebStorage", "system", "News", "Apps"];
  var file=path.normalize(fn), data=fs.readFileSync(file, DEF_ENCODING), vdf=ValveDataFormat(); parsed=vdf.parse(data);
//reset_key(parsed, "UserLocalConfigStore", true);
  cfg = parsed.UserLocalConfigStore;
  for (i in keys) reset_key(cfg, keys[i], false);
  fs.writeFileSync(fn, vdf.stringify(parsed,true), DEF_ENCODING);
};
function reset_key(obj, keypath, main){
  var out=obj, test=keypath.split("/"); 
  for (i=0; i < test.length; i++) {
    for (KeY in out) {
      if (out.hasOwnProperty(KeY) && (KeY+"").toLowerCase()==(test[i]+"").toLowerCase()) {out=out[KeY];/*w.echo("found "+KeY)*/}
    }
  }
  for (line in out) { 
    if (typeof out[line] == "string") {
      w.echo("-", test,"-", line); delete out[line];
    }
    else if (typeof out[line] !== "object" || main) continue;
    for (s in out[line]) {
      if (typeof out[line][s] !== "string") continue;
      w.echo("-", test, "-", line, "-", s); delete out[line][s];
    }
  }
  return out;
}
//------------------------------------------------------------------------------------------------------------------------------
// ValveDataFormat hybrid js parser by AveYo, 2016                                            VDF test on 20.1 MB items_game.txt
// loosely based on vdf-parser by Rossen Popov, 2014-2016                                                       node.js  cscript
// featuring auto-renaming duplicate keys, saving comments, grabbing lame one-line "key" { "k" "v" }     parse:  1.329s   9.285s
// greatly improved cscript performance - it"s not that bad overall but still lags behind node.js    stringify:  0.922s   3.439s
//------------------------------------------------------------------------------------------------------------------------------
function ValveDataFormat(){
  var jscript=(typeof ScriptEngine === "function" && ScriptEngine() === "JScript");
  if (!jscript) { var w={}; w.echo=function(s){console.log(s+"\r");}; } else { w=WScript; }
  var order=!jscript, dups=false, comments=false, newline="\n", empty=(jscript) ? "" : undefined;
  return {
    parse: function(txt, flag){
      var obj={}, stack=[obj], expect_bracket=false, i=0; comments=flag || false;
      if (/\r\n/.test(txt)) {newline="\r\n";} else newline="\n";
      var m, regex =/[^""\r\n]*(\/\/.*)|"([^""]*)"[ \t]+"(.*)"|"([^""]*)"|({)|(})/g;
      while ((m=regex.exec(txt)) !== null) {
        //lf="\n"; w.echo(" cmnt:"+m[1]+lf+" key:"+m[2]+lf+" val:"+m[3]+lf+" add:"+m[4]+lf+" open:"+m[5]+lf+" close:"+m[6]+lf);
        if (comments && m[1] !== empty) {
          i++;key="\x10"+i; stack[stack.length-1][key]=m[1];                                  // AveYo: optionally save comments
        } else if (m[4] !== empty) {
          key=m[4]; if (expect_bracket) { w.echo("VDF.parse: invalid bracket near "+m[0]); return this.stringify(obj,true); }
          if (order && key === ""+~~key) {key="\x11"+key;}          // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] === "undefined") {
            stack[stack.length-1][key] = {};
          } else {
            i++;key+= "\x12"+i; stack[stack.length-1][key] = {}; dups=true;         // AveYo: rename duplicate key obj with \x12+i
          }
          stack.push(stack[stack.length-1][key]); expect_bracket=true;
        } else if (m[2] !== empty) {
          key=m[2]; if (expect_bracket) { w.echo("VDF.parse: invalid bracket near "+m[0]); return this.stringify(obj,true); }
          if (order && key === ""+~~key) key="\x11"+key;            // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] !== "undefined") {i++; key+="\x12"+i; dups=true; }// AveYo: rename duplicate k-v
          stack[stack.length-1][key]=m[3]||"";
        } else if (m[5] !== empty) {
          expect_bracket=false; continue; // one level deeper
        } else if (m[6] !== empty) {
          stack.pop(); continue; // one level back
        }
      }
      if (stack.length !== 1) { w.echo("VDF.parse: open parentheses somewhere"); return this.stringify(obj,true); }
      return obj; // stack[0];
    },
    stringify: function(obj, pretty, nl){
      if (typeof obj !== "object") { w.echo("VDF.stringify: Input not an object"); return obj; }
      pretty=( typeof pretty === "boolean" && pretty) ? true : false; nl=nl || newline || "\n";
      return this.dump(obj, pretty, nl, 0);
    },
    dump: function(obj, pretty, nl, level){
      if (typeof obj !== "object") { w.echo("VDF.stringify: Key not string or object"); return obj; }
      var indent="\t", buf="", idt="", i=0;
      if (pretty) { for (i=0; i < level; i++) idt+= indent; }
      for (var key in obj) {
        if (typeof obj[key] === "object")  {
          buf+= idt+'"'+this.redup(key)+'"'+nl+idt+'{'+nl+this.dump(obj[key], pretty, nl, level+1)+idt+'}'+nl;
        } else {
          if (comments && key.indexOf("\x10") !== -1) { buf+= idt+obj[key]+nl; continue; } // AveYo: restore comments (optional)
          buf+= idt+'"'+this.redup(key)+'"'+indent+indent+'"'+obj[key]+'"'+nl;
        }
      }
      return buf;
    },
    redup: function(key){
      if (order && (key+"").indexOf("\x11") !== -1) key=key.split("\x11")[1];           // AveYo: restore number keys in node.js
      if (dups && (key+"").indexOf("\x12") !== -1) key=key.split("\x12")[0];               // AveYo: restore duplicate key names
      return key;
    },
    nr: function(key){return (!jscript && (key+"").indexOf("\x11") === -1) ? "\x11"+key : key;}  // AveYo: check nr: vdf.nr("nr")
  };
} // End of ValveDataFormat

//------------------------------------------------------------------------------------------------------------------------------
// Hybrid Node.js / JScript Engine by AveYo - can call specific functions as the first script argument
//------------------------------------------------------------------------------------------------------------------------------
if (typeof ScriptEngine === "function" && ScriptEngine() === "JScript") {
  // start of JScript specific code
  jscript=true;engine="JScript";w=WScript;launcher=new ActiveXObject("WScript.Shell"); argc=w.Arguments.Count();argv=[]; run="";
  if (argc > 0){run=w.Arguments(0); for (var i=1; i < argc; i++) argv.push( '"'+w.Arguments(i).replace(/[\\\/]+/g,"\\\\")+'"');}
  process={};process.argv=[ScriptEngine(),w.ScriptFullName];for (var j=0;j<argc;j++) process.argv[j+2]=w.Arguments(j);RN="\r\n";
  path={}; path.join=function(f,n){return fso.BuildPath(f,n);}; path.normalize=function(f){return fso.GetAbsolutePathName(f);};
  path.basename=function(f){return fso.GetFileName(f);};path.dirname=function(f){return fso.GetParentFolderName(f);};
  fs={};fso=new ActiveXObject("Scripting.FileSystemObject"); ado=new ActiveXObject("ADODB.Stream"); DEF_ENCODING="Windows-1252";
  FileExists=function(f){ return fso.FileExists(f); }; PathExists=function(f){ return fso.FolderExists(f); }; path.sep="\\";
  MakeDir=function(fn){
    if (fso.FolderExists(fn)) return; var pfn=fso.GetAbsolutePathName(fn), d=pfn.match(/[^\\\/]+/g), p="";
    for (var i=0,n=d.length; i<n; i++) { p+= d[i]+"\\"; if (!fso.FolderExists(p)) fso.CreateFolder(p); }
  };
  fs.readFileSync=function(fn, charset){
    var data=""; ado.Mode=3; ado.Type=2; ado.Charset=charset || "Windows-1252"; ado.Open(); ado.LoadFromFile(fn);
    while (!ado.EOS) data+= ado.ReadText(131072); ado.Close(); return data;
  };
  fs.writeFileSync=function(fn, data, encoding){
    ado.Mode=3; ado.Type=2; ado.Charset=encoding || "Windows-1252"; ado.Open();
    ado.WriteText(data); ado.SaveToFile(fn, 2); ado.Close(); return 0;
  };
  // end of JScript specific code
} else {
  // start of Node.js specific code
  jscript=false;engine="Node.js";w={}; argc=process.argv.length; argv=[]; run=""; p=process.argv; w.quit=process.exit;RN="\r\n";
  if (argc > 2) { run=p[2]; for (n=3;n<argc;n++) argv.push('"'+p[n].replace(/[\\\/]+/g,"\\\\")+'"'); }
  path=require("path"); fs=require("fs"); DEF_ENCODING="utf-8"; w.echo=function(s){console.log(s+"\r");};
  FileExists=function(f){ try{ return fs.statSync(f).isFile(); }catch(e) { if (e.code === "ENOENT") return false; } };
  PathExists=function(f){ try{ return fs.statSync(f).isDirectory(); }catch(e) { if (e.code === "ENOENT") return false; } };
  MakeDir=function(f){ try{ fs.mkdirSync(f); }catch(e) { if (e.code === "ENOENT") { MakeDir(path.dirname(f)); MakeDir(f); } } };
  // end of Node.js specific code
}
function timer(hint){
  var s=new Date(); return { end:function(){ var e=new Date(), t=(e.getTime()-s.getTime())/1000; w.echo(hint+": "+t+"s");}};
}
// If run without parameters the .js file must have been double-clicked in shell, so try to launch the correct .bat file instead
if (jscript&&run===""&&FileExists(w.ScriptFullName.slice(0, -2)+"bat")) launcher.Run('"'+w.ScriptFullName.slice(0, -2)+"bat\"");
//------------------------------------------------------------------------------------------------------------------------------
// Auto-run JS: if first script argument is a function name - call it, passing the next arguments
//------------------------------------------------------------------------------------------------------------------------------
if (run && !(/[^A-Z0-9$_]/i.test(run))) new Function("if(typeof "+run+" === \"function\") {"+run+"("+argv+");}")();
//
