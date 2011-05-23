@echo off

echo === Process %~1 ===

call "%~dp0\cleanDir.bat" "%~1"
call "%~dp0\signExe.bat" "%~1\*.exe"
call "%~dp0\signExe.bat" "%~1\*.dll"
call "%~dp0\signExe.bat" "%~1\*.ocx"
call "%~dp0\signExe.bat" "%~1\*.msi"
call "%~dp0\signExe.bat" "%~1\*.cab"
call "%~dp0\signExe.bat" "%~1\*.xpi"
call "%~dp0\signExe.bat" "%~1\*.xap"
