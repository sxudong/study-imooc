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

	OperationRegion(PIX0, PCI_Config, 0x41, 0x4)
// USB Controller
	OperationRegion(PIX1, PCI_Config, 0x62, 0x1)

Scope(\_SB){

	Field(PCI0.SBRG.PIX0,ByteAcc,NoLock,Preserve){
		PIRA,8,                 // IRQA route register
		PIRB,8,                 // IRQB route register
		PIRC,8,                 // IRQC route register
		PIRD,8,                 // IRQD route register
		}

	Field(PCI0.SBRG.PIX1,ByteAcc,NoLock,Preserve){
		PIRU,8                  // Route register for USB.
		}

// moved to ASLBUILD.MAK.
//	Name(IPRS,
//		ResourceTemplate()
//		{
//		StartDependentFn(1,1)
//		{
//		IRQ(Level, ActiveLow, Shared ) {3,4,5,6,7,9,10,11,12,14,15}
//		}
//		EndDependentFn()
//		})

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
	}					// End Method _SRS

	}                                       // end Device LNKD

	Device(LNKU){
	Name(_HID, EISAID("PNP0C0F"))
	Name(_UID, 5)
	Method(_STA)
	{
	And(PIRU, 0x80, Local0)
	If(Local0) {Return (0x9)} // LNKU desabled/present/not visible in UI
	    Else   {Return (0xb)} // LNKU enabled
	}

	Method(_PRS,0){
	Return(IPRS)
	}

	Method(_DIS){

	// Disable PIRQ routing
	Or(PIRU, 0x80 ,PIRU)

	}

	Method(_CRS){

	CreateWordField(BUFA, 0x1, IRA0)        // IRQ Mask

	And(PIRU, 0x0f, Local0)

	Store(One, Local1)
	ShiftLeft(Local1, Local0, IRA0)

	Return(BUFA)

	}                                       // End Method _CRS


	Method(_SRS, 1){

	// ARG0 = PnP Resource String

	CreateWordField(ARG0, 0x01, IRA)	// IRQ Low Mask

	FindSetRightBit(IRA, Local0)
	Decrement(Local0)
	And(PIRU, 0x40, Local1)
	Or(Local0, Local1, PIRU)
	
	}					// End Method _SRS


	}                                       // end Device LNKU

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
