#     *****************************************************************;
#     *****************************************************************;
#     **                                                             **;
#     **      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
#     **                                                             **;
#     **                     All Rights Reserved.                    **;
#     **                                                             **;
#     **           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
#     **                                                             **;
#     **                     Phone (770)-246-8600                    **;
#     **                                                             **;
#     *****************************************************************;
#     *****************************************************************;
# (CORE0071-)>
##-----------------------------------------------------------------------#
## calculate BIOS_SIZE                                                  #
##-----------------------------------------------------------------------#
#!if $(DIM_SUPPORT)
#BIOS_SIZE  = 1                 # BIOS size: 0/1 = 64K/128K
#!else
#BIOS_SIZE  = 0                 # BIOS size: 0/1 = 64K/128K
#!endif
# <(CORE0071-)
#-----------------------------------------------------------------------#
# MACROs defined above may need to be changed from bios to bios.        #
# MACROs defined below should not need to be changed from bios to bios. #
#-----------------------------------------------------------------------#
AFLAGS          = @$(BUILD_DIR)\asm.rsp /Fo$*.obj
AMPFLAGS        = @$(BUILD_DIR)\asmmp.rsp /Fo$*.obj
LFLAGS          = /m /ONERROR:NOEXE

!if ($(DIM_SUPPORT) && $(INC_EISA))
NO_NVRAM        = 1
!else
!if !($(DIM_SUPPORT) && $(INC_PNP) && $(NONEISA_NVRAM) && $(NVRAM_FLASH) && $(BOOT_BLOCK))
NO_NVRAM        = 1
!else
NO_NVRAM        = 0
!endif
!endif
#-----------------------------------------------------------------------#
# The <BIOSFILE>.ROM file is dependent on the .POS, .SET, .INI, .BBC,   #
# .I13, .BLD files.  It may be dependant on .DIM,.GPC,.DMI,.MPS, etc.   #
# To generate the <BIOSFILE>.ROM file we need to run BUILD.             #
#-----------------------------------------------------------------------#
PREBUILD:
    SET LIB=$(LIBPATH)

CLEANUP:
# (CORE0071)>
#    $(ROMINFO) $(BUILD_DIR)\$(BIOSFILE).rom
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /L
# <(CORE0071)
    $(COPY) $(BUILD_DIR)\$(BIOSFILE).rom
        @$(COPY) << romter.ini
1
0
!if $(BIOS_SIZE)==1
5
!elseif $(BIOS_SIZE)==2
6
!endif
0
1
000000
$(BUILD_DIR)\$(BIOSFILE).rom
n
<<


$(BIOSFILE).rom: $(BUILD_DIR)\me9.equ           # (CORE0228+)
$(BIOSFILE).rom: $(MKF) $(TEMP_INC_FILES) $(BUILD_DIR)\coremod.dir $(BUILD_DIR)\oemcore.dir
!if $(ML_MODULE)
#$(BIOSFILE).rom: $(BUILD_DIR)\ml\setupequ.ext $(ML_MODULE_FILENAME)
$(BIOSFILE).rom: $(ML_MODULE_FILENAME)
!else
$(BIOSFILE).rom: $(BUILD_DIR)\setupequ.ext
!endif
$(BIOSFILE).rom: $(BUILD_DIR)\oemmake.equ
$(BIOSFILE).rom: $(BUILD_DIR)\makeflag.equ
$(BIOSFILE).rom: $(BUILD_DIR)\epa.bin   # $$$CORE0018
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).POS
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).SET
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).INI
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).I13
#$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).BLD  # (CORE0071)>
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).BBP   # <(CORE0071)
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).BBC
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).RID
!if $(BUP6)                                     # (CORE0071)>
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).P6M
!endif                                          # <(CORE0071)
!if $(DIM_SUPPORT)
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).DIM
!endif
!if $(GPC_SUPPORT)
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).GPC
!endif
!if $(MPS_SUPPORT)
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).MPS
!endif
!if $(ACPI_SUPPORT)
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).ACP
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).AML
!endif
#(CORE0072-)>
#!if $(DMI_SUPPORT)
#$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).DMI
#!endif
#<(CORE0072-)
!if $(DIM_SUPPORT)
    $(PNPCKSUM) $(BUILD_DIR)\$(BIOSFILE).set
!endif
!if ($(DIM_SUPPORT) && $(INC_PCI))
    $(PCICKSUM) $(BUILD_DIR)\$(BIOSFILE).set
!endif
!if ($(DIM_SUPPORT) && $(SMBA_SUPPORT))
    $(B16CKSUM) $(BUILD_DIR)\$(BIOSFILE).set
!endif
# (CORE0071)>
#    $(BUILD) $(BUILD_DIR)\$(BIOSFILE) $(BUILD_DIR)\$(BIOSFILE).bld
    $(BUILD) $(BUILD_DIR)\$(BIOSFILE).bbp
# (CORE0073+)>
!if $(SPLIT_ROM)
        @$(COPY) $(BUILD_DIR)\split1.cmp $(BUILD_DIR)\$(BIOSFILE).svr /y
!endif
# <(CORE0073+)
    $(MM) $(BUILD_DIR)\$(BIOSFILE).mm /b
#!if $(INT10)
#    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(CORE_DIR)\INT10.BIN 0B /M F000 F065
#!endif
# <(CORE0071)
!if $(SILENT_BOOT)
#    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(CORE_MOD_DIR)\PCX-EGA.BIN 32 /M 0000 0000
#    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(OEM_LOGO_FILENAME) 33 /M 0000 0000
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(CORE_MOD_DIR)\PCX256.BIN 32 /M 0000 0000
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(OEM_LOGO_FILENAME) 33 /M 0000 0200
!endif
# (CORE0071-): will be added by AMIBBP
#    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(BUILD_DIR)\$(BIOSFILE).I13 0D /M 0000 0000
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(BUILD_DIR)\$(BIOSFILE).RID 0C /U /M 0000 0000
# $$$CORE0018+ >>>
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /i $(BUILD_DIR)\epa.bin 31 /m 0000 0000
# $$$CORE0018+ <<<
# $$$CORE0021+ >>>
!if "$(TREND_ANTI_VIRUS)"!="0"
    $(MM) $(BUILD_DIR)\$(BIOSFILE).ROM /i $(ADDON_ROM_DIR)\cav162.bin 36 /m $(TREND_ANTI_VIRUS) 0000
#    $(MM) $(BUILD_DIR)\$(BIOSFILE).ROM /i $(ADDON_ROM_DIR)\cav0225.bin 29 /m e800 0000
#    $(MM) $(BUILD_DIR)\$(BIOSFILE).ROM /i $(ADDON_ROM_DIR)\oldcav.bin 29 /m e800 0000
# CAV101.BIN: New graphic logo from Trend
# CAV0225.BIN from FIC
# CAV0202.BIN: old graphic logo with NT boot fix
# oldcav.bin: No graphic logo but NT boot fix.
!endif
# $$$CORE0021+ <<<
!if $(RUN_BCP)
    $(BCP) $(BUILD_DIR)\$(BIOSFILE).rom
!endif
!if $(PCI_ROM1)
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(ADDON_ROM_DIR)\$(PCI_ROM1_FILENAME) 20 /M $(PCI_ROM1_DEVICEID) $(PCI_ROM1_VENDORID)
!endif
!if $(PCI_ROM2)
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(ADDON_ROM_DIR)\$(PCI_ROM2_FILENAME) 20 /M $(PCI_ROM2_DEVICEID) $(PCI_ROM2_VENDORID)
!endif
!if $(PCI_ROM3)
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(ADDON_ROM_DIR)\$(PCI_ROM3_FILENAME) 20 /M $(PCI_ROM3_DEVICEID) $(PCI_ROM3_VENDORID)
!endif
!if $(PCI_ROM4)
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(ADDON_ROM_DIR)\$(PCI_ROM4_FILENAME) 20 /M $(PCI_ROM4_DEVICEID) $(PCI_ROM4_VENDORID)
!endif
!if $(USER_ROM1)
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(ADDON_ROM_DIR)\$(USER_ROM1_FILENAME) $(USER_ROM1_MODULEID) /M $(USER_ROM1_DESTSEG) $(USER_ROM1_DESTADDR)
!endif
!if $(USER_ROM2)
    $(MM) $(BUILD_DIR)\$(BIOSFILE).rom /I $(ADDON_ROM_DIR)\$(USER_ROM2_FILENAME) $(USER_ROM2_MODULEID) /M $(USER_ROM2_DESTSEG) $(USER_ROM2_DESTADDR)
