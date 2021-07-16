Subttl.	Include file for GREEN PC support SMI code...GPMSMI.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

;;	public	actual_smi_handler		;

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
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;---------------------------------------------------------------;
;		       ACTUAL_SMI_HANDLER			;
;---------------------------------------------------------------;

actual_smi_handler	proc	near

	call	save_and_mask_intr		; save and mask all interrupts

IF	IRQ_HANDLING_SUPPORT
	call	check_irq_pm			; IRQ based power management ?
	jnz	short actual_smi_handler_02	; yes...bypass setting up general purpose register structure as it is already done
ENDIF

	lock	or word ptr cs:processor_in_smi_info_cseg,boot_strap_processor_bit; set BSP in SMI
						; LOCK the previous instruction
	mov	ah,pm_cpu_func_00		; get general purpose registers
	call	cpu_support_entry		; setup the general purpose registers in the structure
actual_smi_handler_02:

;-----------------------------------------------;
;	 FOR SMI BASED POWER MANAGEMENT		;
;-----------------------------------------------;
;	CPU_GEN_PURPOSE_REG_ENTRY is filled with;
;	general purpose register values		;
;	when the smi was generated.		;
;						;
;  CPU_GEN_PURPOSE_REG_ENTRY 			;
;	+ reg_eax (000H)    ... (eax)		;
;	+ reg_ebx (004H)    ... (ebx)		;
;	+ reg_ecx (008H)    ... (ecx)		;
;	+ reg_edx (00cH)    ... (edx)		;
;	+ reg_esi (010H)    ... (esi)		;
;	+ reg_edi (014H)    ... (edi)		;
;	+ reg_ebp (018H)    ... (ebp)		;
;	+ reg_eflags (01cH) ... (eflags)	;
;	+ reg_cr0 (020H)    ... (cr0)		;
;						;
;  *  This register structure can be used by	;
;     chipset porting to pass parameters to and	;
;     from smi for software smi.		;
;  *  Smi handler updates the cpu registers exit;
;     values from this register structure at the;
;     time of exiting smi (except for CR0 which	;
;     does not get updated).			;
;  *  The register structure is available when	;
;     chipset porting gets control at individual;
;     smi source handler, so if you want to make;
;     changes to any of the register values, do	;
;     it inside the smi source handler.		;
;-----------------------------------------------;

;-----------------------------------------------;
;	 FOR IRQ BASED POWER MANAGEMENT		;
;-----------------------------------------------;
;	Following registers of CPU_GEN_PURPOSE_	;
;	REG_ENTRY is filled with register values;
;	when the irq was generated.		;
;						;
;  CPU_GEN_PURPOSE_REG_ENTRY 			;
;	+ reg_eflags (01cH) ... (eflags)	;
;	+ reg_cr0 (020H)    ... (cr0)		;
;						;
;-----------------------------------------------;

re_entrant_smi_handling:
	call	get_smi_source			; CHIPSET HOOK HOOK HOOK ... returns (bx) = SMI source
	or	bx,bx				; any active SMI source ?
	jz	short actual_smi_handler_01	; no...exit
	cmp	bx,smi_jmp_table_size		; valid smi source ?
	ja	short actual_smi_handler_01	; no...exit
	dec	bx				;
	shl	bx,1				; (bx) = smi source # * 2
	call	word ptr cgroup:[bx+cgroup:smi_jmp_table - cgroup:smi_code_begin + orgbase]
						; CHIPSET HOOK HOOK HOOK...for individual SMI source handling

;;	jmp	short re_entrant_smi_handling	; ENABLE THIS LINE IF U WANT TO HANDLE SMI SOURCES RE-ENTRANTLY

actual_smi_handler_01:

;-----------------------------------------------;
;	CPU_GEN_PURPOSE_REG_ENTRY is filled with;
;	general purpose register values		;
;	when the smi/irq was generated.		;
;						;
;  CPU_GEN_PURPOSE_REG_ENTRY 			;
;	+ reg_eax (000H)    ... (eax)		;
;	+ reg_ebx (004H)    ... (ebx)		;
;	+ reg_ecx (008H)    ... (ecx)		;
;	+ reg_edx (00cH)    ... (edx)		;
;	+ reg_esi (010H)    ... (esi)		;
;	+ reg_edi (014H)    ... (edi)		;
;	+ reg_ebp (018H)    ... (ebp)		;
;	+ reg_eflags (01cH) ... (eflags)	;
;	+ reg_cr0 (020H)    ... (cr0)		;
;						;
;  *  This register structure can be used by	;
;     chipset porting to pass parameters to and	;
;     from smi/irq.				;
;  *  Valid registers for smi/irq during entry &;
;     exit is mentioned in above note.		;
;-----------------------------------------------;

