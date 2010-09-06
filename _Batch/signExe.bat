@echo off

rem SET TSA=http://timestamp.verisign.com/scripts/timstamp.dll
SET TSA=http://time.certum.pl/

SET NAME=ViaThinkSoft OpenSource Application
SET URL=http://www.viathinksoft.de/

if exist "%~f1" signtool sign -d "%NAME%" -du "%URL%" -a -t "%TSA%" "%~f1"
