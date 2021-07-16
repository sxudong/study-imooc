Subttl.	Include file for GREEN PC support CPU code...GPMCPU.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

;;	public	cpu_support_entry		;
;;	public	cpu_smi_exit			;

;;	public	intel_cpu_smi_entry_ext		;
;;	public	crx_cpu_smi_entry_ext		;
;;	public	amd_cpu_smi_entry_ext		;
;;	public	ibm_cpu_smi_entry_ext		;
;;	public	ti_cpu_smi_entry_ext		;
;;	public	umc_cpu_smi_entry_ext		;

;;	public	intel_amd_plus_relocation	;

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
;		  THIS MODULE HAS THE CODE FOR			;
;		    SUPPORTING DIFFERENT CPU			;
;---------------------------------------------------------------;
;			CPU_SMI_EXIT				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

cpu_smi_exit	proc	near

	call	get_cpu_vendor			; returns (si) = cpu vendor no.
	shl	si,1				; (si) = cpu vendor # * 2
	jmp	word ptr cgroup:[si+cgroup:cpu_smi_exit_jmp_table - cgroup:smi_code_begin + orgbase]; execute the function

cpu_smi_exit	endp

;---------------------------------------------------------------;
;		     CPU_SMI_EXIT_JMP_TABLE			;
;---------------------------------------------------------------;

