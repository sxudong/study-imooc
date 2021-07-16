
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
	extrn	_NUM_OF_PROC		:byte


;*****************************************************************************;
;*****************************************************************************;
;*****************                                  **************************;
;*****************            MP Library Equates    **************************;
;*****************                                  **************************;
;*****************************************************************************;
;*****************************************************************************;

	_SPIN_LOCK		EQU	0f800h


;*****************************************************************************;
cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
;*****************************************************************************;
	.486p



Public				InitCPU@Shutdown
InitCPU@Shutdown		PROC	NEAR


	ret
;;;;	jmp	InitCPU@Runtime
	
InitCPU@Shutdown		ENDP

;*****************************************************************************;


Public				InitializeAPIC
Public				initialize_apic
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



;*****************************************************************************;
;*****************************************************************************;
;*****************************************************************************;
;********                                                             ********;
;********                    MULTI PROCESSOR ROUTINES                 ********;
;********                                                             ********;
;*****************************************************************************;
;*****************************************************************************;
;*****************************************************************************;


;-----------------------------------------------------------------------------;
;		    INITIALIZE ALL APPLICATION PROCESSORS		      ;
;-----------------------------------------------------------------------------;
;	This procedure puts all the application processors in the INIT state. ;
;-----------------------------------------------------------------------------;
;	Input	: none							      ;
;	Output	: none							      ;
;	Reg use	: does not destroy any register				      ;
;-----------------------------------------------------------------------------;

Public				InitAP
InitAP				PROC	NEAR

	push	ds
	pushad
	push	cs
	call	EnableFlatMode			; DS = 0000h, 4GB limit
	call	ToAllINIT			; Send INIT_IPI to all AP
	push	cs
	call	DisableFlatMode			; DS = 0000h, 64K limit
	popad
	pop	ds
	ret

InitAP				ENDP

;-----------------------------------------------------------------------------;
;		      WAKE UP ALL APPLICATION PROCESSORS		      ;
;-----------------------------------------------------------------------------;
;	This procedure wakes up all application processors and jumps to the   ;
;	address specified by the caller. It also sets the 1024 byte stack     ;
;	for each application processor.					      ;
;-----------------------------------------------------------------------------;
;	Input	: far*	= routine to jump on stack			      ;
;		  word	= a 64K scratch segment on stack		      ;
;									      ;
;			|-------------------------------|		      ;
;			|     Caller routine segment	|		      ;
;			|-------------------------------| 6		      ;
;			|     Caller routine offset	|		      ;
;			|-------------------------------| 4		      ;
;			|     Scratch Segment (64KB)	|		      ;
;			|-------------------------------| 2		      ;
;			|	  Return Address	|		      ;
;		    SP->|-------------------------------| 0		      ;
;									      ;
;	Output	: FS = set to local data segment for AP  (1KB)		      ;
;		  GS = set to global data segment for AP (32KB)		      ;
;		  DS = will be set as BSP				      ;
;		  ES = will be set as BSP				      ;
;		  Application processor will be assigned to a 512 byte stack  ;
;	Reg use	: does not destroy any register				      ;
;-----------------------------------------------------------------------------;
;	Note:								      ;
;	This procedure should be invoked by the following		      ;
;		push	segment for caller routine address		      ;
;		push	offset  for caller routine address		      ;
;		push	scratch segment					      ;
;		call	WakeUpAP					      ;
;-----------------------------------------------------------------------------;

