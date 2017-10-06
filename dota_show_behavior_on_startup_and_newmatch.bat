:: for non-windows, save https://pastebin.com/saYGskE6 in \steamapps\common\dota 2 beta\game\dota\scripts\vscripts\core\coreinit.lua
@echo off &setlocal &title Dota show behavior on startup and newmatch by AveYo v5 final [set it and forget it]
call :set_dota
set "P=%DOTA%\game\dota\scripts\vscripts\core" &set "F=coreinit.lua"
mkdir "%P%" >nul 2>nul &cd /d "%P%" 

> %F% echo/-- this file: \steamapps\common\dota 2 beta\game\dota\scripts\vscripts\core\coreinit.lua
>> %F% echo/-- Dota show behavior on startup and newmatch by AveYo v5 final [set it and forget it] 
>> %F% echo/
>> %F% echo/if (Convars:GetStr( 'cl_class' ) == 'gaben' and SendToServerConsole) then -- not executing in matchmaking
>> %F% echo/  local Noop = function() end
>> %F% echo/  local SaveBS = function()
>> %F% echo/    SendToServerConsole( 'blink _fov 0 0; blink ^| grep %%; execute_command_every_frame "";' ) -- stoploop I
>> %F% echo/    SendToServerConsole( 'developer 1; dota_game_account_debug ^| cl_class; developer 0;' ) -- save score into cl_class
>> %F% echo/    SendToServerConsole( 'blink execute_command_every_frame 2 1 3;' ) -- schedule ShowBS after 2/2=1 seconds
>> %F% echo/  end
>> %F% echo/  local ShowBS = function() 
>> %F% echo/    local behavior_score = Convars:GetStr( 'cl_class' ):gsub('\n','') -- import cvar (cl_class is a suitale choice) 
>> %F% echo/    SendToServerConsole( 'blink _fov 0 0; blink ^| grep %%; execute_command_every_frame "";' ) -- stoploop II
>> %F% echo/    SendToServerConsole( 'top_bar_message "' .. behavior_score .. '" 0;' ) -- show top bar gui message
>> %F% echo/    SendToServerConsole( 'blink execute_command_every_frame 10 1 4;' ) -- schedule HideBS after 10/2=5 seconds
>> %F% echo/    print( behavior_score ) -- print score into Console
>> %F% echo/  end
>> %F% echo/  local HideBS = function()
>> %F% echo/    SendToServerConsole( 'blink _fov 0 0; blink ^| grep %%; execute_command_every_frame "";' ) -- stoploop III
>> %F% echo/    SendToServerConsole( 'top_bar_message 0;' ) -- hide top message
>> %F% echo/    Convars:SetStr('cl_class','gaben') -- make sure next coreinit triggers
>> %F% echo/  end
>> %F% echo/  Convars:RegisterCommand( '0.000000', Noop,   'noop',   0 ) -- do nothing in case of blink 'unknown cmd' spew I
>> %F% echo/  Convars:RegisterCommand( '1.000000', Noop,   'noop',   0 ) -- do nothing empty function I
>> %F% echo/  Convars:RegisterCommand( '2.000000', SaveBS, 'savebs', 0 ) -- scheduled savebs function II
>> %F% echo/  Convars:RegisterCommand( '3.000000', ShowBS, 'showbs', 0 ) -- scheduled showbs function III
>> %F% echo/  Convars:RegisterCommand( '4.000000', HideBS, 'hidebs', 0 ) -- scheduled hidebs function IV 
>> %F% echo/  SendToServerConsole( 'blink execute_command_every_frame 12 1 2;' ) -- start SaveBS after 12/2=6 seconds since coreinit
>> %F% echo/else
>> %F% echo/  Convars:SetStr('cl_class','gaben') -- vscript is loaded twice on startup / local game, this prevents double execution 
>> %F% echo/  SendToConsole( 'alias 0.000000 "" ^| grep %%;' ) -- do nothing in case of blink 'unknown cmd' spew II
>> %F% echo/end
>> %F% echo/
>> %F% echo/-- blink [cvar] [interval] [val1] [val2] simply toggles a cvar between 2 numeric values each interval/2 seconds
>> %F% echo/-- here is set to toggle execute_command_every_frame between two numeric-like aliases so both blink and execute can use
>> %F% echo/-- of which the first alias (1 = 1.000000) is empty string, efectively doing nothing half the interval (no perf penalty)
>> %F% echo/-- and when it's time to run the second alias, stoploop is executed, and schedule stops, or is chain-scheduled further 

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