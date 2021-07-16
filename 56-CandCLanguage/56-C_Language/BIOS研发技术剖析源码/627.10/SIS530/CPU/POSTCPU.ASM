
	page	,132
	title	CPU CONFIGURATION MODULE
;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
	.486p

;-----------------------------------------------------------------------------;

	Extrn		GetResetID:near

;-----------------------------------------------------------------------------;
;				INCLUDES				      ;
;-----------------------------------------------------------------------------;
						; (CPU0021+)>
;;;; moved to cpu.cfg
;;;;	include	CPUCFG.INC
						; <(CPU0021+)
	include	cpu.cfg				; 
	include makeflag.equ
if (CORE_626)
	include	oemflag.equ			; 626 MKF_CUSTOMER
else
	include	oemmake.equ			; 627 MKF_CUSTOMER
endif
	include	cpustruc.inc
	include	cpumac.inc
	include	cpuequ.inc

;-----------------------------------------------------------------------------;
;			FILL_CPU_NAME_DISPLAY_BUFFER			      ;
;-----------------------------------------------------------------------------;
;  this routine fills the buffer for displaying the CPU name string from      ;
;  systen confguration display.						      ;
;  input :								      ;
;	primary cpu data area properly filled up			      ;
;  output:								      ;
;	cpu_name_display_buffer filled with proper name			      ;
;  register usage..can destroy any register except DS, ES, EBP		      ;
;  NOTE:								      ;
;	1. this routine is NOT executed from F000 segment.		      ;
;-----------------------------------------------------------------------------;

	extrn	copy_string_ds_si	:near
	extrn	cpu_number		:byte
	extrn	cpu_vendor		:byte
	extrn	cpu_resetid		:dword
	extrn	cpu_name_display_buffer	:byte

	public	fill_cpu_name_display_buffer

fill_cpu_name_display_buffer	proc	near
	push	es
	push	ds
	push	cs
	pop	es
	push	cs
	pop	ds
	mov	di,offset cpu_name_display_buffer
	mov	bx,ds:word ptr [0fea8h]
	cmp	cpu_number,UnknownCPU	; if unknown CPU then always
	jz	dcpu_0			; always copy both vendor and name
	mov	al,cpu_vendor		; functional CPU vendor#
	mov	ah,byte ptr cpu_resetid+1; get DH of reset id
	and	ah,0fh			; AH = Family#
if (CPU_486) and (CPU_UMC)
	cmp	al,UMC			; UMC cpu ?
	jz	dcpu_1			; yes
endif
	cmp	al,Intel		; Intel cpu ?
	jnz	dcpu_0			; no
	cmp	ah,05h			; 586 or later ?
	jae	dcpu_1			; yes
dcpu_0:
	cmp	ax,0601h		; Cyrix M2 CPU ?
	je	dcpu_1			; yes.. no 'Cx' string
	mov	si,word ptr [bx].CPUINFOSTRUC.dvndr$ptr; DS:SI = ptr to vendor string
	call	copy_string_ds_si	; DS:[SI] -> ES:[DI]
	dec	di
dcpu_1:
	mov	si,word ptr [bx].CPUINFOSTRUC.d$ptr; DS:SI = ptr to cpu name string
	call	copy_string_ds_si	; DS:[SI] -> ES:[DI]
dcpu_2:

							; (CPU0003-), (CPU0005) >>>
if (CPU_CYRIX) and (CPU_586)
;;	ife (SHARED_MEMORY)
	cmp	ds:byte ptr cpu_vendor,1; Cyrix ?
	jne	not_cx6x86
	; Program cyrix 6x86 earlier,
	; or video will be mess up with ATI264.
	; And CPU_CLOCK will be wrong if you call it here
	;-------------------------------;
	call	program_cx6x86_regs
not_cx6x86:
;;	endif
endif
							; <(CPU0003-) / (CPU0005)

	pop	ds
	pop	es
	ret

fill_cpu_name_display_buffer	endp


