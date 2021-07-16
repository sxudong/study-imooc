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
//		DON'T CHANGE ANY CODE UNLESS REQUIRED !!!
//**********************************************************************;
//**********************************************************************;
// 		PIIX4 SMB interface methods
//**********************************************************************;

	Field(SMB0,ByteAcc,NoLock,Preserve){

// SMBO points on SMBus base address operation region

	HSTS,8,        // SMBus host status reg.   0x0
	SSTS,8,        // SMBus slave status reg.  0x1
	HSTC,8,        // SMBus host status cntr reg. 0x2
	HCMD,8,        // SMBus host command reg.  0x3
	HADR,8,        // SMBus host address reg.  0x4
	HDT0,8,        // SMBus host data 0 reg.   0x5
	HDT1,8,        // SMBus host data 1 reg.   0x6
	BLKD,8,        // SMBus block data reg.    0x7
//	SLCT,8,        // SMBus slave count reg.   0x8
//	SHCM,8,        // SMBus shadow command reg.0x9
//	SLEV,16,       // SMBus slave event reg.   0xA
//	SLDT,16,       // SMBus slave data reg.    0xC
	}
	Field(SMB0,ByteAcc,NoLock,Preserve){
	Offset(0x5),
	HDTW,16,        // SMBus host data reg.   0x5-0x6
	}

/*
// SMBus protocol 
	Name(WRQI, 0x2)	// Write Quick Command
	Name(RDQI, 0x3)	// Read  Quick Command
	Name(SDBT, 0x4)	// Send byte
	Name(RCBT, 0x5)	// Receive byte
	Name(WRBT, 0x6)	// Write byte
	Name(RDBT, 0x7)	// Read  byte
	Name(WRWD, 0x8)	// Write word
	Name(RDWD, 0x9)	// Read  word
	Name(WRBL, 0xa)	// Write block
	Name(RDBL, 0xb)	// Read  block
	Name(PCLL, 0xc)	// Process call
*/

// Wait for command completion
Method(WTSB) {

//; assuming 32kHz SMB clock -> period = 30us
//; average transaction is less than 50 clocks
//; the timeout 30us*50clocks=150us

// actual counter was redused due to OS has delays
// of running commands itself

	 Store(0xFF, Local7)

	 While(Local7)
	 {
		 Decrement(Local7)
		 If(And(HSTS,0x2))       // if SMB Int bit 1
			  {Return(Local7)}
	 }

	Return(0)                    // if completion fail return 0
	}

// Send command control method
// main method to programm the SMBus host controller
	Method(SCMD, 4) {

//	Arg0 - Device address
// 	Arg1 - Command Code
//	Arg2 - Data to write
//	Arg3 - Protocol (basically RDWD, WRWD or RDBL)

	Store( 5, Local0)       // try number
	While(Local0)
     {
	Store(Arg0, HADR)      // Device address
	Store(Arg1, HCMD)      // Command byte
	Store(Arg2, HDTW)      // Data Word

	Store(0xFF, HSTS)        // Clear all status bits
	Store(Arg3, HSTC)        // Byte data command + start


	If(WTSB())               // wait for command completion
		{Store(0, Local0)}
	Else
		{Decrement(Local0)}
	}                           // end of while

	}

// Send byte protocol
Method(SBYT, 2) {
	// Arg0 = address byte
	// Arg1 = command byte

	SCMD (Arg0, Arg1, 0, 0x44)

	}                     // Method(SBYT)

// Write byte protocol
Method(WBYT, 3) {

	 // Arg0 = address byte
	 // Arg1 = command byte
	 // Arg2 = data byte

	SCMD (Arg0, Arg1, Arg2, 0x48)

	}                       // Method(WBYT)

// Write word protocol
Method(WWRD, 3) {
	 // Arg0 = address byte
	 // Arg1 = command byte
	 // Arg2 = data word


	SCMD (Arg0, Arg1, Arg2, 0x4c)

	}                     // Method(WWRD)

// Write byte block protocol
Method(WBLK, 4) {

	 // Arg0 = address byte
	 // Arg1 = command byte
	 // Arg2 = block length
	 // Arg3 = data buffer


	Store( 5, Local0)       // try number
	While(Local0)
	{
//       Store(1, \_SB.PCI0.PX43.SMBE)
	Store(Arg0, HADR)      // Device address
	Store(Arg1, HCMD)      // Command byte

	Store(HSTS, Local0)	// clear SRAM counter
	Store(Arg2, Local0)	// set byte number to send
	Store(0, Local1)	// init counter
	While(Local0){
	Store(DeRefOf(Index(Arg3,Local1)), BLKD)
	Decrement(Local0)
	Increment(Local1)
	}

	Store(Arg2, HDT0)	// Data byte

	Store(HSTC, Local0)	// clear SRAM counter

	Store(0xFF, HSTS)       // Clear all status bits
	Store(0x4A, HSTC)       // Block data command + start


	If(WTSB())               // wait for command completion
	    {Store(0, Local0)}
       Else {Decrement(Local0)}

	}			// end of repeat counter

	}			// Method(WBLK)

// Receive byte protocol
Method(RSBT, 2) {
	 // Arg0 = address byte
	 // Arg1 = command byte

	Or(Arg0, 0x01, Arg0)    // Read command

	SCMD (Arg0, Arg1, 0, 0x44)

	Return(HDT0)            // Return data in DAT0

}                               // Method(RBYT)

// Read Data byte protocol
Method(RBYT, 2) {
	 // Arg0 = address byte
	 // Arg1 = command byte

	Or(Arg0, 0x01, Arg0)    // Read command

	SCMD (Arg0, Arg1, 0, 0x48)

	Return(HDT0)            // Return data in DAT0

}                               // Method(RBYT)

// Read word protocol
Method(RWRD, 2) {

	// Arg0 = address byte
	// Arg1 = command byte

	Or(Arg0, 0x01, Arg0)    // Read command

	SCMD (Arg0, Arg1, 0, 0x4c)

// DB00 and DB01 are defined as global buffer fields
//	Store(HDT0, DB00)       // Store in 1st byte of the buffer
//	Store(HDT1, DB01)       // Store in 2nd byte of the buffer

//	Return(DW00)                   // Return word data
	Return(HDTW)                   // Return word data

}	                              // Method(RWRD)

// Read byte block protocol
	Method(RBLK, 3) {

	// Arg0 = address byte
	// Arg1 = command byte
	// Arg2 = block length

	Store( 5, Local0)       // try number
	While(Local0)
     {
	Or(Arg0, 0x01, HADR)    // Device address + Read command
	Store(Arg1, HCMD)       // Command byte
	Store(0xFF, HSTS)       // Clear all status bits
	Store(0x54, HSTC)       // block data command + start

	If(WTSB())               // wait for command completion
	      {Store(0, Local0)}
	 Else {Decrement(Local0)}
      }				// end of repeat counter

	Store(HSTC, Local0)	// Clear SRAM pointer
	Store(HDT0, Local0)	// Store byte count

// Create Buffer for block commands
	Add(Local0, 1, Local7)
	Name(RBUF, Buffer(Local7){})

	Store(0, RBUF)		// Clear Destination Buffer

	Store(0, Local1)	// initial counter

	While(Local0){
	Store(BLKD, Index(RBUF,Local1))
	Decrement(Local0)
	Increment(Local1)
	}

	Return(RBUF)		// Return block data
 }                              // Method(RWRD)

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
//		DON'T CHANGE ANY CODE UNLESS REQUIRED !!!
//**********************************************************************;
