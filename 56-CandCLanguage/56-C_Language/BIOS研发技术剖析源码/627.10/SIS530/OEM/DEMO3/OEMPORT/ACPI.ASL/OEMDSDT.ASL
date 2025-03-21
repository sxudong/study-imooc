DefinitionBlock (
        "OEMDSDT.AML",
        "DSDT",
        0x01,
        "SiS",          // OEM ID (6 byte string)
        "530",    // OEM table ID  (8 byte string)
        0x1000          // OEM version of DSDT table (4 byte Integer)
	)
//--------------------------------------------------------------------------
// BEGIN OF ASL SCOPE
//--------------------------------------------------------------------------
{
Scope(\_PR)     {               // BEGIN PROCESSOR PACKAGE
	Processor( CPU1,
// ProcessorID (unique for each CPU)
                1,
// PBlockAddress
                0x40c,
// PBlockLength hardwired to 6 byte
                0x06
	){}
        }                       // end CPU scope

// Value to be set in SLP_TYP register
	Name(\_S0, Package(4){0,0,0,0})	// working state on this chip set
	Name(\_S1, Package(4){1,0,0,0})	// Power on suspend with CPU context maintained.
	Name(\_S5, Package(4){5,0,0,0})	// Soft Off


// MCTH(Str1, Str2) - Compare Str1 and Str2.
        Method(MCTH, 2)
        {
//                    Returns One if Str1 <> Str2
//                    Returns Zero if Str1 == Str2
//1. If Length str1 < Str2 - Return (Err)

            If(LLess(Sizeof(Arg0), Sizeof(Arg1)))
		{
                    Return(0)
            }

//2. Convert str1 & str2 into buffer with length of str2

    // Local0 contains length of string + NULL.
    //
            Add(Sizeof(Arg0), 1, Local0)

            Name(BUF0, Buffer(Local0) {})
            Name(BUF1, Buffer(Local0) {})
            Store(Arg0, BUF0)
            Store(Arg1, BUF1)

            While(Local0)
            {
                Decrement(Local0)
                If(LEqual(Derefof(Index(BUF0, Local0)), Derefof(Index(BUF1, Local0))))
                { }
                Else
                { Return(Zero) }
            }
            Return(One)         // Str1 & Str2 are match
        }
//-----------------------------------------------------------------------
// System Bus scope
//-----------------------------------------------------------------------
Scope(\_SB){

	Name(APIC, 0)			// 0-PIC mode
					// 1-APIC mode
        Method(_PIC, 1)
        {
		Store(Arg0, APIC)
        }
//-----------------------------------------------------------------------
// PCI ROOT (NORTH) BRIDGE
//-----------------------------------------------------------------------
        Device(PCI0) {                          // Start of Root PCI Bus

                Name(_HID, EISAID("PNP0A03"))   // PnP ID for PCI Bus

                Name(_ADR, 0x0000)              // Root Bus is Bus # 0

                Name(_BBN, 0)                   // PCI 0 Bus device address

                Name(CRS,                       //

                ResourceTemplate()
                {
// Tag 0 Bus Number Resources
        WORDBusNumber(
                ResourceProducer,               // bit 0 of general flags 1
		MinFixed,			// Range fixed
		MaxFixed,			// Range fixed
		PosDecode,			// Positive Decode
		0x00,				// Granularity
		0x00,				// Min
		0xff,				// Max
		0x00,				// Translation
                0x0100                          // Range Length = Max-Min+1
		)

// Tag 1 Consumed Resources

	IO(Decode16, 0xCF8, 0xCF8, 1, 8)

// Tag 2 Consumed-&-Produced Resources(I/O Window 1)
// all I/O below CF8

	WORDIO(
		ResourceProducer,		// bit 0 of general flags 0
		MinFixed,			// Range fixed
		MaxFixed,			// Range fixed
		PosDecode,			// Positive Decode
		EntireRange,
		0x00,				// Granularity A = 0x0
		0x00,				// Min
                0x0CF7,                         // Max
		0x00,				// Translation
                0x0CF8                          // Range Length
		)

// Tag 3 Consumed-&-Produced Resources(I/O Window 2)
// all I/O above CFF

	WORDIO(
		ResourceProducer,		// bit 0 of general flags 0
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		PosDecode,			// Positive Decode
		EntireRange,
		0x00,				// Granularity
		0x0D00,				// Min
		0xffff,				// Max
		0x00,				// Translation
		0xf300				// Range Length
		)

// Tag 4 Consumed-&-Produced Resources(Memory Window 1)
// Descriptor for video RAM behind ISA bus

	DWORDMemory(
		ResourceProducer,		// bit 0 of general flags 0
		PosDecode,
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		Cacheable,
		ReadWrite,
		0x0,				// Granularity
		0x0a0000,			// Min
		0x0bffff,			// Max
		0x00,				// Translation
		0x020000			// Range Length
		)

// Tag 5 Consumed-&-Produced Resources(Memory Window 2)
// for device ROMs for ISA plugins devices
// OEM specific

	DWORDMemory(
		ResourceProducer,		// bit 0 of general flags 0
		PosDecode,
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		Cacheable,
		ReadWrite,
		0x0,				// Granularity
		0x0cb000,			// Min
		0x0dffff,			// Max
		0x00,				// Translation
		0x015000			// Range Length
		)

// Tag 6 Consumed-&-Produced Resources(Memory Window 3)

	DWORDMemory(
		ResourceProducer,		// bit 0 of general flags 0
		PosDecode,
		MinFixed,			// Range is not fixed
		MaxFixed,			// Range is not fixed
		Cacheable,
		ReadWrite,
                0x0,                            // Granularity
                0x020000000,                    // Min 512M (calculated dinamically)
		0xffdfffff,			// Max 4Gb-2Mb
		0x00,				// Translation
		0xDFE00000,			// Range Length
						// (4G-2M)-TOM (calculated dinamically)
		,
		,
		MEM6				// Name declaration for this descriptor
		)

	}
	)					// end of CRS


// PCI North bridge specific code
	Include(".\\oemport\\acpi.asl\\sis530.asl")

                Name(FLAG, 1)                   // PCI Bus access Flag
                                                // Reset flag if test NT 5.0
                    Name(OSFL, 1)               // Curernt OS name 1 - Win 98
                                                //                 0 - NT 5.0
                Method(_INI, 0)
                {
// Detect SuperIO devices present onboard
                        \_SB.PCI0.SBRG.IODT()
// Detect currently running OS
                If(MCTH(\_OS, "Microsoft Windows"))     // Is the running OS - Win98?
                        { }
                        Else                            // It is not Win 98 (it's NT 5.0)
                        {
				Store(0, OSFL)
				}
	}

                Method(_REG, 2)                         // is PCI Config space accessible as OpRegion?
                                                        // _REG to update FLAG status
                {
                        If(LEqual(Arg0, 0x2))
                        {
					  Store(Arg1, FLAG)
                        }
                }

                Method(_CRS, 0)                     // PCI 0 Bus resources
                {

				CreateDwordField(CRS, \_SB.PCI0.MEM6._MIN, TMEM)        // Top of memory
				CreateDwordField(CRS, \_SB.PCI0.MEM6._LEN, TLEN)        // 4G-TOM
                                                        // MDET Control Method
                                                        // returns available system memory
                                Store(MDET(), TMEM)     // MDET defined in a \_SB.PCI0 scope

                                Subtract(0xffe00000, TMEM, TLEN)// Local(4G - 2M)-TOM

				Return(CRS)
                }                                       // end PCI _CRS
//-----------------------------------------------------------------------
// 	PCI IRQ ROUTING TABLE (PRT)
//-----------------------------------------------------------------------
                Name(_PRT, Package() {          // Table applies in PIC mode
//-----------------------------------------------------------------------
		Package(){0x01ffff, 0, LNKU, 0},
// Slot 1
		Package(){0x09ffff, 0, LNKA, 0},
		Package(){0x09ffff, 1, LNKB, 0},
		Package(){0x09ffff, 2, LNKC, 0},
		Package(){0x09ffff, 3, LNKD, 0},
// Slot 3
		Package(){0x0bffff, 0, LNKC, 0},
		Package(){0x0bffff, 1, LNKD, 0},
		Package(){0x0bffff, 2, LNKA, 0},
		Package(){0x0bffff, 3, LNKB, 0},
// Slot 4
		Package(){0x0dffff, 0, LNKD, 0},
		Package(){0x0dffff, 1, LNKA, 0},
		Package(){0x0dffff, 2, LNKB, 0},
		Package(){0x0dffff, 3, LNKC, 0},
// Device 1, IRQA
		Package(){0x02ffff, 0, LNKA, 0},
// Device 1, IRQB
		Package(){0x02ffff, 1, LNKB, 0},
// Device 2, IRQD
		Package(){0x0fffff, 0, LNKD, 0},
//-----------------------------------------------------------------------
		} )
//-----------------------------------------------------------------------
// PCI-ISA (SOUTH) BRIDGE
//-----------------------------------------------------------------------
        Device(SBRG) {

                Name(_ADR, 0x010000)


// PCI interrupt routing devices

        Name(\_SB.IPRS,         // List of possible IRQs
                                // to be returned by _PRS for LINKx devices
		ResourceTemplate()
		{
        		StartDependentFnNoPri()
                {
			IRQ(Level, ActiveLow, Shared ) {3,4,5,6,7,9,10,11,12,14,15} // 3,4,5,6,7,9,10,11,12,14,15
                }
		    EndDependentFn()
		})

	Include(".\\oemport\\acpi.asl\\irq-pci.asl")
//-----------------------------------------------------------------------
//			Miscellaneous I/O Ports
//-----------------------------------------------------------------------
// This table should contain any I/O port that is not used by a specific
// device but does not return FFh when read.  Some examples of I/O ports
// that should be reserved here are:
//   The I/O peripheral chip's index/data ports
//   Any I/O port in the range 00 - FF that is not used by any other dev node
//   The IRQ edge/level control ports (4D0/4D1)
//-----------------------------------------------------------------------
// For example:
//	ASL macro "FixedIO"
//	FixedIO( WordConst, // _BAS, Address base
//		 ByteConst  // _LEN, Range length
//		)
//	if SuperIO module Index/Data port address allocated in
//	0x3f0 / 0x3f1 we need to update "FixedIO" macro with
//	"Address base" = 0x3f0 and "Range length" = 0x02
//      FixedIO( 0x3f0, 0x02)
//		   ^^^    ^^ fields only to edit
//-----------------------------------------------------------------------
	Device(SYSR) {

		Name(_HID, EISAID("PNP0C02"))

		Method(_STA, 0)
		{
			If(OSFL)		// If running under Win98?
			{
				Return(0x0f)	// Device present
			}
			Return(0x0)		// Not present if NT 5.0
		}

                Name(IORG,
                        ResourceTemplate()
		{
		FixedIO(0x10, 0x10)
		FixedIO(0x22, 0x1e)
		FixedIO(0x44, 0x1c)
		FixedIO(0x62, 0x02)
		FixedIO(0x65, 0x0b)
		FixedIO(0x72, 0x0E)
		FixedIO(0x80, 0x01)
		FixedIO(0x84, 0x03)
		FixedIO(0x88, 0x01)
		FixedIO(0x8C, 0x03)
		FixedIO(0x90, 0x10)
		FixedIO(0xa2, 0x1e)
		FixedIO(0xe0, 0x10)
// LM78/79 or W8378x Hardware Monitor ICs
		FixedIO(0x290, 0x8)
// Decoded but not used by FDC
//		IO(Decode16, 0x3f3, 0x3f3, 0, 0x1)
// Abel Wu
// Reserve  480 - 48F for Extended DMA ports  
		IO(Decode16, 0x480, 0x480, 0, 0x10)
// Reserve  4D0 and 4D1 for IRQ edge/level control port
		IO(Decode16, 0x4d0, 0x4d0, 0, 0x2)
// PM base address allocation
		IO(Decode16, 0, 0, 0, 0x0, IO1)
// SMBus base address allocation
		IO(Decode16, 0, 0, 0, 0x0, IO2)
// Index\Data for Super I/O
		IO(Decode16, 0x3f0, 0x3f0, 0, 0x2)
// Abel Wu
// Reserve Unknow memory FFEF0000-FFEFFFFF
		Memory32(ReadOnly, 0xffef0000, 0xffef0000, 0, 0x10000)
		    }               // End of ResourceTemplate
		    )               // end of IORG

		    Method(_CRS, 0)
		    {
				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO1._MIN, PM00) // PM Base
				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO1._MAX, PM01)
				CreateByteField(IORG, \_SB.PCI0.SBRG.SYSR.IO1._LEN, PMLN) // PM Length

				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO2._MIN, SM00) // SMB Base
				CreateWordField(IORG, \_SB.PCI0.SBRG.SYSR.IO2._MAX, SM01)
				CreateByteField(IORG, \_SB.PCI0.SBRG.SYSR.IO2._LEN, SMLN) // SMB length

				Store(\_SB.PCI0.PMU.PMBS(), PM00)
				Store(PM00, PM01)
                    If(PM00)                                    // If Base <> 0 : set length to 40
                                {                               // Otherwise to 0
// Abel Wu
				Store(0x40, PMLN)
				}

				Store(\_SB.PCI0.PMU.SMBS(), SM00)
				Store(SM00, SM01)
                    If(SM00)                                    // If Base <> 0 : set length to 10
                                {                               // Otherwise to 0
// Abel Wu
				Store(0x10, SMLN)
				}
				Return(IORG)
		    }

	}			// End System Resources SYSR
/////////////////////////////////////////////////////////////////////////
// System board extension for ACPI BIOS
// Place that device under \_SB scope, As per Msft the MEM
// Resources should not be declared neither in PCI0 nor in PCI-ISA Bus
/////////////////////////////////////////////////////////////////////////
	Device(\_SB.MEM) {		        	      	// Memory
		Name(_HID, EISAID("PNP0C01"))			// Hardware Device ID


		Method (_STA, 0)
		{
                        If(\_SB.PCI0.OSFL)                      // If running under Win98?
			{
                                Return(0x0f)                    // Device present
			}
		Return(0x0)								// Not present
		}

		Name(MEM1,

		ResourceTemplate()
		{
//	Base Address 0 - 0x9FFFF , 640k DOS memory
			Memory32Fixed(ReadWrite, 0x0000, 0xA0000 )//Writeable
//	Base Address F000 - 1M , 64k BIOS
			Memory32Fixed(ReadOnly, 0xF0000, 0x10000 )//Non-writeable

//	Base Address 1M - Top of system present memory
			Memory32Fixed(ReadWrite, 0x100000, 0x1FF00000, TOPM)//Writeable
			Memory32Fixed(ReadOnly, 0xFFFF0000, 0x10000)//Non-Writeable, 64K ROM image
		})

		Method (_CRS, 0)
		{
			// Top of memory
			// MDET Control Method returns available system memory

			CreateDwordField(MEM1, \_SB.MEM.TOPM._LEN, TOP1)
			// MDET defined in \_SB.PCI0 scope
			Subtract(\_SB.PCI0.MDET(), 0x100000, TOP1)

		Return(MEM1)
		}					// end of _CRS

	}						// End Memory
//-----------------------------------------------------------------------
//	ONBOARD I/O Standard peripherals
//	DMA, Keyboard, Timer, Speaker, CMOS...
//-----------------------------------------------------------------------
	Include(".\\oemport\\acpi.asl\\sysstand.asl")
// Resume by key pressed
		    Name(PS2K._PRW, Package(){0x07, 0x01})
/* An example of resume code can be used on particular designs if event handler is needed
		    Method(PS2K._PSW, 1)
		    {
                        If(Arg0){ }      // Enable resume by Keyboard
                        Else
                                { }      // Disable resume
                }
Scope(\_GPE)
	{
                Method(_L07)
		{
		//	OEM ASL code
			Notify(\_SB.PCI0.SBRG.PS2K, 0x2)	// Wake up event
		}
	}
*/
// Resume by key pressed
                Name(PS2M._PRW, Package(){0x07, 0x01})
// Route and Release I/O, DMA resources to EIO Bus
// Dummy methods
        Method(RRIO, 4) { NoOp }
        Method(RGNR, 4) { NoOp }
        Method(rDMA, 3) { NoOp }
	Name(SPIO, 0x3f0)	// Super I/O Index/Data base address
//-----------------------------------------------------------------------
// Super IO devices (FDC, UART1,2, LPT, ECP, IR)
//-----------------------------------------------------------------------
	Include(".\\oemport\\acpi.asl\\superio.asl")

        Name(UAR1._PR0, Package(){URP1})        // Reference to PowerResources
// Resume by modem Ring
	Name(UAR1._PRW, Package(){0x01, 0x01})
        }                                       // End of SBRG

