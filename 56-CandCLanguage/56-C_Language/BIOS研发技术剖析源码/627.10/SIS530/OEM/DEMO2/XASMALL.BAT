break on
del err.out
for %%a in (*.asm) do ml /nologo /c /I..\include /I..\asm2 /I..\pnp %%a >>err.out
ml /nologo /c /I..\include /DPOST /Focfp.obj cf.asm >>err.out
ml /c /I..\ /I..\include /DNOALTEST /Fovmna.obj vm.asm >>err.out
ml /nologo /c /I..\include /DCPUP6 /Formp6.obj rm.asm >>err.out
ml /nologo /c /I..\include /DN_SILENTBOOT /Fosilentn.obj silent.asm >>err.out
ml /nologo /c /I..\include /DN_SILENTBOOT /Fooutn.obj out.asm >>err.out
ml /nologo /c /I..\include /DNAFD /Fobootnafd.obj bootext.asm >>err.out
ml /nologo /c /I..\include /DNAFD /Foautonafd.obj auto.asm >>err.out
ml /nologo /c /I..\include /DPCIPNP /Fome5pci.obj me5.asm >>err.out
ml /nologo /c /I..\include /DHOTKEY /Foint9h.obj int9.asm >>err.out
ml /nologo /c /I..\include /DVANILLA_BIOS /Fobiosv.obj bios.asm >>err.out
ml /nologo /c /I..\include /DVANILLA_BIOS /Focfv.obj cf.asm >>err.out
link int10;
exe2bin int10;
copy int10.bin ..\obj
del int10.obj
del int10.exe
del int10.bin
del makejmp.out
concopy makejmp.out nmake jmp.mak %1
call copyobj
find /I "error" err.out
