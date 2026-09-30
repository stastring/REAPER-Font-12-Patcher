@echo off
setlocal EnableExtensions EnableDelayedExpansion

title REAPER Font 12 Automatic Patch

echo ==========================================
echo      REAPER FONT 12 AUTOMATIC PATCH
echo ==========================================
echo.

REM ============================================================
REM STEP 1 - Locate REAPER
REM ============================================================

echo [1/7] Locating REAPER...
echo.

set "REAPER="

REM --- First try the normal REAPER installation path
if exist "C:\Program Files\REAPER (x64)\reaper.exe" (
    set "REAPER=C:\Program Files\REAPER (x64)\reaper.exe"
)

if not defined REAPER if exist "C:\Program Files\REAPER\reaper.exe" (
    set "REAPER=C:\Program Files\REAPER\reaper.exe"
)

REM --- Try Program Files (x86)
if not defined REAPER if exist "C:\Program Files (x86)\REAPER\reaper.exe" (
    set "REAPER=C:\Program Files (x86)\REAPER\reaper.exe"
)

REM --- If still not found, search Program Files
if not defined REAPER (
    echo Normal REAPER path not found.
    echo Searching Program Files...
    echo.

    for /f "delims=" %%A in ('powershell.exe -NoProfile -Command "$roots=@('C:\Program Files','C:\Program Files (x86)'); foreach($r in $roots){ if(Test-Path $r){ Get-ChildItem -Path $r -Filter reaper.exe -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {$_.FullName} } }"') do (
        if not defined REAPER set "REAPER=%%A"
    )
)

if not defined REAPER goto REAPER_NOT_FOUND

echo REAPER found:
echo %REAPER%
echo.

REM ============================================================
REM STEP 2 - Locate Resource Hacker
REM ============================================================

echo [2/7] Locating Resource Hacker...
echo.

set "RH="

REM --- Your current location
if exist "D:\tools\resource_hacker\ResourceHacker.exe" (
    set "RH=D:\tools\resource_hacker\ResourceHacker.exe"
)

REM --- Common locations
if not defined RH if exist "C:\Program Files\Resource Hacker\ResourceHacker.exe" (
    set "RH=C:\Program Files\Resource Hacker\ResourceHacker.exe"
)

if not defined RH if exist "C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" (
    set "RH=C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe"
)

REM --- Search Program Files if necessary
if not defined RH (
    echo Resource Hacker not found in the normal locations.
    echo Searching Program Files...
    echo.

    for /f "delims=" %%A in ('powershell.exe -NoProfile -Command "$roots=@('C:\Program Files','C:\Program Files (x86)'); foreach($r in $roots){ if(Test-Path $r){ Get-ChildItem -Path $r -Filter ResourceHacker.exe -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {$_.FullName} } }"') do (
        if not defined RH set "RH=%%A"
    )
)

if not defined RH goto RH_NOT_FOUND

echo Resource Hacker found:
echo %RH%
echo.

REM ============================================================
REM STEP 3 - Check Administrator
REM ============================================================

echo [3/7] Checking administrator permission...
echo.

net session >nul 2>&1

if not "%errorlevel%"=="0" goto ADMIN_ERROR

echo OK: Administrator permission confirmed.
echo.

REM ============================================================
REM STEP 4 - Prepare working folder
REM ============================================================

echo [4/7] Preparing working folder...
echo.

set "WORK=%TEMP%\REAPER_Font_Patch"
set "RC=%WORK%\dialogs.rc"
set "RES=%WORK%\dialogs.res"
set "OUT=%~dp0reaper_custom.exe"

if exist "%WORK%" (
    rmdir /s /q "%WORK%" >nul 2>&1
)

mkdir "%WORK%"

echo Working folder:
echo %WORK%
echo.

REM ============================================================
REM STEP 5 - Extract Dialog resources
REM ============================================================

echo [5/7] Extracting Dialog resources...
echo.

"%RH%" -open "%REAPER%" -save "%RC%" -action extract -mask DIALOG,, -log "%WORK%\extract.log"

if not exist "%RC%" goto EXTRACT_ERROR

echo OK: dialogs.rc created.
echo.

REM ============================================================
REM STEP 6 - Change all MS Shell Dlg fonts to 12
REM ============================================================

