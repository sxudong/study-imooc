//---------------------------------------------------------------------
// 	FANs Power Resources
//---------------------------------------------------------------------
// Names defined in AMI.ASL:
//	SFFO,L,M - control bits for FAN1 (System Fan)
//	PFNO,L,M - control bits for FAN2 (Power Supply Fan)
//	FNON - value to be write to turn the Fans ON
// Module contents:
//	1. Power Resources for Global FAN
//	2. Power Resources for FAN1
//	3. Power Resources for FAN2
//---------------------------------------------------------------------
//	1. Power Resources for Global FAN
//---------------------------------------------------------------------

	PowerResource(GFAN, 0, 0) {	// Power Resource
					// for PS/Case Fan

	Method(_STA) {                  // Get Fans Status
		Return(And(Xor(SFNO, And(Not(F1ON),1)), Xor(SFNO, And(Not(F1ON),1))))
	}

	Method(_ON)  {			// Set PS & Case FAN to High Speed
Store(" Global Fan High (ON)" ,Debug)
		Store(F1ON, SFNO)
		Store(F2ON, PFNO)

		Store(0, PFNL)		// PS Fan on
		Store(0, PFNM)

		Store(0, SFNL)		// due to hardware bug (Kahneeta)
		Store(1, SFNM)		// need to keep Low and(or) Midium mode set
	}

	Method(_OFF) {			// Set PS FAN to LOW
Store(" Global Fan Off (OFF)" ,Debug)
		Xor(F1ON, 1, SFNO)
		Xor(F2ON, 1, PFNO)

		Store(0, PFNL)		// PS Fan on
		Store(0, PFNM)

		Store(0, SFNL)
		Store(0, SFNM)
	}
	}				// End resource for FAN

//---------------------------------------------------------------------
//	2. Power Resources for FAN1 (System Fan)
//---------------------------------------------------------------------
	PowerResource(SFN0,0,0)	// System fan speed = MEDIUM or HIGH
	{
	Method(_STA)
	{
//		Return(And(Xor(SFN0, F1ON), And(SFNM, SFNL)))
		Return(And(Xor(SFNO, And(Not(F1ON),1)), And(SFNM, Not(SFNL))))
	}

	Method(_OFF)		// Turn system fan to medium speed
	{
Store(" System Fan Midium (OFF)" ,Debug)
		Store(F1ON,SFNO)
		Store(0, SFNL)
		Store(1, SFNM)
	}


	Method(_ON)		// Turn system fan to high speed
	{
Store(" System Fan High (ON)" ,Debug)
		Store(F1ON,SFNO)

		Store(0,SFNL)		// due to hardware bug
		Store(1,SFNM)		// need to keep Low and(or) Midium mode set
//		Store(1,SFNL)
//		Store(1,SFNM)
	}
	}

	PowerResource(SFN1,0,0)	// System fan speed = LOW or MEDIUM
	{
	Method(_STA)
	{
		Return(And(Xor(SFNO, And(Not(F1ON),1)), And(SFNM, Not(SFNL))))
	}

	Method(_OFF)		// Turn system fan to low speed
	{
Store(" System Fan Low (OFF)" ,Debug)
		Store(F1ON, SFNO)
		Store(1, SFNL)
		Store(0, SFNM)
	}


	Method(_ON)		// Turn system fan to medium speed
	{
Store(" System Fan Midium (ON)" ,Debug)
		Store(F1ON, SFNO)
		Store(0, SFNL)
		Store(1, SFNM)
	}
	}

	PowerResource(SFN2,0,0)	//System fan speed = OFF or LOW
	{

	Method(_STA)		// Return system fan status
	{
		Return(And(Xor(SFNO, And(Not(F1ON),1)), And(Not(SFNM), SFNL)))
	}

	Method(_OFF)		// Turn system fan off
	{
Store(" System Fan OFF (OFF)" ,Debug)
		Xor(F1ON, 1, SFNO)
		Store(0, SFNL)
		Store(0, SFNM)
	}

	Method(_ON)		// Turn system fan to low speed
	{
Store(" System Fan Low (ON)" ,Debug)
		Store(F1ON, SFNO)
		Store(1, SFNL)
		Store(0, SFNM)
	}
	}

//---------------------------------------------------------------------
//	3. Power Resources for FAN2 (Power Supply Fan)
//---------------------------------------------------------------------

	PowerResource(PFN0,0,0)	//Power supply fan speed = MEDIUM or HIGH
	{
	Method(_STA)
	{
		Return(And(Xor(PFNO, And(Not(F2ON),1)), And(PFNM, PFNL)))
	}

	Method(_OFF)		// Turn power supply fan to medium speed
	{
Store(" PS Fan Midium (OFF)" ,Debug)
		Store(F2ON, PFNO)
		Store(0, PFNL)
		Store(1, PFNM)
	}

	Method(_ON)		// Turn power supply fan to high speed
	{
Store(" PS Fan High (ON)" ,Debug)
		Store(F2ON, PFNO)
		Store(1, PFNL)
		Store(1, PFNM)
	}
	}

	PowerResource(PFN1,0,0)	//Power supply fan speed = LOW or MEDIUM
	{
	Method(_STA)		// Return power supply fan status
	{
		Return(And(Xor(PFNO, And(Not(F2ON),1)), And(PFNM, Not(PFNL))))
	}

	Method(_OFF)		// Turn power supply fan to low speed
	{
Store(" PS Fan Low (OFF)" ,Debug)
		Store(F2ON, PFNO)
		Store(1, PFNL)
		Store(0, PFNM)
	}

	Method(_ON)		// Turn power supply fan to medium speed
	{
Store(" PS Fan Midium (ON)" ,Debug)
		Store(F2ON, PFNO)
		Store(0, PFNL)
		Store(1, PFNM)
	}
	}

	PowerResource(PFN2,0,0)	//Power supply fan speed = OFF or LOW
	{
	Method(_STA)		// Return power supply fan status
	{
		Return(And(Xor(PFNO, And(Not(F2ON),1)), And(Not(PFNM), PFNL)))
	}

	Method(_OFF)		// Turn power supply fan off
	{
Store(" PS Fan OFF (OFF)" ,Debug)
		Xor(F2ON, 1, PFNO)
		Store(0, PFNL)
		Store(0, PFNM)
	}

	Method(_ON)		// Turn power supply fan to low speed
	{
Store(" PS Fan Low (ON)" ,Debug)
		Store(F2ON, PFNO)
		Store(1, PFNL)
		Store(0, PFNM)
	}
	}
//---------------------------------------------------------------------