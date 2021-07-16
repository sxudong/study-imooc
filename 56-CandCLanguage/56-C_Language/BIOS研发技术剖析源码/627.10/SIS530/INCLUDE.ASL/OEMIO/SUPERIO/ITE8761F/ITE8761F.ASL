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
// Start of Definitions for ITE87x super I/O device
//**********************************************************************;


	OperationRegion(WIN1,	// Name of Operation Region for SuperIO device
		SystemIO,	// Type of address space
		SPIO,		// Offset to start of region
				// (default offset for SuperIO device)
				// (Real systems will likely have the BIOS relocate this device
				// to avoid conflicts with secondary floppy ID of 0x370)
		2)  		// Size of region in bytes
				// End of Operation Region

	Field(WIN1,		// Fields are in this Operation Region
		ByteAcc, NoLock, Preserve) {
			INDX, 8,	// Field named INDX is 8 bits wide
			DATA, 8		// Field DATA is 8 bits wide
		}

	IndexField(INDX,		// Index name
		DATA,			// Name of I/O port
		ByteAcc, NoLock, Preserve) {
			Offset(0x2),
			CFG,  8,	// Global config control reg
			Offset(0x7),
			LDN,  8,	// Logical Device Number
			Offset(0x30),
			ACTR, 8,	// Activate register
			Offset(0x60),
			IOAH, 8,	// Base I/O addr
			IOAL, 8,	// Base I/O addr
			Offset(0x70),
			INTR, 8,	// IRQ
			, 8,		// 0x  Offset(0x72)
			INT1, 8,	// Second IRQ for some devices
			, 8,		// 0x Offset(0x74)
			DMCH, 8,	// DMA channel
			Offset(0xc0),
			GP40, 8,	// Fast IR control bits
			Offset(0xf0),
			OPT1, 8,	// Option register 1
			OPT2, 8,	// Option register 2
			OPT3, 8		// Option register 3
		}			// End of indexed field

	OperationRegion(SMIR, SystemIO, 0xb2, 0x01)
	Field ( SMIR, ByteAcc, NoLock, Preserve)
	{
	SSMI, 8,			// Software SMI port
        }

/*
	OperationRegion(PNPR, SystemIO, 0x279, 0x01)
	Field ( PNPR, ByteAcc, NoLock, Preserve)
	{
	XPRT, 8,			// PnP config port
	}

// IOKey
	Name(IKEY, Package(){
			Package(4) {0x86, 0x80, 0x55, 0x55},	// For 3F0
			Package(4) {0x86, 0x80, 0x55, 0xAA}, 	// For 3BD
			Package(4) {0x86, 0x80, 0xAA, 0x55},	// For 370
	})
// ConfigKey
	Name(CKEY, Buffer(32){
			0x06a, 0x0b5, 0x0da, 0x0ed, 0x0f6,
			0x0fb, 0x07d, 0x0be, 0x0df, 0x06f,
			0x037, 0x01b, 0x00d, 0x086, 0x0c3,
			0x061, 0x0b0, 0x058, 0x02c, 0x016,
			0x08b, 0x045, 0x0a2, 0x0d1, 0x0e8,
			0x074, 0x03a, 0x09d, 0x0ce, 0x0e7,
			0x073, 0x039,
	})
*/
	Method(ENFG,0){			// Enter Config Mode for

	Store(0xec, SSMI)		// generate an SMI to enter the config mode over SMI code

/*
// Enter IOkey, set the proper Package index
	Store(0, Local1)
	If(LEqual(SPIO, 0x3f0)) {
				Store(0, Local1)
		}
	If(LEqual(SPIO, 0x3b0)) {
				Store(1, Local1)
		}
	If(LEqual(SPIO, 0x370)) {
				Store(2, Local1)
		}

	Store(0, Local0)		// Store the counter
	While(LNotEqual(Local0,4))
	{
		Store(DeRefOf(Index(DeRefOf(Index(IKEY,Local1)), Local0)) , XPRT)
		Increment(Local0)
	}

// Enter ConfigKey
	Store(0, Local0)		// Store the counter
	While(LNotEqual(Local0,32))
	{
		Store(DeRefOf(Index(CKEY,Local0)) , INDX)
		Increment(Local0)
	}
*/
	}

	Method(EXFG,0){			// Enter Config Mode
	Store(0x02, CFG)
	}

// Logical Device numbers for UART1, UART2, FDC, LPT, ECP, IrDa
	Name(LDFD, 0)	// Floppy controller LDD
	NAme(LDU1, 1)	// UART 1
	NAme(LDU2, 2)	// UART2
	NAme(LDIR, 2)	// IRDa
	NAme(LDLP, 3)	// LPT/ECP

// Floppy Disk Controller - FDC0 /////////////////////////////////////////

