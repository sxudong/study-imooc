	page	,132
	title	SETUP HOOKS
;---------------------------------------------------------------;
; NOTE:	Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.
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
;---------------------------------------;
;  THIS EXTERNAL DEFINITIONS MUST BE OUTSIDE THE CGROUP DEFINITION..
	extrn	_old_cmos_buffer:byte
	extrn	_common_cmos_buffer:byte
;---------------------------------------;
	include	mbiosmac.mac
	include	mbiosequ.equ
	include	cf.equ
	include	setupequ.ext
	include	makeflag.equ
;---------------------------------------;
	extrn	check_bcp_setup:near
	extrn	get_cmos_buffer_item:near
	extrn	set_cmos_buffer_item:near
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_SETUP_STARTS
_SETUP_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;		INIT_BUFFER_BEFORE_SETUP	; Moved from NSETUP.ASM
;-----------------------------------------------------------------------;
; If you want to update the _common_cmos_buffer before setup screen	;
; is displayed (e.g. you want to change default value of some option),	;
; this routine can be used. this routine is called from	CMOS_SETUP.	;
; CMOS_SETUP is called at check_point	: 87				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
; NOTE: difference between INIT_BUFFER_BEFORE_SETUP and BEFORE_SETUP	;
;	is in input values of DS, ES					;
;-----------------------------------------------------------------------;
	extrn	get_processor_info:near
	extrn	oem_init_buffer_before_setup:near
	public	init_buffer_before_setup
init_buffer_before_setup:
;---------------------------------------;
;  Do any generic stuff here
	call	check_bcp_setup		; BCP/Setup ?
	jz	short ibbs_02		; BCP, so leave the selection as it is
;  setup being executed
	call	get_processor_info	; eax.1,0 are defined as :
					; 00 = CPU does not support int. cache.
					; 01 = w-thru int. cache only.
					; 10 = w-back int. cache only.
					; 11 = w-thru and w-back int. cache.
	and	al,03h			; bits 1,0 only are revelant.
	mov	ah,al
	mov	al,Q_INTERNAL_CACHE
	jz	short ibbs_01		; int cache not supported
	push	ax
	call	get_cmos_buffer_item	; AL = right justified value
	pop	ax
	jz	short ibbs_00		; int cache disabled
;  internal cache is enabled and CPU supports internal cache..
	cmp	ah,03h			; CPU support both wt/wb ?
	jz	short ibbs_00		; yes, so leave the selection as it is
ibbs_01:
	call	set_cmos_buffer_item
ibbs_00:
;IF	MKF_CPU_OVERRIDE
;ELSE
;	mov	al,Q_CPU_OVERRIDE
;	mov	ah,0fh			; force CPU selection to AUTO
;	call	set_cmos_buffer_item
;ENDIF

ibbs_02:
;  Do OEM specific stuff if any
	call    oem_init_buffer_before_setup    ; in OEMSETUP.ASM
	ret

;-----------------------------------------------------------------------;
;			ADJUST_EXTENDED_MEMORY_SETUP			;
;-----------------------------------------------------------------------;
; If extended memory size need to be adjusted due to memory remap,	;
; relocation/shadow conflict check, or any other change necessary	;
; after CMOS SETUP, use this routine.					;
; this routine is called from normal and hot key setup before CMOS	;
; registers are actually written when "WRITE CMOS REGISTER and EXIT"	;
; is chosen.								;
; input :								;
;	ds			segment of _old_cmos_buffer &		;
;					   _common_cmos_buffer		;
;	_old_cmos_buffer	previous setting of options		;
;	_common_cmos_buffer	updated setting of options thru' CMOS SETUP
;	stack			available				;
; output: (ZF) = 1 -> proceed, (ZF) = 0 -> exit to reboot		;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: while updating extended memory size, locn in _common_cmos_buffer;
;	for cmos registers 17h,18h, 30h,31h,35h,36h must be updated	;
;	properly.							;
;-----------------------------------------------------------------------;
	extrn	oem_adjust_extended_memory_setup:near
	public	adjust_extended_memory_setup
adjust_extended_memory_setup:
; Do OEM specific stuff if any
	call	oem_adjust_extended_memory_setup; in OEMSETUP.ASM
	or	sp,sp			; (ZF) = 0, reboot
	ret
;-----------------------------------------------------------------------;
;			HOT_KEY_ADJUST_SETUP				;
;-----------------------------------------------------------------------;
; this routine is called after running HOT-KEY CMOS SETUP.		;
; This routine can be used to do any programming after hot-key cmos setup
; is executed, cmos is written with updated values and system does not	;
; need to be rebooted.							;
; input :								;
;	ds			segment of _old_cmos_buffer &		;
;					   _common_cmos_buffer		;
;	stack	available						;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: 1. this routine will need to reprogram parameters like wait	;
;	states, power management timers, etc. which are usually		;
;	programmed in PROGRAM_PARAMETER_AFTER_SETUP hook. it is advised	;
;	to write a common subroutine used by both these hooks to	;
;	minimize code size.						;
;-----------------------------------------------------------------------;
	extrn	oem_hot_key_adjust_setup:near
	public	hot_key_adjust_setup
hot_key_adjust_setup:
; Do chipset specific stuff here


; Do chipset specific stuff if any
	call	oem_hot_key_adjust_setup	; in OEMSETUP.ASM
	ret

;; for keyboard power up
	extrn	cmos_data_out_x:near
	extrn	open_extend_cmos:near
	extrn	close_extend_cmos:near
	extrn	ascii_to_scan:near
	public	write_key_password_to_cmos 
write_key_password_to_cmos:				
	pusha

	call	open_extend_cmos
	mov	si,bx
	mov	ah,7ch
	xor	cl,cl
@@:
	lodsb	     				; al = scan code
	or	al,al
	jz	save_in_cmos_over

	mov	bl,ah
	call	ascii_to_scan
	mov	ah,bl

	xchg	ah,al				;  save in cmos
	call	cmos_data_out_x			;
	inc	cx
	xchg	ah,al				;
	dec	ah				;
	jmp	short @b

save_in_cmos_over:
	xchg	ah,al				;  save in cmos
	call	cmos_data_out_x			;

	cmp	cl,0
	jnz	@f				; check if there is a non-empty string
	mov	cl,0ffh
@@:
	mov	al,7dh
	mov	ah,cl
	call	cmos_data_out_x			;

	call	close_extend_cmos

	popa
	ret
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
	public	_SETUP_ENDS
_SETUP_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end
