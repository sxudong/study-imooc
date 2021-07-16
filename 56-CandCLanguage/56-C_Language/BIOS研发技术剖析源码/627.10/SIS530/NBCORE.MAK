#*****************************************************************#
#*****************************************************************#
#**								**#
#**	  (C)Copyright 1985-1999, American Megatrends, Inc.	**#
#**								**#
#**			 All Rights Reserved.			**#
#**								**#
#**	       6145-F Northbelt Pkwy, Norcross, GA 30071	**#
#**								**#
#**			 Phone (770)-246-8600			**#
#**								**#
#*****************************************************************#
#*****************************************************************#

NBMKF = #..\..\nbbios.mak ..\..\nbcore.mak ..\..\nbpath.mak
ANBFLAGS	= @$(BUILD_DIR)\asm.rsp /Fo$*.obj

#---------------------------------------------------------------#
# Preset switches						#
#---------------------------------------------------------------#
NB_BIN_DEPS =

#---------------------------------------------------------------#
# Re-defined							#
#---------------------------------------------------------------#
PREBUILD:	$(BUILD_DIR)\asmnb.rsp
$(BUILD_DIR)\asmnb.rsp: $(MKF) $(BUILD_DIR)\asm.rsp

!if $(NB_SUPPORT)

!if "$(NBCSS_CORE_MOD_DIR)"!="$(CORE_MOD_DIR)"
PREBUILD:	$(BUILD_DIR)\corenb.dir
NB_BIN_DEPS=$(NB_BIN_DEPS)\
$(BUILD_DIR)\corenb.dir
!endif
!if "$(NBOEM_CORE_MOD_DIR)"!="$(OEM_DIR)\oemcore.mod"
PREBUILD:	$(BUILD_DIR)\oemcornb.dir
NB_BIN_DEPS=$(NB_BIN_DEPS)\
$(BUILD_DIR)\oemcornb.dir
!endif

#---------------------------------------------------------------#
$(BIOSFILE).rom: 		$(BUILD_DIR)\NB.BIN
$(BIOSFILE).rom: 		$(BUILD_DIR)\nb.bbp

!endif#	!if $(NB_SUPPORT)

#$(BIOSFILE).rom: $(BUILD_DIR)\nbmake.equ
$(BUILD_DIR)\makeflag.equ: $(BUILD_DIR)\nbmake.equ

#---------------------------------------------------------------#
# Adding notebook's BBP						#
#---------------------------------------------------------------#
$(BUILD_DIR)\nb.bbp:   $(MKF)
	@$(COPY) << $(BUILD_DIR)\nb.bbp
[Notebook]
ModuleID = 0A
compressed = Yes
File = $(BUILD_DIR)\NB.BIN
Destn = 0000:0000
<<
	$(COPY) /b $(BUILD_DIR)\$(BIOSFILE).bbp + $(BUILD_DIR)\nb.bbp $(BUILD_DIR)\$(BIOSFILE).bbp

#---------------------------------------------------------------#
# Swicthes adjustment						#
#---------------------------------------------------------------#
NB_BIN_DEPS=$(NB_BIN_DEPS)\
$(BUILD_DIR)\nb.exe


!if $(NB_SUPPORT)
#---------------------------------------------------------------#
# Added for OBJ.MAK						#
#---------------------------------------------------------------#
SETUP_OBJS = $(SETUP_OBJS)\
$(BUILD_DIR)\nbextfn.obj

RT2_OBJS = $(RT2_OBJS)\
$(NBDSK_CORE_DIR)\nsmi.obj\
$(BUILD_DIR)\cssnsmi.obj\
$(BUILD_DIR)\oemnsmi.obj

!endif# !if $(NB_SUPPORT)

#-----------------------------------------------------------------#
#  NOTEBOOK MAKEFLAG						  #
#-----------------------------------------------------------------#
$(BUILD_DIR)\nbmake.equ: $(MKF)	$(BUILD_DIR)\oemmake.equ
	@$(COPY) << $(BUILD_DIR)\nbmake.equ
