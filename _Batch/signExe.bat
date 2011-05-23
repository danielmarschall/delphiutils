@echo off

REM SET TSA=http://timestamp.verisign.com/scripts/timstamp.dll
SET TSA=http://time.certum.pl/

SET NAME=ViaThinkSoft OpenSource Application
SET URL=http://www.viathinksoft.de/

echo Signing %1

for %%i in (%1) do (
	echo.
	echo Found %%i
	echo Extended: %%~fi
	echo.

	cd "%~dp0"

	REM Bereits signiert?
	signtool.exe verify /pa "%%~fi"

	IF ERRORLEVEL 1 (
		signtool.exe sign -d "%NAME%" -du "%URL%" -a -t "%TSA%" "%%~fi"
	)

	cd ..
)
