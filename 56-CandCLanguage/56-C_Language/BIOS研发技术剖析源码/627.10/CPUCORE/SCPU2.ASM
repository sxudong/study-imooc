
	page	,132
	title	MULTIPLE CPU HANDLER

;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1996, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;


;*****************************************************************;



	INCLUDE	CPUMAC.MAC
	INCLUDE	CPUSTRUC.DEF
	INCLUDE	CPUEQU.EQU

	extrn	InitCPU@Runtime		:near


;*****************************************************************************;
cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
;*****************************************************************************;
	.486p



Public				InitCPU@Shutdown
InitCPU@Shutdown		PROC	NEAR

;-----------------------------------------------;
; SO FAR KNOWLEDGE GOES, DO NOT DO ANYTHING	;
; HERE. THIS HOOK IS MAINTAINED IF IN FUTURE	;
; WE NEED TO DO SOMETHING !!!!			;
;-----------------------------------------------;

	ret
;;;;	jmp	InitCPU@Runtime

	
InitCPU@Shutdown		ENDP


;*****************************************************************************;


Public				InitializeAPIC
Public				initialize_apic
Public				InitLocalApic
Public				DoInitAPIC
InitializeAPIC			PROC	NEAR
initialize_apic			PROC	NEAR

	mov	ah,0c6h
	call	CheckPtCPU			;==== C6 00 ==================
DoInitAPIC::
	push	ds
	push	cs
	call	EnableFlatMode			; DS = 4GB limit
	call	IncSubChkPt			;==== C6 01 =================
	call	InitLocalAPIC			; Initializes Local APIC
	push	cs
	call	DisableFlatMode			; DS = 64KB limit
	call	IncSubChkPt			;==== C6 04 =================
	pop	ds
	ret

initialize_apic			ENDP
InitializeAPIC			ENDP

InitLocalApic			PROC	NEAR

	in	al,21h
	mov	ah,al
	jcxz	$+2
	in	al,0a1h
	push	ax
	mov	al,0ffh
	out	21h,al
	jcxz	$+2
	jcxz	$+2
	out	0a1h,al
	call	IncSubChkPt			;==== Next sub check point ====
	cli
	mov	ebx,0fee00370h			; ERRINT reg
	mov	eax,dword ptr[ebx]		; Read curent ERRINT reg
	mov	al,0fh
	mov	dword ptr[ebx],eax		; Set ERRINT to vector 0Fh
	mov	bx,00f0h			; SVR
	mov	eax,dword ptr[ebx]		; Read SVR data
	and	al,0fh				; Clear SVR, use vector 00fh
	or	ah,00000001b			; Set bit-8, Enable APIC
	mov	dword ptr[ebx],eax		; Write SVR
	mov	bx,0350h			; EBX = LVT1
	mov	eax,dword ptr[ebx]		; Read current LVT1
	and	eax,0fffe58ffh			; Not masked, active high, edge
	or	ah,07h				; Enable ExtInt (IRQ0 - IRQ15)
	mov	dword ptr[ebx],eax		; Write to LVT1
	mov	bl,60h				; EBX = LVT2
	mov	eax,dword ptr[ebx]		; Read current LVT2
	and	eax,0fffe58ffh			; Not masked, active high, edge
	or	eax,0fffe0400h			; Enable NMI
	mov	dword ptr[ebx],eax		; Write to LVT2
	call	IncSubChkPt			;==== Next sub check point ====
	pop	ax
	out	0a1h,al
	jcxz	$+2
	jcxz	$+2
	mov	al,ah
	out	21h,al
	ret

InitLocalApic			ENDP

;*****************************************************************************;

Public				CheckPtCPU
CheckPtCPU			PROC	NEAR

	push	ax
	push	dx
	mov	dx,80h
	mov	al,0
	out	dx,ax
	pop	dx
	pop	ax
	ret
	
CheckPtCPU			ENDP
	
;-----------------------------------------------------------------------------;

