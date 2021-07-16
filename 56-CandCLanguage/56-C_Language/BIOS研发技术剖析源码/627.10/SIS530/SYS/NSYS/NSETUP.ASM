	page	,132
	title	SETUP HOOKS (NO PORTING NEEDED IN GENERAL)
;---------------------------------------------------------------;
; NOTE:	Do not destroy EBP,SS,DS,ES,FS,GS unless otherwise specified.
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
	extrn	cmos_table:word
	extrn	cmos_table_end:word
	extrn	advanced_table:word
	extrn	advanced_table_end:word
	extrn	chipset_table:word
	extrn	chipset_table_end:word
	extrn	pwr_mgmt_table:word
	extrn	pwr_mgmt_table_end:word
	extrn	pci_table:word
	extrn	pci_table_end:word
	extrn	num_advanced_cmos_regs:word
	extrn	num_chipset_regs:word
	extrn	num_pwr_mgmt_regs:word
	extrn	num_pci_regs:word
	extrn	total_cmos_regs:word
	extrn	last_cmos_reg:word
;---------------------------------------;
	include	mbiosmac.mac
	include	mbiosequ.equ
	include	cf.equ
	include	setupequ.ext
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;-----------------------------------------------------------------------;
;			ADJUST EXTENDED MEMORY				;
;-----------------------------------------------------------------------;
; If extended memory size need to be adjusted due to memory remap,	;
; relocation/shadow conflict check, or any other change necessary	;
; after CMOS SETUP, use this routine.					;
; this routine is called from CMOS_SETUP before CMOS registers are actually
; written when "WRITE CMOS REGISTER and EXIT" is chosen.		;
; input :								;
;	ds			segment of _old_cmos_buffer &		;
;					   _common_cmos_buffer		;
;	_old_cmos_buffer	previous setting of options		;
;	_common_cmos_buffer	updated setting of options thru' CMOS SETUP
;	stack			available				;
; output: (ZF) = 1 -> proceed, (ZF) = 0 -> exit to reboot		;
; register usage -- can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: while updating extended memory size, locn in _common_cmos_buffer;
;	for cmos registers 17h,18h, 30h,31h,35h,36h must be updated	;
;	properly.							;
;-----------------------------------------------------------------------;
	public	adjust_extended_memory
	extrn	cmos_data_in_x:near
	extrn	cmos_data_out_x:near
	extrn	open_extend_cmos:near
	extrn	close_extend_cmos:near
	extrn	open_apc_cmos:near
	extrn	close_apc_cmos:near
	extrn	get_std_reboot_status:near
	extrn	adjust_extended_memory_setup:near
adjust_extended_memory:
	call	open_extend_cmos
	sub	dx,dx
	sub	cx,cx
write_password_cmos:
	mov	al,98h
	add	al,cl
	call	cmos_data_in_x
	add	dl,al
	adc	dh,0
	mov	ah,al
	mov	al,90h
	add	al,cl
	call	cmos_data_out_x
	or	ah,ah
	jz	@f
	inc	cx
	cmp	cl,6
	jnz	write_password_cmos
@@:
	mov	ah,dl
	mov	al,08eh
	call	cmos_data_out_x
	mov	ah,dh
	mov	al,08fh
	call	cmos_data_out_x

	call	close_extend_cmos

;; Check Keyboard Password Enable?
	call	open_apc_cmos

	mov	ax,08383h			; APC Register 03h
	call	cmos_data_in_x
	or	al, 80h				; Enable Power Button 
	or	cx,cx
	jz	enable_power_button
	and	al, not 80h			; Disable Power Button
enable_power_button:
	xchg	al,ah
	call	cmos_data_out_x

	mov	ax,08585h			; APC Register 05h
	call	cmos_data_in_x
	or	al, 40h				; Enable Keyboard Password 
	or	cx,cx
	jnz	enable_keyboard_password
	and	al, not 40h			; Disable Keyboard Password  
enable_keyboard_password:
	xchg	al,ah
	call	cmos_data_out_x

	call	close_apc_cmos



	call	adjust_extended_memory_setup
	jnz	aem_00
	jmp	get_std_reboot_status
aem_00:
	ret
;-----------------------------------------------------------------------;
;		HOT_KEY_ADJUST EXTENDED MEMORY				;
;-----------------------------------------------------------------------;
; this routine is called after running HOT-KEY CMOS SETUP.		;
; If extended memory size need to be adjusted due to memory remap,	;
; relocation/shadow conflict check, or any other change necessary	;
; after HOT KEY CMOS SETUP, use this routine.				;
; this routine is called from HOT KEY CMOS SETUP before CMOS registers	;
; are actually written when "WRITE CMOS REGISTER and EXIT" is chosen.	;
; input :								;
;	ds			segment of _old_cmos_buffer &		;
;					   _common_cmos_buffer		;
;	_old_cmos_buffer	previous setting of options		;
;	_common_cmos_buffer	updated setting of options thru' CMOS SETUP
;	stack			available				;
; output: (ZF) = 1 -> proceed, (ZF) = 0 -> exit to reboot		;
; register usage -- can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: while updating extended memory size, locn in _common_cmos_buffer;
;	for cmos registers 17h,18h, 30h,31h,35h,36h must be updated	;
;	properly.							;
;-----------------------------------------------------------------------;
	public	hot_key_adjust_extended_memory
	extrn	get_hk_reboot_status:near
hot_key_adjust_extended_memory:
	call	adjust_extended_memory_setup
	jnz	aem_00			; reboot
	jmp	get_hk_reboot_status
;-----------------------------------------------------------------------;
;		INIT_BUFFER_BEFORE_SETUP	; Moved to SETUP.ASM
;-----------------------------------------------------------------------;
;			INIT_BUFFER_ADV_OPTIMAL				;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in advanced	;
; setup screen when user selects to load optimal values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
;			INIT_BUFFER_CHIPSET_OPTIMAL			;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in chipset	;
; setup screen when user selects to load optimal values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
;			INIT_BUFFER_POWER_OPTIMAL			;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in power mgmt	;
; setup screen when user selects to load optimal values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
;			INIT_BUFFER_PCI_OPTIMAL				;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in pci		;
; setup screen when user selects to load optimal values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
;			INIT_BUFFER_ADV_FAIL_SAFE			;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in advanced	;
; setup screen when user selects to load fail-safe values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
;			INIT_BUFFER_CHIPSET_FAIL_SAFE			;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in chipset	;
; setup screen when user selects to load fail-safe values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
;			INIT_BUFFER_POWER_FAIL_SAFE			;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in power mgmt.	;
; setup screen when user selects to load fail-safe values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
;			INIT_BUFFER_PCI_FAIL_SAFE			;
;-----------------------------------------------------------------------;
; This routine can be used to update _common_cmos_buffer in pci		;
; setup screen when user selects to load fail-safe values.		;
; this routine is called from CMOS_SETUP.				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
	public	init_buffer_adv_optimal
	public	init_buffer_chipset_optimal
	public	init_buffer_power_optimal
	public	init_buffer_pci_optimal
	public	init_buffer_adv_fail_safe
	public	init_buffer_chipset_fail_safe
	public	init_buffer_power_fail_safe
	public	init_buffer_pci_fail_safe
init_buffer_adv_optimal:
;        or      ds:dword ptr _common_cmos_buffer[2ah],04040404h
init_buffer_chipset_optimal:
init_buffer_power_optimal:
init_buffer_pci_optimal:
init_buffer_adv_fail_safe:
init_buffer_chipset_fail_safe:
init_buffer_power_fail_safe:
init_buffer_pci_fail_safe:
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
_text	ends
	end
