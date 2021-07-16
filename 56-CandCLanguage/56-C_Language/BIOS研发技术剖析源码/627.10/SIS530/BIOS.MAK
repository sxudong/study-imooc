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
# These flags should be set to control BIOS building.                   #
#-----------------------------------------------------------------------#
CHIPSETNAME     = SIS530        # 8 characters max. Chipset name        #
                                # Note: use upper case only             #
EVAL            = 0             # 1 -> Evaluation BIOS                  #
                                # 0 -> Production BIOS                  #
CPU_STRING      = 6             # CPU type, 3/4/5 = 386/486/Pentium     #
MAJOR_VER       = 10            # 2 decimal digits only. (01,02,03..99) #
MINOR_VER       = 29            # 2 decimal digits only. (01,02,03..99) #
REF_NUMBER      = 009999        # 6 decimal digits only.                #
                                                                        # (CORE0071+)>
#-----------------------------------------------------------------------#
# Select the ROM size.                                                  #
#-----------------------------------------------------------------------#
BIOS_SIZE       = 1             # 0=64K, 1=128K, 2=256K, 3=512K, ...... #
#-----------------------------------------------------------------------#
#                       P6 micro code files                             #
#-----------------------------------------------------------------------#
MICRO_CODE_FILES =                                                      #
                                                                        # <(CORE0071+)
#-----------------------------------------------------------------------#
#                       FLASH ROM SUPPORT                               #
#-----------------------------------------------------------------------#
FLASH_4GB       = 1             # 1 -> To access Flash NVRAM below 4GB  #
                                # 0 -> To access Flash NVRAM below 1MB  #
                                # Only Intel28F001BX-T, SST29EE010,     #
                                # Atmel29C010, Winbond29EE011 are       #
                                # supported using 4GB method.           #
                                # INDEX_DATA is valid only if FLASH_4GB #
                                # is set to 0.                          #
INDEX_DATA      = 0             # 0 -> To access chipset, only Data port#
                                #      is needed after Index is output. #
                                # 1 -> To access chipset Index and Data #
                                #      ports are needed                 #

SST             = 1             # 1 -> SST 29EE010 5V Flash             #
                                # SHOULD BE SELECTED ALWAYS, if 128K    #
                                # BIOS is generated                     #
INTEL           = 0             # 1 -> Intel 28F001BXT 12V Flash        #
ATMEL           = 1             # 1 -> ATMEL 29C010 5V Flash            #
WINBOND         = 1             # 1 -> WINBOND 29EE011 5V Flash         #
                                #               or                      #
                                #      MegaFlash 5V Flash               #
AMD             = 0             # 1 -> AMD 29F010 5V Flash              #
MXIC            = 0             # 1 -> MXIC 28F1000 12V Flash           #
MXIC_P          = 0             # 1 -> MXIC 28F1000P 12V Flash (BIOS_SIZE=1)#
                                #      MXIC 28F2000P 12V Flash (BIOS_SIZE=2)#
MXIC_T          = 0             # 1 -> MXIC 28F2000T 12V Flash          #
MXIC_29F002T    = 0             # 1 -> MXIC 29F002T 5V 256K flash (CORE0208+)
MXIC_29F001T    = 0             # 1 -> MXIC 29F001T 5V 128K flash (CORE0213+)
MOSEL_V29C51002T= 0             # 1 -> MOSEL V29C51002T 5V 256K flash   # (CORE0215+)
AT49F002T       = 0             # 1 -> ATMEL 49F002T 5V 256K flash      # (CORE0216+)
PMC29F002T      = 0             # 1 -> PMC 29F002T 5V 256K flash        # (CORE0224+)
#-----------------------------------------------------------------------#
#                       BOOT BLOCK BIOS                                 #
#-----------------------------------------------------------------------#
# the filename and extension of binary ROM file which will be searched  #
# by Boot Block BIOS in root directory of diskette in floppy drive A:   #

BOOT_BLOCK      = 1             # 1 -> Boot Block support present       #
                                # The Flash ROMs are selected in        #
                                # Flash ROM Support                     #
PGM_FILENAME    = AMIBOOT       # Program ROM filename (8 char)         #
                                # Note: use upper case only             #
PGM_FILEEXT     = ROM           # Program ROM file extension (3 char)   #
                                # Note: use upper case only             #
#-----------------------------------------------------------------------#
#                       MISC. INFORMATION                               #
#-----------------------------------------------------------------------#
# select method of generating delay                                     #
SOFT_DELAY      = N             # N -> delay routine use refresh signal.#
                                # a numeric value represents software   #
                                # LOOP count. numeric value depends on  #
                                # CPU clock e.g.                        #
                                # 18 -> 33MHz, 36 -> 66MHz, etc.        #
                                # Example: SOFT_DELAY = 1D              #

