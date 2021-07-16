Subttl.	Include file for GREEN PC support INIT code...GPMINIT.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

	public	init_smram			;
	public	init_smram_early_post		;

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
;	    POST TIME CORE BIOS SMI/IRQ HANDLER CODE		;
;	    POST TIME CORE BIOS SMI/IRQ HANDLER CODE		;
;	    POST TIME CORE BIOS SMI/IRQ HANDLER CODE		;
;	    POST TIME CORE BIOS SMI/IRQ HANDLER CODE		;
;---------------------------------------------------------------;
;			INIT_SMRAM_EARLY_POST			;
;---------------------------------------------------------------;
;	Input :	(CS) SMI code source segment			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : NONE				;
; NOTE :							;
;  *  Control comes here to initialize smram with the smi handler
;     during early post for USB etc.				;
;  *  In this routine (BL) is used to keep different info at	;
;     different point of time....				;
;	(BL) bit 0 0 means 64KB or greater SMRAM		;
;		   1 means 32KB SMRAM				;
;	     bit 1 0 means init_smram_early_post not done	;
;		   1 means init_smram_early_post done		;
;	     bit 1 0 means smbase relocation not required	;
;		   1 means smbase relocation is required	;
;	     bit 3  bit 2					;
;	       0      0   ... INTEL type SMI			;
;	       0      1   ... CYRIX type SMI			;
;	       1      0   ... AMD type SMI			;
;	       1      1   ... reserved				;
;	     bit 4 set for dual/multiple CPU present		;
;	     bit 4 clear for single CPU				;
;	     bit 5 set for IRQ based power management		;
;	     bit 5 clear for SMI based power management		;
;	     bit 6 set for SMI capable CPU			;
;	     bit 6 clear for non-SMI CPU			;
;	     bit 7 0 means smi init called during late post	;
;		   1 means smi init called during early post	;
;	     bit 7 0 means smi post was successful		;
;		   1 means smi post was unsuccessful		;
;  *  This routine is called from the main bios	hook in early	;
;     post to make USB kb/mouse device available.		;
;  *  It is assumed all SMI sources are disabled at this point	;
;---------------------------------------------------------------;

init_smram_early_post	proc	near

	push	ax				;
	mov	al,smi_init_early_post		; bit 7 1 to identify early post SMRAM initialization for USB etc.
	call	init_smram_local		;
	jc	short init_smram_early_post_00	; error...

	push	ds				;
	push	bios_data_seg			;
	pop	ds				; (ds) = bios standard data segment (40H)
	or	bda_apm_state,early_post_init_smram_done; set bit 1
	pop	ds				;

init_smram_early_post_00:
	pop	ax				;
	ret

init_smram_early_post	endp

;---------------------------------------------------------------;
;			     INIT_SMRAM				;
;---------------------------------------------------------------;
;	Input :	(CS) SMI code source segment			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : NONE				;
; NOTE :							;
;  *  Control comes here to initialize smram with the smi handler
;  *  In this routine (BL) is used to keep different info at	;
;     different point of time....				;
;	(BL) bit 0 0 means 64KB or greater SMRAM		;
;		   1 means 32KB SMRAM				;
;	     bit 1 0 means init_smram_early_post not done	;
;		   1 means init_smram_early_post done		;
;	     bit 1 0 means smbase relocation not required	;
;		   1 means smbase relocation is required	;
;	     bit 3  bit 2					;
;	       0      0   ... INTEL type SMI			;
;	       0      1   ... CYRIX type SMI			;
;	       1      0   ... AMD type SMI			;
;	       1      1   ... reserved				;
;	     bit 4 set for dual/multiple CPU present		;
;	     bit 4 clear for single CPU				;
;	     bit 5 set for IRQ based power management		;
;	     bit 5 clear for SMI based power management		;
;	     bit 6 set for SMI capable CPU			;
;	     bit 6 clear for non-SMI CPU			;
;	     bit 7 0 means smi init called during late post	;
;		   1 means smi init called during early post	;
;	     bit 7 0 means smi post was successful		;
;		   1 means smi post was unsuccessful		;
;  *  This routine is called from the main bios	hook 'SPECIAL_	;
;     CONFIG_DISPLAY' at check point 0AAh			;
;  *  It is assumed all SMI sources are disabled at this point	;
;---------------------------------------------------------------;

init_smram	proc	near

	push	ax				;
	mov	al,00000000b			; bit 7 0 to identify normal SMRAM initialization
	call	init_smram_local		;
	pop	ax				;
	ret

init_smram	endp

