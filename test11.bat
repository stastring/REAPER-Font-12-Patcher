@echo off
setlocal EnableExtensions

title REAPER Font 12 Patch

echo ==========================================
echo       REAPER FONT 12 AUTOMATIC PATCH
echo ==========================================
echo.

set "REAPER=C:\Program Files\REAPER (x64)\reaper.exe"
set "RH=D:\tools\resource_hacker\ResourceHacker.exe"
set "WORK=%TEMP%\REAPER_Font_Patch"
set "RC=%WORK%\dialogs.rc"
set "RES=%WORK%\dialogs.res"
set "OUT=C:\Program Files\REAPER (x64)\reaper_custom.exe"

echo [1/6] Checking files...
echo.

if not exist "%REAPER%" goto REAPER_ERROR
if not exist "%RH%" goto RH_ERROR

echo OK: REAPER found.
echo OK: Resource Hacker found.
echo.

echo [2/6] Checking administrator permission...
echo.

net session >nul 2>&1

if not "%errorlevel%"=="0" goto ADMIN_ERROR

echo OK: Administrator permission confirmed.
echo.

echo [3/6] Extracting Dialog resources...
echo.

if exist "%WORK%" rmdir /s /q "%WORK%"
mkdir "%WORK%"

"%RH%" -open "%REAPER%" -save "%RC%" -action extract -mask DIALOG,, -log "%WORK%\extract.log"

if not exist "%RC%" goto EXTRACT_ERROR

echo OK: dialogs.rc created.
echo.

echo [4/6] Changing all MS Shell Dlg fonts to 12...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p='%RC%'; $enc=New-Object System.Text.UnicodeEncoding($false,$true); $s=[IO.File]::ReadAllText($p,$enc); $q=[char]34; $pattern='FONT\s+\d+,\s+'+$q+'MS Shell Dlg'+$q; $m=[regex]::Matches($s,$pattern); Write-Host ('Found '+$m.Count+' MS Shell Dlg FONT entries.'); if($m.Count -eq 0){exit 1}; $s=[regex]::Replace($s,$pattern,'FONT 12, '+$q+'MS Shell Dlg'+$q); $n=[regex]::Matches($s,'FONT 12,\s+'+$q+'MS Shell Dlg'+$q).Count; Write-Host ('FONT 12 entries: '+$n); if($n -ne $m.Count){exit 1}; [IO.File]::WriteAllText($p,$s,$enc)"

if errorlevel 1 goto FONT_ERROR

echo.
echo OK: All Dialog fonts changed to 12.
echo.

echo [5/6] Compiling modified Dialog resources...
echo.

"%RH%" -open "%RC%" -save "%RES%" -action compile -log "%WORK%\compile.log"

if not exist "%RES%" goto COMPILE_ERROR

echo OK: dialogs.res created.
echo.

echo [6/6] Creating reaper_custom.exe...
echo.

if exist "%OUT%" del /f /q "%OUT%"

copy /y "%REAPER%" "%OUT%" >nul

if not exist "%OUT%" goto COPY_ERROR

"%RH%" -open "%OUT%" -save "%OUT%" -action addoverwrite -resource "%RES%" -mask DIALOG,, -log "%WORK%\patch.log"

if not exist "%OUT%" goto PATCH_ERROR

echo.
echo ==========================================
echo              PATCH COMPLETE
echo ==========================================
echo.
echo Original REAPER:
echo %REAPER%
echo.
echo Modified REAPER:
echo %OUT%
echo.
echo Dialog font:
echo MS Shell Dlg -> 12
echo.
echo Original reaper.exe was NOT modified.
echo.
echo You can now run:
echo reaper_custom.exe
echo.
echo This window will close in 10 seconds.
echo.

timeout /t 10 /nobreak >nul
exit /b 0


:REAPER_ERROR
echo ERROR: REAPER was not found:
echo %REAPER%
goto FAIL

:RH_ERROR
echo ERROR: Resource Hacker was not found:
echo %RH%
goto FAIL

:ADMIN_ERROR
echo ERROR: Administrator permission required.
echo Right-click the BAT and choose "Run as administrator".
goto FAIL

:EXTRACT_ERROR
echo ERROR: Dialog extraction failed.
echo.
if exist "%WORK%\extract.log" type "%WORK%\extract.log"
goto FAIL

:FONT_ERROR
echo ERROR: Font modification failed.
goto FAIL

:COMPILE_ERROR
echo ERROR: Resource compilation failed.
echo.
if exist "%WORK%\compile.log" type "%WORK%\compile.log"
goto FAIL

:COPY_ERROR
echo ERROR: Could not create reaper_custom.exe.
goto FAIL

:PATCH_ERROR
echo ERROR: Resource injection failed.
echo.
if exist "%WORK%\patch.log" type "%WORK%\patch.log"
goto FAIL

:FAIL
echo.
echo ==========================================
echo               PATCH FAILED
echo ==========================================
echo.
echo This window will remain open for 30 seconds.
echo.
timeout /t 30 /nobreak >nul
exit /b 1