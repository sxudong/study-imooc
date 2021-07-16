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
// $Header: /BIOS/PORTING/ALEXP/INCLUDE.ASL/PCIDEV/PIIX4/EIOROUTE.ASL 6     5/07/98 1:31p Alexp $
//
// $Revision: 6 $
//
// $Date: 5/07/98 1:31p $
//**********************************************************************;
	OperationRegion(\_SB.NRTH.SBRG.PIX2, PCI_Config, 0x90, 0x02)
	Field(\_SB.NRTH.SBRG.PIX2,ByteAcc,NoLock,Preserve){
			TDMA,16,	// Type of DMA CH 0-3
//			DMA0,8,		// Type of DMA CH 0-3
//			DMA1,8,		// Type of DMA CH 4-7
	}

	OperationRegion(\_SB.NRTH.SBRG.PIX3, PCI_Config, 0xB0, 0x01)
	Field(\_SB.NRTH.SBRG.PIX3,ByteAcc,NoLock,Preserve){
			GCFG,8,			// #B0h General Config Register
	}

	OperationRegion(\_SB.NRTH.PMU.PIX4, PCI_Config, 0x50, 0x4)
	Field(\_SB.NRTH.PMU.PIX4,ByteAcc,NoLock,Preserve){
			DACK,32,		// #50h-52h
			}			// DACKx enbl to reload idle timer

	OperationRegion(\_SB.NRTH.PMU.PIX5, PCI_Config, 0x50, 0x30)
	Field(\_SB.NRTH.PMU.PIX5,ByteAcc,NoLock,Preserve){
			DCK0,8,		// #50h DACKx enbl to reload idle timer
			DCK1,8,         // #51
			DCK2,8,         // #52
			Offset(0x0c),
			RSA0,8,		// #5Ch Device Resource A
			RSA1,8,
			RSA2,8,
			RSA3,8,
			RSB0,16,	// #60h Device Resource B
//			RSB1,8,
			RSB2,8,
			RSB3,8,
			RSC0,16,	// #64h Device Resource C
//			RSC1,8,
			RSC2,8,
			RSC3,8, 	// #67h
			GDR2,16,	// #68h Generic Device 2 I/O
			GDM2,8,		// #6Ah Generic Device 2 Monitoring
			,40,
			GDR3,16,	// #70h Generic Device 3 I/O
			GDM3,8,		// #72h Generic Device 3 Monitoring
			,40,
			GDR4,16,	// #78h Generic Device 4 I/O
			GDM4,8,		// #7Ah Generic Device 4 Monitoring
			,8,
			GDR5,16,	// #7Ch Generic Device 5 I/O
			GDM5,8,		// #7Eh Generic Device 5 Monitoring
			}
// Route and Release I/O, DMA resources to EIO Bus

// Standart Port Base Table
Name(STBL,Package(){
	Package(){},  // Device       - 00
	Package(){},  // Device       - 01
	Package(){},  // Device       - 02
	Package(){},  // Device       - 03
		      // AudioDevice  - 04
	Package()  {0x220, 0x240, 0x260, 0x280,  // Sound Blaster
		    0x300, 0x310, 0x320, 0x330,  // MIDI
		    0x530, 0x604, 0xe80, 0xf40,  // Microsoft Sound
		    0x200},                      // Game Port
		     // FDD Device   - 05
//        Package()  {0x3f2, 0x372},
	Package()  {0x3f0, 0x370},
		     // UART1 Device - 06
	Package()  {0x3f8, 0x2f8, 0x220, 0x228, 0x238, 0x2e8, 0x338, 0x3e8},
		     // UART2 Device - 07
	Package()  {0x3f8, 0x2f8, 0x220, 0x228, 0x238, 0x2e8, 0x338, 0x3e8},
		     // LPT Device   - 08
	Package()  {0x3bc, 0x378, 0x278}
	})           // End of Standart Port Base Table