cpu_smi_exit_jmp_table	label	word

	dw	cgroup:intel_cpu_smi_exit - cgroup:smi_code_begin + orgbase; INTEL CPU
	dw	cgroup:crx_cpu_smi_exit - cgroup:smi_code_begin + orgbase  ; CYRIX CPU
	dw	cgroup:amd_cpu_smi_exit - cgroup:smi_code_begin + orgbase  ; AMD CPU
	dw	cgroup:ibm_cpu_smi_exit - cgroup:smi_code_begin + orgbase  ; IBM CPU
	dw	cgroup:ti_cpu_smi_exit - cgroup:smi_code_begin + orgbase   ; TI CPU
	dw	cgroup:umc_cpu_smi_exit - cgroup:smi_code_begin + orgbase   ; UMC CPU

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
;			CPU_SUPPORT_ENTRY			;
;---------------------------------------------------------------;
;	Input : (AH) function no.				;
;		(DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for unsupported func or CPU not specified
;			or CPU not supported			;
;	Register Destroyed : NONE				;
;---------------------------------------------------------------;

cpu_support_entry	proc	near

	cmp	ah,maxm_cpu_func_supported	; valid function no. ?
	ja	short cpu_support_entry_01	; no...invalid function

	pushad					; save all general purpose registers
	movzx	si,ah				; (si) = function #
	shl	si,1				; (si) = function # * 2
	call	word ptr cgroup:[si+cgroup:cpu_support_jmp_table - cgroup:smi_code_begin + orgbase]; execute the function
						; returns (CY) = 0/1 for no error/error
	popad					; restore all general purpose registers
	ret

cpu_support_entry_01:
	stc					; (CY) = 01 for function not supported
	ret

cpu_support_entry	endp

;---------------------------------------------------------------;
;			CPU_SUPPORT_JMP_TABLE			;
;---------------------------------------------------------------;

cpu_support_jmp_table	label	word

	dw	cgroup:cpu_func_00 - cgroup:smi_code_begin + orgbase; FN# = 00 ... get general purpose register
	dw	cgroup:cpu_func_01 - cgroup:smi_code_begin + orgbase; FN# = 01 ... set general purpose register

;---------------------------------------------------------------;
;			CPU_FUNC_00				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not specified or CPU not supported
;	Register Destroyed : (EAX),(EBX),(ECX),(EDX),(ESI),(EDI);
; NOTE :							;
;	Sets up cpu_gen_purpose_reg_entry with on entry smi	;
;	values from cpu dump area for (EAX),(EBX),(ECX),(EDX),	;
;	(ESI),(EDI),(EBP) & (EFLAGS)				;
;---------------------------------------------------------------;

cpu_func_00	proc	near

	call	get_cpu_vendor			; returns (si) = cpu vendor no.
	jc	short cpu_func_00_01		; error...CPU not supported/not specified
	shl	si,1				; (si) = cpu vendor # * 2
	call	word ptr cgroup:[si+cgroup:cpu_func_00_jmp_table - cgroup:smi_code_begin + orgbase ]; execute the function
						; returns (CY) = 0/1 for no error/error
cpu_func_00_01:
	ret

cpu_func_00	endp

;---------------------------------------------------------------;
;			CPU_FUNC_00_JMP_TABLE			;
;---------------------------------------------------------------;

cpu_func_00_jmp_table	label	word

	dw	cgroup:intel_func_00 - cgroup:smi_code_begin + orgbase; INTEL CPU
	dw	cgroup:crx_func_00 - cgroup:smi_code_begin + orgbase  ; CYRIX CPU
	dw	cgroup:amd_func_00 - cgroup:smi_code_begin + orgbase  ; AMD CPU
	dw	cgroup:ibm_func_00 - cgroup:smi_code_begin + orgbase  ; IBM CPU
	dw	cgroup:ti_func_00 - cgroup:smi_code_begin + orgbase   ; TI CPU
	dw	cgroup:umc_func_00 - cgroup:smi_code_begin + orgbase   ; UMC CPU

;---------------------------------------------------------------;
;			    CPU_FUNC_01				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not specified or CPU not supported
;	Register Destroyed : (EAX),(EBX),(ECX),(EDX),(ESI),(EDI);
; NOTE :							;
;	Sets up cpu dump area for (EAX),(EBX),(ECX),(EDX),(ESI),;
;	(EDI),(EBP),(EFLAGS) with on exit smi values from cpu_	;
;	gen_purpose_reg_entry					;
;---------------------------------------------------------------;

cpu_func_01	proc	near

	call	get_cpu_vendor			; returns (si) = cpu vendor no.
	jc	short cpu_func_01_01		; error...CPU not supported/not specified
	shl	si,1				; (si) = cpu vendor # * 2
	call	word ptr cgroup:[si+cgroup:cpu_func_01_jmp_table - cgroup:smi_code_begin + orgbase]; execute the function
						; returns (CY) = 0/1 for no error/error
cpu_func_01_01:
	ret

cpu_func_01	endp

;---------------------------------------------------------------;
;			CPU_FUNC_01_JMP_TABLE			;
;---------------------------------------------------------------;

cpu_func_01_jmp_table	label	word

	dw	cgroup:intel_func_01 - cgroup:smi_code_begin + orgbase; INTEL CPU
	dw	cgroup:crx_func_01 - cgroup:smi_code_begin + orgbase  ; CYRIX CPU
	dw	cgroup:amd_func_01 - cgroup:smi_code_begin + orgbase  ; AMD CPU
	dw	cgroup:ibm_func_01 - cgroup:smi_code_begin + orgbase  ; IBM CPU
	dw	cgroup:ti_func_01 - cgroup:smi_code_begin + orgbase   ; TI CPU
	dw	cgroup:umc_func_01 - cgroup:smi_code_begin + orgbase   ; UMC CPU

;---------------------------------------------------------------;
;			GET_CPU_VENDOR				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(SI) 00 INTEL CPU				;
;		     01 CYRIX CPU				;
;		     02 AMD CPU					;
;		     03 IBM CPU					;
;		     04 TI CPU					;
;		     05 UMC CPU					;
;		(CY) 01 for CPU not specified or CPU not supported
;	Register Destroyed : (SI)				;
;---------------------------------------------------------------;

get_cpu_vendor	proc	near

	bsf	si,ds:cpu_vendor		; (si) = cpu manufacturer no.
	jz	short get_cpu_vendor_01		; no CPU manufacturer specified
	cmp	si,no_of_cpu_vendor_supported	; supported CPU vendor ?
	jae	short get_cpu_vendor_01		; no...
	clc					; (cy) = 00 for no error
	ret

get_cpu_vendor_01:
	stc					; (cy) = 01 for CPU not specified/not supported
	ret

get_cpu_vendor	endp

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
;	THIS PORTION OF CODE SUPPORTS INTEL/AMD PLUS CPU SMI	;
;---------------------------------------------------------------;
;		     'S' SERIES, 386SL/486SL			;
;			   AMD PLUS CPU				;
;---------------------------------------------------------------;

IF	INTEL_AMD_PLUS_SUPPORT

intel_cpu_smi_support_start	label	byte

;---------------------------------------------------------------;
;	    ACTUAL SMI SUPPORT FOR INTEL/AMD PLUS CPU		;
;---------------------------------------------------------------;
;		   INTEL_CPU_SMI_ENTRY_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

intel_cpu_smi_entry_ext	proc	near

	cli					; disable interrupts
	cld					; clear direction flag

;-----------------------------------------------;
;      FOLLOWING PIECE OF CODE IS REQUIRED	;
;     IF SMBASE IS RELOCATED, AS CS SELECTOR	;
;	WILL STILL CONTAIN 3000H NOT THE	;
;	      VALUE OF NEW SMBASE		;
;-----------------------------------------------;

	mov	eax,cs:cpu_dump_smbase_slot_intl; (eax) = absolute SMBASE
	shr	eax,4				; (eax) = SMBASE address selector
	mov	di,(offset cgroup:relocate_jmp_addr_intl - offset cgroup:smi_code_begin + orgbase)
	mov	cgroup:[di+03],ax		; set segment
	jmp	short relocate_jmp_addr_intl	; clear prefetch queue

relocate_jmp_addr_intl:
	db	0eah				; JMP FAR
	dw	cgroup:intel_cpu_smi_entry_ext_10 - cgroup:smi_code_begin + orgbase ; offset
	dw	0000h				; segment

;-----------------------------------------------;

intel_cpu_smi_entry_ext_10:

;-----------------------------------------------;
;     FOLLOWING CODE HAS BEEN ADDED TO TAKE	;
;     CARE OF A BUG IN INTEL PENTIUM PRO CPU	;
;     (P6). ERRATA #38 (RSM CAN NOT RETURN TO	;
;     HALT IN 32BIT OS.				;
;-----------------------------------------------;

	test	byte ptr cs:cpu_dump_halt_auto_restart_intl,00000001b; previous instruction was 'HLT' ?
	jz	short intel_cpu_smi_entry_ext_11; no...
	and	byte ptr cs:cpu_dump_halt_auto_restart_intl,11111110b; do not return to auto halt state
	dec	dword ptr cs:cpu_dump_eip_intl	; position the EIP to 'HLT' instruction
intel_cpu_smi_entry_ext_11:

;-----------------------------------------------;

	mov	ax,cs				; (ax) = data segment for SMI execution

	mov	ds,ax				; set (DS) as PM BIOS data segment
	mov	es,ax				; set (ES) as PM BIOS data segment

	mov	ss,ax				; set (SS) as PM BIOS data segment
	mov	sp,pm_bios_global_stack_ptr	; set (SP) for GLOBAL stack pointer

	mov	word ptr ds:cpu_vendor,intel_cpu_bit; set for INTEL CPU

	call	actual_smi_handler		; handle the SMI source

;---------------------------------------------------------------;
;			INTEL_CPU_SMI_EXIT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;---------------------------------------------------------------;

intel_cpu_smi_exit	proc	near

	intel_rsm				; RSM (resume from SMI)

intel_cpu_smi_exit	endp
intel_cpu_smi_entry_ext	endp

;---------------------------------------------------------------;
;			INTEL_FUNC_00				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI)				;
; NOTE :							;
;	Sets up cpu_gen_purpose_reg_entry with on entry smi	;
;	values from cpu dump area for (EAX),(EBX),(ECX),(EDX),	;
;       (ESI),(EDI),(EBP) & (EFLAGS)				;
;---------------------------------------------------------------;

