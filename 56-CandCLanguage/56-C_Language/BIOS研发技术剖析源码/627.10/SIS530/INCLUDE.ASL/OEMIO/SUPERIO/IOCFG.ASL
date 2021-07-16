////////////////////////////////////////////////////////////////////////
// SET OF DIFFERENT IO DEVICES CONTROL METHOD ROUTINES		      //
////////////////////////////////////////////////////////////////////////

// Detect on board Super IO devices
	Name(FDST,0)
	Name(U1ST,0)
	Name(U2ST,0)
	Name(IRST,0)
	Name(LPST,0)
//	Name(EPST,0)

	Method(IODT)			// Start up code to detect
	{				// the presence of Super IO devices
// FDC
		If(LEqual(GSTA(LDFD), 0xf)) // Get device status
		{
		Store(1, FDST)		 // device present
		}
// UART 1
		If(LEqual(GSTA(LDU1), 0xf)) // Get device status
		{
		Store(1, U1ST)		 // device present
		}
// UART 2
		If(LEqual(GSTA(LDU2), 0xf)) // Get device status
		{
		Store(1, U2ST)		 // device present
		}
// IR
		If(LEqual(GSTA(LDIR), 0xf)) // Get device status
		{
		Store(1, IRST)		 // device present
		}
// LPT,ECP
		If(LEqual(GSTA(LDLP), 0xf)) // Get device status
		{
		Store(1, LPST)		 // device present
		}
	}


// GET SIO DEVICE STATUS according to ACTR/IOAH/IOAL ///////////////////
// Note: device must be selected

Method(GSTA, 1) {		// Get UART status

	ENFG() 			       		// Enter Config Mode
	Store(Arg0, LDN)			// Select Appropriate LDN
	If(ACTR) {Store(0x0F, Local0)}		// Present & Active

	Else {
		If(Or(IOAH, IOAL)) {		// If device address <> 0
			Store(0x0D, Local0)	// then present &! active
		}
		Else {Store(0, Local0)}		// !present
//		Else {Store(0x1, Local0)}	// present/not decode IO/disabled
	}

	EXFG()					// Exit Config Mode
	Return(Local0)		// Return device status

} // EndOf GSTA

// Disable SIO device ///////////////////////////////////////////
// Note: device must be selected

Method(DDIS, 1) {

// Arg0 - LDN
	ENFG()        		// Enter Config Mode
	Store(Arg0, LDN)	// Select Appropriate LDN
	Store(Zero, ACTR)	// Set Activate Register to zero
	EXFG()			// Exit Config Mode
} // End DDIS

Method(DENB, 1) {		// Enable SIO device

// Arg0 - LDN
	ENFG()        		// Enter Config Mode
	Store(Arg0, LDN)	// Select Appropriate LDN
	Store(One, ACTR)	// Set Activate Register to zero
	EXFG()			// Exit Config Mode
} // End DDIS

// COMx and LPT _CRS implementation //////////////////////////

Method(PCRS, 3) {
// Arg0 - LDN
// Arg1 - Alignment
// Arg2 - IO Length

	CreateByteField(PBUF, 0x02, IOLO)	// Range Min Base LSB
	CreateByteField(PBUF, 0x03, IOHI)	// Range Min Base MSB
	CreateWordField(PBUF, 0x02, IOHL)	// Range Min Base Word
	CreateWordField(PBUF, 0x04, IORL)	// Range Max Base Word
	CreateByteField(PBUF, 0x06, ALMN)	// Alignment
	CreateByteField(PBUF, 0x07, LENG)	// Number of IO ports
	CreateByteField(PBUF, 0x09, IRQL)	// IRQ Mask


	ENFG()        		// Enter Config Mode
	Store(Arg0, LDN)	// Select Appropriate LDN

// Write Current Settings into Buffer for IO Descriptor
	Store(IOAH, IOHI)	// Get IO Base MSB
	Store(IOAL, IOLO)	// Get IO Base LSB
	Store(IOHL, IORL)	// Set MaxBase = MinBase
	Store(Arg1, ALMN)	// Set alignment
// adjust base/aligment size if base ports are 0x3bc/0x7bc
	If(LEqual(IOLO, 0xbc)) {Store(0x04, LENG)}
	Else {
	Store(Arg2, LENG)	// Set IO length
	}

// Write Current Settings into IRQ descriptor
	Store(One, Local0)
	ShiftLeft(Local0, INTR, IRQL)

	EXFG()			// Exit Config Mode
	Return(PBUF)		// Return Byte Stream
}
// End //////////////////////////////////////////////////////////

// COMx and LPT _SRS implementation //////////////////////////

Method(PSRS, 2) {
// Arg0 - PnP Resource String to set
// Arg1 - LDN

	CreateByteField (Arg0, 0x02, POLB)	// Range Min Base LSB
	CreateByteField (Arg0, 0x03, POHB)	// Range Min Base MSB
	CreateByteField (Arg0, 0x09, PIRQ)	// IRQ number

	ENFG()        		// Enter Config Mode
	Store(Arg1, LDN)	// Select Appropriate LDN

// Set Base IO Address
	Store(POLB, IOAL)       // Set IO Base LSB
	Store(POHB, IOAH)	// Set IO Base MSB

// Set IRQ
	FindSetRightBit(PIRQ, Local0)
	Subtract(Local0, 1, INTR)

	Store(One, ACTR)	// Activate
	EXFG()			// Exit Config Mode
}
// End //////////////////////////////////////////////////////////

// ECP _CRS implementation //////////////////////////////////////

