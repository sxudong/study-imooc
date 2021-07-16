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
// $Header: $
//
// $Revision: $
//
// $Date: $
//**********************************************************************;
//**********************************************************************;
// Revision History
// ----------------
// $Log: $
// 
//**********************************************************************;

// Start of Definitions for ITE8661F I/O device

OperationRegion(CFGP,SystemIO,0x279,1)
//fields are in this Operation Region
Field(CFGP,ByteAcc,NoLock,Preserve){
                                    UNLK,8,
                                   }

OperationRegion(ITE1,           // name of Operation Region for SuperIO device
                SystemIO,       // type of address space
                SPIO,          // offset to start of region
                                // (default offset for SuperIO device)
                                // (Real systems will likely have the BIOS relocate this device
                                // to avoid conflicts with secondary floppy ID of 0x370)
                2)              //size of region in bytes
                                //end of Operation Region

//fields are in this Operation Region
Field(ITE1,ByteAcc,NoLock,Preserve){
                                    INDX,8, //field named INDX is 8 bits wide
                                    DATA,8  //field DATA is 8 bits wide
                                   }

IndexField(INDX,                // Index name
           DATA,                // Name of I/O port
           ByteAcc,
           NoLock,
           Preserve){
                     ,16,       //0x02
                     CFG,8,     //0x01 (0x02) global config control reg
                     ,32,       //0x04
                     LDN,8,     //0x01 (0x07) Logical Device Number
                     ,200,      //0x19
                     ,120,      //0x0f
                     ACTR,8,    //0x01 (0x30) activate register
                     ,200,      //0x19
                     ,176,      //0x16
                     IOAH,8,    //0x01 (0x60) base I/O addr
                     IOAL,8,    //0x01
                     ,112,      //0x0e
                     INTR,8,    //0x01 (0x70) IRQ
                     ,8,        //0x  Offset(0x72)
                     INT1,8,    //Second IRQ for some devices
                     ,8,        //0x Offset(0x74)
                     DMCH,8,    //DMA channel
                     ,200,      //0x Offset(0xC0)
                     ,200,
                     ,200,
                     GP40,8,    //Fast IR control bits
                     ,176,      //0x Offset(0xF0)
                     ,200,
                     OPT1,8,    //Option register 1
                     OPT2,8,    //Option register 2
                     OPT3,8     //Option register 3
                    }   //end of indexed field
                

Method(ENFG,0){         // Enter Config Mode for
               Store(0x86,UNLK)
               Store(0x61,UNLK)
               Store(0x55,UNLK)
               Store(0x55,UNLK)

               Store(0x6a,INDX)
               Store(0xb5,INDX)
               Store(0xda,INDX)
               Store(0xed,INDX)
               Store(0xf6,INDX)
               Store(0xfb,INDX)
               Store(0x7d,INDX)
               Store(0xbe,INDX)
               Store(0xdf,INDX)
               Store(0x6f,INDX)
               Store(0x37,INDX)
               Store(0x1b,INDX)
               Store(0x0d,INDX)
               Store(0x86,INDX)
               Store(0xc3,INDX)
               Store(0x61,INDX)
               Store(0xb0,INDX)
               Store(0x58,INDX)
               Store(0x2c,INDX)
               Store(0x16,INDX)
               Store(0x8b,INDX)
               Store(0x45,INDX)
               Store(0xa2,INDX)
               Store(0xd1,INDX)
               Store(0xe8,INDX)
               Store(0x74,INDX)
               Store(0x3a,INDX)
               Store(0x9d,INDX)
               Store(0xce,INDX)
               Store(0xe7,INDX)
               Store(0x73,INDX)
               Store(0x39,INDX)
              }

Method(EXFG,0){         // Exit Config Mode for
               Store(0x02,INDX)
               Store(0x02,DATA)
              }

// Logical Device numbers for UART1, UART2, FDC, LPT, ECP, IrDa
	Name(LDFD, 0)	// Floppy controller LDD
	NAme(LDU1, 1)	// UART 1
	NAme(LDU2, 2)	// UART2
	NAme(LDIR, 4)	// IRDa
	NAme(LDLP, 3)	// LPT/ECP

// Floppy Disk Controller 

