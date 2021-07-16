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
// Revision History
// ----------------
// 1     3/23/98 5:06p Alexp
//
//**********************************************************************;
//	ALI5135f SuperIO
//**********************************************************************;


	OperationRegion(ALI1,	// Name of Operation Region for SuperIO device
		SystemIO,	// Type of address space
		SPIO,		// Offset to start of region
				// (default offset for SuperIO device)
				// (Real systems will likely have the BIOS relocate this device
				// to avoid conflicts with secondary floppy ID of 0x370)
		2)  		// Size of region in bytes
				// End of Operation Region

	Field(ALI1,		// Fields are in this Operation Region
		ByteAcc,
		NoLock,
		Preserve) {
			INDX, 8,	// Field named INDX is b bits wide
			DATA, 8		// Field DATA is 8 bits wide
		}

	IndexField(INDX,		// Index name
		DATA,			// Name of I/O port
		ByteAcc,
		NoLock,
		Preserve) {
			Offset(0x2),
			CFG, 8,		// Global config control reg
			Offset(0x7),
			LDN, 8,		// Logical Device Number
			Offset(0x30),
			ACTR, 1,	// Activate register
			,6,
			FIR0,1,		//FIR enb. register, offset 0x30 bit7
			Offset(0x60),
			IOAH, 8,	// Base I/O High addr
			IOAL, 8,	// Base I/O Low addr
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
		} //end of indexed field
/*
	Field(ALI1,WordAcc,NoLock,Preserve) {
		INDC, 8,		
		}
	IndexField(INDX,INDC,ByteAcc,NoLock,Preserve) {
        	Offset(0x51),
		ENTR, 8,		// enable config control reg
                }
*/

		Method(ENFG, 0) {	// Enter Config Mode
			Store(0x51, INDX)
			Store(0x23, INDX)
//			Store(0x23, ENTR)
		}

		Method(EXFG,0) {	// Exit Config Mode
			Store(0xbb, INDX)
		}

// Logical Device numbers for UART1, UART2, FDC, LPT, ECP, IrDa
	Name(LDFD, 0)	// Floppy controller LDD
	NAme(LDU1, 4)	// UART 1
	NAme(LDU2, 0x0b)	// UART 2
	NAme(LDU3, 5)	// UART 3
	NAme(LDIR, 4)	// IRDa
	NAme(LDLP, 3)	// LPT/ECP

// Floppy Disk Controller - FDC0 /////////////////////////////////////////

