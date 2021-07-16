//-------------------- PCI Bus Master IDE Controller -------------------------

	OperationRegion(CFG1, PCI_Config, 0x40, 0x10)
	Field(CFG1,DWordAcc,NoLock,Preserve){
		,1,		// Primary channel
		PRD0,1,		// Drive 0 IORDY sampling mode
		,1,
		PDM0,1,		// Drive 0 DMA timing mode
		,1,
		PRD1,1,		// Drive 1 IORDY sampling mode
		,1,
		PDM1,1,		// Drive 1 DMA timing mode
//	0x41
		PDET,6,		// Primary Device 0 IDE Timing Register
		PSEN,1,		// Slave IDE timing for Primary channel enable
		,1,
//	0x42                    Secondary channel
                ,1,
		SRD0,1,		// Drive 0 IORDY sampling mode
		,1,
		SDM0,1,		// Drive 0 DMA timing mode
		,1,
		SRD1,1,		// Drive 1 IORDY sampling mode
		,1,
		SDM1,1,		// Drive 1 DMA timing mode
//	0x43
		SDET,6,		// Secondary Device 0
		SSEN,1,		// Slave IDE timing for Secondary channel enable
		,1,
//	0x44			Slave IDE timing
		PIDT,4,		// Primary Device 1 IDE Timing
		SIDT,4,		// Secondary Device 1
                Offset(0x08),
//      0x48			 Ultra DMA/33 control
		DCP0,1,         // Primary, Drive 0 SDMA mode
		DCP1,1,		// Primary, Drive 0 SDMA mode
		DCS0,1,		// Secondary, Drive 0 SDMA mode
		DCS1,1,		// Secondary, Drive 1 SDMA mode
		,4,
		Offset(0x0a),
// 	0x4A			Ultra DMA/33 timing
		DTP0,2,		// DMA timings for Primary Drive 0
                ,2,
		DTP1,2,		// DMA timings for Primary Drive 1
                ,2,
		DTS0,2,		// DMA timings for Secondary Drive 0
                ,2,
		DTS1,2,		// DMA timings for Secondary Drive 1
	}

	Name(\PSCP,0)		// Current Power state for IDE controller
// PowerResources for IDE Primary channel
// control code applies for Trajan board only
	PowerResource(\IDEP, 0, 0){		// SystemLevel Parameter=0,
						// which means HDD can be turned off
						// in any sleep state

	Method(_STA, 0){
	Return(PSCP)
//		Return(Xor(HPW0, One))          // Get Power Status
		}                               // End of _STA

	Method(_ON){
		NoOp
//		Store(Zero, HPW0)               // Apply Power
//		Sleep(10)
//		Store(One, HRS0)                // Pulse Reset
//		Stall(10)
//		Store(Zero, HRS0)
		}                               // End of _ON

	Method(_OFF){
		NoOp
//		Store(One, HPW0)                // Cut Power
		}                               // End of _OFF

	}                                       // End of Power Resource

// PowerResources for IDE Secondary channel
	PowerResource(\IDES, 0, 0){		// SystemLevel Parameter=0,
						// which means HDD can be turned off
						// in any sleep state

	Method(_STA, 0){
	Return(PSCP)
//		Return(Xor(HPW1, One))          // Get Power Status
		}                               // End of _STA

	Method(_ON){
		NoOp
//		Store(Zero, HPW1)               // Apply Power
//		Sleep(10)
//		Store(One, HRS1)                // Pulse Reset
//		Stall(10)
//		Store(Zero, HRS1)
		}                               // End of _ON

	Method(_OFF){
		NoOp
//		Store(One, HPW1)                // Cut Power
		}                               // End of _OFF

	}                                       // End of Power Resource

// PIIX4 Function 1 IDE Controller

// Set of ATA commands to send to IDE drive
	Name(GT00, Buffer(57){7})
//	Name(GT01, Buffer(57){7})
//	Name(GT10, Buffer(57){7})
//	Name(GT11, Buffer(57){7})
/*
	Buffer(0x82){
	0x40,0x00,0x22,0x0e,0x00,0x00,0x0f,0x00,0x00,0x00,0x00,0x00,0x3f,0x00
	0x31,0x30,0x38,0x31,0x00,0x00,0x32,0x52,0x37,0x30,0x37,0x33,0x41,0x50
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x03,0x00
	0x00,0x02,0x14,0x00,0x41,0x54,0x58,0x56,0x32,0x33,0x32,0x32,0x61,0x4d
	0x74,0x78,0x72,0x6f,0x38,0x20,0x37,0x31,0x30,0x35,0x32,0x44,0x20,0x20
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x10,0x80,0x00,0x00
	0x00,0x2f,0x00,0x00,0x00,0x02,0x00,0x02,0x07,0x00,0x22,0x0e,0x0f,0x00
	0x3f,0x00,0x82,0x2b,0x34,0x00,0x10,0x01,0x48,0x2e,0x34,0x00,0x00,0x00
	0x07,0x00,0x03,0x00}
*/