Public				WakeUpAP
WakeUpAP			PROC	NEAR	PASCAL	routx:dword, sseg:word

	push	ds
	push	es
	pushad
	mov	bx,ds				; Current DS of BSP
	mov	dx,es				; Current ES of BSP
	mov	eax,routx			; EAX = far* of routine address
	mov	es,sseg				; ES = 64K scratch segment
	call	ReadyStartupCode		; Make StartupCode ready to IPI
	push	cs
	call	EnableFlatMode			; DS = 0000h, 4GB limit
	mov	ebx,0fee00310h
	mov	edi,dword ptr[ebx]
	mov	bl,0
	mov	esi,dword ptr[ebx]
	call	ClearICR
	or	esi,(ORMaskStartup OR 000c0000h); IPI to all but self
	mov	ax,es
	shr	ax,8				; AX = vector for STARTUP_IPI
	or	si,ax				; ESI = ICR HI value to write
	call	WriteICR			; Send STARTUP_IPI to all agent
	call	TenMSDelay			; Give 10 milisec delay
	push	cs
	call	DisableFlatMode			; DS = 0000h, 64K limit
	popad
	pop	es
	pop	ds
	ret
	
WakeUpAP			ENDP


;-----------------------------------------------------------------------------;
;				SpinLockBSP				      ;
;-----------------------------------------------------------------------------;
;	This procedure keeps track of spin lock for BSP. This procedure waits ;
;	until all the APs finished their job				      ;
;-----------------------------------------------------------------------------;
;	Input	: MP scratch segment on stack				      ;
;	Output	: none							      ;
;-----------------------------------------------------------------------------;
;	Reg use	: does not destroy any registers			      ;
;-----------------------------------------------------------------------------;

Public			SpinLockBSP
SpinLockBSP		PROC	NEAR	PASCAL	mpseg:word

	push	ds
	push	ax
        
	mov	ds,mpseg
	mov	al,cs:byte ptr _NUM_OF_PROC
wait_sl:
	cmp	ds:byte ptr[_SPIN_LOCK],al
	jnz	wait_sl

        pop     ax
	pop	ds
        
	ret

SpinLockBSP		ENDP

;-----------------------------------------------------------------------------;
;				SpinLockAP				      ;
;-----------------------------------------------------------------------------;
;	This procedure keeps track of spin lock for AP.			      ;
;-----------------------------------------------------------------------------;
;	Input	: none, SS should be set to the MP library stack segment      ;
;	Output	: none							      ;
;-----------------------------------------------------------------------------;
;	Reg use	: does not destroy any registers			      ;
;-----------------------------------------------------------------------------;

Public			SpinLockAP
SpinLockAP		PROC	NEAR

	push	ds
	push	ss
	pop	ds
lock	inc	ds:byte ptr[_SPIN_LOCK]
	pop	ds
	ret

SpinLockAP		ENDP

;-----------------------------------------------------------------------------;
Extern				_NUM_OF_PROC:BYTE
Public				ToAllInit
ToAllINIT			PROC	NEAR

	cmp	cs:byte ptr _NUM_OF_PROC,1
	jz	ret_tai
	mov	ebx,0fee00310h			; ICR-HI
	mov	edi,dword ptr[ebx]		; Current content
	mov	bl,00h				; ICR-LO
	mov	esi,dword ptr[ebx]		; Get current setting
	call	ClearICR
	or	esi,(ORMaskINIT OR 000c0000h)	; All but self
	call	WriteICR			; Send INIT_IPI
TenMSDelay::
	push	cx
	mov	cx,50				; For 10 millisec
delay10ms:
	call	BusDelay			; Give 200 microsec
	loop	delay10ms
	pop	cx
ret_tai:
	ret

ToAllINIT			ENDP


;-----------------------------------------------------------------------------;
;				INIT LOCAL APIC				      ;
;-----------------------------------------------------------------------------;
;	This procedure initializes the LocalAPIC into the virtual wire mode.  ;
;-----------------------------------------------------------------------------;
;	Input	: none							      ;
;	Output	: none							      ;
;	Reg use	: EAX, EBX						      ;
;-----------------------------------------------------------------------------;

Public				InitLocalAPIC
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


;-----------------------------------------------------------------------------;

Public				BusDelay
BusDelay			PROC	NEAR

