break on
del err.out
for %%a in (*.asm) do ml /nologo /c /I..\include %%a >>err.out
copy *.obj ..\obj
find /I "error" err.out
