	OperationRegion(TMEM, PCI_Config, 0x67, 0x1)
	Field(TMEM, ByteAcc, NoLock, Preserve){
	MEMT,8,					// system memory size
	}

	Name(TOM, 0)				// Top Of Memory global variable

	Method(MDET,0)
	{
	// Check for OS version and PCI Access flag
//		If(And(FLAG, OSFL))
		If(TOM) {}
		Else
		{
			If(FLAG)
			{
	// number of 8Meg blocks
			ShiftLeft(MEMT, 23, TOM)
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