Device(FDC0) {  					

	Name(_HID, EISAID("PNP0700"))		// PnP Device ID
	Method(_STA, 0) {

		If(FDST) {
					// LDN = 0
		Return(GSTA(0))		// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(0) 		// Disable FDC (LDN = 0)
	}

	Method(_CRS, 0) {Return(FCRS)}	// Return FDC current resources

	Method(_PRS, 0) {Return(FPRS)}	// Return FDC possible resources

	Method(_SRS, 1) {
		DENB(0)			// Enable FDC (LDN = 0)
	}
	
}						// end of FDC0

// UART1 - COMA
Device(UAR1)
{
 Name(_HID,EISAID("PNP0501"))

	Name(_UID, 1)			// Generic ID for COMA


	Method(_STA, 0) {

		If(U1ST) {
					// LDN = 1
		Return(GSTA(1))		// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(1)			// Disable UART1 (LDN = 1)
	}

	Method(_CRS, 0) {
		Return(PCRS(1, 1, 8))	// Get UART1 current resources
	}

	Method(_SRS, 1) {
		PSRS(Arg0, 1)		// Set UART1 recources
	}

	Method(_PRS) {Return(C1PR)}	// Return UART1 possible resources

}                                       // End of UART1

// UART2 - COMB
Device(UAR2)
{
 Name(_HID,EISAID("PNP0501"))
 Name(_UID,2)                   // Generic ID for COMB

	Method(_STA, 0) {

		If(U2ST) {
					// LDN = 2
		Return(GSTA(2))		// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(2)			// Disable UART2 (LDN = 2)
	}

	Method(_CRS, 0) {
		Return(PCRS(2, 1, 8))	// Get UART2 current resources

	}

	Method(_SRS, 1) {
		PSRS(Arg0, 2)		// Set UART2 recources
	}

	Method(_PRS) {Return(C2PR)}	// Return UART2 possible resources

}                                       // End of UART2

// LPT DEVICE
Device(LPT)
{
 Name(_HID,EISAID("PNP0400"))            // PnP ID for WIN LPT Port

 Method(_STA,0){                      // LPT Device Status
                ENFG()  
                Store(0x03,LDN)
		And(OPT1, 0x02, Local0)	// ECP Mode?
		EXFG()			// Exit Config Mode
		If(Or(Local0, And(Not(LPST),1)))// Yes - LPT is not present
		{
			Return(Zero)
		}
		Else {			// No - get LPT status
			Return(GSTA(3))
		}
        }        // End _STA method

	Method(_DIS, 0) {
		DDIS(3)			// Disable LPT (LDN = 3)
	}

	Method(_CRS, 0) {
		Return(PCRS(3, 1, 8))	// Get LPT current resources
	}

	Method(_SRS, 1) {
		PSRS(Arg0, 3)		// Set LPT recources
	}

        Method(_PRS) {Return(LPPR)}	// Return LPT possible resources

}       // End Device(LPT)

// Dedicated IR
Device(IRDA)
{
 Name(_HID,EISAID("PNP0510"))
 Name(_UID,3)           // Generic ID for COMC

// IRDA._STA Control Method
	Method(_STA, 0) {

		If(IRST) {
					// LDN = 62
		Return(GSTA(LDIR))	// Get status
		}
		Return(0)		// Not present
	}

	Method(_DIS, 0) {
		DDIS(4)			// Disable IRD (LDN = 4)
	}

	Method(_CRS, 0) {
		Return(PCRS(4, 1, 8))	// Get IRD current resources

	}

	Method(_SRS, 1) {
		PSRS(Arg0, 4)		// Set IRD recources
	}

	Method(_PRS) {Return(C2PR)}	// Return IRD possible resources

}                               // End IRDA

// ECP DEVICE
Device(ECP)
{
 Name(_HID,EISAID("PNP0401"))   // PnP ID ECP Port

	Method(_STA, 0) {
		ENFG()				// Enter Config Mode
		Store(3, LDN)			// ECP LDN = 1
		And(OPT1, 0x02, Local0)
		EXFG()			// Exit Config Mode
		If (Local0)		// ECP Mode?
		{
		 If(LPST) { Return(GSTA(3))}// Yes - get ECP status
		}
		Else {
			Return(Zero)	// No - ECP is not present
		}

	}

	Method(_DIS, 0) {
		DDIS(3)			// Disable ECP (LDN = 3)
	}

	Method(_CRS, 0) {
		Return(ECRS(3))		// Get LPT current resources
	}

	Method(_SRS, 1) {		// Set ECP resources
		ESRS(Arg0, 3)		// Set resources
	}

	Method(_PRS) {Return(EPRS)}	// Return ECP possible resources

}                                               // End ECP Device

// End of ITE8661F
