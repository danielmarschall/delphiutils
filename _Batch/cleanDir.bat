@echo off
if exist %1\__history rd /s /q %1\__history
if exist %1\*.identcache del %1\*.identcache
if exist %1\*.dcu del %1\*.dcu
if exist %1\*.~* del %1\*.~*
if exist %1\*.local del %1\*.local
if exist %1\*.tmp del %1\*.tmp
