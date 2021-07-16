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
// $Header: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/AUDIO/ESS1878/JOYSTICK.ASL 10    7/28/98 10:11a Alexp $
//
// $Revision: 10 $
//
// $Date: 7/28/98 10:11a $
//**********************************************************************;
Device(JOY) {                                          // Joystick

	Name(_HID, EISAID("PNPB02F"))                  // PnP Device ID

	Method(_STA){

	If(JYST){}
	Else{
	Return(0)
	}

	Store(0x2, LDN)			// Select Appropriate LDN

	Store(0, Local0)

	If(\_SB.PCI0.DOCK._STA())	// Moon's ID  0x123b or 0x124b
	{Store(0x4, Local0)}		// should be shown in UI

	If(ACTR) {	  		// Read Activate Register
		Or(Local0, 0xb, Local0) }// Device Present/Active
	Else {
		Or(Local0, 0x9, Local0) }// Device Present/UnActive

	Return(Local0)
	}

	Method(_DIS){
	Store(0x2, LDN)			// Select Appropriate LDN
	Store(0, ACTR)			// deactivate LDN #0
	}

	Name(_CRS,                    // Current Resources

	ResourceTemplate()
	{
	IO(Decode16, 0x201, 0x201, 1, 1)
	})		              // End _CRS method

	Name(_PRS,                    // Possible Resources
	ResourceTemplate()
	{
	StartDependentFn(0,0)
	{
	IO(Decode16, 0x201, 0x201, 1, 1)
	}
	EndDependentFn()
	})		              // end of _PRS

	Method(_SRS,1){

	Store(0x02,LDN)		// Select Appropriate LDN

// Activate device
	Store(One,ACTR)		// Enable ACTR
	}	// end _SRS
}	// End JOY