intel_func_00	proc	near

	call	get_intel_gen_purpose_reg	;
	clc					; (cy) = 00 for no error
	ret

intel_func_00	endp

;---------------------------------------------------------------;
;			INTEL_FUNC_01  ROUTINE			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(SI)				;
; NOTE :							;
;	Sets up cpu dump area for (EAX),(EBX),(ECX),(EDX),(ESI),;
;	(EDI),(EBP),(EFLAGS) with on exit smi values from cpu_	;
;	gen_purpose_reg_entry					;
;---------------------------------------------------------------;

intel_func_01	proc	near

	call	set_intel_gen_purpose_reg	;
	clc					; (cy) = 00 for no error
	ret

intel_func_01	endp

;---------------------------------------------------------------;
;		GET_INTEL_GEN_PURPOSE_REG ROUTINE		;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (EAX),(DI)				;
;---------------------------------------------------------------;

get_intel_gen_purpose_reg	proc	near

	mov	di,cpu_gen_purpose_reg_entry	; (di) = pointer to on entry general purpose reg values structure

	push	es				;
	push	ds				;
	pop	es				; (ds) = (es)

	mov	eax,cs:cpu_dump_eax_intl	; (eax) = on entry (EAX)
	stosd					;
	mov	eax,cs:cpu_dump_ebx_intl	; (eax) = on entry (EBX)
	stosd					;
	mov	eax,cs:cpu_dump_ecx_intl	; (eax) = on entry (ECX)
	stosd					;
	mov	eax,cs:cpu_dump_edx_intl	; (eax) = on entry (EDX)
	stosd					;
	mov	eax,cs:cpu_dump_esi_intl	; (eax) = on entry (ESI)
	stosd					;
	mov	eax,cs:cpu_dump_edi_intl	; (eax) = on entry (EDI)
	stosd					;
	mov	eax,cs:cpu_dump_ebp_intl	; (eax) = on entry (EBP)
	stosd					;
	mov	eax,cs:cpu_dump_eflags_intl	; (eax) = on entry EFLAG
	stosd					;
	mov	eax,cs:cpu_dump_cr0_intl	; (eax) = on entry CR0
	stosd					;

	pop	es				;

	ret

get_intel_gen_purpose_reg	endp

;---------------------------------------------------------------;
;		SET_INTEL_GEN_PURPOSE_REG			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (EAX),(SI)				;
;---------------------------------------------------------------;

set_intel_gen_purpose_reg	proc	near

	mov	si,cpu_gen_purpose_reg_entry	; (si) = pointer to reg values structure on exit

	lodsd					; (eax) = on exit (EAX)
	mov	cs:cpu_dump_eax_intl,eax	;
	lodsd					; (eax) = on exit (EBX)
	mov	cs:cpu_dump_ebx_intl,eax	;
	lodsd					; (eax) = on exit (ECX)
	mov	cs:cpu_dump_ecx_intl,eax	;
	lodsd					; (eax) = on exit (EDX)
	mov	cs:cpu_dump_edx_intl,eax	;
	lodsd					; (eax) = on exit (ESI)
	mov	cs:cpu_dump_esi_intl,eax	;
	lodsd					; (eax) = on exit (EDI)
	mov	cs:cpu_dump_edi_intl,eax	;
	lodsd					; (eax) = on exit (EBP)
	mov	cs:cpu_dump_ebp_intl,eax	;
	lodsd					; (eax) = on exit EFLAG
	mov	cs:cpu_dump_eflags_intl,eax	;
	ret

set_intel_gen_purpose_reg	endp

;---------------------------------------------------------------;
;		    INTEL_AMD_PLUS_RELOCATION			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : (EAX)				;
;---------------------------------------------------------------;

intel_amd_plus_relocation	proc	near

	mov	ax,cs:smi_code_seg_intel_amd_plus_cseg; (ax) = SMI code segment selector
	cmp	dword ptr cs:smi_seg_size_cseg,8000h; is 32KB SMRAM ?
	ja	short intel_amd_plus_relocation_01; no...64KB or greater SMRAM
	sub	ax,800h				; change it to 64KB form
intel_amd_plus_relocation_01:
	movzx	eax,ax				;
	shl	eax,4				; (eax) = absolute address
	mov	cs:cpu_dump_smbase_slot_intl,eax; change SMBASE
	ret

intel_amd_plus_relocation	endp

;---------------------------------------------------------------;

intel_cpu_smi_support_end	label	byte

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

intel_cpu_dummy_smi_support_start	label	byte

;---------------------------------------------------------------;
;	    DUMMY SMI SUPPORT FOR INTEL/AMD PLUS CPU		;
;---------------------------------------------------------------;
;		   INTEL_CPU_SMI_ENTRY_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

intel_cpu_smi_entry_ext	proc	near

;---------------------------------------------------------------;
;			INTEL_CPU_SMI_EXIT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;---------------------------------------------------------------;

intel_cpu_smi_exit	proc	near

	intel_rsm				; RSM (resume from SMI)

intel_cpu_smi_exit	endp
intel_cpu_smi_entry_ext	endp