//  Standard Device Resource Table
//  --------------------------
//  EIOEnRegister(db) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
// -Register #                                                      º
//                                                                  º
//  EIOEnBit(db) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·     º
// -Bit for enabling EIO positive decoding                    º     º
//                                                            º     º
//  MonEnRegister(db) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·     º     º
// -Register #                                          º     º     º
//                                                      º     º     º
//  MonEnBit(db) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·     º     º     º
// -Bit for enabling port monitoring              º     º     º     º
//                                                º     º     º     º
//  PBaseAddrRegister(db) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·     º     º     º     º
// -Register #                              º     º     º     º     º
//                                          º     º     º     º     º
//  PBaseANDMask(db) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·    º     º     º     º     º
// -Matter bits for selecting port     º    º     º     º     º     º
//                                     º    º     º     º     º     º
//  PBaseValue(db) ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·     º    º     º     º     º     º
// -Bits to select proper port   º     º    º     º     º     º     º
//				 º     º    º     º     º     º     º
Name(DEVS,Package(){ //		 º     º    º     º     º     º     º
       Package(){}, // Dev - 0   º     º    º     º     º     º     º
       Package(){}, // Dev - 1   º     º    º     º     º     º     º
       Package(){}, // Dev - 2   º     º    º     º     º     º     º
       Package(){}, // Dev - 3   º     º    º     º     º     º     º
// AudioDevice - 04      	 º     º    º     º     º     º     º
// SBlasterResources        	 º     º    º     º     º     º     º
	Package(){ Package()  {0x00, 0x60, 0x00, 0x08, 0x00, 0x02, 0x03},
		   Package()  {0x20, 0x60, 0x00, 0x08, 0x00, 0x02, 0x03},
		   Package()  {0x40, 0x60, 0x00, 0x08, 0x00, 0x02, 0x03},
		   Package()  {0x60, 0x60, 0x00, 0x08, 0x00, 0x02, 0x03},
// MIDIResources:		 º     º    º     º     º     º     º
		   Package()  {0x00, 0x06, 0x00, 0x01, 0x00, 0x10, 0x05},
		   Package()  {0x02, 0x06, 0x00, 0x01, 0x00, 0x10, 0x05},
		   Package()  {0x04, 0x06, 0x00, 0x01, 0x00, 0x10, 0x05},
		   Package()  {0x06, 0x06, 0x00, 0x01, 0x00, 0x10, 0x05},
// MSSystemResources:		 º     º    º     º     º     º     º
		   Package()  {0x00, 0x03, 0x01, 0x80, 0x00, 0x01, 0x06},
		   Package()  {0x01, 0x03, 0x01, 0x80, 0x00, 0x01, 0x06},
		   Package()  {0x02, 0x03, 0x01, 0x80, 0x00, 0x01, 0x06},
		   Package()  {0x03, 0x03, 0x01, 0x80, 0x00, 0x01, 0x06},
// GamePortResources:		 º     º    º     º     º     º     º
		   Package()  {0x10, 0x10, 0x00, 0x10, 0x00, 0x80, 0x06}},
	//---------------------------------------------------------------
	// Since PIIX4 has no register for Game Port Base
	// to keep main idea of Get_EIO_Resources going
	// we use MonEn register as an Base Port register
	// with value and mask set equals MonEn bit mask
	//---------------------------------------------------------------
// FDD Device - 05   		 º     º    º     º     º     º     º
	Package(){ Package()  {0x00, 0x10, 0x06, 0x10, 0x0b, 0x20, 0x06},
		   Package()  {0x10, 0x10, 0x06, 0x10, 0x0b, 0x20, 0x06}},
// SerialA Device - 06		 º     º    º     º     º     º     º
	Package(){ Package()  {0x00, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09},
		   Package()  {0x01, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09},
		   Package()  {0x02, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09},
		   Package()  {0x03, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09},
		   Package()  {0x04, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09},
		   Package()  {0x05, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09},
		   Package()  {0x06, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09},
		   Package()  {0x07, 0x07, 0x09, 0x40, 0x0b, 0x08, 0x09}},
// SerialB Device - 07		 º     º    º     º     º     º     º
	Package(){ Package()  {0x00, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09},
		   Package()  {0x10, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09},
		   Package()  {0x20, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09},
		   Package()  {0x30, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09},
		   Package()  {0x40, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09},
		   Package()  {0x50, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09},
		   Package()  {0x60, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09},
		   Package()  {0x70, 0x70, 0x09, 0x01, 0x0c, 0x80, 0x09}},
// LPT Device - 08 		 º     º    º     º     º     º     º
	Package(){ Package()  {0x00, 0x06, 0x06, 0x04, 0x0c, 0x80, 0x03},
		   Package()  {0x02, 0x06, 0x06, 0x04, 0x0c, 0x80, 0x03},
		   Package()  {0x04, 0x06, 0x06, 0x04, 0x0c, 0x80, 0x03}}

	       }) // End of Standard Device Name

	Name(ROUT, Package(){0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})