!if $(NB_SUPPORT)
MKF_NB_SUPPORT	equ -1
!else
MKF_NB_SUPPORT	equ 0
!endif
!if $(NB_PNP_SUPPORT)
MKF_NB_PNP_SUPPORT	equ	-1
!else
MKF_NB_PNP_SUPPORT	equ	0
!endif
!if $(NB_DOCK_SUPPORT)
MKF_NB_DOCK_SUPPORT	equ	-1
!else
MKF_NB_DOCK_SUPPORT	equ	0
!endif
!if $(NB_INT_IDE_SUPPORT)
MKF_NB_INT_IDE_SUPPORT	equ	-1
!else
MKF_NB_INT_IDE_SUPPORT	equ	0
!endif
!if $(NB_EXT_HDD_SUPPORT)
MKF_NB_EXT_HDD_SUPPORT	equ	-1
!else
MKF_NB_EXT_HDD_SUPPORT	equ	0
!endif
!if $(NB_INT_IDE_EDD_SUPPORT)
MKF_NB_INT_IDE_EDD_SUPPORT	equ	-1
!else
MKF_NB_INT_IDE_EDD_SUPPORT	equ	0
!endif
!if $(NB_EDD_SUPPORT)
MKF_NB_EDD_SUPPORT	equ	-1
!else
MKF_NB_EDD_SUPPORT	equ	0
!endif
<<
	@$(COPY) $(BUILD_DIR)\oemmake.equ + $(BUILD_DIR)\nbmake.equ $(BUILD_DIR)\oemmake.equ

#-----------------------------------------------------------------------#
# These macros defines the include files that are used by each chipset	#
# module. If an include file is changed, NMAKE must rebuild any .ASM	#
# file(s) that use the changed include file.				#
#-----------------------------------------------------------------------#
NB_PM_INCS =\
$(BUILD_DIR)\setuprd.asm\
$(NBOEM_PWR_PORT_PATH)\oempm.dat\
$(NBOEM_PWR_PORT_PATH)\oempm.equ\
$(NBPWR_PORT_PATH)\csspm.dat\
$(NBPWR_PORT_PATH)\csspm.equ

#------------------------------------------------------------------------------#
# Build list of Power Management OBJs needed for BIOS PM		       #
#------------------------------------------------------------------------------#