IF	IRQ_HANDLING_SUPPORT
	call	check_irq_pm			; IRQ based power management ?
	jnz	short actual_smi_handler_03	; yes...bypass restoring from general purpose register structure as it is already done
ENDIF

	lock	and word ptr cs:processor_in_smi_info_cseg,not boot_strap_processor_bit; set BSP is out of SMI
						; LOCK the previous instruction
	mov	ah,pm_cpu_func_01		; set general purpose registers
	call	cpu_support_entry		; change the general purpose registers from the structure
actual_smi_handler_03:

	call	restore_and_unmask_intr		; restore and unmask all interrupts

	call	clear_smi			; CHIPSET HOOK HOOK HOOK...clear SMI

	mov	ax,ds:pending_apm_event		; (ax) = current pending APM event
	call	set_rom_pending_apm_event	; set in ROM data area

	ret

actual_smi_handler	endp

;---------------------------------------------------------------;
;			  SMI_JMP_TABLE				;
;---------------------------------------------------------------;

smi_jmp_table	label	word

	dw	cgroup:doze_handler - cgroup:smi_code_begin + orgbase	; DOZE HANDLER
	dw	cgroup:sleep_handler - cgroup:smi_code_begin + orgbase	; SLEEP HANDLER
	dw	cgroup:suspend_handler - cgroup:smi_code_begin + orgbase; SUSPEND HANDLER
	dw	cgroup:device_handler - cgroup:smi_code_begin + orgbase	; DEVICE TIMEOUT HANDLER
	dw	cgroup:apm_handler - cgroup:smi_code_begin + orgbase	; APM SMI HANDLER
	dw	cgroup:sw_smi_handler - cgroup:smi_code_begin + orgbase	; SOFTWARE SMI HANDLER
	dw	cgroup:io_trap_handler - cgroup:smi_code_begin + orgbase; DEVICE IOTRAP HANDLER
	dw	cgroup:chipset_handler - cgroup:smi_code_begin + orgbase; CHIPSET HANDLER
	dw	cgroup:resume0_handler - cgroup:smi_code_begin + orgbase; RESUME#0 HANDLER
	dw	cgroup:lb_handler - cgroup:smi_code_begin + orgbase	; LOW BATTERY HANDLER
	dw	cgroup:vlb_handler - cgroup:smi_code_begin + orgbase	; VERY LOW BATTERY HANDLER
	dw	cgroup:relocation_handler - cgroup:smi_code_begin + orgbase ; RELOCATE SMBASE HANDLER
	dw	cgroup:new_memory_ecc_handler - cgroup:smi_code_begin + orgbase ; MEMORY ECC SCRUBBING HANDLER
	dw	cgroup:new_usb_init_handler - cgroup:smi_code_begin + orgbase ; USB INITIALIZATION HANDLER
	dw	cgroup:new_usb_handler - cgroup:smi_code_begin + orgbase ; USB HANDLER
	dw	cgroup:new_special_00_handler - cgroup:smi_code_begin + orgbase ; SPECIAL 00 HANDLER
	dw	cgroup:new_special_01_handler - cgroup:smi_code_begin + orgbase ; SPECIAL 01 HANDLER
	dw	cgroup:resume1_handler - cgroup:smi_code_begin + orgbase; RESUME#1 HANDLER

smi_jmp_table_end	label	byte

;---------------------------------------------------------------;

smi_jmp_table_size	equ	(smi_jmp_table_end - smi_jmp_table)/2

;---------------------------------------------------------------;
;			RELOCATION_HANDLER			;
;---------------------------------------------------------------;
;	Input : NONE						;
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : ALL GENERAL PURPOSE		;
; NOTE :							;
;  *  This is one of the hook from smi handler to handle individual
;     smi source. The control will come here if you detected 	;
;     software smi for smbase relocation source in 'GET_SMI_	;
;     SOURCE' routine.						;
;  *  Implementation of this hook is mandatory if your board/	;
;     chipset requires smbase relocation for INTEL and AMP PLUS	;
;     CPUs.							;
;---------------------------------------------------------------;

relocation_handler	proc	near

	test	word ptr ds:cpu_vendor,intel_cpu_bit; INTEL/AMD PLUS CPU ?
	jz	short relocation_handler_00	; no...exit
	call	intel_amd_plus_relocation	;
relocation_handler_00:
	ret

relocation_handler	endp

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
