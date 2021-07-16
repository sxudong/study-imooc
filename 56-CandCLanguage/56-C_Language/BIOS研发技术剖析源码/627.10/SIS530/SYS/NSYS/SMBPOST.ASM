	page	,132
	title	SMBIOS DATA STRUCRURE INIT DURING POST
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
	include	mbiosequ.equ
	include	cpustruc.def
	include	rt.equ
	include	pci.equ
	include	pi.equ
	include	smbstruc.def
	include	smb.equ
	include	gpnv.equ
	include	makeflag.equ		; (CORE0218+)
;---------------------------------------;
	extrn	smbios_internal_data_size:abs
	extrn	smbios_table_entry_point_struc_size:abs

	extrn	smbios_table_entry_point_struc:byte
	extrn	smbios_runtime_size:byte
	extrn	smbios_data_module_size:byte
	extrn	smbios_internal_data:byte

	extrn	post_interface_routine:near
	extrn	copy_string:near
	extrn	get_string_details:near
	extrn	update_ieps_checksum:near
	extrn	update_eps_checksum:near
	extrn	get_smbios_structures_details:near
	extrn	GetStrucLen:near
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_SMBPOST_STARTS
_SMBPOST_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;			INIT_SMBIOS_POST				;
;  this routine initializes all SMBIOS data structures during POST.	;
;  input :								;
;	DI offset of SMBIOS code+data in F000 (CORE0072+)		;
;	current CS is writeable						;
;  output:								;
;	none								;
;  register usage: can destroy any register excluding FS, GS		;
;-----------------------------------------------------------------------;
	public	init_smbios_post
init_smbios_post:
;	PUSHAD
;	DB	09AH
;	DW	0
;	DW	0DE00H
;	INT	3
;	POPAD
	push	cs
	pop	es			; ES = CS
	push	di			; (CORE0072+)
; initialize local data areas
	mov	di,offset cgroup:smbios_internal_data
	mov	cx,smbios_internal_data_size
	xor	eax,eax
	rep	stosb			; init local data areas with 00
; initialize the SMBIOS Table Entry
; EAX = 00000000
	push	cs
	pop	ds			; CS = DS
	mov	si,offset cgroup:smbios_table_entry_point_struc; DS:SI = ptr to SMBIOS Table Entry
	mov	ds:dword ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bAnchorStr,'_MS_'; offset 00..string "_SM_"
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bChecksum,al	; offset 04..checksum
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bLength,smbios_table_entry_point_struc_size; offset 05..this table size
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bMajorVer,SMBIOS_MAJOR_VERSION; offset 06..Major Version
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bMinorVer,SMBIOS_MINOR_VERSION; offset 07..Minor Version
	mov	ds:word ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize,ax	; offset 08..Maximum Structure Size
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bRevision,al	; offset 0A..Revision
	mov	ds:dword ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bReserved,eax	; offset 0B-0F..Reserved
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si+4]).bReserved,al
	mov	ds:dword ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bIntAnchorStr,'IMD_'; offset 10-14..String "_DMI_"
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si+4]).bIntAnchorStr,'_'; offset 10-14..String "_DMI_"
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bIntChecksum,al	; offset 15..checksum
	mov	ds:word ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).wStrucTblLen,ax	; offset 16..total size of data structures
	mov	ds:dword ptr (SMB_TABLE_HEADER_STRUC ptr [si]).dStrucTblAddr,eax; offset 18..start 32Bit address of data structures
	mov	ds:word ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,ax	; offset 1C..total #of data structures
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bSMBRevision,SMBIOS_VERSION; offset 1D..total #of data structures
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bIntReserved,al	; offset 1E..reserved
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bIntChecksum,al	; offset 15..checksum
	mov	ds:byte ptr  (SMB_TABLE_HEADER_STRUC ptr [si]).bChecksum,al	; offset 14..EPS checksum
	push	ds
	push	si
	lds	si,cgroup:dword ptr ptr_to_smbios_data_module; DS:SI = ptr to start of data structures
	mov	di,cgroup:word ptr smbios_data_module_size; SMBIOS Data structures size
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBRomStructuresLength,di
	add	di,si			; DS:DI = ptr to end of data structures
	call	get_smbios_structures_details	; CX = #of structure
					; AX = maxm structure size
	pop	si
	pop	ds			; DS:SI = ptr to SMBIOS Table Entry
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize,ax	; offset 08..Maximum Structure Size
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,cx	; offset 1C..total #of data structures
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRomStruc,cx
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc,cx
%OUT	Implement the routine to validate & sort the strucrues
;;;;	call	validate_sort_data_structures
	call	init_smbios_data_structures; init the SMBIOS data structures
; all SMBIOS data structures are initialized
; copy the structures at the end of runtime code
	push	cs
	pop	es			; CS = ES
	mov	di,cgroup:word ptr smbios_runtime_size; ES:DI = ptr to destn of SMBIOS Data structures
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBStructuresStart,di; start of data structures
	push	di
	add	di,cgroup:word ptr smbios_data_module_size; ES:DI = ptr to end of SMBIOS runtime image (code+data)
	mov	cgroup:word ptr smbios_runtime_size,di
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd,di; end of current data structures
	pop	di
	pop	bx			; restore offset in bx (CORE0072+)