NB_PM_OBJS =\
# MESSAGE : NB BIOS IS 64K AND BIOS STARTS AT SMRAM SEGMENT : 0000H
$(NBPWR_CORE_PATH)nbmain.obj\
$(NBPWR_CORE_PATH)pinit.obj\
$(NBPWR_CORE_PATH)smi.obj\
$(NBPWR_CORE_PATH)susmisc.obj\
$(NBPWR_CORE_PATH)pmhdd.obj\
$(NBPWR_CORE_PATH)pmhd.obj\
$(NBPWR_CORE_PATH)pmide.obj\
$(NBPWR_CORE_PATH)zvdisp.obj\
$(NBPWR_CORE_PATH)miscdisp.obj\
$(NBPWR_CORE_PATH)miscstr.obj\
$(NBPWR_CORE_PATH)corebios.obj\
$(NBPWR_CORE_PATH)rtc.obj\
$(NBPWR_CORE_PATH)alarm.obj\
$(NBPWR_CORE_PATH)pmdos.obj\
$(NBPWR_CORE_PATH)kbcntlr.obj\
$(NBPWR_CORE_PATH)hotk.obj\
$(NBPWR_CORE_PATH)pmvga.obj\
!if $(NB_VESA_SUPPORT)
$(NBPWR_CORE_PATH)pmvesa.obj\
!else
$(NBPWR_CORE_PATH)pmvesadm.obj\
!endif
!if $(NB_INTEL_CPU_SUPPORT)
$(NBPWR_CORE_PATH)intcpu.obj\
!else
$(NBPWR_CORE_PATH)intcpudm.obj\
!endif
$(NBPWR_CORE_PATH)csegdata.obj\
!if $(NB_INT_IDE_SUPPORT)
$(NBPWR_CORE_PATH)pmint13.obj\
!else
$(NBPWR_CORE_PATH)pmin13dm.obj\
!endif
!if $(NB_EXT_HDD_SUPPORT)
$(NBPWR_CORE_PATH)pmext13.obj\
!else
$(NBPWR_CORE_PATH)pmex13dm.obj\
!endif
!if $(NB_DOS_FILE_SUPPORT)
$(NBPWR_CORE_PATH)dosfile.obj\
!else
$(NBPWR_CORE_PATH)dosfildm.obj\
!endif
!if $(NB_APM12_SUPPORT)
$(NBPWR_CORE_PATH)apm12.obj\
!elseif $(NB_APM11_SUPPORT)
$(NBPWR_CORE_PATH)apm11.obj\
!else
$(NBPWR_CORE_PATH)apm10.obj\
!endif
!if $(NB_PNP_SUPPORT)
$(NBPWR_CORE_PATH)pmpnp.obj\
!endif
$(NBPWR_CORE_PATH)pmdebug.obj\
$(NBPWR_CORE_PATH)end7fff.obj\
# MESSAGE : STARTS AT SMRAM SEGMENT : 8000H
$(NBPWR_CORE_PATH)pmcpu.obj\
!if $(NB_CYRIX_CPU_SUPPORT)
$(NBPWR_CORE_PATH)crxcpu.obj\
!else
$(NBPWR_CORE_PATH)crxcpudm.obj\
!endif
!if $(NB_AMD_CPU_SUPPORT)
$(NBPWR_CORE_PATH)amdcpu.obj\
!else
$(NBPWR_CORE_PATH)amdcpudm.obj\
!endif
$(BUILD_DIR)\setupequ.obj\
$(BUILD_DIR)\csspinit.obj\
!if $(ACPI_SUPPORT)
$(BUILD_DIR)\acpipm.obj\
$(BUILD_DIR)\oemacpi.obj\
!endif
$(BUILD_DIR)\csssmi.obj\
$(BUILD_DIR)\oemsmi.obj\
$(BUILD_DIR)\sus.obj\
$(NBPWR_CORE_PATH)pmcfbcp.obj\
$(BUILD_DIR)\csssus.obj\
$(BUILD_DIR)\cssapm.obj\
!if $(USB_SUPPORT)
$(BUILD_DIR)\gpcusb.obj\
!endif
$(BUILD_DIR)\oemapm.obj\
!if $(NB_APM12_SUPPORT)
$(BUILD_DIR)\oemapm12.obj\
!endif
$(BUILD_DIR)\oemstr.obj\
$(BUILD_DIR)\oemhotk.obj\
!if $(NB_DOCK_SUPPORT)
$(BUILD_DIR)\oemdock.obj\
!else
$(NBPWR_CORE_PATH)dockdm.obj\
!endif
$(BUILD_DIR)\cssbat.obj\
!if $(NB_ESS1688_SUPPORT)
$(NBPWR_CORE_PATH)pmes1688.obj\
!endif
!if $(NB_CT2504_SUPPORT)
$(NBPWR_CORE_PATH)pmct2504.obj\
!endif
!if $(NB_SMB_PRN_SUPPORT) || $(NB_SMB_AMIC51KB_SUPPORT) || $(NB_SMB_PHXM13KB_SUPPORT) || $(NB_SMB_PIIX4_SUPPORT)
$(NBPWR_CORE_PATH)smbus.obj\
!if $(NB_SMB_PHXM13KB_SUPPORT)
$(NBPWR_CORE_PATH)oemsmp13.obj\
!elseif $(NB_SMB_AMIC51KB_SUPPORT)
$(NBPWR_CORE_PATH)oemsma51.obj\
!else
$(NBPWR_CORE_PATH)oemsmprn.obj\
!endif
!else
$(NBPWR_CORE_PATH)smbusdm.obj\
!endif
!if $(NB_SMB_CSS_ACCESS) || $(NB_SMB_PIIX4_SUPPORT)
$(BUILD_DIR)\csssmb.obj\
!endif
!if $(NB_STD_VGA_SUPPORT)
$(NBPWR_CORE_PATH)stdvga.obj\
!else
$(NBPWR_CORE_PATH)stdvgadm.obj\
!endif
!if $(NB_CIR_VGA_SUPPORT)
$(NBPWR_CORE_PATH)cirvga.obj\
!else
$(NBPWR_CORE_PATH)cirvgadm.obj\
!endif
!if $(NB_CT_VGA_SUPPORT)
$(NBPWR_CORE_PATH)cntvga.obj\
!else
$(NBPWR_CORE_PATH)cntvgadm.obj\
!endif
!if $(NB_OEM_VGA_SUPPORT)
$(BUILD_DIR)\oemvga.obj\
!else
$(NBPWR_CORE_PATH)oemvgadm.obj\
!endif
!if $(USB_SUPPORT)
$(BUILD_DIR)\usb.obj\
!if $(USB_UHCI_OHCI)
$(BUILD_DIR)\ohci.obj\
!else
$(BUILD_DIR)\uhci.obj\
!endif
$(BUILD_DIR)\usbkbd.obj\
# (CORE0252+)
!if $(USB_FDD_BOOT)
$(BUILD_DIR)\usbfdu.obj\
!endif
$(BUILD_DIR)\smipci.obj\
!endif
$(NBPWR_CORE_PATH)endfe00.obj
#------------------------------------------------------------------------------#
# NB.BIN is dependent on PMCPU.EXE.  To generate NB.BIN we need to run exe2bin.#
# Since, The code is having org at 8000h, we have to strip out 1st 8000h bytes.#
#------------------------------------------------------------------------------#
$(BUILD_DIR)\nb.bin: $(NBMKF) $(NB_BIN_DEPS)
    debug < <<
