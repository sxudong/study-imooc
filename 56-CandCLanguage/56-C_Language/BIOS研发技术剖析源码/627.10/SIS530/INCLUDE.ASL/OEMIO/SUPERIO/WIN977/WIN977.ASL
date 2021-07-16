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
// $Header: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/SUPERIO/WIN977/WIN977.ASL 7     7/28/98 10:12a Alexp $
//
// $Revision: 7 $
//
// $Date: 7/28/98 10:12a $
//**********************************************************************;
// Start of Definitions for WIN977 super I/O device

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
			CFG, 8,		// Global config control reg
			Offset(0x7),
			LDN, 8,		// Logical Device Number
			Offset(0x30),
			ACTR, 8,	// Activate register
			Offset(0x60),
			IOAH,8,		// Base I/O addr
			IOAL,8,		// Base I/O addr
			Offset(0x70),
			INTR,8,		// IRQ
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

	Method(ENFG, 0) {	// Enter Config Mode
		Store(0x87, INDX)
		Store(0x87, INDX)
	}

	Method(EXFG, 0) {	// Exit Config Mode
		Store(0xAA, INDX)
	}

// Logical Device numbers for UART1, UART2, FDC, LPT, ECP, IrDa
	Name(LDFD, 0)	// Floppy controller LDD
	NAme(LDU1, 2)	// UART 1
	NAme(LDU2, 3)	// UART2
	NAme(LDIR, 6)	// IRDa
	NAme(LDLP, 1)	// LPT/ECP

// Floppy Disk Controller - FDC0 /////////////////////////////////////////

Device(FDC0) {
	Name(_HID, EISAID("PNP0700"))		// PnP Device ID

	Method(_STA, 0) {

		If(FDST) {
					// LDN = 0
		Return(GSTA(0))		// Get status
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

		If(U1ST) {
					// LDN = 2
		Return(GSTA(2))		// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(2)			// Disable UART1 (LDN = 2)
	}

	Method(_CRS, 0) {
		Return(PCRS(2, 1, 8))	// Get UART1 current resources
	}

	Method(_SRS, 1) {
		PSRS(Arg0, 2)		// Set UART1 recources
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

		If(U2ST) {
					// LDN = 3
		Return(GSTA(3))		// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(3)			// Disable UART2 (LDN = 3)
	}

	Method(_CRS, 0) {
		Return(PCRS(3, 1, 8))	// Get UART2 current resources

	}

	Method(_SRS, 1) {
		PSRS(Arg0, 3)		// Set UART2 recources
	}

	Method(_PRS) {Return(C2PR)}	// Return UART2 possible resources


} // End Of COMB ///////////////////////////////////////////////////////////

// InfraRed device - IRDA //////////////////////////////////////////////////

Device(IRDA){
	Name(_HID,EISAID("PNP0510"))

// IRDA._STA Control Method
	Method(_STA, 0) {

		If(IRST) {
					// LDN = 62
		Return(GSTA(LDIR))	// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(6)			// Disable IRD (LDN = 6)
	}

	Method(_CRS, 0) {
		Return(PCRS(6, 1, 8))	// Get IRD current resources

	}

	Method(_SRS, 1) {
		PSRS(Arg0, 6)		// Set IRD recources
	}

	Method(_PRS) {Return(C2PR)}	// Return IRD possible resources


} // End Of IRDA ///////////////////////////////////////////////////////////

// Parallel port - LPT //////////////////////////////////////////////////

Device(LPT) {
	Name(_HID, EISAID("PNP0400"))		// PnP ID for SMC LPT Port

	Method(_STA, 0) {
		ENFG()			// Enter Config Mode
		Store(0x01, LDN)	// Select Appropriate LDN (LPT)
		And(OPT1, 0x02, Local0)	// ECP Mode?
		EXFG()			// Exit Config Mode
		If(Or(Local0, And(Not(LPST),1)))// Yes - LPT is not present
		{
			Return(Zero)
		}
		Else {			// No - get LPT status
			Return(GSTA(1))
		}
	}

	Method(_DIS, 0) {
		DDIS(1)			// Disable LPT (LDN = 1)
	}

	Method(_CRS, 0) {
		Return(PCRS(1, 1, 8))	// Get LPT current resources
	}

	Method(_SRS, 1) {
		PSRS(Arg0, 1)		// Set LPT recources
	}

        Method(_PRS) {Return(LPPR)}	// Return LPT possible resources

} // End Of LPT ////////////////////////////////////////////////////////////

// Extended parallel port - ECP ////////////////////////////////////////////

Device(ECP) {
	Name (_HID, EISAID("PNP0401"))		// PnP ID ECP Port

	Method(_STA, 0) {
		ENFG()				// Enter Config Mode
		Store(1, LDN)			// ECP LDN = 1
		And(OPT1, 0x02, Local0)
		EXFG()			// Exit Config Mode
		If (Local0)		// ECP Mode?
		{
		 If(LPST) { Return(GSTA(1))}// Yes - get ECP status
		}
		Else {
			Return(Zero)	// No - ECP is not present
		}

	}

	Method(_DIS, 0) {
		DDIS(1)			// Disable ECP (LDN = 1)
	}

	Method(_CRS, 0) {
		Return(ECRS(1))		// Get LPT current resources
	}

	Method(_SRS, 1) {		// Set ECP resources
		ESRS(Arg0, 1)		// Set resources
	}

	Method(_PRS) {Return(EPRS)}	// Return ECP possible resources

} // End Of ECP ////////////////////////////////////////////////////////////

// End of WIN977 device
