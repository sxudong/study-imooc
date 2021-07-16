page	60,132
title.		NON-SMI real/16 bit protected/32 bit protected mode code...GAPMNSMI.ASM
.tfcond

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
;-----------------------------------------------;
;	   THIS MODULE HAS THE CODE FOR		;
;	  GREEN PC APM POWER MANAGEMENT		;
;-----------------------------------------------;

cgroup	group	_text
_text	segment word	public	'CODE'
	assume cs:cgroup

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
;-----------------------------------------------;
;     THIS MODULE IS CORE POWER MANAGEMENT	;
;   BIOS MODULE WHICH DOES NOT EXECUTE IN SMI	;
;-----------------------------------------------;
;     CODES ARE REAL/16 BIT PROTECTED MODE/	;
;	     32 BIT PROTECTED MODE		;
;-----------------------------------------------;
;      ROUTINES WILL BE CALLED AS FAR/NEAR	;
;-----------------------------------------------;	
;   ROUTINES & ENTRY POINTS USED FROM OUTSIDE	;
;-----------------------------------------------;

	public	apm_real_mode_entry		;
	public	apm_16bit_prot_mode_entry	;
	public	apm_32bit_prot_mode_entry	;

;-----------------------------------------------;
;		INCLUDE FILE			;
;-----------------------------------------------;

	include	biosdata.dat			; main bios data file
	include	gapm.equ			; APM equate file

;-----------------------------------------------;

.386p
;-----------------------------------------------;
;	   EQUATES USED BY THIS MODULE		;
;-----------------------------------------------;

control_8259_master     equ     020h            ; 8259 master controller control port
control_8259_slave      equ     0a0h            ; 8259 slave controller control port

irr_reg_read_cmd        equ     00001010b       ; interrupt request reg (IRR) read

bios_data_seg		equ	40h		;

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
;---------------------------------------------------------------;
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;---------------------------------------------------------------;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;---------------------------------------------------------------;
;			APM_REAL_MODE_ENTRY			;
;---------------------------------------------------------------;

apm_real_mode_entry	proc	near

	add	sp,02h				; bypass caller

	sti					; enable interrupt
	pushfd					; save EFLAGS
	push	ebp				;
	push	ds				;

	push	apm_16_32_bit_data_seg		;
	pop	ds				; (ds) = APM real mode data segment

	mov	ah,00000001b			; set for APM BIOS called in INT 15h mode
	call	apm_real_16bit_common		;

	pop	ds				;
	pop	ebp				;
	jc	short apm_real_mode_entry_00	; error...
	popfd					; restore (EFLAGS)
	clc					; (cy) = 00 for no error
	retf	2

apm_real_mode_entry_00:
	popfd					; restore (EFLAGS)
	stc					; (cy) = 01 for error
	retf	2

apm_real_mode_entry	endp

;---------------------------------------------------------------;
;		     APM_16BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

apm_16bit_prot_mode_entry	proc	near

	mov	ah,00000010b			; set for APM BIOS called in 16 bit protected mode

	pushfd					; save EFLAGS
	push	ebp				;
	push	ds				;

	call	set_apm_prot_mode_data_seg	; (ds) = APM 16/32 bit protected mode data segment

	call	apm_real_16bit_common		;

	pop	ds				;
	pop	ebp				;
	jc	short apm_16_prot_mode_entry_00	; error...

	popfd					; restore (EFLAGS)
	clc					; (cy) = 00 for no error
	retf

apm_16_prot_mode_entry_00:
	popfd					; restore (EFLAGS)
	stc					; (cy) = 01 for error
	retf

apm_16bit_prot_mode_entry	endp

;---------------------------------------------------------------;
;		     APM_32BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

apm_32bit_prot_mode_entry	proc	near

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
	push	offset cgroup:apm_32_prot_mode_entry_01; offset
	dw	00000h				;

;;	mov	bp,dx				;
	db	066h,08bh,0eah			;
;;	shl	ebp,16				; (ebp) upper word = on entry (dx)
	db	0c1h,0e5h,010h			;
;;	mov	ah,00000100b			; set for APM BIOS called in 32 bit protected mode
	db	0b4h,004h			;
;;	mov	bp,ax				; (ebp) lower word = on entry (ax)
	db	066h,08bh,0e8h			;
;;	mov	ah,53h				; restore on entry (ah)
	db	0b4h,053h			;

	retf					; start executing in 16 bit protected mode code

