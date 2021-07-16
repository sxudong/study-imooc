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
//	ALI1543 PCI IRQ Links devices
//**********************************************************************;

OperationRegion(PIX0, PCI_Config, 0x48, 0x4)
OperationRegion(PIX1, PCI_Config, 0x74, 0x1)

Scope(\_SB)
{
	Field(PCI0.SBRG.PIX0,ByteAcc,NoLock,Preserve)
	{
		PIRA,4,                 // IRQA route register
		PIRB,4,                 // IRQB route register
		PIRC,4,                 // IRQC route register
		PIRD,4,                 // IRQD route register
                // there can be 4 more E, F, G, H
	}
	Field(PCI0.SBRG.PIX1,ByteAcc,NoLock,Preserve)
	{
		PIRU,4,                 // IRQU route register
	}

// ISA IRQ Routing table
	Name(IRQT, 
		Package()
		{
// ISA IRQ 0    1	  2    3    4	 5    6    7
           0x0, 0x8, 0x0, 0x2, 0x4, 0x5, 0x7, 0x6,
// ISA IRQ 8    9    10   11   12   13   14   15
       	   0x0, 0x1, 0x3, 0x9, 0xb, 0x0, 0xd, 0xf,
		}
	)

	Name(BUFA,
    	ResourceTemplate()
        {
            	IRQ(Level, ActiveLow, Shared ) {15}
        }
	)

	CreateWordField(BUFA, 0x1, IRA0)        // IRQ Mask

	Device(LNKA)
	{
    	Name(_HID, EISAID("PNP0C0F"))

	    Name(_UID, 1)

        Method(_STA)
        {
            Store(Match(IRQT, MEQ, PIRA, MTR,0,0), Local0)

        	If(Local0)
            {
				If(Not(Local0))
				{
					Return(0xb)	        // LNKA enabled 
				}
	            Return (0x9)			// Disabled
            }
            Else
            {
            	Return (0x9)        // LNKA desabled/present/not visible in UI
			}
        }

	    Method(_PRS,0)
        {
    	    Return(IPRS)
	    }
		
		Method(_DIS)
		{
			// Disable PIRQ routing
    		Store(0, PIRA)
		}

		Method(_CRS)
		{
	        Store(Match(IRQT, MEQ, PIRA, MTR,0,0), Local0)
		    ShiftLeft(1, Local0, IRA0)
	        Return(BUFA)
		} // End Method _CRS


		Method(_SRS, 1)
		{
			// ARG0 = PnP Resource String
			CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask
			FindSetRightBit(IRA, Local0)
			Decrement(Local0)
	        Store(DeRefOf(Index(IRQT, Local0)), PIRA)
		} // End Method _SRS
	} // end Device LNKA

	Device(LNKB)
	{
		Name(_HID, EISAID("PNP0C0F"))
		Name(_UID, 2)
		Method(_STA)
		{
			Store(Match(IRQT, MEQ, PIRB, MTR,0,0), Local0)

        	If(Local0)
			{
				If(Not(Local0))
				{
					Return(0xb)	        // LNKA enabled 
				}
	            Return (0x9)			// Disabled
            }
            Else
            {
            	Return (0x9)        // LNKA desabled/present/not visible in UI
            }
		}

		Method(_PRS,0)
		{
			Return(IPRS)
		}

		Method(_DIS)
		{
			// Disable PIRQ routing
			Store(0, PIRB)
		}

		Method(_CRS)
		{
			Store(DeRefOf(Index(IRQT, PIRB)), Local0)
			Store(One, Local1)
			ShiftLeft(Local1, Local0, IRA0)
			Return(BUFA)
		} // End Method _CRS

		Method(_SRS, 1)
		{
			// ARG0 = PnP Resource String
			CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask
			FindSetRightBit(IRA, Local0)
			Decrement(Local0)
			Store(DeRefOf(Index(IRQT, Local0)), PIRB)
		} // End Method _SRS
	} // end Device LNKB

	Device(LNKC)
	{
		Name(_HID, EISAID("PNP0C0F"))
		Name(_UID, 3)
		Method(_STA)
		{
			Store(Match(IRQT, MEQ, PIRC, MTR,0,0), Local0)

        	If(Local0)
			{
				If(Not(Local0))
				{
					Return(0xb)	        // LNKA enabled 
				}
	            Return (0x9)			// Disabled
			}
			Else
			{
            	Return (0x9)        // LNKA desabled/present/not visible in UI
			}
		}

		Method(_PRS,0)
		{
			Return(IPRS)
		}

		Method(_DIS)
		{
			// Disable PIRQ routing
			Store(0, PIRC)
		}

		Method(_CRS)
		{
			Store(DeRefOf(Index(IRQT, PIRC)), Local0)
			Store(One, Local1)
			ShiftLeft(Local1, Local0, IRA0)
			Return(BUFA)
		} // End Method _CRS


		Method(_SRS, 1)
		{
			// ARG0 = PnP Resource String
			CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask
			FindSetRightBit(IRA, Local0)
			Decrement(Local0)
			Store(DeRefOf(Index(IRQT, Local0)), PIRC)
		} // End Method _SRS
	} // end Device LNKC

	Device(LNKD)
	{
		Name(_HID, EISAID("PNP0C0F"))
		Name(_UID, 4)
		Method(_STA)
		{
			Store(Match(IRQT, MEQ, PIRD, MTR,0,0), Local0)
       		If(Local0)
			{
				If(Not(Local0))
				{
					Return(0xb)	        // LNKA enabled 
				}
	            Return (0x9)			// Disabled
			}
			Else
			{
				Return (0x9)        // LNKA desabled/present/not visible in UI
			}
		}

		Method(_PRS,0)
		{
			Return(IPRS)
		}

		Method(_DIS)
		{
			// Disable PIRQ routing
			Store(0, PIRD)
		}

		Method(_CRS)
		{
			Store(DeRefOf(Index(IRQT, PIRD)), Local0)
			Store(One, Local1)
			ShiftLeft(Local1, Local0, IRA0)
			Return(BUFA)
		} // End Method _CRS


		Method(_SRS, 1)
		{
			// ARG0 = PnP Resource String
			CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask
			FindSetRightBit(IRA, Local0)
			Decrement(Local0)
			Store(DeRefOf(Index(IRQT, Local0)), PIRD)
		} // End Method _SRS
	} // end Device LNKD

	Device(LNKU)
	{
    	Name(_HID, EISAID("PNP0C0F"))

	    Name(_UID, 9)

        Method(_STA)
        {
            Store(Match(IRQT, MEQ, PIRU, MTR,0,0), Local0)

        	If(Local0)
            {
				If(Not(Local0))
				{
					Return(0xb)			// LNKU enabled
				}
	            Return (0x9)	        // Disabled
            }
            Else
            {
            	Return (0x9)			// LNKU desabled/present/not visible in UI
			}
        }

	    Method(_PRS,0)
        {
    	    Return(IPRS)
	    }
		
		Method(_DIS)
		{
			// Disable PIRQ routing
    		Store(0, PIRU)
		}

		Method(_CRS)
		{
	        Store(Match(IRQT, MEQ, PIRU, MTR,0,0), Local0)
		    ShiftLeft(1, Local0, IRA0)
	        Return(BUFA)
		} // End Method _CRS


		Method(_SRS, 1)
		{
			// ARG0 = PnP Resource String
			CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask
			FindSetRightBit(IRA, Local0)
			Decrement(Local0)
	        Store(DeRefOf(Index(IRQT, Local0)), PIRU)
		} // End Method _SRS
	} // end Device LNKU
// end of _SB
}
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
