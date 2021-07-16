	page	,132
	title	OEM SETUP HOOKS
;-----------------------------------------------------------------------;
; This file is derived from SETUP.ASM and NSETUP.ASM files.		;
; ======================== NOTE === NOTE === NOTE =====================	;
; If the routine name in this file starts with "OEM_", then this routine;
; is called from the corresponding generic chipset hook (in SETUP.ASM or;
; NSETUP.ASM file).							;
; ======================== NOTE === NOTE === NOTE =====================	;
; If the routine name in this file does not start with "OEM_", then this;
; routine is called directly from Core file.				;
;-----------------------------------------------------------------------;
; NOTE:	Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;---------------------------------------;
;  THIS EXTERNAL DEFINITIONS MUST BE OUTSIDE THE CGROUP DEFINITION..
	extrn	_old_cmos_buffer:byte
	extrn	_common_cmos_buffer:byte
;---------------------------------------;
	include	mbiosmac.mac
	include	mbiosequ.equ
	include	cf.equ
	include	setupequ.ext
	include	setupmsg.equ
;---------------------------------------;
	extrn	check_bcp_setup:near
	extrn	get_cmos_buffer_item:near
	extrn	set_cmos_buffer_item:near
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_OEM_SETUP_STARTS
_OEM_SETUP_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;			INT_CACHE_SCHEME_STRINGS			;
; this table describes the options of internal cache setup questions.	;
; the internal cache setup question is of two bits in CMOS.		;
; Bit value	00 -> Disabled						;
;		01 -> Write-Through					;
;		10 -> Write-Back					;
;		11 -> Reserved						;
; this table has 4 entries, each entry is of 4 bytes.			;
; First  entry -> options when internal cache is NOT available in CPU.	;
; Second entry -> options when internal cache is only write-through (WT);
; Third  entry -> options when internal cache is only write-back (WB).	;
; Fourth entry -> options when internal cache is both WB & WT.		;
; NOTE: This order of the entries must be maintained.			;
; You can change any string according to OEM requirement. For example,	;
; for Pemtium CPU, the internal cache is only WB. So instead of saying	;
; Write-back as the option, OEM may want to display it as "Enabled".	;
; In that case, in the third entry (options for only write-back) change	;
; STR_WRITEBACK to STR_ENABLED.						;
;-----------------------------------------------------------------------;
	public	int_cache_scheme_strings
int_cache_scheme_strings	label	byte
; Internal Cache Not Allowed
	db	STR_DISABLED,STR_RESERVED,STR_RESERVED,STR_RESERVED
; Only w-thru allowed.
	db	STR_DISABLED,STR_WRITETHRU,STR_RESERVED,STR_RESERVED
; Only w-back allowed.
	db	STR_DISABLED,STR_RESERVED,STR_WRITEBACK,STR_RESERVED
; W-thru and W-back allowed.	
	db	STR_DISABLED,STR_WRITETHRU,STR_WRITEBACK,STR_RESERVED
;-----------------------------------------------------------------------;
;			EXTERNAL_CACHE_PROC				;
; this is the external function for handling the external cache setup	;
; question. the internal cache setup question is of two bits in CMOS.	;
; Bit value	00 -> Disabled						;
;		01 -> Write-Through					;
;		10 -> Write-Back					;
;		11 -> Reserved						;
; Deafult implementation : If internal cache is not enabled, external	;
; cache is not selectable and is always set to disabled.		;
; If OEM wants to change this default implementation, you can do it	;
; here. Also if the external cache is only one type e.g. Write-Back,	;
; then you can change the options to					;
;	STR_DISABLED,STR_RESERVED,STR_ENABLED,STR_RESERVED		;
; where "WriteBack" option will be disabled as "Enabled".		;
;-----------------------------------------------------------------------;
ext_cache_scheme_strings	label	byte
	db	STR_DISABLED,STR_WRITETHRU,STR_WRITEBACK,STR_RESERVED
;-----------------------------------------------------------------------;
	public	external_cache_proc