;---------------------------------------------------------------;
;			INTEL_FUNC_00				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI),(SI)			;
; NOTE :							;
;	Sets up cpu_gen_purpose_reg_entry with on entry smi	;
;	values from cpu dump area for (EAX),(EBX),(ECX),(EDX),	;
;       (ESI),(EDI),(EBP) & (EFLAGS)				;
;---------------------------------------------------------------;

intel_func_00	proc	near

;---------------------------------------------------------------;
;			INTEL_FUNC_01  ROUTINE			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI)				;
; NOTE :							;
;	Sets up cpu dump area for (EAX),(EBX),(ECX),(EDX),(ESI),;
;	(EDI),(EBP),(EFLAGS) with on exit smi values from cpu_	;
;	gen_purpose_reg_entry					;
;---------------------------------------------------------------;

intel_func_01	proc	near

	stc					; (cy) = 01 for function not supported
	ret

intel_func_01	endp
intel_func_00	endp

;---------------------------------------------------------------;
;		    INTEL_AMD_PLUS_RELOCATION			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : (EAX),(DI)				;
;---------------------------------------------------------------;

intel_amd_plus_relocation	proc	near

	ret

intel_amd_plus_relocation	endp

;---------------------------------------------------------------;

intel_cpu_dummy_smi_support_end	label	byte

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
;   THIS PORTION OF CODE SUPPORTS AMD non-PLUS/IBM/UMC CPU SMI	;
;---------------------------------------------------------------;
;		  Am386SXLV/Am386DXLV/Am486DXLV			;
;		 IBM486SLC2,BLUE LIGHTNING,386SLC		;
;			UMC U5 CPU				;
;---------------------------------------------------------------;

IF	AMD_NON_PLUS_IBM_SUPPORT

amd_ibm_cpu_smi_support_start	label	byte

;---------------------------------------------------------------;
;       ACTUAL SMI SUPPORT FOR AMD non-PLUS/IBM/UMC CPU		;
;---------------------------------------------------------------;
;			AMD_CPU_SMI_ENTRY_EXT			;
;			IBM_CPU_SMI_ENTRY_EXT			;
;			UMC_CPU_SMI_ENTRY_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

amd_cpu_smi_entry_ext	proc	near
ibm_cpu_smi_entry_ext	proc	near
umc_cpu_smi_entry_ext	proc	near

	cli					; disable interrupts
	cld					; clear direction flag

	mov	ax,cs				; (ax) = data segment for SMI execution

	mov	ds,ax				; set (DS) as PM BIOS data segment
	mov	es,ax				; set (ES) as PM BIOS data segment

	mov	ss,ax				; set (SS) as PM BIOS data segment
	mov	sp,pm_bios_global_stack_ptr	; set (SP) for GLOBAL stack pointer

	mov	word ptr ds:cpu_vendor,amd_cpu_bit or ibm_cpu_bit or umc_cpu_bit; set for AMD non-PLUS/IBM/UMC CPU

	test	byte ptr ds:bios_detected_cpu_mfr,ibm_cpu_bit; IBM cpu ?
	jz	short amd_cpu_smi_entry_ext_01	; no...
	cache_wbinvd				; flush & invalidate cache
amd_cpu_smi_entry_ext_01:

	call	actual_smi_handler		; handle the SMI source

;---------------------------------------------------------------;
;			AMD_CPU_SMI_EXIT			;
;			IBM_CPU_SMI_EXIT			;
;			UMC_CPU_SMI_EXIT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;---------------------------------------------------------------;

amd_cpu_smi_exit	proc	near
ibm_cpu_smi_exit	proc	near
umc_cpu_smi_exit	proc	near

	and	dword ptr cs:cpu_dump_dr6_amd_ibm,0ffffefffh; clear SMMS bit
	and	dword ptr cs:cpu_dump_dr7_amd_ibm,0ffffefffh; clear soft SMI enable (SMIE) bit as AMD CPU always sets this bit while entering SMI

	mov	ax,cs				; (ax) = (cs)
	mov	es,ax				; (es) = SMI segment
	xor	edi,edi				; (edi) = set at beginning of CPU save area
	amd_res3				; RES3 (resume from SMI)

umc_cpu_smi_exit	endp
ibm_cpu_smi_exit	endp
amd_cpu_smi_exit	endp
umc_cpu_smi_entry_ext	endp
ibm_cpu_smi_entry_ext	endp
amd_cpu_smi_entry_ext	endp

;---------------------------------------------------------------;
;			   AMD_FUNC_00				;
;			   IBM_FUNC_00				;
;			   UMC_FUNC_00				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;	
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI)				;
; NOTE :							;
;	Sets up cpu_gen_purpose_reg_entry with on entry	smi	;
;	values from cpu dump area for (EAX),(EBX),(ECX),(EDX),	;
;	(ESI),(EDI),(EBP) & (EFLAGS)				;
; NOTE :							;
;	Common routine for amd/ibm/umc cpu			;
;---------------------------------------------------------------;

amd_func_00	proc	near
ibm_func_00	proc	near
umc_func_00	proc	near

	call	get_amd_ibm_gen_purpose_reg	;
	clc					; (cy) = 00 for no error
	ret

umc_func_00	endp
ibm_func_00	endp
amd_func_00	endp

;---------------------------------------------------------------;
;			    AMD_FUNC_01				;
;			    IBM_FUNC_01				;
;			    UMC_FUNC_01				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(SI)				;
; NOTE :							;
;	Sets up cpu dump area for (EAX),(EBX),(ECX),(EDX),(ESI),;
;	(EDI),(EBP),(EFLAGS) with on exit smi values from cpu_	;
;	gen_purpose_reg_entry					;
; NOTE :							;
;	Common routine for amd/ibm/umc cpu			;
;---------------------------------------------------------------;