;-----------------------------------------------;
; 16 BIT PROTECTED MODE CODE...ASSEMBLED WITH USE16

apm_32_prot_mode_entry_01:
	push	ds				;

	call	set_apm_prot_mode_data_seg	; (ds) = APM 16/32 bit protected mode data segment

	call	apm_real_16bit_32bit_common	;

	pop	ds				;
	pushfd					;
	mov	bp,cs				; (bp) = 16 bit protected mode CODE segment selector
	sub	bp,8				; (bp) = 32 bit protected mode CODE segment selector
	popfd					;

	push	bp				; push 32 bit segment selector
	push	offset cgroup:apm_32_prot_mode_entry_02; offset
	retf					; start executing in 32 bit protected mode

;-----------------------------------------------;
; 32 BIT PROTECTED MODE CODE...ASSEMBLED WITH USE16

apm_32_prot_mode_entry_02:
;;	pop	ebp				;
	db	05dh				;
	jc	short apm_32_prot_mode_entry_00	; error...

;;	popfd					; restore (EFLAGS)
	db	09dh				;
	clc					; (cy) = 00 for no error
	retf

apm_32_prot_mode_entry_00:
;;	popfd					; restore (EFLAGS)
	db	09dh				;
	stc					; (cy) = 01 for error
	retf

apm_32bit_prot_mode_entry	endp

;---------------------------------------------------------------;
;		      APM_REAL_16BIT_COMMON			;
;---------------------------------------------------------------;
;	Input :	(AH) bit 0 1 called in real mode (INT 15H)	;
;		     bit 1 1 called in 16 bit protected mode	;
;		     bit 2 1 called in 32 bit protected mode	;
;		     bit 3 1 called in real mode (SMB CALL FAR)	;
;			(bit 3...not used for GREEN PC)		;
;		(AL) APM function no.				;
;			Registers as defined by the APM document;
;			for related function.			;
;	Output: (CY) 01 for error & (AH) has error code		;
;		(CY) 00 for no error				;
;			Registers as defined by the APM document;
;			for related func.			;
;	Register destroyed : As defined by the related function	;
;---------------------------------------------------------------;

apm_real_16bit_common	proc	near

	mov	bp,dx				;
	shl	ebp,16				; (ebp) upper word = on entry (dx)
	mov	bp,ax				; (ebp) lower word = on entry (ax)
	mov	ah,53h				; restore on entry (ah)

;---------------------------------------------------------------;
;		  APM_REAL_16BIT_32BIT_COMMON			;
;---------------------------------------------------------------;
;	Input :	(BP) bit 8 1 called in real mode (INT 15H)	;
;		     bit 9 1 called in 16 bit protected mode	;
;		     bit 10 1 called in 32 bit protected mode	;
;		     bit 11 1 called in real mode (SMB CALL FAR);
;			(bit 11...not used for GREEN PC)	;
;		(AL) APM function no.				;
;			Registers as defined by the APM document;
;			for related function.			;
;	Output: (CY) 01 for error & (AH) has error code		;
;		(CY) 00 for no error				;
;			Registers as defined by the APM document;
;			for related func.			;
;	Register destroyed : As defined by the related function	;
;---------------------------------------------------------------;

apm_real_16bit_32bit_common	proc	near

	call	current_apm_func_in_rom		; current APM function will be executed in ROM ?
	jc	short apm_common_05		; no...
	call	exec_apm_func_in_rom		; execute current APM function in ROM
	ret

apm_common_05:
	call	rom_generate_sw_smi_for_apm	; generate software SMI for executing APM code in SMI
apm_common_06:
	ret

apm_real_16bit_32bit_common	endp
apm_real_16bit_common		endp

;---------------------------------------------------------------;
;		   SET_APM_PROT_MODE_DATA_SEG			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (DS) APM 16/32 bit protected mode data segment	;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

set_apm_prot_mode_data_seg	proc	near

	push	ax				;
	mov	ax,cs				; (ax) = 16 bit protected mode code segment selector
	add	ax,8				; (ax) = 16/32 bit protected mode data segment selector
	mov	ds,ax				; (ds) = APM 16/32 bit protected mode data segment
	pop	ax				;
	ret

set_apm_prot_mode_data_seg	endp

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
;		    CURRENT_APM_FUNC_IN_ROM			;
;---------------------------------------------------------------;
;	Input : (AL) APM function no.				;
;	Output: (CY) 01 means current APM func will not be	;
;			executed in ROM				;
;		(CY) 00 means current APM func will be executed	;
;			in ROM					;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

