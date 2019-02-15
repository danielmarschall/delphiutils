@echo off
if exist *.dcu del *.dcu
if exist *.~* del *.~*
if exist *.obj del *.obj
if exist *.dsm del *.dsm
if exist *.lib del *.lib
if exist *.lck del *.lck
if exist _QSQ*.* del _QSQ*.*
if exist ModelSupport rmdir Modelsupport
attrib __history -h
if exist __history rmdir __history
del *.local
del *.identcache