!endif
#-----------------------------------------------------------------------#
# .DIM is dependent on DIM.EXE.                                         #
# To generate .DIM we need to run locate.                               #
#-----------------------------------------------------------------------#
!if $(DIM_SUPPORT)
$(BUILD_DIR)\$(BIOSFILE).dim: $(BUILD_DIR)\dim.exe
    $(EXE2BIN) $(BUILD_DIR)\dim.exe $(BUILD_DIR)\$(BIOSFILE).dim
!endif
#-----------------------------------------------------------------------#
# The .RID file is dependent on $(MKF)                                  #
#-----------------------------------------------------------------------#
ROM_ID = $(PROJECT_PATH)$(PROJECT_BUILD)
$(BUILD_DIR)\$(BIOSFILE).RID: $(MKF)
    debug < <<
f cs:0 ffff 0
e cs:100 '$(ROM_ID)'
r bx
0
r cx
8
n $(BUILD_DIR)\$(BIOSFILE).rid
w cs:100
q
<<
#-----------------------------------------------------------------------#
# The .I13 file is dependent on INT13.EXE.                              #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\$(BIOSFILE).I13: $(MKF) $(BUILD_DIR)\INT13.EXE
    $(EXE2BIN) $(BUILD_DIR)\INT13.EXE $(BUILD_DIR)\$(BIOSFILE).I13
#-----------------------------------------------------------------------#
# The .INI file is dependent on INIT.EXE.                               #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\$(BIOSFILE).INI: $(BUILD_DIR)\init.EXE
    debug < <<
n $(BUILD_DIR)\init.exe
l
fcs:0 ffff 0
l

******************************* Put the filename and extension of the binary
******************************* ROM file which will be searched for by Boot
******************************* Block Recovery BIOS in root directory of the
******************************* diskette in floppy drive A:

ecs:e004 '           '
ecs:e004 '$(PGM_FILENAME)'
ecs:e00c '$(PGM_FILEEXT)'

******************************* Select keystrokes to be checked for force flash
******************************* programming. if only keystroke is chosen, make
******************************* both scan code same

!if ("$(KEY1_SCAN)" != "N")
ecs:e019 $(KEY1_SCAN)
!else
ecs:e019 0
!endif
!if ("$(KEY2_SCAN)" != "N")
ecs:e01a $(KEY2_SCAN)
!else
ecs:e01a 0
!endif

******************************* Put information of what Boot Block BIOS will do
******************************* after successful Flash programming

!if $(AFTER_PGM)
ecs:e01b 01
!else
ecs:e01b 00
!endif

******************************* If refresh signal is not working then put
******************************* a non-zero value in F000:E019 which will be
******************************* used as loop count for generating delay using
******************************* software LOOP instruction. The non-zero value
******************************* depends on CPU clock frequency, 36 for 66MHz

!if ("$(SOFT_DELAY)" != "N")
ecs:e01e $(SOFT_DELAY)
!else
ecs:e01e 0
!endif

; (CORE0071)>
;rsp
;8000
;
;
;a100
;movax,e000
;subcx,ax
;int3
;
;g=100
;
;r bx
;0
;n $(BUILD_DIR)\$(BIOSFILE).ini
;w cs:e000
n $(BUILD_DIR)\$(BIOSFILE).ini
w cs:0
;<(CORE0071)
q
<<
# (CORE0073+)>
!if $(SPLIT_ROM)
        debug < <<
n $(BUILD_DIR)\$(BIOSFILE).SET
l3000:0000
a100
pushds
movax,3000
movds,ax
movcx,[00]
popds
int3

g=100

n $(BUILD_DIR)\split.bin
r bx
0
w 3000:0000
q
<<
        ..\..\..\exe\compress       $(BUILD_DIR)\split.bin $(BUILD_DIR)\split.cmp
        debug < <<
; calculate size (DX) in bootblock
n $(BUILD_DIR)\$(BIOSFILE).INI
l 3000:0000
; CX = INI file size
a100
movdx,ffd8
subdx,cx
int3

g=100

n $(BUILD_DIR)\split.cmp
l 3000:0000
; CX = size of all, DX = maximum split0 size
a100
cmpdx,cx
jbe109
; Free space of bootblock is greater than size of split.cmp..
movdx,cx
; Leave 10h bytes for split1.cmp
subdx,10
xchgcx,dx
; CX = split0 size, DX = split.cmp size
int3

g=100

; CX = split0 size
n $(BUILD_DIR)\split0.cmp
r bx
0
w 3000:0000

; DX = size of all, CX = split0 size
n $(BUILD_DIR)\split1.cmp
a100
pushcx
movsi,cx
movdi,2000
subdx,cx
movcx,dx
pushds
pushes
movax,3000
movds,ax
moves,ax
repmovsb
popes
popds
movcx,dx
popdx
int3

g=100

r bx
0
w 3000:2000

; DX = split0 size
n $(BUILD_DIR)\$(BIOSFILE).INI
l 3000:0000
; CX = size of INI file
a100
movax,3000
movds,ax
!if $(BIOS_SIZE)==1
mov[e010],cx
!endif
!if $(BIOS_SIZE)==2
mov[c010],cx
!endif
int3

g=100

w 3000:0

q
<<
        @$(COPY) /b $(BUILD_DIR)\$(BIOSFILE).INI+$(BUILD_DIR)\split0.cmp        $(BUILD_DIR)\$(BIOSFILE).INI
!endif
# <(CORE0073+)
#-----------------------------------------------------------------------#
# The .GPC file is dependent on GPC.EXE.                                #
#-----------------------------------------------------------------------#
!if $(GPC_SUPPORT)
$(BUILD_DIR)\$(BIOSFILE).GPC: $(BUILD_DIR)\GPC.EXE
    $(EXE2BIN) $(BUILD_DIR)\gpc.exe $(BUILD_DIR)\$(BIOSFILE).GPC
!endif
#-----------------------------------------------------------------------#
# The .MPS file is dependent on MPS.EXE.                                #
#-----------------------------------------------------------------------#
!if $(MPS_SUPPORT)
$(BUILD_DIR)\$(BIOSFILE).MPS: $(BUILD_DIR)\MPS.EXE
    $(EXE2BIN) $(BUILD_DIR)\mps.exe $(BUILD_DIR)\$(BIOSFILE).MPS
!endif
#-----------------------------------------------------------------------#
!if $(ACPI_SUPPORT)
$(BUILD_DIR)\$(BIOSFILE).ACP: $(BUILD_DIR)\ACPITBL.EXE
    $(EXE2BIN) $(BUILD_DIR)\acpitbl.exe $(BUILD_DIR)\$(BIOSFILE).ACP
#-----------------------------------------------------------------------#
$(BUILD_DIR)\$(BIOSFILE).AML: $(ACPI_ASL_DIR)\oemdsdt.ASL
    $(ASL) /Fo=$(BUILD_DIR)\$(BIOSFILE).AML  /Fl=$(BUILD_DIR)\oemdsdt.lst /Fn=$(BUILD_DIR)\oemdsdt.nsd  $(ACPI_ASL_DIR)\oemdsdt.asl