amd_func_01	proc	near
ibm_func_01	proc	near
umc_func_01	proc	near

	call	set_amd_ibm_gen_purpose_reg	;
	clc					; (cy) = 00 for no error
	ret

umc_func_01	endp
ibm_func_01	endp
amd_func_01	endp

;---------------------------------------------------------------;
;		GET_AMD_IBM_GEN_PURPOSE_REG			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (EAX),(DI),(SI)			;
; NOTE :							;
;	Common routine for amd/ibm/umc cpu			;
;---------------------------------------------------------------;

get_amd_ibm_gen_purpose_reg	proc	near

	mov	di,cpu_gen_purpose_reg_entry	; (di) = pointer to on entry general purpose reg values structure

	push	es				;
	push	ds				;
	pop	es				; (ds) = (es)

	mov	eax,cs:cpu_dump_eax_amd_ibm	; (eax) = on entry (EAX)
	stosd					;
	mov	eax,cs:cpu_dump_ebx_amd_ibm	; (eax) = on entry (EBX)
	stosd					;
	mov	eax,cs:cpu_dump_ecx_amd_ibm	; (eax) = on entry (ECX)
	stosd					;
	mov	eax,cs:cpu_dump_edx_amd_ibm	; (eax) = on entry (EDX)
	stosd					;
	mov	eax,cs:cpu_dump_esi_amd_ibm	; (eax) = on entry (ESI)
	stosd					;
	mov	eax,cs:cpu_dump_edi_amd_ibm	; (eax) = on entry (EDI)
	stosd					;
	mov	eax,cs:cpu_dump_ebp_amd_ibm	; (eax) = on entry (EBP)
	stosd					;
	mov	eax,cs:cpu_dump_eflags_amd_ibm	; (eax) = on entry EFLAG
	stosd					;
	mov	eax,cs:cpu_dump_cr0_amd_ibm	; (eax) = on entry CR0
	stosd					;

	pop	es				;

	ret

get_amd_ibm_gen_purpose_reg	endp

;---------------------------------------------------------------;
;		   SET_AMD_IBM_GEN_PURPOSE_REG			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (EAX),(SI)				;
; NOTE :							;
;	Common routine for amd/ibm/umc cpu			;
;---------------------------------------------------------------;

set_amd_ibm_gen_purpose_reg	proc	near

	mov	si,cpu_gen_purpose_reg_entry	; (di) = pointer to reg values structure on exit

	lodsd					; (eax) = on exit (EAX)
	mov	cs:cpu_dump_eax_amd_ibm,eax	;
	lodsd					; (eax) = on exit (EBX)
	mov	cs:cpu_dump_ebx_amd_ibm,eax	;
	lodsd					; (eax) = on exit (ECX)
	mov	cs:cpu_dump_ecx_amd_ibm,eax	;
	lodsd					; (eax) = on exit (EDX)
	mov	cs:cpu_dump_edx_amd_ibm,eax	;
	lodsd					; (eax) = on exit (ESI)
	mov	cs:cpu_dump_esi_amd_ibm,eax	;
	lodsd					; (eax) = on exit (EDI)
	mov	cs:cpu_dump_edi_amd_ibm,eax	;
	lodsd					; (eax) = on exit (EBP)
	mov	cs:cpu_dump_ebp_amd_ibm,eax	;
	lodsd					; (eax) = on exit EFLAG
	mov	cs:cpu_dump_eflags_amd_ibm,eax
	ret

set_amd_ibm_gen_purpose_reg	endp

;---------------------------------------------------------------;

amd_ibm_cpu_smi_support_end	label	byte

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

amd_ibm_cpu_dummy_smi_support_start	label	byte

;---------------------------------------------------------------;
;	   DUMMY SMI SUPPORT FOR AMD non-PLUS/IBM/UMC CPU	;
;---------------------------------------------------------------;
;			AMD_CPU_SMI_ENTRY_EXT			;
;			IBM_CPU_SMI_ENTRY_EXT			;
;			UMC_CPU_SMI_ENTRY_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

amd_cpu_smi_entry_ext	proc	near
ibm_cpu_smi_entry_ext	proc	near
umc_cpu_smi_entry_ext	proc	near

;---------------------------------------------------------------;
;			AMD_CPU_SMI_EXIT			;
;			IBM_CPU_SMI_EXIT			;
;			UMC_CPU_SMI_EXIT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;---------------------------------------------------------------;

amd_cpu_smi_exit	proc	near
ibm_cpu_smi_exit	proc	near
umc_cpu_smi_exit	proc	near

	and	dword ptr cs:cpu_dump_dr6_amd_ibm,0ffffefffh; clear SMMS bit
	and	dword ptr cs:cpu_dump_dr7_amd_ibm,0ffffefffh; clear soft SMI enable (SMIE) bit as AMD CPU always sets this bit while entering SMI

	mov	ax,cs				; (ax) = (cs)
	mov	es,ax				; (es) = SMI segment
	xor	edi,edi				; (edi) = set at beginning of CPU save area
	amd_res3				; RES3 (resume from SMI)

umc_cpu_smi_exit	endp
ibm_cpu_smi_exit	endp
amd_cpu_smi_exit	endp
umc_cpu_smi_entry_ext	endp
ibm_cpu_smi_entry_ext	endp
amd_cpu_smi_entry_ext	endp

;---------------------------------------------------------------;
;			   AMD_FUNC_00				;
;			   IBM_FUNC_00				;
;			   UMC_FUNC_00				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;	
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI),(SI)			;
; NOTE :							;
;	Sets up cpu_gen_purpose_reg_entry with on entry	smi	;
;	values from cpu dump area for (EAX),(EBX),(ECX),(EDX),	;
;	(ESI),(EDI),(EBP) & (EFLAGS)				;
; NOTE :							;
;	Common routine for amd/ibm/umc cpu			;
;---------------------------------------------------------------;

