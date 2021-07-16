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
//**********************************************************************;
// $Header: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/AUDIO/ESS1888/AUDIO.ASL 7     7/28/98 10:11a Alexp $
//
// $Revision: 7 $
//
// $Date: 7/28/98 10:11a $
//**********************************************************************;
//**********************************************************************;
// Revision History
// ----------------
// $Log: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/AUDIO/ESS1888/AUDIO.ASL $
// 
// 7     7/28/98 10:11a Alexp
// 
// 6     7/20/98 3:56p Alexp
// 
// 5     7/01/98 9:43p Alexp
// 
// 4     6/18/98 5:51p Alexp
// 
// 3     6/09/98 5:20p Alexp
// 
// 2     5/27/98 5:31p Alexp
// 
// 1     4/24/98 5:03p Alexp
// 
// 4     4/09/98 5:30p Alexp
// Get latest updates of all library ASL files
// 
// 1     3/13/98 6:08p Alexp
// Main ASL code library
// 
// 1     3/09/98 7:16p Alexp
// All generic include files 
// 
// 3     9/15/97 5:53p Alexp
// 
// 2     9/15/97 1:14p Alexp
// Disable Joistic device
// 
// 1     9/02/97 5:16p Alexp
// 
// 4     7/10/97 11:13a Alexp
//
// 3     5/20/97 11:08a Alexp
// Updated _STA metods for all NAT338 devices
//
//**********************************************************************;

// Start of Definitions for TESS1888 Audio device

OperationRegion (ACF1,          // Access to System Control Area
		SystemIO,	// type of address space
                0xF9,           // temporary offset to start of region
                0x3)            // size of region in bytes 0xF9-0xFB
                                // end of Operation Region


Field (ACF1 ,ByteAcc, NoLock, WriteAsZeros)
		{
		ALCK,8,         // #0xF9 Lock Audio Config Port
		,8,
		UNLK,8,         // #0xFB Unlock Audio Config Port
                }
OperationRegion (ACF2,          // Access to System Control Area
		SystemIO,	// type of address space
		0xE0,           // temporary offset to start of region
		0x2)            // size of region in bytes 0xE0-0xE1
				// end of Operation Region


Field (ACF2 ,ByteAcc, NoLock, WriteAsZeros)
		{
                INDE,8,
                DATE,8,
                }
IndexField (INDE, DATE, ByteAcc, NoLock, WriteAsZeros)
		{
		SCRG,8,         // System Control Register
		}

OperationRegion (TSTF, SystemIO, 0x22A, 0x21)
Field (TSTF ,ByteAcc, NoLock, WriteAsZeros)
		{
		TST2,8,          // Base 22Ah
		Offset(0x20),
		TST4,8,          // Base 24Ah
		}

Method(GETB,0) {

	If(LNOtEQual(TST2,0xFF)) {Return(0x220)}
	If(LNOtEQual(TST4,0xFF)) {Return(0x240)}
	Return(0)
}

OperationRegion (EXRG,          // name of Operation Region for Extendent registers
		SystemIO,	// type of address space
		GETB,           // temporary offset to start of region
//                0x220,           // temporary offset to start of region
		0x10)           // size of region in bytes 2x0h - 2xfh
				// end of Operation Region


Field (EXRG ,ByteAcc, NoLock, WriteAsZeros)
		{
		,32,
		MXI,8,          // #0x4 Mixer Index
		MXD,8,          // #0x5 Mixer Data
		PWR6,8,         // #0x6 Power control
		PWR7,8,         // #0x7 Power control
		PWR8,8,         // #0x8 Power control
		PWR9,8,         // #0x9 Power control
		EXRA,8,         // #0xA
		,8,
		EXRC,8,         // #0xC
		,8,
		EXRE,8,         // #0xE
		,8,             // #0xF offset
		}

IndexField (MXI, MXD, ByteAcc, NoLock, WriteAsZeros)
	       {
		Offset(0x40),
		MIX,8           // #0x40
		}                         // end of indexed field

//------------------------------------------------------------------
	Name(AUST,0)			// ESS1887 Audio
	Name(JYST,0)			// Joystick

	Method(AUDT)			// Start up code to detect
	{				// the presence of Super IO devices
// ESS Audio
	IF(GETB())              // Define base address of AUDIO device
	{
		Store(1, AUST)          // device present
	}
// ESS Joystick
	If(And(RDMX(),0x2))	    // Read the MIXER Ext Register bit #40.1
		{
		Store(1, JYST)          // device present
		}
	}

// End of TESS1888