#-----------------------------------------------------------------------#
!include $(OEM_DIR)\makeasl.mak
!endif
#(CORE0072-)>
##-----------------------------------------------------------------------#
## The .DMI file is dependent on DMI.EXE.                               #
##-----------------------------------------------------------------------#
#!if $(DMI_SUPPORT)
#$(BUILD_DIR)\$(BIOSFILE).DMI: $(SYS_PORT_DIR)\DMIDAT.DSP
#    $(DSP) $(SYS_PORT_DIR)\DMIDAT.DSP $(BUILD_DIR)\$(BIOSFILE).DMI
#!endif
#<(CORE0072-)
# (CORE0071+)>
#-----------------------------------------------------------------------#
# The .P6M file is dependent on P6 Binaries.                            #
#-----------------------------------------------------------------------#
!if $(BUP6)
$(BUILD_DIR)\$(BIOSFILE).P6M: $(MICRO_CODE_FILES)
#   @!$(COPY) /B $(**: =+) $(BUILD_DIR)\$(BIOSFILE).P6M
    @$(DELETE) $(BUILD_DIR)\$(BIOSFILE).P6M
    !$(COPY) /b $(BUILD_DIR)\$(BIOSFILE).P6M+$** $(BUILD_DIR)\$(BIOSFILE).P6M
    debug < <<
n $(BUILD_DIR)\$(BIOSFILE).P6M
l
fcs:100 ffff 0
l

ads:80
add cx,8
adc bx,0
int3

g=ds:80

n $(BUILD_DIR)\$(BIOSFILE).P6M
w cs:100
q
<<
!endif
# <(CORE0071+)
#-----------------------------------------------------------------------#
# The .BBC file is dependent on UUI.EXE.                                #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\$(BIOSFILE).BBC: $(BUILD_DIR)\UUI.EXE
    $(EXE2BIN) $(BUILD_DIR)\uui.exe $(BUILD_DIR)\$(BIOSFILE).BBC
#-----------------------------------------------------------------------#
# The .POS file is dependent on postrun.EXE.                            #
# To generate the .POS file we need to run a debug script.              #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\$(BIOSFILE).pos: $(BUILD_DIR)\postrun.exe $(BUILD_DIR)\dummyrun.exe
    debug < <<
n $(BUILD_DIR)\postrun.exe
l
r cx
0
r bx
1
n $(BUILD_DIR)\$(BIOSFILE).pos
w cs:0
q
<<
#-----------------------------------------------------------------------#
# The .SET file is dependent on setrun.EXE.                             #
# To generate the .SET file we need to run a debug script.              #
#-----------------------------------------------------------------------#
REFSTRING = $(CPU_STRING)$(BIOS_SIZE)-$(MAJOR_VER)$(MINOR_VER)-00$(CUSTOMER)

$(BUILD_DIR)\$(BIOSFILE).set: $(BUILD_DIR)\setrun.exe $(BUILD_DIR)\dummyrun.exe
!if $(DIM_SUPPORT) && ($(INC_EISA) || $(INC_PCI))
$(BUILD_DIR)\$(BIOSFILE).set: $(BUILD_DIR)\run32.EXE
!endif
    debug < <<
n $(BUILD_DIR)\setrun.exe
l
e cs:fffe fc 0
e cs:f478 '$(REFSTRING)'
************************ CHIPSET name,     8 bytes maximum, terminated by null
e cs:f497 '$(CHIPSETNAME)',0
************************ EVAL/PROD, CPU,   bit-7 = 1->EVAL, bit-6 = 1->286
!if $(EVAL)
e cs:f682 80
!else
e cs:f682 00
!endif
************************ if EISA put 'EISA' at F000:FFD9
!if $(DIM_SUPPORT) && $(INC_EISA)
e cs:FFD9 'EISA'
!endif
e cs:f6e9 $(NUMBER_OF_LANGUAGE)

e cs:f532 $(SIGN_ON_MSG1)

r cx
0
r bx
1

n $(BUILD_DIR)\$(BIOSFILE).set
w cs:0
q
<<
# (CORE0217+)>
    debug < <<
n $(BUILD_DIR)\$(BIOSFILE).set
l 3000:0
a
mov ax,3000
mov ds,ax
mov ah,4
int 1a
push cx
mov cl,4
mov al,dh
and al,f0
shr al,cl
add al,30
mov ah,dh
and ah,0f
add ah,30
mov [fff5],ax
mov al,dl
and al,f0
shr al,cl
add al,30
mov ah,dl
and ah,0f
add ah,30
mov [fff8],ax
pop dx
mov al,dl
and al,f0
shr al,cl
add al,30
mov ah,dl
and ah,0f
add ah,30
mov [fffb],ax
int 3

g
r cx
0
r bx
1
w 3000:0
q
<<
# <(CORE0217+)
    debug < <<
!if $(DIM_SUPPORT) && ($(INC_PCI) || $(INC_EISA))
n $(BUILD_DIR)\run32.EXE
l
ads:80
cli
movax,cs
addax,1010
pushes
moves,ax
movbx,cx
ss:movsi,[bx-4]
subcx,si
es:mov[0],cx
es:mov[2],si
movdi,10
ss:repmovsb
popes
int3

g=ds:80

n $(BUILD_DIR)\$(BIOSFILE).set
l

rsp
dff0

ads:80
cli
movax,cs
movss,ax
movsp,100
addax,10
moves,ax
es:movwo[f85c],0000
es:testby[f85b],80
jza3
es:movwo[f85c],ffff
addax,1000
pushds
movds,ax
movcx,[0]
movdi,[2]
movsi,10
repmovsb
popds
int3


g=ds:80

r cx
0
r bx
1

