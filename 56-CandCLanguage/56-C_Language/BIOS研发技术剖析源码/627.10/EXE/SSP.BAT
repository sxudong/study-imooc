if "%1"=="" goto end
if "%1"=="1" goto ssp1
if "%1"=="2" goto ssp2
goto end
:ssp1
:ssp2
copy \627.10\exe\ssp%1%\amissp.exe \627.10\exe\*.*
:end
