	page	,132
	title	SMBIOS RUNTIME PnP FUNCTIONS 5Xh
;---------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
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
	include	mbiosequ.equ
	include	rt.equ
	include	ri.equ
	include	gpnv.equ
	include	smb.cfg
	include	smb.equ
	include	smbstruc.def
	include	biosdata.dat
	include	makeflag.equ		; (CORE0218+)
					; (CORE0221+)>
	include	cf.equ
	include	silent.equ
					; <(CORE0221+)
;---------------------------------------;
	extrn	smbios_table_entry_point_struc:byte
	extrn	smbios_internal_data:byte
	extrn	runtime_interface_routine:byte
	extrn	gpnv_interface_routine:byte

	extrn	GetStrucLen:near
	extrn	get_structure_details:near
	extrn	copy_string:near
	extrn	get_string_details:near
	extrn	update_ieps_checksum:near
	extrn	update_eps_checksum:near
	extrn	get_smbios_structures_details:near
	extrn	get_ebda:near
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486
;---------------------------------------;
	public	_SMBRUN_STARTS
_SMBRUN_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;			SMBIOS PnP RUNTIME FUNCTIONS			;
;-----------------------------------------------------------------------;
;			SMBIOS_RT_FUNC_ENTRY				;
; This routine is invoked from thr runtime PnP functions if it is not	;
; handled by the generic BIOS module (e.g. if it is a SMBIOS function).	;
; Input:  [EBP+00] = Function number (00h)				;
;	  Other values in Stack are according to the function number	;
; Output: All output is written directly to buffers provided by caller.	;
;         AX = Zero if success, non-zero return code if non successful	;
; Destroys: AX								;
;-----------------------------------------------------------------------;
	public	smbios_rt_func_entry
smbios_rt_func_entry	proc	far
	pushf
	push	bx
	mov	bx,[ebp+00h]		; get the function number
	sub	bx,50h
	mov	ax,RT_INVALID_FUNC	; Return code for unknown func
	cmp	bx,(smbios_func_table_end - smbios_func_table_start) / 2
	jae	short srfe_00		; invalid function
	shl	bx,1
	call	cgroup:word ptr [smbios_func_table_start+bx]; Call proper PnP function
srfe_00:
	pop	bx
	popf
	retf
smbios_rt_func_entry	endp
;-----------------------------------------------------------------------;
;			SMBIOS_FUNC_TABLE				;
;-----------------------------------------------------------------------;
smbios_func_table_start	label	byte
	dw	offset cgroup:rt_get_smbios_info		;SMBIOS func 50h
	dw	offset cgroup:rt_get_smbios_struc		;SMBIOS func 51h
	dw	offset cgroup:rt_set_smbios_struc		;SMBIOS func 52h
	dw	offset cgroup:rt_get_smbios_struc_change_info	;SMBIOS func 53h
	dw	offset cgroup:rt_smbios_control			;SMBIOS func 54h
smbios_func_table_end	label	byte
;-----------------------------------------------------------------------;
;			Func 50h..RT_GET_SMBIOS_INFO			;
;-----------------------------------------------------------------------;
; This function returns information about the SMBIOS extensions such as	;
; the number of structures present and the size of the largest one. This;
; function is presently called only during RUNTIME.			;
; Input:  [EBP+00] = Function number (50h)				;
;         [EBP+02] = BYTE FAR *DmiBiosVersion				;
;         [EBP+06] = WORD FAR *NumStructures				;
;         [EBP+0A] = WORD FAR *StructureSize				;
;         [EBP+0E] = DWORD FAR *DMIStorageBase				;
;         [EBP+12] = WORD FAR *DMIStorageSize				;
;         [EBP+16] = WORD BiosSelector					;
; Output: AX       = Zero if successful, non-zero return code if non successful   ;
;         [EBP+02] = BYTE FAR *DmiBiosVersion filled in with the version of    ;
;                    the DMI BIOS spec that this code supports.                ;
;         [EBP+06] = WORD FAR *NumStructures filled with total number of DMI   ;
;                    structures that are present in the system.                ;
;         [EBP+0A] = WORD FAR *StructureSize filled with the size in bytes of  ;
;                    the largest DMI structure.                                ;
;         [EBP+0E] = WORD FAR *DMIStorageBase filled with the absolute	;
;		     32Bit address of any memory-mapped structure	;
;         [EBP+12] = WORD FAR *DMIStorageSize filled with the buffer	;
;		     size needed in Func 52h/54h.			;
; Destroys: Nothing							;
;-----------------------------------------------------------------------;
rt_get_smbios_info	proc near
	push	si
	push	ds

	push	eax

	lds	si,dword ptr [ebp+02h]		; DS:SI = *DmiBiosVersion
	mov	byte ptr [si],SMBIOS_VERSION

	mov	di,offset cgroup:smbios_table_entry_point_struc
	mov	ax,cgroup:(SMB_TABLE_HEADER_STRUC ptr [di]).wNumSMBStruc; AX = #of DMI structures present
	lds	si,dword ptr [ebp+06h]		; DS:SI = *NumStructures
	mov	word ptr [si],ax		; Fill in structure count in caller's buffer

	mov	ax,cgroup:(SMB_TABLE_HEADER_STRUC ptr [di]).wMaxStrucSize; AX = size of largest structure
	lds	si,dword ptr [ebp+0Ah]		; DS:SI = *StructureSize
	mov	word ptr [si],ax		; Fill in max structure size in caller's buffer
