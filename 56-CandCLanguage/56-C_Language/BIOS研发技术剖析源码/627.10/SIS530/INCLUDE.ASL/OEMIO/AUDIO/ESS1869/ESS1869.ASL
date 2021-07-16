
Device(ESCF) {				// ESS1869/78 Config device

	Name(_HID, EISAID("ESS0006"))	// ESS1869CF PnP Device ID

	Method(_STA)
	{
		Store(0x0, LDN)			// Select Appropriate LDN

		If(CFST)
		{
			If(ACTR) {Return(0xb) }	// Read Activate Register
						// Device Present/Active/Not shown
			Else 	 {Return(0x9) }	// Device Present/UnActive/Not shown
//				Return(0xf) }	// Device Present/Active
//			Else {
//				Return(0xd) }	// Device Present/UnActive
		}
		Else 		 {Return(0) }	// Device Not Present
	}					// end _STA

	Name(BUF1, ResourceTemplate()
	{
	IO(Decode16, 0x900, 0x900, 0, 8)
	})
	Method(_CRS){

	CreateByteField (BUF1, 0x02, IOLO)	// IO Port Hi
	CreateByteField (BUF1, 0x03, IOHI)	// IO Port Low
	CreateWordField (BUF1, 0x02, IOHL)	// IO Range
	CreateWordField (BUF1, 0x04, IORL)	// IO Range

	Store(0x0, LDN)			// Select Appropriate LDN

	Store(IOAH, IOHI)
	Store(IOAL, IOLO)

	Store(IOHL, IORL)
	Return(BUF1)
	}
}