//-----------------------------------------------------------------------
// PCI Power Management Unit (PMU)
//-----------------------------------------------------------------------
	Device(PMU) {

                Name(_ADR, 0x010001)
// Contains the PMBS & SMBS control methods to return the PM & SMBus I/O base address
	Method(PMBS,0) {	// Return Power Management I/O base address
                        Or(ShiftLeft(0x004,8), 0x000, Local0)
        Return(Local0)
	}
	Method(SMBS,0) {	// Return SMBus I/O base address
                        Or(ShiftLeft(0x004,8), 0x040, Local0)
        Return(Local0)
	}
// PM controller IO space
      OperationRegion(PWRG, SystemIO, PMBS, 0x40)
   }


	Device(USB) {                       // Device USB

		Name(_ADR, 0x010002)

	  }						// end USB

        }                                       // End of PCI0 Root Bus


}						// End of _SB scope
//----------------------------------------------------------------------
// SYSTEM MANAGEMENT DEVICES
//----------------------------------------------------------------------

	OperationRegion(FNOR, SystemIO, 0x434, 0x04)
	OperationRegion(SIOR, SystemIO, 0x370, 0x02)
	Field ( SIOR, ByteAcc, NoLock, Preserve)
		{
		SIND,8,		//field named INDX is 8 bits wide
		SDTA,8		//field DATA is 8 bits wide
		}
