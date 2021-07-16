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

// Start of Definitions for WIN877 super I/O device


OperationRegion (WIN1,		// name of Operation Region for SuperIO device
		SystemIO,	// type of address space
		SPIO,		// offset to start of region
				// (default offset for SuperIO device)
				// (Real systems will likely have the BIOS relocate this device
				// to avoid conflicts with secondary floppy ID of 0x370)
				
		2)  		//size of region in bytes
				//end of Operation Region
				
Field (	WIN1,		//fields are in this Operation Region
	ByteAcc,
	NoLock,
	Preserve)
		{
		INDX,8,	//field named INDX is b bits wide
		DATA,8	//field DATA is 8 bits wide
		}

IndexField (		INDX,			// Index name
			DATA,			// Name of I/O port
			ByteAcc,
			NoLock,
			Preserve)
			{
			CR00,8,
			CR01,8,
			CR02,8,
			CR03,8,
			CR04,8,
			CR05,8,
			CR06,8,
			CR07,8,
			CR08,8,
			CR09,8,
			CR0A,8,
			CR0B,8,
			CR0C,8,
			CR0D,8,
			CR0E,8,
			CR0F,8,
			CR10,8,
			CR11,8,
			CR12,8,
			CR13,8,
			CR14,8,
			CR15,8,
			CR16,8,
			CR17,8,
			CR18,8,
			CR19,8,
			CR1A,8,
			CR1B,8,
			CR1C,8,
			CR1D,8,
			CR1E,8,
			CR1F,8,
			CR20,8,
			CR21,8,
			CR22,8,
			CR23,8,
			CR24,8,
			CR25,8,
			CR26,8,
			CR27,8,
			CR28,8,
			CR29,8,
		} //end of indexed field
		

	Method(ENFG,0){			// Enter Config Mode for 
	Store(0x87,INDX)
	Store(0x87,INDX)
	}

	Method(EXFG,0){			// Enter Config Mode for 
	Store(0xAA,INDX)
	}

	Name(FDST,0)
	Name(U1ST,0)
	Name(U2ST,0)
	Name(IRST,0)
	Name(LPST,0)
	Name(EPST,0)

	Method(IODT)			// Start up code to detect
	{					// the presence of Super IO devices
		ENFG()
// FDC
		If(CR20)			// Get device status
		{
			Store(1, FDST)	// device present
		}
// UART 1
		If(CR24)			// Get device status
		{
			Store(1, U1ST)	// device present
		}
// UART 2

		If(CR25)			// Get device status
		{
			Store(1, U2ST)	// Get the UART Mode
		}
// LPT,ECP
		If(CR23)			// Get device status
		{
			Store(1, LPST)	// device present
		}

		EXFG()
	}

	Method(_INI,0)			// Method would be called once during OS boot up
	{
		IODT()
	}

//---------Power Resources for UART1 -------------------------
	Name(CSCP, 0)			// Power state status
   PowerResource(URP1, 1, 0) {   // SystemLevel Parameter=0,
						// which means UART can be turned off
						// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
//         Store(LDU1, LDN)  // Enable ACTivate register
//         Store(1, ACTR)
			Store(1, CSCP)
		}				// end of _ON
		Method(_OFF){
//         Store(LDU1, LDN)  // Disable ACTivate register
//         Store(0, ACTR)
			Store(0, CSCP)
		}				// end of _OFF
	}
//---------Power Resources for UART2 -------------------------
	PowerResource(URP2, 1, 0) {     // SystemLevel Parameter=0,
					// which means UART can be turned off
					// in any sleep state
					// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
			Store(1,CSCP)
		}				// end of _ON
		Method(_OFF){
			Store(0,CSCP)
		}				// end of _OFF
	}
//---------Power Resources for FDD -------------------------
	PowerResource(FDDP, 0, 0) {     // SystemLevel Parameter=0,
					// which means FDD can be turned off
					// in any sleep state
					// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
			Store(1,CSCP)
		}				// end of _ON
		Method(_OFF){
			Store(0,CSCP)
		}				// end of _OFF
	}
//---------Power Resources for LPT -------------------------
	PowerResource(LPTP, 0, 0) {     // SystemLevel Parameter=0,
					// which means LPT can be turned off
					// in any sleep state
					// in any sleep state
		Method(_STA, 0) {
			Return(CSCP)		// Get Power Status
		}				// end of _STA
		Method(_ON) {
			Store(1,CSCP)
		}				// end of _ON
		Method(_OFF){
			Store(0,CSCP)
		}				// end of _OFF
	}

/// end Power resources /////////

// Floppy Disk Controller 

