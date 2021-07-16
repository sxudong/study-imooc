// ------------------------------------------------------------------------
//	System Indication object scope
// ------------------------------------------------------------------------
// Names defined in AMI.ASL:
//	LEDW - Working state LED control field 
//	STDY - LED light mode controll field (Steady/Blink)
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
Store("SST", Debug)
Store(Arg0, Debug)
	If(Arg0) {
	//      = 1 - Working
	If(LEqual(Arg0,1)) {
		Store(STDY, BLNK)	// 	Steady Green
		Store(LDON, LEDW)
	}
	//      = 2 - Waking
	If(LEqual(Arg0,2)) {
		Store(LDON, LEDW)	// 	Blinking Green
	}
	//      = 3 - Sleeping (S1,S2,S3)
	If(LEqual(Arg0,3)) {
		Store(STDY, BLNK)	//	Steady Yellow
//		Xor(STDY, 1, BLNK)	// 	Blinking Yellow
		Xor(LDON, 1, LEDW)
	}
	//      = 4 - Sleeping (S4)
 	If(LEqual(Arg0,4)) {
		Store(STDY, BLNK)	// 	Steady Yellow
		Xor(LDON, 1, LEDW)
	}
	//	= 0 - No system state indication (indicator off)
	}
	Else {
		Store(STDY, BLNK)	// 	Steady Yellow
		Xor(LDON, 1, LEDW)
//		Store(LDON, LEDW)
	}
	}

// Message waiting status indicator
	Method(_MSG, 1)
	{
	//  Arg0 = # of messages waiting
Store("MSG", Debug)
Store(Arg0, Debug)
	If(Arg0) {
		Xor(STDY, 1, BLNK)
		}
	Else {
		Store(STDY, BLNK)
		}
	}
}		// end SI