;-----------------------------------------------------------------------------;
;			    CAT PROCESSOR P-RATING			      ;
;-----------------------------------------------------------------------------;
; This procedure cats the P-Rating string after CPU name for Cyrix, AMD or    ;
; IBM.									      ;
;									      ;
;	Input	: none							      ;
;	Output	: none							      ;
;	Reg use	: does not destroy any register				      ;
;-----------------------------------------------------------------------------;
; Must be invoked by "CALL" and that time CS has to be writable.	      ;
; Must be called after checkpoint 07h and CPU Frequency is detected.	      ;
;-----------------------------------------------------------------------------;
Extrn			pr_string		:byte
Extrn			detected_cpu_vendor	:byte
Extrn			cpu_freq		:byte
Public			CatProcPRating

CatProcPRating		PROC	NEAR

ife (CPU_386)

	cld
	push	ds
	push	es
	pusha
	push	cs
	push	cs
	pop	ds
	pop	es			; DS = ES = CS
	mov	si,offset cgroup:cpu_name_display_buffer
next_c_byte:
	lodsb				; Get CPU name character
	or	al,al			; End of CPU name ?
	jnz	next_c_byte		; No..
	dec	si
	mov	di,si			; DI = ptr to buffer to cat P-Rating
	xor	dx,dx			; DL.0 = clock will be PRxxx, DL.1 = CPU will be append with xxx
					; DH = 0, no extra ASCII code

	mov	bl,detected_cpu_vendor	; Detected CPU vendor#
;	mov	ax,word ptr cpu_resetid
;	and	ah,0fh			; AH = Family#
;	shr	al,4			; AL = Model# and stepping

	xor	bh,bh
	shl	bx,1
	call	word ptr cgroup:prating_routines[bx]
if (MKF_CUSTOMER eq 1437)
	pushf
	and	cgroup:byte ptr _sysinfo_flag,not 01h	; bit0=0, don't display clock
	popf
	jc	cat_freq
	test	dl,2			; CPU string with clock ?
	jz	cat_freq		; no..
	cmp	byte ptr es:[di-1],'/'	; K6 ?
	jne	pcchip_ok		; no..
	jmp	short pcchip_mhz	; yes.. plus 'MHz'
cat_freq:
	mov	al,' '
	stosb
	mov	al,'-'
	stosb
	mov	al,' '
	stosb
pcchip_mhz:
	mov	ax,cgroup:word ptr cpu_freq; DS:SI = pointed to detected CPU frequency
	call	dec_to_str		; DS:SI = converted string from AX in decimal
	rep	movsb
	mov	al,'M'
	stosb
	mov	al,'H'
	stosb
	mov	al,'z'
	stosb
	mov	al,0
	stosb
	jmp	short no_pr
pcchip_ok:
else
	jc	short no_pr		; no.. exit
endif
;---------------------------------------;
; DL.0 = 1 Clock is PRxxx		;
; DL.1 = 1 Append Clock to CPU string	;
; DL.2 = 1 Don't display clock in AA	;
; DL.3 = 1 DS:SI = value, not table	;
; DH   = ASCII to be appended		;
;---------------------------------------;
	test	dl,08h			; get prating string from DS:SI ?
	jnz	cat_pr			; yes..
	lodsw				; Number of table entry
	mov	cx,ax

	mov	bx,cgroup:word ptr cpu_freq	; BX = detected CPU frequency
					; (CPU0002-)> Give it the lowest PRating
;	cmp	bx,word ptr[si]		; Lowest speed ?
;	jb	ret_cpr			; No P-Rating
					; <(CPU0002-)
next_pr:
	lodsw				; AX = current CPU frequency
	cmp	bx,ax			; Matched ?
	jbe	cat_pr
	add	si,sizeof (vPRATINGSTRUC).sRating
	loop	next_pr
	sub	si,sizeof (vPRATINGSTRUC).sRating; move to sFreq to get last Prating if not found in table
cat_pr:
	lodsw				; load adjusted clock
	call	dec_to_str		; DS:SI = converted string from AX in decimal

	test	dl,2			; Cat to CPU string ?
	jz	no_CPUxxx
	pusha
	rep	movsb			; Cat the P rating value
	mov	al,dh			; ASCII for appending ('+' for 6x86)
	stosb
	mov	al,0
	stosb				; Null terminate string
	popa