;---------------------------------------------------------------;
;			INIT_SMRAM_LOCAL			;
;---------------------------------------------------------------;
;	Input :	(CS) SMI code source segment			;
;		(AL) bit 0 set...called during early post	;
;		     bit 0 clear...called during late post	;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : NONE				;
; NOTE :							;
;  *  Control comes here to initialize smram with the smi handler
;  *  In this routine (BL) is used to keep different info at	;
;     different point of time....				;
;	(BL) bit 0 0 means 64KB or greater SMRAM		;
;		   1 means 32KB SMRAM				;
;	     bit 1 0 means init_smram_early_post not done	;
;		   1 means init_smram_early_post done		;
;	     bit 1 0 means smbase relocation not required	;
;		   1 means smbase relocation is required	;
;	     bit 3  bit 2					;
;	       0      0   ... INTEL type SMI			;
;	       0      1   ... CYRIX type SMI			;
;	       1      0   ... AMD type SMI			;
;	       1      1   ... reserved				;
;	     bit 4 set for dual/multiple CPU present		;
;	     bit 4 clear for single CPU				;
;	     bit 5 set for IRQ based power management		;
;	     bit 5 clear for SMI based power management		;
;	     bit 6 set for SMI capable CPU			;
;	     bit 6 clear for non-SMI CPU			;
;	     bit 7 0 means smi init called during late post	;
;		   1 means smi init called during early post	;
;	     bit 7 0 means smi post was successful		;
;		   1 means smi post was unsuccessful		;
;  *  It is assumed all SMI sources are disabled at this point	;
;---------------------------------------------------------------;

init_smram_local	proc	near

	pushad					;
	push	ds				;
	push	es				;
	push	ax				; save early/late post info in bit 7 of (AL)

	cld					; clear direction flag
	call	get_cpu_id_local		; returns (dx:ax) pointer to ASCIIZ cpu name string
						; (cl) cpu number, (bx) function field
	push	bx				; save function field
	call	get_vendor_name_local		; (bl) = cpu vendor number
	mov	ch,bl				; (ch) = cpu vendor number, (cl) = cpu number
	pop	bx				; (bl) bit 7 SMI support info
						; (bh) bit 6 & 5 has SMI type support info for 10/10/94 and above CORE BIOS
	pop	ax				; restore early/late post info in bit 7 of (AL)
	cmp	ch,0ffh				; unknown CPU vendor ?
	jz	short init_smram_00		; exit...can not support power management

	call	set_smi_type			; set/reset bit 2 & 3 of (bh) for proper SMI type (INTEL/CYRIX/AMD)
						; set/reset bit 6 of (bh) for SMI/non-SMI CPU
						; all other bits of (bh) will be reset to 0
						; DOES NOT DESTROY (AL)

	or	bh,al				; set early/late post info in bit 7
	call	get_dual_cpu_info		; set/reset bit 4 of (bh) for dual cpu present/absent
						; setup bits 3 thru 0 of (bl) according to # of secondary CPU

	call	select_pm_method		; CHIPSET HOOK HOOK HOOK...returns (al) = 0/1/2/3
	call	save_pm_method			; save power management method in global data area
;if (MKF_SOFT_OFF)
	jmp	short init_smram_50		; yes...
;else
;	cmp	al,1				; use SMI based power management ?
;	jz	short init_smram_50		; yes...
;endif
;-----------------------------------------------;

init_smram_40:
	cmp	al,3				; IRQ based power management ?
	jz	short init_irq_pm		; yes...
	cmp	al,2				; hardware automatic power management ?
	jnz	short init_smram_00		; no...disable power management

;-----------------------------------------------;

init_hw_auto_pm:
	call	setup_hw_auto_pm		; CHIPSET HOOK HOOK HOOK...setup for automatic hardawre power management
	jmp	init_smram_08			;

;-----------------------------------------------;

init_irq_pm:

IF	IRQ_HANDLING_SUPPORT
	or	bh,irq_power_management		; set for IRQ based power management
	shl	ah,4				; (ah) = get IRQ level in high nibble
	and	bl,00001111b			; clear higher nibble
	or	bl,ah				; (bl) higher nibble contains IRQ level selected
	jmp	short init_smram_50		; go to common path as SMI based power management
ELSE
	jmp	short init_smram_00		; currently IRQ based power management not supported
ENDIF

;-----------------------------------------------;

init_smram_17:
	call	clear_default_smram		;
init_smram_18:
	or	bl,smi_post_failure		; (bl) bit 7 set for smi post unsuccessful
	call	close_smram			; CHIPSET HOOK HOOK HOOK...close SMRAM space
init_smram_00:
	xor	al,al				; disable power management
	call	save_pm_method			; save power management method in global data area
	stc					; (cy) = 01 for premature exit
init_smram_19:
	jmp	init_smram_09			;

;-----------------------------------------------;

init_smram_50:
	xchg	bl,bh				; (bl) used as temp info byte
						; (bh) bits 3-0 .. # of secondary CPU present
						; (bh) bits 7-4 .. IRQ level selected for IRQ based power management

	call	get_mapped_smi_seg_and_size	; CHIPSET HOOK HOOK HOOK...returns mapped smram segment info for different CPU and the size of SMRAM
	call	determine_smram_size		; set/reset bit 0 of (bl)
	jc	short init_smram_00		; exit...can not support 32KB SMRAM for IBM/AMD non-PLUS CPUs
	call	open_smram			; CHIPSET HOOK HOOK HOOK...open the SMRAM space for initialisation
	jc	short init_smram_18		; error in opening SMRAM space...exit
						; returns (edi) = absolute address where SMI handler should be copied to

	test	bl,smram_size_32kb		; is it 32KB SMRAM ?
	jz	short init_smram_02		; no...64KB or greater SMRAM
	sub	edi,8000h			; align 32KB SMRAM in 64KB form