Device(FDC0) {
	Name(_HID, EISAID("PNP0700"))		// PnP Device ID


	Method(_STA, 0) {
					// FDC LDN = 0
		If(FDST) {
			Return(GSTA(0))	// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(0) 		// Disable FDC (LDN = 0)
	}

	Method(_CRS, 0) {Return(FCRS)}	// Return FDC current resources

	Method(_PRS, 0) {Return(FPRS)}	// Return FDC possible resources

	Method(_SRS, 1) {
		DENB(0)			// Enable FDC (LDN = 0)
	}
} // End Of FDC0 /////////////////////////////////////////////////////////

// UART1 - COMA //////////////////////////////////////////////////////////

Device(UAR1) {
	Name(_HID, EISAID("PNP0501"))	// PnP Device ID 16550 Type
	Name(_UID, 1)			// Generic ID for COMA

	Method(_STA, 0) {
					// UART1 LDN = 1
		If(U1ST) {
			Return(GSTA(1))	// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(1)			// Disable UART1 (LDN = 4)
	}

	Method(_CRS, 0) {
		Return(PCRS(1, 1, 8))	// Get UART1 current resources
	}

	Method(_SRS, 1) {
		PSRS(Arg0, 1)		// Set UART1 recources
	}

	Method(_PRS) {Return(C1PR)}	// Return UART1 possible resources

// RI# Ring Indicate Wake Up on UART1 - Applies only to Desktop Reference TX

//	Name(_PRW, Package() {		// Wake-up control method
//		10, 3			// RI is wired to the chipset
//	})				// as a wake event
} // End Of COMA //////////////////////////////////////////////////////

// UART2 - COMB ///////////////////////////////////////////////////////

Device(UAR2) {
	Name(_HID, EISAID("PNP0501"))	// PnP Device ID 16550 Type
	Name(_UID, 2)                   // Generic ID for COMB

	Method(_STA, 0) {

		Store(U2ST, Local0)
		If(Local0)
		{
			ENFG()        		// Enter Config Mode
			Store(0x02, LDN)	// UART2 LDN = 2
			If(LNotEqual(OPT2, 0x4a))
			{
				Store(GSTA(2), Local0)	// Get UART2 status
			}
			Else {
				Store(0, Local0)
			}
			EXFG()			// Exit Config Mode
		}
		Return(Local0)
	}


	Method(_DIS, 0) {
		DDIS(2)			// Disable UART2 (LDN = 2)
	}

	Method(_CRS, 0) {
		Return(PCRS(2, 1, 8))	// Get UART2 current resources

	}

	Method(_SRS, 1) {
		PSRS(Arg0, 2)		// Set UART2 recources
	}

	Method(_PRS) {Return(C2PR)}	// Return UART2 possible resources

} // End Of COMB ///////////////////////////////////////////////////////////

// InfraRed device - IRDA //////////////////////////////////////////////////
/*
Device(IRDA){
	Name(_HID,EISAID("PNP0510"))

// IRDA._STA Control Method
	Method(_STA, 0) {
		ENFG()			// Enter Config Mode
		Store(0x02, LDN)	// Select Appropriate LDN (IrD)
		If(LNotEqual(OPT2, 0x42))
                {
			Store(0x8, LDN)
//			If(And(GP40, 0x11)) {	// If FIR mode
			If(And(GP40, 0x18)) {	// If FIR mode
			Store(0x0, Local0)
			}
			Else {
			Store(0x02, LDN)	// Select Appropriate LDN (IrD)
			Store(GSTA, Local0)	// Get IrD status
			}                 	
		}
		Else {
		Store(0x0, Local0)	// Get IrD status
                }
                EXFG()			// Exit Config Mode
                Return(Local0)
	}

	Method(_DIS, 0) {
		ENFG()        		// Enter Config Mode
		DDIS(2)			// Disable IrD (LDN = 2)
                EXFG()			// Exit Config Mode
	}

	Method(_CRS, 0) {
		ENFG()        		// Enter Config Mode
		Store(PCRS(2, 1, 8), Local0)	// Get IrD current resources
                EXFG()			// Exit Config Mode
                Return(Local0)  	// Return Current Resources
	}

        Method(_SRS, 1) {
		ENFG()        		// Enter Config Mode
		PSRS(Arg0, 5)		// Set IrD resources
                EXFG()			// Exit Config Mode
        }

        Method(_PRS) {Return(C2PR)}	// return IrD possible resources

} // End Of IRDA ///////////////////////////////////////////////////////////
*/
// Parallel port - LPT //////////////////////////////////////////////////

Device(LPT) {
	Name(_HID, EISAID("PNP0400"))		// PnP ID for SMC LPT Port

	Method(_STA, 0) {
		ENFG()			// Enter Config Mode
		Store(0x03, LDN)	// Select Appropriate LDN (LPT)
		And(OPT1, 0x02, Local1)	// ECP Mode?
//		And(OPT1, 0x04, Local1)	// LPT Mode?
		EXFG()			// Exit Config Mode
		If(Or(Local0, And(Not(LPST),1)))// Yes - LPT is not present
		{
			Return(0)
		}
		Else {			// No - get LPT status
			Return(GSTA(3))
		}
	}

	Method(_DIS, 0) {
		DDIS(3)			// Disable LPT (LDN = 3)
	}

	Method(_CRS, 0) {
		Return(PCRS(3, 1, 8))	// Get LPT current resources
	}

        Method(_SRS, 1) {
		PSRS(Arg0, 3)		// Set LPT recources
	}

        Method(_PRS) {Return(LPPR)}	// Return LPT possible resources

} // End Of LPT ////////////////////////////////////////////////////////////

// Extended parallel port - ECP ////////////////////////////////////////////

Device(ECP) {
	Name (_HID, EISAID("PNP0401"))		// PnP ID ECP Port

	Method(_STA, 0) {
		ENFG()				// Enter Config Mode
		Store(3, LDN)			// ECP LDN = 1
		And(OPT1, 0x02, Local1)
		EXFG()				// Exit Config Mode
		If (Local1)			// ECP Mode?
		{
		   If(LPST) {Return(GSTA(3))}	// Yes - get ECP status
		}
		Else {
			Return(0)		// No - ECP is not present
		}
	}

	Method(_DIS, 0) {
		DDIS(3)			// Disable ECP (LDN = 3)
	}

	Method(_CRS, 0) {
		Return(ECRS(3))		// Get LPT current resources
	}

	Method(_SRS, 1) {		// Set ECP resources
		ESRS(Arg0, 3)		// Set resources
	}

	Method(_PRS) {Return(EPRS)}	// Return ECP possible resources
} // End Of ECP ////////////////////////////////////////////////////////////

// End of ITE87x device