n $(BUILD_DIR)\$(BIOSFILE).set
wes:0
!endif
q
<<
#-----------------------------------------------------------------------#
# run32.EXE is dependent on the 32 bit runtime OBJs.                    #
# To generate run32.EXE we need to run the linker.                      #
#-----------------------------------------------------------------------#
!if $(DIM_SUPPORT)
$(BUILD_DIR)\run32.exe: $(RT32_OBJS) $(RT32_0_OBJS) $(RT32_1_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\run32.exe,
$(BUILD_DIR)\run32.map;
<<
!endif
#-----------------------------------------------------------------------#
# DIM.EXE is dependent on the DIM_OBJs.                                 #
# To generate DIM.EXE we need to run the linker.                        #
#-----------------------------------------------------------------------#
!if $(DIM_SUPPORT)
$(BUILD_DIR)\dim.exe: $(DIM_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\dim.exe,
$(BUILD_DIR)\dim.map;
<<
!endif
#-----------------------------------------------------------------------#
# GPC.EXE is dependent on the GPC OBJs.                                 #
# To generate GPC.EXE we need to run the linker.                        #
#-----------------------------------------------------------------------#
!if $(GPC_SUPPORT)
$(BUILD_DIR)\gpc.exe: $(GPC_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\gpc.exe,
$(BUILD_DIR)\gpc.map;
<<
!endif
#-----------------------------------------------------------------------#
# MPS.EXE is dependent on the MPS OBJs.                                 #
# To generate MPS.EXE we need to run the linker.                        #
#-----------------------------------------------------------------------#
!if $(MPS_SUPPORT)
$(BUILD_DIR)\mps.exe: $(MPS_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\mps.exe,
$(BUILD_DIR)\mps.map;
<<
!endif
#-----------------------------------------------------------------------#
# ACPITBL.EXE is dependent on the ACPI Table OBJs.                              #
# To generate ACPITBL.EXE we need to run the linker.                    #
#-----------------------------------------------------------------------#
!if $(ACPI_SUPPORT)
$(BUILD_DIR)\acpitbl.exe: $(ACPI_TABLE_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\acpitbl.exe,
$(BUILD_DIR)\acpitbl.map;
<<
!endif
#-----------------------------------------------------------------------#
# UUI.EXE is dependent on the BBC OBJs.                                 #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\uui.exe: $(BBC_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\uui.exe,
$(BUILD_DIR)\uui.map;
<<
#-----------------------------------------------------------------------#
# init.EXE is dependent on the INI OBJs.                                #
# To generate init.EXE we need to run the linker.                       #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\init.exe: $(INI_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\init.exe,
$(BUILD_DIR)\init.map,
$(BUILD_DIR)\ioc.lib+
$(CORE_DIR)\io.lib;
<<
#-----------------------------------------------------------------------#
# postrun.EXE is dependent on the post and runtime OBJs.                #
# To generate postrun.EXE we need to run the linker.                    #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\dummyrun.exe: $(RTDUMMY_OBJS) $(RT1_OBJS) $(RTPNP_OBJS) $(RT10_OBJS) $(RT2_OBJS)
      $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\dummyrun.exe,
$(BUILD_DIR)\dummyrun.map,
$(BUILD_DIR)\ioc.lib+
$(CORE_DIR)\io.lib;
<<

$(BUILD_DIR)\dmrun32.exe: $(RT32_0_OBJS)
!if $(DIM_SUPPORT) && (($(INC_EISA) && $(INC_EISA_32)) || $(INC_PCI))
      $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\dmrun32.exe,
$(BUILD_DIR)\dmrun32.map;
<<
!endif

!if $(DIM_SUPPORT) && ($(INC_EISA) || $(INC_PCI))
$(BUILD_DIR)\dr.asm $(BUILD_DIR)\rt32strt.asm: $(BUILD_DIR)\dummyrun.exe $(BUILD_DIR)\dmrun32.exe
    debug <$(CORE_DIR)\runtim32.dat >nul
    @$(ASM) /c /I$(INC_DIR) /Fo$(BUILD_DIR)\dr.obj $(BUILD_DIR)\dr.asm
    @$(ASM) /c /I$(INC_DIR) /Fo$(BUILD_DIR)\rt32strt.obj $(BUILD_DIR)\rt32strt.asm
!else
$(BUILD_DIR)\dr.asm: $(BUILD_DIR)\dummyrun.exe $(BUILD_DIR)\dmrun32.exe
    debug <$(CORE_DIR)\runtime.dat >nul
    @$(ASM) /c /I$(INC_DIR) /Fo$(BUILD_DIR)\dr.obj $(BUILD_DIR)\dr.asm
!endif

$(BUILD_DIR)\postrun.exe: $(POST_OBJS) $(RT0_OBJS) $(RT1_OBJS) $(RTPNP_OBJS) $(RT10_OBJS) $(RT2_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\postrun.exe,
$(BUILD_DIR)\postrun.map,
$(BUILD_DIR)\ioc.lib+
$(CORE_DIR)\io.lib+
jmpp.lib;
<<
#-----------------------------------------------------------------------#
# setrun.EXE is dependent on the setup and runtime OBJs.                #
# To generate setrun.EXE we need to run the linker.                     #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\setrun.exe: $(SETUP_OBJS) $(RT0_OBJS) $(RT1_OBJS) $(RTPNP_OBJS) $(RT10_OBJS) $(RT2_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\setrun.exe,
$(BUILD_DIR)\setrun.map,
$(BUILD_DIR)\ioc.lib+
$(CORE_DIR)\io.lib+
jmps.lib;
<<
#-----------------------------------------------------------------------#
# INT13.EXE is dependent on the INT13 OBJs.                             #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\INT13.exe: $(INT13_RUNTIME_OBJS) $(INT13_POST_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\int13.exe,
$(BUILD_DIR)\int13.map;
<<
#-----------------------------------------------------------------------#
# The following commands create the necessary .INC files according to   #
# the selected I/O peripherals.                                         #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\bkbcrtc.inc: $(MKF)
        $(COPY) << $(BUILD_DIR)\bkbcrtc.inc
$(BOOT_KBC_RTC: =^
DefineDevice )
<<

$(BUILD_DIR)\bfdc.inc: $(MKF)
        $(COPY) << $(BUILD_DIR)\bfdc.inc
$(BOOT_FDC: =^
DefineDevice )
<<

$(BUILD_DIR)\io.inc: $(MKF)
        $(COPY) << $(BUILD_DIR)\io.inc
$(IO_PERIPHERALS: =^
DefineDevice )
<<
#-----------------------------------------------------------------------#
# These are commands that are used to generate OBJ files from ASM files.#
#-----------------------------------------------------------------------#
SSP_FILES = $(**:\=\\)
!if $(I2O_SUPPORT)
$(BUILD_DIR)\setupequ.ext : $(CORE_SSP_PATH)i2o.ssp $(CORE_SSP_PATH)core.ssp $(SYS_PORT_PATH)advanced.ssp $(SYS_PORT_PATH)chipset.ssp $(GPC_PORT_PATH)power.ssp $(DIM_PORT_PATH)pcipnp.ssp $(BUILD_DIR)\io.inc $(IO_PATH)io.ssp $(IO_PORT_PATH)ioc.ssp
!else
$(BUILD_DIR)\setupequ.ext : $(CORE_SSP_PATH)core.ssp $(SYS_PORT_PATH)advanced.ssp $(SYS_PORT_PATH)chipset.ssp $(GPC_PORT_PATH)power.ssp $(DIM_PORT_PATH)pcipnp.ssp $(BUILD_DIR)\io.inc $(IO_PATH)io.ssp $(IO_PORT_PATH)ioc.ssp
!endif
   @$(SSP) $(BUILD_DIR)\ <<
include "$(SSP_FILES: ="^
include ")"
<<

$(BUILD_DIR)\oemcore.dir: $(OEM_DIR)\oemcore.mod\*.asm
   @dir /b $(OEM_DIR)\oemcore.mod\*.asm > $(BUILD_DIR)\oemcore.dir
   @!$(ASM) @$(BUILD_DIR)\asm.rsp /I$(OEM_DIR)\oemcore.mod /I..\..\..\asm1 /Fo$(BUILD_DIR)\$(**F:.ASM=.OBJ) $**
   @if EXIST $(OEM_DIR)\oemcore.mod\jmp.asm $(COPY) $(CORE_DIR)\cf*.obj $(BUILD_DIR)
#   @if EXIST $(OEM_DIR)\oemcore.mod\jmp.asm ml @$(BUILD_DIR)\asm.rsp /DPOST /Fo$(BUILD_DIR)\cfp.obj $(OEM_DIR)\oemcore.mod\cf.asm
   @if EXIST $(BUILD_DIR)\jmpp.lib $(DELETE) $(BUILD_DIR)\jmpp.lib
   @if EXIST $(OEM_DIR)\oemcore.mod\jmp.asm $(LIBRARY) $(BUILD_DIR)\jmpp.lib +$(BUILD_DIR)\jmp.obj +$(BUILD_DIR)\cfp.obj;
   @if EXIST $(BUILD_DIR)\jmps.lib $(DELETE) $(BUILD_DIR)\jmps.lib
   @if EXIST $(OEM_DIR)\oemcore.mod\jmp.asm $(LIBRARY) $(BUILD_DIR)\jmps.lib +$(BUILD_DIR)\jmp.obj +$(BUILD_DIR)\cf.obj;

$(BUILD_DIR)\coremod.dir: $(CORE_MOD_DIR)\*.asm
   @dir /b $(CORE_MOD_DIR)\*.asm > $(BUILD_DIR)\coremod.dir
   @!$(ASM) @$(BUILD_DIR)\asm.rsp /Fo$(BUILD_DIR)\$(**F:.ASM=.OBJ) $**
   @if EXIST $(CORE_MOD_DIR)\jmp.asm ml @$(BUILD_DIR)\asm.rsp /DPOST /Fo$(BUILD_DIR)\cfp.obj $(CORE_MOD_DIR)\cf.asm
   @if EXIST $(BUILD_DIR)\jmpp.lib $(DELETE) $(BUILD_DIR)\jmpp.lib
   @if EXIST $(CORE_MOD_DIR)\jmp.asm $(LIBRARY) $(BUILD_DIR)\jmpp.lib +$(BUILD_DIR)\jmp.obj +$(BUILD_DIR)\cfp.obj;
   @if EXIST $(BUILD_DIR)\jmps.lib $(DELETE) $(BUILD_DIR)\jmps.lib
   @if EXIST $(CORE_MOD_DIR)\jmp.asm $(LIBRARY) $(BUILD_DIR)\jmps.lib +$(BUILD_DIR)\jmp.obj +$(BUILD_DIR)\cf.obj;

$(BUILD_DIR)\ioc.lib: $(IO_DIR)\*.asm $(OEM_DIR)\OEMIO.MOD\*.asm
   @!$(ASM) @$(BUILD_DIR)\asm.rsp /Fo$(BUILD_DIR)\$(**F:.ASM=.OBJ) $**
   @if EXIST $(BUILD_DIR)\ioc.lib $(DELETE) $(BUILD_DIR)\ioc.lib
   @!$(LIBRARY) $(BUILD_DIR)\ioc.lib +$(BUILD_DIR)\$(**F:.ASM=.OBJ), $(BUILD_DIR)\ioc.pub; $**

{$(BUILD_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(INC_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(CPU_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(SYS_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(SYS_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(GPC_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(USB_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(USB_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(MP_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AMPFLAGS) $<

{$(MP_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AMPFLAGS) $<

{$(DIM_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(DIM_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(OEM_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

{$(OEM_DIR)\OEMCHIP.MOD}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<

!if $(ACPI_SUPPORT)
{$(ACPI_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(AFLAGS) $<
!endif
#-----------------------------------------------------------------------#
# Following command generates the MAKEFLAG.EQU file for all ASM files.  #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\makeflag.equ: $(MKF) $(BUILD_DIR)\oemmake.equ
        $(COPY) << + $(BUILD_DIR)\oemmake.equ $(BUILD_DIR)\makeflag.equ
MKF_ML_MODULE           equ     $(ML_MODULE)
MKF_NO_LANGUAGES        equ     $(NO_LANGUAGES)
                                        ; (CORE0218+)>
!if $(EVENT_LOG)
MKF_EVENT_LOG           equ     -1
!else
MKF_EVENT_LOG           equ     0
!endif
                                        ; <(CORE0218+)
                                        ; (CORE0211+)>
!if $(BOOTBLOCK_LS120)
MKF_BOOTBLOCK_LS120     equ     -1
!else
MKF_BOOTBLOCK_LS120     equ     0
!endif
                                        ; <(CORE0211+)
                                        ; (CORE0210+)>
!if $(CNVRAM)
MKF_CNVRAM              equ -1
!else
MKF_CNVRAM              equ 0
!endif
                                        ; <(CORE0210+)
MKF_CUSTOMER    equ     $(REF_NUMBER)
                                        ; (CORE0072+)>
!if $(GPNV_SUPPORT)
MKF_GPNV_SUPPORT   equ -1
!if $(GPNV_FLASH)
MKF_GPNV_FLASH     equ -1
!else
MKF_GPNV_FLASH     equ 0
!endif
!else
MKF_GPNV_SUPPORT   equ 0
MKF_GPNV_FLASH     equ 0
!endif
                                        ; <(CORE0072+)

                                        ; (CORE0071+)>
!if ("$(BIOS_SIZE)" == "2")
MKF_256K_BIOS     equ -1
!else
MKF_256K_BIOS     equ 0
!endif
                                        ; <(CORE0071+)
!if ("$(IO_INDEX_PORT)" == "")
MKF_IO_INDEX_PORT equ   0FFFFh
!else
MKF_IO_INDEX_PORT equ   $(IO_INDEX_PORT)
!endif
!if ("$(IO_DATA_PORT)" == "")
MKF_IO_DATA_PORT equ    0FFFFh
!else
MKF_IO_DATA_PORT equ    $(IO_DATA_PORT)
!endif
!if ("$(IO_UNLOCK_DATA)" == "")
MKF_IO_UNLOCK_DATA equ  0FFh
!else
MKF_IO_UNLOCK_DATA equ  $(IO_UNLOCK_DATA)
!endif
!if ("$(IO_ISA_PNP_DATA_PORT)" == "")
MKF_IO_ISA_PNP_DATA_PORT equ    0FFFFh
!else
MKF_IO_ISA_PNP_DATA_PORT equ    $(IO_ISA_PNP_DATA_PORT)
!endif

!if $(EXTRA_INT16) && $(EXTRA_INT16_F0)
MKF_EXTRA_INT16_F0 equ -1
!else
MKF_EXTRA_INT16_F0 equ 0
!endif

!if $(CTRL_ALT)
MKF_CTRL_ALT      equ -1
!else
MKF_CTRL_ALT      equ 0
!endif

!if $(TURBO_SWITCH)
MKF_TURBO_SWITCH  equ -1
!else
MKF_TURBO_SWITCH  equ 0
!endif

!if $(KB_PS2_CONNECTOR_SWAP)
MKF_KB_PS2_CONNECTOR_SWAP equ -1
!else
MKF_KB_PS2_CONNECTOR_SWAP equ 0
!endif

!if $(BAD_PNP_CARD)
MKF_BAD_PNP_CARD  equ -1
!else
MKF_BAD_PNP_CARD  equ 0
!endif

MKF_NCPU          equ $(NCPU)

!if $(INC_PCI) && $(VUMA_SUPPORT)
MKF_VUMA_SUPPORT  equ -1
!else
MKF_VUMA_SUPPORT  equ 0
!endif

!if $(INC_PCI) && $(SMBA_SUPPORT)
MKF_SMBA_SUPPORT  equ -1
!else
MKF_SMBA_SUPPORT  equ 0
!endif

!if $(MPS_SUPPORT)
MKF_MPS_SUPPORT   equ -1
!if $(EXTENDED_APIC)
MKF_EXTENDED_APIC equ -1
!else
MKF_EXTENDED_APIC equ 0
!endif
!else
MKF_MPS_SUPPORT   equ 0
MKF_EXTENDED_APIC equ 0
!endif

!if $(EVAL)
MKF_EVAL          equ -1
!else
MKF_EVAL          equ 0
!endif
!if $(BUP6)
MKF_BUP6          equ -1
!else
MKF_BUP6          equ 0
!endif
!if $(FLASH_4GB)
MKF_FLASH_4GB     equ -1
!else
MKF_FLASH_4GB     equ 0
!endif
!if $(INDEX_DATA)
MKF_INDEX_DATA    equ -1
!else
MKF_INDEX_DATA    equ 0
!endif
!if $(NO_NVRAM)
MKF_NO_NVRAM      equ -1
!else
MKF_NO_NVRAM      equ 0
!endif
!if $(INTEL)
MKF_INTEL         equ -1
!else
MKF_INTEL         equ 0
!endif
!if $(SST)
MKF_SST           equ -1
!else
MKF_SST           equ 0
!endif
!if $(ATMEL)
MKF_ATMEL         equ -1
!else
MKF_ATMEL         equ 0
!endif
!if $(WINBOND)
MKF_WINBOND       equ -1
!else
MKF_WINBOND       equ 0
!endif
!if $(AMD)
MKF_AMD           equ -1
!else
MKF_AMD           equ 0
!endif
!if $(MXIC)
MKF_MXIC          equ -1
!else
MKF_MXIC          equ 0
!endif
!if $(MXIC_P)
MKF_MXIC_P        equ -1
!else
MKF_MXIC_P        equ 0
!endif
!if $(MXIC_T)
MKF_MXIC_T        equ -1
!else
MKF_MXIC_T        equ 0
!endif
                                        ; (CORE0224+)>
!if $(PMC29F002T)
MKF_PMC29F002T          equ -1
!else
MKF_PMC29F002T          equ 0
!endif
                                        ; <(CORE0224+)
                                        ; (CORE0208+)>
!if $(MXIC_29F002T)
MKF_MXIC_29F002T        equ -1
!else
MKF_MXIC_29F002T        equ 0
!endif
                                        ; <(CORE0208+)
                                        ; (CORE0213+)>
!if $(MXIC_29F001T)
MKF_MXIC_29F001T        equ -1
!else
MKF_MXIC_29F001T        equ 0
!endif
                                        ; <(CORE0213+)
                                        ; (CORE0215+)>
!if $(MOSEL_V29C51002T)
MKF_MOSEL_V29C51002T    equ -1
!else
MKF_MOSEL_V29C51002T    equ 0
!endif
                                        ; <(CORE0215+)
                                        ; (CORE0216+)>
!if $(AT49F002T)
MKF_AT49F002T           equ -1
!else
MKF_AT49F002T           equ 0
!endif
                                        ; <(CORE0216+)
!if $(BOOT_BLOCK)
MKF_BOOT_BLOCK    equ -1
!else
MKF_BOOT_BLOCK    equ 0
!endif
!if $(AFTER_PGM)
MKF_AFTER_PGM     equ -1
!else
MKF_AFTER_PGM     equ 0
!endif
!if $(DIM_SUPPORT)
MKF_DIM_SUPPORT   equ -1
!else
MKF_DIM_SUPPORT   equ 0
!endif
!if $(INC_ISA)
MKF_INC_ISA       equ -1
!else
MKF_INC_ISA       equ 0
!endif
!if $(INC_EISA)
MKF_INC_EISA      equ -1
!else
MKF_INC_EISA      equ 0
!endif
!if $(INC_EISA_32)
MKF_INC_EISA_32   equ -1
!else
MKF_INC_EISA_32   equ 0
!endif
!if $(INC_PCI)
MKF_INC_PCI       equ -1
!else
MKF_INC_PCI       equ 0
!endif
!if $(PCI_BRIDGE)
MKF_PCI_BRIDGE    equ -1
!else
MKF_PCI_BRIDGE    equ 0
!endif
!if $(MULTI_HOST_BR)
MKF_MULTI_HOST_BR equ -1
!else
MKF_MULTI_HOST_BR equ 0
!endif
!if $(PCI_MANUAL)
MKF_PCI_MANUAL    equ -1
!else
MKF_PCI_MANUAL    equ 0
!endif
!if $(INC_PNP)
MKF_INC_PNP       equ -1
!else
MKF_INC_PNP       equ 0
!endif
!if $(WRITE_ESCD)
MKF_WRITE_ESCD    equ -1
!else
MKF_WRITE_ESCD    equ 0
!endif
!if $(NONEISA_NVRAM)
MKF_NONEISA_NVRAM equ -1
!else
MKF_NONEISA_NVRAM equ 0
!endif
!if $(NVRAM_FLASH)
MKF_NVRAM_FLASH   equ -1
!else
MKF_NVRAM_FLASH   equ 0
!endif
!if $(NVRAM_DALLAS)
MKF_NVRAM_DALLAS  equ -1
!else
MKF_NVRAM_DALLAS  equ 0
!endif
!if $(FLOPPY_3MODE)
MKF_FLOPPY_3MODE  equ -1
!else
MKF_FLOPPY_3MODE  equ 0
!endif
!if $(SILENT_BOOT)
MKF_SILENT_BOOT   equ -1
!else
MKF_SILENT_BOOT   equ 0
!endif
!if $(INT10)
MKF_INT10         equ -1
!else
MKF_INT10         equ 0
!endif
!if $(VIRUS)
MKF_VIRUS         equ -1
!else
MKF_VIRUS         equ 0
!endif
MKF_CDROM         equ -1
!if $(FLOPTICAL)
MKF_FLOPTICAL     equ -1
!else
MKF_FLOPTICAL     equ 0
!endif
!if $(EXTRA_INT16)
MKF_EXTRA_INT16   equ -1
!else
MKF_EXTRA_INT16   equ 0
!endif
!if $(DISP_PCIPNP)
MKF_DISP_PCIPNP   equ -1
!else
MKF_DISP_PCIPNP   equ 0
!endif
!if $(MEGAKEY)
MKF_MEGAKEY       equ -1
!else
MKF_MEGAKEY       equ 0
!endif
!if $(ACPI_SUPPORT)
MKF_ACPI_SUPPORT   equ -1
! if $(ACPI_APIC_TBL)
MKF_ACPI_APIC_TBL  equ -1
! else
MKF_ACPI_APIC_TBL  equ 0
! endif
! if $(ACPI_QUICK_BOOT)
MKF_ACPI_QUICK_BOOT  equ -1
! else
MKF_ACPI_QUICK_BOOT  equ 0
! endif
! if $(ACPI_S4BIOS)
MKF_ACPI_S4BIOS  equ -1
! else
MKF_ACPI_S4BIOS  equ 0
! endif
!else
MKF_ACPI_SUPPORT   equ 0
MKF_ACPI_APIC_TBL  equ 0
MKF_ACPI_S4BIOS    equ 0
MKF_ACPI_QUICK_BOOT  equ 0
!endif
!if $(GPC_SUPPORT)
MKF_GPC_SUPPORT   equ -1
!else
MKF_GPC_SUPPORT   equ 0
!endif
!if $(GPC_SUPPORT) && $(USB_SUPPORT)
MKF_USB_SUPPORT   equ -1
!if $(USB_UHCI_OHCI)
MKF_USB_UHCI      equ 0
MKF_USB_OHCI      equ -1
!else
MKF_USB_UHCI      equ -1
MKF_USB_OHCI      equ 0
!endif
!else
MKF_USB_SUPPORT   equ 0
!endif
!if $(DMI_SUPPORT)
MKF_DMI_SUPPORT   equ -1
!else
MKF_DMI_SUPPORT   equ 0
!endif
!if $(SUI_SUPPORT)
MKF_SUI_SUPPORT   equ -1
!else
MKF_SUI_SUPPORT   equ 0
!endif
!if $(CPU_OVERRIDE)
MKF_CPU_OVERRIDE  equ -1
!else
MKF_CPU_OVERRIDE  equ 0
!endif
; $$$CORE0021+>
MKF_TREND_ANTI_VIRUS equ 0$(TREND_ANTI_VIRUS)h
; <$$$CORE0021+
; $$$CORE0047+>
!if $(I2O_SUPPORT)
MKF_I2O_SUPPORT   equ -1
!else
MKF_I2O_SUPPORT   equ 0
!endif
; <$$$CORE0047+
<<
#-----------------------------------------------------------------------#
# Following command generates the ASMMP.RSP file for all Flags.         #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\asmmp.rsp: $(MKF)
        $(COPY) << $(BUILD_DIR)\asmmp.rsp
/nologo /c /X
/I$(BUILD_DIR)
/I$(OEM_DIR)
/I$(OEM_PORT_DIR)
/I$(OEM_DIR)\OEMCHIP.MOD
/I$(OEM_DIR)\OEMCORE.MOD
/I$(INC_PORT_DIR)
/I$(INC_DIR)
/I$(SYS_PORT_DIR)
/I$(SYS_DIR)
/I$(DIM_PORT_DIR)
/I$(DIM_DIR)
/I$(GPC_PORT_DIR)
/I$(GPC_DIR)
/I$(MP_PORT_DIR)
/I$(MP_DIR)
/I$(USB_PORT_DIR)
/I$(USB_DIR)
/I$(ACPI_PORT_DIR)
!if $(INC_ISA)
/DINC_ISA
!endif
!if $(INC_EISA)
/DINC_EISA
!endif
!if $(INC_PNP)
/DINC_PNP
!endif
!if $(INC_PCI)
/DINC_PCI
!endif
!ifdef OEM_ID
/DOEM=$(OEM_ID)
!else
/DOEM=
!endif
!ifdef PRODUCT_ID
/DPROD=$(PRODUCT_ID)
!else
/DPROD=
!endif
/DPC=$(NCPU)
<<
#-----------------------------------------------------------------------#
# Following command generates the ASM.RSP file for all Flags.           #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\asm.rsp: $(MKF) $(BUILD_DIR)\asmmp.rsp
        $(COPY) /b << +$(BUILD_DIR)\asmmp.rsp $(BUILD_DIR)\asm.rsp
!if $(INC_ISA)
/DISA=I_ISA
!endif
!if $(INC_EISA)
/DEISA=I_EISA
!endif
!if $(INC_PNP)
/DPNP=I_PNP
!endif
!if $(INC_PCI)
/DPCI=I_PCI
!endif
<<
# (CORE0071)>
#-----------------------------------------------------------------------#
# The following command generates the .BBP file for AMIBBP.EXE.         #
#-----------------------------------------------------------------------#
BIOS_TAG = $(PROJECT_PATH)$(PROJECT_BUILD)
$(BUILD_DIR)\$(BIOSFILE).bbp: $(MKF)
        $(COPY) << $(BUILD_DIR)\$(BIOSFILE).bbp

[Init]
File = $(BUILD_DIR)\$(BIOSFILE).INI

[BIOS]
tag = $(BIOS_TAG)
!if ("$(BIOS_SIZE)" == "2")
size = 8
!else
!       if ("$(BIOS_SIZE)" == "1")
size = 4
!       else
size = 2
!       endif
!endif
File = $(BUILD_DIR)\$(BIOSFILE).ROM
!if $(DIM_SUPPORT) && $(INC_EISA)
Eisa_Support = yes
!endif
!if $(DIM_SUPPORT) && $(INC_PCI)
Pci_Support = yes
!endif
!if $(DIM_SUPPORT) && $(INC_PNP)
Pnp_Support = yes
!endif
!if $(GPC_SUPPORT)
Apm_Support = yes
!endif
!if $(BOOT_BLOCK)
Flash_Support = yes
!endif
!if ($(DIM_SUPPORT) && $(INC_EISA)) || ($(DIM_SUPPORT) && $(INC_PNP) && $(NONEISA_NVRAM))
Escd_Support = yes
!endif
Cdrom_Support = yes
!if $(INT10)
Int10_Support = yes
!endif
!if $(FLOPPY_3MODE)
Floppy3mode_Support = yes
!endif

[Interface]
ModuleID = 08
compressed = no
File = $(BUILD_DIR)\$(BIOSFILE).BBC
Destn = 0000:0000

[SetupServer]
ModuleID = 01
!if $(SPLIT_ROM)
compressed = no
!else
compressed = yes
!endif
File = $(BUILD_DIR)\$(BIOSFILE).SET
Destn = F000:0000

[Post]
ModuleID = 00
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).POS
Destn = F000:0000

[Runtime]
ModuleID = 02
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).RUN
Destn = F000:8000

!if $(SUI_SUPPORT)
[SetupClient]
ModuleID=04
compressed=yes
Destn=0000:0000
file = $(SUI_FILE)
!endif

!if $(DIM_SUPPORT)
[DIM]
ModuleID = 03
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).DIM
Destn = E000:8000
!endif

!if $(MPS_SUPPORT)
[MP]
ModuleID = 09
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).MPS
Destn = 0000:0000
!endif

!if $(GPC_SUPPORT)
[GreenPC]
ModuleID = 07
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).GPC
Destn = 0000:0000
!endif

!if $(INT10)
[INT10]
ModuleID = 0B
compressed = yes
File = $(CORE_DIR)\INT10.BIN
Destn = F000:F065
!endif

[INT13]
ModuleID = 0D
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).I13
Destn = 0000:0000

!if $(ACPI_SUPPORT)
[ACPITable]
ModuleID = 0F
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).ACP
Destn = 0000:0000
!endif

!if $(ACPI_SUPPORT)
[ACPIAML]
ModuleID = 10
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).AML
Destn = 0000:0000
!endif

!if $(BUP6)
[CPUMicroCode]
ModuleID = 11
compressed = no
File = $(BUILD_DIR)\$(BIOSFILE).P6M
Destn = 0000:0000
!endif

!if $(DMI_SUPPORT)
[DMI]
ModuleID = 06
compressed = no
File = $(BUILD_DIR)\$(BIOSFILE).DMI
Destn = 0000:0000

[DMICode]
ModuleID = 13
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).SMC
Destn = 0000:0000
!endif
<<
# <(CORE0071)
#-----------------------------------------------------------------------#
# These are all of the OBJ files and their dependencies.                #
#-----------------------------------------------------------------------#

$(BUILD_DIR)\mpfpstr.obj:     $(MKF) $(TEMP_INC_FILES) $(MP_PATH)mpfpstr.asm
$(BUILD_DIR)\mptable.obj:     $(MKF) $(TEMP_INC_FILES) $(MP_PATH)mptable.asm

#(CORE0072-)>
#$(BUILD_DIR)\npostdmi.obj:    $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)npostdmi.asm $(BUILD_DIR)\setupequ.ext
#$(BUILD_DIR)\nrundmi.obj:     $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)nrundmi.asm $(BUILD_DIR)\setupequ.ext
#$(BUILD_DIR)\dmirdm.obj:      $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)dmirdm.asm $(BUILD_DIR)\setupequ.ext
#<(CORE0072-)

$(BUILD_DIR)\setupdat.obj:    $(MKF) $(TEMP_INC_FILES) $(BUILD_DIR)\setupdat.asm $(BUILD_DIR)\io.inc
$(BUILD_DIR)\setupequ.obj:    $(MKF) $(TEMP_INC_FILES) $(BUILD_DIR)\setupequ.asm $(BUILD_DIR)\io.inc
$(BUILD_DIR)\setuprd.obj:     $(MKF) $(TEMP_INC_FILES) $(BUILD_DIR)\setuprd.asm $(BUILD_DIR)\io.inc $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\setupmsg.obj:    $(MKF) $(TEMP_INC_FILES) $(BUILD_DIR)\setupmsg.asm $(BUILD_DIR)\io.inc

$(BUILD_DIR)\postcpu.obj:     $(MKF) $(TEMP_INC_FILES) $(CPU_PATH)postcpu.asm $(CPU_PATH)pintel.inc $(CPU_PATH)pcyrix.inc $(CPU_PATH)pamd.inc $(CPU_PATH)pibm.inc $(CPU_PATH)pti.inc $(CPU_PATH)psgs.inc $(CPU_PATH)pumc.inc $(CPU_PATH)pidt.inc $(CPU_PATH)prise.inc $(CPU_PATH)CPU.CFG
$(BUILD_DIR)\runcpu.obj:      $(MKF) $(TEMP_INC_FILES) $(CPU_PATH)runcpu.asm $(CPU_PATH)rintel.inc $(CPU_PATH)rcyrix.inc $(CPU_PATH)ramd.inc $(CPU_PATH)ribm.inc $(CPU_PATH)rti.inc $(CPU_PATH)rsgs.inc $(CPU_PATH)rumc.inc $(CPU_PATH)ridt.inc $(CPU_PATH)rrise.inc $(CPU_PATH)CPU.CFG
$(BUILD_DIR)\cpudata.obj:     $(MKF) $(TEMP_INC_FILES) $(INC_DIR)\cpudata.asm

$(BUILD_DIR)\bup6.obj:        $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)bup6.asm
$(BUILD_DIR)\devinfo.obj:     $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)devinfo.asm
$(BUILD_DIR)\dflsinfo.obj:    $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)dflsinfo.asm
$(BUILD_DIR)\extfunc.obj:     $(MKF) $(TEMP_INC_FILES) $(SYS_PORT_PATH)extfunc.asm $(BUILD_DIR)\io.inc
$(BUILD_DIR)\flash.obj:       $(MKF) $(TEMP_INC_FILES) $(SYS_PORT_PATH)flash.asm $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\flashio.obj:     $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)flashio.asm $(BUILD_DIR)\bkbcrtc.inc $(BUILD_DIR)\bfdc.inc
$(BUILD_DIR)\flsinfo.obj:     $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)flsinfo.asm
$(BUILD_DIR)\i16.obj:         $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)i16.asm $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\i16dm.obj:       $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)i16dm.asm
$(BUILD_DIR)\io.obj:          $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)io.asm $(BUILD_DIR)\io.inc
$(BUILD_DIR)\memory.obj:      $(MKF) $(TEMP_INC_FILES) $(SYS_PORT_PATH)memory.asm $(BUILD_DIR)\setuprd.asm  $(BUILD_DIR)\setupequ.ext $(MEMORY_INCS)
$(BUILD_DIR)\nextfunc.obj:    $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)nextfunc.asm $(BUILD_DIR)\io.inc
$(BUILD_DIR)\npost.obj:       $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)npost.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\nruntime.obj:    $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)nruntime.asm $(BUILD_DIR)\setuprd.asm $(NRUNTIME_INCS)
$(BUILD_DIR)\nsetup.obj:      $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)nsetup.asm $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\portswap.obj:    $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)portswap.asm
$(BUILD_DIR)\post.obj:        $(MKF) $(TEMP_INC_FILES) $(SYS_PORT_PATH)post.asm $(BUILD_DIR)\setuprd.asm $(POST_INCS)
$(BUILD_DIR)\p6clk.obj:       $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)p6clk.asm
$(BUILD_DIR)\runtime.obj:     $(MKF) $(TEMP_INC_FILES) $(BUILD_DIR)\ioc.lib $(SYS_PORT_PATH)runtime.asm $(BUILD_DIR)\setuprd.asm $(RUNTIME_INCS)
$(BUILD_DIR)\setup.obj:       $(MKF) $(TEMP_INC_FILES) $(SYS_PORT_PATH)setup.asm $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\turbo.obj:       $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)turbo.asm