//-----------------------------------------------------------------------
// System indication 1
//-----------------------------------------------------------------------
	IndexField(SIND, SDTA,ByteAcc, NoLock, Preserve)
	{
	,25,
	LEDW,1,			// LED control bit 1
	}
	Name(LDON, 1)
	Include(".\\oemport\\acpi.asl\\SI.asl")

//-----------------------------------------------------------------------
// 	_PTS METHOD CALLED JUST BEFORE OS GO TO SLEEP
//-----------------------------------------------------------------------
	Method(_PTS, 1){
		Store(Arg0, DBG8)
// Added by Abel Wu at 07/24/98 for Clear Wakeup IRQ Status
	if (LEqual(Arg0,1)){
		While(WAKS)
		{
			Stall(80)
			Store(1,WAKS)
		}
	}


	}
//-----------------------------------------------------------------------
// 	_WAK METHOD CALLED RIGHT AFTER OS WAKES UP FROM SLEEP
//-----------------------------------------------------------------------
	Method(_WAK, 1) {

		ShiftLeft(Arg0, 4, DBG8)


// Added by Abel Wu at 07/24/98 for Generate SCI
	Store(1,BIOS)


	}

//-----------------------------//
//   For debug purpose only    //
//-----------------------------//

	OperationRegion (WAKP, SystemIO, 0x00414, 1)
	Field (WAKP, ByteAcc,NoLock,Preserve)
		{ ,7,WAKS,1}
	OperationRegion (GBLE, SystemIO, 0x00413, 1)
	Field (GBLE, ByteAcc,NoLock,Preserve)
		{ ,1,BIOS,1,}
	OperationRegion (TEMP, SystemIO, 0x80, 1)
	Field (TEMP, ByteAcc,NoLock,Preserve)
		{ DBG8,8,}
	OperationRegion (DEB0, SystemIO, 0x90, 2)
	Field (DEB0, WordAcc,NoLock,Preserve)
		{ DBG9,16,}
}						// End of ASL File