%Out Fill up DmiStorageBase and DmiStorageSize properly
	mov	eax,cgroup:dword ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).dSMBStorageBase
	lds	si,dword ptr [ebp+0Eh]		; DS:SI = *DMIStorageBase
	mov	dword ptr [si],eax		; Fill in DMI Storage Base address

	mov	ax,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).dSMBStorageSize
	lds	si,dword ptr [ebp+12h]		; DS:SI = *DMIStorageSize
	mov	word ptr [si],ax		; Fill in DMI Storage Size

	pop	eax
	xor	ax,ax				; Indicate success

	pop	ds
	pop	si
	ret
rt_get_smbios_info	endp
;-----------------------------------------------------------------------;
;			Func 51h..RT_GET_SMBIOS_STRUC			;
;-----------------------------------------------------------------------;
; This function copies one DMI structure into the buffer provided by the;
; caller.  The caller's DMI structure number is then updated with next	;
; DMI structure number (or FFFF if no more DMI structures are present).	;
; Input:  [EBP+00] = Function number (51h)				;
;         [EBP+02] = WORD FAR *StructureNum				;
;         [EBP+06] = WORD DAR *DmiStructureBuffer			;
;         [EBP+0A] = WORD DmiSelector					;
;         [EBP+0C] = WORD BiosSelector					;
;									;
; Output: AX       = Zero if success, non-zero return code if non successful
;         [EBP+02] = WORD FAR *StructureNum updated to contain the next DMI
;                    structure number or FFFF if no more structures exist
;         [EBP+06] = WORD FAR *DmiStructureBuffer pointer to buffer that is
;                    filled in with the requested DMI structure.	;
;									;
; Destroys: AX								;
;-----------------------------------------------------------------------;
rt_get_smbios_struc	proc near
	push	ds
	push	es
	pusha
	lds	si,dword ptr [ebp+02h]		; DS:SI = pointer to SMBIOS Structure
	mov	cx,word ptr ds:[si]		; given DMI Structure# (0-based)
	call	get_structure_details		; DS:SI = ptr to concerned structure
						; CX	= length of structure
						; AX	= next structure#
	jc	short rgss_01			; error
	push	ax
	les	di,dword ptr [ebp+06]		; ES:DI = ptr to destn buffer
	rep	movs es:byte ptr [di],ds:byte ptr [si]; copy into destn buffer
	pop	ax
	lds	si,dword ptr [ebp+02h]		; DS:SI = pointer to SMBIOS Structure
	mov	word ptr ds:[si],ax		; return next Structure#
	popa
	xor	ax,ax				; AX = 00, successful
rgss_02:
	pop	es
	pop	ds
	ret
rgss_01:
	popa
	mov	ax,RT_DMI_INVALID_HANDLE
	jmp	short rgss_02
rt_get_smbios_struc	endp
;-----------------------------------------------------------------------;
;			Func 52h..RT_SET_SMBIOS_STRUC			;
;-----------------------------------------------------------------------;
; This function sets the SMBIOS structure identified by the type and	;
; possibly handle, found in the SMBIOS structure header in the given	;
; buffer.								;
; Input:  [EBP+00] = Function number (52h)				;
;         [EBP+02] = WORD FAR *DmiDataBuffer				;
;         [EBP+06] = WORD FAR *DmiWorkBuffer				;
;         [EBP+0A] = WORD Control					;
;         [EBP+0C] = WORD DmiSelector					;
;         [EBP+0E] = WORD BiosSelector					;
; Output: AX       = Zero if successful					;
;		     non-zero return code if unsuccessful   		;
; Destroys: Nothing							;
;-----------------------------------------------------------------------;
rt_set_smbios_struc	proc	near
	push	es
	push	ds
	pushad
	lds	si,dword ptr [ebp+02h]	; DS:SI = ptr to given data buffer
	test	byte ptr [ebp+0ah],01h	; Bit-0 = 0, validate parameter
					;	  1, Set structure immediately
	jnz	short rsss_00		; set structure immediately
; validate paremeter
%OUT	Need to Implement the validate parameter subfunction properly
	jmp	rsss_02_00
rsss_00:
; set structure
	mov	al,ds:byte ptr (SMBIOS_FUNC52_BUFFER_STRUC ptr [si]).bCommand; AL = command byte
					; (CORE0072)>