current_apm_func_in_rom	proc	near

	cmp	al,apm_func_05			; APM CPU IDLE call ?
	jz	short current_apm_func_in_rom_00; yes...execute in ROM...(CY) = 00
	cmp	al,apm_func_06			; APM CPU BUSY call ?
	jz	short current_apm_func_in_rom_00; yes...execute in ROM...(CY) = 00
	cmp	al,apm_func_0a			; APM get power status call ?
	jz	short current_apm_func_in_rom_20; yes...may execute in ROM...(CY) = 00
	cmp	al,apm_func_0b			; APM get PM event call ?
	jz	short current_apm_func_in_rom_10; yes...may execute in ROM...(CY) = 00
current_apm_func_in_rom_01:
	stc					; (cy) = 01 means current APM function will not be executed in ROM
current_apm_func_in_rom_00:
	ret

current_apm_func_in_rom_20:
	cmp	bx,all_power_managed_device_id	; valid device ID ?
	jnz	short current_apm_func_in_rom_01; no...may be v1.2 interface call
	ret					; (cy) = 00 for executing in ROM

current_apm_func_in_rom_10:
	push	ax				;
	push	bx				;

	call	get_rom_apm_connection_info	; (al) = current ROM_APM_CONNECTION_INFO
	mov	bx,valid_v10_event_mask		; consider APM v1.0 APM events only
	test	al,apm_bios_active_ver_above_v10; APM BIOS v1.0 ?
	jz	short current_apm_func_in_rom_11; yes
	mov	bx,valid_v11_event_mask		; consider APM v1.1 APM events only
	test	al,apm_bios_active_ver_v12	; active APM v1.2 ?
	jz	short current_apm_func_in_rom_11; yes
	mov	bx,valid_v12_event_mask		; consider APM v1.2 APM events only
current_apm_func_in_rom_11:
	call	get_rom_pending_apm_event	; (ax) = current PENDING_APM_EVENT
	and	ax,bx				; consider valid APM events
	pop	bx				;
	pop	ax				;
	jnz	short current_apm_func_in_rom_01; some event(s) pending...execute in SMI code
	ret					; (cy) = 00 for executing in ROM

current_apm_func_in_rom	endp

;---------------------------------------------------------------;
;			EXEC_APM_FUNC_IN_ROM			;
;---------------------------------------------------------------;
;	Input :	(BP) bit 8 1 called in real mode		;
;		     bit 9 1 called in 16 bit protected mode	;
;		     bit 10 1 called in 32 bit protected mode	;
;		(AL) APM function no.				;
;			Registers as defined by the APM document;
;			for related function.			;
;	Output: (CY) 01 for error & (AH) has error code		;
;		(CY) 00 for no error				;
;			Registers as defined by the APM document;
;			for related func.			;
;	Register destroyed : As defined by the related function	;
;---------------------------------------------------------------;

exec_apm_func_in_rom	proc	near

	cmp	al,apm_func_05			; APM CPU IDLE call ?
	jz	short exec_apm_func_in_rom_10	; yes...
	cmp	al,apm_func_06			; APM CPU BUSY call ?
	jz	short exec_apm_func_in_rom_20	; yes...
	cmp	al,apm_func_0a			; APM get power status call ?
	jz	short exec_apm_func_in_rom_30	; yes...
	cmp	al,apm_func_0b			; APM get PM event call ?
	jz	short exec_apm_func_in_rom_40	; yes...
	clc					; (cy) = 00 for no error
	ret

;---------------------------------------------------------------;
;		     FN# 05H ... CPU IDLE			;
;---------------------------------------------------------------;
;			EXECUTED IN ROM				;
;---------------------------------------------------------------;
;	Input :	(BP) bit 8 1 called in real mode		;
;		     bit 9 1 called in 16 bit protected mode	;
;		     bit 10 1 called in 32 bit protected mode	;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error &				;
;			(AH) has error code			;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