# select keystrokes to be checked for forced flash programming.         #
# IF ONLY ONE KEYSTROKE IS USED, MAKE BOTH SCAN CODE SAME.              #

KEY1_SCAN       = 1D            # N -> this key is NOT used.            #
                                # a numeric value represents the        #
                                # scan code for that key                #
                                # e.g. 1D -> scan code for <CTRL> key   #
KEY2_SCAN       = 47            # N -> this key is NOT used.            #
                                # a numeric value represents the        #
                                # scan code for that key                #
                                # e.g. 47 for scan code for <HOME> key  #

# select what will Boot Block BIOS do after successful Flash programming#

AFTER_PGM       = 0             # 0 -> re-start the system              #
                                # 1 -> halt with continuous beep        #
#-----------------------------------------------------------------------#
#               DIFFERENT BUS SUPPORT e.g. PCI, PnP, EISA, etc.         #
#-----------------------------------------------------------------------#
DIM_SUPPORT     = 1             # 1 -> DIM supported                    #
                                #  the following variables e.g. INC_ISA,#
                                # INC_EISA, PCI_BRIDGE, etc. is valid   #
                                # only if DIM_SUPPORT is 1.             #

INC_ISA         = 1             # 1 -> Include ISA Device Initializer   #
INC_EISA        = 0             # 1 -> Include EISA Device Initializer  #
INC_EISA_32     = 0             # 1 -> Include EISA 32-bit runtime code #

INC_PCI         = 1             # 1 -> Include PCI Device Initializer   #
PCI_BRIDGE      = 1             # 1 -> Include PCI-PCI Bridges support  #
MULTI_HOST_BR   = 0             # 1 -> Include support for muliple PCI  #
                                #      host bridges                     #
VUMA_SUPPORT    = 1             # 1 -> Include VUMA support             #
SMBA_SUPPORT    = 0             # 1 -> Include SMBA support             #
PCI_MANUAL      = 0             # 1 -> Include PCI manual config code   #
                                # 0 -> Include PCI non-compliant table code

INC_PNP         = 1             # 1 -> Include PNP Device Initializer   #
BAD_PNP_CARD    = 1             # 1 -> Include support for bad PnP cards#
                                # If set to 1, BIOS will NOT initialize #
                                # the PnP cards and set PnP Aware OS    #
                                # to enabled so that these cards can be #
                                # initialized by the OS.                #
                                # WE ARE NOT SURE about the problem if  #
                                # BIOS initializes these cards.         #
                                # See OEMPDIM.ASM file for details.     #
WRITE_ESCD      = 1             # 1 -> Include code to generate ESCD    #

INC_PS2_MOUSE   = 1             # 1 -> Include PS/2 Mouse device node   #
INC_VLBUS       = 0             # 1 -> Include VLBUS device node        #
# Select type of storage to be used for PnP NVRAM.                      #
# The following variables are valid only if INC_EISA is set to 0.       #
# If INC_EISA is set to 1 then EISA CMOS will be used for PnP NVRAM and #
# in that case the following variables are don't care.                  #

NONEISA_NVRAM   = 1             # 1 -> PnP NVRAM is supported for       #
                                # non-EISA board                        #
                                # 0 -> PnP NVRAM is not supported for   #
                                # non-EISA board                        #

NVRAM_FLASH     = 1             # 1 -> PnP NVRAM is supported through   #
                                # Flash. Flash parts are selected in    #
                                # Flash Part Support. This variable     #
                                # NVRAM_FLASH is valid only if variable #
                                # NONEISA_NVRAM is set to 1.            #
                                # 0 -> PnP NVRAM is supported through   #
                                # I/O mapped devices.                   #

NVRAM_DALLAS    = 0             # 1 = PNP NVRAM is supported through    #
                                # DALLAS I/O mapped part, This variable #
                                # is valid only if NVRAM_FLASH variable #
                                # is 0 AND the NONEISA_NVRAM is 1.      #
#-----------------------------------------------------------------------#
#                       ACPI SUPPORT                                    #
#-----------------------------------------------------------------------#
ACPI_SUPPORT    = 0             # 1 = ACPI Support                      #
ACPI_APIC_TBL   = 0             # 1 = APIC support in ACPI              #
                                #       ACPI_APIC_TBL is valid only if  #
                                #       APIC_SUPPORT is set to 1        #
ACPI_QUICK_BOOT = 0                     # For On Now Fast Boot Support          #
ACPI_S4BIOS     = 0                     # For S4BIOS Support                            #
#-----------------------------------------------------------------------#
#                       GREEN PC AND USB SUPPORT                        #
#-----------------------------------------------------------------------#
GPC_SUPPORT     = 1             # 1 -> GreenPC Support present          #
                                # If this is set to 0, then USB flag is #
                                # don't care.                           #
