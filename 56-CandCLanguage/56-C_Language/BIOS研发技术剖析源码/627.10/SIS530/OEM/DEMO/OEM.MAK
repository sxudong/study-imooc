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
!INCLUDE io.mak
!INCLUDE ..\..\bios.mak
#-----------------------------------------------------------------------#
REF_NUMBER      = 009999        # 4 decimal digits for customer         #    
#-----------------------------------------------------------------------#
# Source code, ROMID, BIOS-TAG control parameters.                      #
# BIOSTAG (ROMID) will be $(PROJECT_PATH)$(PROJECT_BUILD)               #
#-----------------------------------------------------------------------#
PROJECT_PATH    = 1SIS5         # 1st digit =   Location                #
                                #               0 = Atlanta, 1 = Taiwan #
                                # Last 4 digit is Project Number assigned
                                # by supervisor.                        #
PROJECT_BUILD   = 300           # Build Number and should be incremented#
                                # with any new release.                 #
                                # Maximum 3 digits.                     #
#-----------------------------------------------------------------------#
BIOSFILE        = $(PROJECT_PATH)$(PROJECT_BUILD)  # Do not remove this line
ALL: PREBUILD $(BIOSFILE).ROM CLEANUP              # Do not remove this line
#-----------------------------------------------------------------------#
#                       MULTIPROCESSOR  SUPPORT                         #
#-----------------------------------------------------------------------#
NCPU            = 1             # DO NOT SET THIS TO 0                  #
                                # 1 -> Single Processor BIOS            #
                                # 2 -> Dual Processor BIOS              #
                                # n -> Multi Processor BIOS             #
BUP6            = 0             # 1 = Include P6 support                #
                                # This needs Flash support using 4GB    #
                                # method (FLASH_4GB must be set to 1).  #
# MP TABLE SUPPORT - The MP Table should only be built if there is an   #
# I/O APIC on the motherboard.                                          #
MPS_SUPPORT     = 0             # 0 = IO APIC not present in motherboard#
                                #     (MP table need not to be built)   #
                                # 1 = IO APIC present in motherboard    #
                                #     (MP table need to be built)       #
# If there is an I/O APIC on the motherboard, then the MP Table may be  #
# modified to include entries for PCI interrupts in INTIN#'s above the  #
# standard IRQ0 - IRQ15.  The routing of PCI interrupts is somewhat     #
# hardware specific so see the MPPOST.ASM file for more detail.         #
# EXTENDED_APIC switch is valid only if MPS_SUPPORT switch is set to 1. #

EXTENDED_APIC   = 1             # 0 = hardware not using INTIN# lines of#
                                #     IO APIC above 15 for PCI slots.   #
                                # 1 = hardware using INTIN#15-INTIN#22  #
                                #     as PCI slot interrupt routing and #
                                #     INTIN#23 as SMI.                  #
OEM_ID          = SiS           # OEM_ID     Upto 8  characters         #
                                # Example: INTEL                        #
PRODUCT_ID      = SiS530        # PRODUCT_ID Upto 12 characters         #
                                # Example: 440FX                        #
#-----------------------------------------------------------------------#
# Add the OEM specific make file switches here.                         #
# The OBJ groups definition as defined in DEF.MAK file, can be redefined#
# here based on the new OEM specific make file switches.                #
# For example                                                           #
# INTEL_256K      = 0           # Set to use 002 or 200 BX T part       #
# SMB_MEM_DETECT  = 0           # For SMBus Memory Detection            #
#-----------------------------------------------------------------------#
BIOS_SIZE               = 2             # 0=64K, 1=128K, 2=256K, 3=512K, ...... #
SOFT_OFF                = 1             # Set if ATX Power Support
ACPI_SUPPORT            = 1             # Set if ACPI Support
ONCHIP_LM78             = 1
LM78_BASE_ADDRESS       = 295h
LM75_SUPPORT            = 1
LM75_SLAVE_ADDRESS      = 9eh
SILENT_BOOT             = 1             # 1 = Silent Boot Support               #