exec_apm_func_in_rom_10:

	push	edx				;
	push	eax				;

	call	rom_check_apm_connection	; is proper APM connection done ?
	jc	short exec_apm_func_in_rom_11	; no...

	call	rom_set_pre_cpu_idle_environment; CHIPSET HOOK HOOK HOOK...setup before going for cpu slow/stop clock
	call	rom_apm_cpu_idle_call		; CHIPSET HOOK HOOK HOOK...set stop clock/slow clock
	call	rom_set_post_cpu_idle_environment; CHIPSET HOOK HOOK HOOK...setup after coming out of stop clock
	clc					; set (CY) = 00 for no error

	pop	eax				;
	pop	edx				;
	ret

exec_apm_func_in_rom_11:
exec_apm_func_in_rom_21:
exec_apm_func_in_rom_41:
	mov	dh,ah				; save (ah) in (dh)
	pop	eax				;
	mov	ah,dh				; restore (ah) from (dh)
	pop	edx				;
	ret

;---------------------------------------------------------------;
;		     FN# 06H ... CPU BUSY			;
;---------------------------------------------------------------;
;			EXECUTED IN ROM				;
;---------------------------------------------------------------;
;	Input :	(BP) bit 8 1 called in real mode		;
;		     bit 9 1 called in 16 bit protected mode	;
;		     bit 10 1 called in 32 bit protected mode	;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error &				;
;			(AH) has error code			;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

exec_apm_func_in_rom_20:

	push	edx				;
	push	eax				;

	call	rom_check_apm_connection	; is proper APM connection done ?
	jc	short exec_apm_func_in_rom_21	; no...

	call	rom_apm_cpu_busy_call		; CHIPSET HOOK HOOK HOOK...set to full processor clock speed
	clc					; set (CY) = 00 for no error

	pop	eax				;
	pop	edx				;
	ret

;---------------------------------------------------------------;
;		     FN# 0BH ... GET PM EVENT			;
;---------------------------------------------------------------;
;			EXECUTED IN ROM				;
;---------------------------------------------------------------;
;	Input :	(BP) bit 8 1 called in real mode		;
;		     bit 9 1 called in 16 bit protected mode	;
;		     bit 10 1 called in 32 bit protected mode	;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error &				;
;			(AH) has error code			;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

exec_apm_func_in_rom_40:

	push	edx				;
	push	eax				;

	call	rom_check_apm_connection	; is proper APM connection done ?
	jc	short exec_apm_func_in_rom_41	; no...

	mov	ah,no_pm_event_pending		; no power management event pending
	stc					; (cy) = 01 for error
	jmp	short exec_apm_func_in_rom_41	;

;---------------------------------------------------------------;
;		  FN# 0AH ... GET POWER STATUS			;
;---------------------------------------------------------------;
;			EXECUTED IN ROM				;
;---------------------------------------------------------------;
;	Input :	(BP) bit 8 1 called in real mode		;
;		     bit 9 1 called in 16 bit protected mode	;
;		     bit 10 1 called in 32 bit protected mode	;
;		(BX) power device ID				;
;	Output: (CY) 00 for no error &				;
;			(BH) AC line status			;
;			(BL) battery status			;
;			(CH) battery flag (v1.1 only)		;
;			(CL) remaining battery flag (percentage	;
;			     of charge)				;
;			(DX) remaining battery life (time units);
;					(v1.1 only)		;
;		(CY) 01 for error &				;
;			(AH) has error code			;
;	Register destroyed : (AH) for error otherwise		;
;			     for v1.0 (BX),(CL)			;
;			     for v1.1 (BX),(CX),(DX)		;	
;---------------------------------------------------------------;

exec_apm_func_in_rom_30:

	cmp	bx,all_power_managed_device_id	; valid device ID ?
	jnz	short exec_apm_func_in_rom_31	; no...

	push	eax				;
	push	ecx				;
	push	edx				;
	call	rom_get_ac_battery_status	; CHIPSET HOOK HOOK HOOK...returns AC line status & 
						; battery status in (bx),(cx) & (dx)
	call	get_rom_apm_connection_info	; (al) = current ROM_APM_CONNECTION_INFO
	test	al,apm_bios_active_ver_above_v10; acive APM v1.0 ?
	jnz	short exec_apm_func_in_rom_32	; no...v1.1
	cmp	bh,02h				; AC line status is 'On backup power' ?
	jnz	short exec_apm_func_in_rom_33	; no...
	mov	bh,00h				; set AC line status as 'Off-line'
exec_apm_func_in_rom_33:
	pop	edx				; restore original (edx)
	mov	al,cl				; save (cl) in (al)
	pop	ecx				; restore original (ecx)
	mov	cl,al				; restore (cl) from (al)
	jmp	short exec_apm_func_in_rom_34	;

