@echo off
if exist "%~f1" signtool sign -d "ViaThinkSoft OpenSource Application" -du "http://www.viathinksoft.de/" -a -t "http://time.certum.pl/" "%~f1"
