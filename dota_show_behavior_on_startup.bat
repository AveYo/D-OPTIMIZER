:: for non-windows, save https://pastebin.com/saYGskE6 in \steamapps\common\dota 2 beta\game\dota\scripts\vscripts\core\coreinit.lua
@echo off &setlocal &title Dota show behavior on startup by AveYo v3 [set it and forget it]
call :set_dota
set "P=%DOTA%\game\dota\scripts\vscripts\core" &set "F=coreinit.lua"
mkdir "%P%" >nul 2>nul &cd /d "%P%" 
echo/if Convars:GetFloat( 'matchmakingbs' ) == nil then > %F%
echo/  Convars:RegisterCommand('showbs', function() >> %F% 
echo/    SendToServerConsole( 'top_bar_message "' .. Convars:GetStr( 'ip' ):gsub('\n','') .. '" 0;ip "";' ) -- lean and mean >> %F%
echo/  end, 'gabenisanass', 2147483649) >> %F%
echo/  SendToServerConsole( 'alias getbs "developer 1; dota_game_account_debug | ip; developer 0;"' ) -- get behavior_score >> %F%
echo/  SendToServerConsole( 'alias #stop "alias 0;blink _fov 0 0;blink | grep %%;execute_command_every_frame 0;"' ) -- loop >> %F%
echo/  SendToServerConsole( 'alias 1.000000 "";' ) -- noop >> %F%
echo/  SendToServerConsole( 'alias 2.000000 "#stop; getbs; blink execute_command_every_frame 4 1 3";' ) -- delay get-show >> %F%
echo/  SendToServerConsole( 'alias 3.000000 "#stop; showbs; blink execute_command_every_frame 10 1 4";' ) -- 10/2 how long >> %F%
echo/  SendToServerConsole( 'alias 4.000000 "#stop; top_bar_message 0;"' ) -- done >> %F%
echo/  SendToServerConsole( 'blink execute_command_every_frame 12 1 2;' ) -- 12/2 is the main delay (+2 from short delay) >> %F%
echo/  Convars:RegisterConvar( 'matchmakingbs', '1', 'gabenisanass', 2147483649 ) >> %F%
echo/end >> %F%
call :end  :Done!
goto :eof

:set_dota outputs %STEAMPATH% %STEAMAPPS% %STEAMDATA% %DOTA%                       ||:i AveYo:" Override detection below if needed "
set "STEAMPATH=C:\Steam" &set "DOTA=C:\Games\steamapps\common\dota 2 beta"
if not exist "%STEAMPATH%\Steam.exe" call :reg_query "HKCU\SOFTWARE\Valve\Steam" "SteamPath" STEAMPATH
if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry
if exist "%DOTA%\game\dota\maps\dota.vpk" set "STEAMAPPS=%DOTA:\common\dota 2 beta=%" &goto :eof
for %%s in ("%STEAMPATH%") do set "STEAMPATH=%%~dpns" &set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%STEAMPATH%\SteamApps\libraryfolders.vdf" call :end ! Cannot find "%STEAMPATH%\SteamApps\libraryfolders.vdf"
for /f usebackq^ delims^=^"^ tokens^=4 %%s in (`findstr /v "%libfilter%" "%STEAMPATH%\SteamApps\libraryfolders.vdf"`) do (
if exist "%%s\steamapps\appmanifest_570.acf" if exist "%%s\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" set "libfs=%%s" )
set "STEAMAPPS=%STEAMPATH%\steamapps" &if defined libfs set "STEAMAPPS=%libfs:\\=\%\steamapps"
if not exist "%STEAMAPPS%\common\dota 2 beta\game\dota\maps\dota.vpk" call :end ! Cannot find "%STEAMAPPS%\common\dota 2 beta"
set "DOTA=%STEAMAPPS%\common\dota 2 beta" &goto :eof
:reg_query %1:KeyName %2:ValueName %3:OutputVariable %4:other_options[example: "/t REG_DWORD"]
setlocal &for /f "skip=2 delims=" %%s in ('reg query "%~1" /v "%~2" /z 2^>nul') do set "rq=%%s" &call set "rv=%%rq:*)    =%%"
endlocal &call set "%~3=%rv%" &goto :eof                         ||:i AveYo - Usage:" call :reg_query "HKCU\MyKey" "MyValue" MyVar "
:end %1:Message
if "%~1"=="!" ( color c0 &echo !ERROR%* &timeout /t 16 &color &exit ) else echo  %* &timeout /t 8 &color &exit