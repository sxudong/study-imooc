#     *****************************************************************;
#     *****************************************************************;
#     **                                                             **;
#     **      (C)Copyright 1985-1998, American Megatrends, Inc.      **;
#     **                                                             **;
#     **                     All Rights Reserved.                    **;
#     **                                                             **;
#     **           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
#     **                                                             **;
#     **                     Phone (770)-246-8600                    **;
#     **                                                             **;
#     *****************************************************************;
#     *****************************************************************;
#**********************************************************************;
#**********************************************************************;

########################################################################
# ASL PROJECT MANAGER                                                  #
########################################################################

ASL_NAME        = OEMDSDT               # Main DSDT ASL file name to compile
ARC_LIB         = 0                     # 0 - ASL library in source files
                                        # 1 - ASL library in ZIPped file
                                        # default name is asllib.zip

ASL_BUILD       = aslbuild.mak          # ASL Builder file name

ASL_PORT        = aslport.mak           # ASL Porting file name

#ASL_LIB_PATH    = ..\INCLUDE.ASL        # Path to ASL Library file(s)
ASL_LIB_PATH   = ..\..\INCLUDE.ASL# Path to ASL Library file(s)
#-----------------------------------------------------------------------#
# In case of multiple ASL projects ASL_PORT, ACPI_ASL_DIR, ASL_LIB_PATH #
# should be unique for each Project                                     #
#-----------------------------------------------------------------------#
#!if $(KAHNEETA)
#ASL_PORT        = aslneeta.mak          # ASL Porting file name
#ACPI_ASL_DIR   = NEW PATH TO ASL TARGET DIRECTORY
#ASL_LIB_PATH   =
#!else
#ASL_PORT        = aslcorte.mak          # ASL Porting file name
#ACPI_ASL_DIR   = NEW PATH TO ASL TARGET DIRECTORY
#ASL_LIB_PATH   =
#!endif
#-----------------------------------------------------------------------#
!INCLUDE        $(ASL_PORT)             # ASL Porting file
!INCLUDE        $(ASL_BUILD)            # ASL Builder file
#-----------------------------------------------------------------------#