// 1. PreStuff for Route/Release I/O ports to EIO Bus
  Method(RRIO,4){       // On Enter
			// Arg0      Device Category
			// Arg1      0/1 Route/Release Mode
			// Arg2      Port to Route/Release
			// Arg3      Port SIZE to Route
			//-----------------------------------
			//        0 - Primary IDE Drive 0
			//        1 - Primary IDE Drive 1
			//        2 - Secondary IDE Drive 0
			//        3 - Secondary IDE Drive 1
			//        4 - Audio
			//        5 - FDD
			//        6 - Serial A (Modem)
			//        7 - Serial B (IR)
			//        8 - LPT
			//        9 - Generic I/O Range 1
			//       10 - Generic I/O Range 2
			//       11 - UserIntCategory
			//       12 - Generic I/O Range 3
			//       13 - Generic I/O Range 4
			//-----------------------------------

       If(LAnd(GCFG, 0x2)) {}
		Else {Return(0)} // return if we are in Subtractive decode

// Code Starts

	Name(LSTS,0x08)                         // Last Standard Devise in Cetegory
	Name(LSTG,0x0F)                         // Last Generic Devise in Cetegory
// Looking for a proper Package within the Standart Port Base Table

	IF(LGreater(Arg0,LSTS)) {
		 IF(LGreater(Arg0,LSTG))
			  {Return(Zero)}
					  // Device out of Config Space
		 Else
		 {Return(RGNR(Arg0,Arg1,Arg2,Arg3))}
		 }
					  // If Device # greater then
					  // LastStandDev and less then
					  // LastGenericDev do call the
					  // Generic Device Routing Method
					  // Return value : Arg0
					  //       0 - Last Routed Port
					  //       1 - SIZE of Port

	Store(Match(DeRefOf(Index(STBL, Arg0)), MEQ, Arg2, MTR,0,0), Local6)


	IF(LEQual(Local6,Ones))                 // OFTB offset within DEVS
		   {Return(One)}                // PORT doesn't match no one
						// Standard port in Device Category

	Store(RSA0, Index(ROUT, 0))
	Store(RSA1, Index(ROUT, 1))
	Store(RSA2, Index(ROUT, 2))
	Store(RSA3, Index(ROUT, 3))
	Store(RSB0, Index(ROUT, 4))

	Store(RSB2, Index(ROUT, 5))
	Store(RSB3, Index(ROUT, 6))
	Store(RSC0, Index(ROUT, 7))

	Store(RSC2, Index(ROUT, 0x08))
	Store(RSC3, Index(ROUT, 0x09))
	Store(DCK0, Index(ROUT, 0x0a))
	Store(DCK1, Index(ROUT, 0x0b))
	Store(DCK2, Index(ROUT, 0x0c))

	Store(DeRefOf(Index(DeRefOf(Index(DeRefOf(Index(DEVS, Arg0)), Local6)), 0)), Local0)
	Store(DeRefOf(Index(DeRefOf(Index(DeRefOf(Index(DEVS, Arg0)), Local6)), 1)), Local1)
	Store(DeRefOf(Index(DeRefOf(Index(DeRefOf(Index(DEVS, Arg0)), Local6)), 2)), Local2)
	Store(DeRefOf(Index(DeRefOf(Index(DeRefOf(Index(DEVS, Arg0)), Local6)), 3)), Local3)
	Store(DeRefOf(Index(DeRefOf(Index(DeRefOf(Index(DEVS, Arg0)), Local6)), 4)), Local4)
	Store(DeRefOf(Index(DeRefOf(Index(DeRefOf(Index(DEVS, Arg0)), Local6)), 5)), Local5)
	Store(DeRefOf(Index(DeRefOf(Index(DeRefOf(Index(DEVS, Arg0)), Local6)), 6)), Local6)

	//Local0             // Value to select proper port
	//Local1             // Bit Field for selecting port
	//Local3             // Bit for enabling port range monitoring
	//Local5             // Bit for enabling EIO positive decoding

	// Local7  - temporarry result storage

 IF(Arg1) {				// Release Resource Method
	Not(Local3,Local3)
	And ( DeRefOf(Index(ROUT, Local4)), Local3, Local7)
	Store(Local7, Index(ROUT, Local4))// Clear the Monitor Enable Bit

	Not(Local5,Local5)
	And ( DeRefOf(Index(ROUT, Local6)), Local5, Local7)
	Store(Local7, Index(ROUT, Local6))// Clear the EIO Decode Enable Bit

//	Not(Local1,Local1)
//	And(DeRefOf(Index(ROUT, Local2)), Local1, Local7)
//	Store(Local7, Index(ROUT, Local2))// Clear Decode Select bits

	}				// End of Release Old Resource

 ELSE   {				// Route Resource
	Not(Local1,Local1)
	And( DeRefOf(Index(ROUT, Local2)), Local1, Local7)
					// Clear Decode Select bits
	Or (Local7, Local0, Index(ROUT, Local2))
					// Set New Port Decode Range
	Or ( DeRefOf(Index(ROUT, Local4)), Local3, Local7)
	Store(Local7, Index(ROUT, Local4))
					// Set the Monitor Enable Bit
// If we are in Subtractive decode mode do not set
// the EIO Positive Decode Enable Bit
       And(GCFG, 0x2, Local7)
       IF(Local7) {
	Or (DeRefOf(Index(ROUT, Local6)), Local5, Local7)
	Store(Local7, Index(ROUT, Local6))// Set the EIO Decode Enable Bit
			   }
	}					// End of Route New Resource

	Store(DeRefOf(Index(ROUT, 0)), RSA0)
	Store(DeRefOf(Index(ROUT, 1)), RSA1)
	Store(DeRefOf(Index(ROUT, 2)), RSA2)
	Store(DeRefOf(Index(ROUT, 3)), RSA3)
	Store(DeRefOf(Index(ROUT, 4)), RSB0)
	Store(DeRefOf(Index(ROUT, 5)), RSB2)
	Store(DeRefOf(Index(ROUT, 6)), RSB3)
	Store(DeRefOf(Index(ROUT, 7)), RSC0)
	Store(DeRefOf(Index(ROUT, 0x08)), RSC2)
	Store(DeRefOf(Index(ROUT, 0x09)), RSC3)
	Store(DeRefOf(Index(ROUT, 0x0a)), DCK0)
	Store(DeRefOf(Index(ROUT, 0x0b)), DCK1)
	Store(DeRefOf(Index(ROUT, 0x0c)), DCK2)
	}					// End of RRIO Method

