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
// 		ALI 1541 SMB interface methods
//**********************************************************************;
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

	// Send command control method
	// main method to programm the SMBus host controller
	Method(SCMD, 4) {

		//	Arg0 - Device address
		// 	Arg1 - Command Code
		//	Arg2 - Data to write
		//	Arg3 - Protocol (basically RDWD, WRWD, RDBL...)

		// SMBus interface over PIIX4 SMBus host controller
		Field(\_SB.PCI0.PMU.SMRG,ByteAcc,NoLock,Preserve){

			// SMBO points on SMBus base address operation region

			HSTS,8,        // SMBus host/Slave status reg.				0x0
			HSTC,8,        // SMBus host/Slave Commabd.					0x1
			HSTR, 8,	   // I/O port to start to generate the programmed cycle on the SMBus 0x2
			HADR,8,        // SMBus address reg for Host Controller.	0x3
			HDTW,16,        // SMBus host data reg.						0x4-0x5
			//HDT0,8,        // SMBus host data 0 reg.				0x4
			//HDT1,8,        // SMBus host data 1 reg.				0x5
			BLKD,8,        // SMBus block data reg.						0x6
			HCMD,8,        // SMBus command reg for Host Controller.	0x7
		}

	/*	Field(SMB0,ByteAcc,NoLock,Preserve){
			Offset(0x4),
			HDTW,16,        // SMBus host data reg.   0x4-0x5
		}*/

		Store( 5, Local0)       // try number
		While(Local0)
		{
			Store(Arg0, HADR)	// Device address
			Store(Arg1, HCMD)	// Command byte
			Store(Arg2, HDTW)	// Data Word

			Store(0xFF, HSTS)	// Clear all status bits
			Store(Arg3, HSTC)	// Byte data command + start
			Store(1, HSTR)	// Byte data command + start

			// wait for command completion

			//; assuming 32kHz SMB clock -> period = 30us
			//; average transaction is less than 50 clocks
			//; the timeout 30us*50clocks=150us

			// actual counter was redused due to OS has delays
			// of running commands itself

			Store(0xFF, Local7)

			While(Local7)
			{
				Decrement(Local7)
				If(And(HSTS,0x10))	// if SMB Int bit 4
				{
					Store(0, Local7)
					Store(1, Local0)
				}
			}
			Decrement(Local0)
		}				// end of while
		If(And(HSTS,0x10))	// if SMB Int bit 4
		{
			Return(HDTW)		// Operation suceed
		}
		Else
		{
			Return(Not(0))		// Operation failed
		}
	}

	// Send byte protocol
	Method(SBYT, 2)
	{
		// Arg0 = address byte
		// Arg1 = command byte
		SCMD (Arg0, Arg1, 0, 0x08)
	}                     // Method(SBYT)

	// Write byte protocol
	Method(WBYT, 3) 
	{
		// Arg0 = address byte
		// Arg1 = command byte
		// Arg2 = data byte
		SCMD (Arg0, Arg1, Arg2, 0x10)
	}                       // Method(WBYT)

	// Write word protocol
	Method(WWRD, 3) 
	{
		// Arg0 = address byte
		// Arg1 = command byte
		// Arg2 = data word
		SCMD (Arg0, Arg1, Arg2, 0x18)
	}                     // Method(WWRD)

	// Receive byte protocol
	Method(RSBT, 2) 
	{
		// Arg0 = address byte
		// Arg1 = command byte
		Or(Arg0, 0x01, Arg0)    // Read command
		Return(SCMD (Arg0, Arg1, 0, 0x08)) // Return data in DAT0
	}                               // Method(RBYT)

	// Read Data byte protocol
	Method(RBYT, 2) 
	{
		 // Arg0 = address byte
		 // Arg1 = command byte
		Or(Arg0, 0x01, Arg0)    // Read command
		Return(SCMD (Arg0, Arg1, 0, 0x10)) // Return data in DAT0
	}                               // Method(RBYT)

	// Read word protocol
	Method(RWRD, 2) 
	{
		// Arg0 = address byte
		// Arg1 = command byte
		Or(Arg0, 0x01, Arg0)    // Read command
		Return(SCMD (Arg0, Arg1, 0, 0x18)) // Return word data
	}				// Method(RWRD)

// Next two SMBus commands WBLK & RBLK are fully functional
// but commented out for future use

/*

// Write byte block protocol
Method(WBLK, 4) {

	 // Arg0 = address byte
	 // Arg1 = command byte
	 // Arg2 = block length
	 // Arg3 = data buffer

	OperationRegion(SMB0,SystemIO, \_SB.PCI0.PMU.SMBS(), 0x10)
	Field(SMB0,ByteAcc,NoLock,Preserve){
// SMBO points on SMBus base address operation region
	,16,
	HSTC,8		// SMBus host status cntr reg.	0x2
	,32,
	BLKD,8,		// SMBus block data reg.	0x7
	}


	Store(HSTC, Local0)	// clear SRAM counter

	Store(Arg2, Local0)	// set byte number to send
	Store(0, Local1)	// init counter
	While(Local0)
	{
		Store(DeRefOf(Index(Arg3,Local1)), BLKD)
		Decrement(Local0)
		Increment(Local1)
	}

	Store(HSTC, Local0)	// clear SRAM counter

	SCMD (Arg0, Arg1, Arg2, 0x54)

	}			// Method(WBLK)

// Read byte block protocol
	Method(RBLK, 3) {

	// Arg0 = address byte
	// Arg1 = command byte
	// Arg2 = block length

	OperationRegion(SMB0,SystemIO, \_SB.PCI0.PMU.SMBS(), 0x10)
	Field(SMB0,ByteAcc,NoLock,Preserve){
// SMBO points on SMBus base address operation region
	,16,
	HSTC,8		// SMBus host status cntr reg.	0x2
	,32,
	BLKD,8,		// SMBus block data reg.	0x7
	}

	Or(Arg0, 0x01, Local0)    // Device address + Read command

	SCMD (Local0, Arg1, Arg2, 0x54)

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
 }                              // Method(RBLK)
*/
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
