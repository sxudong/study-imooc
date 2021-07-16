subttl.	Include file for DUAL/MULTIPROCESSOR support SMI handling code....GPMMP.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

;;	public	save_and_mask_apic_intr		;
;;	public	restore_and_unmask_apic_intr	;

;;	public	setup_smi_handler_for_multiple_cpu
;;	public	relocate_smbase_for_multiple_cpu;

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
;	    THIS PORTION OF CODE SUPPORTS INTEL APIC		;
;	    MULTIPROCESSOR SMI BASED POWER MANAGEMENT		;
;---------------------------------------------------------------;

IF	INTEL_APIC_MP_SUPPORT

intel_mp_smi_handler	label	byte

;---------------------------------------------------------------;
;    RUN TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    RUN TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    RUN TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    RUN TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;---------------------------------------------------------------;
; All the code from here labelled as 'NON_BSP_SMI_CODE_BEGIN' to;
; the label 'NON_BSP_SMI_CODE_END' will be copied to the smram. ;
; This code will execute in smram during the handling of smi.	;
; Please make sure that any code needed during smi handler should
; be added after the label 'NON_BSP_SMI_CODE_BEGIN' and before	;
; the label 'NON_BSP_SMI_CODE_END'.				;
;---------------------------------------------------------------;
;			  ORG 8000H				;
;---------------------------------------------------------------;

non_bsp_smi_code_begin	label	byte

	include	gpmmp.css			; DUAL/MULTIPROCESSOR SMI handling code

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
;	   RUN TIME CORE BIOS BSP APIC SAVE/RESTORE CODE	;
;	   RUN TIME CORE BIOS BSP APIC SAVE/RESTORE CODE	;
;	   RUN TIME CORE BIOS BSP APIC SAVE/RESTORE CODE	;
;	   RUN TIME CORE BIOS BSP APIC SAVE/RESTORE CODE	;
;---------------------------------------------------------------;
;		    SAVE_AND_MASK_APIC_INTR			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : NONE				;
; NOTE :							;
;  * This will mask all interrupts generated thru local APIC	;
;    of INTEL PENTIUM processor.				;
;  * (ES) has 4 GB limit at this point				;
;  * This routine should be used with BSP processor only	;
;---------------------------------------------------------------;

save_and_mask_apic_intr	proc	near

	push	es				;
	push	eax				;
	push	esi				;
	push	di				;

	push	0000h				;
	pop	es				; set (es) to 0000h to access 4 GB address space

	call	get_local_apic_base_addr	; (esi) = local APIC base address
	or	si,apic_lvt_timer_reg		; (esi) = APIC local vector table reg for TIMER (0FEE0_0320H)
	mov	di,apic_lvt_timer_reg_save_area	; (di) = APIC local vector table for TIMER save area
	call	save_mask_apic_local_vec_tbl	; save and mask APIC local interrupt

	call	get_local_apic_base_addr	; (esi) = local APIC base address
	or	si,apic_lvt_intr_00_reg		; (esi) = APIC local vector table reg for LINT0 (0FEE0_0350H)
	mov	di,apic_lvt_intr_00_reg_save_area; (di) = APIC local vector table for LINT0 save area
	call	save_mask_apic_local_vec_tbl	; save and mask APIC local interrupt

	call	get_local_apic_base_addr	; (esi) = local APIC base address
	or	si,apic_lvt_intr_01_reg		; (esi) = APIC local vector table reg for LINT1 (0FEE0_0360H)
	mov	di,apic_lvt_intr_01_reg_save_area; (di) = APIC local vector table for LINT1 save area
	call	save_mask_apic_local_vec_tbl	; save and mask APIC local interrupt

	call	get_local_apic_base_addr	; (esi) = local APIC base address
	or	si,apic_lvt_err_reg		; (esi) = APIC local vector table reg for ERROR (0FEE0_0370H)
	mov	di,apic_lvt_err_reg_save_area	; (di) = APIC local vector table for ERROR save area
	call	save_mask_apic_local_vec_tbl	; save and mask APIC local interrupt

	call	get_local_apic_base_addr	; (esi) = local APIC base address
	or	si,apic_spurious_intr_vec_reg	; (esi) = APIC spurious interrupt vector reg (0FEE0_00F0H)
	mov	di,es:[esi]			; read current setting
	and	di,0ffh				; keep the vector field only
	shl	di,2				; 1 DWORD for each vector
	mov	eax,es:[di]			; (eax) = current vector
	mov	ds:apic_spurious_intr_save_area,di; save for later restore
	mov	ds:(apic_spurious_intr_save_area + 2),eax; save it for later restore
	mov	word ptr es:[di],(offset cgroup:dummy_apic_spurious_intr_handler - offset cgroup:smi_code_begin + orgbase)
	mov	es:[di+2],cs			; segment

	call	get_local_apic_base_addr	; (esi) = local APIC base address
	or	si,apic_task_priority_reg	; (esi) = APIC task priority reg (0FEE0_0080H)
	mov	eax,es:[esi]			; read current value of APIC task priority reg
	mov	ds:apic_task_priority_reg_save_area,eax; save it for later restore
	or	al,0ffh				; set priority to 15, so that APIC will not accept any interrupts
	jmp	short save_and_mask_apic_intr_10;

