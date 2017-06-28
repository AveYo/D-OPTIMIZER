goto="HERO" /* 
:"HERO"
@echo off &mode 99,9 &color 4F &title DOTA_TOGGLE_QUICKCAST_ALTERNATIVE_FOR_LAZY_DEVS_NOT_FIXING_WEEKS_OLD_GUI_BUG by AveYo ver. 322
echo. &echo  Please close DOTA before switching the QuickCast option, else it's not applied & call :set_dota
echo  Last used Steam profile: %STEAMDATA% 
set "quickcast=[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');"
set "abilities=[System.Windows.Forms.MessageBox]::Show('Enable QuickCast for abilities?','DOTA LAZY DEVS',4,32);"
set "items=[System.Windows.Forms.MessageBox]::Show('Enable QuickCast for items?','DOTA LAZY DEVS',4,32);"
for /f %%q in ('powershell -c "%quickcast%;%abilities%"') do set "qc_abilities=%%q"
for /f %%q in ('powershell -c "%quickcast%;%items%"') do set "qc_items=%%q"
cscript //E:JScript //nologo "%~f0" EnableQuickCast "%qc_abilities%" "%qc_items%" "%STEAMDATA%\570\remote\cfg\dotakeys_personal.lst"
call :end Done!
goto :eof
::----------------------------------------------------------------------------------------------------------------------------------
:"Batch_Utility_functions"
::----------------------------------------------------------------------------------------------------------------------------------
:set_dota outputs %STEAMPATH% %STEAMAPPS% %STEAMDATA% %DOTA%                       ||:i AveYo:" Override detection below if needed "
set "STEAMPATH=C:\Steam" &set "DOTA=C:\Games\steamapps\common\dota 2 beta"                    
if not exist "%STEAMPATH%\Steam.exe" call :reg_query "HKCU\SOFTWARE\Valve\Steam" "SteamPath" STEAMPATH
set "STEAMPATH=%STEAMPATH:/=\%" &if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry !
if exist "%DOTA%\game\dota\maps\dota.vpk" set "STEAMAPPS=%DOTA:\common\dota 2 beta=%" &goto :eof
for %%s in ("%STEAMPATH%") do set "STEAMPATH=%%~dpns" &set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%STEAMPATH%\SteamApps\libraryfolders.vdf" call :end ! Cannot find "%STEAMPATH%\SteamApps\libraryfolders.vdf"
for /f usebackq^ delims^=^"^ tokens^=4 %%s in (`findstr /v "%libfilter%" "%STEAMPATH%\SteamApps\libraryfolders.vdf"`) do (
if exist "%%s\steamapps\appmanifest_570.acf" if exist "%%s\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" set "libfs=%%s" )
set "STEAMAPPS=%STEAMPATH%\steamapps" &if defined libfs set "STEAMAPPS=%libfs:\\=\%\steamapps"
if not exist "%STEAMAPPS%\common\dota 2 beta\game\dota\maps\dota.vpk" call :end ! Cannot find "%STEAMAPPS%\common\dota 2 beta"
set "DOTA=%STEAMAPPS%\common\dota 2 beta" &cd /d "%STEAMAPPS%\common\dota 2 beta\game\dota"
call :reg_query "HKCU\SOFTWARE\Valve\Steam\ActiveProcess" "ActiveUser" STEAMUSER &set /a "STEAMID=STEAMUSER" >nul 2>nul
if defined STEAMID if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
if not defined STEAMID for /f delims^=^ eol^= %%b in ('dir /a:-d /b /o:d /t:w cache_*.soc 2^>nul') do set "usercache=%%~nb"
if not defined STEAMID if defined usercache set "STEAMDATA=%steampath%\userdata\%usercache:cache_=%"
if not exist "%STEAMDATA%\570\remote\cfg\dotakeys_personal.lst" call :end ! Cannot find your dotakeys definition file ! 
goto :eof
:reg_query %1:KeyName %2:ValueName %3:OutputVariable %4:other_options[example: "/t REG_DWORD"]
setlocal &for /f "skip=2 delims=" %%s in ('reg query "%~1" /v "%~2" /z 2^>nul') do set "rq=%%s" &call set "rv=%%rq:*)    =%%"
endlocal &call set "%~3=%rv%" &goto :eof                         ||:i AveYo - Usage:" call :reg_query "HKCU\MyKey" "MyValue" MyVar "
:end %1:Message
if "%~1"=="!" ( color c0 &echo  %* &timeout /t 16 &color &exit ) else echo  %* &timeout /t 8 &color &exit 
::----------------------------------------------------------------------------------------------------------------------------------
exit /b :End_of_Batch_engine_parsing - only JS sections below this line
::--------------------------------------------------------------------------------------------------------------------------------*/
                          //:i Switch syntax highlighter in your text editor from BAT to JS