;;	cmp	al,05h			; valid command ?
;;	ja	short rsss_02_00	; invalid command, error
;;	jz	short rsss_cmd_0125	; command 05h
;;	cmp	al,03h			; command 00h/01h/02h ?
;;	jb	short rsss_cmd_0125	; yes
;;	jz	short rsss_05		; command 03h
;;	jmp	rsss_cmd_04		; command 04h
	cmp	al,06h			; valid command ?
	ja	rsss_02_00		; invalid command, error
	cmp	al,05h
	jae	short rsss_cmd_0125	; command 05h/06h
	cmp	al,03h			; command 00h/01h/02h ?
	jb	short rsss_cmd_0125	; yes
	jz	short rsss_05		; command 03h
	jmp	rsss_cmd_04		; command 04h
					; <(CORE0072)
rsss_05:
	jmp	rsss_cmd_03		; command 03h
;---------------------------------------;
; command code 00h/01h/02h/05h/06h
rsss_cmd_0125:
; AL = command code 00h/01h/02h/05h/06h
	push	ax
	add	si,offset SMBIOS_FUNC52_BUFFER_STRUC.dStructureHeader; DS:SI = ptr to given structure header
	push	ds
	push	si
	mov	cx,ds:word ptr (DMIHDR_STRUC ptr [si]).wHandle; CX= given structure#
	call	get_structure_details	; get the concerned structure details
	pop	di
	pop	es
	pop	ax
	jc	short rsss_03_00	; error
; ES:DI = ptr to given structure header
; DS:SI = ptr to concerned structure in Shadow RAM
; CX	= structure length including the terminator
; AL = command code 00h/01h/02h/05h/06h
	mov	bx,es:word ptr (DMIHDR_STRUC ptr [di]).bType; BH = Fixed Length, BL = Type
	cmp	bx,ds:word ptr (DMIHDR_STRUC ptr [si]).bType; match with the information in Shadow
	jnz	short rsss_02_00	; no match, error
	push	ds
	push	si
	push	cx
	les	di,dword ptr [ebp+06h]	; ES:DI = ptr to work buffer
; copy the structure to temp work buffer
	push	di
	rep	movs es:byte ptr [di],ds:byte ptr [si]; DS:SI, CX -> ES:DI
	pop	di
; AL = command code 00h/01h/02h/05h/06h
	lds	si,dword ptr [ebp+02h]	; DS:SI = ptr to given data buffer
	movzx	bx,ds:byte ptr (SMBIOS_FUNC52_BUFFER_STRUC ptr [si]).bFieldOffset ; BX = offset of the field to be changed
	cmp	al,05h			; command 05h/06h ?
					; (CORE0072)>
;	jnz	short rsss_cmd_012	; no
	jb	short rsss_cmd_012	; no
	jz	rsss_cmd_5
; comamnd 06h, block change
; ES:DI = ptr to work buffer containing the original structure from Shadow RAM
; BX	= offset of the field in the structure to be changed
	mov	cx,ds:word ptr (SMBIOS_FUNC52_BUFFER_STRUC ptr [si]).wDataLength; get the given data length
	add	si,offset SMBIOS_FUNC52_BUFFER_STRUC.bStructuredata; DS:SI = ptr to structure data containing the new block data
	push	di
	add	di,bx			; ES:DI = ptr to starting address of the to-be-changed item
	rep	movs es:byte ptr [di],ds:byte ptr [si]; move the data to F000 Shadow
	pop	di
	jmp	short rsss_cmd_0125_00
rsss_cmd_5:
					; <(CORE0072)
; comamnd 05h, string change
; ES:DI = ptr to work buffer containing the original structure from Shadow RAM
; BX	= offset of the field in the structure containing the string# to be changed
	push	es
	push	ds
	pusha
	push	ds
	push	si
	push	es
	pop	ds
	mov	si,di			; DS:SI = ptr ro structure
	movzx	cx,ds:byte ptr [si+bx]	; CX	= string#
	or	cx,cx			; does the string exists in original structure ?
	jnz	short rsss_07		; yes
; the concerned string does not exist in the original structure
	pop	si
	pop	ds
	stc				; CY, error
	jmp	short rsss_08		; concerned string does not exist
rsss_07:
	call	get_string_details	; DS:SI = ptr to string
					; CX	= string length excluding NULL
	inc	cx			; CX	= string length including NULL
	push	ds
	pop	es
	mov	di,si			; ES:DI = ptr to string in original structure
; ES:DI = ptr to concerned string in original structure
; CX	= string length inluding NULL terminator in original structure
	pop	si
	pop	ds			; ES:DI = ptr to given structure header
	cmp	cx,ds:word ptr (SMBIOS_FUNC52_BUFFER_STRUC ptr [si]).wDataLength; validate the given data length ?
	jb	short rsss_08		; error (CY), given length is greater than the original length
	dec	cx			; length available excluding NULL
	add	si,offset SMBIOS_FUNC52_BUFFER_STRUC.bStructuredata; DS:SI = ptr to structure data containing the new string
