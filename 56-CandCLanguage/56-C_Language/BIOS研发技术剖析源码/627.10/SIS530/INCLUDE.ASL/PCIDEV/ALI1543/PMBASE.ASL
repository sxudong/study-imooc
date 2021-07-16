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
//		Detects the PM & SMbus address base
//		Registers applies for ALI M1543C only.
//**********************************************************************;

	Name(PMBR, 0x4000)
	Name(SMBR, 0x5000)

	OperationRegion(BAR0, PCI_Config, 0x10, 0x2)
	OperationRegion(BAR1, PCI_Config, 0x90, 0x2)

	Field(BAR0, ByteAcc, NoLock, Preserve)
	{
		PMSB,16,
	}
	Field(BAR1, ByteAcc, NoLock, Preserve)
	{
		SMSB,16,
	}

	//To enable the bar0 (0x10-0x11) for reading write 00 at 0x5b.
	OperationRegion(BAR2, PCI_Config, 0x5b, 0x1)
	
	Field(BAR2, ByteAcc, NoLock, Preserve)
	{
		PMBE,8,						//PM Base address space read Enable
	}

	Method(PMBS,0) 
	{	// Return Power Management I/O base address

		If(PMBR)
		{}
		Else
		{
			Store(PMBE, local0)
			Store(0, PMBE)
			And(PMSB, 0xFFFE, PMBR)
			Store(local0, PMBE)
		}
		Return(PMBR)
	}

	Method(SMBS,0)
	{	// Return SMBus I/O base address

		If(SMBR)
		{}
		Else
		{
			Store(PMBE, local0)
			Store(0, PMBE)
			And(SMSB, 0xFFFE, SMBR)
			Store(local0, PMBE)
		}
		Return(SMBR)
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
