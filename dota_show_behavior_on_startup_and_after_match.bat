:: for non-windows, save https://pastebin.com/saYGskE6 in \steamapps\common\dota 2 beta\game\dota\scripts\vscripts\core\coreinit.lua
@echo off &setlocal &title Dota show behavior on startup and after match by AveYo v9 final with dynamic grade color [just run once]
call :set_dota
set "P=%DOTA%\game\dota\scripts\vscripts\core" &set "F=coreinit.lua"
set "enable=[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');"
set "vscript=[System.Windows.Forms.MessageBox]::Show('Show behavior on startup and after match?','AveYo DOTA vscript',4,32);"
for /f %%q in ('powershell -c "%enable%;%vscript%"') do set "result=%%q"
if /i "%result%"=="No" ( call :remove_vscript ) else call :install_vscript
call :end :Done!
exit/b

:remove_vscript
echo  REMOVING %P%\%F%
del /f/q "%P%\%F%" >nul 2>nul &exit/b

:install_vscript
echo  INSTALLING %P%\%F%
mkdir "%P%" >nul 2>nul &cd /d "%P%" 
 > %F% echo/-- this file: \steamapps\common\dota 2 beta\game\dota\scripts\vscripts\core\coreinit.lua
>> %F% echo/-- Dota show behavior on startup and after match by AveYo v8 with dynamic grade color [set it and forget it]
>> %F% echo/-- v9 final : Reliable, native VScript scheduler!
>> %F% echo/
>> %F% echo/local ToConsole = function(s) if SendToServerConsole then SendToServerConsole(s) else SendToConsole(s) end end
>> %F% echo/local HideBehaviorScore = function(t) ToConsole( 'top_bar_message "" ' .. t ) Convars:SetStr('cl_class','default') end
>> %F% echo/local ShowBehaviorScore = function(t)
>> %F% echo/  local behavior_score = Convars:GetStr( 'cl_class' ):gsub('\n','') -- import i/o cvar cl_class 
>> %F% echo/  local grade = behavior_score:gsub('behavior_score: ',''):gsub('+',''):gsub('-','') -- substring grade
>> %F% echo/  local flower = { Normal=true, A=true, B=true, C=true } -- Roses are Red, Violetes are Blue
>> %F% echo/  local ass = 1 -- set flag to use red message by default
>> %F% echo/  if flower[grade] then ass = 0 end -- set flag to use blue message if behavior_score is flower grade
>> %F% echo/  print( behavior_score ) -- print behavior_score into Console
>> %F% echo/  local VScheduler = EntIndexToHScript(0) -- if there are entities loaded, than vscheduler is available
>> %F% echo/  if VScheduler then 
>> %F% echo/    ToConsole( 'top_bar_message "' .. behavior_score .. '" ' .. ass .. ';' ) -- show top bar gui message
>> %F% echo/    VScheduler:SetContextThink( "GabenPlz", function() HideBehaviorScore(ass) end, 4 ) -- hide after 4 seconds
>> %F% echo/  end  
>> %F% echo/end
>> %F% echo/
>> %F% echo/if SendToServerConsole then -- local client only [ VScripts loads two vm's, one for sv, one for cl ]
>> %F% echo/  ToConsole( 'developer 1; dota_game_account_client_debug ^| cl_class; developer 0;' ) -- save score into cl_class
>> %F% echo/  ListenToGameEvent("player_connect_full", ShowBehaviorScore, nil) -- show message after each new map
>> %F% echo/end
>> %F% echo/
exit/b

:set_dota outputs %STEAMPATH% %STEAMAPPS% %DOTA%                                   ||:i AveYo:" Override detection below if needed "
set "STEAMPATH=D:\Steam" &set "DOTA=D:\Games\steamapps\common\dota 2 beta"
if not exist "%STEAMPATH%\Steam.exe" call :reg_query "HKCU\SOFTWARE\Valve\Steam" "SteamPath" STEAMPATH
set "STEAMDATA=" &if defined STEAMPATH for %%# in ("%STEAMPATH:/=\%") do set "STEAMPATH=%%~dpnx#"     ||:i  / pathsep on Windows lul
if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry
if exist "%DOTA%\game\dota\maps\dota.vpk" set "STEAMAPPS=%DOTA:\common\dota 2 beta=%" &exit/b
set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%STEAMPATH%\SteamApps\libraryfolders.vdf" call :end ! Cannot find "%STEAMPATH%\SteamApps\libraryfolders.vdf"
for /f usebackq^ delims^=^"^ tokens^=4 %%s in (`findstr /v "%libfilter%" "%STEAMPATH%\SteamApps\libraryfolders.vdf"`) do (
 if exist "%%s\steamapps\appmanifest_570.acf" if exist "%%s\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" set "libfs=%%s" )
set "STEAMAPPS=%STEAMPATH%\steamapps" &if defined libfs set "STEAMAPPS=%libfs:\\=\%\steamapps"
if not exist "%STEAMAPPS%\common\dota 2 beta\game\dota\maps\dota.vpk" call :end ! Cannot find "%STEAMAPPS%\common\dota 2 beta"
set "DOTA=%STEAMAPPS%\common\dota 2 beta" &exit/b
:reg_query %1:KeyName %2:ValueName %3:OutputVariable %4:other_options[example: "/t REG_DWORD"]
setlocal &for /f "skip=2 delims=" %%s in ('reg query "%~1" /v "%~2" /z 2^>nul') do set "rq=%%s" &call set "rv=%%rq:*)    =%%"
endlocal &call set "%~3=%rv%" &exit/b                            ||:i AveYo - Usage:" call :reg_query "HKCU\MyKey" "MyValue" MyVar "
:end %1:Message
if "%~1"=="!" ( color c0 &echo !ERROR%* &timeout /t 16 &color &exit ) else echo  %* &timeout /t 8 &color &exit
::