; DS:SI = ptr to new string in given structure
; ES:DI = ptr to concerned string in original structure
; CX	= available string length excluding NULL terminator in original structure
	call	copy_string		; update the string to original structure
	clc				; ok
rsss_08:
	popa
	pop	ds
	pop	es
	jnc	short rsss_cmd_0125_00
	pop	cx
	pop	si
	pop	ds
rsss_02_00:
	jmp	rsss_02			; error
rsss_03_00:
	jmp	rsss_03			; error
rsss_cmd_012:
	cmp	al,01h			; command 00h/01h/02h ?
	mov	edx,ds:dword ptr (SMBIOS_FUNC52_BUFFER_STRUC ptr [si]).dChangeMask ; EDX = AND mask
	mov	ecx,ds:dword ptr (SMBIOS_FUNC52_BUFFER_STRUC ptr [si]).dChangeValue; EBX = OR  mask
	mov	eax,es:dword ptr [di+bx]; EAX = original content of the field to be changed
	ja	short rsss_cmd_012_00	; command 02h
	pushf
					; (CORE0227)>
;	and	edx,0000FFFFh		; keep the word
	or	edx,0FFFF0000h		; keep the word
	and	ecx,0000FFFFh		; keep the word
	popf
	jz	short rsss_cmd_012_00	; command 01h
;	mov	dh,00h			; keep the byte
	mov	dh,0ffh			; keep the byte
					; <(CORE0227)
	mov	ch,00h			; keep the byte
rsss_cmd_012_00:
	and	eax,edx			; apply AND mask
	or	eax,ecx			; apply OR  mask
	mov	es:dword ptr [di+bx],eax; EAX = update content of the field to be changed
rsss_cmd_0125_00:
	mov	si,di
	push	es
	pop	ds			; DS:SI = ptr to work buffer
	pop	cx			; length of structure
	pop	di
	pop	es			; ES:DI = ptr to structure in Shadow RAM
; before changing the data in Shadow RAM,
;	check whether the data is actually changed
;	if not changed, no need to update Shadow and GPNV (it will save time)
; DS:SI = ptr to updated  structure in work buffer
; ES:DI = ptr to original structure in Shadow RAM
; CX	= length of the structure
	pusha
	repz	cmps ds:byte ptr [si],es:byte ptr [di]; changed ?
	popa
					; (CORE0072)>
;	jz	short rsss_04		; data not changed
	jz	rsss_04			; data not changed
					; <(CORE0072)
	mov	dx,ds:word ptr (DMIHDR_STRUC ptr [si]).wHandle; DX = handel# of structure being changed
	mov	ax,SMBIOS_SINGLE_STRUCTURE_AFFECTED*256+SMBIOS_ONE_MORE_STRUCTURE_CHANGED
					; AH, AL = SMBIOS Change Status, Type
	push	dx
	push	ax
	push	bp
					; (CORE0221)>
;;	mov	bp,F000_READ_X_WRITE_RAM_FUNC; F000 shadow Write enabled
;;	call	cgroup:dword ptr runtime_interface_routine
;;	rep	movs es:byte ptr [di],ds:byte ptr [si]; move the data to F000 Shadow
	mov	bp,offset cgroup:rsss_write_shadow
	call	gen_smi_for_gpnv
rsss_06:
;;	mov	bp,FLUSH_ALL_CACHE_FUNC	; flush all cache
;;	call	cgroup:dword ptr runtime_interface_routine
;;	mov	bp,F000_READ_RAM_WRITE_ROM_FUNC; F000 shadow Read Only
;;	call	cgroup:dword ptr runtime_interface_routine
					; <(CORE0221)
	pop	bp
	pop	ax			; AH, AL = Change Status, Type
	pop	dx			; DX = handle# of changed structure
	call	get_ebda		; DS = EBDA
	mov	xdgroup:smbios_change_status,ah
	mov	xdgroup:smbios_change_type,al
	mov	xdgroup:smbios_change_handle,dx
; Shadow RAM is updated with new information
; Update the GPNV
	push	cs
	pop	es
	movzx	edi,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBStructuresStart; ES:EDI = ptr to start of SMBIOS Date Structures in Shadow RAM
	movzx	ecx,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd; ES:ECX = ptr to end of SMBIOS Date Structures in Shadow RAM + 1
	sub	ecx,edi				; ECX = size of SMIBIOS Data Structures in BYTEs
	lds	si,dword ptr [ebp+06h]		; DS:SI = ptr to scratch buffer
	movzx	esi,si				; DS:ESI = ptr to scratch buffer
	push	fs
	push	gs
	mov	fs,word ptr [ebp+0Ch]		; FS = Dmi Selector
	mov	gs,word ptr [ebp+0Eh]		; GS = Bios Selector
