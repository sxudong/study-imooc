	page	,132
	title	SUBROUTINES USED IN DMI
;---------------------------------------------------------------;
; NOTE:	Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.
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
;---------------------------------------;
	include	smb.cfg
	include	smb.equ
	include	smbstruc.def
;---------------------------------------;
	extrn	smbios_table_entry_point_struc:byte
	extrn	smbios_internal_data:byte
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_SMBSUB_STARTS
_SMBSUB_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;				GetStrucLen				;
; This routine returns the length of the given structure.		;
; input :								;
;	DS:SI	ptr to start of the given structure			;
; output:								;
;	CX	length of structure in bytes				;
; register destroyed : CX						;
;-----------------------------------------------------------------------;
	public	GetStrucLen
GetStrucLen		proc	near
	push	si
	push	ax
	movzx	cx,ds:byte ptr (DMIHDR_STRUC ptr [si]).bLength; CX = length of formatted part
;  calculate the length of variable portion
;  search for two NULLs except for Struc type 5 and 15
	mov	al,ds:byte ptr (DMIHDR_STRUC ptr [si]).bType; AL = structure type
	push	si
	add	si,cx				; DS:SI = ptr to end of formatted part
						; (CORE0072-)>
;;      cmp     al,05                           ; struc type 5 ?
;;      jz      short gsl_01                    ; yes
;;      cmp     al,15                           ; struc type 15 ?
;;      jz      short gsl_01                    ; yes
;;;  struc type is neither 05 nor 15
						; <(CORE0072-)
gsl_00:
	lodsb					; get next byte
	cmp	al,00h				; NULL ?
	jnz	short gsl_00			; yes
	lodsb					; check for two consecutive NULLs
	cmp	al,00h				; NULL ?
	jnz	short gsl_00
gsl_01:
;  CS:SI = ptr to end of structure + 1
	pop	cx				; CS:CX = ptr to start of structure
	sub	si,cx				; SI = length of structure
	mov	cx,si				; CX = length of structure
	pop	ax
	pop	si
	ret
GetStrucLen		endp
;-----------------------------------------------------------------------;
;			GET_SMBIOS_STRUCTURES_DETAILS			;
; This routine returns the SMBIOS structure details.			;
; input :								;
;	DS:SI	ptr to start of the structures				;
;	DS:DI	ptr to end of the structures				;
; output:								;
;	AX	size of the largest structure				;
;	CX	total #of structures present				;
;  register destroyed : AX CX						;
;-----------------------------------------------------------------------;
	public	get_smbios_structures_details
get_smbios_structures_details	proc	near
	push	si
	xor	ax,ax				; structure length of largest structure
	xor	cx,cx				; #of structures
fsd_02:
	push	ax
	mov	al,ds:byte ptr (DMIHDR_STRUC ptr [si]).bType; AL = structure type
	cmp	al,MAXM_SMBIOS_STRUCTURE_TYPE	; valid structure type ?
	pop	ax
	ja	short fsd_00			; invalid structure type
	push	cx
	call	GetStrucLen			; CX = curr structure length
	cmp	ax,cx				; find the larger of AX & CX
	jae	short fsd_01			; AX is larger
	mov	ax,cx				; CX is larger, put it in AX
fsd_01:
	add	si,cx				; DS:SI = ptr to next structure
	pop	cx
	inc	cx				; update #of structures
	cmp	si,di				; end of structure reached ?
	jb	short fsd_02			; no, so continue
fsd_00:
	pop	si
	ret
get_smbios_structures_details	endp
;-----------------------------------------------------------------------;
;			GET_STRUCTURE_DETAILS				;
;  this routine returns the concerned structure details.		;
;  input :								;
;	CX	given structure# (0-based)				;
;  output:								;
;	CY	error, structure not found				;
;	NC	successful						;
;		DS:SI	ptr to start of concerned structure		;
;		CX	structure length including terminator		;
;		AX	next structure# (FFFF if this is the last one)	;
;  register destroyed : AX CX SI DS					;
;-----------------------------------------------------------------------;
	public	get_structure_details