; ES:DI = ptr to start of SMBIOS data at the end of SMBIOS code
	push	000fh
	add	di,bx			; (CORE0072+)
	push	di
	pop	ebx			; EBX = 32bit address of start of data structures
	push	cs
	pop	ds			; CS = DS
	mov	si,offset cgroup:smbios_table_entry_point_struc; DS:SI = ptr to SMBIOS Table Entry
	mov	ds:dword ptr (SMB_TABLE_HEADER_STRUC ptr [si]).dStrucTblAddr,ebx
	mov	ax,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc; total #of data structures
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,ax
	mov	ax,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBRomStructuresLength
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wStrucTblLen,ax
; update the checksum in SMBIOS Table Entry Point
; DS:SI = ptr to SMBIOS Table Entry
	call	update_ieps_checksum	; update checksum in IEPS
	call	update_eps_checksum	; update checksum in EPS
; fill SMBIOS Base Address and SMBIOS Storage Size
	mov	ah,get_gpnv_information_func; 00..GET GPNV INFORMATION
	extrn	gpnv_interface_routine:byte
	call	cgroup:dword ptr gpnv_interface_routine
	jc	short isp_00		; not implemented
; ESI = physical 32Bit address of storage base
; DX  = storage size in bytes
	mov	cs:dword ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).dSMBStorageBase,esi
	shl	dx,1
	mov	cs:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).dSMBStorageSize,dx
isp_00:
	ret
;-----------------------------------------------------------------------;
;			INIT_SMBIOS_DATA_STRUCTURES			;
;  this routine initializes all SMBIOS data structures during POST.	;
;  input :								;
;	current CS is writeable						;
;  output:								;
;	none								;
;  register usage: can destroy any register excluding FS, GS		;
;-----------------------------------------------------------------------;
external_cache_level	db	00h	; level of external cache
;-----------------------------------------------------------------------;
	extrn	ptr_to_smbios_data_module:byte
init_smbios_data_structures:
	push	cs
	pop	es			; ES = CS
	lds	si,cgroup:dword ptr ptr_to_smbios_data_module; DS:SI = ptr to start of data structures
	mov	di,cgroup:word ptr smbios_data_module_size; SMBIOS Data structures size
	add	di,si			; DS:DI = ptr to end of data structures
	call	get_smbios_structures_details	; CX = #of structure
					; AX = maxm structure size
	push	cs
	pop	ds			; CS = DS
	mov	si,offset cgroup:smbios_table_entry_point_struc; DS:SI = ptr to SMBIOS Table Entry
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize,ax	; offset 08..Maximum Structure Size
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,cx	; offset 1C..total #of data structures
; SMBIOS table entry point is formed
;---------------------------------------;
; find out the external cache level#, it will be
;					#of internal cache present + 1
	lds	si,cgroup:dword ptr ptr_to_smbios_data_module; DS:SI = ptr to start of Data structures
	mov	di,cgroup:word ptr smbios_data_module_size; CX = SMBIOS data module size
	add	di,si			; DS:DI = ptr to end of data structures
; DS:SI = ptr to nest available structure
; DS:DI = ptr to end of all structures
	xor	cx,cx			; CX = #of internal cache
isds_03:
	push	cx
	mov	al,CACHE_INFORMATION_TYPE
	call	get_ptr_to_structure	; DS:SI = ptr to the concerned structure
					; DS:BX = ptr to immediate next structure
	pop	cx
	jc	short isds_01		; no more structure found
	push	di
	push	bx
	mov	al,ds:byte ptr (CACHE_INFO_STRUC ptr [si]).wCacheConfig; get config
	and	al,01100000b		; bit6-5 = 00 -> Internal cache
	jnz	short isds_02		; not internal cache
	inc	cx			; update #of internal cache
isds_02:
	pop	si
	pop	di
	jmp	short isds_03
isds_01:
; CX = #of internal cache present
;	inc	cx			; level of external cache
	cmp	cx,0007h		; ext cache level > 7 ?
	jbe	short isds_04		; no
; external cache level > 7, force the level to 7 and make the position unknown
	mov	cl,01100111b		; bit6-5 = 11  -> position unknown
					; bit2-0 = 111 -> level 7
isds_04:
;	or	cl,00100000b		; bit6-5 = 01 -> external
	mov	cgroup:byte ptr external_cache_level,cl
;---------------------------------------;
; initialize different structures, if needed
	mov	bx,offset cgroup:smbios_post_init_table
	mov	cx,smbios_post_init_table_entries
isds_00:
	push	cx
	push	bx
	lds	si,cgroup:dword ptr ptr_to_smbios_data_module; DS:SI = ptr to start of Data structures
	mov	di,cgroup:word ptr smbios_data_module_size; CX = SMBIOS data module size
	add	di,si			; DS:DI = ptr to end of data structures
	call	cgroup:word ptr [bx]	; init the concerned structure
	pop	bx
	pop	cx
	inc	bx
	inc	bx			; CS:BX = ptr to next entry
	loop	isds_00			; continue for all structures
	ret
;-----------------------------------------------------------------------;
smbios_post_init_table        label   byte
	dw	offset cgroup:post_bios_init
	dw	offset cgroup:post_processor_init
	dw	offset cgroup:post_memory_controller_init
	dw	offset cgroup:post_memory_module_init
	dw	offset cgroup:post_external_cache_init
	dw	offset cgroup:post_system_slot_init
	dw	offset cgroup:post_onboard_device_init
	dw	offset cgroup:post_bios_language_init
if MKF_EVENT_LOG			; (CORE0218+)>
	dw	offset cgroup:post_event_log_init
endif					; <(CORE0218+)
smbios_post_init_table_end    label   byte
smbios_post_init_table_entries	equ	(smbios_post_init_table_end-smbios_post_init_table)/2
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
	include	smbpost.inc		; different structure post init routines
;---------------------------------------------------------------;
	public	_SMBPOST_ENDS
_SMBPOST_ENDS	label	byte		; marks end of module
;---------------------------------------------------------------;
_text	ends
END