; DS:ESI = ptr to scratch buffer long enough to contain the whole GPNA Area
; ES:EDI = ptr to buffer containing the data of the new GPNV area
; ECX	 = the new GPNV area size in BYTEs
; FS	 = GPNV Selector
; GS	 = BIOS Selector
	mov	bx,gpnv_dmi_data_bit		; attribute for SMBIOS Data Area in GPNV
						; (CORE0072+)>
	push	ds
	push	ecx
	push	esi
	push	fs
	pop	ds				; ds = GPNV selector
	mov	ah,get_gpnv_attribute_information_func
	call	cgroup:dword ptr gpnv_interface_routine; get handle# from attribute
	mov	dx,gpnv_dmi_data_bit		; attribute for SMBIOS Data Area in GPNV
	pop	esi
	pop	ecx
	pop	ds
	jc	rsss_10
						; <(CORE0072+)

	mov	ah,update_gpnv_attribute_func	; func#
	call	cgroup:dword ptr gpnv_interface_routine; update concerned GPNV area
rsss_10:
	pop	gs
	pop	fs
	jc	short rsss_c03_00		; error in updating GPNV
rsss_04:
	popad
	xor	ax,ax			; successful
rsss_01:
	pop	ds
	pop	es
	ret
rsss_02:
	popad
	mov	ax,RT_DMI_BAD_PARAMETER
	jmp	short rsss_01
rsss_03:
	popad
	mov	ax,RT_DMI_INVALID_HANDLE
	jmp	short rsss_01
rsss_c03_00:
	popad
	mov	ax,RT_DMI_ADD_STRUCTURE_FAILED
	jmp	short rsss_01
;---------------------------------------;
rsss_cmd_03:
; command 03h..add the structure to the SMBIOS structure pool
; DS:SI = ptr to given DMI data buffer
; check whether the any more handle is available
	mov	bx,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc; #of valid runtime structures
	cmp	bx,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRomStruc; handle available ?
	jae	short rsss_c03_00	; handle not available, error
; check whether the given new handle# is the handle# of the new structure
	push	si
	add	si,offset SMBIOS_FUNC52_BUFFER_STRUC.dStructureHeader; DS:SI = ptr to new structure header
	cmp	bx,ds:word ptr (DMIHDR_STRUC ptr [si]).wHandle; given handle# matches ?
	pop	si
	jnz	short rsss_03		; invalid handle
; handle available, check whether the required space is available
	mov	ax,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBAvailableStructuresEnd; ptr to end of available structures space + 1
	mov	di,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd; DI = ptr to current structures end + 1
	sub	ax,di			; AX = space available in bytes
	jbe	short rsss_c03_00	; space not available
; BX	= #of valid runtime structures
; AX	= #of bytes available for the new structure
; CS:DI = ptr to current structures end + 1
; DS:SI = ptr to given DMI data buffer
	mov	cx,ds:word ptr (SMBIOS_FUNC52_BUFFER_STRUC ptr [si]).wDataLength; new struc length in bytes
	cmp	ax,cx			; availabe space enough for the new structure ?
	jb	short rsss_c03_00	; available space not enough for the new structure
	add	si,offset SMBIOS_FUNC52_BUFFER_STRUC.dStructureHeader; DS:SI = ptr to start of new structure
	push	cs
	pop	es
; BX	= #of valid runtime structures
; CX	= new structure length in bytes
; ES:DI = ptr to current structures end + 1
; DS:SI = ptr to new structure
	mov	dx,ds:word ptr (DMIHDR_STRUC ptr [si]).wHandle; DX = handel# of structure being changed
	mov	ax,SMBIOS_SINGLE_STRUCTURE_AFFECTED*256+SMBIOS_ONE_MORE_STRUCTURE_ADDED
					; AH, AL = SMBIOS Change Status, Type
	push	dx
	push	ax
	push	bp
					; (CORE0221)>
;;	mov	bp,F000_READ_X_WRITE_RAM_FUNC; F000 shadow Write enabled
;;	call	cgroup:dword ptr runtime_interface_routine
;;	push	cx
;;	rep	movs es:byte ptr [di],ds:byte ptr [si]; add the new structure to F000 Shadow
;;	pop	cx
;;; BX	= #of valid runtime structures
;;; ES:DI = ptr to updated structures end + 1
;;; CX	= new structure length in bytes
;;; update necessary parameters
;;	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd,di; update ptr to current structures + 1
;;	inc	bx			; #of valid runtime structures
;;	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc,bx; update #of valid runtime structures
;;	push	cs
;;	pop	ds
;;	mov	si,offset cgroup:smbios_table_entry_point_struc; DS:SI = ptr to SMBIOS Table Entry
;;; DS:SI = ptr to SMBIOS Table Entry Point Structure
;;	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,cx; update total #of data structures
;;	cmp	cx,ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize; max structure size changed ?
;;	jbe	short rsss_c03_01	; max structure size does not change
;;	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize,cx; update max structure size
;;rsss_c03_01:
;;; DS:SI = ptr to SMBIOS Table Entry Point Structure
;;; update the checksum in SMBIOS Table Entry Point
;;	call	update_ieps_checksum	; update checksum in IEPS
;;	call	update_eps_checksum	; update checksum in EPS
	push	bp
	mov	bp,offset cgroup:rsss_add_struc
	call	gen_smi_for_gpnv
	pop	bp
					; <(CORE0221)
	jmp	rsss_06