no_CPUxxx:

	test	dl,1			; Clock = PRxxx ?
	jz	no_clock_prxxx
	mov	di,offset cgroup:pr_string+2; dx = ptr to pr_string
	rep	movsb			; Cat the P rating value
	mov	al,dh			; ASCII for appending ('+' for 6x86)
	stosb
	mov	al,0
	stosb				; Null terminate string
no_clock_prxxx:

					; (CPU0018+)>
	test	dl,00000100b		; bit2=1 ?
	jz	ncpr_01			; no..
	extrn	_sysinfo_flag:word
	and	cgroup:byte ptr _sysinfo_flag,not 01h	; bit0=0, don't display clock
					; <(CPU0018+)
ncpr_01:
ccp_exit:
	popa
	pop	es
	pop	ds
	ret

no_pr:
	mov	cgroup:pr_string,0
	jmp	short ccp_exit

else;  ife (CPU_386)

	ret

endif;	ife (CPU_386)

CatProcPRating		ENDP
;----------------------------------------------------------------------;
; Tables for getting PR Rating string from each CPU.
;----------------------------------------------------------------------;
; Input:
;	DX	0
; Output:
;	DL	bit 0 = 1 Clock is PRxxx
;		bit 1 = 1 Append Clock to CPU string
;		bit 2 = 1 Don't display clock at checkpoint AA
;	DS:SI	offset of prating table if DL.3=0
;		bit 3 = 1 Get prating value directly from DS:SI
;	DH	ASCII charactor to be append
;		0 = nothing appended
;	CY	no prating
;----------------------------------------------------------------------;
prating_routines	label	word
	dw	offset	no_prating	; Intel
if (CPU_CYRIX)
	dw	offset	cyrix_prating	; Cyrix
else
	dw	offset	no_prating
endif
if (CPU_AMD)
	dw	offset	amd_prating	; AMD
else
	dw	offset	no_prating
endif
if (CPU_IBM)
	dw	offset	cyrix_prating	; IBM (CPU0022+)
else
	dw	offset	no_prating
endif
	dw	offset	no_prating	; TI
	dw	offset	no_prating	; UMC
	dw	offset	no_prating	; SGSTh
if (CPU_IDT)
	dw	offset	idt_prating	; Centaur
else
	dw	offset	no_prating
endif
if (CPU_RISE)
	dw	offset	rise_prating	; Rise (CPU0037)
else
	dw	offset	no_prating
endif
;----------------------------------------------------------------------;
; Output:
;----------------------------------------------------------------------;
no_prating		proc
	stc				; no pratinf string
	ret
no_prating		endp
;----------------------------------------------------------------------;

; (CPU0020+)>
;----------------------------------------------------------------------;
; Input:
;	AX	value in decimal (Maxium = 999)
; Output:
;	DS:SI	string ptr
;	CX	length
; Don't destroy DX
;----------------------------------------------------------------------;
string_buffer	db	4 dup (0)
dec_to_str	proc
	push	dx
;	push	si
	push	cs
	pop	ds			; ds = cs
	mov	si,offset string_buffer	; buffer for transfering
	xor	dx,dx			; dx = string length
	mov	bl,100
	cmp	ax,100			; >=100 ?
	jae	dts_02			; yes.. divisor start from 100
	mov	bl,10
	cmp	ax,10			; >=10 and <100, divisor start from 10
	jae	dts_02
	mov	bl,1			; one digit only
dts_02:
	inc	dx			; increase length
	div	bl
	add	al,'0'
	mov	ds:[si],al
	inc	si
dts_01:
	movzx	ax,ah			; ax(al) = remainder
	xchg	bx,ax			; bx = remainder
	xor	ah,ah			; ax = divisor
	mov	cl,10
	div	cl			; al = next divisor
	xchg	ax,bx			; bl = next divisor, al = remainder
	or	bl,bl			; divisor = 0 ?
	jnz	dts_02			; no.. continue
	mov	cx,dx			; cx = length
;	pop	si
	mov	si,offset string_buffer	; buffer for transfering
	pop	dx
	ret
dec_to_str	endp
;----------------------------------------------------------------------;
; <(CPU0020+)



		    comment ú

		    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		    º	          CPU MODULE API	   º
		    ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		    º  This routine interfaces with the    º
		    º  CPUmodule.                          º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Environment   : Stack available     º
		    º  Invoked	     : At any time	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Input	     : prm1: function num  º
		    º		       prm2: fn param far* º
		    º  Output	     : CPUmodule parametersº
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Registers Destroyed: none 	   º
		    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		    ú



