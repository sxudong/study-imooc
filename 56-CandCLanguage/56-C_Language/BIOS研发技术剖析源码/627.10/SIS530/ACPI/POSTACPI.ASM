	page	,132
	title	ACPI POST HOOKS
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
	include	mbiosequ.equ
	include	makeflag.equ
	include	oemmake.equ
	include	acpi.equ
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;-----------------------------------------------------------------------;
;				ACPI_OEM_ID				;
; This is the ACPI OEM ID string. Edit this string according to the OEM	;
; ID. This string MUST BE EXACTLY 6 BYTES IN LENGTH.			;
;-----------------------------------------------------------------------;
acpi_oem_id	db	'AMI   '	; exactly 6 bytes
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
;-----------------------------------------------------------------------;
; CODE BELOW THIS NEED NO PORTING..............GIVEN HERE FOR REFERENCE	;
;-----------------------------------------------------------------------;
;			BUILD_ACPI_TABLE				;
; Check Point	: 8C							;
; This routine is called from ADJUST_SETUP routine after E820 tables are;
; build properly.							;
; This routine uncompresses the ACPI Table module and ACPI AML module	;
; and give control to ACPI Table module to build the ACPI tables, copy	;
; the table and AML code to proper memory area to be accessible by OS.	;
; This routine will only be called if ACPI support is enabled in BIOS	;
; and ACPI Aware OS serup question is enabled in Setup.			;
; input :								;
;	none								;
; output:								;
;	none								;
; register destroyed : none						;
;-----------------------------------------------------------------------;

IF	MKF_ACPI_SUPPORT
	extrn	scratch_segment:word
	extrn	uncom_segment:word
	extrn	uncompress_general_module:near
	extrn	clear_64k_memory:near
	extrn	go_to_flat_mode_stack:near
	extrn	comeback_from_flat_mode_stack:near

	extrn	rsd_ptr_header:byte
	extrn	rsdptr_oemid:byte
	extrn	rsdt_ptr:dword
	extrn	rsdptr_start:byte
	extrn	rsdptr_end:byte
	extrn	rsdptr_checksum:byte
	extrn	facs_wake_vector_addr:dword
	extrn	info_start:byte
	extrn	info_end:byte
	extrn	rsdptr_table_length:abs
ENDIF

	public	build_acpi_table
build_acpi_table:
IF	MKF_ACPI_SUPPORT
	pushf
	cli
; Build Tables in CLI Mode	
	pushad
	push	es
	push	ds
; clear the segments where the two ACPI modules will be uncompressed
	mov	ax,cgroup:uncom_segment
	mov	es,ax
	push	ax
	call	clear_64k_memory
	pop	ax
ife MKF_ML_MODULE			; (CORE0220)>
	add	ah,10h
	mov	es,ax
	call	clear_64k_memory
endif					; <(CORE0220)
	call	get_start_acpi_table_address; EAX = 32-bit start destn address of ACPI table
	jc	bat_01			; error
	push	eax
;-----------------------------------------------------------------------;
; Uncompress ACPI Tables Module
	mov	ds,cgroup:scratch_segment
	mov 	es,cgroup:uncom_segment
	mov	bl,acpi_table_module_id	;Module ID
	call	uncompress_general_module
	jnz	short bat_00		; module not found
; DS:SI = ptr to where ACPI module is uncompressed
; CX	= length of ACPI module in bytes
	push	ds
;----------------------------------------------------------------------------;
; Uncompress AML Module
	mov	ds,cgroup:scratch_segment
	mov 	ax,cgroup:uncom_segment
if MKF_ML_MODULE			; (CORE0220)>
	add	cx,0fh
	shr	cx,4			; alligned to next para
	add	ax,cx			; give the segment:0 in uncom_segment (same segment with ACP)
else
	add	ah,10h
endif					; <(CORE0220)
	mov 	es,ax
	mov	bl,acpi_aml_module_id	;Module ID
	call	uncompress_general_module
; DS:SI = ptr to where AML module is uncompressed
; CX	= length of AML module in bytes
	pop	dx			; DX = segment where ACPI module is uncompressed
bat_00:
	pop	eax
	jnz	bat_01			; module not found
if MKF_ML_MODULE			; (CORE0220+)>
	push	ax
	push	cx
	mov	ax,ds
	shl	ax,4			; get offset only
	add	ax,cx			; across 64k ?
	pop	cx
	pop	ax
	jc	short bat_01		; table + AML > 64K, not enough for ACP+AML