// 2. Route Generic Device's port range to EIO Bus
// Now there is only Routing supported(there is no Release)
	Name(GEND, Package(){       //  Generic Device Resource Table
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄ·
//     	         ºBase(Lo) º   Mask   º  MonEn    º  EIOEn    º ChipSel   º
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄ¶
	Package()   {0x00,  0x0F, 0x01, 0x20, 0x01, 0x40, 0x01, 0x80, 0x01},  // Dev  #9
//                   RSB0         RSB2        RSB2        RSB2	      RSB2
	Package()   {0x02,  0x0F, 0x03, 0x20, 0x03, 0x40, 0x03, 0x80, 0x03},  // Dev  #10
//                   RSC0         RSC2        RSC2        RSC2	      RSC2
	Package()   {0x00,  0x00, 0x00, 0x00, 0x00, 0x00, 0x00},  // User #11
	Package()   {0x05,  0x0F, 0x09, 0x10, 0x09, 0x20, 0x04},  // Dev  #12
//                   GDR2         GDM2        GDM2        RSA3
	Package()   {0x06,  0x0F, 0x0a, 0x10, 0x0a, 0x40, 0x04},  // Dev  #13
//                   GDR3         GDM3	      GDM3	  RSA3
	Package()   {0x07,  0x0F, 0x0b, 0x00, 0x0b, 0x10, 0x0b},  // Dev  #14
//                   GDR4         GDM4        GDM4        GDM4
	Package()   {0x08,  0x0F, 0x0c, 0x00, 0x0c, 0x10, 0x0c}}) // Dev  #15
