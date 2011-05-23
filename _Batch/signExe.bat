@echo off

rem SET TSA=http://timestamp.verisign.com/scripts/timstamp.dll
SET TSA=http://time.certum.pl/

SET NAME=ViaThinkSoft OpenSource Application
SET URL=http://www.viathinksoft.de/

for %%i in (%1) do (

echo.
echo Found %%i
echo Extended: %%~fi
echo.

cd "%~dp0"

REM Bereits signiert?
signtool.exe verify /pa "%%~fi"

rem IF %ERRORLEVEL% == 0 GOTO end

IF ERRORLEVEL 1 (

signtool.exe sign -d "%NAME%" -du "%URL%" -a -t "%TSA%" "%%~fi"

)

cd ..

)
