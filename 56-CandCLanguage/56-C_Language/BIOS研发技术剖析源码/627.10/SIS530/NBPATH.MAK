#     *****************************************************************;
#     *****************************************************************;
#     **							     **;
#     **      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
#     **							     **;
#     **		     All Rights Reserved.		     **;
#     **							     **;
#     **	   6145-F Northbelt Pkwy, Norcross, GA 30071	     **;
#     **							     **;
#     **		     Phone (770)-246-8600		     **;
#     **							     **;
#     *****************************************************************;
#     *****************************************************************;
#*****************************************************************#
#-----------------------------------------------------------------------#
#  NOTEBOOK SOURCE DIRECTORY STRUCTURE					#
#-----------------------------------------------------------------------#
#-----------------------------------------------------------------------#
# These directories should be set to indicate where the ASM files are	#
# located, and where the OBJs (and EXEs/ROMs) should be generated.	#
#-----------------------------------------------------------------------#
NB_INC_DIR		= ..\..\..\include.nb
NBPWR_PORT_DIR		= ..\..\cssnb
NBPWR_CORE_DIR		= $(CORE_DIR)
NBPWR_COREASM_DIR	= ..\..\..\nbcore\pwr.asm
NBDSK_PORT_DIR		= ..\..\cssnb
NBDSK_CORE_DIR		= $(CORE_DIR)
NBDSK_COREASM_DIR	= ..\..\..\nbcore\dtop.asm
NBCSS_CORE_MOD_DIR	= $(CORE_MOD_DIR)
NBOEM_PWR_PORT_DIR	= $(OEM_DIR)\oemnb
NBOEM_DSK_PORT_DIR	= $(OEM_DIR)\oemnb
NBOEM_CHIP_MOD_DIR	= $(CHIP_MOD_DIR)
NBOEM_CORE_MOD_DIR	= $(OEM_DIR)\oemcore.mod

#-----------------------------------------------------------------------#
# Path definition for each file based on the priority of the directory. #
# For NB PWR Core files,1st Priority is $(OEM_DIR)\OEMCORE.MOD		#
#			2nd Priority is ..\..\CORE.MOD			#
#			3rd Priority is ..\..\..\NBCORE\PWR.ASM 	#
# For NB DTOP Core files,1st Priority is $(OEM_DIR)\OEMCORE.MOD 	#
#			2nd Priority is ..\..\CORE.MOD			#
#			3rd Priority is ..\..\..\NBCORE\DTOP.ASM	#	#
# For NB PWR CSS files, 1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is ..\..\CSSNB\PWR 		#
# For NB DTOP CSS files,1st Priority is $(OEM_DIR)\OEMCHIP.MOD		#
#			2nd Priority is ..\..\CSSNB\DTOP		#
#-----------------------------------------------------------------------#
NBPWR_CORE_PATH = {$(BUILD_DIR);$(NBPWR_CORE_DIR)}
NBDSK_CORE_PATH = {$(BUILD_DIR);$(NBDSK_CORE_DIR)}
NBPWR_PORT_PATH = {$(NBOEM_CHIP_MOD_DIR);$(NBPWR_PORT_DIR)}
NBDSK_PORT_PATH = {$(NBOEM_CHIP_MOD_DIR);$(NBDSK_PORT_DIR)}
NBOEM_PWR_PORT_PATH = {$(NBOEM_PWR_PORT_DIR);$(OEM_DIR)}
NBOEM_DSK_PORT_PATH = {$(OEM_DIR)\OEMCHIP.MOD;$(NBOEM_DSK_PORT_DIR);$(OEM_DIR)}

#     *****************************************************************;
#     *****************************************************************;
#     **							     **;
#     **      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
#     **							     **;
#     **		     All Rights Reserved.		     **;
#     **							     **;
#     **	   6145-F Northbelt Pkwy, Norcross, GA 30071	     **;
#     **							     **;
#     **		     Phone (770)-246-8600		     **;
#     **							     **;
#     *****************************************************************;
#     *****************************************************************;