$(BUILD_DIR)\message.obj:     $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)message.asm
# (CORE0205-)>
#!if $(ML_MODULE)
#$(BUILD_DIR)\devinfoc.obj:     $(MKF) $(TEMP_INC_FILES) $(SYS_PATH)devinfoc.asm
#!endif
# <(CORE0205-)
$(BUILD_DIR)\mppost.obj:      $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)mppost.asm
$(BUILD_DIR)\oemiotbl.obj:    $(MKF) $(TEMP_INC_FILES) $(IO_PATH)oemiotbl.asm $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\oempost.obj:     $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)oempost.asm $(BUILD_DIR)\setuprd.asm $(POST_INCS)
$(BUILD_DIR)\oemsetup.obj:    $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)oemsetup.asm $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\oemmemry.obj:    $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)oemmemry.asm $(BUILD_DIR)\setuprd.asm  $(BUILD_DIR)\setupequ.ext $(MEMORY_INCS)
$(BUILD_DIR)\oemflash.obj:    $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)oemflash.asm $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\oemrun.obj:      $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)oemrun.asm $(BUILD_DIR)\setuprd.asm $(RUNTIME_INCS)
$(BUILD_DIR)\oempdim.obj:     $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)oempdim.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\oemrpci.obj:     $(MKF) $(TEMP_INC_FILES) $(OEM_PATH)oemrpci.asm

