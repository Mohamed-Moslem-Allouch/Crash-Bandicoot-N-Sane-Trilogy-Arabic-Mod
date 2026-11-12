@echo off
setlocal EnableExtensions
title Crash Bandicoot N. Sane Trilogy - Arabic Mod Installer

set "SILENT=0"
set "TARGET_ARG="
for %%A in (%*) do (
    if /I "%%~A"=="/S" (
        set "SILENT=1"
    ) else if /I "%%~A"=="-s" (
        set "SILENT=1"
    ) else if not defined TARGET_ARG (
        set "TARGET_ARG=%%~A"
    )
)

set "SRC_PAK=%~dp0_Arabic_Mod\update.pak"
if not exist "%SRC_PAK%" set "SRC_PAK=%~dp0archives\update.pak"
if not exist "%SRC_PAK%" (
    echo [ERROR] Missing mod file: "%~dp0_Arabic_Mod\update.pak"
    echo Extract the entire mod archive before running this installer.
    if "%SILENT%"=="0" pause
    exit /b 1
)

echo ============================================================================
echo   Crash Bandicoot N. Sane Trilogy - Full Arabic Translation Mod Installer
echo   Translated by Mohamed Moslem Allouch
echo ============================================================================
echo.

set "GAME_DIR="

if defined TARGET_ARG (
    call :ResolveCandidate "%TARGET_ARG%"
    if not defined GAME_DIR (
        echo [ERROR] Invalid game folder specified: "%TARGET_ARG%"
        echo Could not find CrashBandicootNSaneTrilogy.exe and archives folder.
        if "%SILENT%"=="0" pause
        exit /b 1
    )
    goto :DoInstall
)

:: 1. Auto-detect current directory, parent directory, or package subfolder in game directory
for %%D in ("%~dp0." "%~dp0.." "%~dp0..\..") do (
    if not defined GAME_DIR call :ResolveCandidate "%%~fD"
)

:: 2. Auto-detect Steam AppID 731490 registry keys
if not defined GAME_DIR (
    for %%R in (
        "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 731490"
        "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 731490"
    ) do (
        if not defined GAME_DIR (
            for /f "tokens=2,*" %%A in ('reg query %%R /v InstallLocation 2^>nul ^| findstr /I "InstallLocation"') do (
                call :ResolveCandidate "%%B"
            )
        )
    )
)

:: 3. Auto-detect common install folders across C:-G:
if not defined GAME_DIR (
    for %%L in (C D E F G) do (
        if not defined GAME_DIR (
            for %%P in (
                "%%L:\Games\Crash Bandicoot N. Sane Trilogy"
                "%%L:\Games\Crash Bandicoot - N. Sane Trilogy"
                "%%L:\Program Files (x86)\Steam\steamapps\common\Crash Bandicoot - N. Sane Trilogy"
                "%%L:\Program Files\Steam\steamapps\common\Crash Bandicoot - N. Sane Trilogy"
                "%%L:\SteamLibrary\steamapps\common\Crash Bandicoot - N. Sane Trilogy"
                "%%L:\Steam\steamapps\common\Crash Bandicoot - N. Sane Trilogy"
            ) do (
                if not defined GAME_DIR call :ResolveCandidate "%%~P"
            )
        )
    )
)

:AskLoop
if defined GAME_DIR goto :DoInstall
echo Game folder was not found automatically.
echo Paste or drag-and-drop your "Crash Bandicoot N. Sane Trilogy" folder
echo ^(containing CrashBandicootNSaneTrilogy.exe^) and press ENTER:
set "USER_INPUT="
set /p "USER_INPUT=> "
if not defined USER_INPUT goto :AskLoop
set "USER_INPUT=%USER_INPUT:"=%"
call :ResolveCandidate "%USER_INPUT%"
if not defined GAME_DIR (
    echo [WARNING] CrashBandicootNSaneTrilogy.exe or archives\ not found there.
    echo.
    goto :AskLoop
)

:DoInstall
echo Installing Arabic Mod directly into:
echo   %GAME_DIR%
echo.

for %%F in ("%SRC_PAK%") do set "SRC_FULL=%%~fF"
for %%F in ("%GAME_DIR%\archives\update.pak") do set "DST_FULL=%%~fF"
if /I "%SRC_FULL%"=="%DST_FULL%" (
    echo [SUCCESS] Mod file is already at archives\update.pak!
    goto :DoneOk
)

:: Back up pre-existing non-mod files once (do not overwrite or copy when _Backup_Original already tracks vanilla)
if not exist "%GAME_DIR%\_Arabic_Mod_Backup" (
    if not exist "%GAME_DIR%\_Backup_Original" (
        mkdir "%GAME_DIR%\_Arabic_Mod_Backup" 2>nul
        if not exist "%GAME_DIR%\_Arabic_Mod_Backup" (
            echo [ERROR] Access denied creating backup folder in "%GAME_DIR%".
            echo Right-click Install_Arabic_Mod.cmd and choose "Run as administrator".
            if "%SILENT%"=="0" pause
            exit /b 1
        )
        if exist "%GAME_DIR%\archives\update.pak" (
            echo Backing up existing archives\update.pak...
            copy /Y "%GAME_DIR%\archives\update.pak" "%GAME_DIR%\_Arabic_Mod_Backup\update.pak" >nul
        )
        if exist "%GAME_DIR%\steam_emu.ini" copy /Y "%GAME_DIR%\steam_emu.ini" "%GAME_DIR%\_Arabic_Mod_Backup\steam_emu.ini" >nul
        if exist "%GAME_DIR%\Origins.ini" copy /Y "%GAME_DIR%\Origins.ini" "%GAME_DIR%\_Arabic_Mod_Backup\Origins.ini" >nul
        >"%GAME_DIR%\_Arabic_Mod_Backup\installed.txt" echo Arabic Mod installed.
    )
)

echo Copying update.pak to "%GAME_DIR%\archives\update.pak"...
copy /Y "%SRC_PAK%" "%GAME_DIR%\archives\update.pak" >nul
if errorlevel 1 (
    echo [ERROR] Failed to write "%GAME_DIR%\archives\update.pak".
    echo Right-click Install_Arabic_Mod.cmd and choose "Run as administrator".
    if "%SILENT%"=="0" pause
    exit /b 1
)

:DoneOk
echo.
echo [SUCCESS] Full Arabic Translation Mod installed!
echo - Keep game language set to ENGLISH.
echo - To restore original English later, run Uninstall_Arabic_Mod.cmd.
if "%SILENT%"=="0" timeout /t 3 >nul 2>&1
exit /b 0

:ResolveCandidate
set "CAND=%~1"
set "CAND=%CAND:"=%"
if not defined CAND exit /b 0
for %%I in ("%CAND%") do (
    if /I "%%~nxI"=="CrashBandicootNSaneTrilogy.exe" set "CAND=%%~dpI"
)
if "%CAND:~-1%"=="\" set "CAND=%CAND:~0,-1%"
if exist "%CAND%\CrashBandicootNSaneTrilogy.exe" (
    if exist "%CAND%\archives" (
        for %%R in ("%CAND%") do set "GAME_DIR=%%~fR"
    )
)
exit /b 0