endif					; <(CORE0220+)
; DS:SI = ptr to where AML module is uncompressed
; CX	= length of AML module in bytes
; EAX	= 32bit start destn address of ACPI tables
	push	eax			; 32bit start destn address of ACPI tables
	push	dx			; ACPI module segment
; Do a FAR CALL to the ACPI module at offset C000h
	push	cs
	push	offset cgroup:acpi_ret
	push	dx
	push	ACPI_MODULE_ENTRY_OFFSET
	retf
acpi_ret:  	
;----------------------------------------------------------------------------;
; After returning from the Far Call EAX, has the address for the Firmware 
; Waking Vector
	mov	cgroup:facs_wake_vector_addr,eax; Update Wake Vector Field
;----------------------------------------------------------------------------;
; Copy Stuff to the Appropriate Area above 1 Meg
; ECX has the Address where table should start	
	call	go_to_flat_mode_stack
	pop	si			; SI = ACPI module segment
	pop	edi
	push	edi
	movzx	esi,si
	shl	esi,4			; Get Physical Address
	mov	ecx,ACPI_MODULE_ENTRY_OFFSET; #of bytes to be copied
	rep	movs byte ptr es:[edi],byte ptr ds:[esi]
	call	comeback_from_flat_mode_stack
;----------------------------------------------------------------------------;
	pop	eax			; 32bit start destn address of ACPI tables
	mov	cgroup:rsdt_ptr,eax	; Init ACPI table start addr in RSDPTR table
;---------------------------------------;
; put the ACPI OEM ID here..it has to be exactly 6 bytes
	mov	si,offset cgroup:acpi_oem_id
	mov	di,offset cgroup:rsdptr_oemid
	push	cs
	pop	es
	mov	cx,6			; 6 bytes
	rep	movs es:byte ptr [di],cs:byte ptr [si]
;---------------------------------------;
	mov	si,offset cgroup:rsd_ptr_header
	mov	cs:dword ptr [si],' DSR'	; put 'RSD PTR ' signature
	mov	cs:dword ptr [si+4],' RTP'
	mov	cx,rsdptr_table_length
	xor	ax,ax
	mov	byte ptr cgroup:rsdptr_checksum,al; init checksum with 00
checksum_loop:
        lodsb	cgroup:byte ptr [si]
        add     ah,al
        loop    checksum_loop
        neg	ah
	mov	byte ptr cgroup:rsdptr_checksum,ah
;----------------------------------------------------------------------------;
bat_01:
	pop	ds
	pop	es
	popad
	popf
	ret
ELSE
	ret
ENDIF
;-----------------------------------------------------------------------;
;			GET_START_ACPI_TABLE_ADDRESS			;
; This routine returns the 32Bit physical address where ACPI tables will;
; start in the memory.							;
; Input :								;
;	none								;
; Output:								;
;	NC	ok							;
;		EAX	32bit physical address of start of ACPI Tables	;
;	CY	error							;
;		EAX	Invalid						;
; Register Destroyed : EAX						;
;-----------------------------------------------------------------------;
IF	MKF_ACPI_SUPPORT
get_start_acpi_table_address		proc	near
	push	esi
	push	edi

	push	ebx
	push	ecx
	push	edx

	push	ds
	push	es
	
	xor	ebx,ebx			; mov	ebx,0h
	mov	edx,534d4150h		; Signature SMAP
	mov	es,cgroup:scratch_segment
next_range:	
	mov	ecx,014h
	xor	edi,edi
	mov	eax,0000e820h
	int	15h
	cmp	ah,86h
;;	jz	func_not
	jz	not_found_acpi_addr

	cmp	byte ptr es:[di+10h],ram_acpi_data; ACPI Reclaim Data Area ?
	jz	found_acpi_base_address
	
	or	ebx,ebx			; End of Mem Range reached ?
	jnz	next_range		; no, continue seraching for ACPI Reclaim Data Area
	
	stc				; Error
	jmp	not_found_acpi_addr
	
found_acpi_base_address:	
	mov	eax,dword ptr es:[di+0h] ; Base Address
	clc				; ok
not_found_acpi_addr:

	pop	es
	pop	ds
	
	pop	edx
	pop	ecx
	pop	ebx
	
	pop	edi
	pop	esi
	
	ret

get_start_acpi_table_address		endp
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
