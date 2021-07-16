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
//	PIIX4 PCI IRQ Links devices
//**********************************************************************;

	OperationRegion(SBRG.PIX0, PCI_Config, 0x60, 0x4)

Scope(\_SB){

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	OperationRegion (ELCR, SystemIO, 0x4D0, 0x02)
	Field (ELCR, ByteAcc, Nolock, Preserve) {
	ELC1,   16,
	}
// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers


	Field(\_SB.NRTH.SBRG.PIX0,ByteAcc,NoLock,Preserve){
		PIRA,8,                 // IRQA route register
		PIRB,8,                 // IRQB route register
		PIRC,8,                 // IRQC route register
		PIRD,8,                 // IRQD route register
		}

	Name(IPRS,
		ResourceTemplate()
		{
		StartDependentFn(1,1)
		{
		IRQ(Level, ActiveLow, Shared ) {3,4,5,6,7,9,10,11,12,14,15}
//		IRQ(Level, ActiveLow, Shared ) {3,4,5,6,7,10,11,12,14,15}
		}
		EndDependentFn()
		})

	Name(BUFA,
	ResourceTemplate()
	{
	IRQ(Level, ActiveLow, Shared ) {15}
	})


	Device(LNKA){
	Name(_HID, EISAID("PNP0C0F"))
	Name(_UID, 1)
	Method(_STA)
	{
	And(PIRA, 0x80, Local0)
	If(Local0) {Return (0x9)} // LNKA desabled/present/not visible in UI
	    Else   {Return (0xb)} // LNKA enabled
	}

	Method(_PRS,0){
	Return(IPRS)
	}

	Method(_DIS){

	// Disable PIRQ routing
	Or(PIRA, 0x80 ,PIRA)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	And(PIRA, 0x0f, Local0)

	ShiftLeft(1, Local0, Local1)
	Not(Local1, Local1)
	And(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	}

	Method(_CRS){

	CreateWordField(BUFA, 0x1, IRA0)        // IRQ Mask

	And(PIRA, 0x0f, Local0)

	Store(One, Local1)
	ShiftLeft(Local1, Local0, IRA0)

	Return(BUFA)

	}                                       // End Method _CRS


	Method(_SRS, 1){
	// ARG0 = PnP Resource String

	CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask

	FindSetRightBit(IRA, Local0)
	Decrement(Local0)
	Store(Local0, PIRA)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	ShiftLeft(1, Local0, Local1)
	Or(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	}					// End Method _SRS


	}                                       // end Device LNKA

	Device(LNKB){
	Name(_HID, EISAID("PNP0C0F"))
	Name(_UID, 2)
	Method(_STA)
	{
	And(PIRB, 0x80, Local0)
	If(Local0) {Return (0x9)} // desabled/present/not visible in UI
	    Else   {Return (0xb)} // enabled
	}

	Method(_PRS,0){
	Return(IPRS)
	}

	Method(_DIS){

	// Disable PIRQ routing
	Or(PIRB, 0x80 ,PIRB)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	And(PIRB, 0x0f, Local0)

	ShiftLeft(1, Local0, Local1)
	Not(Local1, Local1)
	And(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	}

	Method(_CRS){

	CreateWordField(BUFA, 0x1, IRA0)        // IRQ Mask

	And(PIRB, 0xf, Local0)

	Store(One, Local1)
	ShiftLeft(Local1, Local0, IRA0)

	Return(BUFA)

	}                                       // End Method _CRS


	Method(_SRS, 1){
	// ARG0 = PnP Resource String

	CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask

	FindSetRightBit(IRA, Local0)
	Decrement(Local0)
	Store(Local0, PIRB)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	ShiftLeft(1, Local0, Local1)
	Or(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	}					// End Method _SRS

	}                                       // end Device LNKB


	Device(LNKC){
	Name(_HID, EISAID("PNP0C0F"))
	Name(_UID, 3)
	Method(_STA)
	{
	And(PIRC, 0x80, Local0)
	If(Local0) {Return (0x9)} // desabled/present/not visible in UI
	    Else   {Return (0xb)} // enabled
	}

	Method(_PRS,0){
	Return(IPRS)
	}

	Method(_DIS){

	// Disable PIRQ routing
	Or(PIRC, 0x80 ,PIRC)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	And(PIRC, 0x0f, Local0)

	ShiftLeft(1, Local0, Local1)
	Not(Local1, Local1)
	And(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	}

	Method(_CRS){

	CreateWordField(BUFA, 0x1, IRA0)        // IRQ Mask

	And(PIRC, 0xf, Local0)

	Store(One, Local1)
	ShiftLeft(Local1, Local0, IRA0)

	Return(BUFA)

	}                                       // End Method _CRS


	Method(_SRS, 1){
	// ARG0 = PnP Resource String

	CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask

	FindSetRightBit(IRA, Local0)
	Decrement(Local0)
	Store(Local0, PIRC)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	ShiftLeft(1, Local0, Local1)
	Or(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	}					// End Method _SRS

	}                                       // end Device LNKC


	Device(LNKD){
	Name(_HID, EISAID("PNP0C0F"))
	Name(_UID, 4)
	Method(_STA)
	{
	And(PIRD, 0x80, Local0)
	If(Local0) {Return (0x9)} // desabled/present/not visible in UI
	    Else   {Return (0xb)} // enabled
	}

	Method(_PRS,0){
	Return(IPRS)
	}

	Method(_DIS){

	// Disable PIRQ routing

	Or(PIRD, 0x80 ,PIRD)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	And(PIRD, 0x0f, Local0)

	ShiftLeft(1, Local0, Local1)
	Not(Local1, Local1)
	And(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers
	}

	Method(_CRS){

	CreateWordField(BUFA, 0x1, IRA0)        // IRQ Mask

	And(PIRD, 0xf, Local0)

	Store(One, Local1)
	ShiftLeft(Local1, Local0, IRA0)

	Return(BUFA)

	}                                       // End Method _CRS


	Method(_SRS, 1){
	// ARG0 = PnP Resource String

	CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask

	FindSetRightBit(IRA, Local0)
	Decrement(Local0)
	Store(Local0, PIRD)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	ShiftLeft(1, Local0, Local1)
	Or(ELC1, Local1, ELC1)

// 2/2/98 workaround for OS bug which could disable
// PCI interrupt routing before unloading the drivers

	}					// End Method _SRS

	}                                       // end Device LNKD

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