;---------------------------------------;
rsss_cmd_04:
; command 04h..delete the structure from the SMBIOS structure pool
; DS:SI = ptr to given DMI data buffer
; check whether the given structure exists
	add	si,offset SMBIOS_FUNC52_BUFFER_STRUC.dStructureHeader; DS:SI = ptr to new structure header
	mov	cx,ds:word ptr (DMIHDR_STRUC ptr [si]).wHandle; given handle#
; CX = handle# (0-based) of the given structure
	push	cx
	call	get_structure_details	; get the concerned structure details in RAM
	pop	dx
; DS:SI	= ptr to start of concerned structure
; CX	= structure length including terminator
; DX	= handle# of the structure to be deleted
	push	ds
	pop	es
	mov	di,si			; ES:DI = ptr to concerned structure in RAM
	jnc	short rsss_c04_01	; structure exists
	jmp	rsss_03			; error, structure does not exist
rsss_c04_01:
; ES:DI	= ptr to start of concerned structure in RAM to be deleted
; CX	= length including terminator of the concerned structure in RAM to be deleted
; DX	= handle# of the structure to be deleted
	push	ds
	call	get_ebda		; DS = EBDA
	mov	ah,xdgroup:smbios_change_status; AH = SMBIOS Change Status
	mov	al,xdgroup:smbios_change_type; AL = SMBIOS Change Type
	mov	dx,xdgroup:smbios_change_handle; DX = SMBIOS Change Handle
	pop	ds
	push	dx
	push	ax
	push	bp
					; (CORE0221)>
;;	mov	bp,F000_READ_X_WRITE_RAM_FUNC; F000 shadow Write enabled
;;	call	cgroup:dword ptr runtime_interface_routine
;;	mov	bx,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd; BX = ptr to current structures end + 1
;;	push	bx
;;	sub	bx,cx			; update current structures end + 1 after deletion
;;	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd,di; update current structures end + 1
;;	pop	bx
;;	push	cs
;;	pop	ds			; DS:BX = current structures end + 1
;;	mov	si,di
;;	add	di,cx			; DS:SI = start of data to be moved
;;; DS:SI = start of data to be moved
;;; DS:BX = end of data to be moved + 1
;;; ES:DI = start of destn
;;; DX	= handle# of the structure to be deleted
;;; move up all the following structures and update the handles of all the
;;; following structures
;;rsss_c04_00:
;;; DS:SI = ptr to next structure to be moved
;;; DX	= new handle# of the structure to be moved
;;	mov	ds:word ptr (DMIHDR_STRUC ptr [si]).wHandle,dx; update handle of next structure
;;	inc	dx			; update handle#
;;	call	GetStrucLen		; CX = length of structure to be moved
;;	rep	movs es:byte ptr [di],ds:byte ptr [si]; move the structure
;;	cmp	si,bx			; end of movement reached ?
;;	jb	short rsss_c04_00	; not yet
;;; the concerned structure is deleted, all the following structures are moved up
;;; update necessary parameters
;;	mov	cx,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc; #of valid runtime structures before deletion
;;	dec	cx
;;	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc,cx; #of valid runtime structures after deletion
;;	mov	si,offset cgroup:smbios_table_entry_point_struc; DS:SI = ptr to SMBIOS Table Entry
;;; DS:SI = ptr to SMBIOS Table Entry Point Structure
;;	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,cx; update total #of data structures
;;	push	si
;;	mov	si,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBStructuresStart; DS:SI = ptr to start of structures
;;	mov	di,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd; DS:DI = ptr to end of structures
;;	call	get_smbios_structures_details	; AX = largest structure size
;;	pop	si
;;; DS:SI = ptr to SMBIOS Table Entry Point Structure
;;	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize,ax; update largest structure size
;;; update the checksum in SMBIOS Table Entry Point
;;	call	update_ieps_checksum	; update checksum in IEPS
;;	call	update_eps_checksum	; update checksum in EPS
	push	bp
	mov	bp,offset cgroup:rsss_del_struc
	call	gen_smi_for_gpnv
	pop	bp
					; <(CORE0221)
	jmp	rsss_06
;---------------------------------------;
rt_set_smbios_struc	endp

					; (CORE0221+)>
;---------------------------------------;
gen_smi_for_gpnv:
	; check if SMI possible ?
	push	ds
	push	0f000h
	pop	ds			; ds = 0f000h
;	test	cgroup:byte ptr _module_bit_map,gpc_bitm; gpc present ?
	test	byte ptr ds:[0f688h],gpc_bitm	; gpc present ?
	jz	gsfg_no_smi		; no..
