#-----------------------------------------------------------------------#
# Redefine MKF variable to make it dependent on DMI.MAK file.		#
# Redefine the files needed to generate the $(BIOSFILE).BBP file.	#
# Define the directories specific to this module files.			#
#-----------------------------------------------------------------------#
#!if $(DMI_SUPPORT)
#MKF		= $(MKF)\
#..\..\dmi.mak
#!endif
!if $(DMI_SUPPORT)
#BBP_FILE	= $(BBP_FILE)+$(BUILD_DIR)\SMBMAKE.BBP
DMIFLAGS	= $(AFLAGS) /I$(BUILD_DIR) /I$(SYS_DIR) /I$(SYS_PORT_DIR)
SMB_PATH	= {$(CHIP_MOD_DIR);$(SYS_DIR)}
SMB_PORT_PATH	= {$(OEM_PORT_DIR);$(SYS_PORT_DIR)}
!endif
#-----------------------------------------------------------------------#
# The $(BUILD_DIR)\$(BIOSFILE).BBP file is dependent on SMBMAKE.BBP.	#
# The $(BUILD_DIR)\MAKEFLAG.EQU file is dependent on SMBMAKE.EQU.	#
#-----------------------------------------------------------------------#
#!if $(DMI_SUPPORT)
#$(BUILD_DIR)\$(BIOSFILE).BBP: $(BUILD_DIR)\SMBMAKE.BBP
#!endif
#-----------------------------------------------------------------------#
# The files for SMB module.						#
#-----------------------------------------------------------------------#
SMB_FILES	= $(SMB_PATH)smb.asm $(SMB_PATH)smbdata.asm $(SMB_PATH)smbrun.asm $(SMB_PATH)smbpost.asm $(SMB_PATH)smbsub.asm
SMB_INC_FILES	= $(SMB_PORT_PATH)smbdesc.def $(SMB_PATH)smbpost.inc $(SMB_PORT_PATH)smb.cfg
#-----------------------------------------------------------------------#
# Build list of OBJs needed for SMB Module				#
#-----------------------------------------------------------------------#
!if $(DMI_SUPPORT)
SMB_RUNTIME_OBJS =\
$(BUILD_DIR)\smb.obj\
$(BUILD_DIR)\smbrun.obj\
$(BUILD_DIR)\smbsub.obj\
$(BUILD_DIR)\smbrune.obj

SMB_POST_OBJS =\
$(BUILD_DIR)\smbpost.obj

SMB_DATA_OBJS =\
$(BUILD_DIR)\smbdata.obj
!endif
#-----------------------------------------------------------------------#
# The .ROM file is dependent on .DMI file.				#
#-----------------------------------------------------------------------#
!if $(DMI_SUPPORT)
#$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).SMD
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).DMI
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).SMC
#$(BIOSFILE).rom: $(BUILD_DIR)\smbmake.equ
#$(BIOSFILE).rom: $(BUILD_DIR)\smbmake.bbp
!endif
#-----------------------------------------------------------------------#
# The .DMI file is dependent on DMI.EXE.				#
#-----------------------------------------------------------------------#
!if $(DMI_SUPPORT)
$(BUILD_DIR)\$(BIOSFILE).SMC: $(BUILD_DIR)\smc.exe
    $(EXE2BIN) $(BUILD_DIR)\smc.exe $(BUILD_DIR)\$(BIOSFILE).SMC
#$(BUILD_DIR)\$(BIOSFILE).SMD: $(BUILD_DIR)\smd.exe
#    $(EXE2BIN) $(BUILD_DIR)\smd.exe $(BUILD_DIR)\$(BIOSFILE).SMD
$(BUILD_DIR)\$(BIOSFILE).DMI: $(BUILD_DIR)\smd.exe
    $(EXE2BIN) $(BUILD_DIR)\smd.exe $(BUILD_DIR)\$(BIOSFILE).DMI
!endif
#-----------------------------------------------------------------------#
# DIM.EXE is dependent on the DIM_OBJs.					#
# To generate DIM.EXE we need to run the linker.			#
#-----------------------------------------------------------------------#
!if $(DMI_SUPPORT)
$(BUILD_DIR)\smc.exe: $(SMB_RUNTIME_OBJS) $(SMB_POST_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\smc.exe,
$(BUILD_DIR)\smc.map;
<<

$(BUILD_DIR)\smd.exe: $(SMB_DATA_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\smd.exe,
$(BUILD_DIR)\smd.map;
<<
!endif
#-----------------------------------------------------------------------#
# Following command generates the MAKEFLAG.EQU file for all ASM files.	#
#-----------------------------------------------------------------------#
#$(BUILD_DIR)\smbmake.equ: $(MKF) $(SMB_FILES) $(SMB_INC_FILES)
#	$(COPY) << $(BUILD_DIR)\smbmake.equ
#!if $(DMI_SUPPORT)
#MKF_DMI_SUPPORT   equ -1
#!else
#MKF_DMI_SUPPORT   equ 0
#!endif
#<<
#-----------------------------------------------------------------------#
# The following command generates the .BBP file for BUILD.EXE.		#
#-----------------------------------------------------------------------#
#$(BUILD_DIR)\smbmake.bbp: $(MKF) $(SMB_FILES) $(SMB_INC_FILES)
#	$(COPY) << $(BUILD_DIR)\smbmake.bbp
#!if $(DMI_SUPPORT)
#[DMI]
#ModuleID = 06
#compressed = no
#File = $(BUILD_DIR)\$(BIOSFILE).SMD
#Destn = 0000:0000
#
#[DMICode]
#ModuleID = 13
#compressed = yes
#File = $(BUILD_DIR)\$(BIOSFILE).SMC
#Destn = 0000:0000
#!endif
#<<
#-----------------------------------------------------------------------#
# These are all of the OBJ files and their dependencies.		#
#-----------------------------------------------------------------------#
$(BUILD_DIR)\smbpost.obj:     $(SMB_PATH)smbpost.asm $(MKF) $(TEMP_INC_FILES) $(SMB_INC_FILES)
   @$(ASM) $(DMIFLAGS) %s
$(BUILD_DIR)\smbrun.obj:      $(SMB_PATH)smbrun.asm $(MKF) $(TEMP_INC_FILES) $(SMB_INC_FILES)
   @$(ASM) $(DMIFLAGS) %s
$(BUILD_DIR)\smbrune.obj:     $(SMB_PATH)smbrune.asm $(MKF) $(TEMP_INC_FILES) $(SMB_INC_FILES)
   @$(ASM) $(DMIFLAGS) %s
$(BUILD_DIR)\smb.obj:         $(SMB_PATH)smb.asm $(MKF) $(TEMP_INC_FILES) $(SMB_INC_FILES)
   @$(ASM) $(DMIFLAGS) %s
$(BUILD_DIR)\smbsub.obj:      $(SMB_PATH)smbsub.asm $(MKF) $(TEMP_INC_FILES) $(SMB_INC_FILES)
   @$(ASM) $(DMIFLAGS) %s
$(BUILD_DIR)\smbdata.obj:     $(SMB_PATH)smbdata.asm $(MKF) $(TEMP_INC_FILES) $(SMB_INC_FILES)
   @$(ASM) $(DMIFLAGS) %s
#-----------------------------------------------------------------------#
