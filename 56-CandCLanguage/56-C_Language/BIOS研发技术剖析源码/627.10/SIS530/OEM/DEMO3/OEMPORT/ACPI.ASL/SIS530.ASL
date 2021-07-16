	OperationRegion(TMEM, PCI_Config, 0x60, 0x4)
	Field(TMEM, ByteAcc, NoLock, Preserve){
	MEM1,8,				// system memory DIMM 1 configuration  
	MEM2,8,				// system memory DIMM 2 configuration   
	MEM3,8,				// system memory DIMM 3 configuration   
	MEMP,3,				// banks information
	, 1,
	MEMS,3,				// Share Memory Info.
	}

	Name(SRAM, Package(){
		0x04, 0x10, 0x10, 0x20, 0x08, 0x20, 0x20, 0x40
		, 0x10, 0x40, 0x40, 0x80, 0x08
		}
	)

	Name(TOM, 0)				// Top Of Memory global variable

	Method(MSIZ,2)
	{
		And(Arg1, MEMP, Local0)// ROW Existence
		And(Arg0, 0x0f, Local1)// DRAM ROW Size
		Store(Zero, Local2)
		And(Arg0, 0x20, Local4)// DRAM Sides
		If (Local0)
		{
			Store(DeRefOf(Index(SRAM, Local1)), Local2)
			ShiftLeft(Local2, 0x1, Local2)
			if (Local4)
			{
				ShiftLeft(Local2, 0x1, Local2)
			}
			Multiply(Local2, 0x100000, Local2)
		}
		Return(Local2)
	}
		
	Method(MDET,0)
	{
	// Check for OS version and PCI Access flag
//		If(And(FLAG, OSFL))
		If(TOM) {}
		Else
		{
			If(FLAG)
			{
			Store(MSIZ(MEM1, 0x01), Local0)
			Add(MSIZ(MEM2, 0x02), Local0, Local0)
			Add(MSIZ(MEM3, 0x04), Local0, Local0)
			And(MEMS, 0x4, Local1)
			If(Local1)
				{
				And(MEMS, 0x3, Local2)
				ShiftLeft(0x100000, Local2, Local3)
				Subtract(Local0, Local3, Local0)
				}
			Store(Local0, TOM)
			}
			Else
			{
			Return(0x20000000)	// only for emergency
						// if OS unable to read
						// the PCI config space
			}
		}

		Return(TOM)
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
