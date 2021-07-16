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
        Name(LDFD, 0)   // Floppy controller LDD
        NAme(LDU1, 1)   // UART 1
        NAme(LDU2, 2)   // UART2
        NAme(LDIR, 4)   // IRDa
        NAme(LDLP, 3)   // LPT/ECP

// Floppy Disk Controller 

Device(FDC0) {                                          

        Name(_HID, EISAID("PNP0700"))           // PnP Device ID
        Method(_STA, 0) {

                If(FDST) {
                                        // LDN = 0
                Return(GSTA(0))         // Get status
                }
                Return(0)               // Not present
        }

        Method(_DIS, 0) {
                DDIS(0)                 // Disable FDC (LDN = 0)
        }

        Method(_CRS, 0) {Return(FCRS)}  // Return FDC current resources

        Method(_PRS, 0) {Return(FPRS)}  // Return FDC possible resources

        Method(_SRS, 1) {
                DENB(0)                 // Enable FDC (LDN = 0)
        }
        
}                                               // end of FDC0

//// UART1 - COMA
  Device(UAR1)
  {
   Name(_HID,EISAID("PNP0501"))

          Name(_UID, 1)                   // Generic ID for COMA


          Method(_STA, 0) {

                  If(U1ST) {
                                          // LDN = 1
                  Return(GSTA(1))         // Get status
                  }
                  Return(0)               // Not present
          }

          Method(_DIS, 0) {
                  DDIS(1)                 // Disable UART1 (LDN = 1)
          }

          Method(_CRS, 0) {
                  Return(PCRS(1, 1, 8))   // Get UART1 current resources
          }

          Method(_SRS, 1) {
                  PSRS(Arg0, 1)           // Set UART1 recources
          }

          Method(_PRS) {Return(C1PR)}     // Return UART1 possible resources

  }                                       // End of UART1
//
//// UART2 - COMB
//Device(UAR2)
//{
// Name(_HID,EISAID("PNP0501"))
// Name(_UID,2)                   // Generic ID for COMB
//
//        Method(_STA, 0) {
//
//                If(U2ST) {
//                                        // LDN = 2
//                Return(GSTA(2))         // Get status
//                }
//                Return(0)               // Not present
//        }
//
//        Method(_DIS, 0) {
//                DDIS(2)                 // Disable UART2 (LDN = 2)
//        }
//
//        Method(_CRS, 0) {
//                Return(PCRS(2, 1, 8))   // Get UART2 current resources
//
//        }
//
//        Method(_SRS, 1) {
//                PSRS(Arg0, 2)           // Set UART2 recources
//        }
//
//        Method(_PRS) {Return(C2PR)}     // Return UART2 possible resources
//
//}                                       // End of UART2

// LPT DEVICE
Device(LPT)
{
 Name(_HID,EISAID("PNP0400"))            // PnP ID for WIN LPT Port

 Method(_STA,0){                      // LPT Device Status
                ENFG()  
                Store(0x03,LDN)
                And(OPT1, 0x02, Local0) // ECP Mode?
                EXFG()                  // Exit Config Mode
                If(Or(Local0, And(Not(LPST),1)))// Yes - LPT is not present
                {
                        Return(Zero)
                }
                Else {                  // No - get LPT status
                        Return(GSTA(3))
                }
        }        // End _STA method

        Method(_DIS, 0) {
                DDIS(3)                 // Disable LPT (LDN = 3)
        }

        Method(_CRS, 0) {
                Return(PCRS(3, 1, 8))   // Get LPT current resources
        }

        Method(_SRS, 1) {
                PSRS(Arg0, 3)           // Set LPT recources
        }

        Method(_PRS) {Return(LPPR)}     // Return LPT possible resources

}       // End Device(LPT)

//// Dedicated IR
//Device(IRDA)
//{
// Name(_HID,EISAID("PNP0510"))
// Name(_UID,3)           // Generic ID for COMC
//
//// IRDA._STA Control Method
//        Method(_STA, 0) {
//
//                If(IRST) {
//                                        // LDN = 62
//                Return(GSTA(LDIR))      // Get status
//                }
//                Return(0)               // Not present
//        }
//
//        Method(_DIS, 0) {
//                DDIS(4)                 // Disable IRD (LDN = 4)
//        }
//
//        Method(_CRS, 0) {
//                Return(PCRS(4, 1, 8))   // Get IRD current resources
//
//        }
//
//        Method(_SRS, 1) {
//                PSRS(Arg0, 4)           // Set IRD recources
//        }
//
//        Method(_PRS) {Return(C2PR)}     // Return IRD possible resources
//
//}                               // End IRDA

