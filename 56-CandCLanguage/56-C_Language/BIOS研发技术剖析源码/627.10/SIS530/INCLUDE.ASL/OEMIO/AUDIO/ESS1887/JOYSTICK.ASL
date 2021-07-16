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
// $Header: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/AUDIO/ESS1887/JOYSTICK.ASL 10    7/28/98 10:11a Alexp $
//
// $Revision: 10 $
//
// $Date: 7/28/98 10:11a $
//**********************************************************************;
//**********************************************************************;
// Revision History
// ----------------
// $Log: /BIOS/PORTING/ALEXP/INCLUDE.ASL/OEMIO/AUDIO/ESS1887/JOYSTICK.ASL $
// 
// 10    7/28/98 10:11a Alexp
// 
// 9     7/20/98 3:56p Alexp
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
// 6     7/10/97 11:13a Alexp
// 
// 5     6/11/97 5:54p Alexp
// Resource descriptors were changed with macro
// 
// 4     6/03/97 11:49a Alexp
// DKID device ID being added
//
// 3     5/20/97 11:08a Alexp
// Updated _STA metods for all NAT338 devices
//
//**********************************************************************;
Device(JOY) {                                          // Joystick

	Name(_HID, EISAID("PNPB02F"))                  // PnP Device ID

  Method(_STA,0){               // Joystick Status
				// is the device functioning?
				// read Audio Register #2xA
				// Return Device Present and device Active

	Store(0, Local0)	// Local0 init

	If(\_SB.PCI0.DOCK._STA())	// Moon's ID  0x123b or 0x124b
	{Store(0x4, Local0)}		// should be shown in UI

	IF(JYST)			// Define the base address of AUDIO device
	{
	If(And(RDMX(),0x2))	    // Read the MIXER Ext Register bit #40.1
	{
		Or(Local0, 0xb, Local0) }// Device Present/Active
	Else {
		Or(Local0, 0x9, Local0) }// Device Present/UnActive
	}
	Else {
		Return(0) }		// Device Not Present

	Return(Local0)
	}				// End of _STA method

	Method(_DIS) {			// Disable Method

	And(RDMX(),0xFD,Local0)
	WRMX(Local0)
	}				// End of _DIS Method


  Name(_CRS,                    // Current Resources

	ResourceTemplate()
	{
	  IO(Decode16, 0x201, 0x201, 1, 1)
	}
			)              // End _CRS method

  Name(_PRS,                    // Possible Resources
	ResourceTemplate()
	{
	  StartDependentFn(1,1)
	  {
	  IO(Decode16, 0x201, 0x201, 1, 1)
	  }
	  EndDependentFn()
	}
			)              // end of _PRS

Method(_SRS,1){                         // Set Resource

// Write current FM base settings into Reg#40.FM bit
		Or(RDMX(),0x2,Local0)
		WRMX(Local0)

		}       // End of _SRS Method
}                       // End of Joystick

