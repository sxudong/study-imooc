#**********************************************************************;
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
#**********************************************************************;
#                                                                       #
#!!!!!!!!!!!!!!!!!!!!!! DESKTOP SPECIFIC !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
#                                                                       #
# The ASL file structure builder module                                 #
#-----------------------------------------------------------------------#
# ACPI_ASL_PATH macro has a path to ASL Project direcory (ASL style)    #
#-----------------------------------------------------------------------#
ACPI_ASL_PATH           = $(ACPI_ASL_DIR:\=\\)\\
INCLUDE_ASL_PATH	= $(ASL_LIB_PATH)
!if $(ARC_LIB)
COPY                    = pkunzip -e -o $(ASL_LIB_PATH)\asllib.zip
INCLUDE_ASL_PATH	= INCLUDE.ASL
!endif
#-----------------------------------------------------------------------#
# PATH into Library INCLUDE.ASL files                               	#
#-----------------------------------------------------------------------#
CUSTOM_PATH		= $(INCLUDE_ASL_PATH)\CUSTOM
PCI_DEV_PATH            = $(INCLUDE_ASL_PATH)\PCIDEV
OEMIO_PATH		= $(INCLUDE_ASL_PATH)\OEMIO
OEMIO_PATH_AUDIO	= $(OEMIO_PATH)\AUDIO
OEMIO_PATH_SUPERIO      = $(OEMIO_PATH)\SUPERIO
SMBAT_PATH 		= $(INCLUDE_ASL_PATH)\SMBAT
SYSTEM_PATH             = $(INCLUDE_ASL_PATH)\SYSTEM
TSENSOR_PATH            = $(INCLUDE_ASL_PATH)\TSENSOR
DOCK_PATH		= $(INCLUDE_ASL_PATH)\DOCK
#-----------------------------------------------------------------------#
# Add new macros if any new hardware support added                      #
#-----------------------------------------------------------------------#
#-----------------------------------------------------------------------#
# PCI North bridge name. Default : Intel 440BX				#
#-----------------------------------------------------------------------#
!if $(A_N_I430TX)
A_NRTH_BRG_PATH	= i430tx
!elseif $(A_N_I440LX)
A_NRTH_BRG_PATH	= i440lx
!elseif $(A_N_I440EX)
A_NRTH_BRG_PATH	= i440ex
!elseif $(A_N_I440GX)
A_NRTH_BRG_PATH	= i440gx
!elseif $(A_N_ALI1541)
A_NRTH_BRG_PATH	= ALI1541
!elseif $(A_N_ALI1621)
A_NRTH_BRG_PATH	= ALI1621
!elseif $(A_N_CAMINO)
A_NRTH_BRG_PATH	= Camino
!elseif $(A_N_CYRIX30)
A_NRTH_BRG_PATH	= cyrix30
!elseif $(A_N_FIRESTAR)
A_NRTH_BRG_PATH	= firestar
!elseif $(A_N_SIS5598)
A_NRTH_BRG_PATH	= sis5598
!elseif $(A_N_SIS5600)
A_NRTH_BRG_PATH	= sis5600
!elseif $(A_N_SIS530)
A_NRTH_BRG_PATH	= sis530
!elseif $(A_N_SIS620)
A_NRTH_BRG_PATH	= sis620
!elseif $(A_N_VIA82588)
A_NRTH_BRG_PATH	= via82588
!elseif $(A_N_VIA82595)
A_NRTH_BRG_PATH	= via82595
!elseif $(A_N_VIA82691)
A_NRTH_BRG_PATH	= via82691
!else
A_NRTH_BRG_PATH	= i440bx
!endif
#-----------------------------------------------------------------------#
# PCI South bridge macros. Default : Intel PIIX4                        #
#-----------------------------------------------------------------------#
!if $(A_S_ALI1543)
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\ALI1543
!elseif $(A_S_FIRESTAR)
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\FIRESTAR
!elseif $(A_S_VIA82586)
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\VIA82586
!elseif $(A_S_VIA82586)
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\VIA82595
!elseif $(A_S_CYRIX30)
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\CYRIX30
!elseif $(A_S_ICH)
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\ICH
!elseif $(A_S_SIS5595)	
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\sis5595
!else
A_SOUTH_BRG_PATH	= $(PCI_DEV_PATH)\PIIX4
!endif
#-----------------------------------------------------------------------#
A_S_IRQ_FIXED		= 0
# ALI1543
!if $(A_S_ALI1543)
A_IDE_DEV_FUN_Adr       = $(M5229_Dev_Number:h=)0000
A_USB_DEV_FUN_Adr       = $(M5237_Dev_Number:h=)0000
A_PMU_DEV_FUN_Adr 	= $(M7101_Dev_Number:h=)0000
A_S_IRQ_FIXED		= 1
# ALI1543 USB device
A_S_PIC_IRQ_TABLE	= Package(){0x$(M5237_Dev_Number:h=)ffff, 0, LNKU, 0},
A_S_APIC_IRQ_TABLE	= Package() {0x01ffff, 0, 0, 0x$(A_PCI_INTD_APIA)},^
		Package() {0x01ffff, 1, 0, 0x$(A_PCI_INTD_APIB)},^
		Package() {0x02ffff, 0 ,0, 0x$(A_PCI_INTD_APIA)},
# CYRIX30
!elseif $(A_S_CYRIX30)
A_IDE_DEV_FUN_Adr 	= $(A_IDE_DEV_Nbr)00$(A_IDE_FUN_Nbr)
A_USB_DEV_FUN_Adr 	= $(A_USB_DEV_Nbr)00$(A_USB_FUN_Nbr)
# Warning. The PMU address is wrong.
A_PMU_DEV_FUN_Adr 	= $(A_S_DEV_Nbr)0000
# I_ICH
!elseif $(A_S_ICH)
A_IDE_DEV_FUN_Adr 	= 001F0001
A_USB_DEV_FUN_Adr 	= 001F0002
A_PMU_DEV_FUN_Adr 	= $(A_S_DEV_Nbr)0000
A_S_IRQ_FIXED		= 1
A_S_PIC_IRQ_TABLE	= Package(){0x01f0002, 3, LNKD, 0},^
                Package(){0x01f0003, 1, LNKB, 0},^
                Package(){0x01f0005, 1, LNKB, 0},^
                Package(){0x01f0006, 1, LNKB, 0},
A_S_APIC_IRQ_TABLE	= Package(){0x01f0002 3, 0, 0x$(A_PCI_INTD_APIC)},^
                Package(){0x01f0003 1, 0, 0x$(A_PCI_INTB_APIC)},^
                Package(){0x01f0005 1, 0, 0x$(A_PCI_INTB_APIC)},^
                Package(){0x01f0006 1, 0, 0x$(A_PCI_INTB_APIC)},
!elseif $(A_S_SIS5595)
A_IDE_DEV_FUN_Adr       = $(A_IDE_DEV_Nbr)00$(A_IDE_FUN_Nbr)
A_USB_DEV_FUN_Adr       = $(A_S_DEV_Nbr)0002
A_PMU_DEV_FUN_Adr       = $(A_S_DEV_Nbr)0001
A_S_IRQ_FIXED		= 1
# SIS5595 USB device
A_S_PIC_IRQ_TABLE	= Package(){0x$(A_S_DEV_Nbr)ffff, 0, LNKU, 0},
#A_S_APIC_IRQ_TABLE	= Package(){0x$(A_USB_DEV_Nbr)ffff, 0, 0, 0x$(A_PCI_INTD_APIC)},
!else
A_IDE_DEV_FUN_Adr 	= $(A_S_DEV_Nbr)0001
A_USB_DEV_FUN_Adr 	= $(A_S_DEV_Nbr)0002
A_PMU_DEV_FUN_Adr 	= $(A_S_DEV_Nbr)0003
A_S_IRQ_FIXED		= 1
# PIIX4 Fun 2 USB device
A_S_PIC_IRQ_TABLE	= Package(){0x$(A_S_DEV_Nbr)ffff, 3, LNKD, 0},
A_S_APIC_IRQ_TABLE	= Package(){0x$(A_S_DEV_Nbr)ffff, 3, 0, 0x$(A_PCI_INTD_APIC)},
!endif
#-----------------------------------------------------------------------#
# List of devices supporting PMU PCI device (return the PM & SMBase I/O address)
A_PMU_ALL		= ($(A_S_PIIX4) || $(A_S_ALI1543)\
 || $(A_S_CYRIX30) || $(A_S_FIRESTAR) || $(A_S_VIA82586)\
 || $(A_S_VIA82595) || $(A_S_ICH)) || $(A_S_SIS5595) # James
#-----------------------------------------------------------------------#
# List of devices supporting USB as a part of South Bridge
A_USB_ALL		= ($(A_S_PIIX4) || $(A_S_ALI1543) || $(A_S_CYRIX30)\
 || $(A_S_VIA82586) || $(A_S_VIA82595) || $(A_S_ICH)) || $(A_S_SIS5595) # James
#-----------------------------------------------------------------------#
# path to SMBus host controller module
#-----------------------------------------------------------------------#
!if $(A_SMBUS)
A_SMB_HOST_PATH		= $(A_SOUTH_BRG_PATH)\smb_host.asl
!endif
#-----------------------------------------------------------------------#
# path to IDE PM control module
#-----------------------------------------------------------------------#
!if $(A_IDE_PM)
A_IDE_PM_PATH           = $(A_SOUTH_BRG_PATH)\pci-ide0.asl
!endif
#-----------------------------------------------------------------------#
# path to SuperIO module
#-----------------------------------------------------------------------#
A_OEMIO_PATH_SUPERIO	=

!ifdef SMC932_SMC935
! if $(SMC932_SMC935)
A_OEMIO_PATH_SUPERIO	= SMC93x
! endif
!endif

!ifdef SMC60X
! if $(SMC60X)
A_OEMIO_PATH_SUPERIO   = SMC60x
! endif
!endif

!ifdef SMC665                   #|| SMC665IR
! if $(SMC665) || $(SMC665IR)
A_OEMIO_PATH_SUPERIO	= SMC665
! endif
!endif

!ifdef SMC67X
! if $(SMC67X)
A_OEMIO_PATH_SUPERIO	= SMC67x
! endif
!endif

!ifdef ALI5135                  #|| ALI513X
! if $(ALI5135)
A_OEMIO_PATH_SUPERIO	= ALI5135F
! endif
!endif

!ifdef NAT307
! if $(NAT307)
A_OEMIO_PATH_SUPERIO	= NAT307
! endif
!endif

!ifdef NAT308                   #|| NAT317
! if $(NAT308)# || $(NAT317)
A_OEMIO_PATH_SUPERIO	= NAT308
! endif
!endif

!ifdef NAT309
! if $(NAT309)
A_OEMIO_PATH_SUPERIO	= NAT309
! endif
!endif

!ifdef NAT312
! if $(NAT312)
A_OEMIO_PATH_SUPERIO	= NAT312
! endif
!endif

!ifdef NAT338
! if $(NAT338)
A_OEMIO_PATH_SUPERIO	= NAT338
! endif
!endif

