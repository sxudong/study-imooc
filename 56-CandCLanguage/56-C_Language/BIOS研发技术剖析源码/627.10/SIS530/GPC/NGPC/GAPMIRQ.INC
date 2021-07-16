subttl.	Include file for IRQ based real/16 bit protected/32 bit protected mode APM code...GAPMIRQ.INC

;-----------------------------------------------;	
;   FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

;;	public	irq_apm_real_mode_entry		;
;;	public	irq_apm_16bit_prot_mode_entry	;
;;	public	irq_apm_32bit_prot_mode_entry	;

;-----------------------------------------------;
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
;---------------------------------------------------------------;
; THIS PORTION OF CODE SUPPORTS IRQ BASED APM POWER MANAGEMENT	;
;---------------------------------------------------------------;

IF	IRQ_HANDLING_SUPPORT

irq_apm_handler	label	byte

;---------------------------------------------------------------;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;---------------------------------------------------------------;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;---------------------------------------------------------------;
;		     IRQ_APM_REAL_MODE_ENTRY			;
;---------------------------------------------------------------;

irq_apm_real_mode_entry	proc	near

	add	sp,02h				; bypass caller

	pushfd					; save EFLAGS
	push	ebp				;

	mov	bp,00000001b			; set for called in real mode
	call	irq_apm_real_16_32_common	;

	pop	ebp				;
	jc	short irq_apm_real_mode_entry_00; error...

	popfd					; restore (EFLAGS)
	clc					; (cy) = 00 for no error
	retf	2

irq_apm_real_mode_entry_00:
	popfd					; restore (EFLAGS)
	stc					; (cy) = 01 for error
	retf	2

irq_apm_real_mode_entry	endp

;---------------------------------------------------------------;
;		  IRQ_APM_16BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

irq_apm_16bit_prot_mode_entry	proc	near

	pushfd					; save EFLAGS
	push	ebp				;

	mov	bp,00000010b			; set for called in 16 bit protected mode
	call	irq_apm_real_16_32_common	;

	pop	ebp				;
	jc	short irq_apm_16_prot_mode_entry_00; error...

	popfd					; restore (EFLAGS)
	clc					; (cy) = 00 for no error
	retf

irq_apm_16_prot_mode_entry_00:
	popfd					; restore (EFLAGS)
	stc					; (cy) = 01 for error
	retf

irq_apm_16bit_prot_mode_entry	endp

;---------------------------------------------------------------;
;		  IRQ_APM_32BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

irq_apm_32bit_prot_mode_entry	proc	near

;-----------------------------------------------;
; 32 BIT PROTECTED MODE CODE...ASSEMBLED WITH USE16

;;	pushfd					;
	db	09ch				;
;;	push	ebp				;
	db	055h				;

;;	mov	ebp,cs				; (ebp) = 32 bit protected mode CODE segment selector
	db	08ch,0cdh			;
;;	add	ebp,8				; (ebp) = 16 bit protected mode CODE segment selector
	db	083h,0c5h,008h			;

;;	push	ebp				; push 16 bit segment selector
	db	055h				;
	push	(offset cgroup:irq_apm_32_prot_mode_entry_01 - offset cgroup:smi_code_begin + orgbase); offset
	dw	00000h				;

;;	mov	bp,00000100b			; set for called in 32 bit protected mode
	db	066h,0bdh,004h,000h		;

	retf					; start executing in 16 bit protected mode code

;-----------------------------------------------;
; 16 BIT PROTECTED MODE CODE...ASSEMBLED WITH USE16

irq_apm_32_prot_mode_entry_01:
	call	irq_apm_real_16_32_common	;

	pushfd					;
	mov	bp,cs				; (bp) = 16 bit protected mode CODE segment selector
	sub	bp,8				; (bp) = 32 bit protected mode CODE segment selector
	popfd					;

	push	bp				; push 32 bit segment selector
	push	(offset cgroup:irq_apm_32_prot_mode_entry_02 - offset cgroup:smi_code_begin + orgbase); offset
	retf					; start executing in 32 bit protected mode

;-----------------------------------------------;
; 32 BIT PROTECTED MODE CODE...ASSEMBLED WITH USE16

irq_apm_32_prot_mode_entry_02:
;;	pop	ebp				;
	db	05dh				;
	jc	short irq_apm_32_prot_mode_entry_00; error...

