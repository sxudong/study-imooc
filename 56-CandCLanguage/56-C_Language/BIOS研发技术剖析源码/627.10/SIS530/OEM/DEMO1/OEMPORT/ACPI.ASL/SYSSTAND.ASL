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
//		System standard resources
//**********************************************************************;

Device(PIC) {				// 8259 PIC
	Name(_HID,EISAID("PNP0000"))	// Hardware Device ID

	Method (_STA, 0)
	{

	If(OSFL)		// If running under Win98?
		{
		Return(0x0f)	// Device present
		}
	Return(0x0)		// Not present

	}

	Name(_CRS,
	ResourceTemplate()
	{
	FixedIO(0x20, 2)
	FixedIO(0xA0, 2)
//        IRQ(Edge, ActiveHigh, Exclusive ){2}
	IRQNoFlags(){2}
	}
			 )              // End of _CRS

		}			// End of PIC

Device(DMAD) {                                  // 8257 DMA
	Name(_HID,EISAID("PNP0200"))	// Hardware Device ID

	Name(_CRS,

	ResourceTemplate()
	{
	DMA(Compatibility, BusMaster, Transfer8) {4}
	FixedIO(0x00, 0x10)
	FixedIO(0x81, 3)
	FixedIO(0x87, 1)
	FixedIO(0x89, 3)
	FixedIO(0x8f, 1)
	FixedIO(0xC0, 0x20)
        }
                        )               // End of _CRS

		}			// End of DMA

Device(TMR) {					// Timer
        Name(_HID,EISAID("PNP0100"))            // Hardware Device ID

	Name(_CRS,

        ResourceTemplate()
        {
	FixedIO(0x40, 4)
        IRQNoFlags(){0}
			})		// End of _CRS


}					// End of TMR

	Device(RTC) {		// Real Time Clock Device
	Name(_HID, EISAID("PNP0B00"))		// Hardware Device ID

	Name (_CRS,

	ResourceTemplate()
	{
	FixedIO(0x70, 2)
	IRQNoFlags(){8}
	})
		}					// End RTC

Device(SPKR) {						// Speaker
	Name(_HID,EISAID("PNP0800"))		// Hardware Device ID

	Name(_CRS,
	ResourceTemplate()
	{
	FixedIO(0x61, 1)
        })                               // End of _CRS


}					// End of spkK

Device(COPR) {						// Math Coprocessor Device

	Name(_HID,EISAID("PNP0C04"))		// Hardware Device ID

	Name(_CRS,

	ResourceTemplate()
	{
	FixedIO(0xf0, 0x10)
	IRQNoFlags(){13}
			})		// End of _CRS


}					// End of Math Coprocessor

	OperationRegion(PSRG, SystemMemory, 0x410, 0x1)
	Field(PSRG, DWordAcc, NoLock, Preserve){
	,2,
	PS2E,1,
	}

Device(PS2M) {				// PS2 Mouse Device

   Name(_HID, EISAID("PNP0F03"))  // Hardware Device ID
   Name(_CID, EISAID("PNP0F13"))

	Method(_STA,0){
		If(PS2E) {
			Return(0x0f)	// PS/2 Mouse Present
		}
		Else	{
			Return(0x0)	// PS/2 Mouse not Present
		}
	}
	Name(_CRS,

	ResourceTemplate()
	{
	IRQNoFlags(){12}
	})

}					// End of PS2M

Device(PS2K) {				// PS2 Keyboard Device
//	Name(_HID,EISAID("PNP0303"))	// Standard Keyboard 101/102
	Name(_HID,EISAID("PNP030b"))    // PC/AT Enhanced Keyboard 101/102

	Name(_CRS,
	ResourceTemplate()
	{
	FixedIO(0x60, 1)
	FixedIO(0x64, 1)
	IRQNoFlags(){1}
	})
				       // End of _CRS


}					// End of PS2K
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