//// ECP DEVICE
//Device(ECP)
//{
// Name(_HID,EISAID("PNP0401"))   // PnP ID ECP Port
//
//        Method(_STA, 0) {
//                ENFG()                          // Enter Config Mode
//                Store(3, LDN)                   // ECP LDN = 1
//                And(OPT1, 0x02, Local0)
//                EXFG()                  // Exit Config Mode
//                If (Local0)             // ECP Mode?
//                {
//                 If(LPST) { Return(GSTA(3))}// Yes - get ECP status
//                }
//                Else {
//                        Return(Zero)    // No - ECP is not present
//                }
//
//        }
//
//        Method(_DIS, 0) {
//                DDIS(3)                 // Disable ECP (LDN = 3)
//        }
//
//        Method(_CRS, 0) {
//                Return(ECRS(3))         // Get LPT current resources
//        }
//
//        Method(_SRS, 1) {               // Set ECP resources
//                ESRS(Arg0, 3)           // Set resources
//        }
//
//        Method(_PRS) {Return(EPRS)}     // Return ECP possible resources
//
//}                                               // End ECP Device

// End of ITE8661F
////////////////////////////////////////////////////////////////////////
// SET OF DIFFERENT IO DEVICES CONTROL METHOD ROUTINES                //
////////////////////////////////////////////////////////////////////////

// Detect on board Super IO devices
        Name(FDST,0)
        Name(U1ST,0)
        Name(U2ST,0)
        Name(IRST,0)
        Name(LPST,0)
//      Name(EPST,0)

        Method(IODT)                    // Start up code to detect
        {                               // the presence of Super IO devices
// FDC
                If(LEqual(GSTA(LDFD), 0xf)) // Get device status
                {
                Store(1, FDST)           // device present
                }
// UART 1
                If(LEqual(GSTA(LDU1), 0xf)) // Get device status
                {
                Store(1, U1ST)           // device present
                }
// UART 2
                If(LEqual(GSTA(LDU2), 0xf)) // Get device status
                {
                Store(1, U2ST)           // device present
                }
// IR
                If(LEqual(GSTA(LDIR), 0xf)) // Get device status
                {
                Store(1, IRST)           // device present
                }
// LPT,ECP
                If(LEqual(GSTA(LDLP), 0xf)) // Get device status
                {
                Store(1, LPST)           // device present
                }
        }


// GET SIO DEVICE STATUS according to ACTR/IOAH/IOAL ///////////////////
// Note: device must be selected

Method(GSTA, 1) {               // Get UART status

        ENFG()                                  // Enter Config Mode
        Store(Arg0, LDN)                        // Select Appropriate LDN
        If(ACTR) {Store(0x0F, Local0)}          // Present & Active

        Else {
                If(Or(IOAH, IOAL)) {            // If device address <> 0
                        Store(0x0D, Local0)     // then present &! active
                }
                Else {Store(0, Local0)}         // !present
//              Else {Store(0x1, Local0)}       // present/not decode IO/disabled
        }

        EXFG()                                  // Exit Config Mode
        Return(Local0)          // Return device status

} // EndOf GSTA

// Disable SIO device ///////////////////////////////////////////
// Note: device must be selected

Method(DDIS, 1) {

// Arg0 - LDN
        ENFG()                  // Enter Config Mode
        Store(Arg0, LDN)        // Select Appropriate LDN
        Store(Zero, ACTR)       // Set Activate Register to zero
        EXFG()                  // Exit Config Mode
} // End DDIS

Method(DENB, 1) {               // Enable SIO device

// Arg0 - LDN
        ENFG()                  // Enter Config Mode
        Store(Arg0, LDN)        // Select Appropriate LDN
        Store(One, ACTR)        // Set Activate Register to zero
        EXFG()                  // Exit Config Mode
} // End DDIS

// COMx and LPT _CRS implementation //////////////////////////

