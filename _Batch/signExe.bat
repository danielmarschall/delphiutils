@echo off

REM Bereits signiert?
signtool verify /pa "%~f1"

IF %ERRORLEVEL% == 0 GOTO end

rem SET TSA=http://timestamp.verisign.com/scripts/timstamp.dll
SET TSA=http://time.certum.pl/

SET NAME=ViaThinkSoft OpenSource Application
SET URL=http://www.viathinksoft.de/

if exist "%~f1" signtool sign -d "%NAME%" -du "%URL%" -a -t "%TSA%" "%~f1"

:end
