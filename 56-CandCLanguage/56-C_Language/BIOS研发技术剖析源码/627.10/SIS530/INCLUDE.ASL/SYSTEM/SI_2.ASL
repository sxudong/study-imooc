// ------------------------------------------------------------------------
//	System Indication object scope
// ------------------------------------------------------------------------
// Names defined in AMI.ASL:
//	LEDW - Working state LED control field 
//	LEDS - Sleep state LED control field
//	LDON - value to be written to LED control field
//		 to reflect the System in a Working state 
// ------------------------------------------------------------------------

Scope(\_SI) {
// System status indicator
	Method(_SST, 1)
	{
	//  Arg0 = 0 - No system state indication (indicator off)
	//       = 1 - Working
	//       = 2 - Waking
	//       = 3 - Sleeping (S1,S2,S3)
	//       = 4 - Sleeping (S4)
	If(Arg0) {
//      = 1 - Working
	If(LEqual(Arg0,1)) {
		Store(WKON, LEDW)
		Xor(SPON,1, LEDS)
	}
//      = 2 - Waking
	If(LEqual(Arg0,2)) {
		Store(WKON, LEDW)
	}
//      = 3 - Sleeping (S1,S2,S3)
	If(LEqual(Arg0,3)) {
		Xor(WKON,1, LEDW)
		Store(SPON, LEDS)
	}
//      = 4 - Sleeping (S4)
	If(LEqual(Arg0,4)) {
		Store(WKON, LEDW)
		Store(SPON, LEDS)
	}
//  	= 0 - No system state indication (indicator off)
	}	Else {
		Xor(WKON,1, LEDS)
		Xor(SPON,1, LEDW)
		}
	}

// Message waiting status indicator
	Method(_MSG, 1)
	{
	//  Arg0 = number of messages waiting
	NoOp
	}
}		// end SI