external_cache_proc	proc	near
	mov	ah,02h			; to show normal
	call	check_bcp_setup		; BCP/Setup ?
	jz	short l2cp_1		; BCP, show normal
	mov	al,Q_INTERNAL_CACHE
	call	get_cmos_buffer_item	; get curr setting of internal cache
	mov	ah,02h			; to show normal
	jnz	short l2cp_1		; internal cache is enabled
;  internal cache is disabled, force external cache to disabled and make
;  the external cache not selectable
	mov	al,Q_EXTERNAL_CACHE	; External cache qn. no.
	mov	ah,00h			; Make external cache disabled
	call	set_cmos_buffer_item
	mov	ah,03h			; display shadowed
l2cp_1:
	mov	dx,cs
	mov	bx,offset cgroup:ext_cache_scheme_strings
	retf
external_cache_proc	endp
;-----------------------------------------------------------------------;
;		      OEM_INIT_BUFFER_BEFORE_SETUP			;
;-----------------------------------------------------------------------;
; this routine is called from INIT_BUFFER_BEFORE_SETUP routine in	;
; SETUP.ASM file.							;
; If you want to update the _common_cmos_buffer before setup screen	;
; is displayed (e.g. you want to change default value of some option),	;
; this routine can be used.
; CMOS_SETUP is called at check_point	: 87				;
; input :								;
;	ds	segment of _common_cmos_buffer				;
;	es	segment of _common_cmos_buffer				;
;	stack	available						;
; register usage -- can destroy any register except EBP, DS, ES		;
; NOTE: difference between INIT_BUFFER_BEFORE_SETUP and BEFORE_SETUP	;
;	is in input values of DS, ES					;
;-----------------------------------------------------------------------;
	public	oem_init_buffer_before_setup
oem_init_buffer_before_setup:
	ret
;-----------------------------------------------------------------------;
;		    OEM_ADJUST_EXTENDED_MEMORY_SETUP			;
;-----------------------------------------------------------------------;
; If extended memory size need to be adjusted due to memory remap,	;
; relocation/shadow conflict check, or any other change necessary	;
; after CMOS SETUP, use this routine.					;
; this routine is called from ADJUST_EXTENDED_MEMORY_SETUP in SETUP.ASM	;
; file for normal and hot key setup before CMOS registers are actually	;
; written when "WRITE CMOS REGISTER and EXIT" is chosen.		;
; input :								;
;	ds			segment of _old_cmos_buffer &		;
;					   _common_cmos_buffer		;
;	_old_cmos_buffer	previous setting of options		;
;	_common_cmos_buffer	updated setting of options thru' CMOS SETUP
;	stack			available				;
; output: (ZF) = 1 -> proceed, (ZF) = 0 -> exit to reboot		;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: while updating extended memory size, locn in _common_cmos_buffer;
;	for cmos registers 17h,18h, 30h,31h,35h,36h must be updated	;
;	properly.							;
;-----------------------------------------------------------------------;
	public	oem_adjust_extended_memory_setup
oem_adjust_extended_memory_setup:
	or	sp,sp			; (ZF) = 0, reboot
	ret
;-----------------------------------------------------------------------;
;			OEM_HOT_KEY_ADJUST_SETUP			;
;-----------------------------------------------------------------------;
; this routine is called from HOT_KEY_ADJUST_SETUP in SETUP.ASM file.	;
; This routine can be used to do any OEM specific programming after	;
; hot-key cmos setup is executed, cmos is written with updated values	;
; and system does not need to be rebooted.				;
; input :								;
;	ds			segment of _old_cmos_buffer &		;
;					   _common_cmos_buffer		;
;	stack	available						;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: 1. this routine will need to reprogram parameters like wait	;
;	states, power management timers, etc. which are usually		;
;	programmed in PROGRAM_PARAMETER_AFTER_SETUP hook. it is advised	;
;	to write a common subroutine used by both these hooks to	;
;	minimize code size.						;
;-----------------------------------------------------------------------;
	public	oem_hot_key_adjust_setup
oem_hot_key_adjust_setup:
	ret
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1995, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-263-8181.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;
	public	_OEM_SETUP_ENDS
_OEM_SETUP_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end
