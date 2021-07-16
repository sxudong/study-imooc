Name (PSC, 0)	// Power state flag

Device(ES87) {  					// Audio drive

//	Name(_HID, EISAID("ESS0106"))                   // ESS1888 PnP Device ID
	Name(_HID, EISAID("ESS1882"))                   // ESS1887 PnP Device ID


	Method(_STA,0){		// Status of the Audio controller
				// is the device functioning?
				// read Audio Register 0x2xA
				// Return Device Present and Active
	IF(AUST)		//
      {
// Read the IRQ,DMA  ext registers to check if Audio is active or not
	SCMD(0xC6)                // #C6h command to read ext registers
	And(RDEX(0xB2),0x0C,Local0)  // read DMA control register #B2
	SCMD(0xC7)                // #C7h command to disable ext mode
	IF(Local0){Return(0xF)}   // device present/active/functioning properly
	     Else {Return(0xD)}   // device present/shown/not active
      }
	Else {Return(0)}         // Devise is not present

	}		        // End of _STA method

	Method(_DIS,0){		// Disable Audio

	SCMD(0xC6)                // #C6h command to read ext registers
	And(RDEX(0xB2),0xF3,Local0)  // Clear DMA settings in register #B2
	SCMD(0xC7)                // #C7h command to disable ext mode
// Add routing/release call
//	Store(0,UNLK)                           // UnLock ReConfig Port
//	Store(0,SCRG)				// set CE disable
//	Store(0,ALCK)                           // Lock ReConfig Port
// Add Release Audio resources from EIO Bus
	}			                // End of _DIS method


	Name(ESSB,
	ResourceTemplate()
	{
	  IO(Decode16, 0x220, 0x220, 0x20, 0x10, IOL1)	// Audio
	  IO(Decode16, 0x388, 0x388, 8, 0, IOL2)	// FM synt
	  IO(Decode16, 0x300, 0x300, 0x10, 0, IOL3)	// MPU401
	  IRQNoFlags(IRQA) {10}
	  DMA(Compatibility, NotBusMaster, Transfer8, DMAA) {00}
	  IRQNoFlags() {11}
	})

	Method(_CRS,0){                       // Current Resources

	IF(GETB())			// if Audio IO access enabled ?
      {
// Audio base
	CreateWordField (ESSB, 0x02, IOLO) // IO Port Low
	CreateWordField (ESSB, 0x04, IORL) // IO Port
// FM Synthesizer
	CreateByteField (ESSB, 0x0F, FMAL) // FM port length
// MPU401
	CreateByteField (ESSB, 0x12, IOLM) // IO Port Low
	CreateByteField (ESSB, 0x14, IOML) // IO Port
	CreateByteField (ESSB, 0x17, MPAL) // MPU401 port length
// IRQ,DMA
	CreateWordField (ESSB, 0x19, IRQL) // IRQ low
	CreateByteField (ESSB, 0x1c, DMAL) // DMA low

// Write current Audio base settings
	Store(GETB,IOLO)
	Store(IOLO,IORL)

	Store(MIX,Local0)

// Get current FM base settings from MIX Reg#40.0

	And(Local0, 0x1, Local1)
	If(Local1) {Store(4, FMAL)}

// Get current Midi base settings Reg#40.MPU port
	And(Local0, 0xE0, Local3)
	If(Local3)                          // test if is MPU401 off
      {
	ShiftLeft(Local0,0x1,Local1)
	And(Local1,0x30,Local0)
	Store(Local0,IOLM)
	Store(Local0,IOML)
	Store(0x2, MPAL)                  // MPU401 is on
      }

// Write current settings into IRQ descriptor
	SCMD(0xC6)                        // #C6h command to read ext registers
	Store(RDEX(0xB1),Local0)          // read IRQ control register #B1
	ShiftRight(Local0,0x2,Local1)
	And(Local1,0x3,Local0)

	IF(Lequal(Local0,0x0 )){ Store(0x200,IRQL) }   // IRQ 9
	IF(Lequal(Local0,0x1 )){ Store(0x20, IRQL) }   // IRQ 5
	IF(Lequal(Local0,0x2 )){ Store(0x80, IRQL) }   // IRQ 7
	IF(Lequal(Local0,0x3 )){ Store(0x400,IRQL) }   // IRQ 10

// Write current settings into DMA descriptor
	ShiftRight(RDEX(0xB2),0x2,Local1) // read DMA control register #B2
	And(Local1,0x3,Local0)

	IF(Lequal(Local0,0x1 )) { Store(0x1 ,DMAL) }    // DMA 0
	IF(Lequal(Local0,0x2 )) { Store(0x2, DMAL) }    // DMA 1
	IF(Lequal(Local0,0x3 )) { Store(0x8, DMAL) }    // DMA 3

	SCMD(0xC7)                         // #C7h command to disable ext mode

	}
	Return(ESSB)
   }                                       // End of _CRS method


      Name(_PRS,

	ResourceTemplate()
	{
//--------1st Table---------
	StartDependentFn(0,0)
		{
	  IO(Decode16, 0x220, 0x220, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 8, 4)	// FM synt
	  IO(Decode16, 0x300, 0x300, 0x10, 2)	// MPU401
	  IRQNoFlags() {5}
	  DMA(Compatibility, NotBusMaster, Transfer8) {1}
	  IRQNoFlags() {11}
		}
	StartDependentFn(1,1)
		{
	  IO(Decode16, 0x220, 0x240, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 8, 4)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 2)	// MPU401
	  IRQNoFlags() {5,7,10}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {11}
		}
//--------2nd Table---------no MPU401
	StartDependentFn(1,1)
		{
	  IO(Decode16, 0x220, 0x240, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 8, 4)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 0)	// MPU401
	  IRQNoFlags() {5,7,10}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {11}
		}
//--------3rd Table---------no FM synth
	StartDependentFn(1,1)
		{
	  IO(Decode16, 0x220, 0x240, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 8, 0)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 2)	// MPU401
	  IRQNoFlags() {5,7,10}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {11}
		}
