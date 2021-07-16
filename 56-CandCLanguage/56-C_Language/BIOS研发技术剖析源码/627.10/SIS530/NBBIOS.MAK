#*****************************************************************#
#**								**#
#** Notebook BIOS MAK File For OEMs				**#
#**								**#
#** This MAK file builds NB.BIN.  It has two parts		**#
#** 1.	NBBIOS.MAK -- Allows OEM to custimize the feature	**#
#**		      support required in the BIOS.		**#
#** 2.	NBCORE.MAK -- Script for assembling, linking, and	**#
#**		      creating the NB.BIN file. 		**#
#**								**#
#*****************************************************************#

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

#-----------------------------------------------------------------#
#  NB BIOS FEATURE SUPPORT SWITCHES				  #
#-----------------------------------------------------------------#
#  Unless otherwise specifed, the switches work as follows:	  #
#	SWITCH = 1  -- The MAK file will link the OBJ module that #
#		       has complete support for this feature.	  #
#	SWITCH = 0  -- The MAK file will link a "dummy" OBJ	  #
#		       module that contains "dummy" proceedures   #
#		       and label for resolving externals, without #
#		       proper code to support this feature.	  #
#  Hints:							  #
#  1.  It is suggested that if the feature is not required for	  #
#      the BIOS being built, set the switch to 0.  This will	  #
#      decrease the code segment size and increase the free space #
#      inside the ROM image.					  #
#-----------------------------------------------------------------#

#-----------------------------------------------------------------#
#  CORE BIOS ASSEMBLY						  #
#-----------------------------------------------------------------#
#  Select whether or not to assemble the NB CORE objs here.	  #
#	NB_ASMCORE = 1	-- Assemble the CORE Notebook BIOS OBJs   #
#			   as required during the MAK process.	  #
#	NB_ASMCORE = 0	-- Do not assemble the CORE Notebook BIOS #
#			   OBJs.				  #
#  Default = 0							  #
#  Hints:							  #
#  1.  Notebook CORE BIOS objs should not need to be changed.	  #
#      Only set this switch if you MUST modify a NB CORE ASM file.#
#-----------------------------------------------------------------#
NB_ASMCORE		    = 0

#-----------------------------------------------------------------#
#  CPU SUPPORT							  #
#-----------------------------------------------------------------#
#  Select the CPU support required inside SMI.			  #
#	NB_INTEL_CPU_SUPPORT  -- BIOS requires Intel CPU support. #
#	NB_CYRIX_CPU_SUPPORT  -- BIOS requires Cyrix CPU support. #					  #
#	NB_AMD_CPU_SUPPORT    -- BIOS requires AMD CPU support.   #
#  Defualt = Select Intel CPU support only.			  #
#  Hints:							  #
#  1.  Select CPU support for only those CPU vendors which the	  #
#      chipset supports and the OEM will use on their motherboard #
#      now or in the future.					  #
#-----------------------------------------------------------------#
NB_INTEL_CPU_SUPPORT	    = 1 # Intel/AMD-Plus type PM
NB_CYRIX_CPU_SUPPORT	    = 0 # Cyrix/TI type PM
NB_AMD_CPU_SUPPORT	    = 0 # AMD/IBM/UMC type PM

#-----------------------------------------------------------------#
#  APM SUPPORT							  #
#-----------------------------------------------------------------#
#  Select ONE of the following to determine the MAXIMUM version of#
#  the APM Specification the BIOS will support. 		  #
#	NB_APM10_SUPPORT -- For APM spec. 1.0 ONLY		  #
#	NB_APM11_SUPPORT -- For APM spec. 1.0 & 1.1 ONLY	  #
#	NB_APM12_SUPPORT -- For APM spec. 1.0, 1.1 & 1.2	  #
#-----------------------------------------------------------------#
NB_APM10_SUPPORT	    = 0 # Support APM v1.0
NB_APM11_SUPPORT	    = 0 # Supports APM v1.0 & v1.1
NB_APM12_SUPPORT	    = 1 # Supports APM v1.0, v1.1, & v1.2

#-----------------------------------------------------------------#
#  DOS FILE SUPPORT FOR SUSPEND TO DISK (0V SUSPEND)		  #
#-----------------------------------------------------------------#
#  Select whether the BIOS can support saving the system infor-   #
#  mation to a DOS file (FAT file system only). 		  #
#  Default = 1							  #
#-----------------------------------------------------------------#
NB_DOS_FILE_SUPPORT	    = 1 # 1 = Notebook BIOS supports DOS file save to disk