init_smram_02:
	shr	edi,4				; (di) = segment where SMI code will be copied to
						; we will use [di:8000h] to [di:ffffh], so both
						; 32KB and 64KB SMRAM should work

	push	bios_data_seg			;
	pop	ds				; (ds) = bios standard data segment (40H)
	mov	al,bda_apm_state		; (al) = current bda_apm_state
	and	bda_apm_state,not early_post_init_smram_done; clear bit 1
	and	al,early_post_init_smram_done	;
	or	bl,al				; set/reset bit 1 for early_post_init_smram done

	mov	ds,di				; set (ds) to SMRAM segment
	mov	es,di				; set (es) to SMRAM segment

	test	bl,smi_init_early_post		; SMI initialization code is being called during early post ?
	jnz	short init_smram_61		; yes...
	test	bl,early_post_init_smram_done	; early_post_init_smram done ?
	jnz	short init_smram_62		; yes...
init_smram_61:

	call	clear_smram			; clear SMRAM area
	call	copy_compare_smram		; copy SMI code into SMRAM and compare
	jc	short init_smram_18		; error in SMI code compare

	call	init_smi_cpu_data		; initialise SMI data area related to CPU
	call	setup_cpu_jmp_code		; setup CPU JMP vectors

	test	bl,smi_init_early_post		; SMI initialization code is being called during early post ?
	jnz	short init_smram_60		; yes...

init_smram_62:
	call	init_smi_data			; initialise SMI data area
	call	apm_post			; initialise APM data area
	call	init_pm_registers		; CHIPSET HOOK HOOK HOOK...initialise power management registers based on BCP/SETUP info
	test	bl,early_post_init_smram_done	; early_post_init_smram done ?
	jnz	short init_smram_64		; yes...
init_smram_60:
	call	handle_smbase_relocation	; set/reset bit 1 of (bl)
	jc	short init_smram_17		; error...
	call	setup_smi_handler_for_multiple_cpu; setup SMI handler for all secondary cpu
	jc	short init_smram_17		; error...EXIT
	push	bx				; save bit 7 of (BL) having SMI init at early/late post info
	and	bl,not smi_post_failure		; set SMI POST was successful
						; smi_init_early_post & smi_post_failure are sharing the same bit
	call	close_smram			; CHIPSET HOOK HOOK HOOK...close SMRAM space
	pop	bx				; restore bit 7 of (BL) having SMI init at early/late post info
	call	relocate_smbase_for_multiple_cpu; relocate SMBASE for all secondary cpu
	jc	short init_smram_00		; error...EXIT
	call	global_smi_enable		; CHIPSET HOOK HOOK HOOK...set for SMI generation
	test	bl,smbase_reloc_reqd		; relocation needed ?
	jz	short init_smram_08		; no...
	call	generate_sw_smi_for_relocation	; CHIPSET HOOK HOOK HOOK...generate software SMI for relocation
	call	clear_default_smram		;
init_smram_08:
	clc					; (cy) = 00 for no error
init_smram_09:
	pop	es				;
	pop	ds				;
	popad					;
	ret

;-----------------------------------------------;

init_smram_64:
	and	bl,not smbase_reloc_reqd	; clear bit 1...smbase relocation not required
	call	close_smram			; CHIPSET HOOK HOOK HOOK...close SMRAM space
	call	global_smi_enable		; CHIPSET HOOK HOOK HOOK...set for SMI generation
	jmp	short init_smram_08		;

init_smram_local	endp

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
;	      SUBROUTINES USED BY SMRAM INIT ROUTINE		;
;---------------------------------------------------------------;
;			GET_DUAL_CPU_INFO			;
;---------------------------------------------------------------;
;	Input :	(CH) cpu vendor #				;
;		(CL) cpu #					;
;		(BH) bit 3  bit 2				;
;		       0      0   ... INTEL type SMI		;
;		       0      1   ... CYRIX type SMI		;
;		       1      0   ... AMD type SMI		;
;		       1      1   ... reserved			;
;		     bit 6 set for SMI capable CPU		;
;		     bit 6 clear for non-SMI CPU		;
;		STACK PRESENT					;
;	Output: (BH) bit 4 set for dual/multiple CPU present	;
;		     bit 4 clear for single CPU			;
;		(BL) bit 3-0...no. of secondary CPU present	;
;	Register destroyed : (BX)				;
;---------------------------------------------------------------;

get_dual_cpu_info	proc	near

	and	bx,(not dual_cpu_present)*256 + 11110000b; clear bit 4 of (bh) for dual/multiple CPU not present
						; clear bit 3 thru 0 of (bl) for no dual/multiple CPU present
	call	get_no_of_sec_cpu_local		; (al) = # of dual/multiple CPU present
	jc	short get_dual_cpu_info_00	; no dual/multiple CPU present
	and	al,00001111b			; consider bits 3 thru 0
	or	bl,al				; set # of secondary CPU present
	or	bh,dual_cpu_present		; set dual/multiple CPU present
get_dual_cpu_info_00:
	ret

get_dual_cpu_info	endp

;---------------------------------------------------------------;
;		      DETERMINE_SMRAM_SIZE			;
;---------------------------------------------------------------;
;	Input :	(CH) cpu vendor #				;
;		(CL) cpu #					;
;		(BL) bit 3  bit 2				;
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
;		(EDI) 00010000h or other values for 64KB	;
;				or greater SMRAM		;
;		      00008000h for 32KB SMRAM			;
;		STACK PRESENT					;
;	Output: (CY) 01 SMI can not be supported for current	;
;			CPU and SMRAM size			;
;		(CY) 00 SMI can be supported for current CPU and;
;			SMRAM size &				;
;			(BL) bit 0 set for 32KB SMRAM		;
;			     bit 0 clear for 64KB or greater SMRAM
;	Register destroyed : (BL)				;
;---------------------------------------------------------------;

