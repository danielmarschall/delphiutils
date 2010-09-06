@echo off

echo === Process %~1 ===

call "%%~dp0%%\cleanDir.bat" "%~1"
call "%%~dp0%%\signExe.bat" "%~1\*.exe"
