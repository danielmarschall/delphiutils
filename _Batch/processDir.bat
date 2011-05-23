@echo off

echo === Process %~1 ===

call "%~dp0cleanDir.bat" "%~1\"
call "%~dp0signExe.bat" "%~1\*.exe"
call "%~dp0signExe.bat" "%~1\*.dll"
call "%~dp0signExe.bat" "%~1\*.ocx"
call "%~dp0signExe.bat" "%~1\*.msi"
call "%~dp0signExe.bat" "%~1\*.cab"
call "%~dp0signExe.bat" "%~1\*.xpi"
call "%~dp0signExe.bat" "%~1\*.xap"