exec_apm_func_in_rom_32:
	mov	ax,dx				; save (dx) in (ax)
	pop	edx				; restore original (edx)
	mov	dx,ax				; restore (dx) from (ax)
	mov	ax,cx				; save (cx) in (ax)
	pop	ecx				; restore original (ecx)
	mov	cx,ax				; restore (cx) from (ax)
exec_apm_func_in_rom_34:
	pop	eax				; balance stack
	clc					; (cy) = 00 for no error
	ret

;-----------------------------------------------;

exec_apm_func_in_rom_31:
	mov	ah,invalid_device_id		; unrecognized device ID
	stc					; (cy) = 01 for error
	ret

exec_apm_func_in_rom	endp

;---------------------------------------------------------------;
;		    ROM_CHECK_APM_CONNECTION			;
;---------------------------------------------------------------;
;	Input :	(BP) bit 8 1 called in real mode		;
;		     bit 9 1 called in 16 bit protected mode	;
;		     bit 10 1 called in 32 bit protected mode	;
;	Output:	(CY) 00 for no error				;
;		(CY) 01 for error...APM not connected		;
;				 ...APM not engaged		;
;		(AH) error code for error			;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

rom_check_apm_connection	proc	near

	mov	ax,bp				; (ah) bit 0/1/2 called in real/16/32 bit mode
	call	get_rom_apm_connection_info	; (al) = current ROM_APM_CONNECTION_INFO
	test	al,ah				; is proper APM connection done ?
	jz	short rom_check_apm_connection_00; no...

	test	al,apm_bios_active_ver_above_v10; APM v1.0 ?
	jz	short rom_check_apm_connection_01; yes...(CY) = 00
	call	get_rom_apm_state		; (al) = current ROM_APM_STATE
	test	al,pm_engaged_by_apm		; power management engaged by APM ?
	jz	short rom_check_apm_connection_06; no...(CY) = 00

rom_check_apm_connection_01:
	ret

;-----------------------------------------------;

rom_check_apm_connection_06:
	mov	ah,interface_not_engaged	; APM interface not engaged
	stc					; (CY) = 01 for error
	ret

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

rom_check_apm_connection_00	proc	near

	mov	ah,interface_not_connected	; APM driver interface not connected
	stc					; (CY) = 01 for error
	ret

rom_check_apm_connection_00	endp
rom_check_apm_connection	endp

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
;		ROM_ENQUIRE_INTR_PENDING_SYSTEM			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (ZF) set means no interrupt pending.		;
;		(ZF) clear means interrupt pending &		;
;		     (AL) has master pending interrupts info	;
;		     (AH) has slave pending interrupts info	;
;	Register destroyed : (AX),(DX)				;
;---------------------------------------------------------------;

rom_enquire_intr_pending_system	proc	near

	mov	dx,control_8259_slave		;
	call	rom_read_8259_irr_reg		; (al) = interrupt pending status for slave
	mov	ah,al				; (ah) = interrupt pending status for slave
	mov	dx,control_8259_master		;
	call	rom_read_8259_irr_reg		; (al) = interrupt pending status for master
	mov	dx,ax				; (dl) = (al) = interrupt pending status for master
						; (dh) = (ah) = interrupt pending status for slave
	or	dl,dh				; set/clear (ZF)
	ret

rom_enquire_intr_pending_system	endp

;---------------------------------------------------------------;
;                     ROM_READ_8259_IRR_REG                     ;
;---------------------------------------------------------------;
;	Input :	(DX) 8259 master/slave control reg i/o port	;
;	Output: (AL) IRR read value				;
;	Register destroyed : (AL)				;
;---------------------------------------------------------------;

rom_read_8259_irr_reg	proc	near

	pushf                                   ; save current interrupt status
	cli                                     ; disable interrupts
	mov     al,irr_reg_read_cmd            	;
	out     dx, al                          ; send IRR read command to 8259
	jcxz	short $+2			; i/o delay
	jcxz	short $+2			; i/o delay
	in      al, dx                          ; (al) = read current IRR status
	popf                                    ; restore original interrupt status
	ret

rom_read_8259_irr_reg	endp

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
;		   INCLUDE FILES FOR CODE USAGE			;
;---------------------------------------------------------------;

	include	gapmnsmi.css			; runtime ROM APM code (chipset part)

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

.286p

_text	ends
	end