Device(FDC0) {  					

	Name(_HID, EISAID("PNP0700"))		// PnP Device ID
	
// Status

	Method(_STA,0){		
				
	// Enter Config Mode
	ENFG()	

	If(CR20)
	{
		EXFG()	
		Return(0xf)		// PRESENT & ACTIVE
	}
	Else
	{
		EXFG()	
		Return(1)		// All Bits ZERO
	}
	
	} 					// End _STA method


// Disable 

	Method(_DIS,0){		
	
	ENFG()	

	// Disable FDC
	Store(Zero,CR20)
			
	EXFG()	

	} 					// End _DIS method


// Current Resource Settings

	Method(_CRS,0){		
	
	Name(BUF0,Buffer()
		{
			0x47,		//IO Port Descriptor	Offset 0
			0x01,		//16 bit decode
                        0xF2,           //IO Port Range Minimum Base Low
			0x03,		//IO Port Range Minimum Base High
                        0xF2,           //IO Port Range Maximum Base LOW
			0x03,		//IO Port Range Maximum Base High
			0x01,           //Base Alignment
                        0x02,           //Length of contiguous IO Ports
                
			0x47,		//IO Port Descriptor	 Offset 8
			0x01,		//16 bit decode
                        0xF4,           //IO Port Range Minimum Base Low
			0x03,		//IO Port Range Minimum Base High
                        0xF4,           //IO Port Range Maximum Base LOW
			0x03,		//IO Port Range Maximum Base High
			0x01,           //Base Alignment
                        0x02,           //Length of contiguous IO Ports
                     
			0x47,		//IO Port Descriptor	 Offset 10
			0x01,		//16 bit decode
                        0xF7,           //IO Port Range Minimum Base Low
			0x03,		//IO Port Range Minimum Base High
                        0xF7,           //IO Port Range Maximum Base LOW
			0x03,		//IO Port Range Maximum Base High
			0x01,           //Base Alignment
                        0x01,           //Length of contiguous IO Ports

			0x22,		//IRQ Descriptor       Offset 18
			0x40,		//IRQ Mask Lo=bit 6
			0x00,		//IRQ Mask High

			0x2A,		//DMA Descriptor     Offset 1B
                        0x04,           //DMA Mask CH2
			0x00,		//DMA Channel Speed Support

			0x79,		//end tag
			0x00,
		})

	CreateByteField (BUF0, 0x02, IOLO)	// IO Port Low
	CreateByteField (BUF0, 0x03, IOHI)	// IO Port Hi
	CreateByteField (BUF0, 0x04, IORL)	// Range Low
	CreateByteField (BUF0, 0x05, IORH)	// Range Hi
	CreateByteField (BUF0, 0x19, IRQL)	// IRQ low
	CreateByteField (BUF0, 0x1C, DMAV)	// DMA
	
	ENFG()
	
	// Write Current Settings into IO descriptor
	
	If(CR20)
	{
		Store(0xf2, IOLO)
		Store(0x03, IOHI)
		Store(IOLO, IORL)
		Store(IOHI, IORH)
	}

	// Write Current Settings into IRQ descriptor
	ShiftRight(CR29,4,Local3)
	Store(One,Local0)
	ShiftLeft(Local0,Local3,IRQL)

	// Write Current Settings into DMA descriptor
	ShiftRight(CR26,4,Local3)
	Store(One,Local0)
	ShiftLeft(Local0,Local3,DMAV)
	
	EXFG()

	Return(BUF0)				// Return Buffer 
	
	} 					// End _CRS method
	
// Possible Resource Settings
	
	Name(_PRS,Buffer()	
		       {
			0x30,		// Start Dependent Function
			
			0x47,		//IO Port Descriptor	Offset 0
			0x01,		//16 bit decode
                        0xF2,           //IO Port Range Minimum Base Low
			0x03,		//IO Port Range Minimum Base High
                        0xF2,           //IO Port Range Maximum Base LOW
			0x03,		//IO Port Range Maximum Base High
			0x01,           //Base Alignment
                        0x02,           //Length of contiguous IO Ports
                
			0x47,		//IO Port Descriptor	 Offset 8
			0x01,		//16 bit decode
                        0xF4,           //IO Port Range Minimum Base Low
			0x03,		//IO Port Range Minimum Base High
                        0xF4,           //IO Port Range Maximum Base LOW
			0x03,		//IO Port Range Maximum Base High
			0x01,           //Base Alignment
                        0x02,           //Length of contiguous IO Ports
                     
			0x47,		//IO Port Descriptor	 Offset 10
			0x01,		//16 bit decode
                        0xF7,           //IO Port Range Minimum Base Low
			0x03,		//IO Port Range Minimum Base High
                        0xF7,           //IO Port Range Maximum Base LOW
			0x03,		//IO Port Range Maximum Base High
			0x01,           //Base Alignment
                        0x01,           //Length of contiguous IO Ports

			0x22,		//IRQ Descriptor       Offset 18
			0x40,		//IRQ Mask Lo=bit 6
			0x00,		//IRQ Mask High

			0x2A,		//DMA Descriptor     Offset 1B
                        0x04,           //DMA Mask CH2
			0x00,		//DMA Channel Speed Support

			0x38,		// End Dependent Function
			
			0x79,		// End Tag
			0x00,
			
			})			// End _PRS method
		
		

// Set Resource Settings

	Method(_SRS,1){		
	
	// ARG0 = PnP Resource String to set
	
	CreateByteField (ARG0, 0x02, IOLO)	// IO Port Low
	CreateByteField (ARG0, 0x03, IOHI)	// IO Port High
	CreateWordField (ARG0, 0x19, IRQL)	// IRQ low
	CreateByteField (ARG0, 0x1C, DMAV)	// DMA

	ENFG()	

	// Set Base IO Address
//	If (IOLO)
//	{
//		Store(0xfc, IOAH)
//	}

	// Set IRQ
	FindSetRightBit(IRQL,Local0)
	Subtract(Local0,1,Local0)
	ShiftRight(Local0,4,Local0)
	And(CR29,0xf0,Local5)
	Or(Local0,Local5,CR29)

		  
	// Set DMA
	FindSetRightBit(DMAV,Local0)
	Subtract(Local0,1,Local0)
	ShiftRight(Local0,4,Local0)
	And(CR26,0xf0,Local5)
	Or(Local0,Local5,CR26)
	
	EXFG()		

	}					// End of _SRS Method



}	//end of FDC0
	