!ifdef WIN877
! if $(WIN877)
A_OEMIO_PATH_SUPERIO	= WIN877
! endif
!endif

!ifdef WIN977AF                 #|| WIN977
! if $(WIN977) || $(WIN977AF)
A_OEMIO_PATH_SUPERIO	= WIN977
! endif
!endif

!ifdef WIN977TF
! if $(WIN977TF)
A_OEMIO_PATH_SUPERIO	= WIN977TF
! endif
!endif

!ifdef ITE8680
! if $(ITE8680)
A_OEMIO_PATH_SUPERIO	= ITE8761F
! endif
!endif

!ifdef ITE8661
! if $(ITE8661)
A_OEMIO_PATH_SUPERIO	= ITE8661F
! endif
!endif

!ifdef GM803C
! if $(GM803C)
A_OEMIO_PATH_SUPERIO	= GM803C
! endif
!endif

#-----------------------------------------------------------------------#
# path to Audio module
#-----------------------------------------------------------------------#
!if $(A_ESS1888)
A_OEMIO_PATH_AUDIO	= ESS1888
!elseif $(A_ESS1887)
A_OEMIO_PATH_AUDIO	= ESS1887
!elseif $(A_ESS1887)
A_OEMIO_PATH_AUDIO	= ESS1878
!elseif $(A_ESS1869)
A_OEMIO_PATH_AUDIO	= ESS1869
!else
A_OEMIO_PATH_AUDIO	=
!endif
#-----------------------------------------------------------------------#
# path to thermal sensor module. Default path : nosensor.asl
#-----------------------------------------------------------------------#
!  if $(A_LM75)
A_T_SENSOR_PATH		= $(TSENSOR_PATH)\lm75.asl
!  elseif $(A_MAX1617L)
A_T_SENSOR_PATH		= $(TSENSOR_PATH)\max1617l.asl
!  elseif $(A_MAX1617R)
A_T_SENSOR_PATH		= $(TSENSOR_PATH)\max1617r.asl
!  else
A_T_SENSOR_PATH		= $(TSENSOR_PATH)\nosensor.asl
!  endif
#-----------------------------------------------------------------------#
# path to FAN module
#-----------------------------------------------------------------------#
!if "$(A_FAN_ISA_IO_Adr)" != ""
A_FAN_FIELD		= Field (FNOR, ByteAcc, NoLock, Preserve)
!elseif "$(A_FAN_INDEX_DATA_IO_Adr)" != ""
A_FAN_FIELD		= IndexField(FIND, FDTA,ByteAcc, NoLock, Preserve)
!endif

!  if $(A_FAN_MODEL_1)
A_FAN_PATH		= $(SYSTEM_PATH)\fan1.asl
!  elseif $(A_FAN_MODEL_2)
A_FAN_PATH		= $(SYSTEM_PATH)\fan2.asl
!  elseif $(A_FAN_MODEL_3)
A_FAN_PATH		= $(SYSTEM_PATH)\fan3.asl
!  elseif $(A_FAN_OEM)
A_FAN_PATH		= $(CUSTOM_PATH)\CUST_FAN.oem
!else
A_FAN_PATH		=
!endif
#-----------------------------------------------------------------------#
# path to System Indication mudule
#-----------------------------------------------------------------------#
! if $(A_SI_MODEL_1)
A_SI_PATH		= $(SYSTEM_PATH)\si_1.asl
! elseif $(A_SI_MODEL_2)
A_SI_PATH		= $(SYSTEM_PATH)\si_2.asl
! elseif $(A_SI_MODEL_3)
A_SI_PATH		= $(SYSTEM_PATH)\si_3.asl
! elseif $(A_SI_OEM)
A_SI_PATH		= $(CUSTOM_PATH)\CUST_SI.oem
!else
A_SI_PATH		=
!endif
!if "$(A_SI_ISA_IO_Adr)" != ""
A_SI_FIELD              = Field (SIOR, ByteAcc, NoLock, Preserve)
!elseif "$(A_SI_INDEX_DATA_IO_Adr)" != ""
A_SI_FIELD              = IndexField(SIND, SDTA,ByteAcc, NoLock, Preserve)
!endif
#-----------------------------------------------------------------------#
# !!!!!!!!!!!!!!!!!!    END OF MACRO DEFINITIONS    !!!!!!!!!!!!!!!!!!! #
#-----------------------------------------------------------------------#
#-----------------------------------------------------------------------#
#  Set of rules to create ASL Project files                             #
#-----------------------------------------------------------------------#
$(ACPI_ASL_DIR)\oemdsdt.asl:
# James
#PREBUILD:
#
#CLEANUP:
#
#$(BIOSFILE).rom: $(ACPI_ASL_DIR)\*.*  $(ASL_PORT)
#!if [choice ASL Builder process ready to update ASL project files. Your vote-] == 1
#-----------------------------------------------------------------------#
# Preserve existing ASL project files to CUSTOM_PATH\ASLOLD\ directory	#
#-----------------------------------------------------------------------#
!if !$(ARC_LIB)
	-@$(COPY) $(ACPI_ASL_DIR)\CUST_*.oem $(CUSTOM_PATH)
!endif
#	@MD $(ACPI_ASL_DIR)\ASLOLD
#        @DELTREE -Y $(ACPI_ASL_DIR)\ASLOLD\*.*
#        -@attrib -r $(ACPI_ASL_DIR)\*.*
#	-@move $(ACPI_ASL_DIR)\*.* $(ACPI_ASL_DIR)\ASLOLD
#-----------------------------------------------------------------------#
#                        GENERATE AMI.ASL file                          #
#-----------------------------------------------------------------------#
    copy << $(ACPI_ASL_DIR)\$(ASL_NAME).asl
DefinitionBlock (
        "$(ASL_NAME).AML",
        "DSDT",
        0x01,
        "$(A_OEM_ID)",          // OEM ID (6 byte string)
        "$(A_OEM_TABLE_ID)",    // OEM table ID  (8 byte string)
        0x$(A_OEM_REV)          // OEM version of DSDT table (4 byte Integer)
	)