save_and_mask_apic_intr	endp

;---------------------------------------------------------------;
;		  RESTORE_AND_UNMASK_APIC_INTR			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : NONE				;
; NOTE :							;
;  * This will restore previously saved mask of all interrupts	;
;    generated thru local APIC of INTEL PENTIUM processor.	;
;  * (ES) has 4 GB limit at this point				;
;  * This routine should be used with BSP processor only	;
;---------------------------------------------------------------;

restore_and_unmask_apic_intr	proc	near

	push	es				;
	push	eax				;
	push	esi				;
	push	di				;

	push	0000h				;
	pop	es				; set (es) to 0000h to access 4 GB address space

	push	cx				;
	mov	cx,4				; restore 4 local interrupts
	mov	di,apic_lvt_timer_reg_save_area	; (di) = APIC local vector table for TIMER save area
restore_and_unmask_apic_intr_00:
	mov	esi,[di]			; (esi) = APIC reg address
	mov	eax,[di+4]			; (eax) = read saved data
	call	write_apic_reg			;
	add	edi,8				; point to next entry
	loop	restore_and_unmask_apic_intr_00	;
	pop	cx				;

	mov	di,ds:apic_spurious_intr_save_area; (di) = spurious interrupt vector restore pointer
	mov	eax,ds:(apic_spurious_intr_save_area + 2); data to restore
	mov	es:[di],eax			;

	call	get_local_apic_base_addr	; (esi) = local APIC base address
	or	si,apic_task_priority_reg	; (esi) = APIC task priority reg (0FEE0_0080H)
	mov	eax,ds:apic_task_priority_reg_save_area; get the saved value

;-----------------------------------------------;

save_and_mask_apic_intr_10::
	call	write_apic_reg			;

	pop	di				;
	pop	esi				;
	pop	eax				;
	pop	es				;

	ret

restore_and_unmask_apic_intr	endp

;---------------------------------------------------------------;
;		SAVE_MASK_APIC_LOCAL_VEC_TBL			;
;---------------------------------------------------------------;
;	Input : (ESI) APIC reg address				;
;		(DI) data save address				;
;		(ES) 0000h with 4GB limit			;
;	Output: NONE						;
;	Register destroyed : (EAX)				;
; NOTE :							;
;  * (ES) has 4 GB limit at this point				;
;---------------------------------------------------------------;

save_mask_apic_local_vec_tbl	proc	near

	mov	[di],esi			; save APIC reg address
	mov	eax,es:[esi]			; (eax) = read current value
	mov	[di+04],eax			; save the data
	or	eax,apic_intr_mask_bit		; mask local APIC interrupt

;---------------------------------------------------------------;
;			WRITE_APIC_REG				;
;---------------------------------------------------------------;
;	Input : (EAX) data to write				;
;		(ESI) APIC reg address				;
;		(ES) 0000h with 4GB limit			;
;	Output: NONE						;
;	Register destroyed : NONE				;
; NOTE :							;
;  * (ES) has 4 GB limit at this point				;
;---------------------------------------------------------------;

write_apic_reg	proc	near

	mov	es:[esi],eax			;
	mov	eax,es:[esi]			; read back to post write ???
	ret

write_apic_reg	endp
save_mask_apic_local_vec_tbl	endp

;---------------------------------------------------------------;
;		DUMMY_APIC_SPURIOUS_INTR_HANDLER		;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