// UART1 - COMA

Device(UAR1) {					
	
	Name(_HID, EISAID("PNP0501"))	
	Name(_UID,1)

// Status Method

	Method(_STA,0){		
		
	ENFG()
	
	
	// Is the device functioning?
	// Read Activate Register 
	

	If(CR24)
	{			// Return Device Present and 
				// device Active
		EXFG()			
		Return(0xf)
	}
	Else
	{
		EXFG()			
		Return(1) 	// Device Absent
	}
			
	}				// End _STA method
	


// Disable Method	

	Method(_DIS,0){		
	
// Enable Writes

	ENFG()
		
	// Set Address Register to zero
//	Store(Zero, CR24)
	
	EXFG()

       	} 				// End _DIS method
	       	
// Current Resource Settings

	Method(_CRS,0){				
		
			Name(BUF1,Buffer(){		
				0x47,		// IO Port Descriptor
				0x01,		// 16 bit decode
				0xF8,		// IO Port Range Minimum Base Low
				0x03,		// IO Port Range Minimum Base High
				0xF8,		// IO Port Range Maximum Base LOW
				0x03,		// IO Port Range Maximum Base High
				0x08,		// Base Alignment
				0x08,		// Length of contiguous IO Ports

				0x22,		// IRQ Descriptor
				0x10,		// IRQ Mask Lo=bit 4
				0x00,

				0x79,		// End Tag
				0x00,		// Checksum = 0 Treat as if the 
						// Structure checksummed correctly
				})

		CreateByteField (BUF1, 0x02, IOLO)	// IO Port Low
		CreateByteField (BUF1, 0x03, IOHI)	// IO Port High
		CreateByteField (BUF1, 0x04, IORL)	// IO Range Low
		CreateByteField (BUF1, 0x05, IORH)	// IO Range High
		CreateByteField (BUF1, 0x09, IRQL)	// IRQ Mask
			
	ENFG()	
			
	// Write Current Settings into Buffer for IO Descriptor
      	Store(CR24, Local2)
	If (LEqual(Local2,0xfe))
	{
		Store(0x03, IOHI)
		Store(0xF8, IOLO)
	}
	Else 
	{ 
		If (LEqual(Local2,0xbe))
	  	{
			Store(0x02, IOHI)
			Store(0xF8, IOLO)
		}
		Else
		{
			If (LEqual(Local2,0xfa))
			{
				Store(0x03, IOHI)
				Store(0xE8, IOLO)
			}
			Else
			{
				Store(0x02, IOHI)
				Store(0xE8, IOLO)
			}
		}
	}

	Store(IOLO, IORL)
	Store(IOHI, IORH)
      
	// Write Current Settings into IRQ descriptor
      	Store(One,Local0)
      	Store(CR28,Local5)
	ShiftRight(Local5,4,Local5)
	ShiftLeft(Local0,Local5,IRQL)
	
	EXFG()	

			
	Return(BUF1)				// Return BUF1 
	
	
	} 					// End _CRS method
		

// Possible Resource Settings

	Name(_PRS,Buffer(){		
	
/// First Possible Config 3F8, IRQ 4
		0x30,		// Start Dependent Function
		
		0x47,		// IO Port Descriptor
		0x01,		// 16 bit decode
		0xF8,		// IO Port Base Minimum Low  
		0x03,		// IO Port Base Maximum High 
		0xF8,		// IO Port Range Minimum Low 
		0x03,		// IO Port Range Maximum High
		0x08,		// Base Alignment
		0x08,		// Length of contiguous IO Ports

		0x22,		// IRQ Descriptor
		0x10,		// IRQ Mask 
		0x00,
	
/// Second Possible Config 2F8 IRQ 3
			
		0x30,		// Start Dependent Function     
				                                
		0x47,		// IO Port Descriptor           
		0x01,		// 16 bit decode                
		0xF8,		// IO Port Base Minimum Low     
		0x02,		// IO Port Base Maximum High    
		0xF8,		// IO Port Range Minimum Low    
		0x02,		// IO Port Range Maximum High   
		0x08,		// Base Alignment               
		0x08,		// Length of contiguous IO Ports
				                                
		0x22,		// IRQ Descriptor               
		0x08,		// IRQ Mask                     
		0x00,

/// Third Possible Config 3E8 IRQ 4
			
		0x30,		// Start Dependent Function     
				                                
		0x47,		// IO Port Descriptor           
		0x01,		// 16 bit decode                
		0xE8,		// IO Port Base Minimum Low     
		0x03,		// IO Port Base Maximum High    
		0xE8,		// IO Port Range Minimum Low    
		0x03,		// IO Port Range Maximum High   
		0x08,		// Base Alignment               
		0x08,		// Length of contiguous IO Ports
				                                
		0x22,		// IRQ Descriptor               
		0x10,		// IRQ Mask                     
		0x00,
					

/// Fourth Possible Config 2E8 IRQ 3
			
		0x30,		// Start Dependent Function     
				                                
		0x47,		// IO Port Descriptor           
		0x01,		// 16 bit decode                
		0xE8,		// IO Port Base Minimum Low     
		0x02,		// IO Port Base Maximum High    
		0xE8,		// IO Port Range Minimum Low    
		0x02,		// IO Port Range Maximum High   
		0x08,		// Base Alignment               
		0x08,		// Length of contiguous IO Ports
				                                
		0x22,		// IRQ Descriptor
		0x08,		// IRQ Mask      
		0x00,
		
		0x38,		// End Dependent Function
		
		0x79,		// End Tag
		0x00,		// 

	
	})


// Set Resource Settings

	Method(_SRS,1){
				
	CreateByteField (ARG0, 0x02, IOLO)	// IO Port Low
	CreateByteField (ARG0, 0x03, IOHI)	// IO Port High
	CreateByteField (ARG0, 0x09, IRQL)	// IRQ
		       
	
	ENFG()

	// Set Base IO Address
	If (LEqual(IOHI,0x03))
	{
		If (LEqual(IOLO,0xF8))
		{
			Store(0xfe, CR24)
		}
		Else
		{
			Store(0xfa, CR24)
		}
	}
	Else 
	{ 
		If (LEqual(IOLO,0xF8))
		{
			Store(0xbe, CR24)
		}
		Else
		{
			Store(0xba, CR24)
		}
	}
			
	// Set IRQ
			
	FindSetRightBit(IRQL,Local0)
	Subtract(Local0,1,Local0)
	ShiftLeft(Local0,4,Local0)

      	Store(CR28,Local5)
	And(Local5,0x0f,Local5)
	Or(Local0,Local5,CR28)
			
	EXFG()

	}					// End _SRS Method
	

// RI# Ring Indicate Wake Up on UART1 - Applies only to Desktop Reference TX

//	Method(_PRW,0){			// Wake-up control method
//		Return(10)		// RI is wired to the chipset 
//					// as a wake event
//	}

}			// End of UART1