//--------------------------------------------------------------------------
// BEGIN OF ASL SCOPE
//--------------------------------------------------------------------------
{
Scope(\_PR)     {               // BEGIN PROCESSOR PACKAGE
	Processor( CPU1,
// ProcessorID (unique for each CPU)
                1,
// PBlockAddress
!if "$(A_CPU_PBLK)" != ""
                0x$(A_CPU_PBLK),
// PBlockLength hardwired to 6 byte
                0x06
!else
                0,
                0
!endif
	){}
!if $(NCPU) > 1
	Processor( CPU2,
// ProcessorID (unique for each CPU)
                2,
// PBlockAddress
!if "$(A_CPU_PBLK)" != ""
                0x$(A_CPU_PBLK),
// PBlockLength hardwired to 6 byte
                0x06
!else
                0,
                0
!endif
	){}
!endif
!if $(NCPU) > 2
	Processor( CPU3,
// ProcessorID (unique for each CPU)
                3,
// PBlockAddress
!if "$(A_CPU_PBLK)" != ""
                0x$(A_CPU_PBLK),
// PBlockLength hardwired to 6 byte
                0x06
!else
                0,
                0
!endif
	){}
!endif
!if $(NCPU) > 3
	Processor( CPU4,
// ProcessorID (unique for each CPU)
                4,
// PBlockAddress
!if "$(A_CPU_PBLK)" != ""
                0x$(A_CPU_PBLK),
// PBlockLength hardwired to 6 byte
                0x06
!else
                0,
                0
!endif
	){}
!endif
        }                       // end CPU scope

// Value to be set in SLP_TYP register
	Name(\_S0, Package(4){$(A_S0),0,0,0})	// working state on this chip set
!if "$(A_S1)" != ""
	Name(\_S1, Package(4){$(A_S1),0,0,0})	// Power on suspend with CPU context maintained.
!endif
!if "$(A_S2)" != ""
	Name(\_S2, Package(4){$(A_S2),0,0,0})	// Power on suspend with CPU context lost.
!endif
!if "$(A_S3)" != ""
	Name(\_S3, Package(4){$(A_S3),0,0,0})	// Power on suspend with CPU context lost.
!endif
!if "$(A_S4)" != ""
	Name(\_S4, Package(4){$(A_S4),0,0,0})	// Suspend to disk + Soft Off
!endif
	Name(\_S5, Package(4){$(A_S5),0,0,0})	// Soft Off

!if $(A_START_UP_OEM)
// OEM start-up code. Will be called once while OS booting
	Include("$(ACPI_ASL_PATH)cust_stp.oem")
!endif

// MCTH(Str1, Str2) - Compare Str1 and Str2.
        Method(MCTH, 2)
        {
//                    Returns One if Str1 <> Str2
//                    Returns Zero if Str1 == Str2
//1. If Length str1 < Str2 - Return (Err)

            If(LLess(Sizeof(Arg0), Sizeof(Arg1)))
		{
                    Return(0)
            }

//2. Convert str1 & str2 into buffer with length of str2

    // Local0 contains length of string + NULL.
    //
            Add(Sizeof(Arg0), 1, Local0)

            Name(BUF0, Buffer(Local0) {})
            Name(BUF1, Buffer(Local0) {})
            Store(Arg0, BUF0)
            Store(Arg1, BUF1)

            While(Local0)
            {
                Decrement(Local0)
                If(LEqual(Derefof(Index(BUF0, Local0)), Derefof(Index(BUF1, Local0))))
                { }
                Else
                { Return(Zero) }
            }
            Return(One)         // Str1 & Str2 are match
        }
//-----------------------------------------------------------------------
// System Bus scope
//-----------------------------------------------------------------------
Scope(\_SB){

	Name(APIC, 0)			// 0-PIC mode
					// 1-APIC mode
        Method(_PIC, 1)
        {
		Store(Arg0, APIC)
        }
//-----------------------------------------------------------------------
// PCI ROOT (NORTH) BRIDGE
//-----------------------------------------------------------------------
        Device(PCI0) {                          // Start of Root PCI Bus

                Name(_HID, EISAID("PNP0A03"))   // PnP ID for PCI Bus

                Name(_ADR, 0x0000)              // Root Bus is Bus # 0

                Name(_BBN, 0)                   // PCI 0 Bus device address

                Name(CRS,                       //

                ResourceTemplate()
                {
// Tag 0 Bus Number Resources
        WORDBusNumber(
                ResourceProducer,               // bit 0 of general flags 1
		MinFixed,			// Range fixed
		MaxFixed,			// Range fixed
		PosDecode,			// Positive Decode
		0x00,				// Granularity
		0x00,				// Min
		0xff,				// Max
		0x00,				// Translation
                0x0100                          // Range Length = Max-Min+1
		)

// Tag 1 Consumed Resources

	IO(Decode16, 0xCF8, 0xCF8, 1, 8)

// Tag 2 Consumed-&-Produced Resources(I/O Window 1)
// all I/O below CF8

	WORDIO(
		ResourceProducer,		// bit 0 of general flags 0
		MinFixed,			// Range fixed
		MaxFixed,			// Range fixed
		PosDecode,			// Positive Decode
		EntireRange,
		0x00,				// Granularity A = 0x0
		0x00,				// Min
                0x0CF7,                         // Max
		0x00,				// Translation
                0x0CF8                          // Range Length
		)

// Tag 3 Consumed-&-Produced Resources(I/O Window 2)
// all I/O above CFF

	WORDIO(
		ResourceProducer,		// bit 0 of general flags 0
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		PosDecode,			// Positive Decode
		EntireRange,
		0x00,				// Granularity
		0x0D00,				// Min
		0xffff,				// Max
		0x00,				// Translation
		0xf300				// Range Length
		)

// Tag 4 Consumed-&-Produced Resources(Memory Window 1)
// Descriptor for video RAM behind ISA bus

	DWORDMemory(
		ResourceProducer,		// bit 0 of general flags 0
		PosDecode,
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		Cacheable,
		ReadWrite,
		0x0,				// Granularity
		0x0a0000,			// Min
		0x0bffff,			// Max
		0x00,				// Translation
		0x020000			// Range Length
		)

// Tag 5 Consumed-&-Produced Resources(Memory Window 2)
// for device ROMs for ISA plugins devices
// OEM specific

	DWORDMemory(
		ResourceProducer,		// bit 0 of general flags 0
		PosDecode,
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		Cacheable,
		ReadWrite,
		0x0,				// Granularity
		0x0cb000,			// Min
		0x0dffff,			// Max
		0x00,				// Translation
		0x015000			// Range Length
		)

// Tag 6 Consumed-&-Produced Resources(Memory Window 3)

	DWORDMemory(
		ResourceProducer,		// bit 0 of general flags 0
		PosDecode,
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		Cacheable,
		ReadWrite,
                0x0,                            // Granularity
                0x020000000,                    // Min 512M (calculated dinamically)
		0xffdfffff,			// Max 4Gb-2Mb
		0x00,				// Translation
		0xDFE00000,			// Range Length
						// (4G-2M)-TOM (calculated dinamically)
		,
		,
		MEM6				// Name declaration for this descriptor
		)

!ifdef MPS_SUPPORT
! if $(MPS_SUPPORT)
// Memory hole for APIC access
// Tag 7 Consumed-&-Produced Resources(Memory Window 4)
	DWORDMemory(
                ResourceProducer,              // bit 0 of general flags 0
		PosDecode,
                MinFixed,                      // Range is not fixed
                MaxFixed,                      // Range is not fixed
		Cacheable,
		ReadWrite,
                0x0,                            // Granularity
                0xfee01000,                     // Min (Local APIC + 0x1000)
                0xffdfffff,                     // Max 4Gb-2Mb (hardwired)
                0x00,                           // Translation
                0xfff000,                       // Range Length (hardwired)
                                                // (4G-2M) - APIC
		)
! endif
!endif
	}
	)					// end of CRS


// PCI North bridge specific code
	Include("$(ACPI_ASL_PATH)$(A_NRTH_BRG_PATH).asl")

                Name(FLAG, 1)                   // PCI Bus access Flag
                                                // Reset flag if test NT 5.0
                    Name(OSFL, 1)               // Curernt OS name 1 - Win 98
                                                //                 0 - NT 5.0
                Method(_INI, 0)
                {
! if $(A_START_UP_OEM)
// Run OEM start up code
				\INI()
! endif
! if "$(A_OEMIO_PATH_SUPERIO)" != ""
// Detect SuperIO devices present onboard
                        \_SB.PCI0.SBRG.IODT()
! endif
!if "$(A_OEMIO_PATH_AUDIO)" != ""
// Detect Audio devices present onboard
                        \_SB.PCI0.SBRG.AUDT()
!endif
// Detect currently running OS
                If(MCTH(\_OS, "Microsoft Windows"))     // Is the running OS - Win98?
                        { }
                        Else                            // It is not Win 98 (it's NT 5.0)
                        {
				Store(0, OSFL)
				}
	}

                Method(_REG, 2)                         // is PCI Config space accessible as OpRegion?
                                                        // _REG to update FLAG status
                {
                        If(LEqual(Arg0, 0x2))
                        {
					  Store(Arg1, FLAG)
                        }
                }

                Method(_CRS, 0)                     // PCI 0 Bus resources
                {

				CreateDwordField(CRS, \_SB.PCI0.MEM6._MIN, TMEM)        // Top of memory
				CreateDwordField(CRS, \_SB.PCI0.MEM6._LEN, TLEN)        // 4G-TOM
                                                        // MDET Control Method
                                                        // returns available system memory
                                Store(MDET(), TMEM)     // MDET defined in a \_SB.PCI0 scope

!ifdef MPS_SUPPORT
! if $(MPS_SUPPORT)
// PCI available memory has a hole for Local/IO APIC access
// IO APIC address hirdwired to 0xfec0000
                                Subtract(0xfec00000, TMEM, TLEN)// IO APIC-TOM
! else
                                Subtract(0xffe00000, TMEM, TLEN)// Local(4G - 2M)-TOM
! endif
!endif

!	if  !$(A_THERMAL) && ("$(A_FAN_PATH)" != "")
				If(OSFL){}                      // If NT 5.0-Turn FAN On
				Else
				{
					  \GFAN._ON()
				}
!	endif
				Return(CRS)
                }                                       // end PCI _CRS
//-----------------------------------------------------------------------
// 	PCI IRQ ROUTING TABLE (PRT)
//-----------------------------------------------------------------------
!if $(A_PCI_IRQ_ROUTE_STANDARD)
! ifdef MPS_SUPPORT
!  if $(MPS_SUPPORT)
                Method(_PRT)
                {
                         If(APIC)
                         {
                                 Return(PIC0)
                         }
                         Else
                                {
                                 Return(PIC1)
                                }
                }                                       // end PCI0 _PRT
                Name(PIC0, Package() {                  // Table applies in APIC mode
//-----------------------------------------------------------------------
!if $(A_S_IRQ_FIXED)
		$(A_S_APIC_IRQ_TABLE)
!endif
!  if "$(A_PCI_SLOT1)" != ""
// Slot 1
		Package(){0x$(A_PCI_SLOT1)ffff, 0, 0, 0x$(A_PCI_INTA_APIC)},
		Package(){0x$(A_PCI_SLOT1)ffff, 1, 0, 0x$(A_PCI_INTB_APIC)},
		Package(){0x$(A_PCI_SLOT1)ffff, 2, 0, 0x$(A_PCI_INTC_APIC)},
		Package(){0x$(A_PCI_SLOT1)ffff, 3, 0, 0x$(A_PCI_INTD_APIC)},
!  endif
!  if "$(A_PCI_SLOT2)" != ""
// Slot 2
		Package(){0x$(A_PCI_SLOT2)ffff, 0, 0, 0x$(A_PCI_INTB_APIC)},
		Package(){0x$(A_PCI_SLOT2)ffff, 1, 0, 0x$(A_PCI_INTC_APIC)},
		Package(){0x$(A_PCI_SLOT2)ffff, 2, 0, 0x$(A_PCI_INTD_APIC)},
		Package(){0x$(A_PCI_SLOT2)ffff, 3, 0, 0x$(A_PCI_INTA_APIC)},
!  endif
!  if "$(A_PCI_SLOT3)" != ""
// Slot 3
		Package(){0x$(A_PCI_SLOT3)ffff, 0, 0, 0x$(A_PCI_INTC_APIC)},
		Package(){0x$(A_PCI_SLOT3)ffff, 1, 0, 0x$(A_PCI_INTD_APIC)},
		Package(){0x$(A_PCI_SLOT3)ffff, 2, 0, 0x$(A_PCI_INTA_APIC)},
		Package(){0x$(A_PCI_SLOT3)ffff, 3, 0, 0x$(A_PCI_INTB_APIC)},
!  endif
!  if "$(A_PCI_SLOT4)" != ""
// Slot 4
		Package(){0x$(A_PCI_SLOT4)ffff, 0, 0, 0x$(A_PCI_INTD_APIC)},
		Package(){0x$(A_PCI_SLOT4)ffff, 1, 0, 0x$(A_PCI_INTA_APIC)},
		Package(){0x$(A_PCI_SLOT4)ffff, 2, 0, 0x$(A_PCI_INTB_APIC)},
		Package(){0x$(A_PCI_SLOT4)ffff, 3, 0, 0x$(A_PCI_INTC_APIC)},
!  endif
!  if "$(A_PCI_SLOT5)" != ""
// Slot 5
		Package(){0x$(A_PCI_SLOT5)ffff, 0, 0, 0x$(A_PCI_INTA_APIC)},
		Package(){0x$(A_PCI_SLOT5)ffff, 1, 0, 0x$(A_PCI_INTB_APIC)},
		Package(){0x$(A_PCI_SLOT5)ffff, 2, 0, 0x$(A_PCI_INTC_APIC)},
		Package(){0x$(A_PCI_SLOT5)ffff, 3, 0, 0x$(A_PCI_INTD_APIC)},
!  endif
!  if "$(A_PCI_SLOT6)" != ""
// Slot 6
		Package(){0x$(A_PCI_SLOT6)ffff, 0, 0, 0x$(A_PCI_INTA_APIC)},
		Package(){0x$(A_PCI_SLOT6)ffff, 1, 0, 0x$(A_PCI_INTB_APIC)},
		Package(){0x$(A_PCI_SLOT6)ffff, 2, 0, 0x$(A_PCI_INTC_APIC)},
		Package(){0x$(A_PCI_SLOT6)ffff, 3, 0, 0x$(A_PCI_INTD_APIC)},
!  endif
!  if "$(A_PCI_DEV1_IRQA)" != ""
// Device 1, IRQA
		Package(){0x$(A_PCI_DEV1_IRQA:.=), 0, 0x$(A_PCI_INTA_APIC)},
!  endif
!  if "$(A_PCI_DEV1_IRQB)" != ""
// Device 1, IRQB
		Package(){0x$(A_PCI_DEV1_IRQB:.=), 0, 0x$(A_PCI_INTB_APIC)},
!  endif
!  if "$(A_PCI_DEV1_IRQC)" != ""
// Device 1, IRQC
		Package(){0x$(A_PCI_DEV1_IRQC:.=), 0, 0x$(A_PCI_INTC_APIC)},
!  endif
!  if "$(A_PCI_DEV1_IRQD)" != ""
// Device 1, IRQD
		Package(){0x$(A_PCI_DEV1_IRQD:.=), 0, 0x$(A_PCI_INTD_APIC)},
!  endif
!  if "$(A_PCI_DEV2_IRQA)" != ""
// Device 2, IRQA
		Package(){0x$(A_PCI_DEV2_IRQA:.=), 0, 0x$(A_PCI_INTA_APIC)},
!  endif
!  if "$(A_PCI_DEV2_IRQB)" != ""
// Device 2, IRQB
		Package(){0x$(A_PCI_DEV2_IRQB:.=), 0, 0x$(A_PCI_INTB_APIC)},
!  endif
!  if "$(A_PCI_DEV2_IRQC)" != ""
// Device 2, IRQC
		Package(){0x$(A_PCI_DEV2_IRQC:.=), 0, 0x$(A_PCI_INTC_APIC)},
!  endif
!  if "$(A_PCI_DEV2_IRQD)" != ""
// Device 2, IRQD
		Package(){0x$(A_PCI_DEV2_IRQD:.=), 0, 0x$(A_PCI_INTD_APIC)},
!  endif
!  if "$(A_PCI_DEV3_IRQA)" != ""
// Device 3, IRQA
		Package(){0x$(A_PCI_DEV3_IRQA:.=), 0, 0x$(A_PCI_INTA_APIC)},
!  endif
!  if "$(A_PCI_DEV3_IRQB)" != ""
// Device 3, IRQB
		Package(){0x$(A_PCI_DEV3_IRQB:.=), 0, 0x$(A_PCI_INTB_APIC)},
!  endif
!  if "$(A_PCI_DEV3_IRQC)" != ""
// Device 3, IRQC
		Package(){0x$(A_PCI_DEV3_IRQC:.=), 0, 0x$(A_PCI_INTC_APIC)},
!  endif
!  if "$(A_PCI_DEV3_IRQD)" != ""
// Device 3, IRQD
		Package(){0x$(A_PCI_DEV3_IRQD:.=), 0, 0x$(A_PCI_INTD_APIC)},
!  endif
!  if "$(A_PCI_DEV4_IRQA)" != ""
// Device 4, IRQA
		Package(){0x$(A_PCI_DEV4_IRQA:.=), 0, 0x$(A_PCI_INTA_APIC)},
!  endif
!  if "$(A_PCI_DEV4_IRQB)" != ""
// Device 4, IRQB
		Package(){0x$(A_PCI_DEV4_IRQB:.=), 0, 0x$(A_PCI_INTB_APIC)},
!  endif
!  if "$(A_PCI_DEV4_IRQC)" != ""
// Device 4, IRQC
		Package(){0x$(A_PCI_DEV4_IRQC:.=), 0, 0x$(A_PCI_INTC_APIC)},
!  endif
!  if "$(A_PCI_DEV4_IRQD)" != ""
// Device 4, IRQD
		Package(){0x$(A_PCI_DEV4_IRQD:.=), 0, 0x$(A_PCI_INTD_APIC)},
!  endif
//-----------------------------------------------------------------------
		} )
                Name(PIC1, Package(){           // Table applies in PIC mode
!  else
                Name(_PRT, Package() {          // Table applies in PIC mode
!  endif
! else
                Name(_PRT, Package() {          // Table applies in PIC mode
! endif
//-----------------------------------------------------------------------
!if $(A_S_IRQ_FIXED)
		$(A_S_PIC_IRQ_TABLE)
!endif
!  if "$(A_PCI_SLOT1)" != ""
// Slot 1
		Package(){0x$(A_PCI_SLOT1)ffff, 0, LNKA, 0},
		Package(){0x$(A_PCI_SLOT1)ffff, 1, LNKB, 0},
		Package(){0x$(A_PCI_SLOT1)ffff, 2, LNKC, 0},
		Package(){0x$(A_PCI_SLOT1)ffff, 3, LNKD, 0},
!  endif
!  if "$(A_PCI_SLOT2)" != ""
// Slot 2
		Package(){0x$(A_PCI_SLOT2)ffff, 0, LNKB, 0},
		Package(){0x$(A_PCI_SLOT2)ffff, 1, LNKC, 0},
		Package(){0x$(A_PCI_SLOT2)ffff, 2, LNKD, 0},
		Package(){0x$(A_PCI_SLOT2)ffff, 3, LNKA, 0},
!  endif
!  if "$(A_PCI_SLOT3)" != ""
// Slot 3
		Package(){0x$(A_PCI_SLOT3)ffff, 0, LNKC, 0},
		Package(){0x$(A_PCI_SLOT3)ffff, 1, LNKD, 0},
		Package(){0x$(A_PCI_SLOT3)ffff, 2, LNKA, 0},
		Package(){0x$(A_PCI_SLOT3)ffff, 3, LNKB, 0},
!  endif
!  if "$(A_PCI_SLOT4)" != ""
// Slot 4
		Package(){0x$(A_PCI_SLOT4)ffff, 0, LNKD, 0},
		Package(){0x$(A_PCI_SLOT4)ffff, 1, LNKA, 0},
		Package(){0x$(A_PCI_SLOT4)ffff, 2, LNKB, 0},
		Package(){0x$(A_PCI_SLOT4)ffff, 3, LNKC, 0},
!  endif
!  if "$(A_PCI_SLOT5)" != ""
// Slot 5
		Package(){0x$(A_PCI_SLOT5)ffff, 0, LNKA, 0},
		Package(){0x$(A_PCI_SLOT5)ffff, 1, LNKB, 0},
		Package(){0x$(A_PCI_SLOT5)ffff, 2, LNKC, 0},
		Package(){0x$(A_PCI_SLOT5)ffff, 3, LNKD, 0},
!  endif
!  if "$(A_PCI_SLOT6)" != ""
// Slot 6
		Package(){0x$(A_PCI_SLOT6)ffff, 0, LNKA, 0},
		Package(){0x$(A_PCI_SLOT6)ffff, 1, LNKB, 0},
		Package(){0x$(A_PCI_SLOT6)ffff, 2, LNKC, 0},
		Package(){0x$(A_PCI_SLOT6)ffff, 3, LNKD, 0},
!  endif
!  if "$(A_PCI_DEV1_IRQA)" != ""
// Device 1, IRQA
		Package(){0x$(A_PCI_DEV1_IRQA:.=), LNKA, 0},
!  endif
!  if "$(A_PCI_DEV1_IRQB)" != ""
// Device 1, IRQB
		Package(){0x$(A_PCI_DEV1_IRQB:.=), LNKB, 0},
!  endif
!  if "$(A_PCI_DEV1_IRQC)" != ""
// Device 1, IRQC
		Package(){0x$(A_PCI_DEV1_IRQC:.=), LNKC, 0},
!  endif
!  if "$(A_PCI_DEV1_IRQD)" != ""
// Device 1, IRQD
		Package(){0x$(A_PCI_DEV1_IRQD:.=), LNKD, 0},
!  endif
!  if "$(A_PCI_DEV2_IRQA)" != ""
// Device 2, IRQA
		Package(){0x$(A_PCI_DEV2_IRQA:.=), LNKA, 0},
!  endif
!  if "$(A_PCI_DEV2_IRQB)" != ""
// Device 2, IRQB
		Package(){0x$(A_PCI_DEV2_IRQB:.=), LNKB, 0},
!  endif
!  if "$(A_PCI_DEV2_IRQC)" != ""
// Device 2, IRQC
		Package(){0x$(A_PCI_DEV2_IRQC:.=), LNKC, 0},
!  endif
!  if "$(A_PCI_DEV2_IRQD)" != ""
// Device 2, IRQD
		Package(){0x$(A_PCI_DEV2_IRQD:.=), LNKD, 0},
!  endif
!  if "$(A_PCI_DEV3_IRQA)" != ""
// Device 3, IRQA
		Package(){0x$(A_PCI_DEV3_IRQA:.=), LNKA, 0},
!  endif
!  if "$(A_PCI_DEV3_IRQB)" != ""
// Device 3, IRQB
		Package(){0x$(A_PCI_DEV3_IRQB:.=), LNKB, 0},
!  endif
!  if "$(A_PCI_DEV3_IRQC)" != ""
// Device 3, IRQC
		Package(){0x$(A_PCI_DEV3_IRQC:.=), LNKC, 0},
!  endif
!  if "$(A_PCI_DEV3_IRQD)" != ""
// Device 3, IRQD
		Package(){0x$(A_PCI_DEV3_IRQD:.=), LNKD, 0},
!  endif
!  if "$(A_PCI_DEV4_IRQA)" != ""
// Device 4, IRQA
		Package(){0x$(A_PCI_DEV4_IRQA:.=), LNKA, 0},
!  endif
!  if "$(A_PCI_DEV4_IRQB)" != ""
// Device 4, IRQB
		Package(){0x$(A_PCI_DEV4_IRQB:.=), LNKB, 0},
!  endif
!  if "$(A_PCI_DEV4_IRQC)" != ""
// Device 4, IRQC
		Package(){0x$(A_PCI_DEV4_IRQC:.=), LNKC, 0},
!  endif
!  if "$(A_PCI_DEV4_IRQD)" != ""
// Device 4, IRQD
		Package(){0x$(A_PCI_DEV4_IRQD:.=), LNKD, 0},
!  endif
//-----------------------------------------------------------------------
		} )
!  else
	Include("$(ACPI_ASL_PATH)CUST_irq.oem")
!  endif
//-----------------------------------------------------------------------
// PCI-ISA (SOUTH) BRIDGE
//-----------------------------------------------------------------------
        Device(SBRG) {

                Name(_ADR, 0x$(A_S_DEV_Nbr)0000)

!	if  !$(A_THERMAL) && ("$(A_FAN_PATH)" != "")

// Keep the FAN On whenever the parent Device On

		Name(_PR0, Package(){GFAN})
!	endif

// PCI interrupt routing devices

        Name(\_SB.IPRS,         // List of possible IRQs
                                // to be returned by _PRS for LINKx devices
		ResourceTemplate()
		{
        		StartDependentFnNoPri()
                {
			IRQ(Level, ActiveLow, Shared ) {$(A_PCI_IRQ_LIST)} // 3,4,5,6,7,9,10,11,12,14,15
                }
		    EndDependentFn()
		})

	Include("$(ACPI_ASL_PATH)irq-pci.asl")
//-----------------------------------------------------------------------
//			Miscellaneous I/O Ports
//-----------------------------------------------------------------------
// This table should contain any I/O port that is not used by a specific
// device but does not return FFh when read.  Some examples of I/O ports
// that should be reserved here are:
//   The I/O peripheral chip's index/data ports
//   Any I/O port in the range 00 - FF that is not used by any other dev node
//   The IRQ edge/level control ports (4D0/4D1)
//-----------------------------------------------------------------------
// For example:
//	ASL macro "FixedIO"
//	FixedIO( WordConst, // _BAS, Address base
//		 ByteConst  // _LEN, Range length
//		)
//	if SuperIO module Index/Data port address allocated in
//	0x3f0 / 0x3f1 we need to update "FixedIO" macro with
//	"Address base" = 0x3f0 and "Range length" = 0x02
//      FixedIO( 0x3f0, 0x02)
//		   ^^^    ^^ fields only to edit
//-----------------------------------------------------------------------
	Device(SYSR) {

		Name(_HID, EISAID("PNP0C02"))

		Method(_STA, 0)
		{
			If(OSFL)		// If running under Win98?
			{
				Return(0x0f)	// Device present
			}
			Return(0x0)		// Not present if NT 5.0
		}

                Name(IORG,
                        ResourceTemplate()
		{
		FixedIO(0x10, 0x10)
		FixedIO(0x22, 0x1e)
		FixedIO(0x44, 0x1c)
		FixedIO(0x62, 0x02)
		FixedIO(0x65, 0x0b)
		FixedIO(0x72, 0x0E)
		FixedIO(0x80, 0x01)
		FixedIO(0x84, 0x03)
		FixedIO(0x88, 0x01)
		FixedIO(0x8C, 0x03)
		FixedIO(0x90, 0x10)
		FixedIO(0xa2, 0x1e)
		FixedIO(0xe0, 0x10)
// LM78/79 or W8378x Hardware Monitor ICs
		FixedIO(0x290, 0x8)
// Decoded but not used by FDC
//		IO(Decode16, 0x3f3, 0x3f3, 0, 0x1)
// Abel Wu
!if $(A_S_ALI1543) 
// Reserve  40B for Extended DMA1 Mode port
			IO(Decode16, 0x40b, 0x40b, 0, 0x1)
!endif
!if $(A_S_SIS5595) || $(A_S_ALI1543)
// Reserve  480 - 48F for Extended DMA ports  
		IO(Decode16, 0x480, 0x480, 0, 0x10)
!endif
// Reserve  4D0 and 4D1 for IRQ edge/level control port
		IO(Decode16, 0x4d0, 0x4d0, 0, 0x2)
!if $(A_S_ALI1543) 
// Reserve  4D6 for Extended DMA2 Mode port
			IO(Decode16, 0x4d6, 0x4d6, 0, 0x1)
!endif
!if $(A_PMU_ALL)
// PM base address allocation
		IO(Decode16, 0, 0, 0, 0x0, IO1)
// SMBus base address allocation
		IO(Decode16, 0, 0, 0, 0x0, IO2)
!endif
!if "$(IO_INDEX_PORT)" != ""
// Index\Data for Super I/O
		IO(Decode16, 0x$(IO_INDEX_PORT:h=), 0x$(IO_INDEX_PORT:h=), 0, 0x2)
!endif
// Abel Wu
!if $(A_S_VIA82586)
! if $(SUPER_SOUTH_BR)
// VIA 82C686 Hardware Monitor I/O Ports
		IO(Decode16, 0x$(HW_BASE_HIGH:h=)00, 0x$(HW_BASE_HIGH:h=)00, 0, 0x80)
! endif
!endif
!if $(A_S_SIS5595)
// Reserve Unknow memory FFEF0000-FFEFFFFF
		Memory32(ReadOnly, 0xffef0000, 0xffef0000, 0, 0x10000)
!endif
		    }               // End of ResourceTemplate
		    )               // end of IORG

		    Method(_CRS, 0)
		    {
!if $(A_PMU_ALL)
				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO1._MIN, PM00) // PM Base
				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO1._MAX, PM01)
				CreateByteField(IORG, \_SB.PCI0.SBRG.SYSR.IO1._LEN, PMLN) // PM Length

				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO2._MIN, SM00) // SMB Base
				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO2._MAX, SM01)
				CreateByteField(IORG, \_SB.PCI0.SBRG.SYSR.IO2._LEN, SMLN) // SMB length

				Store(\_SB.PCI0.PMU.PMBS(), PM00)
				Store(PM00, PM01)
                    If(PM00)                                    // If Base <> 0 : set length to 40
                                {                               // Otherwise to 0
// Abel Wu
!if $(A_S_VIA82586)
				Store(0x80, PMLN)
!else
				Store(0x40, PMLN)
!endif
				}

				Store(\_SB.PCI0.PMU.SMBS(), SM00)
				Store(SM00, SM01)
                    If(SM00)                                    // If Base <> 0 : set length to 10
                                {                               // Otherwise to 0
// Abel Wu
!if $(A_S_ALI1543)
				Store(0x20, SMLN)
!else 
				Store(0x10, SMLN)
!endif
				}
!endif
				Return(IORG)
		    }

	}			// End System Resources SYSR
/////////////////////////////////////////////////////////////////////////
// System board extension for ACPI BIOS
// Place that device under \_SB scope, As per Msft the MEM
// Resources should not be declared neither in PCI0 nor in PCI-ISA Bus
/////////////////////////////////////////////////////////////////////////
	Device(\_SB.MEM) {		        	      	// Memory
		Name(_HID, EISAID("PNP0C01"))			// Hardware Device ID


		Method (_STA, 0)
		{
                        If(\_SB.PCI0.OSFL)                      // If running under Win98?
			{
                                Return(0x0f)                    // Device present
			}
		Return(0x0)								// Not present
		}

		Name(MEM1,

		ResourceTemplate()
		{
//	Base Address 0 - 0x9FFFF , 640k DOS memory
			Memory32Fixed(ReadWrite, 0x0000, 0xA0000 )//Writeable
//	Base Address F000 - 1M , 64k BIOS
			Memory32Fixed(ReadOnly, 0xF0000, 0x10000 )//Non-writeable

//	Base Address 1M - Top of system present memory
			Memory32Fixed(ReadWrite, 0x100000, 0x1FF00000, TOPM)//Writeable
!if $(NCPU) > 1
//	Local & IO APIC memory reservation. Make sure addresses are compliant to ACPI APIC table
! ifdef MPS_SUPPORT
!  if $(MPS_SUPPORT)
                        Memory32Fixed(ReadOnly, 0xFEC00000, 0x1000 )// APIC Non-Writeable
!  endif
! endif
                        Memory32Fixed(ReadOnly, 0xFEE00000, 0x1000 )// APIC Non-Writeable
!endif
			Memory32Fixed(ReadOnly, 0xFFFF0000, 0x10000)//Non-Writeable, 64K ROM image
		})

		Method (_CRS, 0)
		{
			// Top of memory
			// MDET Control Method returns available system memory

			CreateDwordField(MEM1, \_SB.MEM.TOPM._LEN, TOP1)
			// MDET defined in \_SB.PCI0 scope
			Subtract(\_SB.PCI0.MDET(), 0x100000, TOP1)

		Return(MEM1)
		}					// end of _CRS

	}						// End Memory
//-----------------------------------------------------------------------
//	ONBOARD I/O Standard peripherals
//	DMA, Keyboard, Timer, Speaker, CMOS...
//-----------------------------------------------------------------------
	Include("$(ACPI_ASL_PATH)sysstand.asl")
!if $(A_KEY_WAKE_UP)
// Resume by key pressed
		    Name(PS2K._PRW, Package(){0x$(A_KEY_GPE), 0x$(A_KEY_WAK_SYST)})
/* An example of resume code can be used on particular designs if event handler is needed
		    Method(PS2K._PSW, 1)
		    {
                        If(Arg0){ }      // Enable resume by Keyboard
                        Else
                                { }      // Disable resume
                }
Scope(\_GPE)
	{
                Method(_L$(A_KEY_GPE))
		{
		//	OEM ASL code
			Notify(\_SB.PCI0.SBRG.PS2K, 0x2)	// Wake up event
		}
	}
*/
!endif
!if $(A_MOUSE_WAKE_UP)
// Resume by key pressed
                Name(PS2M._PRW, Package(){0x$(A_MOUSE_GPE), 0x$(A_MOUSE_WAK_SYST)})
!endif
!if $(A_POS_DECODE)
//              Device(EIO) {
//                      Name(_HID, EISAID("PNP0A06"))

// Methods for routing/release IO/DMA resources on EIO bus
	Include("$(ACPI_ASL_PATH)eioroute.asl")
!else
// Route and Release I/O, DMA resources to EIO Bus
// Dummy methods
        Method(RRIO, 4) { NoOp }
        Method(RGNR, 4) { NoOp }
        Method(rDMA, 3) { NoOp }
!endif
!if "$(A_OEMIO_PATH_SUPERIO)" != ""
	Name(SPIO, 0x$(IO_INDEX_PORT:h=))	// Super I/O Index/Data base address
//-----------------------------------------------------------------------
// Super IO devices (FDC, UART1,2, LPT, ECP, IR)
//-----------------------------------------------------------------------
	Include("$(ACPI_ASL_PATH)superio.asl")

!if $(A_SUPER_IO_PM) || $(A_RI_WAKE_UP_UART1)
        Name(UAR1._PR0, Package(){URP1})        // Reference to PowerResources
!endif
!if $(A_SUPER_IO_PM) || $(A_RI_WAKE_UP_UART2)
        Name(UAR2._PR0, Package(){URP2})        // Reference to PowerResources
!endif
! if $(A_SUPER_IO_PM)
        Name(FDC0._PR0, Package(){FDDP})        // Reference to PowerResources
        Name(ECP._PR0, Package(){LPTP})         // Reference to PowerResources
        Name(LPT._PR0, Package(){LPTP})         // Reference to PowerResources
! endif
!if $(A_RI_WAKE_UP_UART1)
// Resume by modem Ring
	Name(UAR1._PRW, Package(){0x$(A_RI_GPE), 0x$(A_RI_WAK_SYST)})
!endif
!if $(A_RI_WAKE_UP_UART2)
// Resume by modem Ring
	Name(UAR2._PRW, Package(){0x$(A_RI_GPE), 0x$(A_RI_WAK_SYST)})
!endif
!endif
!if "$(A_OEMIO_PATH_AUDIO)" != ""
	Include("$(ACPI_ASL_PATH)audio.asl")
!endif
!if $(A_OEM_ISA_DEV)
// OEM ISA device
	Include("$(ACPI_ASL_PATH)cust_isa.oem")
!endif
!if $(A_POS_DECODE)
//	}					// end of EIO bus
!endif
        }                                       // End of SBRG

!if $(A_PMU_ALL)
//-----------------------------------------------------------------------
// PCI Power Management Unit (PMU)
//-----------------------------------------------------------------------
	Device(PMU) {

                Name(_ADR, 0x$(A_PMU_DEV_FUN_Adr))
// Contains the PMBS & SMBS control methods to return the PM & SMBus I/O base address
!ifdef PM_BASE_HIGH
	Method(PMBS,0) {	// Return Power Management I/O base address
                        Or(ShiftLeft(0x$(PM_BASE_HIGH:h=),8), 0x$(PM_BASE_LOW:h=), Local0)
        Return(Local0)
	}
	Method(SMBS,0) {	// Return SMBus I/O base address
                        Or(ShiftLeft(0x$(SMB_BASE_HIGH:h=),8), 0x$(SMB_BASE_LOW:h=), Local0)
        Return(Local0)
	}
!else
      Include("$(ACPI_ASL_PATH)pmbase.asl")
////////////////////////////////////////////////////////////////////////////
// Due to OS restriction in access to PCI space during ASL Name space evaluation,
// the below OpRegion(s) need to be moved directly to Control Methods where
// OpReg are going to be used. Or hardwire the address(es) of OpRegion(s)
////////////////////////////////////////////////////////////////////////////
!endif
// PM controller IO space
      OperationRegion(PWRG, SystemIO, PMBS, 0x40)
!if $(A_SMBUS)
// SMBus controller IO space
      OperationRegion(SMRG, SystemIO, SMBS, 0x10)
!endif
   }
!endif

!if $(A_OEM_PCI_DEV)
// OEM PCI device
	Include("$(ACPI_ASL_PATH)cust_pci.oem")
!endif

!if $(A_IDE_PM)
        Device(IDE0) {                    // IDE controller

                Name(_ADR, 0x$(A_IDE_DEV_FUN_Adr))
// add custom PM control code for PS0, PS3
		    Include("$(ACPI_ASL_PATH)pci-ide0.asl")
	}         					// end IDE
!endif
!if $(A_USB_ALL)
	Device(USB) {                       // Device USB

		Name(_ADR, 0x$(A_USB_DEV_FUN_Adr))

!if $(A_USB_WAKE_UP) || $(A_PME_WAKE_UP)
//---------Power Resources for USB -------------------------
/*
	PowerResource(USBP, 3, 0) 		// SystemLevel Parameter=0,
	{				            // which means Dev. can be turned off
							// in S3 or deeper sleep state
		Name(STA, 0)

		    Method(_STA, 0) {
			Return(STA)
		    }

		Method(_ON) {
			Store(1, STA)
		    }					// end of _ON

		Method(_OFF){
			Store(0, STA)
		    }					// end of _OFF
	  }

// Power resources & Wake - up capabilities
		Name(_PR0, Package(){USBP})

		Name(_PSC,0)			// Return power state

		Method(_PS0,0){			// D0
			Store(0, _PSC)
		}
		Method(_PS3,0){			// D3
			Store(3, _PSC)
		}
*/
// Wake up on USB event
! if $(A_USB_WAKE_UP)
		Name(_PRW, Package(){0x$(A_USB_GPE), 0x$(A_USB_WAK_SYST)})
! else
		Name(_PRW, Package(){0x$(A_USB_GPE), 0x$(A_PME_WAK_SYST)})
! endif
!endif
	  }						// end USB
!endif

!if $(A_LAN_WAKE_UP)
!  if "$(A_PCI_SLOT1)" != ""
// Slot 1
	Device(SLT1) {

		Name(_ADR, 0x$(A_PCI_SLOT1)FFFF)
// Wake up on LAN event
		Name(_PRW, Package(){0x$(A_LAN_GPE), 0x$(A_LAN_WAK_SYST)})
	}
!  endif
!  if "$(A_PCI_SLOT2)" != ""
// Slot 2
	Device(SLT2) {

		Name(_ADR, 0x$(A_PCI_SLOT2)FFFF)
// Wake up on LAN event
		Name(_PRW, Package(){0x$(A_LAN_GPE), 0x$(A_LAN_WAK_SYST)})
	}
!  endif
!  if "$(A_PCI_SLOT3)" != ""
// Slot 3
	Device(SLT3) {

		Name(_ADR, 0x$(A_PCI_SLOT3)FFFF)
// Wake up on LAN event
		Name(_PRW, Package(){0x$(A_LAN_GPE), 0x$(A_LAN_WAK_SYST)})
	}
!  endif
!  if "$(A_PCI_SLOT4)" != ""
// Slot 4
	Device(SLT4) {

		Name(_ADR, 0x$(A_PCI_SLOT4)FFFF)
// Wake up on LAN event
		Name(_PRW, Package(){0x$(A_LAN_GPE), 0x$(A_LAN_WAK_SYST)})
	}
!  endif
!  if "$(A_PCI_SLOT5)" != ""
// Slot 5
	Device(SLT5) {

		Name(_ADR, 0x$(A_PCI_SLOT5)FFFF)
// Wake up on LAN event
		Name(_PRW, Package(){0x$(A_LAN_GPE), 0x$(A_LAN_WAK_SYST)})
	}
!  endif
!  if "$(A_PCI_SLOT6)" != ""
// Slot 6
	Device(SLT6) {

		Name(_ADR, 0x$(A_PCI_SLOT6)FFFF)
// Wake up on LAN event
		Name(_PRW, Package(){0x$(A_LAN_GPE), 0x$(A_LAN_WAK_SYST)})
	}
!  endif
!endif
!if $(A_PME_WAKE_UP)
// Wake up on PCI PME event
	Name(_PRW, Package(){0x$(A_PME_GPE), 0x$(A_PME_WAK_SYST)})
!endif
        }                                       // End of PCI0 Root Bus

!if $(A_SLEEP_BUTTON_GENERIC)
// Control method Sleep Button
! if "$(A_SB_IO_Adr)" != ""
!  if $(A_S_PIIX4)
	OperationRegion(SB01, SystemIO, 0x$(A_SB_IO_Adr), 10)
!  else
	OperationRegion(SB01, SystemIO, 0x$(A_SB_IO_Adr), 4)
!  endif
! if "$(A_SB_ENBL_Offset)" != ""
	Field(SB01, ByteAcc, NoLock, Preserve)
		{
		,$(A_SB_ENBL_Offset),
		SBEN,1,
		}
! endif
! if "$(A_SB_STA_Offset)" != ""
	Field(SB01, ByteAcc, NoLock, Preserve)
		{
		,$(A_SB_STA_Offset),
		SLPS,1,
		}
! else
	Name(SLPS, 0)
! endif
!else
	Name(SLPS, 0)
!endif
	Device(SLPB)				// Device Sleep Button
	{
		    Name(_HID,EISAID("PNP0C0E"))

		    Method(SBEV, 0) {               // SBEVent handler
		// Serve Sleep button event
		If (SLPS) {
			Store(0, SLPS)
			Notify (SLPB, 0x02) }	// Wake-Up
		Else {
			Store(1, SLPS)
			Notify (SLPB, 0x80) }	// Sleep

		}					// end SBEVent handler
!if "$(A_SB_IO_Adr)" != ""
! if "$(A_SB_ENBL_Offset)" != ""
	Method(_PSW, 1)
		{
// Abel Wu
//		Store(Arg0, SBEN)
		Store(1, SBEN)
		}
! endif
!else
! if "$(A_SB_GPE)" != ""			
// Abel Wu
	Scope(\_GPE)
		{
	Method(_L$(A_SB_GPE), 0) {	// Are we sure this is a LEVEL ?
		\_SB.SLPB.SBEV()		// Sleep Button event handler
		}				// end of GPE_SB
	}					// end GPE
// Abel Wu
	Name(_PRW, Package(){0x$(A_SB_GPE), $(A_SB_WAK_SYST)})
! endif
! endif
	}					// End Device Sleep Button
!endif

!if $(A_POWER_BUTTON_GENERIC)
// Control method Power Button
!if "$(A_PB_IO_Adr)" != ""
	OperationRegion(PB01, SystemIO, 0x$(A_PB_IO_Adr), 4)

! if "$(A_PB_ENBL_Offset)" != ""
	Field($(A_PB_PATH), ByteAcc, NoLock, Preserve)
		{
		,$(A_PB_ENBL_Offset),
		PBEN,1,
		}
! endif
! if "$(A_PB_STA_Offset)" != ""
	Field($(A_PB_PATH), ByteAcc, NoLock, Preserve)
		{
		,$(A_PB_STA_Offset),
		PBST,1,
		}
! else
	Name(PBST, 0)
! endif
!else
	Name(PBST, 0)
!endif

	Device(PWRB)				// Device Power Button
	{
                Name(_HID,EISAID("PNP0C0C"))

                Method(PBEV, 0) {               // PBEVent handler
		// Serve power button event
		If (PBST) {
			Store(0, PBST)
			Notify (PWRB, 0x02) }   // Wake-Up
		Else {
			Store(1, PBST)
			Notify (PWRB, 0x80) }   // Sleep

		}                               // end PBEVent handler
!if "$(A_PB_IO_Adr)" != ""
!  if "$(A_PB_ENBL_Offset)" != ""
	Method(_PSW, 1)
		{
		Store(Arg0, PBEN)
		}
!  endif
!  if "$(A_PB_STA_Offset)" != ""
	Scope(\_GPE)
		{
	Method(_L$(A_PB_GPE), 0){		// Are we sure this is a LEVEL ?
		\_SB.PWRB.PBEV()			// Power Button event handler
		}					// end of GPE_PB
	}						// end GPE
!  endif
! endif
	Name(_PRW, Package(){0x$(A_PB_GPE), 0x05})
	}					// End Device Power Button
!endif
}						// End of _SB scope
//----------------------------------------------------------------------
// SYSTEM MANAGEMENT DEVICES
//----------------------------------------------------------------------
!if $(A_SMBUS)
// SMBus interface over PIIX4 SMBus host controller
	Include("$(ACPI_ASL_PATH)smb_host.asl")
!endif

!if "$(A_FAN_ISA_IO_Adr)" != ""
	OperationRegion(FNOR, SystemIO, 0x$(A_FAN_ISA_IO_Adr), 0x04)
!elseif "$(A_FAN_INDEX_DATA_IO_Adr)" != ""
	OperationRegion(FNOR, SystemIO, 0x$(A_FAN_INDEX_DATA_IO_Adr), 0x02)
	Field ( FNOR, ByteAcc, NoLock, Preserve)
		{
		FIND,8,		//field named INDX is 8 bits wide
		FDTA,8		//field DATA is 8 bits wide
		}
!endif
!if $(A_FAN_MODEL_1)
//-----------------------------------------------------------------------
//  FAN block 1
//-----------------------------------------------------------------------
	$(A_FAN_FIELD)
	{
	,$(A_FAN_1_GPO_Offset),
	FAN1,1,
	}
	Name(F1ON, $(A_FAN_1_1_ON))	// FAN 1 On

!if "$(A_FAN_2_GPO_Offset)" != ""
	$(A_FAN_FIELD)
	{
	,$(A_FAN_2_GPO_Offset),
	FAN2,1,
	}
	Name(NFAN, 2)
	Name(F2ON, $(A_FAN_1_2_ON))	// FAN 2 On
!else
	Name(NFAN, 1)
	Name(FAN2, 1)			// FAN 2
	Name(F2ON, 1)			// FAN 2 On
!endif
! elseif $(A_FAN_MODEL_2)
//-----------------------------------------------------------------------
//  FAN block 2
//-----------------------------------------------------------------------
	$(A_FAN_FIELD)
	{
	,$(A_FAN_1_0_GPO_Offset),
	FN10,1,         // System (Case) FAN0
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_1_1_GPO_Offset),
	FN11,1,		// System (Case) FAN1
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_2_0_GPO_Offset),
	FN20,1,		// PS FAN 0
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_2_1_GPO_Offset),
	FN21,1,		// PS FAN 1
	}