Method(PCRS, 3) {
// Arg0 - LDN
// Arg1 - Alignment
// Arg2 - IO Length

        CreateByteField(PBUF, 0x02, IOLO)       // Range Min Base LSB
        CreateByteField(PBUF, 0x03, IOHI)       // Range Min Base MSB
        CreateWordField(PBUF, 0x02, IOHL)       // Range Min Base Word
        CreateWordField(PBUF, 0x04, IORL)       // Range Max Base Word
        CreateByteField(PBUF, 0x06, ALMN)       // Alignment
        CreateByteField(PBUF, 0x07, LENG)       // Number of IO ports
        CreateByteField(PBUF, 0x09, IRQL)       // IRQ Mask


        ENFG()                  // Enter Config Mode
        Store(Arg0, LDN)        // Select Appropriate LDN

// Write Current Settings into Buffer for IO Descriptor
        Store(IOAH, IOHI)       // Get IO Base MSB
        Store(IOAL, IOLO)       // Get IO Base LSB
        Store(IOHL, IORL)       // Set MaxBase = MinBase
        Store(Arg1, ALMN)       // Set alignment
// adjust base/aligment size if base ports are 0x3bc/0x7bc
        If(LEqual(IOLO, 0xbc)) {Store(0x04, LENG)}
        Else {
        Store(Arg2, LENG)       // Set IO length
        }

// Write Current Settings into IRQ descriptor
        Store(One, Local0)
        ShiftLeft(Local0, INTR, IRQL)

        EXFG()                  // Exit Config Mode
        Return(PBUF)            // Return Byte Stream
}
// End //////////////////////////////////////////////////////////

// COMx and LPT _SRS implementation //////////////////////////

Method(PSRS, 2) {
// Arg0 - PnP Resource String to set
// Arg1 - LDN

        CreateByteField (Arg0, 0x02, POLB)      // Range Min Base LSB
        CreateByteField (Arg0, 0x03, POHB)      // Range Min Base MSB
        CreateByteField (Arg0, 0x09, PIRQ)      // IRQ number

        ENFG()                  // Enter Config Mode
        Store(Arg1, LDN)        // Select Appropriate LDN

// Set Base IO Address
        Store(POLB, IOAL)       // Set IO Base LSB
        Store(POHB, IOAH)       // Set IO Base MSB

// Set IRQ
        FindSetRightBit(PIRQ, Local0)
        Subtract(Local0, 1, INTR)

        Store(One, ACTR)        // Activate
        EXFG()                  // Exit Config Mode
}
// End //////////////////////////////////////////////////////////

// ECP _CRS implementation //////////////////////////////////////

Method(ECRS, 1) {
// Arg0 - LDN
        CreateByteField(EBUF, 0x02, EPLO)       // Range Min Base LSB
        CreateByteField(EBUF, 0x03, EPHI)       // Range Min Base MSB
        CreateWordField(EBUF, 0x02, EPHL)       // Range Min Base Word
        CreateWordField(EBUF, 0x04, EPRL)       // Range Max Base Word
        CreateWordField(EBUF, 0x06, ALM1)       // Alignment
        CreateWordField(EBUF, 0x0a, E4LO)       // IO Port+400h Low
        CreateWordField(EBUF, 0x0c, E4RL)       // IO Range+400h Low
        CreateWordField(EBUF, 0x11, EIRQ)       // IRQ
        CreateWordField(EBUF, 0x14, EDMA)       // DMA


        ENFG()                          // Enter Config Mode
        Store(Arg0, LDN)                // Select Appropriate LDN (LPT)

// Write Current Settings into Buffer for IO Descriptor
        Store(IOAH, EPHI)               // Get Min Base MSB
        Store(IOAL, EPLO)               // Get Min Base LSB

        Store(EPHL, EPRL)               // Set Max Base Word

        Add(EPHL, 0x400, E4LO)
        Store(E4LO, E4RL)

// adjust base/aligment size if base ports are 0x3bc/0x7bc
        If(LEqual(EPHL, 0x3bc)) {Store(0x0401, ALM1)}
        Else                    {Store(0x0801, ALM1)}

// Write Current Settings into IRQ descriptor
        Store(One, Local0)
        Store(INTR, Local1)
        ShiftLeft(Local0, Local1, EIRQ)

// Write Current Settings into DMA descriptor
        Store(DMCH, Local1)
        If(LGreater(Local1, 0x3))
        {
                Store(0, EDMA)                  // No DMA
        }
        Else
        {
                Store(One, Local0)
                ShiftLeft(Local0, Local1, EDMA)
        }

        EXFG()                          // Exit Config Mode

        Return(EBUF)                    // Return Current Resources
}
// End //////////////////////////////////////////////////////////

// ECP _SRS implementation //////////////////////////////////////