Public				IncSubChkPt
IncSubChkPt			PROC	NEAR

	push	ax
	push	dx
	mov	dx,80h
	in	ax,dx
	inc	al
	out	dx,ax
	pop	dx
	pop	ax
	ret
	
IncSubChkPt			ENDP


;*****************************************************************************;
;*****************************************************************************;
;*****************                                  **************************;
;*****************          MP Library Routines     **************************;
;*****************                                  **************************;
;*****************************************************************************;
;*****************************************************************************;


Public			InitAP
InitAP			PROC	NEAR

	ret

InitAP			ENDP

;-----------------------------------------------------------------------------;

Public			WakeUpAP
WakeUpAP		PROC	NEAR	PASCAL	routx:dword, sseg:word

	ret
	
WakeUpAP			ENDP

;-----------------------------------------------------------------------------;

Public			SpinLockBSP
SpinLockBSP		PROC	NEAR	PASCAL	mpseg:word

	ret

SpinLockBSP		ENDP

;-----------------------------------------------------------------------------;

Public			SpinLockAP
SpinLockAP		PROC	NEAR

	ret

SpinLockAP		ENDP

;-----------------------------------------------------------------------------;

Public			BeginLockSection
BeginLockSection	PROC	NEAR

	ret
	
BeginLockSection	ENDP	
	
;-----------------------------------------------------------------------------;

Public			EndLockSection
EndLockSection		PROC	NEAR

	ret
	
EndLockSection		ENDP


;*****************************************************************************;
;*****************************************************************************;
;*****************************************************************************;
;********                                                             ********;
;********                    FLAT MODE ACCESS ROUTINES                ********;
;********                                                             ********;
;*****************************************************************************;
;*****************************************************************************;
;*****************************************************************************;


	extrn	enable_8042_bit_20		:near
	extrn	enable_addr_bit_20		:near
	extrn	disable_8042_bit_20		:near
	extrn	disable_addr_bit_20		:near

;-----------------------------------------------------------------------------;
;				ENABLE FLAT MODE			      ;
;-----------------------------------------------------------------------------;
;	Enables Processors flat mode for DS				      ;
;	Input	: none							      ;
;	Output	: DS = 0, DS selector limit = 4GB			      ;
;	Reg use	: does not destroy any register except DS		      ;
;-----------------------------------------------------------------------------;

Public				EnableFlatMode
EnableFlatMode			PROC	NEAR

	push	ax
	push	dx
	mov	dl,1				; 4GB limit
	call	SetLimitToDS			; Set segment limit as 4GB
	xor	ax,ax				; Real mode segment val = 0
	mov	ds,ax				; DS = 0, but limit is 4GB
	pop	dx
	pop	ax
	retf

EnableFlatMode			ENDP

;-----------------------------------------------------------------------------;
;				DISABLE FLAT MODE			      ;
;-----------------------------------------------------------------------------;
;	Enables Processors flat mode for DS				      ;
;	Input	: none							      ;
;	Output	: DS = 0, DS selector limit = 4GB			      ;
;	Reg use	: does not destroy any register except DS		      ;
;-----------------------------------------------------------------------------;

Public				DisableFlatMode
DisableFlatMode			PROC	NEAR

	push	dx
	mov	dl,0				; 64KB limit
	call	SetLimitToDS			; Set segment limit as 4GB
	call	disable_8042_bit_20		; Disable GateA20 line
	pop	dx
	retf

DisableFlatMode			ENDP


;-----------------------------------------------------------------------------;
;				SET LIMIT TO DS				      ;
;-----------------------------------------------------------------------------;
;	Sets the segment limit to DS register				      ;
;	Input	: DL =	0: 64KB limit					      ;
;			1: 4GB limit					      ;
;	Output	: none							      ;
;	Reg use	: does not destroy any register				      ;
;-----------------------------------------------------------------------------;

