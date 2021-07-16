#-----------------------------------------------------------------------#
# Redefine MKF variable to make it dependent on DC.MAK file.            #
#-----------------------------------------------------------------------#
#MKF            = $(MKF)\
#..\..\dc.mak
EQUATOR         = ..\..\..\exe\equator.exe
#-----------------------------------------------------------------------#
$(BIOSFILE).rom: $(BUILD_DIR)\$(BIOSFILE).DC
$(BIOSFILE).rom: $(BUILD_DIR)\dc.BBP
#-----------------------------------------------------------------------#
$(BUILD_DIR)\$(BIOSFILE).DC: $(BUILD_DIR)\dc.exe
        $(EXE2BIN) $(BUILD_DIR)\dc.exe $(BUILD_DIR)\$(BIOSFILE).DC
#-----------------------------------------------------------------------#
# Build list of OBJs needed for .DC Module                              #
#-----------------------------------------------------------------------#
DC_OBJS =\
$(CORE_PATH)dc.obj\
!if $(DISP_PCIPNP)
$(BUILD_DIR)\devinfo.obj\
#$(CORE_PATH)me5pci.obj\
!else
#$(CORE_PATH)me5.obj\
!endif
$(BUILD_DIR)\setupequ.obj
#-----------------------------------------------------------------------#
# DC.EXE is dependent on the DC_OBJs.                                   #
# To generate DC.EXE we need to run the linker.                         #
#-----------------------------------------------------------------------#
$(BUILD_DIR)\dc.exe: $(DC_OBJS)
    $(LINK) $(LFLAGS) @<<
$(**: = +^
),
$(BUILD_DIR)\dc.exe,
$(BUILD_DIR)\dc.map;
<<
#-----------------------------------------------------------------------#
$(BUILD_DIR)\dc.BBP:    $(BUILD_DIR)\$(BIOSFILE).BBP
        $(COPY) << $(BUILD_DIR)\dc.bbp

[DispConfig]
ModuleID = 12
compressed = yes
File = $(BUILD_DIR)\$(BIOSFILE).DC
Destn = 0000:0000
<<
        $(COPY) $(BUILD_DIR)\$(BIOSFILE).BBP + $(BUILD_DIR)\dc.bbp $(BUILD_DIR)\$(BIOSFILE).BBP
#-----------------------------------------------------------------------#
$(BUILD_DIR)\me9.equ:   $(OEM_PORT_DIR)\message.asm
        $(EQUATOR) $(OEM_PORT_DIR)\message.asm $(BUILD_DIR)\me9.equ
        if exist $(CORE_MOD_DIR)\me5pci.asm $(EQUATOR) $(CORE_MOD_DIR)\me5pci.asm $(BUILD_DIR)\me5.equ
        if exist $(OEM_DIR)\OEMCORE.MOD\me5pci.asm $(EQUATOR) $(OEM_DIR)\OEMCORE.MOD\me5pci.asm $(BUILD_DIR)\me5.equ
