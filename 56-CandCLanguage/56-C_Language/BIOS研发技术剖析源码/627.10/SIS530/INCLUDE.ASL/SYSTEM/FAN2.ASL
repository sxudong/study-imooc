//---------------------------------------------------------------------
// 	FANs Power Resources
//---------------------------------------------------------------------
// Names defined in AMI.ASL:
//	FN10, FN11 - control bits for FAN1
//	FN20, FN21 - control bits for FAN2
// Module contents:
//	1. Power Resources for Global FAN
//	2. Power Resources for FAN1
//	3. Power Resources for FAN2
//---------------------------------------------------------------------

//	1. Power Resources for Global FAN

	PowerResource(GFAN, 0, 0){              // Power Resource
						// for PS/Case Fan

	Method(_STA) {				// Get Fans Status

	Return( And(And(FN10, FN11), And(FN10, FN11)) )
	}

	Method(_ON)  {				// Set PS & Case FAN to High Speed
Store(" Global Fan High (ON)" ,Debug)
		Store(1, FN10)
		Store(1, FN11)
		Store(1, FN20)
		Store(1, FN21)

	}

	Method(_OFF) {                  // Set PS FAN to OFF
Store(" Global Fan Off (OFF)" ,Debug)
		Store(0, FN10)
		Store(0, FN11)
		Store(0, FN20)
		Store(0, FN21)
	}
	}				// End resource for FAN

//---------------------------------------------------------------------
//	2. Power Resources for FAN1
//	CPU FAN
//---------------------------------------------------------------------
//	Status flags for System & PS FANs

	PowerResource(SFN0,0,0)	//System fan speed = MEDIUM or HIGH
	{
	Method(_STA)
	{
		Return(And(FN10, FN11))
	}

	Method(_OFF)		// Turn system fan to medium speed
	{
Store(" System Fan Midium (OFF)" ,Debug)
		Store(0, FN10)
		Store(1, FN11)
	}


	Method(_ON)		// Turn system fan to high speed
	{
Store(" System Fan High (ON)" ,Debug)
		Store(1, FN10)
		Store(1, FN11)
	}

	}

	PowerResource(SFN1,0,0)	// System fan speed = LOW or MEDIUM
	{
	Method(_STA)
	{
		Return(And(FN11, Not(FN10)))
	}

	Method(_OFF)		// Turn system fan to low speed
	{
Store(" System Fan Low (OFF)" ,Debug)
		Store(1, FN10)
		Store(0, FN11)
	}

	Method(_ON)		// Turn system fan to medium speed
	{
Store(" System Fan Midium (ON)" ,Debug)
		Store(0, FN10)
		Store(1, FN11)
	}
	}

	PowerResource(SFN2,0,0)	//System fan speed = OFF or LOW
	{

	Method(_STA)		// Return system fan status
	{
		Return(And(FN10, Not(FN11)))
	}

	Method(_OFF)		// Turn power supply fan off
	{
Store(" System Fan OFF (OFF)" ,Debug)
		Store(0, FN10)
		Store(0, FN11)
	}

	Method(_ON)		// Turn power supply fan to low speed
	{
Store(" System Fan Low (ON)" ,Debug)
		Store(1, FN10)
		Store(0, FN11)
	}
	}

//---------------------------------------------------------------------
//	3. Power Resources for FAN2
// 	Power supply FAN
//---------------------------------------------------------------------

	PowerResource(PFN0,0,0)	//Power supply fan speed = MEDIUM or HIGH
	{
	Method(_STA)
	{
		Return(And(FN20, FN21))
	}

	Method(_OFF)		// Turn power supply fan to medium speed
	{
Store(" PS Fan Midium (OFF)" ,Debug)
		Store(0, FN20)
		Store(1, FN21)
	}

	Method(_ON)		// Turn power supply fan to high speed
	{
Store(" PS Fan High (ON)" ,Debug)
		Store(1, FN20)
		Store(1, FN21)
	}
	}

	PowerResource(PFN1,0,0)	//Power supply fan speed = LOW or MEDIUM
	{
	Method(_STA)		// Return power supply fan status
	{
		Return(And(FN21, Not(FN20)))
	}

	Method(_OFF)		// Turn power supply fan to low speed
	{
Store(" PS Fan Low (OFF)" ,Debug)
		Store(1, FN20)
		Store(0, FN21)
	}

	Method(_ON)		// Turn power supply fan to medium speed
	{
Store(" PS Fan Midium (ON)" ,Debug)
		Store(0, FN20)
		Store(1, FN21)
	}
	}

	PowerResource(PFN2,0,0)	//Power supply fan speed = OFF or LOW
	{
	Method(_STA)		// Return power supply fan status
	{
		Return(And(FN20, Not(FN21)))
	}

	Method(_OFF)		// Turn power supply fan off
	{
Store(" PS Fan OFF (OFF)" ,Debug)
		Store(0, FN20)
		Store(0, FN21)
	}

	Method(_ON)		// Turn power supply fan to low speed
	{
Store(" PS Fan Low (ON)" ,Debug)
		Store(1, FN20)
		Store(0, FN21)
	}
	}
//---------------------------------------------------------------------