amd_func_00	proc	near
ibm_func_00	proc	near
umc_func_00	proc	near

;---------------------------------------------------------------;
;			    AMD_FUNC_01				;
;			    IBM_FUNC_01				;
;			    UMC_FUNC_01				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI)				;
; NOTE :							;
;	Sets up cpu dump area for (EAX),(EBX),(ECX),(EDX),(ESI),;
;	(EDI),(EBP),(EFLAGS) with on exit smi values from cpu_	;
;	gen_purpose_reg_entry					;
; NOTE :							;
;	Common routine for amd/ibm/umc cpu			;
;---------------------------------------------------------------;

amd_func_01	proc	near
ibm_func_01	proc	near
umc_func_01	proc	near

	stc					; (cy) = 01 for function not supported
	ret

umc_func_01	endp
ibm_func_01	endp
amd_func_01	endp
umc_func_00	endp
ibm_func_00	endp
amd_func_00	endp

;---------------------------------------------------------------;

amd_ibm_cpu_dummy_smi_support_end	label	byte

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
;	  THIS PORTION OF CODE SUPPORTS CYRIX/TI CPU SMI	;
;---------------------------------------------------------------;
;	     Cx486SLCe,Cx486SLC2e,Cx486DLCe,Cx486DLC2e		;
;		Cx486Se,Cx486S2e,Cx486DX,Cx486DX2		;
;		 TI POTOMAC TI486SLCe,TI486SLC2e		;
;		 TI POTOMAC TI486DLCe,TI486DLC2e		;
;		     TI 486SXLCe,TI 486SXLC2e			;
;		      TI 486SXLe,TI 486SXL2e			;
;---------------------------------------------------------------;

IF	CYRIX_TI_SUPPORT

crx_ti_cpu_smi_support_start	label	byte

;---------------------------------------------------------------;
;	       ACTUAL SMI SUPPORT FOR CYRIX/TI CPU		;
;---------------------------------------------------------------;
;		TEMPORARY DESCRIPTOR STRUCTURE			;
;---------------------------------------------------------------;

;struc_temp_desc_crx_ti	struc

seg_limit_low_crx_ti	equ	00h			; 1 word..segment limit (low)
seg_base_low_crx_ti	equ	seg_limit_low_crx_ti+02h; 1 word..segment base (low)
seg_base_middle_crx_ti	equ	seg_base_low_crx_ti+02h ; 1 byte..segment base (middle)
seg_attribute_crx_ti	equ	seg_base_middle_crx_ti+01h; 1 byte..attribute
seg_limit_high_crx_ti	equ	seg_attribute_crx_ti+01h; 1 byte..segment limit (high) & attribute
seg_base_high_crx_ti	equ	seg_limit_high_crx_ti+01h; 1 byte..segment base (high)
seg_selector_crx_ti	equ	seg_base_high_crx_ti+01h; 1 word..segment selector

;struc_temp_desc_crx_ti	ends

;---------------------------------------------------------------;

;temp_desc_crx_ti	struc_temp_desc_crx_ti <0ffffh,0000h,00h,93h,30h,00h,0000h>
						; set for 64KB limit

temp_desc_crx_ti	dw	0ffffh		; segment limit (low)
			dw	00000h		; segment base (low)
			db	000h		; segment base (middle)
			db	093h		; attribute
;			db	030h		; segment limit (high) & attribute
			db	0bfh
			db	000h		; segment base (high)
			dw	00000h		; segment selector

;---------------------------------------------------------------;
;		    CRX_CPU_SMI_ENTRY_EXT			;
;		     TI_CPU_SMI_ENTRY_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

crx_cpu_smi_entry_ext	proc	near
ti_cpu_smi_entry_ext	proc	near

	cli					; disable interrupts
	cld					; clear direction flag

	mov	cs:temp_cpu_dump_eax_crx_ti,eax	; save (EAX) in temporary dump area
	mov	cs:temp_cpu_dump_ebx_crx_ti,ebx	; save (EBX) in temporary dump area
	mov	cs:temp_cpu_dump_ecx_crx_ti,ecx	; save (ECX) in temporary dump area
	mov	cs:temp_cpu_dump_edx_crx_ti,edx	; save (EDX) in temporary dump area
	mov	cs:temp_cpu_dump_esi_crx_ti,esi	; save (ESI) in temporary dump area
	mov	cs:temp_cpu_dump_edi_crx_ti,edi	; save (EDI) in temporary dump area
	mov	cs:temp_cpu_dump_ebp_crx_ti,ebp	; save (EBP) in temporary dump area
	mov	cs:temp_cpu_dump_esp_crx_ti,esp	; save (ESP) in temporary dump area

	ds_svdc_cseg	temp_cpu_dump_ds_desc_low_crx_ti ; save (DS & DS DESCRIPTOR) in temporary dump area
	es_svdc_cseg	temp_cpu_dump_es_desc_low_crx_ti ; save (ES & ES DESCRIPTOR) in temporary dump area
	ss_svdc_cseg	temp_cpu_dump_ss_desc_low_crx_ti ; save (SS & SS DESCRIPTOR) in temporary dump area

	sgdt	fword ptr cs:temp_cpu_dump_gdt_desc_low_crx_ti ; save (GDT) descriptor temporarily
	sidt	fword ptr cs:temp_cpu_dump_idt_desc_low_crx_ti ; save (IDT) descriptor temporarily

;-----------------------------------------------;

	mov	ax,cs				; (ax) = data segment for SMI execution