Device(ES69) {  			// Audio drive

//	Name(_HID, EISAID("ESS1878"))	// ESS1878 PnP Device ID
	Name(_HID, EISAID("ESS1869"))	// ESS1869 PnP Device ID


	Method(_STA,0){

	If(AUST)
	{
	Store(0x01,LDN)			// Select Appropriate LDN

		If(ACTR) {Return(0xf)}	// Read Activate Register
					// Device Present/Active/shown
		Else 	 {Return(0xd)}	// Device Present/UnActive/shown
	}
	Else 		 {Return(0)  }	// Device Not Present
	}				// End _STA method


	// Disable Method
	Method(_DIS,0){
		Store(0x01,LDN)			// Select Appropriate LDN (LPT)
	If(MPUS)				// if MPU as a separarte LDN
		{
		Store(0x03,LDN)			// Select LDN#3
		}
		Store(0, ACTR )			// Set Activate Register to zero
//	Release Sound IO ports
//	RRIO(0x4, 0x1, 0x220, 0x10)	// Audio
//	RRIO(0x4, 0x1, 0x300, 0x2)	// MPU401
//	RRIO(0x4, 0x1, 0x388, 0x4)	// FM Synth
	}				// End _DIS method

	Name(ESSB,
	ResourceTemplate()
	{
//0    01 02
//0x2a xx xx
	  DMA(Compatibility, NotBusMaster, Transfer8) {1}
//3    04 05
//0x2a xx xx
	  DMA(Compatibility, NotBusMaster, Transfer8) {3}
//6    07 08
//0x22 xx xx
	  IRQNoFlags(IRQA) {5}
//9    0a 0b 0c 0d 0e 0f 10
//0x47 01 xx xx xx xx xx xx
	  IO(Decode16, 0x220, 0x220, 0x20, 0x10)// Audio
//11   12 13 14 15 16 17 18
//0x47 01 xx xx xx xx xx xx
	  IO(Decode16, 0x388, 0x388, 4, 4)	// FM synt
//19   1a 1b 1c 1d 1e 1f 20
//0x47 01 xx xx xx xx xx xx
	  IO(Decode16, 0x300, 0x300, 0x10, 2)	// MPU401
	})

	Method(_CRS,0){
// Audio base
	CreateByteField (ESSB, 0x0b, IOLO)	// IO Port Low
	CreateByteField (ESSB, 0x0c, IOHI)	// IO Port Hi
	CreateWordField (ESSB, 0x0b, IOHL)	// IO Word
	CreateWordField (ESSB, 0x0d, IORL)	// IO Range
// FM Synthesizer
	CreateByteField (ESSB, 0x13, FMLO)	// FM Port Low
	CreateByteField (ESSB, 0x14, FMHI)	// FM Port Low
	CreateWordField (ESSB, 0x13, FMHL)	// FM Port Low
	CreateWordField (ESSB, 0x15, FMRL)	// FM Range
	CreateByteField (ESSB, 0x18, FMLG) 	// FM length
// MPU401
	CreateByteField (ESSB, 0x1b, MPLO) 	// MPU Port Low
	CreateByteField (ESSB, 0x1d, MPRL) 	// MPU Port Low
	CreateByteField (ESSB, 0x20, MPLG) 	// MPU Lengh
// DMA 0
	CreateByteField (ESSB, 0x01, DMAL) 	// DMA 0
// DMA 1
	CreateByteField (ESSB, 0x04, DMAH) 	// DMA 1
// IRQ
	CreateWordField (ESSB, 0x07, IRQL) 	// IRQ low

	Store(0x01,LDN)		// Select Appropriate LDN

// Get Audio range
	Store(IOAH, IOHI)
	Store(IOAL, IOLO)

	Store(IOHL, IORL)
// Get FM range
	If(FMAH) {}
	Else 	 { Store(0, FMLG) }

	Store(FMAH, FMHI)
	Store(FMAL, FMLO)
	Store(FMHL, FMRL)

// Get MPU range
	If(MPUS)
	{
	Store(0x03,LDN)		// Select LDN

	Store(IOAL, MPLO)
	If(ACTR) {}
	Else	{Store(0, MPLG)}

	Store(0x01,LDN)		// Select LDN
	}
	Else
	{
	If(MPAH) {}
	Else 	 {Store(0, MPLG)}

	Store(MPAL, MPLO)
	}
	Store(MPLO, MPRL)

	Store(One,Local0)
// Write Current Settings into IRQ descriptor
	ShiftLeft(Local0, INTR, IRQL)

// Write Current Settings into DMA 1 descriptor
	ShiftLeft(Local0, DMC0, DMAL)

// Write Current Settings into DMA 2 descriptor
	ShiftLeft(Local0, DMC1, DMAH)

	Return(ESSB)		// Return Buffer
	}			// End _CRS method

      Name(_PRS,

	ResourceTemplate()
	{
//--------Table---------
	StartDependentFn(0,0)
		{
	  DMA(Compatibility, NotBusMaster, Transfer8) {1}
	  DMA(Compatibility, NotBusMaster, Transfer8) {3}
	  IRQNoFlags() {5}
	  IO(Decode16, 0x220, 0x220, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 4, 4)	// FM synt
	  IO(Decode16, 0x330, 0x330, 0x10, 2)	// MPU401
		}
//--------1st Table---------
	StartDependentFn(1,1)
		{
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {5,7,10}
	  IO(Decode16, 0x220, 0x280, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 4, 4)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 2)	// MPU401
		}
//--------2nd Table---------no MPU401
	StartDependentFn(1,1)
		{
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {5,7,10}
	  IO(Decode16, 0x220, 0x280, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 4, 4)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 0)	// MPU401
		}
//--------3rd Table---------no FM synth
	StartDependentFn(1,1)
		{
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {5,7,10}
	  IO(Decode16, 0x220, 0x280, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 4, 0)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 2)	// MPU401
		}
//--------4th Table---------no MPU401 & FM
	StartDependentFn(1,1)
		{
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {5,7,10}
	  IO(Decode16, 0x220, 0x280, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 4, 0)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 0)	// MPU401
		}
	EndDependentFn()
	})