$(BUILD_DIR)\gapmnsmi.obj:    $(MKF) $(TEMP_INC_FILES) $(GPC_PATH)gapmnsmi.asm $(APM_INCS) $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\gpm.obj:         $(MKF) $(TEMP_INC_FILES) $(GPC_PATH)gpm.asm $(GPM_INCS) $(BUILD_DIR)\setupequ.ext

$(BUILD_DIR)\postusb.obj:     $(MKF) $(TEMP_INC_FILES) $(USB_PATH)postusb.asm $(USB_INCS)
$(BUILD_DIR)\runusb.obj:      $(MKF) $(TEMP_INC_FILES) $(USB_PORT_PATH)runusb.asm $(USB_INCS)
$(BUILD_DIR)\gpcusb.obj:      $(MKF) $(TEMP_INC_FILES) $(USB_PORT_PATH)gpcusb.asm $(USB_INCS)

!if $(ACPI_SUPPORT)
$(BUILD_DIR)\postacpi.obj:    $(MKF) $(TEMP_INC_FILES) $(ACPI_PORT_PATH)postacpi.asm $(ACPI_INCS)
$(BUILD_DIR)\runacpi.obj:     $(MKF) $(TEMP_INC_FILES) $(ACPI_PORT_PATH)runacpi.asm $(ACPI_INCS)
$(BUILD_DIR)\acpitbl.obj:     $(MKF) $(TEMP_INC_FILES) $(ACPI_PORT_PATH)acpitbl.asm $(ACPI_INCS)
!endif