;-----------------------------------------------;

	mov	di,(offset cgroup:temp_desc_crx_ti - offset cgroup:smi_code_begin + orgbase); (di) = temporary descriptor
	movzx	eax,ax				; (eax) = PM BIOS data segment
	mov	cgroup:[di+seg_selector_crx_ti],ax; set selector
	shl	eax,4				; (eax) = PM BIOS data segment (absolute)
	mov	cgroup:[di+seg_base_low_crx_ti],ax; set segment base (low)
	shr	eax,16				;
	mov	cgroup:[di+seg_base_middle_crx_ti],al; set segment base (middle)

;-----------------------------------------------;

temp_desc_crx_ti_relocate	equ	temp_desc_crx_ti - smi_code_begin + orgbase

	ds_rsdc_cseg	temp_desc_crx_ti_relocate; set (DS) as PM BIOS data segment
	es_rsdc_cseg	temp_desc_crx_ti_relocate; set (ES) as PM BIOS data segment
	ss_rsdc_cseg	temp_desc_crx_ti_relocate; set (SS) as PM BIOS data segment

;-----------------------------------------------;

	mov	ax,cs				; (ax) = PM BIOS data segment
	mov	ds,ax				; set (DS) as PM BIOS data segment
	mov	es,ax				; set (ES) as PM BIOS data segment

	mov	ss,ax				; set (SS) as PM BIOS data segment
	mov	sp,pm_bios_global_stack_ptr	; set (SP) for GLOBAL stack pointer

	mov	word ptr ds:cpu_vendor,cyrix_cpu_bit or ti_cpu_bit; set for CYRIX CPU/TI CPU

;-----------------------------------------------;

	mov	dword ptr ds:smi_idt_descriptor,000003ffh
	mov	dword ptr ds:smi_idt_descriptor+4,00000000h
	lidt	fword ptr ds:smi_idt_descriptor	;

;-----------------------------------------------;

	call	actual_smi_handler		; handle the SMI source

;---------------------------------------------------------------;
;		     CRX_CPU_SMI_EXIT				;
;		      TI_CPU_SMI_EXIT				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;---------------------------------------------------------------;

crx_cpu_smi_exit	proc	near
ti_cpu_smi_exit	proc	near

	mov	eax,cs:temp_cpu_dump_eax_crx_ti	; restore (EAX)
	mov	ebx,cs:temp_cpu_dump_ebx_crx_ti	; restore (EBX)
	mov	ecx,cs:temp_cpu_dump_ecx_crx_ti	; restore (ECX)
	mov	edx,cs:temp_cpu_dump_edx_crx_ti	; restore (EDX)
	mov	esi,cs:temp_cpu_dump_esi_crx_ti	; restore (ESI)
	mov	edi,cs:temp_cpu_dump_edi_crx_ti	; restore (EDI)
	mov	ebp,cs:temp_cpu_dump_ebp_crx_ti	; restore (EBP)
	mov	esp,cs:temp_cpu_dump_esp_crx_ti	; restore (ESP)

	ds_rsdc_cseg	temp_cpu_dump_ds_desc_low_crx_ti ; restore (DS & DS DESCRIPTOR) from temporary dump area
	es_rsdc_cseg	temp_cpu_dump_es_desc_low_crx_ti ; restore (ES & ES DESCRIPTOR) from temporary dump area
	ss_rsdc_cseg	temp_cpu_dump_ss_desc_low_crx_ti ; restore (SS & SS DESCRIPTOR) from temporary dump area

	db	066h				; USE 32 BIT OPERAND for LGDT
	lgdt	fword ptr cs:temp_cpu_dump_gdt_desc_low_crx_ti ; restore (GDT) descriptor temporarily
	db	066h				; USE 32 BIT OPERAND for LIDT
	lidt	fword ptr cs:temp_cpu_dump_idt_desc_low_crx_ti ; restore (IDT) descriptor temporarily

;-----------------------------------------------;

	crx_rsm					; RSM (resume from SMI)

ti_cpu_smi_exit	endp
crx_cpu_smi_exit	endp
ti_cpu_smi_entry_ext	endp
crx_cpu_smi_entry_ext	endp

;---------------------------------------------------------------;
;			  CRX_FUNC_00				;
;			   TI_FUNC_00				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI)				;
; NOTE :							;
;	Sets up cpu_gen_purpose_reg_entry with on entry smi	;
;	values from cpu dump area for (EAX),(EBX),(ECX),(EDX),	;
;	(ESI),(EDI),(EBP) & (EFLAGS)				;
; NOTE :							;
;	Common routine for cyrix/ti cpu				;
;---------------------------------------------------------------;

crx_func_00	proc	near
ti_func_00	proc	near

	call	get_crx_ti_gen_purpose_reg	;
	clc					; (cy) = 00 for no error
	ret

ti_func_00	endp
crx_func_00	endp

;---------------------------------------------------------------;
;			  CRX_FUNC_01				;
;			   TI_FUNC_01				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(SI)				;
; NOTE :							;
;	Sets up cpu dump area for (EAX),(EBX),(ECX),(EDX),(ESI),;
;	(EDI),(EBP),(EFLAGS) with on exit smi values from cpu_	;
;	gen_purpose_reg_entry					;
; NOTE :							;
;	Common routine for cyrix/ti cpu				;
;---------------------------------------------------------------;

crx_func_01	proc	near
ti_func_01	proc	near

	call	set_crx_ti_gen_purpose_reg	;
	clc					; (cy) = 00 for no error
	ret

ti_func_01	endp
crx_func_01	endp

;---------------------------------------------------------------;
;		  GET_CRX_TI_GEN_PURPOSE_REG			;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (EAX),(DI)				;
; NOTE :							;
;	Common routine for cyrix/ti cpu				;
;---------------------------------------------------------------;

