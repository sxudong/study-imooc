@echo off
cls
if "%1"=="" goto syntax
if "%1"=="DEMO" goto syntax
if "%chipset%"=="" set chipset=sis530
c:
CD\627.10
MD %chipset%
MD %chipset%\OEM
MD %chipset%\OEM\%1

rem  creating porting subdirectory for specific vendor

CD\627.10\%chipset%\OEM\%1
MD OEMPORT
MD OEMPORT\ACPI.ASL
MD OEMIO.MOD
MD OEMCORE.MOD
MD OEMCHIP.MOD
rem   ****************************************
rem   copy BIOS setup script file
rem   ****************************************
CD\627.10
copy obj\core.ssp      %chipset%\oem\%1\oemcore.mod\*.*
copy io.112\io*.ssp    %chipset%\oem\%1\oemio.mod\*.*
rem   ****************************************
rem   change to chipset layer
rem   ****************************************

cd %chipset%
copy io\io*.ssp        oem\%1\oemio.mod\*.*
copy dim\pcipnp.ssp    oem\%1\oemchip.mod\*.*
copy gpc\power.ssp     oem\%1\oemchip.mod\*.*
copy sys\*.ssp         oem\%1\oemchip.mod\*.*
rem   ****************************************
rem   coping some assembly files fot porting
rem   *****************************************
copy  oem\demo\oemport\OEMFLASH.ASM    oem\%1\oemport\OEMFLASH.ASM
copy  oem\demo\oemport\OEMPOST.ASM     oem\%1\oemport\OEMPOST.ASM
copy  oem\demo\oemport\OEMPDIM.ASM     oem\%1\oemport\OEMPDIM.ASM
copy  oem\demo\oemport\OEMMEMRY.ASM    oem\%1\oemport\OEMMEMRY.ASM

copy  oem\demo\oemport\OEMRUN.ASM      oem\%1\oemport\OEMRUN.ASM
copy  oem\demo\oemport\OEMRPCI.ASM     oem\%1\oemport\OEMRPCI.ASM
copy  oem\demo\oemport\OEMSETUP.ASM    oem\%1\oemport\OEMSETUP.ASM
copy  oem\demo\oemport\OEMIOTBL.ASM    oem\%1\oemport\OEMIOTBL.ASM
copy  oem\demo\oemio.mod\OEMRMISC.ASM  oem\%1\oemio.mod\OEMRMISC.ASM
copy  oem\demo\makeall.bat             oem\%1\makeall.bat
copy  oem\demo\makebios.bat            oem\%1\makebios.bat

echo  \627.10\%chipset%\oem\%1% and subdirectories has been created !
goto end
:syntax

echo  MAKEOEM [vendor]  or
echo  MAKEOEM [product] , all [vendor] or [product] string must be uppercaps.
echo.
echo  example: MAKEOEM LEAD , will make \627.10\SIS530\OEM\LEAD and subdirs.
echo.
echo  PS: if you don't set chipset=xxxx in enviroment space before,
echo      default chipset=SIS530
:end