;	test	cs:byte ptr bios_scratch,bios_post_complete_bit; POST/Runtime ?
	test	byte ptr ds:[0e2c1h],bios_post_complete_bit; POST/Runtime ?
	jz	gsfg_no_smi		; POST..
	pop	ds

	; SMI possible..
	db	9ah			; far call F000:EEE4
	dw	0eee4h
	dw	0f000h
gsfg_exit:
	ret

gsfg_no_smi:
	pop	ds
	push	cs			; far call
	call	bp
	jmp	short gsfg_exit
;---------------------------------------;
rsss_prot_shadow:
	mov	bp,FLUSH_ALL_CACHE_FUNC	; flush all cache
	call	cgroup:dword ptr runtime_interface_routine
	mov	bp,F000_READ_RAM_WRITE_ROM_FUNC; F000 shadow Read Only
	call	cgroup:dword ptr runtime_interface_routine
	ret				; NEAR return
;---------------------------------------;
rsss_write_shadow:
	mov	bp,F000_READ_X_WRITE_RAM_FUNC; F000 shadow Write enabled
	call	cgroup:dword ptr runtime_interface_routine
	rep	movs es:byte ptr [di],ds:byte ptr [si]; move the data to F000 Shadow
	; (CORE0221) Make sure shadow accessing in one shot during SMM
	call	rsss_prot_shadow
	retf
;---------------------------------------;
rsss_add_struc:
	mov	bp,F000_READ_X_WRITE_RAM_FUNC; F000 shadow Write enabled
	call	cgroup:dword ptr runtime_interface_routine
	push	cx
	rep	movs es:byte ptr [di],ds:byte ptr [si]; add the new structure to F000 Shadow
	pop	cx
; BX	= #of valid runtime structures
; ES:DI = ptr to updated structures end + 1
; CX	= new structure length in bytes
; update necessary parameters
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd,di; update ptr to current structures + 1
	inc	bx			; #of valid runtime structures
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc,bx; update #of valid runtime structures
	push	cs
	pop	ds
	mov	si,offset cgroup:smbios_table_entry_point_struc; DS:SI = ptr to SMBIOS Table Entry
; DS:SI = ptr to SMBIOS Table Entry Point Structure
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,cx; update total #of data structures
	cmp	cx,ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize; max structure size changed ?
	jbe	short rsss_c03_01	; max structure size does not change
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize,cx; update max structure size
rsss_c03_01:
; DS:SI = ptr to SMBIOS Table Entry Point Structure
; update the checksum in SMBIOS Table Entry Point
	call	update_ieps_checksum	; update checksum in IEPS
	call	update_eps_checksum	; update checksum in EPS
	; (CORE0221) Make sure shadow accessing in one shot during SMM
	call	rsss_prot_shadow
	retf
;---------------------------------------;
rsss_del_struc:
	mov	bp,F000_READ_X_WRITE_RAM_FUNC; F000 shadow Write enabled
	call	cgroup:dword ptr runtime_interface_routine
	mov	bx,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd; BX = ptr to current structures end + 1
	push	bx
	sub	bx,cx			; update current structures end + 1 after deletion
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd,di; update current structures end + 1
	pop	bx
	push	cs
	pop	ds			; DS:BX = current structures end + 1
	mov	si,di
	add	di,cx			; DS:SI = start of data to be moved
; DS:SI = start of data to be moved
; DS:BX = end of data to be moved + 1
; ES:DI = start of destn
; DX	= handle# of the structure to be deleted
; move up all the following structures and update the handles of all the
; following structures
rsss_c04_00:
; DS:SI = ptr to next structure to be moved
; DX	= new handle# of the structure to be moved
	mov	ds:word ptr (DMIHDR_STRUC ptr [si]).wHandle,dx; update handle of next structure
	inc	dx			; update handle#
	call	GetStrucLen		; CX = length of structure to be moved
	rep	movs es:byte ptr [di],ds:byte ptr [si]; move the structure
	cmp	si,bx			; end of movement reached ?
	jb	short rsss_c04_00	; not yet
; the concerned structure is deleted, all the following structures are moved up
; update necessary parameters
	mov	cx,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc; #of valid runtime structures before deletion
	dec	cx
	mov	cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBNumRuntimeStruc,cx; #of valid runtime structures after deletion
	mov	si,offset cgroup:smbios_table_entry_point_struc; DS:SI = ptr to SMBIOS Table Entry
; DS:SI = ptr to SMBIOS Table Entry Point Structure
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc,cx; update total #of data structures
	push	si
	mov	si,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBStructuresStart; DS:SI = ptr to start of structures
	mov	di,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBCurrentStructuresEnd; DS:DI = ptr to end of structures
	call	get_smbios_structures_details	; AX = largest structure size
	pop	si
; DS:SI = ptr to SMBIOS Table Entry Point Structure
	mov	ds:word ptr (SMB_TABLE_HEADER_STRUC ptr [si]).wMaxStrucSize,ax; update largest structure size