;;	popfd					; restore (EFLAGS)
	db	09dh				;
	clc					; (cy) = 00 for no error
	retf

irq_apm_32_prot_mode_entry_00:
;;	popfd					; restore (EFLAGS)
	db	09dh				;
	stc					; (cy) = 01 for error
	retf

irq_apm_32bit_prot_mode_entry	endp

;---------------------------------------------------------------;
;		IRQ_APM_REAL_16BIT_32BIT_COMMON			;
;---------------------------------------------------------------;
;	Input :	(BP) bit 0 1 called in real mode		;
;		     bit 1 1 called in 16 bit protected mode	;
;		     bit 2 1 called in 32 bit protected mode	;
;		(AL) APM function no.				;
;			Registers as defined by the APM document;
;			for related function.			;
;	Output: (CY) 01 for error & (AH) has error code		;
;		(CY) 00 for no error				;
;			Registers as defined by the APM document;
;			for related func.			;
;	Register destroyed : As defined by the related function	;
;---------------------------------------------------------------;

irq_apm_real_16_32_common	proc	near

	cli					; disable interrupts
	cld					; clear direction flag

	push	ds				;
	push	es				;

	push	eax				;
	push	edx				;
	mov	ax,cs				;
	test	bp,0000000000000001b		; real mode APM call ?
	jnz	short irq_apm_real_16_32_common_01; yes...
	add	ax,8				; selector for (ds)
irq_apm_real_16_32_common_01:
	mov	ds,ax				; set (ds)
	mov	es,ax				; set (es)

	call	write_enable_irq_shadow		; CHIPSET HOOK HOOK HOOK...write enable shadow ram area used for IRQ based power management implementation
						; shadow area is alreay readable
						; DO NOT CHANGE SHADOW READ STATUS

	mov	byte ptr ds:irq_apm_in_progress,0ffh; indicate IRQ based APM functions currently being executed

	call	irq_apm_save_and_mask_intr	; save and mask all interrupts

	pop	edx				;
	pop	eax				;

;-----------------------------------------------;

	call	apm_call_near			; execute APM call

	cli					; disable interrupts

	pushf					;
	push	eax				;
	push	edx				;

	call	irq_apm_restore_and_unmask_intr	; restore and unmask all interrupts
	mov	byte ptr ds:irq_apm_in_progress,000h; indicate IRQ based APM functions currently is not being executed

	call	check_and_write_protect_irq_shadow; write protect shadow ram area used for IRQ based power management implementation
						; shadow area is alreay readable
						; DO NOT CHANGE SHADOW READ STATUS

	pop	edx				;
	pop	eax				;
	popf					;

	pop	es				;
	pop	ds				;
	ret
	
irq_apm_real_16_32_common	endp

;---------------------------------------------------------------;

irq_apm_handler_ends	label	byte

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
;---------------------------------------------------------------;

ELSE

irq_apm_handler_dummy	label	byte

;---------------------------------------------------------------;
;		DUMMY SUPPORT FOR IRQ APM HANDLING		;
;---------------------------------------------------------------;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;	     RUN TIME CORE BIOS IRQ APM HANDLER CODE		;
;---------------------------------------------------------------;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;	     THIS MODULE WILL RESIDE IN IRQ SHADOW		;
;---------------------------------------------------------------;
;		     IRQ_APM_REAL_MODE_ENTRY			;
;---------------------------------------------------------------;

irq_apm_real_mode_entry	proc	near

;;	mov	ah,unsupported_func		; function not supported
;;	add	sp,02h				; bypass caller
;;	stc					; (cy) = 01 for error
;;	retf	2

	ret

irq_apm_real_mode_entry	endp

;---------------------------------------------------------------;
;		  IRQ_APM_16BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

irq_apm_16bit_prot_mode_entry	proc	near

;;	mov	ah,unsupported_func		; function not supported
;;	stc					; (cy) = 01 for error
;;	retf

	retf

irq_apm_16bit_prot_mode_entry	endp

;---------------------------------------------------------------;
;		  IRQ_APM_32BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

irq_apm_32bit_prot_mode_entry	proc	near

;;	mov	ah,unsupported_func		; function not supported
;;	stc					; (cy) = 01 for error
;;	retf

	retf

irq_apm_32bit_prot_mode_entry	endp

;---------------------------------------------------------------;

irq_apm_handler_dummy_ends	label	byte

ENDIF

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
;---------------------------------------------------------------;