// UART2 - COMB
// Presently Code only for COM


// COM Control Methods RS232 Operation 

Device(UAR2){		

	Name(_HID,EISAID("PNP0501"))
        Name(_UID,2)                    // Generic ID for COMB
        

// Status  

	Method(_STA,0){			

	// Enable Config
	ENFG()					

	// Is the device functioning?
	// read Activate Register 
					
	If(CR25)
	{			// Return Device Present and 
				// device Active
		EXFG()			
		Return(0xf)
	}
	Else
	{
		EXFG()			
		Return(1) 	// Device Absent
	}

	}				// End _STA method

// Disable 

	Method(_DIS,0){		
		
	// Enable Config
	ENFG()
					
	// Set Address Register to zero
//	Store(Zero, CR25)
	
	EXFG()
	
	} 				// End _DIS method
	

// Current Resource Settings

	Method(_CRS,0){				
		
			Name(BUF1,Buffer(){		
				0x47,		// IO Port Descriptor
				0x01,		// 16 bit decode
				0xF8,		// IO Port Range Minimum Base Low
				0x03,		// IO Port Range Minimum Base High
				0xF8,		// IO Port Range Maximum Base LOW
				0x03,		// IO Port Range Maximum Base High
				0x08,		// Base Alignment
				0x08,		// Length of contiguous IO Ports

				0x22,		// IRQ Descriptor
				0x10,		// IRQ Mask Lo=bit 4
				0x0,

				0x79,		// End Tag
				0x00,		// Checksum = 0 Treat as if the 
						// Structure checksummed correctly
				})

		CreateByteField (BUF1, 0x02, IOLO)	// IO Port Low
		CreateByteField (BUF1, 0x03, IOHI)	// IO Port High
		CreateByteField (BUF1, 0x04, IORL)	// IO Range Low
		CreateByteField (BUF1, 0x05, IORH)	// IO Range High
		CreateByteField (BUF1, 0x09, IRQL)	// IRQ Mask
			
	ENFG()	
			
	// Write Current Settings into Buffer for IO Descriptor
      	Store(CR25, Local2)
	If (LEqual(Local2,0xfe))
	{
		Store(0x03, IOHI)
		Store(0xF8, IOLO)
	}
	Else 
	{ 
		If (LEqual(Local2,0xbe))
	  	{
			Store(0x02, IOHI)
			Store(0xF8, IOLO)
		}
		Else
		{
			If (LEqual(Local2,0xfa))
			{
				Store(0x03, IOHI)
				Store(0xE8, IOLO)
			}
			Else
			{
				Store(0x02, IOHI)
				Store(0xE8, IOLO)
			}
		}
	}

	Store(IOLO, IORL)
	Store(IOHI, IORH)
      
	// Write Current Settings into IRQ descriptor
      	Store(One,Local0)
      	Store(CR28,Local5)
	And(Local5,0x0f,Local5)
	ShiftLeft(Local0,Local5,IRQL)

	EXFG()

	Return(BUF1)				// Return BUF1 
			
	} 					// End _CRS method
		

// Possible Resource Settings

	Name(_PRS,Buffer(){		
	
/// First Possible Config 3F8, IRQ 4
		0x30,		// Start Dependent Function
		
		0x47,		// IO Port Descriptor
		0x01,		// 16 bit decode
		0xF8,		// IO Port Base Minimum Low  
		0x03,		// IO Port Base Maximum High 
		0xF8,		// IO Port Range Minimum Low 
		0x03,		// IO Port Range Maximum High
		0x08,		// Base Alignment
		0x08,		// Length of contiguous IO Ports

		0x22,		// IRQ Descriptor
		0x10,		// IRQ Mask 
		0x00,
	
/// Second Possible Config 2F8 IRQ 3
			
		0x30,		// Start Dependent Function     
				                                
		0x47,		// IO Port Descriptor           
		0x01,		// 16 bit decode                
		0xF8,		// IO Port Base Minimum Low     
		0x02,		// IO Port Base Maximum High    
		0xF8,		// IO Port Range Minimum Low    
		0x02,		// IO Port Range Maximum High   
		0x08,		// Base Alignment               
		0x08,		// Length of contiguous IO Ports
				                                
		0x22,		// IRQ Descriptor               
		0x08,		// IRQ Mask                     
		0x00,

/// Third Possible Config 3E8 IRQ 4
			
		0x30,		// Start Dependent Function     
				                                
		0x47,		// IO Port Descriptor           
		0x01,		// 16 bit decode                
		0xE8,		// IO Port Base Minimum Low     
		0x03,		// IO Port Base Maximum High    
		0xE8,		// IO Port Range Minimum Low    
		0x03,		// IO Port Range Maximum High   
		0x08,		// Base Alignment               
		0x08,		// Length of contiguous IO Ports
				                                
		0x22,		// IRQ Descriptor               
		0x10,		// IRQ Mask                     
		0x00,
					

/// Fourth Possible Config 2E8 IRQ 3
			
		0x30,		// Start Dependent Function     
				                                
		0x47,		// IO Port Descriptor           
		0x01,		// 16 bit decode                
		0xE8,		// IO Port Base Minimum Low     
		0x02,		// IO Port Base Maximum High    
		0xE8,		// IO Port Range Minimum Low    
		0x02,		// IO Port Range Maximum High   
		0x08,		// Base Alignment               
		0x08,		// Length of contiguous IO Ports
				                                
		0x22,		// IRQ Descriptor
		0x08,		// IRQ Mask      
		0x00,
		
		0x38,		// End Dependent Function
		
		0x79,		// End Tag
		0x00,		// 

	
	})

// Set Resource Settings

	Method(_SRS,1){		
				
	CreateByteField (ARG0, 0x02, IOLO)	// IO Port Low
	CreateByteField (ARG0, 0x03, IOHI)	// IO Port High
	CreateByteField (ARG0, 0x09, IRQL)	// IRQ
		       
	
	ENFG()	

	// Set Base IO Address
	If (LEqual(IOHI,0x03))
	{
		If (LEqual(IOLO,0xF8))
		{
			Store(0xfe, CR25)
		}
		Else
		{
			Store(0xfa, CR25)
		}
	}
	Else 
	{ 
		If (LEqual(IOLO,0xF8))
		{
			Store(0xbe, CR25)
		}
		Else
		{
			Store(0xba, CR25)
		}
	}
			
	// Set IRQ
			
	FindSetRightBit(IRQL,Local0)
	Subtract(Local0,1,Local0)

      	Store(CR28,Local5)
	And(Local5,0xf0,Local5)
	Or(Local0,Local5,CR28)
			
	EXFG()

	}					// End _SRS Method


}						// End of COMB