USB_SUPPORT     = 1             # 1 -> USB Support present              #
                                # This is valid only if GPC_SUPPORT is  #
                                # set to 1.                             #
                                # If this is set to 0, the USB_HCI flag #
                                # is don't care.                        #
USB_UHCI_OHCI   = 1             # Defines USB HOST Controller Interface.#
                                # 0 -> UHCI (Intel, VIA, etc.)          #
                                # 1 -> OHCI (SiS, UMC, CMD, etc.)       #
                                # This flag is valid only if USB_SUPPORT#
                                # flag is set to 1.                     #
#-----------------------------------------------------------------------#
#                       DMI SUPPORT                                     #
#-----------------------------------------------------------------------#
DMI_SUPPORT     = 1             # 1 -> DMI Support present              #
                                # Runtime DMI functions will be         #
                                # available only if DIM_SUPPORT and     #
                                # INC_PNP are selected                  #
#-----------------------------------------------------------------------#
# Multi Language Support                                                #
#-----------------------------------------------------------------------#
ML_MODULE          = 0          # 1 = Multi-Language Module present (Big5 Chinese)
                                # 2 = GB code Chinese
                                # 3 = Big5 Japanese
NO_LANGUAGES       = 1          # language numbers (default=1: English)
ML_MODULE_FILENAME = $(BUILD_DIR)\ML.BIN        # Multi Language Module Filename.Ext    #
ML_MODULE_DESTSEG  = 7000       # Multi Language Module Dest Segment    #
ML_MODULE_DESTADDR = 0000       # Multi Language Module Dest Addr       #
#-----------------------------------------------------------------------#
#               DIFFERENT MODULE SUPPORT                                #
#-----------------------------------------------------------------------#
# Extra space will be available for BIOS porting, if one or more of     #
# these modules are not selected.                                       #
#-----------------------------------------------------------------------#
                                # (CORE0073+)>
NO_BOOTBLOCK            = 0     # 1 = Remove Bootblock support
SPLIT_ROM               = 0     # 1 = Split Setup Client to Bootblock
                                # <(CORE0073+)
#-----------------------------------------------------------------------#
CNVRAM                  = 0     # 1 = CMOS can be saved/restored to/from NVRAM (called CNVRAM) # (CORE0210+)
BOOTBLOCK_LS120         = 0     # 1 = Include LS120 support if BIOS_SIZE>1                      # (CORE0211+)
#-----------------------------------------------------------------------#
FLOPPY_3MODE    = 0             # 1 = 3Mode/Japanese Floppy support     #
BIOS_FLOPPY_SWAP= 1             # 1 = Software floppy swap code         # $$$CORE0067
SILENT_BOOT     = 0             # 1 = Silent Boot Support               #
INT10           = 1             # 1 = CGA/Mono Video Support            #
VIRUS           = 0             # 1 = BootSector Virus Protection support
TREND_ANTI_VIRUS= 0             # Trend Anti Virus ROM segment
                                # 0 = not support
FLOPTICAL       = 1             # 1 = ATAPI Floptical Drive supported   #
SMART_IDE       = 0             # 1 = S.M.A.R.T. Feature for Hard Disk  #
DISP_CONFIG     = 1             # 1 = System config display before boot # (CORE0228+)
DISP_PCIPNP     = 1             # 1 = Displays PCI/PnP cards in system  #
                                #     configuration display             #
EXTRA_INT16     = 1             # 1 = INT-16 extra fn E0xx support      #
EXTRA_INT16_F0  = 0             # 1 = INT16 extra fn F0xx support       #
                                # The switch EXTRA_INT16_F0 is valid    #
                                # only if EXTRA_INT16 is set to 1 i.e.  #
                                # to have INT16 fn F0xx support, fn E0xx#
                                # support must be present.              #
ADDR_LINE_TEST  = 1             # 1 = Include Address Line test during  #
                                #     memory test.                      #
CPU_OVERRIDE    = 0             # 1 = CPU Override Selection available  #
                                #     in Setup.                         #
CTRL_ALT        = 0             # 1 = Include CHANGE_SPEED support      #
                                # by <CTRL><ALT><+>/<->, etc.           #
TURBO_SWITCH    = 0             # 1 = Turbo switch support thru' KBC pin#
KB_PS2_CONNECTOR_SWAP = 0       # 1 = Include Keyboard and PS2 connector#
                                #     swap support.                     #
                                # ===== NOTE ==== NOTE ==== NOTE ====== #
                                # This switch can be set to 1 only if   #
                                # the AMI KB-5 keyboard controller is   #
                                # used.                                 #
                                # ===================================== #
