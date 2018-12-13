@echo off &color 0B &mode 112,16 &title Dota 2 - reset local and remote Cloud settings by AveYo, v3.1
rem v3.1 changes: don't reset herobuilds.cfg, settings hotkeys, control groups and user mutes; improved detection, print steamid
echo. & echo. & echo.
echo     INSTRUCTIONS:
echo  1. Make sure you launch the game at least once with the account having troubles,
echo     else this script will use the last logged on account
echo  2. Run this script - you might need to right-click it and Run as Administrator
echo  3. After launching Dota 2, chose "Upload" at the Cloud Sync Conflict prompt then "Play Game"
echo  4. Adjust your settings, then restart Dota 2. Did it stick? Repeat procedure with Cloud On and Off
echo. 
setlocal &call :set_steam_dota
if not defined STEAMDATA echo Error! Cannot find Dota 2 user profile &pause &exit /b
echo  STEAMID = %STEAMID% & echo. & echo.
taskkill /t /f /im dota2.exe >nul 2>nul
taskkill /t /f /im steam.exe >nul 2>nul
takeown /f "%STEAMDATA%" /r /d y >nul 2>nul
icacls "%STEAMDATA%" /reset /t /q >nul 2>nul
attrib -r "%STEAMDATA%" /s /d >nul 2>nul
:: dota 2
del /f /q "%STEAMDATA%\570\remotecache.vdf" >nul 2>nul
copy /y "%STEAMDATA%\570\remote\cfg\dotakeys_personal.lst" "%DOTA%\dota\cfg" >nul 2>nul
cd/d "%STEAMDATA%\570"
set "filter=.png .jpg control_groups.txt herobuilds.cfg voice_ban.dt"
for /f "usebackq tokens=*" %%a in (`dir /a:-D /b /s ^| findstr /l /i /v "%filter%"`) do cd.>"%%a"
copy /y "%DOTA%\dota\cfg\dotakeys_personal.lst" "%STEAMDATA%\570\remote\cfg\dotakeys_personal.lst" >nul 2>nul
cd/d "%DOTA%\dota\cfg"
for /f "usebackq tokens=*" %%a in (`dir /a:-D /b ^| findstr /l /i /v ".cfg .lst"`) do del /f/q "%%a" >nul 2>nul
ren autoexec.cfg saved_autoexec.cfg >nul 2>nul
pause
set ukd="%DOTA%\dota\cfg\user_keys_default.vcfg"
 > %ukd% echo/"config"
>> %ukd% echo/{
>> %ukd% echo/	"bindings"
>> %ukd% echo/	{
>> %ukd% echo/		"\" "toggleconsole"
>> %ukd% echo/	}
>> %ukd% echo/}
del /f/s/q "%DOTA%\dota\core" >nul 2>nul &rmdir /s/q "%DOTA%\dota\core" >nul 2>nul
del /f/s/q "%DOTA%\core\cfg\*.json" >nul 2>nul
del /f/s/q "%DOTA%\core\cfg\*.bin" >nul 2>nul
start "w" steam://rungameid/570
timeout /t 25 >nul
echo  DONE! You can close this window now
pause >nul
endlocal &exit /b
::
rem Utils
:set_steam_dota outputs %STEAMPATH% %STEAMID% %STEAMDATA% %STEAMAPPS% %DOTA% %CONTENT%
set "STEAMPATH=D:\Steam" &set "DOTA=D:\Games\steamapps\common\dota 2 beta\game"      &rem AveYo:" Override detection if needed "
if not exist "%STEAMPATH%\Steam.exe" call :reg_query STEAMPATH "HKCU\SOFTWARE\Valve\Steam" "SteamPath"
set "STEAMDATA=" & if defined STEAMPATH for %%# in ("%STEAMPATH%") do set "STEAMPATH=%%~dpnx#"
if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry
call :reg_query ACTIVEUSER "HKCU\SOFTWARE\Valve\Steam\ActiveProcess" "ActiveUser" & set/a "STEAMID=ACTIVEUSER" >nul 2>nul
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
if not defined STEAMDATA for /f "delims=" %%# in ('dir "%STEAMPATH%\userdata" /b/o:d/t:w/s 2^>nul') do set "ACTIVEUSER=%%~dp#"
if not defined STEAMDATA for /f "delims=\" %%# in ("%ACTIVEUSER:*\userdata\=%") do set "STEAMID=%%#"
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
if exist "%DOTA%\dota\maps\dota.vpk" set "STEAMAPPS=%DOTA:\common\dota 2 beta=%" & exit/b
set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%STEAMPATH%\SteamApps\libraryfolders.vdf" call :end ! Cannot find "%STEAMPATH%\SteamApps\libraryfolders.vdf"
for /f usebackq^ delims^=^"^ tokens^=4 %%s in (`findstr /v "%libfilter%" "%STEAMPATH%\SteamApps\libraryfolders.vdf"`) do (
if exist "%%s\steamapps\appmanifest_570.acf" if exist "%%s\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" set "libfs=%%s")
set "STEAMAPPS=%STEAMPATH%\steamapps" & if defined libfs set "STEAMAPPS=%libfs:\\=\%\steamapps"
if not exist "%STEAMAPPS%\common\dota 2 beta\game\dota\maps\dota.vpk" call :end ! Missing "%STEAMAPPS%\common\dota 2 beta\game"
set "DOTA=%STEAMAPPS%\common\dota 2 beta\game" & set "CONTENT=%STEAMAPPS%\common\dota 2 beta\content"
exit/b
:reg_query [USAGE] call :reg_query ResultVar "HKCU\KeyName" "ValueName"
(for /f "skip=2 delims=" %%s in ('reg query "%~2" /v "%~3" /z 2^>nul') do set ".=%%s" & call set "%~1=%%.:*)    =%%") & exit/b
:end %1:Message
if "%~1"=="!" ( color c0 &echo !ERROR%* &timeout /t 16 &color &exit ) else echo  %* &timeout /t 8 &color &exit
