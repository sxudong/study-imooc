	page	,132
	title	EXTERNAL/RUNTIME FUNCTIONS IN SETUP
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
;---------------------------------------;
	extrn	_temp_buffer:byte
	extrn	_common_cmos_buffer:byte
	extrn	get_cmos_buffer_item:near
	extrn	set_cmos_buffer_item:near
	extrn	get_processor_info:near
;---------------------------------------;
	include	setupequ.ext
	include	setupmsg.equ
	include	makeflag.equ
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_EXTFN_STARTS
_EXTFN_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;			RUNTIME FUNCTIONS				;
;-----------------------------------------------------------------------;
;			BU_UPDATE_PROC					;
;-----------------------------------------------------------------------;
;  this routine checks whether CPU Micro code update is allowed. If not,;
;  it displays 'Disabled' as the only option and it is shadowed(user	;
;  cannot change it). If allowed, it displays 'Disabled','Enabled' and	;
;  user can select it.							;
;  input :								;
;	none								;
;  output:								;
;	ah	0 or 2..normal code to be executed i.e. allowed		;
;	ah	3.......not allowed and structure to be shown shadowed	;
;  register usage..can destroy any register except DS, ES, BP		;
;-----------------------------------------------------------------------;
IF	MKF_BUP6
	extrn	check_p6:near
	public	bu_update_proc
bu_update_proc:
	mov	ah,00h			; show normal for P6 present
	call	check_bcp_setup		; BCP/Setup ?
	jz	short bup_01		; BCP, assume P6 present
;  Setup being executed
	call	check_p6		; P6 present ?
	jz	bup_01			; P6 present
;  Intel P6 not found..
;;;;	mov	ah,00h			; force CPU Micro Code update disabled
					; AH is already 00
	mov	al,Q_BU_UPDATE
	call	set_cmos_buffer_item
	mov	ah,03h			; display shadowed
bup_01:
	retf
ELSE
	public	bu_update_proc
bu_update_proc:
	mov	ah,03h			; display shadowed
	retf
ENDIF
;-----------------------------------------------------------------------;
;			EXTERNAL FUNCTIONS				;
;-----------------------------------------------------------------------;
;			INTERNAL_CACHE_PROC				;
;-----------------------------------------------------------------------;
;  this routine checks whether internal cache is allowed. If not, it	;
;  displays 'Disabled' as the only option and it is shadowed(user	;
;  cannot change it). If allowed, it displays 'Disabled',' W-Back' and	;
;  'W-Thru' depending upon which ones are allowd.			;
;  input :								;
;	none								;
;  output:								;
;	ah	2.....normal code to be executed i.e. allowed		;
;	ah	3.......not allowed and structure to be shown shadowed	;
; 			makes cmos bits 0 in the common_cmos_buffer	;
;			dx:bx	ptr to zlist				;
;  register usage..can destroy any register except DS, ES, BP		;
;-----------------------------------------------------------------------;
	extrn	int_cache_scheme_strings:byte	; Moved to OEMSETUP.ASM
	public	internal_cache_proc
internal_cache_proc	proc	near
	call	check_bcp_setup		; BCP or Setup ?
	mov	al,03h			; all allowed for BCP
	jz	short icp_00		; BCP
;  setup being executed
	call	get_processor_info	; eax.1,0 are defined as :
					; 00 = CPU does not support int. cache.
					; 01 = w-thru int. cache only.
					; 10 = w-back int. cache only.
					; 11 = w-thru and w-back int. cache.
icp_00:
	and	ax,0003h		; bits 1,0 only are revelant.
	mov	bx,ax
	shl	bx,2			; to go to the beginning of the option
					; strings for the type(s) of int. cache
					; supported.
	add	bx,offset cgroup:int_cache_scheme_strings
	mov	dx,cs			; dx:bx points to the correct zlist.
	mov	ah,02h			; display normal.
;;	cmp	al,00h			; internal cache supported ?
;;	jnz	icp_00			; yes
;;	mov	al,Q_INTERNAL_CACHE
;;	mov	ah,0
;;	call	set_cmos_buffer_item
;;icp_00:
	retf
internal_cache_proc	endp
;-----------------------------------------------------------------------;
;		EXTERNAL CACHE PROC	; Moved to OEMSETUP.ASM
;-----------------------------------------------------------------------;
;				CHECK_BCP_SETUP				;
; this routine checks whether this function is called by BCP or Setup.	;
; input :								;
;	none								;
; output:								;
;	ZR	BCP							;
;	NZ	Setup							;
; register destroyed : none						;
;-----------------------------------------------------------------------;
	extrn	_setup_offset:word
	public	check_bcp_setup