Device(FDC0) {
	Name(_HID, EISAID("PNP0700"))	// PnP Device ID

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
// UART1 - IRD1 //////////////////////////////////////////////////////////
Device(UAR1) {
	Method(_HID, 0){
		ENFG()        		// Enter Config Mode
		Store(LDU1, LDN)		// UART1 LDN = 4
		And(OPT2, 0x18, Local0)
		EXFG()			// Exit Config Mode
		If (LEqual(Local0, 0x08)) {	// Ir is active => COMA not present
			Return(EISAID("PNP0510"))// PnP Device ID IrDa
		}
		Else {
			Return(EISAID("PNP0501"))// PnP Device ID 16550 Type
		}
	}

	Name(_UID, 1)			// Generic ID for COMA

	Method(_STA, 0) {
					// UART1 LDN = 4
		If(U1ST) {
			Return(GSTA(LDU1))	// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(LDU1)			// Disable UART1 (LDN = 4)
	}

	Method(_CRS, 0) {
		Return(PCRS(LDU1, 1, 8))	// Get UART1 current resources
	}

	Method(_SRS, 1) {
		PSRS(Arg0, LDU1)		// Set UART1 recources
	}

	Method(_PRS) {Return(C1PR)}	// Return UART1 possible resources

// RI# Ring Indicate Wake Up on UART1 - Applies only to Desktop Reference TX

//	Name(_PRW, Package() {		// Wake-up control method
//		10, 3			// RI is wired to the chipset
//	})				// as a wake event
} // End Of COMA //////////////////////////////////////////////////////
//// End Of IRDA //////////////////////////////////////////////////////


// UART2 - COMB /////////////////////////////////////////////////////
// UART2 InfraRed device - IRD2 /////////////////////////////////////
Device(UAR2) {

	Method(_HID, 0){
		ENFG()        		// Enter Config Mode
		Store(LDU2, LDN)		// UART2 LDN = b
		And(OPT2, 0x18, Local0)
		EXFG()
		If (LEqual(Local0, 0x8)) {	// Ir is active => COMA not present
			Return(EISAID("PNP0510"))// PnP Device ID IrDa
		}
		Else {
			Return(EISAID("PNP0501"))// PnP Device ID 16550 Type
		}
	}

	Name(_UID, 2)                   // Generic ID for COMB

	Method(_STA, 0) {
		If(U2ST) {
			Return(GSTA(LDU2))	// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(LDU2)			// Disable UART2 (LDN = 5)
	}

	Method(_CRS, 0) {
		Return(PCRS(LDU2, 1, 8))	// Get UART2 current resources

	}

	Method(_SRS, 1) {
		PSRS(Arg0, LDU2)		// Set UART2 recources
	}

	Method(_PRS) {Return(C2PR)}	// Return UART2 possible resources

} // End Of COMB ////////////////////////////////////////////////////////
//// End Of IRDA ////////////////////////////////////////////////////////

// UART3  //////////////////////////////////////////////////////
// IRDA ////////////////////////////////////////////////////////
Device(UAR3) {

	Method(_HID,0)
	{

		ENFG()        		// Enter Config Mode
		Store(LDU3, LDN)		// UART2 LDN = 5
		And(OPT2, 0x18, Local0)		// UART mode
		And(FIR0, 0x1,  Local1)		// FIR Mode?
		EXFG()
		If(Local1)
		{
			Return(EISAID("ALI5123"))	// Fast IR
		}
		Else
		{
			If (Local0) 		// Ir is active => COMA not present
			{
			Return(EISAID("PNP0510"))// PnP Device ID IrDa
			}
			Else
			{
			Return(EISAID("PNP0501"))// PnP Device ID 16550 Type
			}
		}
	}

	Name(_UID, 3)                   // Generic ID for COMC

	Method(_STA, 0) {
		If(IRST) {
			Return(GSTA(LDU3))	// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(LDU3)			// Disable UART3 (LDN = b)
	}

	Method(_CRS, 0) {
		Return(PCRS(LDU3, 1, 8))	// Get UART3 current resources

	}

	Method(_SRS, 1) {
		PSRS(Arg0, LDU3)		// Set UART3 recources
	}

	Method(_PRS) {Return(C2PR)}	// Return UART3 possible resources

} // End Of COMC ////////////////////////////////////////////////////////
//// End Of IRDA ////////////////////////////////////////////////////////

// Parallel port - LPT //////////////////////////////////////////////////
Device(LPT) {
	Name(_HID, EISAID("PNP0400"))		// PnP ID for SMC LPT Port

	Method(_STA, 0) {
		ENFG()			// Enter Config Mode
		Store(LDLP, LDN)	// Select Appropriate LDN (LPT)
		And(OPT1, 0x02, Local0)	// ECP Mode?
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
		DDIS(LDLP)			// Disable LPT (LDN = 3)
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
		Store(LDLP, LDN)		// ECP LDN = 3
		And(OPT1, 0x02, Local0)
		EXFG()				// Exit Config Mode
		If (Local0)			// ECP Mode?
		{
		  If(LPST) { Return(GSTA(3))}	// Yes - get ECP status
		}
		Else {
			Return(0)		// No - ECP is not present
		}
	}

	Method(_DIS, 0) {
		DDIS(LDLP)			// Disable ECP (LDN = 3)
	}

	Method(_CRS, 0) {
		Return(ECRS(3))		// Get LPT current resources
	}

	Method(_SRS, 1) {		// Set ECP resources
		ESRS(Arg0, 3)		// Set resources
	}

	Method(_PRS) {Return(EPRS)}	// Return ECP possible resources
} // End Of ECP ////////////////////////////////////////////////////////////
// End of SIO