n $(BUILD_DIR)\nb.exe
l
fcs:0 ffff 0
l
rcx
0000
rbx
1
n $(BUILD_DIR)\nb.bin
w cs:0000
q
<<

#------------------------------------------------------------------------------#
# NB.EXE is dependent on the pm OBJs.					       #
# To generate NB.EXE we need to run the linker. 			       #
#------------------------------------------------------------------------------#
$(BUILD_DIR)\nb.exe: $(NB_PM_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\nb.exe,
$(BUILD_DIR)\nb.map;
<<

#-----------------------------------------------------------------------#
# Following command generates the ASMNB.RSP file for all Flags. 	#
# It is dependent on asmmp.rsp. 					#
#-----------------------------------------------------------------------#
$(BUILD_DIR)\asmnb.rsp:
	$(COPY) << $(BUILD_DIR)\asmnb.rsp
!if "$(NBOEM_CORE_MOD_DIR)"!="$(OEM_DIR)\oemcore.mod"
/I$(NBOEM_CORE_MOD_DIR)
!endif
!if "$(NBOEM_CHIP_MOD_DIR)" != "$(CHIP_MOD_DIR)"
/I$(NBOEM_CHIP_MOD_DIR)
!endif
!if "$(NBOEM_DSK_PORT_DIR)" != "$(OEM_PORT_DIR)"
/I$(NBOEM_DSK_PORT_DIR)
!endif
!if "$NBOEM_PWR_PORT_DIR)" != "$(OEM_PORT_DIR)"
/I$(NBOEM_PWR_PORT_DIR)
!endif
!if "$(NBCSS_CORE_MOD_DIR)"!="$(CORE_MOD_DIR)"
/I$(NBCSS_CORE_MOD_DIR)
!endif
/I$(NBDSK_PORT_DIR)
/I$(NBPWR_PORT_DIR)
/I$(NB_INC_DIR)
<<
	$(COPY) /b $(BUILD_DIR)\asm.rsp + $(BUILD_DIR)\asmnb.rsp $(BUILD_DIR)\asm.rsp

#-----------------------------------------------------------------------#
# These are commands that are used to generate OBJ files from ASM files.#
#-----------------------------------------------------------------------#

!if "$(NBCSS_CORE_MOD_DIR)" != "$(CORE_MOD_DIR)"
$(BUILD_DIR)\oemcornb.dir: $(NBOEM_CORE_MOD_DIR)\*.asm
   @dir /b /-P $(NBOEM_CORE_MOD_DIR)\*.asm > $(BUILD_DIR)\oemcornb.dir
   @!$(ASM) @$(BUILD_DIR)\asm.rsp /Fo$(BUILD_DIR)\$(**F:.ASM=.OBJ) $**
!endif

!if "$(NBOEM_CORE_MOD_DIR)"!="$(OEM_DIR)\oemcore.mod"
$(BUILD_DIR)\corenb.dir: $(NBCSS_CORE_MOD_DIR)\*.asm
   @dir /b /-P $(NBCSS_CORE_MOD_DIR)\*.asm > $(BUILD_DIR)\corenb.dir
   @!$(ASM) @$(BUILD_DIR)\asm.rsp /Fo$(BUILD_DIR)\$(**F:.ASM=.OBJ) $**
!endif

!if $(NB_ASMCORE)
{$(NBPWR_COREASM_DIR)\}.asm{$(NBPWR_CORE_DIR)\}.obj:
   @$(ASM) $(ANBFLAGS) $<

{$(NBDSK_COREASM_DIR)\}.asm{$(NBDSK_CORE_DIR)\}.obj:
   @$(ASM) $(ANBFLAGS) $<
!endif

{$(NBDSK_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(ANBFLAGS) $<

{$(NBPWR_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(ANBFLAGS) $<

!if "$(NBOEM_DSK_PORT_DIR)" != "$(OEM_PORT_DIR)"
{$(NBOEM_DSK_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(ANBFLAGS) $<
!endif

!if "$NBOEM_PWR_PORT_DIR)" != "$(OEM_PORT_DIR)"
{$(NBOEM_PWR_PORT_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(ANBFLAGS) $<
!endif

!if "$(NBOEM_CHIP_MOD_DIR)" != "$(CHIP_MOD_DIR)"
{$(NBOEM_CHIP_MOD_DIR)\}.asm{$(BUILD_DIR)\}.obj:
   @$(ASM) $(ANBFLAGS) $<
!endif

!if $(ACPI_SUPPORT)
$(BUILD_DIR)\acpipm.obj:	$(NBPWR_PORT_PATH)\acpipm.asm $(NB_PM_INCS)
$(BUILD_DIR)\oemacpi.obj:	$(NBOEM_PWR_PORT_PATH)\oemacpi.asm $(NB_PM_INCS)
!endif
$(BUILD_DIR)\csspinit.obj:	$(NBPWR_PORT_PATH)\csspinit.asm $(NB_PM_INCS)
$(BUILD_DIR)\csssmi.obj:	$(NBPWR_PORT_PATH)\csssmi.asm $(NB_PM_INCS) $(NBPWR_PORT_PATH)\pwrcyrix.inc
$(BUILD_DIR)\cssapm.obj:	$(NBPWR_PORT_PATH)\cssapm.asm $(NB_PM_INCS)
$(BUILD_DIR)\cssbat.obj:	$(NBPWR_PORT_PATH)\cssbat.asm $(NB_PM_INCS)
$(BUILD_DIR)\csssus.obj:	$(NBPWR_PORT_PATH)\csssus.asm $(NB_PM_INCS)
$(BUILD_DIR)\sus.obj:		$(NBPWR_PORT_PATH)\sus.asm $(NB_PM_INCS)
$(BUILD_DIR)\oemsmi.obj:	$(NBOEM_PWR_PORT_PATH)\oemsmi.asm $(NBOEM_PWR_PORT_PATH)\oemsio.inc $(NB_PM_INCS)
$(BUILD_DIR)\oemhotk.obj:	$(NBOEM_PWR_PORT_PATH)\oemhotk.asm $(NB_PM_INCS)
$(BUILD_DIR)\oemapm.obj:	$(NBOEM_PWR_PORT_PATH)\oemapm.asm $(NB_PM_INCS)
$(BUILD_DIR)\oemapm12.obj:	$(NBOEM_PWR_PORT_PATH)\oemapm12.asm $(NB_PM_INCS)
$(BUILD_DIR)\oemdock.obj:	$(NBOEM_PWR_PORT_PATH)\oemdock.asm $(NB_PM_INCS)

$(BUILD_DIR)\cssnsmi.obj:	$(MKF) $(TEMP_INC_FILES) $(NBDSK_PORT_PATH)\cssnsmi.asm $(NB_INCS) $(BUILD_DIR)\setupequ.ext
$(BUILD_DIR)\oemnsmi.obj:	$(MKF) $(TEMP_INC_FILES) $(NBOEM_DSK_PORT_PATH)\oemnsmi.asm $(NB_INCS) $(BUILD_DIR)\setupequ.ext
!if $(NB_DOCK_SUPPORT)
$(BUILD_DIR)\oemndock.obj:	$(MKF) $(TEMP_INC_FILES) $(NBOEM_DSK_PORT_PATH)\oemndock.asm $(NB_INCS) $(BUILD_DIR)\setupequ.ext
!else
$(BUILD_DIR)\oemndkdm.obj:	$(MKF) $(NBOEM_DSK_PORT_PATH)\oemndkdm.asm
!endif


#*****************************************************************#
#*****************************************************************#
#**								**#
#**	  (C)Copyright 1985-1999, American Megatrends, Inc.	**#
#**								**#
#**			 All Rights Reserved.			**#
#**								**#
#**	       6145-F Northbelt Pkwy, Norcross, GA 30071	**#
#**								**#
#**			 Phone (770)-246-8600			**#
#**								**#
#*****************************************************************#
#*****************************************************************#