GPNV_SUPPORT            = 1             # 1 = GPNV support                      #
GPNV_FLASH              = 1             # 0 = GPNV in IO Mapped NVRAM           #
EVENT_LOG               = 0
USB_SUPPORT             = 1             # 1 -> USB Support present              #
 
SUI_FILE                = hf130.bin
#SUI_FILE                = easy132.BIN
#SUI_FILE                = SP130.BIN
#SUI_FILE                = Win29.BIN

#SUI_FILE                = SP130.BIN

#SIGN_ON_MSG1    = 'AMI BIOS for SiS 530',0    # sign on message


#-----------------------------------------------------------------------#
INTEL           = 0                                                     #
SST             = 1                                                     #
ATMEL           = 1                                                     #
WINBOND         = 1                                                     #
AMD             = 1                                                     #
#-----------------------------------------------------------------------#
# SMBus Base Address to be programmed in the PIIX4 Function 3, Reg 90..91
# This Base Address will be programed in Boot Block code
# !!!! DO NOT CHANGE THESE VALUES !!!!
#-----------------------------------------------------------------------#
SMB_BASE_HIGH   = 004h
SMB_BASE_LOW    = 040h
#-----------------------------------------------------------------------#
# PM (ACPI) Base Address to be programmed in the PIIX4 Function 3, Reg 40..41
# This Base Address will be programed in Boot Block code
# !!!! DO NOT CHANGE THESE VALUES !!!!
#-----------------------------------------------------------------------#
PM_BASE_HIGH    = 004h
PM_BASE_LOW     = 000h
#-----------------------------------------------------------------------#
# Include the OBJ.MAK file defining the OBJ Groups based on make file   #
# switches defined in BIOS.MAK and in this file above.                  #
# ================== NOTE ==== NOTE ==== NOTE ========================= #
# NOTE : All the OEM specific Make file switches MUST BE DEFINED above. #
#-----------------------------------------------------------------------#
!INCLUDE ..\..\obj.mak
#-----------------------------------------------------------------------#
$(BUILD_DIR)\oemmake.equ: $(MKF)
        copy << $(BUILD_DIR)\oemmake.equ
; Generate new makefile equates using OEM specific switches

MKF_CUSTNO      equ     $(REF_NUMBER)

!if $(SOFT_OFF)
MKF_SOFT_OFF    equ  -1
!else
MKF_SOFT_OFF    equ  00
!endif

!if $(LM75_SUPPORT)
MKF_LM75_SUPPORT        equ  -1
!else
MKF_LM75_SUPPORT        equ  0
!endif

!if $(ONCHIP_LM78)
MKF_ONCHIP_LM78 equ  -1
MKF_LM78_BASE_ADDRESS   equ     $(LM78_BASE_ADDRESS)
!else
MKF_ONCHIP_LM78 equ  0
!endif

MKF_LM75_SLAVE_ADDRESS = $(LM75_SLAVE_ADDRESS)

; System Management BUS Equates
MKF_SMB_BASE_LOW        equ     $(SMB_BASE_LOW)
MKF_SMB_BASE_HIGH       equ     $(SMB_BASE_HIGH)
MKF_SMB_BASE_ADDRESS    equ     ($(SMB_BASE_HIGH) SHL 8) + $(SMB_BASE_LOW)

;; Power Management I/O Base Address Equates
MKF_PM_BASE_LOW         equ     $(PM_BASE_LOW)
MKF_PM_BASE_HIGH        equ     $(PM_BASE_HIGH)
MKF_PM_BASE_ADDRESS     equ     ($(PM_BASE_HIGH) SHL 8) + $(PM_BASE_LOW)

!if $(SERIAL_IRQ)
MKF_SERIAL_IRQ          equ     -1
!else
MKF_SERIAL_IRQ          equ     0
!endif