determine_smram_size	proc	near

	and	bl,not smram_size_32kb		; bit 0 clear for 64KB or greater SMRAM

	cmp	edi,8000h			; is 32KB SMRAM ?
	ja	short det_smram_size_01		; no...64KB or greater SMRAM

IF	IRQ_HANDLING_SUPPORT
	test	bl,irq_power_management		; IRQ based power management ?
	jnz	short det_smram_size_02		; yes...
ENDIF

	test	bl,smi_type_amd			; AMD type SMI ?
	jnz	short det_smram_size_00		; yes...can not support 32KB SMRAM for AMD non-PLUS/IBM/UMC CPU...EXIT
	test	bl,smi_type_cyrix		; CYRIX type SMI ?
	jnz	short det_smram_size_02		; yes...can support 32KB SMRAM
	test	bl,dual_cpu_present		; dual/multiple CPU present ?
	jnz	short det_smram_size_00		; yes...can not support 32KB SMRAM for AMD non-PLUS/IBM/UMC CPU...EXIT
det_smram_size_02:
	or	bl,smram_size_32kb		; set (bl) bit 0 for 32KB SMRAM
det_smram_size_01:
	clc					; (cy) = 00 for no error
	ret

det_smram_size_00:
	stc					; (cy) = 01 for smi can not be supported for current CPU & SMRAM size
	ret

determine_smram_size	endp

;---------------------------------------------------------------;
;			CLEAR_SMRAM				;
;---------------------------------------------------------------;
;	Input : (ES) segment where SMI code will be copied to	;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
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
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (EAX),(DI)				;
;---------------------------------------------------------------;

clear_smram	proc	near

	push	cx				;
	call	get_size_and_offset		; get size and offset of SMRAM area
	xor	eax,eax				;
	rep	stosd				; clear the SMRAM
	pop	cx				;
	ret

clear_smram	endp