//	Name(FNON, $(A_FAN_2_ON))
! elseif $(A_FAN_MODEL_3)
//-----------------------------------------------------------------------
//  FAN block 3
//-----------------------------------------------------------------------
	$(A_FAN_FIELD)
	{
	,$(A_FAN_1_ON_GPO_Offset),
	SFNO,1,         // System FAN On/Off
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_1_LOW_GPO_Offset),
	SFNL,1,         // System (Case) FAN_LOW
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_1_MID_GPO_Offset),
	SFNM,1,         // System FAN_MIDIUM
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_2_ON_GPO_Offset),
	PFNO,1,         // PS FAN On/Off
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_2_LOW_GPO_Offset),
	PFNL,1,         // Power Supply FAN_LOW
	}

	$(A_FAN_FIELD)
	{
	,$(A_FAN_2_MID_GPO_Offset),
	PFNM,1,         // PS FAN_MIDIUM
	}
	Name(F1ON, $(A_FAN_3_1_ON))
	Name(F2ON, $(A_FAN_3_2_ON))

!  endif
!if $(A_FAN_OEM)
	Include("$(ACPI_ASL_PATH)cust_fan.oem")
! elseif "$(A_FAN_PATH)" != ""
	Include("$(ACPI_ASL_PATH)fan.asl")