dummy_apic_spurious_intr_handler	proc	far

	iret

dummy_apic_spurious_intr_handler	endp

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
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;---------------------------------------------------------------;
;		SETUP_SMI_HANDLER_FOR_MULTIPLE_CPU		;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
;		     bit 1 set for smbase requires relocation	;
;		     bit 1 clear for smbase relocation not reqd.;
;		     bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		     bit 5 set for IRQ based power management	;
;		     bit 5 clear for SMI based power management	;
;		     bit 6 set for SMI capable CPU		;
;		     bit 6 clear for non-SMI CPU		;
;		(BH) bit 3-0...no. of secondary CPU present	;
;		     bit 7-4...IRQ level for IRQ power management
;		(CH) cpu vendor #				;
;			00 Intel				;
;			01 Cyrix				;
;			02 AMD					;
;			03 IBM					;
;			04 TI					;
;			05 UMC					;
;		(CL) cpu #					;
;			>= 16 IBM-CYRIX cpu (all in decimal)	;
;			12-31 AMD-PLUS cpu (all in decimal)	;
;			0ffh means UNKNOWN CPU			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : (EAX),(EDX),(SI),(EDI)		;
;---------------------------------------------------------------;

setup_smi_handler_for_multiple_cpu	proc	near

	xor	si,si				; smram init request
	call	common_smi_init_for_multiple_cpu; do smram initialisation for all secondary cpu
	ret

setup_smi_handler_for_multiple_cpu	endp

;---------------------------------------------------------------;
;		RELOCATE_SMBASE_FOR_MULTIPLE_CPU		;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment (not accessible)		;
;		(ES) SMRAM segment (not accessible)		;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
;		     bit 1 set for smbase requires relocation	;
;		     bit 1 clear for smbase relocation not reqd.;
;		     bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		     bit 5 set for IRQ based power management	;
;		     bit 5 clear for SMI based power management	;
;		     bit 6 set for SMI capable CPU		;
;		     bit 6 clear for non-SMI CPU		;
;		(BH) bit 3-0...no. of secondary CPU present	;
;		     bit 7-4...IRQ level for IRQ power management
;		(CH) cpu vendor #				;
;			00 Intel				;
;			01 Cyrix				;
;			02 AMD					;
;			03 IBM					;
;			04 TI					;
;			05 UMC					;
;		(CL) cpu #					;
;			>= 16 IBM-CYRIX cpu (all in decimal)	;
;			12-31 AMD-PLUS cpu (all in decimal)	;
;			0ffh means UNKNOWN CPU			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : (EAX),(EDX),(SI),(EDI)		;
;---------------------------------------------------------------;

relocate_smbase_for_multiple_cpu	proc	near

	mov	si,0ffh				; smbase relocation request
	call	common_smi_init_for_multiple_cpu; do smbase relocation for all secondary cpu
	ret

relocate_smbase_for_multiple_cpu	endp

;---------------------------------------------------------------;
;		COMMON_SMI_INIT_FOR_MULTIPLE_CPU		;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(SI) 00h/0ffh for smram init/smbase relocation	;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
;		     bit 1 set for smbase requires relocation	;
;		     bit 1 clear for smbase relocation not reqd.;
;		     bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		     bit 5 set for IRQ based power management	;
;		     bit 5 clear for SMI based power management	;
;		     bit 6 set for SMI capable CPU		;
;		     bit 6 clear for non-SMI CPU		;
;		(BH) bit 3-0...no. of secondary CPU present	;
;		     bit 7-4...IRQ level for IRQ power management
;		(CH) cpu vendor #				;
;			00 Intel				;
;			01 Cyrix				;
;			02 AMD					;
;			03 IBM					;
;			04 TI					;
;			05 UMC					;
;		(CL) cpu #					;
;			>= 16 IBM-CYRIX cpu (all in decimal)	;
;			12-31 AMD-PLUS cpu (all in decimal)	;
;			0ffh means UNKNOWN CPU			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : (EAX),(EDX),(SI),(EDI)		;
;---------------------------------------------------------------;