Method(_SRS,1){         // Set Resources
			// ARG0 = PnP Resource String to set
// Audio base
	CreateByteField (ARG0, 0x0b, IOLO)	// IO Port Low
	CreateByteField (ARG0, 0x0c, IOHI)	// IO Port Hi
	CreateWordField (ARG0, 0x0b, IOAD)	// Port address
	CreateByteField (ARG0, 0x0f, SIZE)	// Port Size
// FM Synthesizer
	CreateByteField (ARG0, 0x13, FMLO)	// FM Port Low
	CreateByteField (ARG0, 0x14, FMHI)	// FM Port Hi
	CreateByteField (ARG0, 0x18, FMLG) 	// FM length
// MPU401
	CreateByteField (ARG0, 0x1b, MPLO) 	// MPU Port Low
	CreateByteField (ARG0, 0x1c, MPHI) 	// MPU Port
	CreateWordField (ARG0, 0x1b, MPAD)	// Port address

	CreateByteField (ARG0, 0x20, MPLG) 	// MPU Lengh
// IRQ,DMA
	CreateWordField (ARG0, 0x7, IRQL) 	// IRQ low
	CreateByteField (ARG0, 0x1, DMAL) 	// DMA low
	CreateByteField (ARG0, 0x4, DMAH) 	// DMA Hi

	Store(0x01,LDN)		// Select Appropriate LDN

// Get Audio range
	Store(IOHI, IOAH)
	Store(IOLO, IOAL)
// Get FM range
	Store(0, FMAH)
	If(FMLG) {Store(FMHI, FMAH)}
	Store(FMLO, FMAL)
// Get MPU range
	If(MPUS) {
	Store(0x03,LDN)		// Select LDN

	Store(0, ACTR)
	If(MPLG) {Store(1, ACTR)}

	Store(MPHI, MPAH)
	Store(MPLO, MPAL)

	Store(0x01,LDN)		// Restore LDN
	}
	Else {
	Store(0, MPAH)
	If(MPLG) {Store(MPHI, MPAH)}
	Store(MPLO, MPAL)
	}

// Write Current Settings into DMA descriptor

	FindSetRightBit(DMAL, Local0)
	Subtract(Local0, 1, DMC0)

	// Route ISA DMA
	// Arg0      Device Category
	// Arg1      Route/Clear DMA monitoring
	// Arg2      DMA channel to route (1 based)
	rDMA(0x4, 0, Local0)

	FindSetRightBit(DMAH, Local0)
	Subtract(Local0, 1, DMC1)

	// Route 2nd DMA
	rDMA(0x4, 0, Local0)

// Write Current Settings into IRQ descriptor
	FindSetRightBit(IRQL, Local0)
	Subtract(Local0, 1, INTR)

// Route Audio port range 0x220-0x240
	// Arg0      Device Category
	// Arg1      0/1 Route/Release Mode
	// Arg2      Port to Route/Release
	// Arg3      Port SIZE to Route
	RRIO(0x4, 0x0, IOAD, SIZE)

	If(MPLG) {				// set MPU401 port base
//	Or (0x300,MPLO,Local0)
	// Route MPU-401 port
	RRIO(0x4, 0x0, MPAD, MPLG)
	} Else {}				// Disable MPU401

// Activate Audio
	Store(1, ACTR)
   }                                             // End of _SRS Method

//	Power control for ESS1869
/*
//-------------------------------------------------------------------------
	PowerResource(ESSP, 0, 0) {	// SystemLevel Parameter=0,
					// which means Audio can be turned off
					// in any sleep state
// Main control method for ESS Power controll
	Method(PWRC, 1)
	{

	Name(AUDD, 0x200)
// Audio base address detect
	Store(1, LDN)
	Or(AUDD, IOAL, AUDD)

OperationRegion (AUDB, SystemIO, AUDD, 0x10)
Field (	AUDB, ByteAcc, NoLock, Preserve )
	{
	Offset(0x7),
	,7,
	PWR7,1,
	Offset(0xA),
	RUNA,8,
	}
	If(LEqual(Arg0, 0))	// Return Status
		{
		Return(And(PWRM, 0x1))
		}
	If(LEqual(Arg0, 1))	// Power Off
		{
		Store(2, PWRM)
		Store(1, PWR7)	// Pulse High
		Store(0, PWR7)	// Pulse Low
		}
	If(LEqual(Arg0, 2))	// Power On
		{
		Store(3, PWRM)
		Store(RUNA, Local0)
		}

	}
	Method(_STA, 0) {
		Return(PWRC(0))
	}		      		// end of _STA

	Method(_ON) {			// Resume / working
		PWRC(2)
	}				// end of _ON

	Method(_OFF){			// Power down / suspend
	}				// end of _OFF
		PWRC(1)
	}				// end of Power Resource
//-------------------------------------------------------------------------


//	Name (_PR0, Package(){ESSP})                    // Power Resource

	Name(_PSC, 0)

	Method(_PS0) {	// full working
		ESSP._ON()
		Store(0,_PSC)
	}

	Method(_PS3) {  // power down , need to save registers context
		ESSP._OFF()
		Store(3,_PSC)
	}

*/
}                                                // End of Audio Device

