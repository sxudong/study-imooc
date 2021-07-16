@echo off
if "%1"=="" goto showuse
cls
@set ext=.eng
if "%2"=="ml" set ext=.cht
if "%2"=="ML" set ext=.cht
xcopy \627.10\exe\playrom.exe *.exe
xcopy \627.10\exe\retriv.exe
xcopy \627.10\exe\romsetup%ext% *.exe
cls
romsetup %1
del playrom.exe
del retriv.exe
del romsetup.exe
goto end
:showuse
echo %0 filename.rom [ML]
:end