; update the checksum in SMBIOS Table Entry Point
	call	update_ieps_checksum	; update checksum in IEPS
	call	update_eps_checksum	; update checksum in EPS
	; (CORE0221) Make sure shadow accessing in one shot during SMM
	call	rsss_prot_shadow
	retf
					; <(CORE0221+)
;-----------------------------------------------------------------------;
;		Func 53h..RT_GET_SMBIOS_STRUC_CHANGE_INFO		;
;-----------------------------------------------------------------------;
; This function returns the information about what type of SMBIOS	;
; structure-change occurred.						;
; Input:  [EBP+00] = Function number (53h)				;
;         [EBP+02] = WORD FAR *DmiChangeStructure			;
;         [EBP+06] = WORD DmiSelector					;
;         [EBP+08] = WORD BiosSelector					;
; Output: AX       = Zero if successful					;
;		     non-zero return code if unsuccessful   		;
; Destroys: Nothing							;
;-----------------------------------------------------------------------;
rt_get_smbios_struc_change_info	proc	near
	push	es
	push	ds
	push	di
	les	di,dword ptr [ebp+02h]	; ES:DI = ptr to DMI Change Structure buffer
	call	get_ebda		; DS = EBDA
	xor	ax,ax
	xchg	ah,xdgroup:smbios_change_status; AH = SMBIOS Change Status
	xchg	al,xdgroup:smbios_change_type; AL = SMBIOS Change Type
	mov	es:byte ptr (SMBIOS_FUNC53_BUFFER_STRUC ptr [di]).bChangeStatus,ah
	mov	es:byte ptr (SMBIOS_FUNC53_BUFFER_STRUC ptr [di]).bChangeType,al
	push	ax
	cmp	ah,SMBIOS_MULTIPLE_STRUCTURE_AFFECTED
	mov	ax,0000h		; DO NOT USE xor ax,ax !!!!!!!!!!!!!!!!
					; Flags has the information of prev CMP
	xchg	ax,xdgroup:smbios_change_handle; AX = handle# of changed structure
	jnz	short rgssci_00		; single structure affected
	xor	ax,ax			; make handle# 00 for multiple structures change
rgssci_00:
	mov	es:word ptr (SMBIOS_FUNC53_BUFFER_STRUC ptr [di]).wChangeHandle,ax
	pop	ax			; AH, AL = change status, type
	cmp	ah,SMBIOS_NO_CHANGE	; any change in status ?
	mov	ax,RT_DMI_SUCCESS	; successful
	jnz	short rgssci_01		; change in status
	mov	ax,RT_DMI_NO_CHANGE	; no change in status, return with error code
rgssci_01:
	pop	di
	pop	ds
	pop	es
	ret
rt_get_smbios_struc_change_info	endp
;-----------------------------------------------------------------------;
;		Func 54h..RT_SMBIOS_CONTROL				;
;-----------------------------------------------------------------------;
; This function returns the information about what type of SMBIOS	;
; structure-change occurred.						;
; Input:  [EBP+00] = Function number (54h)				;
;         [EBP+02] = SubFunction					;
;         [EBP+04] = WORD FAR *Data					;
;         [EBP+08] = Control						;
;         [EBP+0A] = WORD DmiSelector					;
;         [EBP+0C] = WORD BiosSelector					;
; Output: AX       = Zero if successful					;
;		     non-zero return code if unsuccessful   		;
; Destroys: Nothing							;
;-----------------------------------------------------------------------;
rt_smbios_control:
					; (CORE0218+)>
;	mov	ax,RT_PNP_UNSUPPORTED	;Return code for unsupported func
if MKF_EVENT_LOG
	push	ds
	push	es
	pushad
	test	byte ptr [ebp+08h],01h	; Bit-0 = 0, validate parameter
					;	  1, Set structure immediately
	jz	short rsc_00		; validate parameters (unsupport)
	cmp	byte ptr [EBP+02],02h
	ja	rsc_00
	cmp	byte ptr [EBP+02],01h	;DMI_CONTROL_LOGGING ?
	jne	rsc_02
	les	di,dword ptr [ebp+02h]	; ES:DI = ptr to Data
	mov	edx,dword ptr es:[di]	; get AND/OR value
	mov	cl,1			;subfunction 1
call_special:
	mov	ax,'PB'			;special function
	mov	bx,'GV'			;special function
	int	15h
	popad
	xor	ax,ax			; successful
rsc_01:
	pop	es
	pop	ds
	ret

rsc_02:					;DMI_CLEAR_EVENT
	mov	cl,2			;subfunction 2
	jmp	call_special
	jmp	rsc_01
rsc_00:
	popad
	mov	ax,RT_DMI_BAD_PARAMETER
	jmp	rsc_01
else
	mov	ax,RT_DMI_FUNCTION_NOT_SUPPORTED; error code for corrupted GPNV
	ret
endif ;MKF_EVENT_LOG
					; <(CORE0218+)
	ret
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
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
	public	_SMBRUN_ENDS
_SMBRUN_ENDS	label	byte		; marks end of module
;---------------------------------------------------------------;
_text	ends
END
