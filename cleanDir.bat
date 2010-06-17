@echo off

rd /s /q %1\__history
del %1\*.identcache
del %1\*.dcu
del %1\*.~*
del %1\*.local
