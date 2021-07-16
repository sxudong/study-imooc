subttl.	Include file for GREEN PC support IRQ handling code....GPMIRQ.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

;;	public	setup_irq_handler		;

;;	public	exec_irq_pm			;

;;	public	check_and_write_protect_irq_shadow

;-----------------------------------------------;
;	   IRQ HANDLING STACK EQUATES		;
;-----------------------------------------------;

off_eax_irq			equ	28	;
off_ebx_irq			equ	16	;
off_ecx_irq			equ	24	;
off_edx_irq			equ	20	;
off_esi_irq			equ	04	;
off_edi_irq			equ	00	;
off_ebp_irq			equ	08	;
off_flag_irq			equ	40	;

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
;   THIS PORTION OF CODE SUPPORTS IRQ BASED POWER MANAGEMENT	;
;---------------------------------------------------------------;

IF	IRQ_HANDLING_SUPPORT

irq_handler	label	byte

;---------------------------------------------------------------;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;---------------------------------------------------------------;
;			SETUP_IRQ_HANDLER			;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB SMRAM			;
;		     bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		     bit 5 set for IRQ based power management	;
;		     bit 5 clear for SMI based power management	;
;		(BH) bit 3-0...no. of secondary CPU present	;
;		     bit 7-4...IRQ level for IRQ power management
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (AX),(DX),(DI)			;
;---------------------------------------------------------------;

setup_irq_handler	proc	near

	push	cx				;

	mov	cl,bh				;
	shr	cl,4				; (cl) = IRQ level
	mov	al,70h				; slave interrupt controller base vector
	mov     dx,mask_8259_slave 	        ; (dx) = 8259 slave mask port (0a0h)
	test	cl,00001000b			; IRQ level 0 thru 7 ?
	jnz	short setup_irq_handler_01	; no...level 8 thru 15
	mov	al,08h				; master interrupt controller base vector
	mov     dx,mask_8259_master 	        ; (dx) = 8259 master mask port (020h)
setup_irq_handler_01:
	and     cl,00000111b                    ; make the level 0 thru 7
	add	al,cl				; get appropriate vector
	movzx	di,al				;
	shl	di,2				; 4 bytes for each vector

	pushf					; save current interrupt flag
	cli					; disable interrupts
	push	ds				;
	push	int_vec_seg			;
	pop	ds				; (ds) = INT vector address segment
	mov	word ptr [di],offset cgroup:exec_irq_pm - offset cgroup:smi_code_begin + orgbase; OFFSET
	mov	[di+2],es			; SEGMENT
	pop	ds				;

	mov	ah,00000001b			;
	shl	ah,cl				; bring it to proper bit position
	not	ah				;
	in	al,dx				; (al) = read current mask status
	smi_io_delay				; i/o delay

	and	al,ah				; unmask the required level
	out	dx,al				;

	popf					; restore interrupt status
	pop	cx				;
	ret

setup_irq_handler	endp

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
;		RUN TIME CORE BIOS IRQ HANDLER CODE		;
;		RUN TIME CORE BIOS IRQ HANDLER CODE		;
;		RUN TIME CORE BIOS IRQ HANDLER CODE		;
;		RUN TIME CORE BIOS IRQ HANDLER CODE		;
;---------------------------------------------------------------;
;			     EXEC_IRQ_PM			;
;---------------------------------------------------------------;

exec_irq_pm	proc	near

	cli					; disable interrupts
	cld					; clear direction flag

	push	ds				;
	push	es				;
	pushad					;

	mov	ax,cs				; (ax) = data segment for IRQ execution
	mov	ds,ax				; set (DS) as PM BIOS data segment
	mov	es,ax				; set (ES) as PM BIOS data segment

	call	write_enable_irq_shadow		; CHIPSET HOOK HOOK HOOK...write enable shadow ram area used for IRQ based power management implementation
						; shadow area is alreay readable
						; DO NOT CHANGE SHADOW READ STATUS

	mov	byte ptr ds:irq_in_progress,0ffh; indicate IRQ handler is currently being executed

;-----------------------------------------------;

	pushfd					;
	pop	eax				; (eax) = EFLAGS
	mov	ds:[cpu_gen_purpose_reg_entry+reg_eflags],eax; on entry EFLAGS
	mov	eax,cr0				; (eax) = on entry CR0
	mov	ds:[cpu_gen_purpose_reg_entry+reg_cr0],eax; on entry CR0

;-----------------------------------------------;

	mov	ds:save_irq_ss,ss		; save on entry (SS)
	mov	ds:save_irq_sp,sp		; save on entry (SP)

	push	cs				;
	pop	ss				; (SS) = (CS)
	mov	sp,pm_bios_global_stack_ptr	; set (SP) for GLOBAL stack pointer

	call	actual_smi_handler		; handle the SMI source

	cli					; disable interrupts

	mov	ss,ds:save_irq_ss		; restore on entry (SS)
	mov	sp,ds:save_irq_sp		; restore on entry (SP)

	mov	byte ptr ds:irq_in_progress,000h; indicate IRQ handler is not being executed

;-----------------------------------------------;

	call	check_and_write_protect_irq_shadow; write protect shadow ram area used for IRQ based power management implementation
						; shadow area is alreay readable
						; DO NOT CHANGE SHADOW READ STATUS

;-----------------------------------------------;

	mov	al,eoi_cmd			;
	test	byte ptr ds:irq_used_for_pm,00001000b; IRQ level 8 thru 15 ?
	jz	short exec_irq_pm_01		; no...0 thru 7
	out	control_8259_slave,al		; send end of interrupt
	smi_io_delay				; i/o delay
exec_irq_pm_01:
	out	control_8259_master,al		; send end of interrupt

	popad					;
	pop	es				;
	pop	ds				;
	iret

exec_irq_pm	endp

;---------------------------------------------------------------;
;		CHECK_AND_WRITE_PROTECT_IRQ_SHADOW		;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		STACK PRESENT...OS STACK...RESTRICTED USAGE	;
;	Output: NONE						;
;	Register destroyed : (EAX),(EDX)			;
;---------------------------------------------------------------;

check_and_write_protect_irq_shadow	proc	near

	mov	al,ds:irq_apm_in_progress	; (al) = IRQ APM handling in progress status
	or	al,ds:irq_in_progress		; IRQ handling/IRQ APM in progress ?
	jnz	short check_and_protect_01	; yes...do not write protect IRQ shadow area
	call	write_protect_irq_shadow	; CHIPSET HOOK HOOK HOOK...write protect shadow ram area used for IRQ based power management implementation
						; shadow area is alreay readable
						; DO NOT CHANGE SHADOW READ STATUS
check_and_protect_01:
	ret

check_and_write_protect_irq_shadow	endp

;---------------------------------------------------------------;

irq_handler_ends	label	byte

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

irq_handler_dummy	label	byte

;---------------------------------------------------------------;
;		  DUMMY SUPPORT FOR IRQ HANDLING		;
;---------------------------------------------------------------;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;		POST TIME CORE BIOS IRQ HANDLER CODE		;
;---------------------------------------------------------------;
;			SETUP_IRQ_HANDLER			;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB SMRAM			;
;		     bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		     bit 5 set for IRQ based power management	;
;		     bit 5 clear for SMI based power management	;
;		(BH) bit 3-0...no. of secondary CPU present	;
;		     bit 7-4...IRQ level for IRQ power management
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (AX),(DI)				;
;---------------------------------------------------------------;

setup_irq_handler	proc	near

	ret

setup_irq_handler	endp

;---------------------------------------------------------------;

irq_handler_dummy_ends	label	byte

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

