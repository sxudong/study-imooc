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
// 		SMB support for MAX1617 thermal sensor
//			control for local sensor
//**********************************************************************;
// change max1617 trip point
	Method(TCHG, 0) {

	Store(RBYT(TSAD, 0x00), Local0) // Read local Current temp

//	Add(Local0, 0x5, Local1)	// Set Thigh T + 5.0 C

////	Subtract(Local0, 0x5, Local2)	// Set Tlow  T - 5.0 C
//	Subtract(Local0, 0x2, Local2)	// Set Tlow  T - 2.0 C

//	Subtract(TMIN, 0x5, Local3)	// Set Tlow  TMIN - 5.0 C
//	If(LGreater(Local2,Local3))
//			{Store(Local3,Local2)}
//	STOS(Local1)		// Set Thigh
//	STHY(Local2)		// Set Tlow
	STOS(0x7f)		// Set Thigh
	STHY(0xbf)		// Set Tlow
	RBYT(TSAD, 0x02)	// Read status byte after limit changes
				// Clears ALARM bit
/*
	Store(RBYT(TSAD, 0x07), Local0)	// remote high limit
	Store(RBYT(TSAD, 0x08), Local1)	// remote low limit
	Store(RBYT(TSAD, 0x01), Local2)	// remote current temp
	RBYT(TSAD, 0x02)		// Read status byte
	if( LGreaterEqual(Local2,Local0) ) {
		// High limit alert
		if( LEqual(Local0, TMIN) ) {
			// Set TMAX to high limit & TMIN-2 to low limit
			STOS(TMAX)		// Set Thigh to TMAX
			Subtract(TMIN, 2, Local3)
			STHY(Local3)		// Set Tlow to TMIN-2
		}
		else {
			if( LEqual(Local0, TMAX) ) {
				// Set TCRT to high limit & TMAX-2 to low limit
				STOS(TCRT)		// Set Thigh to TCRT
				Subtract(TMAX, 2, Local3)
				STHY(Local3)		// Set Tlow to TMAX-2
			}
			else {
				if( LEqual(Local0, TCRT) ) {
					// Notify OS to shutdown
					// Set Extreeme high to high limit & TCRT-2 to low limit
					STOS(0x7f)		// Set Thigh to extreeme high (127C)
					Subtract(TCRT, 2, Local3)
					STHY(Local3)		// Set Tlow to TCRT-2
				}
//				else {
//					// This from init. set TMIN to high & Extreeme to low limit
//					STOS(TMIN)		// Set Thigh to TMIN
//					STHY(0xc9)		// Set Tlow to extreeme low (-55C)
//				}
			}
		}
	}
	else {
		if( LLessEqual(Local2, Local1) ) {
			// Low limit alert
			if( LLess(Local1, TMIN) ) {
				// Set TMIN to high limit & Extreeme to low limit
				STOS(TMIN)		// Set Thigh to TMIN
				STHY(0xc9)		// Set Tlow to extreeme low (-55C)
			}
			else {
				if( LLess(Local1, TMAX) ) {
					// Set TMAX to high limit & TMIN-2 to low limit
					STOS(TMAX)		// Set Thigh to TMAX
					Subtract(TMIN, 2, Local3)
					STHY(Local3)		// Set Tlow to TMIN-2
				}
				else {
					if( LLess(Local1, TCRT) ) {
						// Set TCRT to high limit & TMAX-2 to low limit
						STOS(TCRT)		// Set Thigh to TCRT
						Subtract(TMAX, 2, Local3)
						STHY(Local3)		// Set Tlow to TMAX-2
					}
//					else {
//						// This from init. set TMIN to high & Extreeme to low
//						STOS(TMIN)		// Set Thigh to TMIN
//						STHY(0xc9)		// Set Tlow to extreeme low (-55C)
//					}
				}
			}
		}
	}
		

	RBYT(TSAD, 0x02)		// Read status byte after limit changes	
	RSBT(0x19, 0) 	         	// Receive Byte, Addr 0x18
*/
	}

// Set configuration register #0x9
Method(SCFG, 1) {
	// Arg0 = configuration byte

	WBYT(TSAD, 0x09, Arg0)
 }

// Read Status Byte
Method(RSTS, 0) {
	// Arg0 = configuration byte

        Return(RBYT(TSAD, 0x02))
 }

// Set Tos register #0xb
Method(STOS, 1) {
	// Arg0 = temperature low byte

	// Set pointer register (occupy the command byte) to 0x0B

	 WBYT(TSAD, 0x0B, Arg0)
 }

// Set Thyst register #0xC
Method(STHY, 1) {
	// Arg0 = temperature low byte

	// Set pointer register (occupy the command byte) to 0x0C
	WBYT(TSAD, 0x0C, Arg0)
 }
// Get Tos register #0x5
Method(GTOS, 0) {

	 Store(RBYT(TSAD, 0x05), Debug)
 }

// Set Thyst register #0x6
Method(GTHY, 0) {

	Store(RBYT(TSAD, 0x06), Debug)
 }

// Read local temperature register

Method(RTMP, 0) {
	// Set pointer register (occupy the command byte) to 0x00

	Store(RBYT(TSAD, 0x00), Local0)

Store(Local0, DBG8)

	If(Not(Local0)) 	// Read command completed
		{
		Return( Local0 )
		}
	Else 			// Read command failed
		{
		Store("_TMP Read ERROR", Debug)
		Return(Add(TMIN, 2))	// MIN trip point + 2.0 C
		}
} // Method(RTMP)

// MAX1617 Thermal interrupt handler
Method(THDL,0) {
//**********************************************************************;
	TCHG()			// change Trip points
				// Clear ALARM bit
	RSBT(0x19, 0)          	// Receive Byte, Addr 0x18
//**********************************************************************;
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