check_bcp_setup:
	cmp	cgroup:_setup_offset,0000h; BCP/Setup ?
					; ZR = BCP, NZ = Setup
	ret
COMMENT ~
;-----------------------------------------------------------------------;
;			EXTERNAL FUNCTION FOR CPU SELECTION		;
;-----------------------------------------------------------------------;
IF	MKF_CPU_OVERRIDE
zlist_table	label	byte
	db	STR_INTEL
	db	STR_CYRIX
	db	STR_AMD
	db	STR_IBM
	db	STR_TI
	db	STR_UMC
zlist_table_end	label	byte
;---------------------------------------;
	extrn	detected_cpu_vendor:byte
	extrn	cpu_selection_table:byte
	extrn	cpu_selection_table_end:byte
	extrn	_ccp_vendor_support:byte
	public	cpu_selection_proc
cpu_selection_proc:
	mov	di,offset _temp_buffer
	push	di
	push	es
	push	ds
	pop	es
	mov	cx,0fh
	mov	al,STR_RESERVED		; init 16bytes
	rep	stosb
	mov	al,STR_AUTO
	stosb
	pop	es
	pop	di
	mov	bx,offset cgroup:zlist_table
	mov	al,cgroup:detected_cpu_vendor; detected CPU vendor# at reset
	mov	dl,al
	call	check_for_support
	jz	csp_02			; this detected vendor currently
					; not selected in the cpu utility
	call	put_in_zlist		; put detected vendor in zlist
csp_02:
	mov	si,offset cgroup:cpu_selection_table
csp_00:
	cmp	si,offset cgroup:cpu_selection_table_end
	jae	csp_01			; end
	db	2eh			; CS:
	lodsw				; AL = vendor#, AH = override vendor#
	cmp	al,dl			; match in vendor# ?
	jnz	csp_00			; yes
	mov	al,ah
	call	check_for_support
	jz	csp_00			; this override vendor currently
					; not selected in the cpu utility
	call	put_in_zlist		; put possible override vendor in zlist
	jmp	short csp_00
csp_01:
	mov	ah,02h			; use returned zlist
	mov	bx,di			; offset _temp_buffer
	push	ds
	pop	dx			; DX:BX = ptr to zlist
	retf				; must be FAR RETURN
;---------------------------------------;
;	CHECK_FOR_SUPPORT		;
;---------------------------------------;
;  input :				;
;	al	cpu vendor		;
;  output:				;
;	zr	not supported		;
;	nz	supported		;
;  register destroyed..CX		;
;---------------------------------------;
check_for_support	proc	near
	mov	ch,1
	mov	cl,al
	shl	ch,cl
	test	cgroup:byte ptr _ccp_vendor_support,ch
	ret
check_for_support	endp
;---------------------------------------;
;	PUT_IN_ZLIST			;
;---------------------------------------;
;  input :				;
;	al	vendor#			;
;	cs:bx	ptr to zlist table	;
;	ds:di	ptr to start of zlist	;
;		buffer			;
;  output:				;
;	none				;
;  register destroyed..AH		;
;---------------------------------------;
put_in_zlist:
	push	bp
	mov	ah,00h
	mov	bp,ax
	db	2eh
	xlat				; AL = string#
	mov	ds:[di+bp],al
	pop	bp
	ret
;---------------------------------------;
ELSE					; CPU OVERRIDE NOT REQUIRED

default_cpu_zlist	label	byte
	db	STR_RESERVED, STR_RESERVED, STR_RESERVED, STR_RESERVED
	db	STR_RESERVED, STR_RESERVED, STR_RESERVED, STR_RESERVED
	db	STR_RESERVED, STR_RESERVED, STR_RESERVED, STR_RESERVED
	db	STR_RESERVED, STR_RESERVED, STR_RESERVED, STR_AUTO

	public	cpu_selection_proc
cpu_selection_proc:
	mov	bx,offset cgroup:default_cpu_zlist
	push	cs
	pop	dx			; DX:BX = ptr to zlist
	mov	ah,02h			; use returned zlist
	retf				; must be FAR RETURN
ENDIF
~
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
	public	_EXTFN_ENDS
_EXTFN_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end