!endif
!if $(A_THERMAL)
//---------------------------------------------------------------------------
//	Generic ThermalZone objects
//---------------------------------------------------------------------------
// Note: Do not require any changes unless system has more then
//	one Active cooling FAN device and/or more then one CPU
//---------------------------------------------------------------------------
Scope(\_TZ){

// Global variables (presently for Thermal)
	Name(THBF, Buffer(){ 0, 0 ,0 ,0})

// Converts temperature in Celcius to Kelvin in format xxx.y (2732 => 273.2k)
	Method(KELV, 1)	{
                And(Arg0, 0xff, Local0)         // Leave only Low byte temperarure
                Multiply( Local0, 10, Local0 )  // x 10
                Add( Local0, 2732, Local0 )     // convert to Kelvin x 10
                Return(Local0)
        }
! if $(A_FAN_MODEL_1)
	Device(FANC){                           // CPU FAN
		Name(_HID, EISAID("PNP0C0B"))   // PnP ID for Fan Device
		Name(_PR0, Package(){GFAN})
	}                                       // End of FAN
! elseif $(A_FAN_MODEL_2) || $(A_FAN_MODEL_3)
	Device(FN00)           			// High-Midium
	{
		Name(_HID,EISAID("PNP0C0B"))
		Name(_PR0,Package() {
		PFN0,
		SFN0,
		})
	}

	Device(FN01)				// Midium-Low
	{
		Name(_HID,EISAID("PNP0C0B"))
		Name(_PR0,Package() {
		PFN1,
		SFN1,
		})
	}

	Device(FN02)				// Low-Off
	{
		Name(_HID,EISAID("PNP0C0B"))
		Name(_PR0,Package() {
		PFN2,
		SFN2,
		})
	}
!  endif
	Name(PLCY, 0)				// primary thermal policy-active

! if $(A_GET_THRM_DATA)
!  if "$(A_THRM_INDEX_DATA_IO_Adr)" != ""
	OperationRegion(THOR, SystemIO, 0x$(A_THRM_INDEX_DATA_IO_Adr), 0x02)
	Field ( THOR, ByteAcc, NoLock, Preserve)
	{
	  ECMI, 8,        	// Extended CMOS index
	  ECMD, 8		// Extended CMOS data
	}
	IndexField (ECMI, ECMD,	// index/data
	ByteAcc, NoLock, Preserve)
	{
	Offset(0x$(A_THRM_INDEX_DATA_IO_Ofs)),
!  endif
	TMIN,8,         // TMIN
	TMAX,8,         // TMAX
	TCRT,8,         // TCRT
	TSP, 8,         // TSP
	TC1, 8,         // TC1
	TC2, 8,         // TC2
	TSAD,8,         // TSAD
	}		// End of Thermal data field
! else
	Name(TMIN, $(A_TRP1))           // 1st Thermal limit
	Name(TMAX, $(A_TRP2))           // 2nd Thermal limit
	Name(TCRT, $(A_TCRT))           // Critical themperature
	Name(TSP , $(A_TSP))            // Themp. sampling period
	Name(TC1 , $(A_TC1))            // 1st Thermal constant
	Name(TC2 , $(A_TC2))            // 2nd Thermal constant

	Name(TSAD, 0x$(A_THRM_Adr))     // Tsensor SMBus address
! endif
//----------------------------------------------------------------------
//	Thermal sensor module
//----------------------------------------------------------------------
	Include("$(ACPI_ASL_PATH)tsensor.asl")

ThermalZone (THRM)
	{
	Method(_CRT) {				// get critical temp
			Return (KELV(TCRT))
			}
	Method(_TMP) {				// get current temp
			Return (KELV(RTMP()))
			}
// Passive cooling objects
// CPU is a passive cooling device
!if "$(NCPU)" != ""
	Name(_PSL, Package (){\_PR.CPU1})
!  endif

	Method(_TSP,0) {			//sample every TSP*10 sec
		Multiply(TSP, 10, Local0)
		Return(Local0)
	}

	Method(_TC1,0){                         // 1st Thermal constant
		Return(TC1)
	}
	Method(_TC2,0){                         // 2nd Thermal constant
		Return(TC2)
	}

	Method(_PSV) { If(PLCY)			// activate CPU throttling
		       {Return (KELV(TMIN))}
		else   {Return (KELV(TMAX))}
		    }
// Active cooling objects
// fan is an active cool device
!if $(A_FAN_MODEL_1)
	Name(_AL0, Package(1){FANC})
	Method(_AC0)	{
		If(PLCY)
			{ Return (KELV(TMAX)) }
		else	{ Return (KELV(TMIN)) }
				}
! elseif $(A_FAN_MODEL_2) || $(A_FAN_MODEL_3)
	Name(_AL0,Package()
	    {
		FN00,
	    })
	Name(_AL1,Package()
	    {
		FN01,
	    })
	Name(_AL2,Package()
	    {
		FN02,
	    })
// OEM Specific code.
// Provide proper thermal limits for each FAN device

	Method(_AC0)		// Return active trip point
	    {
	      If(PLCY)  {Return(Add(KELV(TMIN), 200))}	// $(A_TRP1) + 20.0 C
	      Else  {Return(Add(KELV(TMIN), 150))}    	// $(A_TRP1) + 15.0 C
	    }

	Method(_AC1)
	    {
	      If(PLCY)  {Return(Add(KELV(TMIN), 100))}	// $(A_TRP1) + 10.0 C
	      Else  {Return(Add(KELV(TMIN), 50))}     	// $(A_TRP1) + 05.0 C
	    }

	Method(_AC2)
	    {
	      If(PLCY)  {Return(Add(KELV(TMIN), 50))}	// $(A_TRP1) + 05.0 C
	      Else  {Return(Add(KELV(TMIN), 0))}	// $(A_TRP1) + 00.0 C
	    }
!  endif
	Method(_SCP, 1) {			// set cooling mode

		Store (Arg0, PLCY)

		TCHG()				// Set Thigh/TLow

//      Notify value same as for Thermal _L$(A_THERMAL_GPE) handler
		Notify(\_TZ.THRM, 0x81)		// Notify of trip point change
		       }
	}					// end of Thermal Zone
!       if "$(A_THERMAL_GPE)" != ""
Scope(\_GPE){
//---------------------------------------------------------------------------
//	Thermal event handler
//---------------------------------------------------------------------------
	Method( _L$(A_THERMAL_GPE), 0, Serialized )   {
		\_TZ.THDL()		  	// Interrupt handler

		Notify(\_TZ.THRM, 0x81)		// Notify of temperature change
	}

//	Method( _L07, 0, Serialized)	{	// Clear Thermal Override. PIIX4 only
//		NoOp
//	}
}						// End of \_GPE
!	endif
}						// End of \_TZ
!endif
!if "$(A_SI_ISA_IO_Adr)"  != ""
	OperationRegion(SIOR, SystemIO, 0x$(A_SI_ISA_IO_Adr), 0x04)
