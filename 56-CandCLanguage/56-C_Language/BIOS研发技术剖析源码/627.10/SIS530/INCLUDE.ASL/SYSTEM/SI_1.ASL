// ------------------------------------------------------------------------
//	System Indication object scope
// ------------------------------------------------------------------------
// Names defined in AMI.ASL:
//	LEDW - LED control field
//	LDON - value to be written to LED control field
//		 to reflect the System in a Working state
// ------------------------------------------------------------------------

Scope(_SI) {

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
		Store(LDON, LEDW)
	}
//      = 2 - Waking
	If(LEqual(Arg0,2)) {
		Store(LDON, LEDW)
	}
//      = 3 - Sleeping (S1,S2,S3)
	If(LEqual(Arg0,3)) {
		Xor(LDON,1, LEDW)
	}
//      = 4 - Sleeping (S4)
	If(LEqual(Arg0,4)) {
		Xor(LDON,1, LEDW)
	}
//  	= 0 - No system state indication (indicator off)
	}	Else {
		Xor(LDON,1, LEDW)
		}
	}

// Message waiting status indicator
	Method(_MSG, 1)
	{
	//  Arg0 = number of messages waiting
	NoOp
	}
}		// end SI
