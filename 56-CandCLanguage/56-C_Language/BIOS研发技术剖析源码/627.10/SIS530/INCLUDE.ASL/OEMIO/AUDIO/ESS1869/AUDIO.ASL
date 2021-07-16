//**********************************************************************;
//     *****************************************************************;
//     *****************************************************************;
//     **                                                             **;
//     **      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
//     **                                                             **;
//     **                     All Rights Reserved.                    **;
//     **                                                             **;
//     **           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
//     **                                                             **;
//     **                     Phone (770)-246-8600                    **;
//     **                                                             **;
//     *****************************************************************;
//     *****************************************************************;
//**********************************************************************;
// Start of Definitions for ESS1869 Audio device
//**********************************************************************;

OperationRegion (CFGS,          // name of Operation Region
		SystemIO,	// type of address space
		0x900,		// temporary offset to start of region
		0x20)           // size of region in bytes 900h - 91fh
				// end of Operation Region


Field (CFGS ,ByteAcc, NoLock, Preserve)
	{
	IND0,8,
	Offset(0x8),
	IND1,8,
	Offset(0x10),
	IND2,8,
	Offset(0x18),
	IND3,8,
	}


Method(NDTC,0) {		// Audio base addresses detect

	Store(0x900, Local0)	// default base for CFG device
	If(LNotEQual(IND1,0xFF)) {Store(0x908,Local0)}
	If(LNotEQual(IND2,0xFF)) {Store(0x910,Local0)}
	If(LNotEQual(IND3,0xFF)) {Store(0x918,Local0)}
	Return(Local0)

	}

// Configuration device

OperationRegion (ACFG,		// name of Operation Region for Audio CFG device
		SystemIO,	// type of address space
		NDTC,		// offset to start of region
				// (default offset for CFG device)

		2)  		// size of region in bytes
				// end of Operation Region

Field (	ACFG,		//fields are in this Operation Region
	ByteAcc,
	NoLock,
	Preserve)
		{
		AIND,8,	// index field AIND is 8 bit wide
		ADAT,8	// data  field ADAT is 8 bit wide
		}

IndexField (		AIND,		// Index name
			ADAT,		// Name of I/O port
			ByteAcc,
			NoLock,
			Preserve)
			{
//			Offset(0x2),
//			CFG,8,		//Global config control reg
			Offset(0x7),
			LDN,8,		//Logical Device Number
			Offset(0x25),
			,7,
			MPUS,1,		// MPU device control
					// 0- MPU is part of LDN #1
					// 1- MPU is LDN #3
			Offset(0x2D),
			PWRM,2,		// ESS Power control
			Offset(0x30),
			ACTR,1,		//activate register
			Offset(0x60),
			IOAH,8,		//base I/O High addr
			IOAL,8,		//base I/O Low addr
			FMAH,8,         // base for FM
			FMAL,8,		// if 0 - FM not accessible/disable
			MPAH,8,		// MPU IO may also config on #60-#61
			MPAL,8,		// if set as LDN#3
			Offset(0x70),
			INTR,8,		//IRQ
			,8,		//0x  Offset(0x72)
			INT1,8,		//Second IRQ for some devices
			,8,		//0x Offset(0x74)
			DMC0,8,		//DMA channel 0
			DMC1,8,		//DMA channel 1
		} //end of indexed field

//------------------------------------------------------------------
	Name(CFST,0)			// ESS Config. device
	Name(AUST,0)			// ESS1869 Audio
	Name(JYST,0)			// Joystick

	Method(AUDT)			// Start up code to detect
	{				// the presence of Super IO devices
// ESS CFG
	Store(0x0, LDN)
		If(ACTR)		// Get device status
		{
		Store(1, CFST)          // device present
		}
// ESS Audio
	Store(0x1, LDN)
		If(ACTR)		// Get device status
		{
		Store(1, AUST)          // device present
		}
// ESS Joystick
	Store(0x2, LDN)
		If(ACTR)		// Get device status
		{
		Store(1, JYST)          // device present
		}
	}


// End of TESS1878