SetLimitToDS:
	pushf
	push	eax
	push	ebx
	cli					; Disable interrupt
	mov	al,8dh
	out	70h,al				; Disable NMI

	xor	eax,eax
	xor	ebx,ebx
	mov	ax,cs
	shl	eax,4
	mov	bx,offset FlatGDT
	add	eax,ebx				; EAX = 32 bit linear address

	mov	bx,offset GDTDesc
	mov	cs:[bx].PSEUDODESCSTRUC.dGDTaddr,eax
	call	enable_8042_bit_20		; Enable GateA20 line
	lgdt	cs:fword ptr GDTDesc		; Load GDTR
	mov	eax,cr0
	or	al,01				; Enable protected mode
	mov	cr0,eax				; Write to control reg0
	jmp	pm_flush_queue
pm_flush_queue:
	mov	ax,(offset DataDesc4GB - offset FlatGDT)
	or	dl,dl				; 4GB limit ?
	jnz	ok_limit			; Yes..
	mov	ax,(offset DataDesc64KB - offset FlatGDT)
ok_limit:
	mov	ds,ax				; DS = data desc, 4GB limit
	mov	eax,cr0
	and	al,0feh				; Disable protected mode
	mov	cr0,eax				; Write to CR0
	jmp	rm_flush_queue
rm_flush_queue:
	pop	ebx
	pop	eax
	popf
	ret




;*****************************************************************************;
;*									     *;
;*				PERMANENT DATA AREA			     *;
;*									     *;
;*****************************************************************************;



;---------------------------------------;
;	Definition of Descriptors	;
;---------------------------------------;

DESCSTRUC		STRUCT

	wLimit0_15	word	?		; Segment limit (A0 - A15)
	wBase0_15	word	?		; Base address (A0 - A15)
	bBase16_23	byte	?		; Base address (A16 - A23)
	bAtribute	byte	?		; Defines attribute of the seg
	bLimit16_19	byte	?		; Granularity/seg limit 16-19
	bBase24_31	byte	?		; Base address (A24 - A31)

DESCSTRUC		ENDS

PSEUDODESCSTRUC		STRUCT

	wGDTLimit	word	?		; Current GDT limit
	dGDTaddr	dword	?		; GDT 32-bit address
	
PSEUDODESCSTRUC		ENDS


;---------------------------------------;
;	Descriptor Flag EQUATES		;
;---------------------------------------;

	Accessed	EQU	00000001b	; Segment is accessed
	Writable	EQU	00000010b	; Segment is writable (data)
	Readable	EQU	00000010b	; Segment is readable (code)
	ExpandDown	EQU	00000100b	; Segment is expand-down mode
	DPL0		EQU	00000000b	; Descriptor Previlage level-0
	DPL1		EQU	00100000b	; Descriptor Previlage level-1
	DPL2		EQU	01000000b	; Descriptor Previlage level-2
	DPL3		EQU	01100000b	; Descriptor Previlage level-3
	Available	EQU	00010000b	; Segment available for system
	Big		EQU	01000000b	; Big mode (32bit operand) on
	Granularity4K	EQU	10000000b	; Segment limit = 4GB


;---------------------------------------;
;	GLOBAL DESCRIPTOR TABLE		;
;---------------------------------------;
; Format of this table :		;
; --------------------			;
;					;
;    1st entry : Null descriptor	;
;    2nd entry : GDT descriptor		;
;    3rd entry : Code seg descriptor	;
;    4th entry : Data seg descriptor	;
;    5th entry : Stack seg descriptor	;
;---------------------------------------;


		even
FlatGDT:

	NullDesc	DESCSTRUC	{0,0,0,0,0,0}

	DataDesc4GB	DESCSTRUC	{\
					  0ffffh,
					  0000h,
					  00h,
					  (90h or DPL0 or Writable),
					  (0fh or Granularity4K),
					  00h\
					}

	DataDesc64KB	DESCSTRUC	{\
					  0ffffh,
					  0000h,
					  00h,
					  (90h or DPL0 or Writable),
					  00h,
					  00h\
					}
FlatGDTEnd:

;-----------------------------------------------------------------------------;


GDTDesc		PSEUDODESCSTRUC	{\
				  (offset FlatGDTEnd - offset FlatGDT),
				  00000000h\
				}




;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1996, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
_text	ends
	end