common_smi_init_for_multiple_cpu	proc	near

	test	bl,dual_cpu_present		; dual/multiple cpu present ?
	jz	short common_init_multiple_cpu_01; no...EXIT...(CY) = 00
	test	bl,irq_power_management		; IRQ based power management active ?
	jnz	short common_init_multiple_cpu_01; yes...EXIT...(CY) = 00

	or	si,si				; smram init ?
	jnz	short common_init_multiple_cpu_05; no...smbase relocation

	push	si				;
	call	get_mapped_smi_seg_and_size	; CHIPSET HOOK HOOK HOOK...(edi) = SMI area size
	pop	si				;
	movzx	eax,bh				;
	and	al,00001111b			; (eax) = # of secondary CPU present
	inc	al				; include boot strap processor (BSP)
	shl	eax,15				; 32KB SMI space needed for each CPU
	cmp	edi,eax				; is enough SMI space available ?
	jc	short common_init_multiple_cpu_01; error...not enough SMI space available

;-----------------------------------------------;

	mov	ds:bsp_code_seg_cseg,ds		; set BSP code segment in BSP SMRAM space
	mov	word ptr ds:current_processor_bit_cseg,boot_strap_processor_bit
	mov	word ptr ds:processor_in_smi_info_cseg,0000h; clear processor in SMI

;-----------------------------------------------;

common_init_multiple_cpu_05:
	mov	dx,ds				; (dx) = segment for BSP processor
	sub	dx,800h				; (dx) = segment for 1st secondary processor (non-BSP)
	mov	ax,0000000000000010b		; bit position for 1st secondary processor
	call	multiple_cpu_common		; init/smbase relocation for current cpu
	jc	short common_init_multiple_cpu_01; error...during SMRAM copy/compare
	add	dx,1000h			; (dx) = segment for next secondary processor

;-----------------------------------------------;

	movzx	di,bh				;
	and	di,0000000000001111b		; (di) = # of secondary cpu present

common_init_multiple_cpu_03:
	dec	di				; decrement # of secondary cpu
	jz	short common_init_multiple_cpu_02; all secondary cpu done
	shl	ax,1				; bit position for next secondary cpu
	call	multiple_cpu_common		; init/smbase relocation for current cpu
	jc	short common_init_multiple_cpu_01; error...during SMRAM copy/compare
	add	dx,800h				; (dx) = segment for next secondary cpu
	jmp	short common_init_multiple_cpu_03

common_init_multiple_cpu_02:
	clc					; (cy) = 00 for no error
common_init_multiple_cpu_01:
	ret

common_smi_init_for_multiple_cpu	endp

;---------------------------------------------------------------;
;			MULTIPLE_CPU_COMMON			;
;---------------------------------------------------------------;
;	Input : (DS) boot strap processor (BSP) SMI code segment;
;		(ES) boot strap processor (BSP) SMI code segment;
;		(CS) dual/multiple CPU SMI code source segment	;
;		(AX) current processor bit			;
;		(DX) dual/multiple processor SMI code segment	;
;		(SI) 00h/0ffh for smram init/smbase relocation	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for miscompare				;
;	Register destroyed : upper 16 bit of (EAX)		;
;---------------------------------------------------------------;

multiple_cpu_common	proc	near

	or	si,si				; smram init ?
	jnz	short multiple_cpu_common_01	; no...smbase relocation
	call	copy_compare_multiple_cpu_smram	; copy SMRAM code to 1st secondary processor and initialise
	ret

multiple_cpu_common_01:
	call	relocate_smbase_individual_cpu	; relocate smbase for individual cpu
	ret

multiple_cpu_common	endp

;---------------------------------------------------------------;
;		COPY_COMPARE_MULTIPLE_CPU_SMRAM			;
;---------------------------------------------------------------;
;	Input : (DS) boot strap processor (BSP) SMI code segment;
;		(ES) boot strap processor (BSP) SMI code segment;
;		(CS) dual/multiple CPU SMI code source segment	;
;		(AX) current processor bit			;
;		(DX) dual/multiple processor SMI code segment	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for miscompare				;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

copy_compare_multiple_cpu_smram	proc	near

	pusha					;
	push	es				;
	mov	es,dx				; (es) = SMI code destination segment for current processor
	mov	si,offset cgroup:non_bsp_smi_code_begin	; (cs:si) = SMI code start
	mov	cx,offset cgroup:non_bsp_smi_code_end
	call	copy_compare_cpu_smram		;

	mov	es:bsp_code_seg_cseg,ds		; fill in BSP code segment in local processor area
	mov	es:current_processor_bit_cseg,ax; fill in info about processor #

	pop	es				;
	popa					;
	ret