Method(ESRS, 2) {
// Arg0 - PnP Resource String to set
// Arg1 - LDN
        CreateByteField (Arg0, 0x02, LOEP)      // IO Port Low
        CreateByteField (Arg0, 0x03, HIEP)      // IO Port Low
        CreateWordField (Arg0, 0x11, IRQE)      // IRQ
        CreateWordField (Arg0, 0x14, DMAE)      // DMA Channel

        ENFG()                  // Enter Config Mode
        Store(Arg1, LDN)        // Select Appropriate LDN (LPT)

// Set Base IO Address
        Store(LOEP, IOAL)
        Store(HIEP, IOAH)

// Set IRQ
        FindSetRightBit(IRQE, Local0)
        Subtract(Local0, 1, INTR)

// Set DMA
        If(DMAE)
        {
                FindSetRightBit(DMAE, Local0)
                Subtract(Local0, 1, DMCH)
        }
        Else    // No DMA
        {
                Store(4, DMCH)
        }


        Store(One, ACTR)        // Enable ACTR
        EXFG()                  // Exit Config Mode
}                               // End of _SRS Method
// End //////////////////////////////////////////////////////////

// IR Port definitions
        Name(CNBF, Buffer() {0xF8, 0x3})// Buffer to provide word/byte access
                                        // to UART2 base address
// Device's Base address detecting
// Arg0 - has a proper LDN
        Method(UABS, 1) {

        ENFG()
        Store(Arg0, LDN)                // Select Appropriate LDN

        CreateByteField(CNBF, 0, IOLO)
        CreateByteField(CNBF, 1, IOHI)
        CreateWordField(CNBF, 0, IOAD)
        Store(IOAL, IOLO)
        Store(IOAH, IOHI)

        EXFG()
        Return(IOAD)
        }

//---------Power Resources for UART1 -------------------------
        Name(CSCP, 0)                   // Power state status
   PowerResource(URP1, 1, 0) {   // SystemLevel Parameter=0,
                                                // which means UART can be turned off
                                                // in any sleep state
                Method(_STA, 0) {
                        Return(CSCP)            // Get Power Status
                }                               // end of _STA
                Method(_ON) {
//         Store(LDU1, LDN)  // Enable ACTivate register
//         Store(1, ACTR)
                        Store(1, CSCP)
                }                               // end of _ON
                Method(_OFF){
//         Store(LDU1, LDN)  // Disable ACTivate register
//         Store(0, ACTR)
                        Store(0, CSCP)
                }                               // end of _OFF
        }
//---------Power Resources for UART2 -------------------------
        PowerResource(URP2, 0, 0) {     // SystemLevel Parameter=0,
                                        // which means UART can be turned off
                                        // in any sleep state
                                        // in any sleep state
                Method(_STA, 0) {
                        Return(CSCP)            // Get Power Status
                }                               // end of _STA
                Method(_ON) {
                        Store(1,CSCP)
                }                               // end of _ON
                Method(_OFF){
                        Store(0,CSCP)
                }                               // end of _OFF
        }
//---------Power Resources for FDD -------------------------
        PowerResource(FDDP, 0, 0) {     // SystemLevel Parameter=0,
                                        // which means FDD can be turned off
                                        // in any sleep state
                                        // in any sleep state
                Method(_STA, 0) {
                        Return(CSCP)            // Get Power Status
                }                               // end of _STA
                Method(_ON) {
                        Store(1,CSCP)
                }                               // end of _ON
                Method(_OFF){
                        Store(0,CSCP)
                }                               // end of _OFF
        }
//---------Power Resources for LPT -------------------------
        PowerResource(LPTP, 0, 0) {     // SystemLevel Parameter=0,
                                        // which means LPT can be turned off
                                        // in any sleep state
                                        // in any sleep state
                Method(_STA, 0) {
                        Return(CSCP)            // Get Power Status
                }                               // end of _STA
                Method(_ON) {
                        Store(1,CSCP)
                }                               // end of _ON
                Method(_OFF){
                        Store(0,CSCP)
                }                               // end of _OFF
        }

/// end Power resources /////////
//////////////////////////////////////////////////////////////////
// Generic devices Current Resources Buffers /////////////////////
//////////////////////////////////////////////////////////////////

// FDC Current Resource Settings (to be returned by _CRS)
        Name(FCRS, ResourceTemplate() {
                IO(Decode16, 0x3f2, 0x3f2, 1, 2, FCP1)
                IO(Decode16, 0x3f4, 0x3f4, 1, 2, FCP2)
                IO(Decode16, 0x3f7, 0x3f7, 1, 1, FCP3)
                IRQNoFlags(FCI1) {6}
                DMA(Compatibility, NotBusMaster, Transfer8, FCD1) {2}
        })

// Ports (COMx and LPT) Current Resource Settings
// (to be initialized and returned by _CRSreturned by COMx._CRS/LPT._CRS)
        Name(PBUF, ResourceTemplate() {
                IO(Decode16, 0, 0, 1, 8, PBP1)
                IRQNoFlags(PBI1) {0}
        })