//----------------------------------------------------------------------------------------------------------------------------------
// EnableQuickCast JS function - DOTA GUI option has been broken for weeks...
//----------------------------------------------------------------------------------------------------------------------------------
EnableQuickCast = function(qc_abilities, qc_items, fn) {
  var qc_abilities = (qc_abilities == 'No') ? 0 : 1, qc_items = (qc_items == 'No') ? 0 : 1; 
  var abilities = ['AbilityPrimary1','AbilityPrimary2','AbilityPrimary3','AbilitySecondary1','AbilitySecondary2','AbilityUltimate'];
  var items = ['Inventory1','Inventory2','Inventory3','Inventory4','Inventory5','Inventory6'];
  var file_src = path.normalize(fn), file_read = fs.readFileSync(file_src, DEF_ENCODING), vdf = ValveDataFormat();
  var file_parse = vdf.parse(file_read), dotakeys = file_parse.KeyBindings.Keys;
  for (i=0;i<6;i++) dotakeys[abilities[i]].Mode = qc_abilities; for (i=0;i<6;i++) dotakeys[items[i]].Mode = qc_items;
  fs.writeFileSync(fn, vdf.stringify(file_parse,true), DEF_ENCODING);
  console.log(' QuickCast for abilities? ' + qc_abilities + '\r\n' + ' QuickCast for items? ' + qc_items); 
}
//----------------------------------------------------------------------------------------------------------------------------------
// ValveDataFormat hybrid parser by AveYo, 2016                                                   VDF test on 20.1 MB items_game.txt
// loosely based on vdf-parser by Rossen Popov, 2014-2016                                                           node.js  cscript                 
// featuring auto-renaming duplicate keys, saving comments, grabing lame one-line "key" { "k" "v" }         parse:  1.329s   9.285s
// greatly improved cscript performance - it's not that bad overall but still lags behind node.js       stringify:  0.922s   3.439s    
//----------------------------------------------------------------------------------------------------------------------------------
function ValveDataFormat() {
  var jscript = (typeof ScriptEngine=='function' && ScriptEngine()=='JScript');
  var order = !jscript, dups = false, comments = false, newline = '\n', empty = (jscript) ? '' : undefined;
  return {
    parse: function(txt, flag) {
      var obj = {}, stack = [obj], expect_bracket = false, i = 0; comments = flag || false;
      if (/\r\n/.test(txt)) {newline = '\r\n'} else newline = '\n';
      var m, regex =/[^"\r\n]*(\/\/.*)|"([^"]*)"[ \t]+"([^"]*\\"[^"]*\\"[^"]*|[^"]*)"|"([^"]*)"|({)|(})/g;     
      while ((m = regex.exec(txt)) !== null) {
        //lf='\n'; console.log(' cmnt:',m[1],lf ,'key:',m[2],lf ,'val:',m[3],lf ,'add:',m[4],lf ,'open:',m[5],lf ,'close:',m[6],lf);
        if (comments && m[1] !== empty) {
          key = '\x10' + i++; stack[stack.length-1][key] = m[1];                                  // AveYo: optionally save comments
        } else if (m[4] !== empty) {          
          key = m[4]; if (expect_bracket) { console.log('VDF.parse: invalid bracket near '+ m[0]); return this.stringify(obj,true) }
          if (order && key == ''+~~key) {key = '\x11' + key;}  // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (stack[stack.length-1][key] === undefined) {
            stack[stack.length-1][key] = {};
          } else { 
            key += '\x12' + i++; stack[stack.length-1][key] = {}; dups = true; // AveYo: rename duplicate key obj with \x12 + i
          } 
          stack.push(stack[stack.length-1][key]); expect_bracket = true;       
        } else if (m[2] !== empty) {
          key = m[2]; if (expect_bracket) { console.log('VDF.parse: invalid bracket near '+ m[0]); return this.stringify(obj,true) }          
          if (order && key == ''+~~key) key = '\x11' + key;    // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (stack[stack.length-1][key] !== undefined) { key += '\x12' + i++; dups = true }// AveYo: rename duplicate k-v pair
          stack[stack.length-1][key] = m[3]||'';
        } else if (m[5] !== empty) { 
          expect_bracket = false; continue; // one level deeper 
        } else if (m[6] !== empty) { 
          stack.pop(); continue; // one level back 
        } 
      }
      if (stack.length != 1) { console.log('VDF.parse: open parentheses somewhere'); return this.stringify(obj,true) }
      return obj; // stack[0];
    },
    stringify: function(obj, pretty, nl) {
      if (typeof obj != 'object') { console.log('VDF.stringify: Input not an object'); return obj } 
      pretty = ( typeof pretty == 'boolean' && pretty) ? true : false; nl = nl || newline || '\n';
      return this.dump(obj, pretty, nl, 0);
    },
    dump: function(obj, pretty, nl, level) {
      if (typeof obj != 'object') { console.log('VDF.stringify: Key not string or object'); return obj} 
      var indent = '\t', buf = '', idt = '', i = 0;
      if (pretty) for (; i < level; i++) idt += indent;
      for (var key in obj) {
        if (typeof obj[key] == 'object')  {
          buf += idt +'"'+ this.redup(key) +'"'+ nl + idt +'{'+ nl + this.dump(obj[key], pretty, nl, level+1) + idt +'}'+ nl;
        } else {
          if (comments && key.indexOf('\x10') !== -1) { buf += idt + obj[key] + nl; continue } // AveYo: restore comments (optional)
          buf += idt +'"'+ this.redup(key) +'"'+ indent + indent +'"'+ obj[key] +'"'+ nl;
        }
      };
      return buf;
    },
    redup: function(key) {
      if (order && key.indexOf('\x11')!== -1) key = key.split('\x11')[1]; // AveYo: restore number keys in node.js 
      if (dups && key.indexOf('\x12') !== -1) key = key.split('\x12')[0]; // AveYo: restore duplicate key names 
      return key;
    },
    nr: function(key) {return (!jscript && key.indexOf('\x11') == -1) ? '\x11' + key : key} //check number key: vdf.nr('nr');
  }
} // End of ValveDataFormat
//----------------------------------------------------------------------------------------------------------------------------------
// JScript Engine by AveYo - can call specific functions as the first script argument    
// a subset of Hybrid Node.js / JScript Engine used in 'No-Bling DOTA mod builder.bat'                 
//----------------------------------------------------------------------------------------------------------------------------------
jscript = true, engine = 'JScript', w = WScript, argc = w.Arguments.Count(), argv=[], run='';
if (argc > 0) { run = w.Arguments(0); for (var i=1;i<argc;i++) argv.push( '"'+ w.Arguments(i).replace(/[\\\/]+/g,'\\\\') +'"') }
process={}; process.argv=[ScriptEngine(),w.ScriptFullName]; for (var i=0;i<argc;i++) process.argv[i+2] = w.Arguments(i);
path={}; path.join = function(f,n){return fso.BuildPath(f,n)}; path.normalize = function(f){return fso.GetAbsolutePathName(f)};  
path.basename = function(f){return fso.GetBaseName(f)}; path.dirname=function(f){return fso.GetParentFolderName(f)};path.sep='\\'; 
console={}; console.log=function(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u) { w.echo(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u) };
fs={}; fso=new ActiveXObject("Scripting.FileSystemObject"); ado=new ActiveXObject('ADODB.Stream'); DEF_ENCODING='Windows-1252'; 
FileExists = function(f) { return fso.FileExists(f) }; PathExists = function(f) { return fso.FolderExists(f) };
fs.readFileSync = function(fn, charset) {
  var data=''; ado.Mode=3; ado.Type=2; ado.Charset=charset || 'Windows-1252'; ado.Open(); ado.LoadFromFile(fn); 
  while (!ado.EOS) data += ado.ReadText(131072); ado.Close(); return data;
}
fs.writeFileSync = function(fn, data, encoding) {
  ado.Mode=3; ado.Type=2; ado.Charset=encoding || 'Windows-1252'; ado.Open(); 
  ado.WriteText(data); ado.SaveToFile(fn, 2); ado.Close(); return 0; 
}
//----------------------------------------------------------------------------------------------------------------------------------
// Auto-run: if first script argument is a function name - call it, passing the next arguments
//----------------------------------------------------------------------------------------------------------------------------------
if (run && !/[^A-Z0-9$_]/i.test(run)) new Function('if(typeof '+run+'=="function"){'+run+'('+argv+');}')(); 