get_crx_ti_gen_purpose_reg	proc	near

	mov	di,cpu_gen_purpose_reg_entry	; (di) = pointer to on entry general purpose reg values structure

	push	es				;
	push	ds				;
	pop	es				; (ds) = (es)

	mov	eax,cs:temp_cpu_dump_eax_crx_ti	; (eax) = on entry (EAX)
	stosd					;
	mov	eax,cs:temp_cpu_dump_ebx_crx_ti	; (eax) = on entry (EBX)
	stosd					;
	mov	eax,cs:temp_cpu_dump_ecx_crx_ti	; (eax) = on entry (ECX)
	stosd					;
	mov	eax,cs:temp_cpu_dump_edx_crx_ti	; (eax) = on entry (EDX)
	stosd					;
	mov	eax,cs:temp_cpu_dump_esi_crx_ti	; (eax) = on entry (ESI)
	stosd					;
	mov	eax,cs:temp_cpu_dump_edi_crx_ti	; (eax) = on entry (EDI)
	stosd					;
	mov	eax,cs:temp_cpu_dump_ebp_crx_ti	; (eax) = on entry (EBP)
	stosd					;
	mov	eax,cs:cpu_dump_eflags_crx_ti	; (eax) = on entry EFLAG
	stosd					;
	mov	eax,cs:cpu_dump_cr0_crx_ti	; (eax) = on entry CR0
	stosd					;

	pop	es				;

	ret

get_crx_ti_gen_purpose_reg	endp

;---------------------------------------------------------------;
;		SET_CRX_TI_GEN_PURPOSE_REG			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (EAX),(SI)				;
; NOTE :							;
;	Common routine for cyrix/ti cpu				;
;---------------------------------------------------------------;

set_crx_ti_gen_purpose_reg	proc	near

	mov	si,cpu_gen_purpose_reg_entry	; (di) = pointer to reg values structure on exit

	lodsd					; (eax) = on exit (EAX)
	mov	cs:temp_cpu_dump_eax_crx_ti,eax	; save temporarily in dump area
	lodsd					; (eax) = on exit (EBX)
	mov	cs:temp_cpu_dump_ebx_crx_ti,eax	; save temporarily in dump area
	lodsd					; (eax) = on exit (ECX)
	mov	cs:temp_cpu_dump_ecx_crx_ti,eax	; save temporarily in dump area
	lodsd					; (eax) = on exit (EDX)
	mov	cs:temp_cpu_dump_edx_crx_ti,eax	; save temporarily in dump area
	lodsd					; (eax) = on exit (ESI)
	mov	cs:temp_cpu_dump_esi_crx_ti,eax	; save temporarily in dump area
	lodsd					; (eax) = on exit (EDI)
	mov	cs:temp_cpu_dump_edi_crx_ti,eax	; save temporarily in dump area
	lodsd					; (eax) = on exit (EBP)
	mov	cs:temp_cpu_dump_ebp_crx_ti,eax	; save temporarily in dump area
	lodsd					; (eax) = on exit EFLAG
	mov	cs:cpu_dump_eflags_crx_ti,eax	;
	ret

set_crx_ti_gen_purpose_reg	endp

;---------------------------------------------------------------;

crx_ti_cpu_smi_support_end	label	byte

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

crx_ti_cpu_dummy_smi_support_start	label	byte

;---------------------------------------------------------------;
;		DUMMY SMI SUPPORT FOR CYRIX/TI CPU		;
;---------------------------------------------------------------;
;		    CRX_CPU_SMI_ENTRY_EXT			;
;		     TI_CPU_SMI_ENTRY_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

crx_cpu_smi_entry_ext	proc	near
ti_cpu_smi_entry_ext	proc	near

;---------------------------------------------------------------;
;		     CRX_CPU_SMI_EXIT				;
;		      TI_CPU_SMI_EXIT				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;---------------------------------------------------------------;

crx_cpu_smi_exit	proc	near
ti_cpu_smi_exit	proc	near

	crx_rsm					; RSM (resume from SMI)

ti_cpu_smi_exit	endp
crx_cpu_smi_exit	endp
ti_cpu_smi_entry_ext	endp
crx_cpu_smi_entry_ext	endp

;---------------------------------------------------------------;
;			  CRX_FUNC_00				;
;			   TI_FUNC_00				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI),(SI)			;
; NOTE :							;
;	Sets up cpu_gen_purpose_reg_entry with on entry smi	;
;	values from cpu dump area for (EAX),(EBX),(ECX),(EDX),	;
;	(ESI),(EDI),(EBP) & (EFLAGS)				;
; NOTE :							;
;	Common routine for cyrix/ti cpu				;
;---------------------------------------------------------------;

crx_func_00	proc	near
ti_func_00	proc	near

;---------------------------------------------------------------;
;			  CRX_FUNC_01				;
;			   TI_FUNC_01				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for CPU not supported			;
;	Register destroyed : (EAX),(DI)				;
; NOTE :							;
;	Sets up cpu dump area for (EAX),(EBX),(ECX),(EDX),(ESI),;
;	(EDI),(EBP),(EFLAGS) with on exit smi values from cpu_	;
;	gen_purpose_reg_entry					;
; NOTE :							;
;	Common routine for cyrix/ti cpu				;
;---------------------------------------------------------------;

crx_func_01	proc	near
ti_func_01	proc	near

	stc					; (cy) = 01 for function not supported
	ret

ti_func_01	endp
crx_func_01	endp
ti_func_00	endp
crx_func_00	endp

;---------------------------------------------------------------;

crx_ti_cpu_dummy_smi_support_end	label	byte

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
