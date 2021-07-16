	page	,132
	title	ACPI RUNTIME HOOKS
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
;*****************************************************************;
;---------------------------------------;
	include	makeflag.equ
	include	mbiosmac.mac
	include	mbiosequ.equ
	include	cf.equ
	include	rt.equ
        include pci.equ
        include silent.equ
	include	makeflag.equ
	include	oemmake.equ
	include	setupequ.ext
        include acpi.equ
;---------------------------------------;
cgroup	group	_text
_text	segment	para	public	'CODE'
	assume	cs:cgroup
.486p
;-----------------------------------------------------------------------;
;			'RSD PTR ' Pointer Structure			;
;-----------------------------------------------------------------------;
IF	MKF_ACPI_SUPPORT
	public	rsd_ptr_header    
	public	rsdt_ptr
	public	rsdptr_start
	public	rsdptr_end
	public	rsdptr_oemid
	public	rsdptr_checksum
	public	facs_wake_vector_addr
	public	info_start
	public	info_end
	public	rsdptr_table_length
align	16	
info_start		label	word
rsdptr_start		label	word
	rsd_ptr_header		db	8 dup (0)	; 'RSD PTR '; 8 Bytes ACSII
	rsdptr_checksum		db	1 dup (0)	; checksum
	rsdptr_oemid		db	6 dup (20h)	; 6 Bytes ASCII
	rsdptr_resv		db	1 dup (0)	; Reserved
	rsdt_ptr		dd	1 dup (0)	; Pointer Updated
rsdptr_end		label	word
	facs_wake_vector_addr	dd	1 dup (0)	; THIS IS USED IN AMIBIOS ONLY
							; THIS IS NOT A PART OF RSDPTR STRUCTURE
info_end		label	word
rsdptr_table_length	equ	(rsdptr_end-rsdptr_start)
ENDIF
;-----------------------------------------------------------------------;
;				WAKE_UP					;
; this routine is invoked just after runtime bios gets control in shadow;
; ram. NOTHING IS DEFINED (except EDX) ON ENTRY TO THIS ROUTINE.	;
;  input :								;
;	edx	cpu id if hard reset					;
;	ss	= cs							;
;	stack	not available						;
;  output:								;
;	none								;
;  register usage : can destroy any register except EDX, SS		;
;  Note: 1. This routine can be used to implement ACPI S2/S3 resume.	;
;	 2. If not S2/S3 wake up, just return control by JMP WAKE_UP_END;
;	 3. If S2/S3 wake up, initialize context, jmp to Wake Up vector.;
;	    (IMPORTANT: For multiprocessor system, you need to initilize;
;	    APIC and for P6, initlialize MTRR, update microcode.)	;
;-----------------------------------------------------------------------;
	public	wake_up
	extrn	wake_up_end:near
wake_up:
IF	MKF_ACPI_SUPPORT
; write the code to handle S2/S3 wake up here

	jmp	wake_up_end		; not S2/S3 wake up
ELSE
	jmp	wake_up_end
ENDIF
;-----------------------------------------------------------------------;
;			SAVE_ACPI_CONTEXT				;
; check_point		: B1						;
; This routine saves the ACPI related system context to be used by in	;
; S2/S3 wakeup. This routine is the last chipset hook (it is called	;
; after COPY_RUNTIME_BIOS) before BIOS issues INT19.			;
; input:								;
;	SS	0030H							;
;	DS	0040H							;
;	ES	0000H							;
;	stack	available						;
; register usage : can destroy any register except EBP, DS, ES		;
;-----------------------------------------------------------------------;
	extrn	bios_scratch:byte
	public	save_acpi_context
save_acpi_context:
IF	MKF_ACPI_SUPPORT
; if ACPI Aware OS is selected, then only save the context..........
	test	cgroup:byte ptr bios_scratch,acpi_aware_os_bit
	jz	short sac_00		; not ACPI Aware OS
; write code to save ACPI related context here


sac_00:
	ret
ELSE
	ret
ENDIF
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
; CODE BELOW THIS NEED NO PORTING..............GIVEN HERE FOR REFERENCE	;
;-----------------------------------------------------------------------;
IF	MKF_ACPI_SUPPORT
;-----------------------------------------------------------------------;
;			INT 15 Func 88h for ACPI			;
; This routine does not need any porting in general.			;
;-----------------------------------------------------------------------;
	public	acpi_int15_fn88
acpi_int15_fn88:
	push	ax
	mov	ax,3536h
	extrn	read_cmos_word:near
	call	read_cmos_word		; AX = Extd Memory in 64K Unit
	cmp	ax,64*16		; Ext Mem > 64MB ?
	ja	asi15_03 		; Normal Path
; Extended Memory is <= 64MB
	shl	ax,6			; AX = Ext Mem in 1K Unit
	extrn	rt_cmos_byte:byte
	test	cgroup:byte ptr rt_cmos_byte,80h; OS/2 compatible mode ?
	jnz	asi15_05		; Yes
; Extended Memory is <= 64MB
asi15_04:
	sub	ax,ACPI_MEM_KB		; Decrement by 64K to take care of ACPI
asi15_06:
	add	sp,2			; Discard "PUSH AX"
	add	sp,2			; Discard Return Address
	clc
	retf	2
asi15_05:
	cmp	ax,15*16+ACPI_MEM_KB	; Extd Mem >= 15MB + ACPI_Mem?	
	jb	asi15_04			; No
	mov	ax,3c00h
	jmp	short asi15_06
asi15_03:
	pop	ax
	ret
;-----------------------------------------------------------------------;
;			INT 15 Func E801h for ACPI			;
; This routine does not need any porting in general.			;
;-----------------------------------------------------------------------;
	public	acpi_int15_fne801
acpi_int15_fne801:
	add	sp,2			; Discard Return Address 
	mov	ah,86h			; E801 not supported if ACPI
	stc
	retf	2
;-----------------------------------------------------------------------;
ENDIF
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
