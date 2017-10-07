:: for non-windows, save https://pastebin.com/saYGskE6 in \steamapps\common\dota 2 beta\game\dota\scripts\vscripts\core\coreinit.lua
@echo off &setlocal &title Dota show behavior on startup and after match by AveYo v6 with dynamic grade color [set it and forget it]
call :set_dota
set "P=%DOTA%\game\dota\scripts\vscripts\core" &set "F=coreinit.lua"
mkdir "%P%" >nul 2>nul &cd /d "%P%" 

 > %F% echo/-- this file: \steamapps\common\dota 2 beta\game\dota\scripts\vscripts\core\coreinit.lua
>> %F% echo/-- Dota show behavior on startup and after match by AveYo v6 with dynamic grade color [set it and forget it] 
>> %F% echo/
>> %F% echo/local NoopBS = function() end
>> %F% echo/local SaveBS = function()
>> %F% echo/  if SendToServerConsole then -- only execute locally
>> %F% echo/    SendToServerConsole( 'blink _fov 0 0;blink ^| grep %%;execute_command_every_frame "";' ) -- stop any loop
>> %F% echo/    SendToServerConsole( 'developer 1; dota_game_account_debug ^| cl_class; developer 0;' ) -- save score into cl_class
>> %F% echo/    SendToServerConsole( 'blink execute_command_every_frame 2 1 3;' ) -- chain-schedule ShowBS after 2/2=1 seconds
>> %F% echo/  end
>> %F% echo/end
>> %F% echo/local ShowBS = function() 
>> %F% echo/  if SendToServerConsole then -- only execute locally
>> %F% echo/    SendToServerConsole( 'blink _fov 0 0;blink ^| grep %%;execute_command_every_frame "";' ) -- stop any loop
>> %F% echo/    local behavior_score = Convars:GetStr( 'cl_class' ):gsub('\n','') -- import i/o cvar cl_class 
>> %F% echo/    local grade = behavior_score:gsub('behavior_score: ',''):gsub('+',''):gsub('-','') -- substring grade
>> %F% echo/    local flower = { Normal=true, A=true, B=true, C=true } -- Roses are Red, Violetes are Blue
>> %F% echo/    local ass = 1 -- set flag to use red message by default
>> %F% echo/    if flower[grade] then ass = 0 end -- set flag to use blue message if behavior_score is flower grade
>> %F% echo/    print( behavior_score ) -- print behavior_score into Console
>> %F% echo/    Convars:SetStr('cl_class','default') -- reset i/o cvar cl_class [choice has no ill-effects]
>> %F% echo/    SendToServerConsole( 'top_bar_message "' .. behavior_score .. '" ' .. ass .. ';' ) -- show top bar gui message
>> %F% echo/    SendToServerConsole( 'blink execute_command_every_frame 10 1 4;' ) -- chain-schedule HideBS after 10/2=5 seconds
>> %F% echo/  end
>> %F% echo/end
>> %F% echo/local HideBS = function()
>> %F% echo/  if SendToServerConsole then -- only execute locally
>> %F% echo/    SendToServerConsole( 'blink _fov 0 0;blink ^| grep %%;execute_command_every_frame "";' ) -- stop any loop
>> %F% echo/    SendToServerConsole( 'top_bar_message "";' ) -- hide top message
>> %F% echo/    SendToServerConsole( 'log_flags Console -DoNotEcho ^| grep %%' ) -- resume Console spew
>> %F% echo/  end
>> %F% echo/end
>> %F% echo/
>> %F% echo/if SendToServerConsole then -- only execute locally
>> %F% echo/  SendToServerConsole( 'log_flags Console +DoNotEcho ^| grep %%' ) -- disable Console spew
>> %F% echo/  Convars:RegisterCommand( '4.000000', HideBS, 'hidebs', 0 ) -- HideBS function 4 [end-schedule]
>> %F% echo/  Convars:RegisterCommand( '3.000000', ShowBS, 'showbs', 0 ) -- ShowBS function 3 [chain-schedule HideBS]
>> %F% echo/  Convars:RegisterCommand( '2.000000', SaveBS, 'savebs', 0 ) -- SaveBS function 2 [chain-schedule ShowBS]
>> %F% echo/  Convars:RegisterCommand( '1.000000', NoopBS, 'noopbs', 0 ) -- NoopBS function 1 [runs half the interval]
>> %F% echo/  Convars:RegisterCommand( '0.000000', NoopBS, 'noopbs', 0 ) -- NoopBS function 0 [runs if blink cmd fails]
>> %F% echo/  SendToServerConsole( 'blink execute_command_every_frame 12 1 2;' ) -- [coreinit-schedule SaveBS after 12/2=6 seconds]
>> %F% echo/end
>> %F% echo/
>> %F% echo/-- blink [cvar] [interval] [val1] [val2] simply toggles a cvar between 2 numeric values each interval/2 seconds
>> %F% echo/-- here is set to toggle execute_command_every_frame between two numeric-like aliases so both blink and execute can use
>> %F% echo/-- of which the first alias [1 = 1.000000] is empty string, efectively doing nothing half the interval [no perf penalty]
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