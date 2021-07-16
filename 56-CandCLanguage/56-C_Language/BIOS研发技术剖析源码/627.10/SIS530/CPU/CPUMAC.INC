;лллллллллллллллллллллл  MACROS USED FOR CPU DETECTION  лллллллллллллллллллллл;



	io_delay	macro			; Gives delay in successive I/O

		jcxz	$+2
		jcxz	$+2
	endm

;*****************************************************************************;

	cpu_id		macro			; Simulate 'CPUID' instruction

		db	00fh
		db	0a2h

	endm

;*****************************************************************************;

	CallNS		macro	RoutAddr	; Simulate CALL when no stack
		local	AddrToReturn, PointerToSP
		even
		mov	sp,offset PointerToSP
		jmp	RoutAddr
	PointerToSP:
		dw	offset AddrToReturn
	AddrToReturn:

	endm

;*****************************************************************************;

	IRETCS		macro			; Simulate IRET when SS = CS

		local	iret_ip
		local	iret_cs
		local	iret_flag
		local	iretcs_end
		mov	cs:word ptr iret_cs,cs
		mov	sp,offset iret_ip
		iret
		even
	iret_ip:
		dw	offset iretcs_end
	iret_cs:
		dw	0000h
	iret_flag:
		dw	0000h
	iretcs_end:

	endm

;*****************************************************************************;

	JmpDI		macro	RoutAddr
		local	AddrToReturn
		mov	di,offset AddrToReturn
		jmp	RoutAddr
	AddrToReturn:

	endm

;***************************************************************************;

	PushNS		macro	Reg

		shl	Reg,16

	endm

;***************************************************************************;

	PopNS		macro	Reg

		shr	Reg,16

	endm

;***************************************************************************;

	MovTR1toEAX macro

        	db  00fh
        	db  024h
        	db  0c8h

	endm

;***************************************************************************;

	MovEAXtoTR1 macro

        	db  00fh
		db  026h
        	db  0c8h

	endm

;***************************************************************************;

	MovTR2toEAX macro

        	db  00fh
        	db  024h
        	db  0d0h

	endm

;***************************************************************************;

	MovEAXtoTR2 macro

        	db  00fh
	        db  026h
        	db  0d0h

	endm

;***************************************************************************;

	MovTR4toEBX	macro

		db	00fh
		db	024h
		db	0e3h

	endm

;***************************************************************************;

	MovEBXtoTR4	macro

		db	00fh
		db	026h
		db	0e3h

	endm

;***************************************************************************;

	MovTR4toEAX	macro

		db	00fh
		db	024h
		db	0e0h

	endm

;***************************************************************************;

	MovEAXtoTR4	macro

		db	00fh
		db	026h
		db	0e0h

	endm

;***************************************************************************;

	MovEAXtoTR5	macro

		db	00fh
		db	026h
		db	0e8h

	endm

;***************************************************************************;

	RD_MSR		macro		; Read IBM Model Specific Register

		db	0fh
		db	32h

	endm

;***************************************************************************;

	WR_MSR		macro		; Write IBM Model Specific Register

		db	0fh
		db	30h

	endm

;***************************************************************************;

	RD_MTRR		macro		; Read MTRR

		db	0fh
		db	32h

	endm

;***************************************************************************;

	WR_MTRR		macro		; Write to MTRR

		db	0fh
		db	30h

	endm

;***************************************************************************;

Create_CPU$	macro	cpu_number

	public	cpu_number
		cpu_number	equ	cpu_counter

	cpu_counter = cpu_counter + 1
endm


