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
// $Header: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/AUDIO/ESS1888/ESSTUFF.ASL 10    7/28/98 10:11a Alexp $
//
// $Revision: 10 $
//
// $Date: 7/28/98 10:11a $
//**********************************************************************;
//**********************************************************************;
// Revision History
// ----------------
// $Log: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/AUDIO/ESS1888/ESSTUFF.ASL $
// 
// 10    7/28/98 10:11a Alexp
// 
// 9     7/20/98 3:57p Alexp
// 
// 8     7/01/98 9:43p Alexp
// 
// 7     6/18/98 5:51p Alexp
// 
// 6     6/09/98 5:20p Alexp
// 
// 5     5/27/98 5:31p Alexp
// 
// 4     4/09/98 5:30p Alexp
// Get latest updates of all library ASL files
// 
// 1     3/13/98 6:08p Alexp
// Main ASL code library
// 
// 1     3/09/98 7:16p Alexp
// All generic include files 
// 
// 1     9/02/97 5:16p Alexp
// 
// 4     7/10/97 11:12a Alexp
// 
// 3     5/20/97 11:08a Alexp
// Updated _STA metods for all NAT338 devices
// 
//**********************************************************************;
// Routines to support access to TESS1888 configurations registers

//-------------------------------------------------------------------------
	PowerResource(ESSP, 0, 0) {       // SystemLevel Parameter=0,
					  // which means Audio can be turned off
					  // in any sleep state
	Method(_STA, 0) {

	If(And(PWR6,0x8))
		{Return(1)}		// Get Power Status
	Else {Return(0)}		// If Audio not present, Return 0
	}				// end of _STA

	Method(_ON) {

	Store(EXRA,Local0)		// Wake up the Audio
					// Read any Audio port exept
					// 2x6h,2x7h
	}				// end of _ON

 Method(_OFF){

	If(And(PWR6,0x1))		// If ESS is being held in reset
	       {Store(0x1, PWR6)}	// we have to release reset before
					// go to power down
	Sleep(1)			// 1 msec delay

/*	If(And(PWR6,0x4))		// If ESS is in the MIDI serial
					// interface mode it's better to
					// let him finish, so to do nothing
					// and Return
	       {Return(0)}
*/
	Or(PWR7, 0x8, PWR7)		// Set bit 3 high
					// Analog part stays on

//	And(PWR7, 0xE7, PWR7)		// Clear Analog Power bit
					// and pulsing bit 2, first high,
					// then low
	Or(PWR7, 0x4, PWR7)
	And(PWR7, 0xFB, PWR7)
	}				// end of _OFF

	}				// end of Power Resource
//-------------------------------------------------------------------------
/*
Method(DSBL,0){         // Reset/Disable the Audio controller

      If(GETB()){                         // If Audio is present

	Store(One,PWR6)
	Store(Zero,PWR6)
	Store(100,Local7)
 While(Local7){
	Decrement(Local7)
	Store(EXRE,Local0)
	IF(And(Local0,0x80)) { Store(EXRA,Local1)
			    IF(LEQual(Local1,0xAA))
				{Store(Zero,Local7)}
			     }
	      }                          // end of While
      }
     Else { Return(0)}                  // if Audio is not present
}                                        // End of DSBL Method
*/
Method(WRMX,1)  {                        // Write to ESS mixer
					 // on Enter ARG0.0 - Data to write
	Store(Arg0,MIX)
}                                        // End of WRMX Method

Method(RDMX,0){                          // Read from ESS mixer
					 // on Enter - nothing
	Return(MIX)                      // on Exit - Reg data
}                                        // End of RDMX Method

Method(WREX,2){                          // Write to ESS extension registers
					 // on Enter Arg0 - Reg number
					 //          Arg1 - Data to write
	Store(Arg1,Local1)
	SCMD(Arg0)                       // send the REG to write to
	SCMD(Local1)                     // send the DATA to send to
}                                        // End of WREX Method

Method(RDEX,1){                          // Read from ESS extension registers
					 // on Enter Arg0 - Reg number
	Store(Arg0,Local0)
	SCMD(0xC0)                       // send command to read the REG
	SCMD(Local0)                     // send the REG number to read
					 // read the data from ext REG
	Return(RDDT())                   // Exit          - Reg data
}                                        // End of RDEX Method

Method(SCMD,1){                          // Send to ESS registers command/data
					 // on Enter Arg0 - Command/Data
					 // to send to
	 Store(100,Local7)
	 While(Local7){
		IF(And(EXRC,0x80)) {
			Decrement(Local7)
			}
		Else {
			Store(Zero,Local7)
			}
	}
//        Sleep(1)                        // wait for a 1 ms
	Store(Arg0,EXRC)
}                                        // End of SCMD Method

Method(RDDT,0){                          // Read data from ESS registers
					 // on Enter - nothing
	 Store(100,Local7)
	 While(Local7){
		Decrement(Local7)
		IF(And(EXRE,0x80)) {
			Store(Zero,Local7)
				}
       }
//     Sleep(1)                          // wait for a 1 ms
     Return(EXRA)
}                                        // End of RDEX Method