copy_compare_multiple_cpu_smram	endp

;---------------------------------------------------------------;
;		RELOCATE_SMBASE_INDIVIDUAL_CPU			;
;---------------------------------------------------------------;
;	Input : (DS) boot strap processor (BSP) SMI code segment;
;		(ES) boot strap processor (BSP) SMI code segment;
;		(CS) dual/multiple CPU SMI code source segment	;
;		(AX) current processor bit			;
;		(DX) dual/multiple processor SMI code segment	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for miscompare				;
;	Register destroyed : upper 16 bit of (EAX)		;
;---------------------------------------------------------------;

relocate_smbase_individual_cpu	proc	near

	pusha					;
	push	es				;

	mov	cx,3000h			;
	mov	es,cx				; (es) = default SMRAM segment

	push	ds				;
	call	get_bsp_default_smram_save_info	;
	rep	movsd				; save BSP default SMRAM code
	pop	ds				;

	mov	si,offset cgroup:non_bsp_relocation_code_begin	; (cs:si) = SMI code start
	mov	cx,offset cgroup:non_bsp_relocation_code_end
	call	copy_compare_cpu_smram		;
	jc	short rel_smbase_ind_cpu_00	; error in copy/compare
	mov	es:smi_code_seg_intel_amd_plus_cseg,dx; set SMI code segment for current processor
	mov	byte ptr es:processor_in_smi_info_cseg,11111111b; set current processor in SMI
	call	send_apic_smi_ipi		; send SMI IPI for current processor for reloaction
	jc	short rel_smbase_ind_cpu_02	; error in sending SMI IPI

	xor	cx,cx				; wait in 64K loop for current processor in SMI for smbase relocation
rel_smbase_ind_cpu_01:
	test	byte ptr es:processor_in_smi_info_cseg,11111111b; is current processor still in SMI ?
	loopnz	rel_smbase_ind_cpu_01		; wait for current processor out of SMI
	jz	short rel_smbase_ind_cpu_02	; no...(cy) = 00

;-----------------------------------------------;
;	REMOVE FOLLOWING CODE AS DURING SOFT	;
;	 RESET SMBASE IS ALREADY RELOCATED	;
;-----------------------------------------------;

;;	stc					; (cy) = 01 for error

;-----------------------------------------------;

rel_smbase_ind_cpu_02:
	loop	$				; some delay to put current processor really out of SMI
rel_smbase_ind_cpu_00:
	push	ds				;
	call	get_bsp_default_smram_save_info	;
	xchg	si,di				;
	rep	movsd				; restore BSP default SMRAM code
	pop	ds				;

	pop	es				;
	popa					;
	ret

relocate_smbase_individual_cpu	endp

;---------------------------------------------------------------;
;		GET_BSP_DEFAULT_SMRAM_SAVE_INFO			;
;---------------------------------------------------------------;
;	Input : (ES) default INTEL CPU SMI segment (3000H)	;
;	Output: (DS) default INTEL CPU SMI segment (3000H)	;
;		(DI) offset for saving BSP default SMRAM	;
;		(SI) offset for BSP default SMRAM code		;
;		(CX) count of DWORDs for BSP default SMRAM code	;
;	Register destroyed : (DS),(DI),(SI),(CX)		;
;			   : FLAGS NOT AFFECTED			;
;---------------------------------------------------------------;

get_bsp_default_smram_save_info	proc	near

	push	es				;
	pop	ds				; (ds) = (es)
	mov	di,0000h			; (di) = offset for saving BSP default SMRAM
	mov	si,8000h			; (si) = offset for BSP default SMRAM code
	mov	cx,2000h			; 32KB of code+data to be moved
	ret

get_bsp_default_smram_save_info	endp

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

non_bsp_relocation_code_begin	label	byte

;---------------------------------------------------------------;
;		INTEL_NON_BSP_CPU_RELOCATION_ENTRY		;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

intel_non_bsp_cpu_relocation_entry	proc	near

	cli					; disable interrupts
	movzx	eax,word ptr cs:smi_code_seg_intel_amd_plus_cseg; (eax) = SMI code segment selector
	shl	eax,4				; (eax) = absolute address
	mov	cs:cpu_dump_smbase_slot_intl,eax; change SMBASE
	lock	xor byte ptr cs:processor_in_smi_info_cseg,11111111b; set current processor not in SMI