/*
CreateField(GT00,   0, 56, CMD0)
CreateField(GT00,  56, 56, CMD1)
CreateField(GT00, 112, 56, CMD2)
CreateField(GT00, 168, 56, CMD3)
CreateField(GT00, 224, 56, CMD4)
CreateField(GT00, 280, 56, CMD5)
CreateField(GT00, 336, 56, CMD6)
CreateField(GT00, 392, 56, CMD7)
*/

// Timings package for Primary / Secondary channels

	Name(TIM0, Package() {		// Primary / Secondary channels timings
	Package(){120, 180, 240, 380},	// Timings in ns (PIO 4, 3, 2, 1)
	Package(){0x23,0x21,0x10, 0},	// Primary / Secondary Master
	Package(){0x0b,0x09,0x04, 0},	// Primary / Secondary Slave
	Package(){120, 80, 60, 30},	// DMA Timings in ns
	})


	Name(TMD0, Buffer(20){})	// 5 DWORD length
	CreateDWordField(TMD0, 00, PIO0)
	CreateDWordField(TMD0, 04, DMA0)
	CreateDWordField(TMD0, 8,  PIO1)		// do not use "08"
	CreateDWordField(TMD0, 12, DMA1)
	CreateDWordField(TMD0, 16, FLAG)



// Primary channel of IDE controller

	Device(CHN0)
	{
	Name(_ADR,0)
	Name(_PR0,Package(){IDEP})

	Method(_PS0,0){		// D0
	\IDEP._ON()
	Store(0,PSCP)
	}

	Method(_PS3,0){		// D3
	\IDEP._OFF()
	Store(3,PSCP)
	}

	Method(_PSC,0){		// Return power state
	Return(PSCP)
	}


	Method(_GTM,0 ) {	// Get Timing PIO/DMA Mode
				// Return Buffer
				// PIO 0 Speed DWORD
				// DMA 0 Speed DWORD
				// PIO 1 Speed DWORD
				// DMA 1 Speed DWORD
				// Flags
	Store(Ones, PIO0)	// Preset the return values
	Store(Ones, PIO1)	// Preset the return values
	Store(Ones, DMA0)	// Preset the return values
	Store(Ones, DMA1)	// Preset the return values
	Store(Zero, FLAG)	// Preset the return values

// PIO mode for Primary channel
	If(PRD0)
	{
// IOChannelReady is used
	Or(FLAG, 0x2, FLAG)		// Set IOChannelReady flag
// Drive 0
	And (PDET, 0x33, local0)	// Read Current value of reg 40-41
	Store(Match(DeRefOf(Index(TIM0, 1)), MEQ, Local0, MTR,0,0), Local7)
	If(Not(Local7)) {
	Store(DeRefOf(Index(DeReFof(Index(TIM0, 0)), Local7)), PIO0)
			}
		Else {
		XOr(FLAG, 0x2, FLAG)	// ReSet IOChannelReady flag 
			}
	}
	If(PRD1)
	{
// IOChannelReady is used
	Or(FLAG, 0x8, FLAG)		// Set IOChannelReady flag
// Drive 1
	If(PSEN)
	{
// if the timings for Drive 1 may be set independantly
	Or(FLAG, 0x10, FLAG)
	Store(Match(DeRefOf(Index(TIM0, 2)), MEQ, PIDT, MTR,0,0), Local7)
		If(Not(Local7)) {
			Store(DeRefOf(Index(DeReFof(Index(TIM0, 0)), Local7)), PIO1)
			}
		Else {
			Xor(FLAG, 0x10, FLAG)
			XOr(FLAG, 0x8, FLAG)	// ReSet IOChannelReady flag
                        }
		}
        }
// DMA timings for
// Drive 0
	If(DCP0){ 
// if UltraDMA enabled
	Store(DeRefOf(Index(DeReFof(Index(TIM0, 3)), DTP0)), DMA0)
	Or(FLAG, 0x1, FLAG)     	// using UltraDMA on drive 0
	}
// Drive 1
	If(DCP1){
// if UltraDMA enabled
	Store(DeRefOf(Index(DeReFof(Index(TIM0, 3)), DTP1)), DMA1)
	Or(FLAG, 0x4, FLAG)       	// using UltraDMA on drive 1
	}

Store(TMD0, Debug)

	Return(TMD0)
	}

	Method(_STM, 3) {	// Set Timing PIO/DMA Mode
				// Channel Timing Info (Package)
				// Arg 1 = ATA Command set Primary (Buffer)
				// Arg 2 = ATA Command set Slave (Buffer)

Store(TMD0, Debug)

	Store(Arg0, TMD0)	// Copy Arg0 into TMD0 buffer

Store(TMD0, Debug)


// Set IO timings for Primary channel
// Drive 0

	Store(0, PRD0)	// assume IOChannelReady for Drive 0 is not used
	Store(0, PRD1)	// assume IOChannelReady for Drive 1 is not used
	Store(0, PSEN)	// Assume Drive 1 timings cannot be set independantly

	If(And(And(FLAG, 0x2), Not(PIO0)))	// Drive 0 is present
	{
	Store(1, PRD0)
// set real timings
		Store(Match(DeRefOf(Index(TIM0, 0)), MEQ, PIO0, MTR,0,0), Local7)
		If(Not(Local7)) {
		Or(PDET, DeRefOf(Index(DeReFof(Index(TIM0, 1)), Local7)), PDET)
                		}
	}
// Drive 1
	If(And(FLAG, 0x8))	// Drive 1 is present
       	{
	Store(1, PRD1)
		If(And(And(FLAG, 0x10), Not(PIO1)))
// if the timings for Drive 1 should be set independantly
			{
			Store(1, PSEN)
			Store(Match(DeRefOf(Index(TIM0, 0)), MEQ, PIO1, MTR,0,0), Local7)
			If(Not(Local7)) {
			Store(DeRefOf(Index(DeReFof(Index(TIM0, 2)), Local7)), PIDT)
					}
			}
	}

// Set DMA 

	Store(0, DCP0)	// Assume there is no UltraDMA
	Store(0, DCP1)	// Assume there is no UltraDMA
// Drive 0
	If(And(And(FLAG, 0x1), Not(DMA0)))
        {
		Store(1, DCP0)	// enable UltraDMA for Device 0
		Store(Match(DeRefOf(Index(TIM0, 3)), MEQ, DMA0, MTR,0,0), DTP0)
	}
// Drive 1
	If(And(And(FLAG, 0x4), Not(DMA1)))
	{
		Store(1, DCP1)	// enable UltraDMA for Device 1
		Store(Match(DeRefOf(Index(TIM0, 3)), MEQ, DMA1, MTR,0,0), DTP1)
	}

// do something with Arg1,2 ?????
// convert Arg1,2 here and update ATA set of command here
	} // end Method _STM

	Device(DRV0)		// Primary Master
		{
		Name(_ADR, 0)
		Method(_GTF,0 ) {
		Return(GT00)
		}
		}
	Device(DRV1)            // Primary Slave
		{
		Name(_ADR, 1)
		Method(_GTF,0 ) {
		Return(GT00)
		}
		}

}				// end CHN0 Primary Channel