; Assumption: 200MHz CPU, gives a 200 microsec delay

	push	ax
	push	cx
	in	ax,80h
	mov	cx,200				; For 10 milisec delay
do_bus_delay:
	push	cx
	mov	cx,12				; For 1 microsec delay
bd_00:	
	out	80h,ax
	loop	bd_00				; Complete 1 micro sec delay
	pop	cx
	loop	do_bus_delay			; Complete 200 microsec
	pop	cx
	pop	ax
	ret
	
BusDelay			ENDP
	
;-----------------------------------------------------------------------------;
;				   WRITE ICR				      ;
;-----------------------------------------------------------------------------;
;	Procedure writes the Interrupt Command Register with the supplied     ;
;	data.								      ;
;	Input	: ESI = ICR-LO, EDI = ICR-HI				      ;
;		  DS selector is set: 4GB limit and DS = 0		      ;
;		  Upper 16 bit of EBX is set to 4KB page base of APIC memory  ;
;		  mapped I/O (e.g. FEE0h)				      ;
;	Output	: none							      ;
;	Reg use	: only BX, EAX is destroyed				      ;
;-----------------------------------------------------------------------------;

Public				WriteICR
WriteICR			PROC	NEAR

	mov	bx,0310h			; ICR-HI reg
	mov	dword ptr[ebx],edi		; Write destination
	mov	bl,00h				; ICR-LO reg
	mov	dword ptr[ebx],esi		; Generate IPI
	call	BusDelay
	ret
	
WriteICR			ENDP
	

;-----------------------------------------------------------------------------;
;			      READY STARTUP CODE			      ;
;-----------------------------------------------------------------------------;
;	Procedure makes the STARTUP_IPI code ready to jump the handler.	      ;
;	Input	: EAX = far* of handler to jump				      ;
;		  ES = 64K scratch segment (at 4KB page)		      ;
;		  BX = Current DS of BSP				      ;
;		  DX = Current ES of BSP				      ;
;	Output	: FS = set to local data segment for AP  (1KB)		      ;
;		  GS = set to global data segment for AP (32KB)		      ;
;		  DS = will be set as BSP				      ;
;		  ES = will be set as BSP				      ;
;		  Application processor will be assigned to a 512 byte stack  ;
;	Reg use	: destroys SI, DI, AX, CX				      ;
;-----------------------------------------------------------------------------;


ap_startup_code:
		lock	bts	cs:word ptr[(offset local_semaphore - offset ap_startup_code)],0
			jc	ap_startup_code
			mov	ax,cs
			mov	ss,ax
			mov	sp,cs:word ptr[(offset ap_stack_top - offset ap_startup_code)]
		lock	sub	cs:word ptr[(offset ap_stack_top - offset ap_startup_code)],512
			mov	al,0
			push	ax
			inc	ah
			mov	gs,ax
			pop	ax
			add	ax,cs:word ptr[(offset ap_local_ds - offset ap_startup_code)]
			mov	fs,ax
			mov	ds,cs:word ptr[(offset bsp_ds - offset ap_startup_code)]
			mov	es,cs:word ptr[(offset bsp_es - offset ap_startup_code)]
			add	cs:word ptr[(offset ap_local_ds - offset ap_startup_code)],40h
			push	ds
			push	es
			push	fs
			push	gs
			push	ss
			push	(offset global_semaphore - offset ap_startup_code)
		lock	and	cs:word ptr[(offset local_semaphore - offset ap_startup_code)],0fffeh
			call	cs:dword ptr[(offset ap_startup_code_end - offset ap_startup_code)]
			jmp	$
ap_startup_code_end:
ap_startup_offset	dw	00000h
ap_startup_seg		dw	00000h
ap_stack_top		dw	0f000h
ap_local_ds		dw	00900h
bsp_ds			dw	00000h
bsp_es			dw	00000h
global_semaphore	dw	00000h
local_semaphore		dw	00000h
ap_startup_end_label:

Public				ReadyStartupCode
ReadyStartupCode		PROC	NEAR

	cld					; Clear direction flag
	xor	di,di
	mov	cx,8000h
	push	eax
	xor	ax,ax
rep	stosw					; Clear segment

;-----------------------------------------------;
; Initialize MP global data....			;
;-----------------------------------------------;

	mov	es:byte ptr[_SPIN_LOCK],1	; SpinLock check byte = 1

;-----------------------------------------------;

	mov	cx,(offset ap_startup_end_label - offset ap_startup_code)
	xor	di,di
	mov	si,offset ap_startup_code
rep	movs	byte ptr es:[di], cs:[si]
	pop	eax
	mov	di,(offset ap_startup_offset - offset ap_startup_code)
	mov	es:word ptr[di],ax		; Offset of far*
	shr	eax,16
	mov	es:word ptr[di+2],ax		; Segment of far*
	mov	di,(offset bsp_ds - offset ap_startup_code)
	mov	es:word ptr[di],bx
	mov	di,(offset bsp_es - offset ap_startup_code)
	mov	es:word ptr[di],dx
	mov	di,0fff0h
	mov	ax,0eebh
	stosw					; Older P6 patch
	ret
	
ReadyStartupCode		ENDP

;-----------------------------------------------------------------------------;
;				BEGIN LOCK SECTION			      ;
;-----------------------------------------------------------------------------;
;	This procedure locks the critical section followed by.		      ;
;-----------------------------------------------------------------------------;
;	Input	: none, SS should be set to MP library stack segment	      ;
;	Output	: none							      ;
;	Reg use	: does not destroy any register				      ;
;-----------------------------------------------------------------------------;

Public			BeginLockSection
BeginLockSection	PROC	NEAR

	push	ds
	push	si
	push	ss
	pop	ds				; DS = AP segment
	mov	si,(offset global_semaphore - offset ap_startup_code)
wait_ap:
lock	bts	ds:word ptr[si],0
	jc	wait_ap
	pop	si
	pop	ds
	ret
	
BeginLockSection	ENDP	
	
;-----------------------------------------------------------------------------;
;				END LOCK SECTION			      ;
;-----------------------------------------------------------------------------;
;	This procedure unlocks the access of a critical section for an AP.    ;
;-----------------------------------------------------------------------------;
;	Input	: none, SS should be set to MP library stack segment	      ;
;	Output	: none							      ;
;	Reg use	: does not destroy any register				      ;
;-----------------------------------------------------------------------------;

Public			EndLockSection
EndLockSection		PROC	NEAR

	push	ds
	push	si
	push	ss
	pop	ds				; DS = AP segment
	mov	si,(offset global_semaphore - offset ap_startup_code)
lock	and	ds:word ptr[si],0fffeh
	pop	si
	pop	ds
	ret
	
EndLockSection		ENDP

;-----------------------------------------------------------------------------;

Public				ClearDest
ClearDest			PROC	NEAR

	and	edi,ClearDestMask		; Mask out destination field
	ret
	
ClearDest			ENDP
	
;-----------------------------------------------------------------------------;

Public				ClearICR
ClearICR			PROC	NEAR

	and	esi,ClearICRMask		; Keep reserved bit information
	ret
	
ClearICR			ENDP

;-----------------------------------------------------------------------------;
;-----------------------------------------------------------------------------;

Public				CheckPtCPU
CheckPtCPU			PROC	NEAR

	push	ax
	mov	al,0
	out	80h,ax
	pop	ax
	ret
	
CheckPtCPU			ENDP
	
;-----------------------------------------------------------------------------;

Public				IncSubChkPt
IncSubChkPt			PROC	NEAR
	pushf
	push	ax
	in	ax,80h
	inc	al
	out	80h,ax
	pop	ax
	popf
	ret

IncSubChkPt			ENDP

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




;*****************************************************************************;



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