$(BUILD_DIR)\dbug.obj:        $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)dbug.asm

$(BUILD_DIR)\postdim.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PORT_PATH)postdim.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\pcifb.obj:       $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)pcifb.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\runvuma.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)runvuma.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\runsmba.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)runsmba.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\runfb.obj:       $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)runfb.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\npostdim.obj:    $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)npostdim.asm $(BUILD_DIR)\setuprd.asm
$(BUILD_DIR)\dummynvr.obj:    $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)dummynvr.asm
$(BUILD_DIR)\dalasnvr.obj:    $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)dalasnvr.asm
$(BUILD_DIR)\eisanvr.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)eisanvr.asm
$(BUILD_DIR)\flsnvrg.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)flsnvrg.asm
$(BUILD_DIR)\flsnvrd.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)flsnvrd.asm
$(BUILD_DIR)\flsnvrid.obj:    $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)flsnvrid.asm
$(BUILD_DIR)\runpci.obj:      $(MKF) $(TEMP_INC_FILES) $(DIM_PORT_PATH)runpci.asm
$(BUILD_DIR)\nrunpci.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)nrunpci.asm
$(BUILD_DIR)\runeisa.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)runeisa.asm
$(BUILD_DIR)\pcimhbr.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)pcimhbr.asm
$(BUILD_DIR)\pciman.obj:      $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)pciman.asm
$(BUILD_DIR)\pcinc.obj:       $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)pcinc.asm
$(BUILD_DIR)\rth.obj:         $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)rth.asm
$(BUILD_DIR)\postext.obj:     $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)postext.asm
$(BUILD_DIR)\runext.obj:      $(MKF) $(TEMP_INC_FILES) $(DIM_PATH)runext.asm

