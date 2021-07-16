//---------------------------------------------------------------------
// 	FANs Power Resources
//---------------------------------------------------------------------
// Names defined in AMI.ASL:
//	FAN1	  - control bits for FAN1 (CPU Fan)
//	FAN2	  - control bits for FAN2 (CPU Fan)
//	F1ON,F2ON - value to be write to turn the Fans ON
//	NFAN 	  - number of FANs
// Module contents:
//	1. Power Resources for Global FAN
//---------------------------------------------------------------------
	PowerResource(GFAN, 0, 0){	// Power Resource


	Method(_STA)
	{
		Return(Xor(FAN1, And(Not(F1ON),1)))
	}

	Method(_ON)  {			// Set the FAN On
		Store(F1ON, FAN1)
		If(LEqual(NFAN,2))
			{
			Store(F2ON, FAN2)
			}
	}
	Method(_OFF) {                  // Set the FAN OFF
		Xor(F1ON, 1, FAN1)

		If(LEqual(NFAN,2))
			{
			Xor(F2ON, 1, FAN2)
			}
	}
	}				// End resource for FAN
//---------------------------------------------------------------------