!elseif "$(A_SI_INDEX_DATA_IO_Adr)" != ""
	OperationRegion(SIOR, SystemIO, 0x$(A_SI_INDEX_DATA_IO_Adr), 0x02)
	Field ( SIOR, ByteAcc, NoLock, Preserve)
		{
		SIND,8,		//field named INDX is 8 bits wide
		SDTA,8		//field DATA is 8 bits wide
		}
!endif
!if $(A_SI_MODEL_1)
//-----------------------------------------------------------------------
// System indication 1
//-----------------------------------------------------------------------
	$(A_SI_FIELD)
	{
	,$(A_SI_LED_1_GPO_Offset),
	LEDW,1,			// LED control bit 1
	}
	Name(LDON, $(A_SI_LED_1_ON))
! elseif $(A_SI_MODEL_2)
//-----------------------------------------------------------------------
// System indication 2
//-----------------------------------------------------------------------
	$(A_SI_FIELD)
	{
	,$(A_SI_WORK_GPO_Offset),
	LEDW,1,			// LED control bit 1
	}

	$(A_SI_FIELD)
	{
	,$(A_SI_SLEEP_GPO_Offset),
	LEDS,1,			// LED control bit 2
	}
	Name(WKON, $(A_SI_WORK_2_ON))
	Name(SPON, $(A_SI_SLEEP_2_ON))