// ECP DEVICE

Device(ECP) {

	Name (_HID, EISAID("PNP0401"))	// PnP ID ECP Port
	

	// ECP Device Status  
	
	Method (_STA, 0) {		
	
	ENFG()

	And(CR09, 0x80, Local0)
	And(CR00, 0x08, Local1)
	If(LAnd(Local1, Local0))
	{
		If(CR23)
		{
			EXFG()			
			Return(0xf)	// Return Device Present and device Active
		}
		Else
		{
			EXFG()			
			Return(0x1)	// Return Device Present and Disable
		}
	}
	Else
	{
	EXFG()			
	Return(0) 	// Device Absent
	}
	} 				// End of _STA Method
	

	// Device Disable 
	
	Method (_DIS) {			
	
	ENFG()

	Store (Zero, CR23)	// Set Activate Reg = 0
	
	EXFG()	
	
	} 				// End of _DIS Method

// Current Resource Settings 
	 
	Method (_CRS) {			

		Name(BUF6,Buffer(){
			0x47,			// IO Port Descriptor
			0x01,			// 16 bit decode
			0x00,			// 
			0x00,
			0x00,			
			0x00,

			0x01,			// Alignment
			0x08,			// Number of ports
			
			0x47,			// IO port descriptor
                        0x01,                   // 16 bit decode
			0x00,			// LPT1 @ 0x778h
			0x00,
			0x00,
			0x00,
			
			0x01,			// Alignment
			0x04,			// Number of Ports

			0x22,			// IRQ Descriptor
			0x00,			// 
			0x00,			//

			0x2A,			// DMA Descriptor
			0x00,			// 
			0x00,			// 

			0x79,			// End Tag
			0x00,
		})


	CreateByteField (BUF6, 0x02, IOLO)	// IO Port Low
	CreateByteField (BUF6, 0x03, IOHI)	// IO Port Hi 
	CreateByteField (BUF6, 0x04, IORL)	// Range Low
	CreateByteField (BUF6, 0x05, IORH)	// Range Hi
	CreateByteField (BUF6, 0x07, IOLG)	// Length
	CreateByteField (BUF6, 0x0a, EIOL)	// IO Port Low
	CreateByteField (BUF6, 0x0b, EIOH)	// IO Port Hi 
	CreateByteField (BUF6, 0x0c, IOLE)	// Range Low
	CreateByteField (BUF6, 0x0d, IORE)	// Range Hi

	CreateByteField (BUF6, 0x11, IRQL)	// IRQ
	CreateByteField (BUF6, 0x14, DMAC)
	
	ENFG()

	// Base Address
      	Store(CR23, Local2)
	If (LEqual(Local2,0xde))
	{
		Store(0x78,IOLO)
		Store(0x03,IOHI)
	}
	Else
	{
		If (LEqual(Local2,0xef)) 
		{
			Store(0xBC,IOLO)
			Store(0x03,IOHI)
			Store(0x04,IOLG)
		}
		Else
		{
			Store(0x78,IOLO)
			Store(0x02,IOHI)
		}
	}

	Store(IOLO, IORL)
	Store(IOHI, IORH)
	Store(IOLO, EIOL)
	Store(IOLO, IOLE)
	Add(IOHI, 0x04, EIOH)
	Store(EIOH, IORE)
	
	// IRQ
      	And(CR27,0x0f,Local5)
	If (LEqual(Local5,5))	// 877 IRQ_E is mapped to 8259 IRQ 7
	{
		Store(0x80,IRQL)
	}
	Else
	{
//		If (LEqual(Local5,1))	// 877 IRQ_A is mapped to 8259 IRQ 5
		Store(0x20,IRQL)
	}

	And(CR26,0x0f,Local5)
	If (LEqual(Local5,3))
	{
		Store(0x08,DMAC)		// DMA 3
	}
	Else
	{
		If (LEqual(Local5,2))
		{
			Store(0x02,DMAC)	// DMA 1
		}
		Else
		{
			Store(0x01,DMAC)	// DMA 0
		}
	}


	EXFG()
					
	Return(BUF6)				// Return BUF6 
		
	}					// End _CRS method
	

// Possible Resource Settings

	Name(_PRS, Buffer(){
	
//-------------------------- 1st Set
		
			0x30,			// Dependent Function Start

			0x47,			// IO port descriptor
			0x01,			// 16 Bit Decode
			0x78,			// LPT1 @ 0x378h
                        0x03,
			0x78,
                        0x03,

			0x01,			// Alignment
			0x08,			// Number of Ports

			0x47,			// IO port descriptor
			0x01,			// 16 bit decode
			0x78,			// LPT1 @ 0x778h
			0x07,
			0x78,
			0x07,

			0x01,			// Alignment
			0x04,			// Number of Ports

			0x22,			// IRQ Descriptor
			0xA0,			// IRQ7,5 
			0x00,

			0x2A,			// DMA Descriptor
                        0x0B,                   // DMA 
			0x00,			// 8-bit,not a Bus Master, 
						// Compatibility Mode Chn Spd
//-------------------------- 2nd Set

			0x30,			// Dependent Function Start

			0x47,			// IO port descriptor
			0x01,			// 16 Bit Decode
			0x78,			// LPT1 @ 0x278h
                        0x02,
			0x78,
                        0x02,

			0x01,			// Alignment
			0x08,			// Number of Ports

			0x47,			// IO port descriptor
			0x01,			// 16 bit decode
			0x78,			// LPT1 @ 0x678h
			0x06,
			0x78,
			0x06,

			0x01,			// Alignment
			0x04,			// Number of Ports

			0x22,			// IRQ Descriptor
			0xA0,			// IRQ7,5 
			0x00,

			0x2A,			// DMA Descriptor
                        0x0B,                   // DMA 
			0x00,			// 8-bit,not a Bus Master, 
						// Compatibility Mode Chn Spd

//-------------------------- 3nd Set

			0x30,			// Dependent Function Start

			0x47,			// IO port descriptor
			0x01,			// 16 Bit Decode
			0xBC,			// LPT1 @ 0x3BCh
                        0x03,
			0xBC,
                        0x03,

			0x01,			// Alignment
			0x04,			// Number of Ports

			0x47,			// IO port descriptor
			0x01,			// 16 bit decode
			0xBC,			// LPT1 @ 0x7BCh
			0x07,
			0xBC,
			0x07,

			0x01,			// Alignment
			0x04,			// Number of Ports

			0x22,			// IRQ Descriptor
			0xA0,			// IRQ7,5 
			0x00,

			0x2A,			// DMA Descriptor
                        0x0B,                   // DMA 
			0x00,			// 8-bit,not a Bus Master, 
						// Compatibility Mode Chn Spd

                        0x38,                   // End Dependent Function

			0x79,			// End Tag
			0x00,
			}) // End buffer

// Set Resource Settings

	Method ( _SRS,1 ) {		
	


	CreateByteField (ARG0, 0x02, IOLO)	// IO Port Low
	CreateByteField (ARG0, 0x03, IOHI)	// IO Port Hi
	CreateByteField (ARG0, 0x11, IRQL)	// IRQ
	CreateByteField (ARG0, 0x14, DMAC)	// DMA Channel 

	// Set the requested resources on the device

	ENFG()
	
	// Set Base IO Address
	If (LEqual(IOHI,0x03))
	{
		If (LEqual(IOLO,0x78))
		{
			Store(0xde, CR23)	// 378
		}
		Else
		{
			Store(0xef, CR23)	// 3bc
		}
	}
	Else
	{
		Store(0x9e, CR23)	// 278
	}
			
	// Set IRQ
	And(CR27,0xf0,Local0)
	If (LEqual(IRQL,0x80))		// IRQ 7
	{
		Or(Local0,0x05,CR27)
	}
	Else
	{
		Or(Local0,0x01,CR27)
	}


	// Set DMA
	And(CR26,0xf0,Local0)
	If (LEqual(DMAC,0x08))
	{
		Or(Local0,0x03,CR26)	// DMA 3
	}
	Else
	{
		If (LEqual(DMAC,0x02))
		{
			Or(Local0,0x02,CR26)	// DMA 1
		}
		Else
		{
			Or(Local0,0x01,CR26)	// DMA 0
		}
	}

	EXFG()

	} 					// End _SRS Method

} 						// End ECP Device

