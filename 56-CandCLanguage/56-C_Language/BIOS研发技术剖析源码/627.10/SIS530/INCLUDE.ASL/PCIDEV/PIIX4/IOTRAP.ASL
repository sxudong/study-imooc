// Workaround ASL code for E3 & E4 (440BX only)
// E3 & E4 sleep state fixes for EDO and SDRAM

// E3 & E4 I/O trap save
	Name(DVAD, 0)          // Device gen.io base save data
	Name(DVMS, 0)          // Device gen.io mask & monitor
	Name(DVTP, 0)          // Device gen.io trap

	Method(TRAP, 3)
	{
// arg0 - Sleep state
// arg1 - Set/release trap
// arg2 - I/O address to trap

//PIIX4 PMbase register space
   Field (\_SB.PCI0.PMU.PWRG, ByteAcc, NoLock, Preserve)
		{
//		Offset(0x21),		// Global stanby timer enable
//		,0,			// bit 0 of 21h
//		GSTY,1,			// Fix for E3,E4

		Offset(0x2F),		// Device 12 I/O trap
		TP12,1,			// bit 0 of 2Fh
		}
					// Fix for E3&E4, BIOS spec 2.2

// check if it's S3 reset trap enable on 0x$(A_PM_BASE)+4 register
// E3 & E4 sleep state fixes for EDO and SDRAM
		If(And(Arg0,0x1))	// If S1/S3 then do E3/E4
		{
//	And(Arg0,0x2,Local0)
//	If(LEqual(Local0,2)) {		// If S2/S3 then do E3/E4

		If(Arg1)		// Trap Enable/Disable
			{
//		Store(1, GSTY)		// E3/E4 fix by GST
					// E3/E4 fix by Device I/O trap
// 1.Save device 9 I/O base & monitor
			Store(\_SB.PCI0.SBRG.GDR2, DVAD)
			Store(\_SB.PCI0.SBRG.GDM2, DVMS)

// 2.Set I/O trap in dev gen. io
			Store(Arg2, \_SB.PCI0.SBRG.GDR2)
			Store(0x11, \_SB.PCI0.SBRG.GDM2)
// 3.Save Device I/O trap
			Store(TP12, DVTP)
			Store(1, TP12)
			}
		Else
			{
//			Store(0, GSTY)		// E3/E4 fix by GST

// E3/E4 fix by Device I/O trap
// 1. Restore device I/O base & monitor
			Store(DVAD, \_SB.PCI0.SBRG.GDR2)
			Store(DVMS, \_SB.PCI0.SBRG.GDM2)
// 2. Restore Device I/O trap
			Store(DVTP, TP12)
			}
		}
	}					// end TRAP control method
