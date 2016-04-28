:: Dota 2 - reset local and remote Cloud settings (cc) AVEYO
:: Procedure:
:: 1. Make sure you launch the game at least once with the account having troubles, else this script will use the last logged on account
:: 2. Run this script - you might need to right-click it and Run as Administrator
:: 3. Open Steam then launch Dota 2 from Steam library, and chose Upload at the Cloud Sync Conflict prompt (if enabled) 
:: 4. Adjust your settings, then restart Dota 2. Did it stick? Repeat procedure with Cloud On and Off

@ECHO OFF &SETLOCAL ENABLEDELAYEDEXPANSION
CALL :DETECT_STEAMPATH 
echo/%STEAMPATH%
CALL :DETECT_DOTAPATH 
echo/%DOTAPATH%
CALL :DETECT_USERPATH 
echo/%USERPATH%
TASKKILL /T /F /IM dota2.exe >nul 2>&1
TASKKILL /T /F /IM Steam.exe >nul 2>&1
TAKEOWN /F "%USERPATH%" /R /D Y >nul 2>&1
ICACLS "%USERPATH%" /reset /T /Q >nul 2>&1
ATTRIB -R "%USERPATH%" /S /D >nul 2>&1
DEL /F /Q "%USERPATH%\570\remotecache.vdf" >nul 2>&1
FOR /F %%i IN ('DIR %USERPATH%\570 /A:-D/B/S') DO CD.>"%%i"
COPY /Y "%DOTAPATH%\dota\cfg\autoexec.cfg" "%~dp0\" >nul 2>&1 
DEL /F /Q "%DOTAPATH%\dota\cfg\*" >nul 2>&1
COPY /Y "%~dp0\autoexec.cfg" "%DOTAPATH%\dota\cfg\" >nul 2>&1 
CD.>"%DOTAPATH%\dota\cfg\user_keys_default.vcfg"
SET "ACFG=%DOTAPATH%\dota\cfg\autoexec.cfg"
IF NOT EXIST "%ACFG%" EXIT /B
FINDSTR /L "dota_keybindings_cloud_disable 0;;;" "%ACFG%" >nul 2>&1
IF "%ERRORLEVEL%"=="0" EXIT /B
ATTRIB -R "%ACFG%" 
(echo.&echo/dota_keybindings_cloud_disable 0;;;)>>"%ACFG%"
EXIT /B
GOTO :eof
::END.MAIN

:DETECT_STEAMPATH
:: search in default_path/filetypes/registry and save it in %STEAMPATH% var
SET "STEAMPATH=C:\Program Files (x86)\Steam"
IF EXIST "%STEAMPATH%\Steam.exe" IF EXIST "%STEAMPATH%\config\config.vdf" GOTO :eof
FOR /F USEBACKQ^ TOKENS^=2^ DELIMS^=^" %%A IN (`FTYPE steam 2^>nul`) DO SET "STEAMPATH=%%~dpA"
SET "STEAMPATH=%STEAMPATH:~,-1%"
IF EXIST "%STEAMPATH%\Steam.exe" GOTO :eof
:: Valve why do you use Linux paths under Windows?!
FOR /F "usebackq tokens=2* delims=_" %%A IN (`REG QUERY "HKCU\SOFTWARE\Valve\Steam" 2^>nul ^| FIND /I "SteamPath"`) DO SET "STEAMPATH=%%~A"
SET "STEAMPATH=%STEAMPATH:~6%"
SET "STEAMPATH=%STEAMPATH:/=\%"
SET "STEAMPATH=%STEAMPATH:\\=\%"
IF EXIST "%STEAMPATH%\Steam.exe" GOTO :eof
SET "STEAMPATH="
GOTO :eof
::END.DETECT_STEAMPATH

:DETECT_DOTAPATH
:: search in default_path/filetypes/steam_config/steam_library and save it in %DOTAPATH% var
IF EXIST "!STEAMPATH!\SteamApps\appmanifest_570.acf" IF EXIST "!STEAMPATH!\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" SET "DOTAPATH=!STEAMPATH!\steamapps\common\dota 2 beta\game" &GOTO :eof
FOR /F USEBACKQ^ TOKENS^=2^ DELIMS^=^" %%A IN (`FTYPE dota2 2^>nul`) DO CD /D "%%~dpA" >NUL 2>&1
IF EXIST particles.dll CD /D ..\..\ 
SET "DOTAPATH=!CD!"
IF EXIST "!DOTAPATH!\dota\maps\dota.vpk" GOTO :eof
:: damn Valve why don't you have a reg entry for library folders?
FOR /F USEBACKQ^ DELIMS^=^"^ TOKENS^=4 %%A IN (`FINDSTR "BaseInstallFolder_" "!STEAMPATH!\config\config.vdf"`) DO (
SET "APPPATH=%%A" &SET "APPPATH=!APPPATH:/=\!" &SET "APPPATH=!APPPATH:\\=\!" 
IF EXIST "!APPPATH!\appmanifest_570.acf" IF EXIST "!APPPATH!\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" SET "DOTAPATH=!APPPATH!\steamapps\common\dota 2 beta\game" &GOTO :eof
)
FOR /F USEBACKQ^ DELIMS^=^"^ TOKENS^=4 %%A IN (`FINDSTR /V "LibraryFolders { TimeNextStatsReport ContentStatsID }" "!STEAMPATH!\SteamApps\libraryfolders.vdf"`) DO (
SET "APPPATH=%%A" &SET "APPPATH=!APPPATH:/=\!" &SET "APPPATH=!APPPATH:\\=\!"
IF EXIST "!APPPATH!\steamapps\appmanifest_570.acf" IF EXIST "!APPPATH!\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" SET "DOTAPATH=!APPPATH!\steamapps\common\dota 2 beta\game" &GOTO :eof
)
SET "DOTAPATH="
GOTO :eof
::END.DETECT_DOTAPATH

:DETECT_USERPATH
:: search in %DOTAPATH%\game\dota\ and save it in %USERPATH% var - simpler this way, else it would require converting steamid and poking around steam config files
CD /D "%DOTAPATH%\dota\" >NUL 2>&1 
FOR /F DELIMS^=^ EOL^= %%B IN ('DIR /A:-D /B /O:D /T:W cache_*.soc 2^>nul') DO SET "USERCACHE=%%~nB"
SET "USERPATH=%STEAMPATH%\userdata\%USERCACHE:cache_=%"
IF EXIST "%USERPATH%\config\localconfig.vdf" GOTO :eof
SET "USERPATH="
GOTO :eof
::END.DETECT_USERPATH