// LPT DEVICE

Device(LPT) {

	Name (_HID, EISAID("PNP0400"))	// PnP ID LPT Port
	

	// LPT Device Status  
	
	Method (_STA, 0) {		
	
	ENFG()
	
	And(CR09, 0x80, Local0)
	And(CR00, 0x08, Local1)
	If(LAnd(Local1, Local0))
	{
	EXFG()			
	Return(0) 	// Device Absent
	}
	Else
	{
		If(CR23)
		{
			EXFG()			
			Return(0xf)	// Return Device Present and device Active
		}
		Else
		{
			EXFG()			
			Return(0x1)	// Return Device Present and Disable
		}
	}
	} 				// End of _STA Method
	

	// Device Disable 
	
	Method (_DIS) {			
	
	ENFG()

	Store (Zero, CR23)	// Set Activate Reg = 0
	
	EXFG()	
	
	} 				// End of _DIS Method

// Current Resource Settings 
	 
	Method (_CRS) {			

		Name(BUF6,Buffer(){
			0x47,			// IO Port Descriptor
			0x01,			// 16 bit decode
			0x00,			// 
			0x00,
			0x00,			
			0x00,

			0x01,			// Alignment
			0x08,			// Number of ports
			
			0x22,			// IRQ Descriptor
			0x00,			// 
			0x00,			//

			0x79,			// End Tag
			0x00,
		})


	CreateByteField (BUF6, 0x02, IOLO)	// IO Port Low
	CreateByteField (BUF6, 0x03, IOHI)	// IO Port Hi 
	CreateByteField (BUF6, 0x04, IORL)	// Range Low
	CreateByteField (BUF6, 0x05, IORH)	// Range Hi
	CreateByteField (BUF6, 0x07, IOLG)	// Length

	CreateByteField (BUF6, 0x09, IRQL)	// IRQ
	
	ENFG()

	// Base Address
      	Store(CR23, Local2)
	If (LEqual(Local2,0xde))
	{
		Store(0x78,IOLO)
		Store(0x03,IOHI)
	}
	Else
	{
		If (LEqual(Local2,0xef)) 
		{
			Store(0xBC,IOLO)
			Store(0x03,IOHI)
			Store(0x04,IOLG)
		}
		Else
		{
			Store(0x78,IOLO)
			Store(0x02,IOHI)
		}
	}

	Store(IOLO, IORL)
	Store(IOHI, IORH)
	
	// IRQ
      	And(CR27,0x0f,Local5)
	If (LEqual(Local5,5))	// 877 IRQ_E is mapped to 8259 IRQ 7
	{
		Store(0x80,IRQL)
	}
	Else
	{
//		If (LEqual(Local5,1))	// 877 IRQ_A is mapped to 8259 IRQ 5
		Store(0x20,IRQL)
	}

	EXFG()
					
	Return(BUF6)				// Return BUF6 
		
	}					// End _CRS method
	

// Possible Resource Settings

	Name(_PRS, Buffer(){
	
//-------------------------- 1st Set
		
			0x30,			// Dependent Function Start

			0x47,			// IO port descriptor
			0x01,			// 16 Bit Decode
			0x78,			// LPT1 @ 0x378h
                        0x03,
			0x78,
                        0x03,

			0x01,			// Alignment
			0x08,			// Number of Ports

			0x22,			// IRQ Descriptor
			0xA0,			// IRQ7,5 
			0x00,

//-------------------------- 2nd Set

			0x30,			// Dependent Function Start

			0x47,			// IO port descriptor
			0x01,			// 16 Bit Decode
			0x78,			// LPT1 @ 0x278h
                        0x02,
			0x78,
                        0x02,

			0x01,			// Alignment
			0x08,			// Number of Ports

			0x22,			// IRQ Descriptor
			0xA0,			// IRQ7,5 
			0x00,

//-------------------------- 3nd Set

			0x30,			// Dependent Function Start

			0x47,			// IO port descriptor
			0x01,			// 16 Bit Decode
			0xbc,			// LPT1 @ 0x3BCh
                        0x03,
			0xbc,
                        0x03,

			0x01,			// Alignment
			0x04,			// Number of Ports

			0x22,			// IRQ Descriptor
			0xA0,			// IRQ7,5 
			0x00,

                        0x38,                   // End Dependent Function

			0x79,			// End Tag
			0x00,
			}) // End buffer

// Set Resource Settings

	Method ( _SRS,1 ) {		
	


	CreateByteField (ARG0, 0x02, IOLO)	// IO Port Low
	CreateByteField (ARG0, 0x03, IOHI)	// IO Port Hi
	CreateByteField (ARG0, 0x09, IRQL)	// IRQ

	// Set the requested resources on the device

	ENFG()
	
	// Set Base IO Address
	If (LEqual(IOHI,0x03))
	{
		If (LEqual(IOLO,0x78))
		{
			Store(0xde, CR23)	// 378
		}
		Else
		{
			Store(0xef, CR23)	// 3bc
		}
	}
	Else
	{
		Store(0x9e, CR23)	// 278
	}
			
	// Set IRQ
	And(CR27,0xf0,Local0)
	If (LEqual(IRQL,0x80))		// IRQ 7
	{
		Or(Local0,0x05,CR27)
	}
	Else
	{
		Or(Local0,0x01,CR27)
	}


	EXFG()

	} 					// End _SRS Method

} 						// End ECP Device

// End of WIN877