get_structure_details	proc	near
	mov	si,offset cgroup:smbios_table_entry_point_struc
	mov	ax,cgroup:(SMB_TABLE_HEADER_STRUC ptr [si]).wNumSMBStruc; AX = #of DMI structures present
	dec	ax				; #of structures (0-based)
	cmp	cx,ax				; valid structure# ?
	ja	short gsd_01			; invalid structure#
	push	cx
	jb	short gsd_00			; valid structure#
; valid struc# but this is the last structure
	mov	cx,0fffeh
gsd_00:
	inc	cx				; CX = return value of next structure#
	pop	ax				; AX = given structure# (0-based)
	push	cx				; save next structure#
	inc	ax				; AX = given structure# (1-based)
; AX = given structure# (1-based)
	push	cs
	pop	ds
	mov	si,cgroup:word ptr (SMB_INTERNAL_DATA_STRUC ptr smbios_internal_data).wSMBStructuresStart; DS:SI = ptr to start of SMBIOS structures
	xor	cx,cx				; init length of structure
gsd_04:
	add	si,cx				; DS:SI = ptr to next structure
	call	GetStrucLen			; CX = length of the structure
	dec	ax				; decrement the struc #
	jnz	short gsd_04			; check the next structure
	pop	ax				; AX = next structure#
	clc					; NC, successful
; DS:SI = ptr to the concerned structure requested by user
; CX = structure length in bytes
; AX = next structure# (FFFF if this is the last structure)
gsd_02:
; NC/CY = ok/error
	ret
gsd_01:
	stc					; CY, error
	jmp	short gsd_02
get_structure_details	endp
;-----------------------------------------------------------------------;
;			GET_STRING_DETAILS				;
;  this routine copies the source string to the destn taking into	;
;  account of the length available, padding it with blanks if needed,	;
;  etc.									;
;  input :								;
;	DS:SI	ptr to the start of structure				;
;	CX	given string#						;
;		(it is assured to be non-zero i.e. string exists)	;
;  output:								;
;	DS:SI	ptr to the concerned string within the structure	;
;	CX	concerned string length excluding NULL in bytes		;
;  registed destroyed : SI						;
;-----------------------------------------------------------------------;
	public	get_string_details
get_string_details	proc	near
	push	bx
	movzx	bx,ds:(DMIHDR_STRUC ptr [si]).bLength; formatted length
gsd_00:
	add	si,bx				; CS:SI = ptr to next string
; CX = concerned string# (1-based)
	push	cx
	call	get_string_length		; CX = string length in bytes
	mov	bx,cx				; BX = string length
	inc	bx				; include NULL
	pop	cx
	loop	gsd_00
	dec	bx				; exclude NULL
	mov	cx,bx				; CX = string length
	pop	bx
	ret
get_string_details	endp
;-----------------------------------------------------------------------;
;				COPY_STRING				;
;  this routine copies the source string to the destn taking into	;
;  account of the length available, padding it with blanks if needed,	;
;  etc.									;
;  input :								;
;	DS:SI	ptr to the source string				;
;	ES:DI	ptr to the destn string					;
;	CX	length available excluding NULL				;
;  output:								;
;	none								;
;  registed destroyed : ALL except DS, ES				;
;-----------------------------------------------------------------------;
	public	copy_string
copy_string	proc	near
; CX = length available excluding NULL
cs_01:
	lods	ds:byte ptr [si]	; get nest source byte
	or	al,al			; end of source ?
	jz	short cs_00		; yes
	stos	es:byte ptr [di]	; copy it to destn
	loop	cs_01
; control will come here if the available space is less than or equal to the
; source string length
	jmp	short cs_02		; exit
