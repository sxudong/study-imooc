	page	,132
	title	DEBUGGING MODULE
	.286p
;---------------------------------------------------------------;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
; this file contain all code which is NOT required after bootup	;
;---------------------------------------------------------------;
; NOTE:	in the routines below, make it a general rule NOT to destroy DS, ES, BP
;	unless otherwise specified.
;---------------------------------------------------------------;
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
;****************************************************************************;
;---------------------------------------;
;  THIS EXTERNAL DEFINITIONS MUST BE OUTSIDE THE CGROUP DEFINITION..
extrn	_old_cmos_buffer:byte
extrn	_common_cmos_buffer:byte	; common buffer for setup
extrn	_temp_buffer:byte
;---------------------------------------;
cgroup	group	_text
_text	segment	byte	public	'CODE'
	assume	cs:cgroup
;---------------------------------------;
	public	_DBUG_STARTS
_DBUG_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;			DEBUGGER_HOOK1					;
;-----------------------------------------------------------------------;
; called at check_point		: 2A					;
; This routine is suppoesed to prepare for debugging. this routine is	;
; invoked thru' a JMP instruction.					;
; input :								;
;	SS	0030H							;
;	DS	0040H							;
;	ES	0000H							;
;	stack	available						;
; output :								;
;	none								;
; register usage -- can destroy any register except BP, DS, ES		;
; NOTE:	1. this routine prepares the system for debugging.		;
;	   a. make any BIOS code region (E000 and/or F000) shadow R/W.	;
;	   b. copy any BIOS (which has not been shadowed yet) to shadow.;
;-----------------------------------------------------------------------;
	public	debugger_hook1
	extrn	debugger_hook1_end:near
debugger_hook1:

ifndef INC_DEBUG

debug_start:
	jmp	debugger_hook1_end

else	;INC_DEBUG

;------------------------------------------------------------------------------
;  FOLLOWING IS A SAMPLE OF DEBUGGING CODE
;  This is start of TDREM debugging code
;  this code assumes the DIM code is present at ROM at address E700:0000.
;			 DEBUGGER code is at ROM at address EA00:0000.
;  so this DIM code has to be copied to E400:0 shadow ram.
	public	debugger_hook1
	extrn	debugger_hook1_end:near
	extrn	read_chip_reg:near
	extrn	write_chip_reg:near

	DIM_INT		equ 60h

	pushf
	pusha
	push	es
	push	ds
	mov	dx, 180h		; whether to debug (read a switch) ?
	in	al, dx
	test	al, 1			; debug ?
	jnz	debug_skip		; no

; Patch to disable SMC665 serial port so TDREM will work
	cli
	mov	al, 55h
	mov	dx, 3f0h
	out	dx, al
	jcxz	$+2
	jcxz	$+2
	out	dx, al
	jcxz	$+2
	jcxz	$+2
	mov	al, 2
	out	dx, al
	jcxz	$+2
	jcxz	$+2
	inc	dx
	in	al, dx
	and	al, 088h
	dec	dx
	mov	ah, al
	mov	al, 2
	out	dx, al
	jcxz	$+2
	jcxz	$+2
	inc	dx
	mov	al, ah
	out	dx, al

; Make E8000-EBFFF region R/W for TDREM
; --------------------------------------------------------------

	********* Chipset code needed here *********

; --------------------------------------------------------------

; save current ES, DS
	xor	ax, ax
	mov	es, ax
	mov	ax, ss			;Save SS, SP in DIM_INT vector
	mov	word ptr es:[(DIM_INT * 4) + 2], ax
	mov	word ptr es:[(DIM_INT * 4) + 0], sp

; Call TDREM at E400:0 (it will move itself to 9E00:0)
; TDREM can be moved anywhere in the ROM.  If this is done the TDREM address
; needes to be changed in the following call far as well as in the makefile.
	db	09Ah			;call far E400:0
	dw	0000h, 0E400h

debug_start:
	cli
	xor	ax, ax			;Restore SS, SP from DIM_INT vector
	mov	es, ax
	mov	ax, word ptr es:[(DIM_INT * 4) + 2]
	mov	sp, word ptr es:[(DIM_INT * 4) + 0]
	mov	ss, ax
debug_skip:
	pop	ds
	pop	es
	popa
	popf
	jmp	debugger_hook1_end

;  This is end of TDREM debugging code
endif	;INC_DEBUG


;-----------------------------------------------------------------------;
;			DEBUGGER_HOOK2					;
;-----------------------------------------------------------------------;
; This routine is called during memory test after each 64k memory block.;
; this routine is invoked in PROTECTED MODE.				;
; input :								;
;	selector ES	concerned segment to be tested			;
;	DS:SI		ptr to a byte containg A19-A12 of segment	;
;			concerned					;
;	DS:SI+3		ptr to a byte containg A27-A20 of segment	;
;			concerned					; 
;	stack	available						;
; output :								;
;	zr	protects from testing (do not test)			;
;	nz	do testing						;
; register usage -- can destroy any register except BP, DS, ES		;
; NOTE:	1. this routine prepares the system for debugging.		;
;	2. this routine protects the memory segment (where debugger code;
;	is) from testing i.e. from being destroyed.			;
;	3. this code assumes the debugger code will be at 9000h segment	;
;	(to be specific at 9000:E000 to 9000:FFFF, whole segment must be;
;	protected because memory test is done with 64k granularity).	;
;-----------------------------------------------------------------------;
	public	debugger_hook2
debugger_hook2:
ifndef INC_DEBUG

	ret

else	;INC_DEBUG

	cmp	byte ptr [si],09h 	; skip 9000h segment
	jnz	dh2_0
	cmp	byte ptr [si+3],0
	jnz	dh2_0
	pushf
	push	ds
	push	es
	pop	ds
	push	si
	xor	si,si
	xor	di,di
	mov	cx,8000h
	rep	movsw			; init the segment with same code
	pop	si
	pop	ds
	popf
dh2_0:
	ret

endif	;INC_DEBUG

;-----------------------------------------------------------------------;
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
;-----------------------------------------------------------------------;
	public	_DBUG_ENDS
_DBUG_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end	debug_start