Public	cpu_module_api
cpu_module_api:
CpuModuleApi			proc	far	C	prm1:word, prm2:dword
	ret
CpuModuleApi			endp


;-----------------------------------------------------------------------------;

Public	Vendor_Name_Tbl
Public	Vendor_Name_Tbl_End
Vendor_Name_Tbl 	label	byte


;	Vendor Name String(executing CPUID)	VendorHandle
;	-----------------------------------	------------

if (CPU_INTEL)
	db	'GenuineIntel',			Intel
endif

if (CPU_CYRIX)
	db	'CyrixInstead',			Cyrix
endif

if (CPU_AMD)
;	db	'AMD ISBETTER',			AMD
	db	'AuthenticAMD',			AMD
endif

if (CPU_486) and (CPU_UMC)
	db	'UMC UMC UMC ',			UMC
endif

if (CPU_IDT) and (CPU_586)
	db	'CentaurHauls',			Centaur
endif

if (CPU_Rise) and (CPU_586)			; (CPU0014+)
	db	'RiseRiseRise',			Rise
endif


Vendor_Name_Tbl_End	label	byte

		comment ú

		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					    Û
		Û   A S S O C I A T E	  R O U T I N E S   Û
		Û					    Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

		ú


;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

Public			Vendor_Check_Procs
Public			Vendor_Check_Procs_End
Vendor_Check_Procs	label	byte

if (CPU_CYRIX)
VNDRCHKSTRUC	{ offset CheckCyrix, Cyrix }
elseif (CPU_SGS)
VNDRCHKSTRUC	{ offset CheckCyrix, SGSTh }
endif
VNDRCHKSTRUC	{ offset CheckTI, TI }
VNDRCHKSTRUC	{ offset CheckIBM, IBM }

Vendor_Check_Procs_End	label	byte

if (CPU_Cyrix) or (CPU_TI) or (CPU_IBM) or (CPU_SGS)
;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;
CheckCxTI:
	mov	ecx,edx
	mov	bx,ax			; Save ResetID
	xor	ax,ax
	sahf				; Clear FLAG
	mov	al,5
	div	al			; For Cyrix, should not change FLAG
	lahf
	cmp	ah,2			; Bit 1 is always set in FLAG
	mov	ax,bx			; Restore AX
	jnz	ret_cc			; Not a Cyrix CPU
ret_cc:
	mov	edx,ecx
	ret

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

ReadDIR:
	pushf
	cli
	mov	al,0ffh			; DIR1 register index
	call	read_ccrreg		; AL = DIR1 value
	mov	ah,al
	mov	al,0feh			; DIR0 register index
	call	read_ccrreg		; AL = DIR0 value
	popf
	ret
;---------------------------------------;
read_ccrreg:
	out	22h,al			; Write index
	jcxz	$+2
	jcxz	$+2
	in	al,23h			; AL = reg value
	ret

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

Public			CheckCyrix
CheckCyrix:

;  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;  ³ This routine checks whether the CPU is Cyrix	 ³
;  ³ or not.						 ³
;  ³ Input   : DX = ResetID (from MinCPUInfo)		 ³
;  ³ Output  : ZF = 0 (JNZ) : Not a Cyrix CPU		 ³
;  ³	       ZF = 1 (JZ)  : Cyrix CPU 		 ³
;  ³ stack available					 ³
;  ³ Reg destroyed : BX, DO NOT DESTROY EAX, EDX, SI	 ³
;  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	call	CheckCxTI		; ZF = 1 (JZ): Cyrix or TI CPU
	jnz	ret_chkcx		; No.. this is not a Cyrix CPU
	call	ReadDIR			; AL = DIR0, AH = DIR1
	cmp	ax,0ffffh		; DIR not supported ?
	jz	ret_chkcx		; Yes.. must be cyrix
	test	ah,10000000b		; Set ZF according to TI bit
ret_chkcx:
	ret

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

else;  if (CPU_Cyrix) or (CPU_TI) or (CPU_IBM) or (CPU_SGS)

Public			CheckCyrix
CheckCyrix:
	or	sp,sp
	ret