cs_00:
; control will come here if the available space is gretare than to the
; source string length
; the destn string needs to be padded with blanks
	mov	al,20h			; padd with CX #of Blanks
	rep	stosb
cs_02:
	ret
copy_string	endp
;-----------------------------------------------------------------------;
;			UPDATE_IEPS_CHECKSUM				;
; this routine updates the checksum in IEPS of SMBIOS Table Entry Point.;
; input :								;
;	DS:SI	ptr to SMBIOS Structure Table Entry Point		;
; output:								;
;	none								;
; register destroyed : none						;
;-----------------------------------------------------------------------;
	public	update_ieps_checksum
update_ieps_checksum	proc	near
;  calculate the intermediate checksum of IEPS
	pusha
	push	si
	mov	ds:byte ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bIntChecksum,00; IEPS checksum
	mov	cx,IEPS_LENGTH		; length of IEPS
	movzx	ax,ds:byte ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bLength; EPS size
	sub	ax,cx
	add	si,ax			; DS:SI = ptr to start of IEPS
	xor	ah,ah			; init checksum
spi_00:
	lods	ds:byte ptr [si]	; get next byte
	add	ah,al
	loop	spi_00
	neg	ah
	pop	si
	mov	ds:byte ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bIntChecksum,ah; IEPS checksum
	popa
	ret
update_ieps_checksum	endp
;-----------------------------------------------------------------------;
;			UPDATE_EPS_CHECKSUM				;
; this routine updates the checksum in EPS of SMBIOS Table Entry Point.	;
; input :								;
;	DS:SI	ptr to SMBIOS Structure Table Entry Point		;
; output:								;
;	none								;
; register destroyed : none						;
;-----------------------------------------------------------------------;
	public	update_eps_checksum
update_eps_checksum	proc	near
	pusha
	mov	ds:byte ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bChecksum,00; EPS checksum
;  calculate the checksum of EPS of the SMBIOS table entry point structure
	movzx	cx,ds:byte ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bLength; entry point stucture size
	xor	ah,ah			; init cheksum
	push	si
spi_01:
	lods	ds:byte ptr [si]	; get next byte
	add	ah,al
	loop	spi_01
	pop	si
	neg	ah
	mov	ds:byte ptr (SMB_TABLE_HEADER_STRUC ptr [si]).bChecksum,ah; EPS checksum
	popa
	ret
update_eps_checksum	endp
;-----------------------------------------------------------------------;
;				GET_EBDA				;
; this routine returns the Extended BIOS Data Area Segment.		;
; input :								;
;	none								;
; output:								;
;	DS	EBDA segment						;
; register destroyed : DS						;
;-----------------------------------------------------------------------;
	public	get_ebda
get_ebda	proc	near
	push	0040h
	pop	ds
	mov	ds,ds:word ptr [000eh]	; DS = EBDA
	ret
get_ebda	endp
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
;		SUBROUTINES USED BY ROUTINES IN THIS FILE		;
;-----------------------------------------------------------------------;
;			GET_STRING_LENGTH				;
;  this routine copies the source string to the destn taking into	;
;  account of the length available, padding it with blanks if needed,	;
;  etc.									;
;  input :								;
;	DS:SI	ptr to the string					;
;  output:								;
;	CX	concerned string length excluding NULL in bytes		;
;  registed destroyed : CX						;
;-----------------------------------------------------------------------;
get_string_length:
	push	si
	push	ax
	xor	cx,cx			; init the string length
gsl_00:
	inc	cx			; update string length
	lodsb				; get next byte
	or	al,al			; end ?
	jnz	short gsl_00		; no
	dec	cx			; exclude NULL from string length
	pop	ax
	pop	si
	ret
;-----------------------------------------------------------------------------;
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
	public	_SMBSUB_ENDS
_SMBSUB_ENDS	label	byte		; marks start of module
;---------------------------------------------------------------;
_text	ends
END