#-----------------------------------------------------------------#
#  INT 13h HANDLING DURING SMI					  #
#-----------------------------------------------------------------#
#  Select how the INT 13h will be handled during SMM.		  #
#	NB_INT_IDE_SUPPORT  -- IDE INT 13h routines will be	  #
#			       in SMRAM.  If set to 0, IDE INT 13h#
#			       will be handled by System BIOS.	  #
#	NB_EXT_HDD_SUPPORT  -- To support INT 13h for non-IDE	  #
#			       drives (SCSI).  INT 13h will final #
#			       ly be passed to the SCSI ROM.	  #
#  Default = NB_INT_IDE_SUPPORT = 1, NB_EXT_HDD_SUPPORT = 0	  #
#-----------------------------------------------------------------#
NB_INT_IDE_SUPPORT	    = 1 # Supports IDE handling inside SMM
NB_EXT_HDD_SUPPORT	    = 0 # Supports external int13 handling (SCSI)
#;TonyLo Wed 03-03-1999 -
NB_INT_IDE_EDD_SUPPORT	    = 1 # SMM IDE EDD function support
NB_EDD_SUPPORT		    = 1 #
#;TonyLo Wed 03-03-1999 - end

#-----------------------------------------------------------------#
#  VIDEO CONTROLLER SUPPORT					  #
#-----------------------------------------------------------------#
#  Select which VGA controller support is required in the BIOS.   #
#  Also select whether the Notebook BIOS should support the VESA  #
#  DPMS (Display Power Management Services) functions.		  #
#  Defualt = NB_VESA_SUPPORT	= 1				  #
#	     NB_STD_VGA_SUPPORT = 1				  #
#	     NB_CIR_VGA_SUPPORT = 0				  #
#	     NB_CT_VGA_SUPPORT	= 0				  #
#	     NB_OEM_VGA_SUPPORT = 0				  #
#  Hints:							  #
#  1.  For a PCI demonstration BIOS, set all flags to one (except #
#      NB_WD_VGA_SUPPORT, as WD does not have a PCI VGA control-  #
#      ler), and detect the VGA controller at initialization.	  #
#  2.  For a OEM specific board, only include support for the	  #
#      VGA controller in the Notebook.				  #
#  3.  ALWAYS set NB_VESA_SUPPORT = 1.				  #
#-----------------------------------------------------------------#
NB_VESA_SUPPORT 	    = 1 # Support VGA VESA DMPMS calls
NB_STD_VGA_SUPPORT	    = 1 # Standard VGA handling routines
NB_CIR_VGA_SUPPORT	    = 0 # CIRRUS VGA handling routines
NB_CT_VGA_SUPPORT	    = 0 # C&T VGA handling routines
NB_OEM_VGA_SUPPORT	    = 0 # OEM specific VGA handling routines

#-----------------------------------------------------------------#
#  AUDIO CHIP POWER MANAGEMENT SUPPORT				  #
#-----------------------------------------------------------------#
#  Set ONE of the following switches to 1 to select the proper	  #
#  audio power management, or set all switches to 0 for no	  #
#  audio chip power management support. 			  #
#  Default = All switches set to 0				  #
#-----------------------------------------------------------------#
NB_ESS1688_SUPPORT	    = 0 # ESS1688 Audio PM routines
NB_CT2504_SUPPORT	    = 0 # CT2504 Audio PM routines

#-----------------------------------------------------------------#
#  SMART BATTERY SUPPORT					  #
#-----------------------------------------------------------------#
#  Set ONE of the following switches to 1 to select the proper	  #
#  smart battery support, or set all switches to 0 to remove	  #
#  smart battery support.					  #
#  Default = All switches set to 0				  #
#-----------------------------------------------------------------#
NB_SMB_PRN_SUPPORT	    = 0 # SMB Parallel Port Demo card handling routines
NB_SMB_AMIC51KB_SUPPORT     = 0 # SMB AMI I80C51 KB handling routines
NB_SMB_PHXM13KB_SUPPORT     = 0 # SMB PHX M38813 KB handling routines
NB_SMB_PIIX4_SUPPORT	    = 0 # SMB INTEL PIIX4 chipset handling routines
NB_SMB_CSS_ACCESS	    = 1 # SMBus chipset specific access routines

#-----------------------------------------------------------------#
#  PnP SAVE AND RESTORE SUPPORT 				  #
#-----------------------------------------------------------------#
#  If PnP configuration needs to be saved and restored during	  #
#  0V suspend and resume, set this switch to make the routines	  #
#  available to be called.					  #
#  Defualt = NB_PNP_SUPPORT = 1 				  #
#-----------------------------------------------------------------#
NB_PNP_SUPPORT		    = 0 # PnP PM save & restore routines

#-----------------------------------------------------------------#
#  HOT DOCKING SUPPORT						  #
#-----------------------------------------------------------------#
#  If the Notebook supports HOT DOCKING, set this Bit.		  #
#-----------------------------------------------------------------#
NB_DOCK_SUPPORT 	    = 0 # Notebook Docking Support

#-----------------------------------------------------------------#
#  NOTEBOOK OVERRIDE PATHS					  #
#-----------------------------------------------------------------#
!INCLUDE nbpath.mak
#-----------------------------------------------------------------#
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