! elseif $(A_SI_MODEL_3)
//-----------------------------------------------------------------------
// System indication 3
//-----------------------------------------------------------------------
	$(A_SI_FIELD)
	{
	,$(A_SI_LED_3_GPO_Offset),
	LEDW,1,			// LED control bit
	}

	$(A_SI_FIELD)
	{
	,$(A_SI_BLINK_GPO_Offset),
	BLNK,1,			// Steady / Blink
	}
	Name(LDON, $(A_SI_LED_3_ON))
	Name(STDY, $(A_SI_LED_STEADY))
!endif
!if $(A_SI_OEM)
	Include("$(ACPI_ASL_PATH)cust_SI.oem")
! elseif "$(A_SI_PATH)" != ""
	Include("$(ACPI_ASL_PATH)SI.asl")
! else
!endif
!if $(A_PTS_WAK_OEM)
// CUSTOM PTS_WAK
// make all changes in CUST_PTS.oem
	Include("$(ACPI_ASL_PATH)CUST_pts.oem")
!else

!if $(A_PM1a_Cnt_IO_TRAP) && $(A_S_PIIX4) && $(A_POS_DECODE)
// I/O Trap control code
	Include("$(ACPI_ASL_PATH)iotrap.asl")
!endif
//-----------------------------------------------------------------------
// 	_PTS METHOD CALLED JUST BEFORE OS GO TO SLEEP
//-----------------------------------------------------------------------
	Method(_PTS, 1){
		Store(Arg0, DBG8)
!if $(A_S_PIIX4)
		if (LEqual(Arg0,1)){
			Store(1, ETRP)
			}
!endif
!if $(A_S_SIS5595) || $(A_S_VIA82586) 
// Added by Abel Wu at 07/24/98 for Clear Wakeup IRQ Status
	if (LEqual(Arg0,1)){
		While(WAKS)
		{
			Stall(80)
			Store(1,WAKS)
		}
	}
!endif
!if $(A_N_I440BX)
// Reset CPU by resume from S2 state
// This code is for Intel 440BX based design only
		Store(0, \_SB.PCI0.PCIR)
		If(LEqual(Arg0,2)) {Store(1, \_SB.PCI0.PCIR)}
!	endif

!	if  $(A_THERMAL)
		Store(\GFAN._OFF, Local0)	// Basically is an OS bug bypass
						// Win98 keeps FAN On in suspend state
! 	endif
!	if $(A_SLEEP_BUTTON_GENERIC)
// Set Sleep flag for Sleep Button Device
//		Not(SLPS, SLPS)
		Store(1, \_SB.SLPS)
!	endif
!	if $(A_POWER_BUTTON_GENERIC)
// Set Sleep flag for Power Button Device
//		Not(PBST, PBST)
		Store(1, \_SB.PBST)
!	endif

!if $(A_PM1a_Cnt_IO_TRAP) && $(A_S_PIIX4) && $(A_POS_DECODE)
		Add(\_SB.PCI0.PMU.PMBS(), 4, Local0)
		TRAP(Arg0, 1, Local0)		// Trap on access to PM_BASE+4 enable
!	endif
	}