endif;	if (CPU_Cyrix) or (CPU_TI) or (CPU_IBM) or (CPU_SGS)


Public			CheckTI
CheckTI:

;----------
if (CPU_TI)
;----------

;  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;  ³ This routine checks whether the CPU is TI or not.	 ³
;  ³							 ³
;  ³ Input   : DX = ResetID (from MinCPUInfo)		 ³
;  ³ Output  : ZF = 0 (JNZ) : Not a TI CPU		 ³
;  ³	       ZF = 1 (JZ)  : TI CPU			 ³
;  ³ stack available, DO NOT DESTROY EAX, EDX, SI	 ³
;  ³ Register destroyed : EBX, ECX		 	 ³
;  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	call	CheckCxTI		; Check for Cyrix/TI CPU
	jnz	ret_chkti		; No.. it is not a Cyrix or TI CPU
;  ChipA, removed for space reasons, 386 & 486 support not needed
if (CPU_486)
	cmp	dh,04h
	jnz	chk_ti			; Not 486 class CPU, check future CPU
	cmp	dl,80h			; 386 Upgrades (SLC/DLC processors) ?
	jc	chk_old_ti		; Yes..
chk_ti:
endif; (CPU_486)
	call	ReadDIR			; AL = DIR0, AH = DIR1
	cmp	ax,0ffffh		; DIR not supported ?
	jz	ret_chkti1
	and	ah,10000000b
	xor	ah,10000000b		; Set ZF according to TI bit
ret_chkti:
	ret
ret_chkti1:
	or	ax,ax			; ZF = 0, not a TI CPU
	ret

;  ChipA, removed for space reasons, 386 & 486 support not needed
if (CPU_486)
chk_old_ti:
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³ CPU found as Cyrix. Now check for TI. For TI Potomac ³
;³ TR4 bit 9 is not used as it has 16K cache instead of ³
;³ 1K in Cyrix. AX = already set VendorHandle as Cyrix. ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	mov	ecx,eax 		; Save AX
	MovTR4toEBX			; Get current value of TR4
	mov	eax,00000200h
	MovEAXtoTR4			; Set bit9 of TR4 (used TAG address)
	mov	ax,0001h
	MovEAXtoTR5			; Cache write
	mov	al,2
	MovEAXtoTR5			; Cache read
	MovTR4toEAX			; Get current TR4 value
	test	ah,00000010b		; Bit 9 still set ?
	mov	eax,ebx
	MovEBXtoTR4			; Restore TR4
	mov	eax,ecx 		; Restore AX
	ret
endif; (CPU_486)

;---
else
;---
	or	sp,sp			; ZF = 0, not TI CPU
	ret

;---------------
endif;	(CPU_TI)
;---------------

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


Public			CheckIBM
CheckIBM:

;  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;  ³ This routine checks whether the CPU is IBM		 ³
;  ³ or not.						 ³
;  ³ Input   : DX = ResetID				 ³
;  ³ Output  : ZF = 0 (JNZ) : Not a IBM CPU		 ³
;  ³	       ZF = 1 (JZ)  : IBM CPU 			 ³
;  ³ Does not use any stack				 ³
;  ³ Register destroyed : BL, DO NOT DESTROY EAX, EDX, SI³
;  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	mov	bl,dh
	and	bl,80h			; Keep IBM identifying bit
	xor	bl,80h			; Set ZF accordingly
	ret

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


; NOTES: This routine will be changed according to your chipset porting
;	 This routine is needed only for AMD-K6 and IDT CPUs.
; Input:
;	ECX,EDX memory region1 32-bit start address, size in bytes
;	EDI	bit-0 = Memory region1 information
;			0..memory region1 is a HOLE region
;			1..memory region1 is a non-cacheable region
;		bit-1 = Memory region2 information
;			0..memory region2 is a HOLE region
;			1..memory region2 is a non-cacheable region
;		bit-2 = Reserved
;		bit-3 = 0 -> rest of memory L1 write-through
;			1 -> rest of memory L1 write-back
;		bit-31..4 = Reserved
; Output:
;	NC = no 15-16MB hole
;	CY = 15-16MB hole enabled
; Do not destroy any register
;-----------------------------------------------------------------------;
	public	zero_equ
