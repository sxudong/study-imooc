	page	,132
	title	SMBIOS 2.1 IMPLEMENTATION
;---------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1997, American Megatrends Inc.	**;
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
	include	smb.cfg
	include	smbstruc.def
	include	smb.equ
;---------------------------------------;
	extrn	smbios_rt_func_entry:near
	extrn	smbios_runtime_code_end:byte
;---------------------------------------;
	public	smbios_runtime_size
	public	smbios_data_module_size
	public	ptr_to_smbios_data_module
	public	post_interface_routine
	public	runtime_interface_routine
	public	ptr_to_gpnv_data_area
	public	gpnv_interface_routine
;---------------------------------------;
cgroup	group	_text
_text	segment	para	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_SMB_STARTS
_SMB_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;  This is the first file linked in creating SMBIOS module.		;
;-----------------------------------------------------------------------;
	ORG	0000h			; OFFSET 00..SMBIOS Runtime PnP Function entry point
	jmp	smbios_rt_func_entry
	ORG	0003h			; OFFSET 03..POST routines for SMBIOS
	jmp	smbios_post_routine
	ORG	0006h			; OFFSET 06..SMBIOS runtime image size
smbios_runtime_size:
	dw	offset cgroup:smbios_runtime_code_end
	ORG	0008h			; OFFSET 08..ptr to internal data area
	dw	offset cgroup:smbios_internal_data
	ORG	000Ah			; OFFSET 0A..SMBIOS Data Module Size in Bytes
smbios_data_module_size:
	dw	0000h			; SMBIOS Data Module size in bytes
	ORG	000Ch			; OFFSET 0C..Segment of SMBIOS Data Module
ptr_to_smbios_data_module:
	dw	0000h			; offset  where SMBIOS Data Module is uncompressed
	dw	0000h			; segment where SMBIOS Data Module is uncompressed
	ORG	0010h			; OFFSET 10..ptr to POST Interface routine to be initialized by Core Control code
post_interface_routine:
	dw	0000h			; offset  of POST Interface routine
	dw	0000h			; segment of POST Interface routine
	ORG	0014h			; OFFSET 14..ptr to POST Interface routine to be initialized by Core Control code
runtime_interface_routine:
	dw	0000h			; offset  of Runtime Interface routine
	dw	0000h			; segment of Runtime Interface routine
	ORG	0018h			; OFFSET 18..ptr to GPNV Data Area to be initialized by Core Control code
ptr_to_gpnv_data_area:
	dw	0000h			; offset  of GPNV Data Area
	dw	0000h			; segment of GPNV Data Area
	ORG	001Ch			; OFFSET 1C..ptr to GPNV Interface to be initialized by Core Control code
gpnv_interface_routine:
	dw	0000h			; offset  of GPNV Interface Routine
	dw	0000h			; segment of GPNV Interface Routine
;-----------------------------------------------------------------------;
;		INTERNAL DATA AREA USED in SMBIOS			;
;  These data areas may be accessed from other modules, so the offset of;
;  each variable within this data area SHOULD NOT BE CHANGED ONCE IT IS	;
;  DEFINED.............................................................	;
;-----------------------------------------------------------------------;
	public	smbios_internal_data
	public	smbios_internal_data_size
smbios_internal_data		label	byte
		SMB_INTERNAL_DATA_STRUC	{}
smbios_internal_data_end	label	byte
smbios_internal_data_size	equ	smbios_internal_data_end-smbios_internal_data
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1997, American Megatrends Inc.	**;
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
;			SMBIOS_POST_ROUTINE				;
;  this routine decides based on the input function number (AH) which	;
;  routine needs to be executed and execute that routine. This routine	;
;  MUST BE INVOKED as CALL FAR and it must return with RETF.		;
;  input :								;
;	AH	function#						;
;	AL	UNDEFINED						;
;	EAX+	UNDEFINED						;
;	Other registers specific to the function			;
;  output:								;
;	NC	successful						;
;	CY	error							;
;-----------------------------------------------------------------------;
smbios_post_routine	proc	near
	push	es
	push	ds
	pushad
	movzx	eax,ah
	cmp	al,num_of_smbios_routines		; valid func# ?
	jae	short spr_00			; invalid func#
	call	cgroup:word ptr [smbios_routine_table+eax]; execute the routine
	xor	ah,ah				; AH = 00
spr_00:
	cmp	ah,1
	cmc					; return proper Carry Flag
	popad
	pop	ds
	pop	es
	retf
spr_01:
	mov	ah,0ffh				; error code
	jmp	short spr_00
smbios_post_routine	endp
;-----------------------------------------------------------------------;
;			SMBIOS_ROUTINE_TABLE				;
;-----------------------------------------------------------------------;
smbios_routine_table	label	byte
	dw	offset cgroup:smbios_post_init	; FN00..SMBIOS DATA STRUCTURE INIT
smbios_routine_table_end	label	byte
num_of_smbios_routines	equ	(smbios_routine_table_end-smbios_routine_table)/2
;-----------------------------------------------------------------------;
;			SMBIOS_POST_INIT				;
;  this routine initializes all SMBIOS data structures during POST.	;
;  input :								;
;	current CS is writeable						;
;  output:								;
;	none								;
;  register usage: can destroy any register excluding FS, GS		;
;-----------------------------------------------------------------------;
	extrn	init_smbios_post:near
smbios_post_init:
	call	init_smbios_post	; initialize/form the data structures
; all SMBIOS data structures are initialized
; copy the structures at the end of runtime code
	push	cs
	pop	es
	mov	di,offset cgroup:smbios_runtime_code_end; ES:DI = ptr to destn of SMBIOS Data structures
	lds	si,cgroup:dword ptr ptr_to_smbios_data_module; DS:SI = ptr to SMBIOS Data Module
	mov	cx,cgroup:word ptr smbios_data_module_size; CX = SMBIOS data module size
	rep	movsb			; copy the data module
	ret
;-----------------------------------------------------------------------;
;		SMBIOS STRUCTURE TABLE ENTRY POINT			;
;-----------------------------------------------------------------------;
align	16
	public	smbios_table_entry_point_struc
	public	smbios_table_entry_point_struc_size
smbios_table_entry_point_struc	label	byte
	SMB_TABLE_HEADER_STRUC {}	; initialized during POST init
smbios_table_entry_point_struc_end	label	byte
smbios_table_entry_point_struc_size	equ	smbios_table_entry_point_struc_end-smbios_table_entry_point_struc
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1997, American Megatrends Inc.	**;
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
	include	biosdata.dat
;---------------------------------------------------------------;
	public	_SMB_ENDS
_SMB_ENDS	label	byte		; marks end of module
;---------------------------------------------------------------;
_text	ends
END
