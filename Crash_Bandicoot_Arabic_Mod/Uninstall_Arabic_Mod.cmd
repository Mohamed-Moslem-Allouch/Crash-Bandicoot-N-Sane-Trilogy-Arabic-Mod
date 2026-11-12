@echo off
setlocal EnableExtensions
title Crash Bandicoot N. Sane Trilogy - Uninstall Arabic Mod

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

echo ============================================================================
echo   Crash Bandicoot N. Sane Trilogy - Arabic Mod Uninstaller
echo ============================================================================
echo.

set "GAME_DIR="

if defined TARGET_ARG (
    call :ResolveCandidate "%TARGET_ARG%"
    if not defined GAME_DIR (
        echo [ERROR] Invalid game folder specified: "%TARGET_ARG%"
        if "%SILENT%"=="0" pause
        exit /b 1
    )
    goto :DoUninstall
)

for %%D in ("%~dp0." "%~dp0.." "%~dp0..\..") do (
    if not defined GAME_DIR call :ResolveCandidate "%%~fD"
)

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
if defined GAME_DIR goto :DoUninstall
echo Paste or drag-and-drop your "Crash Bandicoot N. Sane Trilogy" folder:
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

:DoUninstall
echo Removing Arabic Mod from:
echo   %GAME_DIR%
echo.

if exist "%GAME_DIR%\_Arabic_Mod_Backup\update.pak" (
    copy /Y "%GAME_DIR%\_Arabic_Mod_Backup\update.pak" "%GAME_DIR%\archives\update.pak" >nul
    echo Restored previous archives\update.pak from _Arabic_Mod_Backup.
) else if exist "%GAME_DIR%\archives\update.pak" (
    del /F /Q "%GAME_DIR%\archives\update.pak"
    if errorlevel 1 (
        echo [ERROR] Failed to delete "%GAME_DIR%\archives\update.pak".
        echo Right-click Uninstall_Arabic_Mod.cmd and choose "Run as administrator".
        if "%SILENT%"=="0" pause
        exit /b 1
    )
    echo Removed archives\update.pak ^(original game restored^).
) else (
    echo archives\update.pak is already absent.
)

if exist "%GAME_DIR%\_Arabic_Mod_Backup\steam_emu.ini" (
    copy /Y "%GAME_DIR%\_Arabic_Mod_Backup\steam_emu.ini" "%GAME_DIR%\steam_emu.ini" >nul
)
if exist "%GAME_DIR%\_Arabic_Mod_Backup\Origins.ini" (
    copy /Y "%GAME_DIR%\_Arabic_Mod_Backup\Origins.ini" "%GAME_DIR%\Origins.ini" >nul
)
if exist "%GAME_DIR%\_Arabic_Mod_Backup" (
    rmdir /S /Q "%GAME_DIR%\_Arabic_Mod_Backup" 2>nul
)

echo.
echo [SUCCESS] Original English game state restored!
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