;-----------------------------------------------;
;     FOLLOWING CODE HAS BEEN ADDED TO TAKE	;
;     CARE OF A BUG IN INTEL PENTIUM PRO CPU	;
;     (P6). ERRATA #38 (RSM CAN NOT RETURN TO	;
;     HALT IN 32BIT OS.				;
;-----------------------------------------------;

	test	byte ptr cs:cpu_dump_halt_auto_restart_intl,00000001b; previous instruction was 'HLT' ?
	jz	short intel_non_bsp_relocation_11; no...
	and	byte ptr cs:cpu_dump_halt_auto_restart_intl,11111110b; do not return to auto halt state
	dec	dword ptr cs:cpu_dump_eip_intl	; position the EIP to 'HLT' instruction
intel_non_bsp_relocation_11:

;-----------------------------------------------;

	intel_rsm				; RSM (resume from SMI)

intel_non_bsp_cpu_relocation_entry	endp

;---------------------------------------------------------------;

non_bsp_relocation_code_end	label	byte

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

non_bsp_smi_code_end	label	byte

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

intel_mp_smi_handler_ends	label	byte

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

intel_mp_smi_handler_dummy	label	byte

;---------------------------------------------------------------;
;		   DUMMY SUPPORT FOR INTEL APIC			;
;	    MULTIPROCESSOR SMI BASED POWER MANAGEMENT		;
;---------------------------------------------------------------;
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;    POST TIME CORE BIOS DUAL/MULTIPROCESSOR SMI HANDLER CODE	;
;---------------------------------------------------------------;
;		SETUP_SMI_HANDLER_FOR_MULTIPLE_CPU		;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
;		     bit 1 set for smbase requires relocation	;
;		     bit 1 clear for smbase relocation not reqd.;
;		     bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		     bit 5 set for IRQ based power management	;
;		     bit 5 clear for SMI based power management	;
;		     bit 6 set for SMI capable CPU		;
;		     bit 6 clear for non-SMI CPU		;
;		(BH) bit 3-0...no. of secondary CPU present	;
;		     bit 7-4...IRQ level for IRQ power management
;		(CH) cpu vendor #				;
;			00 Intel				;
;			01 Cyrix				;
;			02 AMD					;
;			03 IBM					;
;			04 TI					;
;			05 UMC					;
;		(CL) cpu #					;
;			>= 16 IBM-CYRIX cpu (all in decimal)	;
;			12-31 AMD-PLUS cpu (all in decimal)	;
;			0ffh means UNKNOWN CPU			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : (EAX),(EDX),(SI),(EDI)		;
;---------------------------------------------------------------;

setup_smi_handler_for_multiple_cpu	proc	near

;---------------------------------------------------------------;
;		RELOCATE_SMBASE_FOR_MULTIPLE_CPU		;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment (not accessible)		;
;		(ES) SMRAM segment (not accessible)		;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
;		     bit 1 set for smbase requires relocation	;
;		     bit 1 clear for smbase relocation not reqd.;
;		     bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		     bit 5 set for IRQ based power management	;
;		     bit 5 clear for SMI based power management	;
;		     bit 6 set for SMI capable CPU		;
;		     bit 6 clear for non-SMI CPU		;
;		(BH) bit 3-0...no. of secondary CPU present	;
;		     bit 7-4...IRQ level for IRQ power management
;		(CH) cpu vendor #				;
;			00 Intel				;
;			01 Cyrix				;
;			02 AMD					;
;			03 IBM					;
;			04 TI					;
;			05 UMC					;
;		(CL) cpu #					;
;			>= 16 IBM-CYRIX cpu (all in decimal)	;
;			12-31 AMD-PLUS cpu (all in decimal)	;
;			0ffh means UNKNOWN CPU			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : (EAX),(EDX),(SI),(EDI)		;
;---------------------------------------------------------------;

relocate_smbase_for_multiple_cpu	proc	near

	clc					; (cy) = 00 for no error
	ret

relocate_smbase_for_multiple_cpu	endp
setup_smi_handler_for_multiple_cpu	endp

;---------------------------------------------------------------;

intel_mp_smi_handler_dummy_ends	label	byte

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
