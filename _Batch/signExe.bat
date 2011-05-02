@echo on

SET XXX=%~f1

cd "%~dp0"

if not exist "%XXX%" goto end

REM Bereits signiert?
signtool.exe verify /pa "%XXX%"

IF %ERRORLEVEL% == 0 GOTO end

rem SET TSA=http://timestamp.verisign.com/scripts/timstamp.dll
SET TSA=http://time.certum.pl/

SET NAME=ViaThinkSoft OpenSource Application
SET URL=http://www.viathinksoft.de/

signtool.exe sign -d "%NAME%" -du "%URL%" -a -t "%TSA%" "%XXX%"

:end

cd ..