//		     GDR5         GDM5        GDM5        GDM5
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄ½

  Method(RGNR,4){

	Store(RSB0, Index(ROUT, 0))
	Store(RSB2, Index(ROUT, 1))
	Store(RSC0, Index(ROUT, 2))
	Store(RSC2, Index(ROUT, 3))
	Store(RSA3, Index(ROUT, 4))
	Store(GDR2, Index(ROUT, 5))
	Store(GDR3, Index(ROUT, 6))
	Store(GDR4, Index(ROUT, 7))
	Store(GDR5, Index(ROUT, 8))
	Store(GDM2, Index(ROUT, 9))
	Store(GDM3, Index(ROUT, 0xa))
	Store(GDM4, Index(ROUT, 0xb))
	Store(GDM5, Index(ROUT, 0xc))

	Name(CATG, 0)
	Name(MODE, 0)
	Name(PORT, 0)
	Name(SIZE, 0)

	Store(Arg0, CATG)	// Device Category
	Store(Arg1, MODE)	// 0/1 Route/Release Mode
	Store(Arg2, PORT)	// Port to Route/Release
	Store(Arg3, SIZE)	// Port SIZE to Route
					// Resource Table
					// 0 - Generic I/O Range 9
					// 1 - Generic I/O Range 10
					// 2 - UserIntCategory   11
					// 3 - Generic I/O Range 12
					// 4 - Generic I/O Range 13
					// 5 - Generic I/O Range 14
					// 6 - Generic I/O Range 15

	Subtract(CATG, 9, CATG)			// Subtract 9 to match
						// to device appearances in GEND
// Get Old Decode Base Address
Store(DeRefOf(Index(ROUT, DeRefOf(Index(Index(GEND, CATG), 0)))), Local2)

// Set New Decode Base Address
Store(PORT, Index(ROUT, DeRefOf(Index(Index(GEND, CATG), 0))) )

// Get Old SIZEe Mask
And  (DeRefOf(Index(ROUT, DeRefOf(Index(Index(GEND, CATG) ,2)))), 0x0F, Local3)
Increment(Local3)

// Set Port SIZE Mask
Subtract(SIZE, 1, Local4)               // Subtract One to
					// create the SIZE mask
FindSetLeftBit(Local4, Local5)
ShiftRight(0xFF, Local5, Local6)

// Set New SIZE mask
Store(Local6, Index(ROUT, DeRefOf(Index(Index(GEND, CATG), 2))) )

// Set Decode Chip-select bit for only Dev9 or Dev10
If(Or(LEqual(CATG, 0), LEqual(CATG, 1) ))
	{
	Store(Index(ROUT, DeRefOf(Index(Index(GEND, Arg0), 8))),Local7)

	If(MODE) {	// 0-Route/1-Release
		And(Local7 , Not(DeRefOf(Index(Index(GEND, Arg0), 7))), Local7)
		}
	Else {
		Or(Local7 , DeRefOf(Index(Index(GEND, Arg0), 7)), Local7)
		}
	Store(Local7, Index(ROUT, DeRefOf(Index(Index(GEND, Arg0), 8))) )
	}

// Set EIO enable bit
//	If(And(GCFG,0x2))
//	{
	// Set the EIO Decode Enable Bit

	Store(Index(ROUT, DeRefOf(Index(Index(GEND, Arg0), 6))),Local7)

	If(MODE) {	// 0-Route/1-Release
		And(Local7 , Not(DeRefOf(Index(Index(GEND, Arg0), 5))), Local7)
		}
	Else {
		Or(Local7 , DeRefOf(Index(Index(GEND, Arg0), 5)), Local7)
		}
	Store(Local7, Index(ROUT, DeRefOf(Index(Index(GEND, Arg0), 6))) )
//}

	Store(Index(ROUT, 0), RSB0)
	Store(Index(ROUT, 1), RSB2)
	Store(Index(ROUT, 2), RSC0)
	Store(Index(ROUT, 3), RSC2)
	Store(Index(ROUT, 4), RSA3)
	Store(Index(ROUT, 5), GDR2)
	Store(Index(ROUT, 6), GDR3)
	Store(Index(ROUT, 7), GDR4)
	Store(Index(ROUT, 8), GDR5)
	Store(Index(ROUT, 9), GDM2)
	Store(Index(ROUT, 0xa), GDM3)
	Store(Index(ROUT, 0xb), GDM4)
	Store(Index(ROUT, 0xc), GDM5)

// Prepare Return package
	Store(Arg0, Index(ROUT, 0))	// Device Category
	Store(MODE, Index(ROUT, 1))	// 0/1 Route/Release Mode
	Store(Local2, Index(ROUT, 2))	// Port to Route/Release
	Store(Local3, Index(ROUT, 3))	// Port SIZE to Route


	Return(ROUT)
	}				// End of RGNR Method


