	OperationRegion(TMEM, PCI_Config, 0x60, 0x4)
	Field(TMEM, ByteAcc, NoLock, Preserve){
	BNK0,4,		// Bank 0, Memory populated
        ,2,
	TYP0,2,		// Type of Memory (SDRAM=0x3, others = 0-1)
	BNK1,4,		// Bank 0, Memory populated
        ,2,
	TYP1,2,		// Type of Memory (SDRAM=0x3, others = 0-1)
	BNK2,4,		// Bank 0, Memory populated
        ,2,
	TYP2,2,		// Type of Memory (SDRAM=0x3, others = 0-1)
	SLT0,1,		// DRAM BANK status (0- Absent, 1- installed)
	SLT1,1,		// DRAM BANK status (0- Absent, 1- installed)
	SLT2,1,		// DRAM BANK status (0- Absent, 1- installed)
	}

	Name(SMAP, Package(){10,40,80,20,80,80,100,40,100,100,200,20})	// SDRAM Memory size map (04=256k, 10=1M,..)
	Name(OMAP, Package(){04,10,40,100,10,20,40,80,08,10,20})	// Other type Memory size map

	Method(MDET,0)
	{
		Store(0x020000000, Local0)
		If(FLAG)
		{

	Store(0, Local0)			// Memory size for Bank0
	Store(0, Local1)			// Memory size for Bank1
	Store(0, Local2)			// Memory size for Bank2

	If(SLT0)				// if Slot0 is populated
	{
		If(And(TYP0,0x3))		// if SDRAM ?
		{
		Store(DeRefOf(Index(SMAP,BNK0)), Local0)
		}
		Else
		{
		Store(DeRefOf(Index(OMAP,BNK0)), Local0)
                }     	

        }
	If(SLT1)				// if Slot1 is populated
	{
		If(And(TYP1,0x3))		// if SDRAM ?
		{
		Store(DeRefOf(Index(SMAP,BNK1)), Local1)
		}
		Else
		{
		Store(DeRefOf(Index(OMAP,BNK1)), Local1)
                }     	
	}
	If(SLT2)				// if Slot2 is populated
	{
		If(And(TYP2,0x3))		// if SDRAM ?
		{
		Store(DeRefOf(Index(SMAP,BNK2)), Local2)
		}
		Else
		{
		Store(DeRefOf(Index(OMAP,BNK2)), Local2)
		}
	}
	Add(Local0, Local1, Local5)
	Add(Local2, Local5, Local5)
	ShiftLeft(Local5, 0x10, Local0)

	}
	Return(Local0)
	}


	Method(TFCS, 0)	// Returns end of FACS table absolute address
	{		// TOM - 32k + 64byte
	Subtract(MDET, 0x7fc0, Local0)
	Return(Local0)
	}
//	OperationRegion(SMEM, SystemMemory, MDEF, 0x4)
//	Field(SMEM, DWordAcc, NoLock, Preserve){
//			MEMP,32,
//			}