//-----------------------------------------------------------------------
// 	_WAK METHOD CALLED RIGHT AFTER OS WAKES UP FROM SLEEP
//-----------------------------------------------------------------------
	Method(_WAK, 1) {

		ShiftLeft(Arg0, 4, DBG8)

!if $(A_S_PIIX4)
		Store(1, GSCI)
!endif

!if $(A_S_SIS5595) || $(A_S_VIA82586) || $(A_S_ALI1543) 
// Added by Abel Wu at 07/24/98 for Generate SCI
	Store(1,BIOS)
!endif

!if $(A_PM1a_Cnt_IO_TRAP) && $(A_S_PIIX4) && $(A_POS_DECODE)
		TRAP(Arg0, 0, 0)		// Trap on access to PM_BASE+4 disable
!	endif

!if $(A_START_UP_OEM) || $(A_THERMAL)
		if (LGreater(Arg0,1))
		{
!if $(A_START_UP_OEM)
// OEM start-up code.
		\INI()				// Run OEM start-up code
!endif
!if $(A_THERMAL)
		\_TZ.TCHG()			// Set Thigh/TLow
!endif
		}
!endif
!if $(A_N_I440BX)
// Reset CPU by resume from S2 state
// This code is for Intel 440BX based design only
		Store(0, \_SB.PCI0.PCIR)

!	endif
!	if $(A_SLEEP_BUTTON_GENERIC)
// Clear Sleep flag for Sleep Button Device
//		Not(SLPS, SLPS)
//		Store(0, SLPS)
!	endif
!	if $(A_THERMAL)
		Notify(\_TZ.THRM, 0x81)		// Notify of Thermal
!	endif
	}
!endif

//-----------------------------//
//   For debug purpose only    //
//-----------------------------//

!if $(A_S_PIIX4)
	OperationRegion (SMI0, SystemIO, 0x$(PM_BASE_HIGH:h=)2f, 1)
	Field (SMI0, ByteAcc,NoLock,Preserve)
		{ ,1,ETRP,1,}
	OperationRegion (SMI1, SystemIO, 0x$(PM_BASE_HIGH:h=)28, 1)
	Field (SMI1, ByteAcc,NoLock,Preserve)
		{ ,1,GSCI,1,}
!endif
!if $(A_S_SIS5595)
	OperationRegion (WAKP, SystemIO, 0x$(PM_BASE_HIGH:h=)14, 1)
	Field (WAKP, ByteAcc,NoLock,Preserve)
		{ ,7,WAKS,1}
	OperationRegion (GBLE, SystemIO, 0x$(PM_BASE_HIGH:h=)13, 1)
	Field (GBLE, ByteAcc,NoLock,Preserve)
		{ ,1,BIOS,1,}
!endif
!if $(A_S_VIA82586)
	OperationRegion (WAKP, SystemIO, 0x$(PM_BASE_HIGH:h=)28, 1)
	Field (WAKP, ByteAcc,NoLock,Preserve)
		{ ,7,WAKS,1}
	OperationRegion (GBLE, SystemIO, 0x$(PM_BASE_HIGH:h=)2C, 1)
	Field (GBLE, ByteAcc,NoLock,Preserve)
		{ ,1,BIOS,1,}
!endif
!if $(A_S_ALI1543)
	OperationRegion (GBLE, SystemIO, 0x$(PM_BASE_HIGH:h=)20, 1)
	Field (GBLE, ByteAcc,NoLock,Preserve)
		{ ,1,BIOS,1,}
	OperationRegion (PBTN, SystemIO, 0x$(PM_BASE_HIGH:h=)01, 1)
	Field (PBTN, ByteAcc,NoLock,Preserve)
		{ PWRB,1,}
!endif
	OperationRegion (TEMP, SystemIO, 0x80, 1)
	Field (TEMP, ByteAcc,NoLock,Preserve)
		{ DBG8,8,}
	OperationRegion (DEB0, SystemIO, 0x90, 2)
	Field (DEB0, WordAcc,NoLock,Preserve)
		{ DBG9,16,}
}						// End of ASL File
<<
# James
!if !exist($(ACPI_ASL_DIR)\oemdsdt.asl)
#---------------------------------------------------------------------------------------------#
#       COPY TARGET INCLUDE FILES INTO THE DESTINATION (ACPI.ASL).                            #
#---------------------------------------------------------------------------------------------#
        @$(COPY) $(PCI_DEV_PATH)\$(A_NRTH_BRG_PATH).asl $(ACPI_ASL_DIR)
	@$(COPY) $(A_SOUTH_BRG_PATH)\irq-pci.asl $(ACPI_ASL_DIR)
	@$(COPY) $(SYSTEM_PATH)\sysstand.asl $(ACPI_ASL_DIR)
!if $(A_PMU_ALL)
!ifndef PM_BASE_HIGH
	@$(COPY) $(A_SOUTH_BRG_PATH)\pmbase.asl $(ACPI_ASL_DIR)
!endif
!endif
!if $(A_POS_DECODE)
	@$(COPY) $(A_SOUTH_BRG_PATH)\eioroute.asl $(ACPI_ASL_DIR)
! if $(A_PM1a_Cnt_IO_TRAP) && $(A_S_PIIX4)
	@$(COPY) $(A_SOUTH_BRG_PATH)\iotrap.asl $(ACPI_ASL_DIR)
! endif
!endif
!if $(A_SMBUS)
	@$(COPY) $(A_SMB_HOST_PATH) $(ACPI_ASL_DIR)
!endif
!if !($(A_PCI_IRQ_ROUTE_STANDARD))
	@$(COPY) $(CUSTOM_PATH)\cust_irq.oem $(ACPI_ASL_DIR)
!endif
!if $(A_IDE_PM)
	@$(COPY) $(A_IDE_PM_PATH) $(ACPI_ASL_DIR)
!endif
	@MD $(ACPI_ASL_DIR)\TEMP
# SuperIO exceptions
!if $(NAT338) || $(WIN877) || $(SMC665) || $(GM803C) 
	@$(COPY) $(OEMIO_PATH_SUPERIO)\$(A_OEMIO_PATH_SUPERIO)\*.asl $(ACPI_ASL_DIR)\TEMP
!elseif "$(OEMIO_PATH_SUPERIO)" != ""
# COPY SuperIO stuff
	@$(COPY) $(OEMIO_PATH_SUPERIO)\$(A_OEMIO_PATH_SUPERIO)\$(A_OEMIO_PATH_SUPERIO).asl $(ACPI_ASL_DIR)\TEMP
	@$(COPY) $(OEMIO_PATH_SUPERIO)\iocfg.asl $(ACPI_ASL_DIR)\TEMP
	@$(COPY) $(OEMIO_PATH_SUPERIO)\iodata.asl $(ACPI_ASL_DIR)\TEMP
!endif
	@COPY $(ACPI_ASL_DIR)\TEMP\*.* $(ACPI_ASL_DIR)\superio.asl
	DELTREE -Y $(ACPI_ASL_DIR)\TEMP\*.*

!if "$(A_OEMIO_PATH_AUDIO)" != ""
	@$(COPY) $(OEMIO_PATH_AUDIO)\$(A_OEMIO_PATH_AUDIO)\*.* $(ACPI_ASL_DIR)\TEMP
	@COPY $(ACPI_ASL_DIR)\TEMP\*.* $(ACPI_ASL_DIR)\audio.asl
	@DELTREE -Y $(ACPI_ASL_DIR)\TEMP\*.*
!endif
! if $(A_SI_OEM)
	@$(COPY) $(A_SI_PATH) $(ACPI_ASL_DIR)\TEMP
	@COPY $(ACPI_ASL_DIR)\TEMP\*.* $(ACPI_ASL_DIR)\cust_si.oem
! elseif "$(A_SI_PATH)" != ""
	@$(COPY) $(A_SI_PATH) $(ACPI_ASL_DIR)\TEMP
	@COPY $(ACPI_ASL_DIR)\TEMP\*.* $(ACPI_ASL_DIR)\si.asl
! endif
	@DELTREE -Y $(ACPI_ASL_DIR)\TEMP\*.*
! if $(A_FAN_OEM)
	@$(COPY) $(A_FAN_PATH) $(ACPI_ASL_DIR)\TEMP
	@COPY $(ACPI_ASL_DIR)\TEMP\*.* $(ACPI_ASL_DIR)\cust_fan.oem
! elseif "$(A_FAN_PATH)" != ""
	@$(COPY) $(A_FAN_PATH) $(ACPI_ASL_DIR)\TEMP
	@COPY $(ACPI_ASL_DIR)\TEMP\*.* $(ACPI_ASL_DIR)\fan.asl
! endif
	@DELTREE -Y $(ACPI_ASL_DIR)\TEMP\*.*

!if $(A_THERMAL)
	@$(COPY) $(A_T_SENSOR_PATH) $(ACPI_ASL_DIR)\TEMP
	@COPY $(ACPI_ASL_DIR)\TEMP\*.* $(ACPI_ASL_DIR)\tsensor.asl
!endif
	@DELTREE -Y $(ACPI_ASL_DIR)\TEMP

!if $(A_START_UP_OEM)
	@$(COPY) $(CUSTOM_PATH)\cust_stp.oem $(ACPI_ASL_DIR)
!endif

!if $(A_PTS_WAK_OEM)
	@$(COPY) $(CUSTOM_PATH)\cust_pts.oem $(ACPI_ASL_DIR)
!  endif

!if $(A_OEM_ISA_DEV)
	@$(COPY) $(CUSTOM_PATH)\cust_isa.oem $(ACPI_ASL_DIR)
!endif
!if $(A_OEM_PCI_DEV)
	@$(COPY) $(CUSTOM_PATH)\cust_pci.oem $(ACPI_ASL_DIR)
!endif
#-----------------------------------------------------------------------#
! endif
# James        $(ASL) /Fo=$(BUILD_DIR)\$(BIOSFILE).aml /Fl=$(ASL_NAME).lst /Fn=$(ASL_NAME).nsd $(ACPI_ASL_DIR)\$(ASL_NAME).asl
#        @[EXIT]