; Generate the makefile equates based on IO chipset selection
!if $(AIP)
MKF_AIP         equ -1
!else
MKF_AIP         equ 0
!endif
!if $(ALI5105)
MKF_ALI5105     equ -1
!else
MKF_ALI5105     equ 0
!endif
!if $(ALI5113)
MKF_ALI5113     equ -1
!else
MKF_ALI5113     equ 0
!endif
!if $(ALI5119)
MKF_ALI5119     equ -1
!else
MKF_ALI5119     equ 0
!endif
!if $(ALI5123)
MKF_ALI5123     equ -1
!else
MKF_ALI5123     equ 0
!endif
!if $(CT735)
MKF_CT735       equ -1
!else
MKF_CT735       equ 0
!endif
!if $(DSCH20)
MKF_DSCH20      equ -1
!else
MKF_DSCH20      equ 0
!endif
!if $(GM803B)
MKF_GM803B      equ -1
!else
MKF_GM803B      equ 0
!endif
!if $(GM803C)
MKF_GM803C      equ -1
!else
MKF_GM803C      equ 0
!endif
!if $(ITE8680)
MKF_ITE8680     equ -1
!else
MKF_ITE8680     equ 0
!endif
!if $(ITE8661)
MKF_ITE8661     equ -1
!else
MKF_ITE8661     equ 0
!endif
!if $(NAT303)
MKF_NAT303      equ -1
!else
MKF_NAT303      equ 0
!endif
!if $(NAT306)
MKF_NAT306      equ -1
!else
MKF_NAT306      equ 0
!endif
!if $(NAT307) || $(NAT308)
MKF_NAT308      equ -1
!else
MKF_NAT308      equ 0
!endif
!if $(NAT312)
MKF_NAT312      equ -1
!else
MKF_NAT312      equ 0
!endif
!if $(NAT322)
MKF_NAT322      equ -1
!else
MKF_NAT322      equ 0
!endif
!if $(NAT332)
MKF_NAT332      equ -1
!else
MKF_NAT332      equ 0
!endif
!if $(NAT336)
MKF_NAT336      equ -1
!else
MKF_NAT336      equ 0
!endif
!if $(NAT338)
MKF_NAT338      equ -1
!else
MKF_NAT338      equ 0
!endif
!if $(SMC651_SMC661_CT711_CT721)
MKF_SMC651      equ -1
!else
MKF_SMC651      equ 0
!endif
!if $(SMC665)
MKF_SMC665      equ -1
!else
MKF_SMC665      equ 0
!endif
!if $(SMC665IR)
MKF_SMC665IR    equ -1
!else
MKF_SMC665IR    equ 0
!endif
!if $(SMC669) || $(SMC669FR)
MKF_SMC669      equ -1
!else
MKF_SMC669      equ 0
!endif
!if $(SMC669FR)
MKF_SMC669FR    equ -1
!else
MKF_SMC669FR    equ 0
!if $(SMC67X)
MKF_SMC67X      equ -1
!else
MKF_SMC67X      equ 0
!endif
!if $(SMC68X)
MKF_SMC68X      equ -1
!else
MKF_SMC68X      equ 0
!endif
!endif
!if $(SMC922)
MKF_SMC922      equ -1
!else
MKF_SMC922      equ 0
!endif
!if $(SMC932_SMC935) || $(SMC932FR)
MKF_SMC932      equ -1
!else
MKF_SMC932      equ 0
!endif
!if $(SMC957)
MKF_SMC957      equ -1
!else
MKF_SMC957      equ 0
!endif
!if $(UMC8663)
MKF_UMC8663     equ -1
!else
MKF_UMC8663     equ 0
!endif
!if $(UMC8663B)
MKF_UMC8663B    equ -1
!else
MKF_UMC8663B    equ 0
!endif
!if $(UMC8669)
MKF_UMC8669     equ -1
!else
MKF_UMC8669     equ 0
!endif
!if $(WIN787_WIN777)
MKF_WIN787      equ -1
!else
MKF_WIN787      equ 0
!endif
!if $(WIN787IF)
MKF_WIN787IF    equ -1
!else
MKF_WIN787IF    equ 0
!endif
!if $(WIN877)
MKF_WIN877      equ -1
!else
MKF_WIN877      equ 0
!endif
!if $(WIN977)
MKF_WIN977      equ -1
!else
MKF_WIN977      equ 0
!endif
<<
#-----------------------------------------------------------------------#
# Silent Boot Support                                                   #
# If Silent Boot is supported, OEM Logo Module should be present,       #
# specify the OEM Logo module binary imgae filename including the       #
# pathname here.                                                        #
#-----------------------------------------------------------------------#