Name(DTBL,Package(){
	Package(){},  // Device       - 00
	Package(){},  // Device       - 01
	Package(){},  // Device       - 02
	Package(){},  // Device       - 03
//		      M	    D     D     D     D     D     D     D     D
//		      A	    A     A     A     A     A     A     A     A
//	      PIIX4   S	    C     C     C     C     C     C     C     C
//	   Register   K     K     K     K     K     K     K     K     K
//		     Xor    0,    1,    2,    3,    4,    5,    6,    7
			// AudioDevice  - 04
	Package()  {0x3f, 0x01, 0x02, 0x00, 0x04, 0x00, 0x08, 0x10, 0x20},
			// FDD Device   - 05
	Package()  {0x0800,0x00, 0x00, 0x0800},
	Package()  {},	// UART1 Device - 06
	Package()  {},	// UART2 Device - 07
			// LPT Device   - 08
	Package()  {0x020000, 0x020000, 0x220000, 0x00, 0x420000}
	})		// End


// 3. Route DMA Channels to EIO Bus
// 3.1 Set new DACK event reload timer in DEVRESD Fun3 / #50h - 52h
// 3.2 Set new DMA type to be performed in DMACFG registers Fun0 / #90h-91h
  Method(rDMA, 3){
			// Arg0      Device Category
			// Arg1      0/1 Route/Release Mode
			// Arg2      DMA channel to route (1 based)
/*
// 3.1 Set new DACK event reload timer in DEVRESD Fun3 / #50h - 52h
	// Xor mask
	Store(DeRefOf(Index(DeRefOf(Index(DTBL, Arg0)), 0)), Local1)
	// new value
	Store(DeRefOf(Index(DeRefOf(Index(DTBL, Arg0)),Arg2)), Local0)

	Xor(Local1, Ones, Local2)
	And(DACK, Local2, DACK)		// clear DMA monitor enable

	If(Arg1) {}			// Route DMA
		Else
		{
		Or(DACK, Local0, DACK)
		}			// End of DMA routing

//	If(Lequal(Arg0, 4))	// Audio
//	{
//	Store(Local0, DCK0)     // Set DACKx to reload idle timer
//	}
//	If(Lequal(Arg0, 5))	// FDD
//	{
//	Or(DCK1, Local0, DCK1)	// Set FDC DMA Monitor Enable
//	}
//	If(Lequal(Arg0, 8))	// ECP
//	{
//	And(DCK2, 0xCD, Local1)	// Clear LPT DMA control bits
//	Or(Local1, Local0, DCK2)//Set DACKx to reload idle timer
//	}
*/
// 3.2 Set new DMA type to be performed in DMACFG registers Fun0 / #90h-91h

	Decrement(Arg2)	// Make DMA channel in order to DMA0-0, DMA1-1...

	ShiftLeft(Arg2, 1, Local1)	// every two bits
	ShiftLeft(3, Local1, Local2)
	Xor(Local2, 0xffff, Local2)
	Store(TDMA, Local0)
	And(Local0, Local2, TDMA)
//	And(TDMA, Local2, TDMA)
}
