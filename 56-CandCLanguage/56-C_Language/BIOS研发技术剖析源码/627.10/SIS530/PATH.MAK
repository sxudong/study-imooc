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
#-----------------------------------------------------------------------#
# These directories should be set to indicate where the ASM files are	#
# located, and where the OBJs (and EXEs/ROMs) should be generated.	#
#-----------------------------------------------------------------------#
OEM_DIR       = .
OEM_PORT_DIR  = .\oemport
CHIP_MOD_DIR  = .\oemchip.mod
CORE_DIR      = ..\..\..\obj
CORE_MOD_DIR  = ..\..\core.mod
BUILD_DIR     = ..\..\rom
IO_DIR        = ..\..\io
INC_DIR	      = ..\..\..\include
INC_PORT_DIR  = ..\..\inc
SYS_DIR       = ..\..\sys\nsys
SYS_PORT_DIR  = ..\..\sys
DIM_DIR       = ..\..\dim\ndim
DIM_PORT_DIR  = ..\..\dim
GPC_DIR       = ..\..\gpc\ngpc
GPC_PORT_DIR  = ..\..\gpc
USB_DIR       = ..\..\usb\nusb
USB_PORT_DIR  = ..\..\usb
CPU_DIR       = ..\..\cpu
MP_DIR	      = ..\..\mp\nmp
MP_PORT_DIR   = ..\..\mp
ADDON_ROM_DIR = ..\..\..\add-on.rom
# ACPI_SUPPORT
ACPI_PORT_DIR = ..\..\acpi
ACPI_ASL_DIR  = $(OEM_PORT_DIR)\acpi.asl
#-----------------------------------------------------------------------#
# Path definition for each file based on the priority of the directory.	#
# For Core files,	1st Priority is $(OEM_DIR)\OEMCORE.MOD		#
#			2nd Priority is CORE.MOD			#
#			3rd Priority is OBJ				#
# For CORE.SSP file,	1st Priority is $(OEM_DIR)\OEMCORE.MOD		#
#			2nd Priority is CORE.MOD			#
#			3rd Priority is OBJ				#
# For CPU files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(CPU_DIR)			#
# For SYS files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(SYS_PORT_DIR)			#
# For NSYS files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(SYS_DIR)			#
# For DIM files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(DIM_PORT_DIR)			#
# For NDIM files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(DIM_DIR)			#
# For USB files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(USB_PORT_DIR)			#
# For NUSB files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(USB_DIR)			#
# For MP files,		1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(MP_PORT_DIR)			#
# For NMP files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(MP_DIR)			#
# For GPC files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(GPC_PORT_DIR)			#
# For NGPC files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(GPC_DIR)			#
#									#
# For INC files,	1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is $(INC_PORT_DIR)			#
# For INCLUDE files,	1st Priority is $(OEM_DIR)\OEMCORE.MOD		#
#			2nd Priority is $(INC_DIR)			#
#									#
# For LIB files, e.g.	1st Priority is $(BUILD_DIR)			#
# JMPP.LIB,JMPS.LIB	2nd Priority is $(CORE_DIR)			#
#-----------------------------------------------------------------------#
CORE_PATH	= {$(BUILD_DIR);$(CORE_DIR)}
CORE_SSP_PATH	= {$(OEM_DIR)\OEMCORE.MOD;$(CORE_MOD_DIR);$(CORE_DIR)}
CPU_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(CPU_DIR)}
SYS_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(SYS_DIR)}
SYS_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(SYS_PORT_DIR)}
DIM_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(DIM_DIR)}
DIM_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(DIM_PORT_DIR)}
GPC_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(GPC_DIR)}
GPC_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(GPC_PORT_DIR)}
USB_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(USB_DIR)}
USB_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(USB_PORT_DIR)}
INC_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(INC_DIR)}
INC_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(INC_PORT_DIR)}
MP_PATH		= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(MP_DIR)}
MP_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(MP_PORT_DIR)}
# ACPI_SUPPORT
ACPI_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR);$(ACPI_PORT_DIR)}
IO_PATH		= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR)\OEMIO.MOD;$(CORE_DIR)}
IO_PORT_PATH	= {$(OEM_DIR)\OEMCHIP.MOD;$(OEM_DIR)\OEMIO.MOD;$(IO_DIR)}
OEM_PATH	= {$(OEM_PORT_DIR);$(OEM_DIR)}
#-----------------------------------------------------------------------#
# Commands to use to run assembler, linker, and BCP, along with command	#
# options to use with each.						#
#-----------------------------------------------------------------------#
# (CORE0071)>
#BUILD    = ..\..\..\exe\amibuild
BUILD    = ..\..\..\exe\amibbp
# <(CORE0071)
BCP      = ..\..\..\exe\amibcp
ROMINFO  = ..\..\..\exe\rominfo
LOCATE   = ..\..\..\exe\locate
EXE2BIN  = ..\..\..\exe\exe2bin
B16CKSUM = ..\..\..\exe\b16cksum
PNPCKSUM = ..\..\..\exe\pnpcksum
PCICKSUM = ..\..\..\exe\pcicksum
SSP      = ..\..\..\exe\amissp
DSP      = ..\..\..\exe\amidsp
MM	 = ..\..\..\exe\amimm
#ACPI_SUPPORT
ASL	 = ..\..\..\exe\asl

COPY     = copy
DELETE   = del
ASM      = ml
LINK     = link
LIBRARY	 = lib
EMULATOR = lr
MKF	 = #..\..\bios.mak ..\..\core.mak ..\..\path.mak ..\..\obj.mak io.mak oem.mak
#-----------------------------------------------------------------------#
# Default definitions							#
#-----------------------------------------------------------------------#
LIBPATH=$(BUILD_DIR);$(CORE_DIR)
TEMP_INC_FILES = $(BUILD_DIR)\makeflag.equ $(BUILD_DIR)\asm.rsp
#-----------------------------------------------------------------------#
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