echo [6/7] Changing all MS Shell Dlg fonts to 12...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p='%RC%'; $enc=New-Object System.Text.UnicodeEncoding($false,$true); $s=[IO.File]::ReadAllText($p,$enc); $q=[char]34; $pattern='FONT\s+\d+,\s+'+$q+'MS Shell Dlg'+$q; $m=[regex]::Matches($s,$pattern); Write-Host ('Found '+$m.Count+' MS Shell Dlg FONT entries.'); if($m.Count -eq 0){exit 1}; $s=[regex]::Replace($s,$pattern,'FONT 12, '+$q+'MS Shell Dlg'+$q); $n=[regex]::Matches($s,'FONT 12,\s+'+$q+'MS Shell Dlg'+$q).Count; Write-Host ('FONT 12 entries: '+$n); if($n -ne $m.Count){exit 1}; [IO.File]::WriteAllText($p,$s,$enc)"

if errorlevel 1 goto FONT_ERROR

echo.
echo OK: All Dialog fonts changed to 12.
echo.

REM ============================================================
REM STEP 7 - Compile and create modified REAPER
REM ============================================================

echo [7/7] Compiling and creating reaper_custom.exe...
echo.

"%RH%" -open "%RC%" -save "%RES%" -action compile -log "%WORK%\compile.log"

if not exist "%RES%" goto COMPILE_ERROR

echo OK: dialogs.res created.
echo.

REM --- Delete previous custom version
if exist "%OUT%" (
    del /f /q "%OUT%" >nul 2>&1
)

REM --- Copy the ORIGINAL REAPER
copy /y "%REAPER%" "%OUT%" >nul

if not exist "%OUT%" goto COPY_ERROR

REM --- Inject modified Dialog resources
"%RH%" -open "%OUT%" -save "%OUT%" -action addoverwrite -resource "%RES%" -mask DIALOG,, -log "%WORK%\patch.log"

if not exist "%OUT%" goto PATCH_ERROR

echo.
echo ==========================================
echo             PATCH COMPLETE
echo ==========================================
echo.
echo Original REAPER:
echo %REAPER%
echo.
echo Resource Hacker:
echo %RH%
echo.
echo Modified REAPER:
echo %OUT%
echo.
echo Dialog font:
echo MS Shell Dlg -> 12
echo.
echo The original reaper.exe was NOT modified.
echo.
echo ==========================================
echo.
echo You can now run:
echo.
echo reaper_custom.exe
echo.
echo This window will close in 15 seconds.
echo.

timeout /t 15 /nobreak >nul
exit /b 0


REM ============================================================
REM ERROR MESSAGES
REM ============================================================

:REAPER_NOT_FOUND

echo.
echo ==========================================
echo ERROR: REAPER NOT FOUND
echo ==========================================
echo.
echo The script could not locate reaper.exe.
echo.
echo Please check where REAPER is installed.
echo.
timeout /t 30 /nobreak >nul
exit /b 1


:RH_NOT_FOUND

echo.
echo ==========================================
echo ERROR: RESOURCE HACKER NOT FOUND
echo ==========================================
echo.
echo The script could not locate ResourceHacker.exe.
echo.
echo Please check where Resource Hacker is installed.
echo.
timeout /t 30 /nobreak >nul
exit /b 1


:ADMIN_ERROR

echo.
echo ==========================================
echo ERROR: ADMINISTRATOR REQUIRED
echo ==========================================
echo.
echo Right-click this BAT file and choose:
echo.
echo Run as administrator
echo.
timeout /t 30 /nobreak >nul
exit /b 1


:EXTRACT_ERROR

echo.
echo ==========================================
echo ERROR: EXTRACTION FAILED
echo ==========================================
echo.
if exist "%WORK%\extract.log" type "%WORK%\extract.log"
echo.
timeout /t 30 /nobreak >nul
exit /b 1


:FONT_ERROR

echo.
echo ==========================================
echo ERROR: FONT MODIFICATION FAILED
echo ==========================================
echo.
echo The current REAPER version did not contain
echo the expected MS Shell Dlg font entries.
echo.
echo No modified REAPER was created.
echo.
timeout /t 30 /nobreak >nul
exit /b 1


:COMPILE_ERROR

echo.
echo ==========================================
echo ERROR: RESOURCE COMPILATION FAILED
echo ==========================================
echo.
if exist "%WORK%\compile.log" type "%WORK%\compile.log"
echo.
timeout /t 30 /nobreak >nul
exit /b 1


:COPY_ERROR

echo.
echo ==========================================
echo ERROR: COULD NOT CREATE CUSTOM REAPER
echo ==========================================
echo.
echo Target:
echo %OUT%
echo.
timeout /t 30 /nobreak >nul
exit /b 1


:PATCH_ERROR

echo.
echo ==========================================
echo ERROR: RESOURCE INJECTION FAILED
echo ==========================================
echo.
if exist "%WORK%\patch.log" type "%WORK%\patch.log"
echo.
timeout /t 30 /nobreak >nul
exit /b 1