//--------4th Table---------no MPU401 & FM
	StartDependentFn(1,1)
		{
	  IO(Decode16, 0x220, 0x240, 0x20, 0x10)// Audio
	  IO(Decode16, 0x388, 0x388, 8, 0)	// FM synt
	  IO(Decode16, 0x300, 0x330, 0x10, 0)	// MPU401
	  IRQNoFlags() {5,7,10}
	  DMA(Compatibility, NotBusMaster, Transfer8) {0,1,3}
	  IRQNoFlags() {11}
		}
	EndDependentFn()
	})

Method(_SRS,1){         // Set Resources
			// ARG0 = PnP Resource String to set

	CreateWordField (ARG0, 0x02, IOLO) // IO Base Address port
	CreateByteField (ARG0, 0x0F, FMAL) // FM port size
	CreateByteField (ARG0, 0x12, IOLM) // IO MPU401 Port
	CreateByteField (ARG0, 0x17, MPAL) // MPU401 port size
	CreateWordField (ARG0, 0x19, IRQL) // IRQ low
	CreateByteField (ARG0, 0x1c, DMAL) // DMA low

// add here routing/release call

	Store(0,UNLK)                           // UnLock ReConfig Port
	IF(Lequal(IOLO,0x220)) {Store(4,SCRG)}  // for 220 Base
				ELSE {Store(6,SCRG)} // for 240 Base
	Store(0,ALCK)                           // Lock access to Base
						// ReConfig Area
// Route Audio port range 0x220-0x240
	// Arg0      Device Category
	// Arg1      0/1 Route/Release Mode
	// Arg2      Port to Route/Release
	// Arg3      Port SIZE to Route
//	CreateByteField (ARG0, 0x06, SIZE)  // Port Size
//	RRIO(0x4, 0x0, IOLO, SIZE)

// Write current MPU401 IRQ settings #40.5-7
// Write current MPU401 base addr settings #40.3-4
// Write current FM base settings into Reg #40.0

	And(MIX, 0x2, Local0)			// remove old MPU401 and FM

	If(FMAL) {				// set FM if present
	Or (Local0, 0x1,  Local0)
	// Route FM synth port
//	RRIO(0x4, 0x0, 0x388, FMAL)
	} Else {}				// Disable FM

	If(MPAL) {				// set MPU401 port base
	ShiftRight(IOLM,0x1,Local1)
	Or (Local0,Local1,Local0)
	// Route MPU-401 port
	Or (IOLM, 0x300,  Local1)
	RRIO(0x4, 0x0, Local1, MPAL)
	} Else {}				// Disable MPU401

	 Store(Local0, MIX)                    // Store new value into MIX

//-------------------------------------------------------//
// 	Write current settings into IRQ Register #B1h    //
//-------------------------------------------------------//

	 IF(Lequal(IRQL,0x200)){Store(0x90,Local2)}        // IRQ 9
	 IF(Lequal(IRQL,0x20 )){Store(0x94,Local2)}        // IRQ 5
	 IF(Lequal(IRQL,0x80 )){Store(0x98,Local2)}        // IRQ 7
	 IF(Lequal(IRQL,0x400)){Store(0x9C,Local2)}        // IRQ 10
	 SCMD(0xC6)                              // send #C6h command
						 // to access ext registers
	 WREX(0xB1,Local2)
//-------------------------------------------------------//
// 	Write current settings into DMA Register #B2h    //
//-------------------------------------------------------//
	IF(Lequal(DMAL,0x1)){Store(0x0B4,Local2)}           // DMA 0
	IF(Lequal(DMAL,0x2)){Store(0x0B8,Local2)}           // DMA 1
	IF(Lequal(DMAL,0x8)){Store(0x0BC,Local2)}           // DMA 3
//	SCMD(0xC6)                               // send #C6h command
						 // to access ext registers
	WREX(0xB2,Local2)
	SCMD(0xC7)                               // #C7h command to disable ext mode
//-------------------------------------------------------//
//      Route/Release new resources to EIO bus           //
//-------------------------------------------------------//
// Route ISA DMA
	// Arg0      Device Category
	// Arg1      Route/Clear DMA monitoring
	// Arg2      DMA channel to route (1 based)
	FindSetRightBit(DMAL, Local0)
	rDMA(0x4, 0, Local0 )

   }                                             // End of _SRS Method
//	Power control for ESS1887

	Name (_PR0, Package(){ESSP})                    // Power Resource
//	Name (_PR1, Package(){ESSP})                    // Power Resource
//	Name (_PR2, Package(){ESSP})                    // Power Resource

	Method(_PS0) {	// full working
//	ESSP._ON()
	Store(0,PSC)
	}

	Method(_PS3) {  // power down , need to save registers context
//	ESSP._OFF()
	Store(3,PSC)
	}

	Method(_PSC) { Return(PSC) }
}                                                // End of Audio Device