zero_equ	equ	0
	extrn	get_cmos_item:near
if_hole_15_16m:
	push	ax
	extern	Q_MEMORY_HOLE(zero_equ):abs
	mov	al,Q_MEMORY_HOLE
	or	al,al			; no equate exist ?
	jz	not_implemented		; yes.. not implemented
	call	get_cmos_item
	cmp	al,2			; 15-16M ?
	stc
	jz	ih11m_exit
not_implemented:
	clc
ih11m_exit:
	pop	ax
	ret
;-----------------------------------------------------------------------;



;*****************************************************************************;


;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


DummyFindFamilyMember		PROC	NEAR

	xor	ax,ax			; First element in Dummy data base
	ret

DummyFindFamilyMember		ENDP

;-----------------------------------------------------------------------------;

Dummy_Family_Data_Base:


;			       ÚÄÄÄÄÄÄÄÄ¿
;			       ³ Header ³
;			       ÀÄÄÄÄÄÄÄÄÙ

dw	offset Dummy_Members_End
db	CPU$Set
db	UnknownCPU_$

db	0ffh,	0ffh,	NoSMI+Bus32+Clk1X+CachePgm1,	FPU+NoInit,	Unknown_$,	0ffh

Dummy_Members_End:
db	0ffh,	0ffh,	NoSMI+Bus32+Clk1X+CachePgm1,	FPU+NoInit,	Unknown_$,	0ffh

;-----------------------------------------------------------------------------;

DummyCPUHandle@Reset		PROC	NEAR

	ret				; Do not do anything

DummyCPUHandle@Reset		ENDP

;-----------------------------------------------------------------------------;

DummyInitCPU@Reset		PROC	NEAR

	ret				; Do not do anything

DummyInitCPU@Reset		ENDP

;-----------------------------------------------------------------------------;

DummyInitCPUBeforeBOOT		PROC	NEAR

	ret				; Do not do anything

DummyInitCPUBeforeBOOT		ENDP


;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


	Public	Vendor_Post_Data_Base
	Public	Vendor_Post_Data_Base_End

Vendor_Post_Data_Base:

if (CPU_INTEL)
VNDRPSTSTRUC	{\
		offset	FindIntelFamilyMember,
		offset	Intel_Family_Data_Base,
		offset	GetIntelCPUHandle@Reset,
		offset	InitIntelCPU@Reset,
		offset	InitIntelCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif

if (CPU_CYRIX)
VNDRPSTSTRUC	{\
		offset	FindCyrixFamilyMember,
		offset	Cyrix_Family_Data_Base,
		offset	GetCyrixCPUHandle@Reset,
		offset	InitCyrixCPU@Reset,
		offset	InitCyrixCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif

if (CPU_AMD)
VNDRPSTSTRUC	{\
		offset	FindAMDFamilyMember,
		offset	AMD_Family_Data_Base,
		offset	GetAMDCPUHandle@Reset,
		offset	InitAMDCPU@Reset,
		offset	InitAMDCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif

if (CPU_IBM)
VNDRPSTSTRUC	{\
		offset	FindIBMFamilyMember,
		offset	IBM_Family_Data_Base,
		offset	GetIBMCPUHandle@Reset,
		offset	InitIBMCPU@Reset,
		offset	InitIBMCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif

if (CPU_TI)
VNDRPSTSTRUC	{\
		offset	FindTIFamilyMember,
		offset	TI_Family_Data_Base,
		offset	GetTICPUHandle@Reset,
		offset	InitTICPU@Reset,
		offset	InitTICPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif

if (CPU_UMC) and (CPU_486)
VNDRPSTSTRUC	{\
		offset	FindUMCFamilyMember,
		offset	UMC_Family_Data_Base,
		offset	GetUMCCPUHandle@Reset,
		offset	InitUMCCPU@Reset,
		offset	InitUMCCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif

if (CPU_SGS) and (CPU_486)
VNDRPSTSTRUC	{\
		offset	FindSGSThFamilyMember,
		offset	SGSTh_Family_Data_Base,
		offset	GetSGSThCPUHandle@Reset,
		offset	InitSGSThCPU@Reset,
		offset	InitSGSThCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif

if CPU_IDT
VNDRPSTSTRUC	{\
		offset	FindIDTFamilyMember,
		offset	IDT_Family_Data_Base,
		offset	GetIDTCPUHandle@Reset,
		offset	InitIDTCPU@Reset,
		offset	InitIDTCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif;	if CPU_IDT

						; (CPU0014+)>
if CPU_Rise
VNDRPSTSTRUC	{\
		offset	FindRiseFamilyMember,
		offset	Rise_Family_Data_Base,
		offset	GetRiseCPUHandle@Reset,
		offset	InitRiseCPU@Reset,
		offset	InitRiseCPUBeforeBOOT\
		}
else
VNDRPSTSTRUC	{\
		offset	DummyFindFamilyMember,
		offset	Dummy_Family_Data_Base,
		offset	DummyCPUHandle@Reset,
		offset	DummyInitCPU@Reset,
		offset	DummyInitCPUBeforeBOOT\
		}
endif;	if CPU_Rise
						; <(CPU0014+)

Vendor_Post_Data_Base_End:

;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;
if (CPU_INTEL)
	include	pintel.inc		; POST Intel routines/macros
endif
if (CPU_CYRIX) or (CPU_TI) or (CPU_IBM) or (CPU_SGS)
	include	pcyrix.inc		; POST Cyrix routines/macros
endif
if (CPU_AMD)
	include	pamd.inc		; POST AMD routines/macros
endif
if (CPU_IBM)
	include	pibm.inc		; POST IBM routines/macros
endif
if (CPU_TI)
	include	pti.inc			; POST TI routines/macros
endif
if (CPU_UMC)
	include	pumc.inc		; POST UMC routines/macros
endif
if (CPU_SGS)
	include	psgs.inc		; POST SGS routines/macros
endif
if (CPU_IDT)
	include	pidt.inc		; POST IDT routines/macros
endif
if (CPU_RISE)
	include	prise.inc		; POST RiSE routines/macros
endif
;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;

	Public	AbsVendor
		AbsVendor		db	CPU$Set, Unknown_$

	Public	AbsVendorNo
		AbsVendorNo		db	0FFh

	Public	AbsCPU
		AbsCPU		db		CPU$Set, Unknown_$

	Public	AbsCPUID
		AbsCPUID		dw	0000h

	Public	AbsCPUNo
		AbsCPUNo		db	0FFh

	Public	AbsOverwriteByte
		AbsOverwriteByte	db	000h

;-----------------------------------------------------------------------------;

Public	CPU_$_Start
CPU_$_Start:

	cpu_counter	= 0

;-----------
if (FP_PROC)
;-----------

	Create_CPU$	i387_$
if (CPU_INTEL)
				db	'387'
endif
				db	0

	Create_CPU$	i487_$
if (CPU_INTEL)
				db	'487SX'
endif
				db	0

	Create_CPU$	Cx87SLC_$
if (CPU_CYRIX)
				db	'87SLC'
endif
				db	0

	Create_CPU$	Cx87DLC_$
if (CPU_CYRIX)
				db	'87DLC'
endif
				db	0

	Create_CPU$	Cx487S_$
if (CPU_CYRIX)
				db	'487S'
endif
				db	0

	Create_CPU$	Cx487SX_$
if (CPU_CYRIX)
				db	'487SX'
endif
				db	0
endif


	Create_CPU$	Unknown_$
				db	'(Unknown)',0

	Create_CPU$	Null_$
				db	0

	Create_CPU$	BuiltIn_$
				db	'Built-In',0

	Create_CPU$	UnknownCPU_$
				db	'XX',0

if (CPU_INTEL)
	Create_Intel_CPU_names
endif

if (CPU_CYRIX)
	Create_Cyrix_CPU_names
endif

if (CPU_AMD)
	Create_AMD_CPU_names
endif

if (CPU_IBM)
	Create_IBM_CPU_names
endif

if (CPU_TI)
	Create_TI_CPU_names
endif

if (CPU_UMC)
	Create_UMC_CPU_names
endif

if (CPU_SGS)
	Create_SGS_CPU_names
endif

if (CPU_IDT)
	Create_IDT_CPU_names
endif

if (CPU_RISE)
	Create_RISE_CPU_names
endif

;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;

	_text	ends
	END

