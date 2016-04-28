:: Dota 2 - log files needed for debugging unwanted settings reset (cc) AVEYO
:: Procedure:
:: 1. Add Dota 2 launch options: -condebug -conclearlog
:: 2. Launch Dota 2 
:: 3. After closing Dota 2, run this script to gather configuration files in the LOG subfolder
:: 4. Archive (.zip) the folder or just a particular run inside and share it on dev.dota2 

@ECHO OFF &SETLOCAL ENABLEDELAYEDEXPANSION
CALL :DETECT_STEAM_PATH
echo    %STEAMPATH%
CALL :DETECT_USER_PATH
echo    %USERPATH%
CALL :DETECT_DOTA2_PATH
echo    %DOTAPATH%
echo %STEAMID64%

FOR /F %%a IN ('WMIC OS GET LocalDateTime ^| FIND "."') DO SET DTS=%%a
SET DateTime=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%_%DTS:~8,2%-%DTS:~10,2%-%DTS:~12,2%

XCOPY "%USERPATH%\570\*" "%~dp0LOG\%DateTime%\570\" /C /E /I /Q /S /Y
XCOPY "%DOTAPATH%\game\dota\cfg\*" "%~dp0LOG\%DateTime%\cfg\" /C /E /I /Q /S /Y
COPY /Y "%DOTAPATH%\game\dota\console.log" "%~dp0LOG\%DateTime%\" >NUL 2>&1

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