!if $(SILENT_BOOT)
OEM_LOGO_FILENAME       = bluesea.pcx            # specify the OEM logo filename #
!endif
#-----------------------------------------------------------------------#
# Multi Language Support                                                #
#-----------------------------------------------------------------------#
ML_MODULE          = 0          # 1 = Multi-Language Module present     #
ML_MODULE_FILENAME =            # Multi Language Module Filename.Ext    #
ML_MODULE_DESTSEG  =            # Multi Language Module Dest Segment    #
ML_MODULE_DESTADDR =            # Multi Language Module Dest Addr       #

# If Multi Language Module is present,                                  #
#       then    1. Generate the Assembly file in Project directory.     #
#               2. Write the Dependencies here.                         #
#               3. Write the command to assemble the file and create the#
#                  OBJ files in BUILD_DIR.                              #
#               4. Create the Module Binary File in BUILD_DIR.          #

#-----------------------------------------------------------------------#
# Specify the user defined ADDON ROMs to be put into the final ROM file.#
# These ADDON ROMs binary files must be present in ADDON_ROM directory. #
#-----------------------------------------------------------------------#
PCI_ROM1           = 1            # 1 = PCI ROM1 present in ADDON_ROM dir #
PCI_ROM1_FILENAME  = 530v107.rom  # PCI ADDON ROM1 Filename.Ext          #
PCI_ROM1_DEVICEID  = 6306         # PCI ADDON ROM1 Device ID              #
PCI_ROM1_VENDORID  = 1039         # PCI ADDON ROM1 Vendor ID              #

PCI_ROM2           = 0            # 1 = PCI ROM2 present in ADDON_ROM dir #
PCI_ROM2_FILENAME  =              # PCI ADDON ROM2 Filename.Ext           #
PCI_ROM2_DEVICEID  =              # PCI ADDON ROM2 Device ID              #
PCI_ROM2_VENDORID  =              # PCI ADDON ROM2 Vendor ID              #

PCI_ROM3           = 0          # 1 = PCI ROM3 present in ADDON_ROM dir #
PCI_ROM3_FILENAME  =            # PCI ADDON ROM3 Filename.Ext           #
PCI_ROM3_DEVICEID  =            # PCI ADDON ROM3 Device ID              #
PCI_ROM3_VENDORID  =            # PCI ADDON ROM3 Vendor ID              #

PCI_ROM4           = 0          # 1 = PCI ROM4 present in ADDON_ROM dir #
PCI_ROM4_FILENAME  =            # PCI ADDON ROM4 Filename.Ext           #
PCI_ROM4_DEVICEID  =            # PCI ADDON ROM4 Device ID              #
PCI_ROM4_VENDORID  =            # PCI ADDON ROM4 Vendor ID              #

USER_ROM1          = 0          # 1 = USER ROM1 present                 #
USER_ROM1_MODULEID =            # User ROM1 Module ID (e.g. 29,2A, etc.)#
USER_ROM1_FILENAME =            # User ROM1 Filename.Ext                #
USER_ROM1_DESTSEG  =            # User ROM1 Destination Segment         #
USER_ROM1_DESTADDR =            # User ROM1 Destination Address         #

USER_ROM2          = 0          # 1 = USER ROM2 present                 #
USER_ROM2_MODULEID =            # User ROM2 Module ID (e.g. 29,2A, etc.)#
USER_ROM2_FILENAME =            # User ROM2 Filename.Ext                #
USER_ROM2_DESTSEG  =            # User ROM2 Destination Segment         #
USER_ROM2_DESTADDR =            # User ROM2 Destination Address         #
#-----------------------------------------------------------------------#
!INCLUDE ..\..\core.mak
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