// Secondary Channel of IDE controller

	Name(\PSCS,0)		// Current Power state

	Device(CHN1)
	{
	Name(_ADR,1)
	Name(_PR0,Package(){IDES})

	Method(_PS0,0){		// D0
	\IDES._ON()
	Store(0,PSCS)
	}

	Method(_PS3,0){		// D3
	\IDES._OFF()
	Store(3,PSCS)
	}

	Method(_PSC,0){		// Return power state
	Return(PSCS)
	}

	Method(_GTM,0 ) {	// Get Timing PIO/DMA Mode

				// Return Buffer
				// PIO 0 Speed DWORD
				// DMA 0 Speed DWORD
				// PIO 1 Speed DWORD
				// DMA 1 Speed DWORD
				// Flags
	Store(Ones, PIO0)	// Preset the return values
	Store(Ones, PIO1)	// Preset the return values
	Store(Ones, DMA0)	// Preset the return values
	Store(Ones, DMA1)	// Preset the return values
	Store(Zero, FLAG)	// Preset the return values

// PIO mode for Primary channel
	If(SRD0)
	{
// IOChannelReady is used
		Or(FLAG, 0x2, FLAG)	// Set IOChannelReady flag
// Drive 0
		And (SDET, 0x33, local0)// Read Current value of reg 42-43
		Store(Match(DeRefOf(Index(TIM0, 1)), MEQ, Local0, MTR,0,0), Local7)
		If(Not(Local7)) {
			Store(DeRefOf(Index(DeReFof(Index(TIM0, 0)), Local7)), PIO0)
				}
		Else {
			XOr(FLAG, 0x2, FLAG)	// ReSet IOChannelReady flag
                        }
	}
	If(SRD1)
	{
// IOChannelReady is used
	Or(FLAG, 0x8, FLAG)	// Set IOChannelReady flag
// Drive 1
		If(SSEN)
		{
// if the timings for Drive 1 may be set independantly
		Or(FLAG, 0x10, FLAG)
		Store(Match(DeRefOf(Index(TIM0, 2)), MEQ, SIDT, MTR,0,0), Local7)
		If(Not(Local7)) {
			Store(DeRefOf(Index(DeReFof(Index(TIM0, 0)), Local7)), PIO1)
			}
		Else {
			Xor(FLAG, 0x10, FLAG)
			XOr(FLAG, 0x8, FLAG)	// ReSet IOChannelReady flag 
                        }
		}
	}
// DMA timings for
// Drive 0
	If(DCS0){
// if UltraDMA enabled
	Store(DeRefOf(Index(DeReFof(Index(TIM0, 3)), DTS0)), DMA0)
	Or(FLAG, 0x1, FLAG)     	// using UltraDMA on drive 0
	}
// Drive 1
	If(DCS1){
// if UltraDMA enabled
	Store(DeRefOf(Index(DeReFof(Index(TIM0, 3)), DTS1)), DMA1)
	Or(FLAG, 0x4, FLAG)     	// using UltraDMA on drive 1
	}

	Return(TMD0)
	}

	Method(_STM, 3) {	// Set Timing PIO/DMA Mode
				// Channel Timing Info (Package)
				// Arg 1 = ATA Command set Primary (Buffer)
				// Arg 2 = ATA Command set Slave (Buffer)

Store(Arg0, Debug)
Store(Arg1, Debug)
Store(Arg2, Debug)

	Store(Arg0, TMD0)	// Copy Arg0 into TMD0 buffer

// Set IO timings for Primary channel
// Drive 0

	Store(0, SRD0)	// assume IOChannelReady for Drive 0 is not used
	Store(0, SRD1)	// assume IOChannelReady for Drive 1 is not used
	Store(0, SSEN)	// Assume Drive 1 timings cannot be set independantly

	If(And(And(FLAG, 0x2), Not(PIO0)))	// Drive 0 is present
	{
	Store(1, SRD0)
// set real timings
		Store(Match(DeRefOf(Index(TIM0, 0)), MEQ, PIO0, MTR,0,0), Local7)
		If(Not(Local7)) {
		Or(SDET, DeRefOf(Index(DeReFof(Index(TIM0, 1)), Local7)), SDET)
                		}
	}
// Drive 1
	If(And(FLAG, 0x8))	// Drive 1 is present
       	{
	Store(1, SRD1)
		If(And(And(FLAG, 0x10), Not(PIO1)))
// if the timings for Drive 1 should be set independantly
			{
			Store(1, SSEN)
			Store(Match(DeRefOf(Index(TIM0, 0)), MEQ, PIO1, MTR,0,0), Local7)
			If(Not(Local7)) {
			Store(DeRefOf(Index(DeReFof(Index(TIM0, 2)), Local7)), SIDT)
					}
			}
	}

// Set DMA 
	Store(0, DCS0)	// Assume there is no UltraDMA
	Store(0, DCS1)	// Assume there is no UltraDMA
// Drive 0
	If(And(And(FLAG, 0x1), Not(DMA0)))
	{
		Store(1, DCS0)			// enable UltraDMA for Device 0
		Store(Match(DeRefOf(Index(TIM0, 3)), MEQ, DMA0, MTR,0,0), DTP0)
	}
// Drive 1
	If(And(And(FLAG, 0x4), Not(DMA1)))
	{
		Store(1, DCS1)			// enable UltraDMA for Device 1
		Store(Match(DeRefOf(Index(TIM0, 3)), MEQ, DMA1, MTR,0,0), DTP1)
	}

// do something with Arg1,2 ?????
// convert Arg1,2 here and update ATA set of command here
	} // end Method _STM


	Device(DRV0)		// Secondary Master
		{
		Name(_ADR, 0)
		Method(_GTF,0 ) {
		Return(GT00)
//		Return(GT10)
		}
		}
	Device(DRV1)            // Secondary  Slave
		{
		Name(_ADR, 1)
		Method(_GTF,0 ) {
		Return(GT00)
//		Return(GT11)
		}
		}

		}		// end CHN1 Secondary Channel