;---------------------------------------------------------------;
;		      GET_SIZE_AND_OFFSET			;
;---------------------------------------------------------------;
;	Input :	(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
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
;		STACK PRESENT					;
;	Output: (CX) size of SMRAM area in DWORDs		;
;		(DI) offset for start of SMRAM area		;
;	Register destroyed : (CX),(DI)				;
;---------------------------------------------------------------;

get_size_and_offset	proc	near

	xor	di,di				; offset for 64KB SMRAM
	mov	cx,4000h			; 16KB dwords for 64KB SMRAM
	test	bl,smram_size_32kb		; is SMRAM size 32KB ?
	jz	short get_size_offset_00	; no...64KB or greater
	mov	di,8000h			; offset for 32KB SMRAM
	mov	ch,20h				; 8KB dwords for 32KB SMRAM
get_size_offset_00:
	ret

get_size_and_offset	endp

;---------------------------------------------------------------;
;		      COPY_COMPARE_SMRAM			;
;---------------------------------------------------------------;
;	Input : (DS) segment where SMI code will be copied to	;
;		(ES) segment where SMI code will be copied to	;
;		(CS) SMI code source segment			;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for miscompare				;
;	Register destroyed : (SI),(DI)				;
;---------------------------------------------------------------;

copy_compare_smram	proc	near

	push	cx				;
	mov	si,offset cgroup:smi_code_begin	; (cs:si) = SMI code start
;;;	mov	cx,offset cgroup:smi_code_end	;
	mov	cx,cseg_data_area_begin		; 
	call	copy_compare_cpu_smram		;
	pop	cx				;
	ret

copy_compare_smram	endp

;---------------------------------------------------------------;
;		    COPY_COMPARE_CPU_SMRAM			;
;---------------------------------------------------------------;
;	Input : (ES) segment where SMI code will be copied to	;
;		(CS) SMI code source segment			;
;		(SI) SMI code start offset			;
;		(CX) SMI code end offset			;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for miscompare				;
;	Register destroyed : (CX),(SI),(DI)			;
;---------------------------------------------------------------;

copy_compare_cpu_smram	proc	near

	push	ds				;

	push	cs				;
	pop	ds				; (ds) = SMI code source segment
	mov	di,orgbase			; offset in SMRAM area for SMI code
	sub	cx,si				; (cx) = SIZE of SMI code in bytes
	add	cx,3				; adjust to calculate # of dwords
	shr	cx,2				; (cx) = # of dwords to be copied

	call	copy_compare			;
	pop	ds				;
	ret

copy_compare_cpu_smram	endp

;---------------------------------------------------------------;
;	           COPY_COMPARE_DEFAULT_SMRAM			;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
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
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for miscompare				;
;	Register destroyed : (SI),(DI)				;
;---------------------------------------------------------------;

copy_compare_default_smram	proc	near

	push	cx				;
	push	es				;

	mov	cx,3000h			;
	mov	es,cx				; (es) = default SMRAM segment
	call	get_size_and_offset		; get size and offset of SMRAM area
	mov	si,di				;

	call	copy_compare			;
	pop	es				;
	pop	cx				;
	ret

copy_compare_default_smram	endp

;---------------------------------------------------------------;
;		         COPY_COMPARE				;
;---------------------------------------------------------------;
;	Input : (DS:SI) source					;
;		(ES:DI) destination				;
;		(CX) count of DWORDs to copy			;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for miscompare				;
;	Register destroyed : (CX),(SI),(DI)			;
;---------------------------------------------------------------;

copy_compare	proc	near

	push	cx				;
	push	si				;
	push	di				;
	rep	movsd				; copy SMI code in SMRAM area
	pop	di				;
	pop	si				;
	pop	cx				;

	repe	cmpsd
	clc					; (cy) = 00 for no error
	jz	short copy_compare_00		; compare successful
	stc					; (cy) = 01 for compare error
copy_compare_00:
	ret

copy_compare	endp

;---------------------------------------------------------------;
;		        CLEAR_DEFAULT_SMRAM			;
;---------------------------------------------------------------;
;	Input : NONE						;
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (EAX),(DI)				;
;---------------------------------------------------------------;

clear_default_smram	proc	near

	push	cx				;
	push	es				;
	mov	cx,3000h			;
	mov	es,cx				; (es) = default SMRAM segment
	call	clear_smram			;
	pop	es				;
	pop	cx				;
	ret

clear_default_smram	endp

;---------------------------------------------------------------;
;			INIT_SMI_CPU_DATA			;
;---------------------------------------------------------------;
;	Input : (DS) SMI segment				;
;		(ES) SMI segment				;
;		(CS) SMI code source segment			;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
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
;		(CL) cpu #					;
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (EAX),(EDX),(ESI),(EDI)		;
;---------------------------------------------------------------;

init_smi_cpu_data	proc	near

	mov	ds:misc_proc_smi_info,bl	;
	mov	ds:misc_proc_smi_info_cseg,bl	;

	movzx	ax,ch				; (ax) = cpu vendor#
	bts	ds:bios_detected_cpu_mfr,ax	; set proper bit for CPU vendor#
	bts	ds:bios_detected_cpu_mfr_cseg,ax;

	movzx	ax,cl				; (ax) = cpu#
	mov	ds:cpu_name_dseg,ax		; save cpu# 
	mov	ds:cpu_name_cseg,ax		;

	mov	al,bh				;
	and	al,00001111b			; (al) = # of secondary CPU present
	mov	ds:no_of_sec_cpu_present,al	;
	mov	ds:no_of_sec_cpu_present_cseg,al;

IF	IRQ_HANDLING_SUPPORT
	mov	al,bh				;
	shr	al,4				; (al) = IRQ level for IRQ based power management
	mov	ds:irq_used_for_pm,al		;
	mov	ds:irq_used_for_pm_cseg,al	;
ENDIF

	call	get_mapped_smi_seg_and_size	; CHIPSET HOOK HOOK HOOK...returns mapped smram segment info for different CPU and the size of SMRAM
	mov	ds:smi_code_seg_intel_amd_plus_cseg,ax; SMI mapped segment for INTEL/AMD PLUS CPU
						; shadow area used for IRQ based power management
	shr	eax,16				;
	mov	ds:smi_code_seg_cyrix_ti_cseg,ax; SMI mapped segment for CYRIX/TI CPU
	mov	ds:smi_code_seg_ibm_amd_non_plus_cseg,si; SMI mapped segment for IBM/AMD non-PLUS CPU
	mov	ds:smi_seg_size_cseg,edi	; SMI/IRQ segment size

	ret

init_smi_cpu_data	endp

;---------------------------------------------------------------;
;		        INIT_SMI_DATA				;
;---------------------------------------------------------------;
;	Input : (DS) SMI segment				;
;		(ES) SMI segment				;
;		(CS) SMI code source segment			;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
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
;		(CL) cpu #					;
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (EAX),(EDX),(ESI),(EDI)		;
;---------------------------------------------------------------;

init_smi_data	proc	near

	push	cx				;

	call	setup_ide_data_area		; setup data area for IDE drives
	call	setup_disp_data_area		; setup data area for VESA VBE/PM
	mov	di,save_post_vga_vector		;
	call	save_int10_vectors		; save vectors for INT 10h execution

	push	ds				;
	push	int_vec_seg			;
	pop	ds				; (ds) = INT vector address segment
	mov	eax,ds:[10h*4]			; (eax) = INT 10H vecotr address
	mov	es:vga_bios_entry,eax		;
	mov	eax,ds:[16h*4]			; (eax) = INT 16H vector address
	mov	es:int_16_entry,eax		;

	push	bios_data_seg			;
	pop	ds				; (ds) = bios standard data segment (40H)
	test	machine_config,00000010b	; numeric co-processor present ?
	jz	short init_smi_data_01		; no...
	or	byte ptr es:misc_proc_info,npx_present; set for numeric co-processor present
	or	byte ptr es:misc_proc_info_cseg,npx_present; set for numeric co-processor present
init_smi_data_01:

	pop	ds				;

	pop	cx				;
	push	cx				;
	push	bx				;
	mov	di,chipset_config_area		;
	call	init_chipset_data		; CHIPSET HOOK HOOK HOOK...initialise chipset specific data area
	pop	bx				;

	pop	cx				;
	ret

init_smi_data	endp

;---------------------------------------------------------------;
;			SETUP_CPU_JMP_CODE			;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
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
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (AX),(DX),(DI)			;
;---------------------------------------------------------------;

setup_cpu_jmp_code	proc	near

	mov	di,8000h			;

IF	IRQ_HANDLING_SUPPORT
	test	bl,irq_power_management		; IRQ based power management ?
	jnz	short setup_cpu_jmp_10		; yes...
ENDIF

	mov	byte ptr [di],0e9h		; smi_seg:8000h ---> JMP 8019h
;;	mov	word ptr [di+01],0016h		; INTEL/AMD PLUS 32KB/64KB SMRAM
	mov	word ptr [di+01],(cgroup:intel_amd_plus_detect - cgroup:smi_code_begin -3)
						; INTEL/AMD PLUS 32KB/64KB SMRAM
	test	bl,smram_size_32kb		; 32KB SMRAM ?
	jnz	short setup_cpu_jmp_01		; yes...

	xor	di,di				;
	mov	byte ptr [di],0e9h		; smi_seg:0000h ---> JMP 801Fh
;;	mov	word ptr [di+01],801ch		; CYRIX/TI/IBM-CYRIX 64KB SMRAM
	mov	word ptr [di+01],(cgroup:crx_ti_detect - cgroup:smi_code_begin + orgbase - 3)
						; CYRIX/TI/IBM-CYRIX 64KB SMRAM

	mov	ax,ds:smi_code_seg_ibm_amd_non_plus_cseg; (ax) = smi code segment for IBM/AMD non-PLUS CPU
	mov	di,0fff0h			;
	mov	byte ptr [di],0eah		; smi_seg:fff0h ---> JMP smi_seg:801Ch
;;	mov	word ptr [di+01],801ch		; IBM/AMD non-PLUS/UMC 64KB SMRAM
	mov	word ptr [di+01],(cgroup:amd_non_plus_ibm_detect - cgroup:smi_code_begin + orgbase)
						; IBM/AMD non-PLUS/UMC 64KB SMRAM
	mov	word ptr [di+03],ax		;

	ret

setup_cpu_jmp_01:
	test	bl,smi_type_cyrix		; CYRIX type SMI ?
	jz	short setup_cpu_jmp_02		; no...INTEL type SMI

	mov	ax,ds:smi_code_seg_cyrix_ti_cseg; (ax) = smi code segment for CYRIX/TI CPU
	sub	ax,800h				; align in 64KB form
	mov	byte ptr [di],0eah		; smi_seg:0000h ---> JMP (smi_seg-800h):801Fh
;;	mov	word ptr [di+01],801fh		; CYRIX/TI 32KB SMRAM
	mov	word ptr [di+01],(cgroup:crx_ti_detect - cgroup:smi_code_begin + orgbase)
						; CYRIX/TI 32KB SMRAM
	mov	word ptr [di+03],ax		;

setup_cpu_jmp_02:
	ret

IF	IRQ_HANDLING_SUPPORT
setup_cpu_jmp_10:
	mov	word ptr [di],0aa55h		; put as ROM signature
	mov	byte ptr [di+02],40h		; set size as 32KB
	call	setup_irq_handler		; setup IRQ handler
	ret
ENDIF

setup_cpu_jmp_code	endp

;---------------------------------------------------------------;
;		HANDLE_SMBASE_RELOCATION			;
;---------------------------------------------------------------;
;	Input : (DS) SMRAM segment				;
;		(ES) SMRAM segment				;
;		(BL) bit 0 set for 32KB SMRAM			;
;		     bit 0 clear for 64KB or greater SMRAM	;
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
;		(CL) cpu #					;
;		STACK PRESENT					;
;	Output: (CY) 00 ... SMBASE relocation not required	;
;			... SMBASE relocation required and code	;
;			    + data copied to default smbase area;
;			    successfully & (bl) bit 1 set as	;
;			    smbase relocation is required.	;
;		(CY) 01 ... SMBASE relocation is required but	;
;			    code + data could not be copied	;
;			    successfully.			;
;	Register destroyed : (BL),(SI),(DI)			;
;---------------------------------------------------------------;

handle_smbase_relocation	proc	near

	and	bl,not smbase_reloc_reqd	; clear bit 1 of (bl) for no smbase relocation
	test	bl,smi_type_mask or irq_power_management; INTEL type SMI/IRQ based power management ?
	jnz	short smbase_reloc_05		; no...does not require relocation
	test	bl,smram_size_32kb		; is it 32KB SMRAM ?
	jz	short smbase_reloc_06		; no...64KB or greater SMRAM
	cmp	word ptr ds:smi_code_seg_intel_amd_plus_cseg,3800h; does relocation needed ?
	jmp	short smbase_reloc_08		;

smbase_reloc_06:
	cmp	word ptr ds:smi_code_seg_intel_amd_plus_cseg,3000h; does relocation needed ?
smbase_reloc_08:
	jz	short smbase_reloc_05		; does not need relocation
smbase_reloc_07:
	or	bl,smbase_reloc_reqd		; (bl) bit 1 set for relocation needed
	call	copy_compare_default_smram	; copy SMRAM code+data to default SMRAM area
	ret

smbase_reloc_05:
	clc					; (cy) = 00 for no error
	ret

handle_smbase_relocation	endp

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
;		ROUTINES FOR SETTING UP IDE DATA AREA		;
;---------------------------------------------------------------;
;			SETUP_IDE_DATA_AREA			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

setup_ide_data_area	proc	near

	pushad					;
;	db	09ah
;	dw	0
;	dw	0de00h
;	int	3

	push	es				; save on entry (es)
	push	bios_data_seg			; BIOS standard data segment
	pop	es				;

	movzx	cx,byte ptr es:winch_number	; (cx) = # of IDE drives in system

; (CX) SHOULD CONTAIN # OF IDE DRIVES SUPPORTED BY THE MAIN CORE BIOS.....IMPORTANT IMPORTANT......
; ANOTHER ASSUMPTION HERE IS IDE DRIVES CONTROLLED BY MAIN CORE BIOS
; START WITH 80H............IMPORTANT IMPORTANT........

	cmp	cx,no_of_ide_drv_supported	; is more than supported drive ?
	jbe	short setup_ide_data_area_01	; no...
	mov	cx,no_of_ide_drv_supported	;
setup_ide_data_area_01:
	or	cl,cl				; any ide drive present ?
	jz	short setup_ide_data_area_10	; no...

	push	es
	push	0
	pop	es
	mov	si,es:[13h*4]
	mov	ax,es:[13h*4+2]
	mov	es,ax
	mov	ax,es:[si+1]
	add	si,ax
	add	si,6
	mov	ax,es:[si]
	mov	es,ax
	mov	dl,es:[100h]
	pop	es
	mov	ax,0400h
_next_drv:
	mov	dh,dl
	and	dh,03h
	cmp	dh,01h				; HDD ?
	jnz	@f
	inc	al
@@:
	cmp	dh,02h				; CD-ROM?
	jnz	@f
	xchg	ah,cl
	mov	dh,00010000b
	shr	dh,cl
;	or	byte ptr ds:[atapi_byte],dh
	xchg	ah,cl
@@:
	ror	dl,2
	dec	ah
	jnz	_next_drv
	or	ax,ax
	jz	short setup_ide_data_area_10	; no...
	xchg	ax,cx
	mov	dx,80h				; start from drive 80h
	push	ax
	mov	al,Q_FIRST_BOOT_DRIVE
	call	check_cmos_data_far
	cmp	al,0ah				; SCSI boot?
	pop	ax
	jnz	setup_ide_data_area_00
	sub	ax,cx
	add	dx,ax
setup_ide_data_area_00:
	push	cx				;
	mov	si,ext_drv_param		; (si) = buffer address to get extended drive parameters
	mov	word ptr [si+ms_info_size],struc_ext_drv_param_size
	call	setup_individual_ide		; setup individual IDE drive
	pop	cx				;
	inc	dx				; next drive #
	loop	setup_ide_data_area_00		; do for all drives present in the system

setup_ide_data_area_10:
	pop	es				;
	popad					;
	ret

setup_ide_data_area	endp

;---------------------------------------------------------------;
;		    SETUP_INDIVIDUAL_IDE			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(DX) drive # (80h,81h etc.)			;
;		(DS:SI) buffer for extended drive parameter	;
;	Output: NONE						;
;	Register destroyed : (ES),(AX),(BX),(CX),(SI)           ;
; NOTE : If main core bios provide fixed address for extended	;
;	 drive parameter, then following code can be reduced.	;
;	 Following code still required if IDE drives are	;
;	 controlled from optional rom.				;
;---------------------------------------------------------------;

setup_individual_ide	proc	near

	push	dx				; (dx) = save drive #
	mov	ah,int_13_ext_func_41		; check extensions present (MICROSOFT)
	mov	bx,055aah			;
	int	13h				;
	jc	short setup_individual_ide_10	; error...extension not present
	cmp	bx,0aa55h			; extension present ?
	jnz	short setup_individual_ide_10	; no...
	pop	dx				; (dx) = restore drive #
	push	dx				; (dx) = save drive #

	mov	ah,int_13_ext_func_48		; get drive parameters
	int	13h				;
	jc	short setup_individual_ide_10	; error...function not supported

	cmp	dword ptr [si+wd_extended_table],0ffffffffh; valid address ?
	jz	short setup_individual_ide_10	; no...
	pop	dx				; (dx) = restore drive #
	les	si,[si+wd_extended_table]	; (es:si) = pointer to extended table
	call	setup_ext_ide_spl_info		;
	ret

setup_individual_ide_10:
	pop	dx				; (dx) = restore drive #
	call	setup_ide_spl_info		;
	ret

setup_individual_ide	endp

;---------------------------------------------------------------;
;		     SETUP_IDE_SPL_INFO				;
;---------------------------------------------------------------;
;	Input : (DX) drive # (80h,81h...etc)			;
;		(DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (BX)				;
;---------------------------------------------------------------;

setup_ide_spl_info	proc	near

	cmp	dl,80h				; drive # 80h ?
	jnz	short setup_ide_spl_info_00	; no...

	mov	bx,hdd_0_control_struc		; drive 0 of primary controller
	mov	byte ptr [bx+hdd_misc_control_info],00011110b; IRQ level 14
						; drive present
						; primary controller
						; master drive
	ret

setup_ide_spl_info_00:
	cmp	dl,81h				; drive # 81h ?
	jnz	short setup_ide_spl_info_01	; no...exit

	mov	bx,hdd_1_control_struc		; drive 1 of primary controller
	mov	byte ptr [bx+hdd_misc_control_info],10011110b; IRQ level 14
						; drive present
						; primary controller
						; slave drive
setup_ide_spl_info_01:
	ret

setup_ide_spl_info	endp

;---------------------------------------------------------------;
;		    SETUP_EXT_IDE_SPL_INFO			;
;---------------------------------------------------------------;
;	Input : (DX) drive # (80h,81h...etc)			;
;		(ES:SI) pointer to extended table		;
;		(DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (AX),(BX)				;
;---------------------------------------------------------------;

setup_ext_ide_spl_info	proc	near

	mov	al,es:[si+wd_irq]		; (al) = IRQ level
	and	ax,0000000000001111b		; clear upper nibble
	bts	ds:gpm_ide_irq_usage,ax		; set proper bit for IRQ usage

	test	byte ptr es:[si+wd_hdd_misc_info_00],wd_drive_0_1_bit; drive 1 of the controller ?
	jz	short ext_ide_spl_info_01	; no...
	or	al,hdd_drive_select_bit_equ	; set for drive 1 of the controller

ext_ide_spl_info_01:
	cmp	word ptr es:[si+wd_ide_base_addr],primary_ide_cntlr; primary ide controller ?
	jz	short ext_ide_spl_info_04	; yes...
	cmp	word ptr es:[si+wd_ide_base_addr],secondary_ide_cntlr; secondary ide controller ?
	jnz	short ext_ide_spl_info_03	; no...
	or	al,hdd_port_select_bit_equ	; set for secondary controller
	mov	bx,hdd_2_control_struc		; drive 0 of secondary controller
ext_ide_spl_info_02:
	test	al,hdd_drive_select_bit_equ	; drive 1 of primary/secondary controller ?
	jz	short ext_ide_spl_info_05	; no...drive 0
	add	bx,struc_hdd_x_info_size	; point to drive 1 table of primary/secondary controller
ext_ide_spl_info_05:
	or	al,hdd_present_bit_equ		; set for drive present
	mov	[bx+hdd_misc_control_info],al	;
ext_ide_spl_info_03:
	ret

ext_ide_spl_info_04:
	mov	bx,hdd_0_control_struc		; drive 0 of primary controller
	jmp	short ext_ide_spl_info_02	;

setup_ext_ide_spl_info	endp

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
;	    ROUTINES FOR SETTING UP DISPLAY DATA AREA		;
;---------------------------------------------------------------;
;			SETUP_DISP_DATA_AREA			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

setup_disp_data_area	proc	near

	pusha					;
	push	es				;
	mov	ax,vesa_ext_func*256+vesa_vbe_pm_services_func	; extended VESA VBE/PM function call
	mov	cx,0000h			; (cx) = currently consider primary controller only
	mov	bl,report_vbe_pm_support_info	; (bl) = sub function...report vbe/pm capabilities
	xor	di,di				;
	mov	es,di				; (es:di) should be null pointer for VBE/PM v1.0
	int	10h				; execute the function
	mov	si,disp_0_control_struc		; (si) = control information for primary controller
	mov	byte ptr [si+disp_misc_control_info],00000000b; set for primar controller &
						; vbe/pm interface not supported
	cmp	ax,00h*256+vesa_ext_func	; VESA VBE/PM extension supported ?
	jnz	short setup_disp_data_area_00	; no...
	and	bh,vbe_pm_standby_bit or vbe_pm_suspend_bit or vbe_pm_off_bit or vbe_pm_reduced_on_bit
						; any of the power saving mode supported ?
	jz	short setup_disp_data_area_00	; no...
	or	byte ptr [si+disp_misc_control_info],vbe_pm_interface_supported
	mov	[si+disp_vbe_supported_power_mode],bh
	mov	[si+disp_vbe_ver_no],bl		;
setup_disp_data_area_00:
	pop	es				;
	popa					;
	ret

setup_disp_data_area	endp

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
;			SAVE_PM_METHOD				;
;---------------------------------------------------------------;
;	Input : (AL) 00h disable power management		;
;		     01h use SMI power management method	;
;		     02h use hardware auto power management method
;		     03h use IRQ based power management		;
;		(BL) bit 7 set, cpu has SMI support		;
;		STACK PRESENT					;
;	Output: (AL) 00h disable power management		;
;		     01h use SMI power management method	;
;		     02h use hardware auto power management method
;		     03h use IRQ based power management		;
;	Register destroyed : (AL) under certain cases		;
;---------------------------------------------------------------;

save_pm_method	proc	near

	push	ds				;
	push	bios_data_seg			;
	pop	ds				; (ds) = bios standard data segment (40H)
	cmp	al,1				; use SMI based power management ?
	jnz	short save_pm_method_00		; no...
	test	bl,10000000b			; cpu has SMI support ?
	jnz	short save_pm_method_00		; yes...
	xor	al,al				; convert to disable power management
save_pm_method_00:
	and	al,00000011b			; consider power management method bits
	shl	al,4				; take it to bits 5,4
	and	sys_info,11001111b		; clear bits 5,4
	or	sys_info,al			;
	shr	al,4				; get power management method bits in 1,0
	pop	ds				;
	ret

save_pm_method	endp

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