// ECP DEVICE Current Resource Settings
        Name(EBUF, ResourceTemplate() {
                IO(Decode16, 0x378, 0x378, 1, 8, EBP1)
                IO(Decode16, 0x778, 0x778, 1, 4, EBP2)
                IRQNoFlags(EBI1) {7}
                DMA(Compatibility, NotBusMaster, Transfer8, EBD1) {}
        })

//////////////////////////////////////////////////////////////////
// Generic devices Possible Resources Buffers ////////////////////
//////////////////////////////////////////////////////////////////

// FDC Possible Resources
        Name(FPRS, ResourceTemplate() {
                StartDependentFn(0, 0) {
                        IO(Decode16, 0x3f2, 0x3f2, 1, 2)
                        IO(Decode16, 0x3f4, 0x3f4, 1, 2)
                        IO(Decode16, 0x3f7, 0x3f7, 1, 1)
                        IRQNoFlags() {6}
                        DMA(Compatibility, NotBusMaster, Transfer8) {2}
                }
                EndDependentFn()
        })

// UART1 Possible Resources
        Name(C1PR, ResourceTemplate() {
                StartDependentFn(0, 0) {
                        IO(Decode16, 0x3f8, 0x3f8, 4, 8)
                        IRQNoFlags() {4}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x3f8, 0x3f8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x2f8, 0x2f8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x3e8, 0x3e8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x2e8, 0x2e8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                EndDependentFn()
        })

// UART2 Possible Resources
        Name(C2PR, ResourceTemplate() {
                StartDependentFn(0, 0) {
                        IO(Decode16, 0x2f8, 0x2f8, 4, 8)
                        IRQNoFlags() {3}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x2f8, 0x2f8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x3f8, 0x3f8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x3e8, 0x3e8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x2e8, 0x2e8, 4, 8)
                        IRQNoFlags() {3,4,10,11}
                }
                EndDependentFn()
        })

// LPT Possible Resources
        Name(LPPR, ResourceTemplate() {
                StartDependentFn(0, 0) {
                        IO(Decode16, 0x378, 0x378, 1, 8)
                        IRQNoFlags() {7}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x378, 0x378, 1, 8)
                        IRQNoFlags() {5, 7}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x278, 0x278, 1, 8)
                        IRQNoFlags() {5, 7}
                }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x3bc, 0x3bc, 1, 4)
                        IRQNoFlags() {5, 7}
                }
                EndDependentFn()
        })

// ECP Possible Resources
        Name(EPRS, ResourceTemplate() {
                StartDependentFn(0, 0) {
                        IO(Decode16, 0x378, 0x378, 1, 8)
                        IO(Decode16, 0x778, 0x778, 1, 4)
                        IRQNoFlags() {7}
                        DMA(Compatibility, NotBusMaster, Transfer8) {1}
                        }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x378, 0x378, 1, 8)
                        IO(Decode16, 0x778, 0x778, 1, 4)
                        IRQNoFlags() {5, 7}
                        DMA(Compatibility, NotBusMaster, Transfer8) {0, 1, 3}
                        }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x278, 0x278, 1, 8)
                        IO(Decode16, 0x678, 0x678, 1, 4)
                        IRQNoFlags() {5, 7}
                        DMA(Compatibility, NotBusMaster, Transfer8) {0, 1, 3}
                        }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x3bc, 0x3bc, 1, 4)
                        IO(Decode16, 0x7bc, 0x7bc, 1, 4)
                        IRQNoFlags() {5, 7}
                        DMA(Compatibility, NotBusMaster, Transfer8) {0, 1, 3}
                }
// No DMA
                StartDependentFnNoPri() {
                        IO(Decode16, 0x378, 0x378, 1, 8)
                        IO(Decode16, 0x778, 0x778, 1, 4)
                        IRQNoFlags() {5, 7}
                        DMA(Compatibility, NotBusMaster, Transfer8) {}
                        }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x278, 0x278, 1, 8)
                        IO(Decode16, 0x678, 0x678, 1, 4)
                        IRQNoFlags() {5, 7}
                        DMA(Compatibility, NotBusMaster, Transfer8) {}
                        }
                StartDependentFnNoPri() {
                        IO(Decode16, 0x3bc, 0x3bc, 1, 4)
                        IO(Decode16, 0x7bc, 0x7bc, 1, 4)
                        IRQNoFlags() {5, 7}
                        DMA(Compatibility, NotBusMaster, Transfer8) {}
                }
                EndDependentFn()
        })