Method(ECRS, 1) {
// Arg0 - LDN
	CreateByteField(EBUF, 0x02, EPLO)	// Range Min Base LSB
	CreateByteField(EBUF, 0x03, EPHI)	// Range Min Base MSB
	CreateWordField(EBUF, 0x02, EPHL)	// Range Min Base Word
	CreateWordField(EBUF, 0x04, EPRL)	// Range Max Base Word
	CreateWordField(EBUF, 0x06, ALM1)	// Alignment
	CreateWordField(EBUF, 0x0a, E4LO)	// IO Port+400h Low
	CreateWordField(EBUF, 0x0c, E4RL)	// IO Range+400h Low
	CreateWordField(EBUF, 0x11, EIRQ)	// IRQ
	CreateWordField(EBUF, 0x14, EDMA)	// DMA


	ENFG()    	    		// Enter Config Mode
	Store(Arg0, LDN)		// Select Appropriate LDN (LPT)

// Write Current Settings into Buffer for IO Descriptor
	Store(IOAH, EPHI)		// Get Min Base MSB
	Store(IOAL, EPLO)		// Get Min Base LSB

	Store(EPHL, EPRL)		// Set Max Base Word

	Add(EPHL, 0x400, E4LO)
	Store(E4LO, E4RL)

// adjust base/aligment size if base ports are 0x3bc/0x7bc
	If(LEqual(EPHL, 0x3bc)) {Store(0x0401, ALM1)}
	Else 			{Store(0x0801, ALM1)}

// Write Current Settings into IRQ descriptor
	Store(One, Local0)
	Store(INTR, Local1)
	ShiftLeft(Local0, Local1, EIRQ)

// Write Current Settings into DMA descriptor
	Store(DMCH, Local1)
	If(LGreater(Local1, 0x3))
	{
		Store(0, EDMA)			// No DMA
	}
	Else
	{
		Store(One, Local0)
		ShiftLeft(Local0, Local1, EDMA)
	}

	EXFG()				// Exit Config Mode

	Return(EBUF)			// Return Current Resources
}
// End //////////////////////////////////////////////////////////

// ECP _SRS implementation //////////////////////////////////////

Method(ESRS, 2) {
// Arg0 - PnP Resource String to set
// Arg1 - LDN
	CreateByteField (Arg0, 0x02, LOEP)	// IO Port Low
	CreateByteField (Arg0, 0x03, HIEP)	// IO Port Low
	CreateWordField (Arg0, 0x11, IRQE)	// IRQ
	CreateWordField (Arg0, 0x14, DMAE)	// DMA Channel

	ENFG() 	    		// Enter Config Mode
	Store(Arg1, LDN)	// Select Appropriate LDN (LPT)

// Set Base IO Address
	Store(LOEP, IOAL)
	Store(HIEP, IOAH)

// Set IRQ
	FindSetRightBit(IRQE, Local0)
	Subtract(Local0, 1, INTR)

// Set DMA
	If(DMAE)
	{
		FindSetRightBit(DMAE, Local0)
		Subtract(Local0, 1, DMCH)
	}
	Else	// No DMA
	{
		Store(4, DMCH)
	}


	Store(One, ACTR)	// Enable ACTR
	EXFG()			// Exit Config Mode
} 				// End of _SRS Method
// End //////////////////////////////////////////////////////////

// IR Port definitions
	Name(CNBF, Buffer() {0xF8, 0x3})// Buffer to provide word/byte access
					// to UART2 base address
// Device's Base address detecting
// Arg0 - has a proper LDN
	Method(UABS, 1) {

	ENFG()
	Store(Arg0, LDN)		// Select Appropriate LDN

	CreateByteField(CNBF, 0, IOLO)
	CreateByteField(CNBF, 1, IOHI)
	CreateWordField(CNBF, 0, IOAD)
	Store(IOAL, IOLO)
	Store(IOAH, IOHI)

	EXFG()
	Return(IOAD)
	}

//---------Power Resources for UART1 -------------------------
	Name(CSCP, 0)			// Power state status
   PowerResource(URP1, 1, 0) {   // SystemLevel Parameter=0,
						// which means UART can be turned off
						// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
//         Store(LDU1, LDN)  // Enable ACTivate register
//         Store(1, ACTR)
			Store(1, CSCP)
		}				// end of _ON
		Method(_OFF){
//         Store(LDU1, LDN)  // Disable ACTivate register
//         Store(0, ACTR)
			Store(0, CSCP)
		}				// end of _OFF
	}
//---------Power Resources for UART2 -------------------------
	PowerResource(URP2, 0, 0) {     // SystemLevel Parameter=0,
					// which means UART can be turned off
					// in any sleep state
					// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
			Store(1,CSCP)
		}				// end of _ON
		Method(_OFF){
			Store(0,CSCP)
		}				// end of _OFF
	}
//---------Power Resources for FDD -------------------------
	PowerResource(FDDP, 0, 0) {     // SystemLevel Parameter=0,
					// which means FDD can be turned off
					// in any sleep state
					// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
			Store(1,CSCP)
		}				// end of _ON
		Method(_OFF){
			Store(0,CSCP)
		}				// end of _OFF
	}
//---------Power Resources for LPT -------------------------
	PowerResource(LPTP, 0, 0) {     // SystemLevel Parameter=0,
					// which means LPT can be turned off
					// in any sleep state
					// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
			Store(1,CSCP)
		}				// end of _ON
		Method(_OFF){
			Store(0,CSCP)
		}				// end of _OFF
	}

/// end Power resources /////////