MEGAKEY         = 0             # 1 = MEGAKEY Keyboard Controller support
#(CORE0072+)>
#-------------------------- GPNV Support -------------------------------#
GPNV_SUPPORT    = 0             # 1 = GPNV support                      #
GPNV_FLASH      = 0             # 0 = GPNV in IO Mapped NVRAM           #
                                # 1 = GPNV in Memory Mapped Flash Block #
EVENT_LOG       = 0             # 1 -> Event log type added to GPNV     # (CORE0218+)
# NOTE : GPNV_FLASH switch is valid only if GPNV_SUPPORT = 1. If        #
# GPNV_FLASH = 1, then GPNV uses a separate block of Flash. This Flash  #
# Block used for GPNV is NOT the same block used for ESCD. So BIOS with #
# GPNV support using a Flash Block can not be flashed with a BIOS       #
# without GPNV support or with a BIOS with GPNV support in IO mapped    #
# NVRAM unless the whole Flash is reporgrammed.                         #
# SO CARE MUST BE TAKEN BEFORE GPNV_FLASH IS SET TO 1.                  #
#<(CORE0072+)
#-------------------------- I2O Support --------------------------------#
I2O_SUPPORT     = 0             # 1 = I2O support                       #
#-----------------------------------------------------------------------#
#                       SETUP USER INTERFACE SUPPORT                    #
#-----------------------------------------------------------------------#
SUI_SUPPORT     = 1             # 1 = BIOS will support CMOS SETUP      #
                                # 0 = BIOS will not support CMOS SETUP  #
                                # i.e. SETUP can not be invoked at all  #
SUI_FILE        = $(CORE_DIR)\hiflex.bin
                                # filename of setup user interface      #
                                # WINSETUP.BIN = WinBIOS Setup          #
                                # HIFLEX.BIN = HiFlex  Setup            #
#-----------------------------------------------------------------------#
#                               RUN AMIBCP                              #
#-----------------------------------------------------------------------#
RUN_BCP         = 0             # 1 = Run AMIBCP after building BIOS    #
#-----------------------------------------------------------------------#
LM75_SUPPORT    = 0             # 1 = NS LM78 support
#-----------------------------------------------------------------------#
!INCLUDE path.mak
#-----------------------------------------------------------------------#
#                       CHIPSET IO MODULE                               #
# IO Module selection is done in OEM.MAK file. Please add any extra IO  #
# module here. For example, if PIIX3 PCI IDE is supported, please add   #
# corresponding routine here as follows:                                #
#       IO_PERIPHERALS  =$(IO_PERIPHERALS)\                             #
#       PIIX3IdeController                                              #
#-----------------------------------------------------------------------#
!if $(DIM_SUPPORT) && $(INC_PCI)
IO_PERIPHERALS  = $(IO_PERIPHERALS)\
SystemPciBus
!endif

IO_PERIPHERALS  =$(IO_PERIPHERALS)\
SIS5513IdeController

!if $(DIM_SUPPORT) && $(INC_PS2_MOUSE)
IO_PERIPHERALS  = $(IO_PERIPHERALS)\
SystemPS2Mouse
!endif

!if $(DIM_SUPPORT) && $(INC_VLBUS)
IO_PERIPHERALS  = $(IO_PERIPHERALS)\
SystemVlBus
!endif
#-----------------------------------------------------------------------#
# These macros defines the include files that are used by each chipset  #
# module. If an include file is changed, NMAKE must rebuild any .ASM    #
# file(s) that use the changed include file.                            #
#-----------------------------------------------------------------------#
MEMORY_INCS     =
POST_INCS       =
NPOST_INCS      =
RUNTIME_INCS    =
NRUNTIME_INCS   =
GPM_INCS        = $(GPC_PORT_DIR)\gpm.css $(GPC_PORT_DIR)\gapm.css $(GPC_PORT_DIR)\cssgpm.dat $(GPC_PORT_DIR)\cssgpm.equ $(GPC_PORT_DIR)\gpm.cfg $(ACPI_PORT_DIR)\acpi.equ $(ACPI_PORT_DIR)\acpi_css.equ $(OEM_PORT_DIR)\acpi_oem.equ
APM_INCS        = $(GPC_PORT_DIR)\gapmnsmi.css $(GPC_PORT_DIR)\gpm.cfg
USB_INCS        =
# ACPI_SUPPORT
ACPI_INCS       = $(ACPI_PORT_DIR)\acpi.equ $(ACPI_PORT_DIR)\acpi_css.equ $(ACPI_PORT_DIR)\acpi_css.inc $(OEM_PORT_DIR)\acpi_oem.equ $(OEM_PORT_DIR)\acpi_oem.inc $(ACPI_PORT_DIR)\acpi.dat
#ASL_INCS       = $(ACPI_ASL_DIR)\ami.asl
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