$(BUILD_DIR)\prunext.obj:     $(DIM_PATH)runext.asm $(MKF) $(TEMP_INC_FILES)
   @$(ASM) $(AFLAGS) /DRT32 %s

$(BUILD_DIR)\pnrunpci.obj:    $(DIM_PATH)nrunpci.asm $(MKF) $(TEMP_INC_FILES)
   @$(ASM) $(AFLAGS) /DRT32 %s

$(BUILD_DIR)\prunpci.obj:     $(DIM_PORT_PATH)runpci.asm $(MKF) $(TEMP_INC_FILES)
   @$(ASM) $(AFLAGS) /DRT32 %s

$(BUILD_DIR)\poemrpci.obj:    $(OEM_PATH)oemrpci.asm $(MKF) $(TEMP_INC_FILES)
   @$(ASM) $(AFLAGS) /DRT32 %s

$(BUILD_DIR)\peisanvr.obj:    $(DIM_PATH)eisanvr.asm $(MKF) $(TEMP_INC_FILES)
   @$(ASM) $(AFLAGS) /DRT32 %s

$(BUILD_DIR)\pruneisa.obj:    $(DIM_PATH)runeisa.asm $(MKF) $(TEMP_INC_FILES)
   @$(ASM) $(AFLAGS) /DRT32 %s

$(BUILD_DIR)\oemiotbb.obj:    $(IO_PATH)oemiotbl.asm $(MKF) $(TEMP_INC_FILES) $(BUILD_DIR)\setupequ.ext
   @$(ASM) $(AFLAGS) /DBOOTBLOCK %s

#---------------------------------------#
# $$$CORE0018+ >>>
$(BUILD_DIR)\epa.bin            : $(CORE_PATH)epa.obj
        $(LINK) %s, $(BUILD_DIR)\epa.exe;
        $(EXE2BIN) $(BUILD_DIR)\epa.exe $(BUILD_DIR)\epa.bin
# $$$CORE0018+ <<<
#---------------------------------------#

!include ..\..\dmi.mak                  # (CORE0072+)
#                                       (CORE0228+)>
!if $(DISP_CONFIG)
!include ..\..\dc.mak
!endif
#                                       <(CORE0228+)
#     *****************************************************************;
#     *****************************************************************;
#     **                                                             **;
#     **      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
#     **                                                             **;
#     **                     All Rights Reserved.                    **;
#     **                                                             **;
#     **           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
#     **                                                             **;
#     **                     Phone (770)-246-8600                    **;
#     **                                                             **;
#     *****************************************************************;
#     *****************************************************************;
