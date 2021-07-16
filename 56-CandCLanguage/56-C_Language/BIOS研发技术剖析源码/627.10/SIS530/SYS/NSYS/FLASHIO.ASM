	page	,132
	title	Boot Block I/O suppor table
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
DefineDevice	macro	x
	extrn	x:near
	dw	offset cgroup:x
endm
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
;---------------------------------------;
;	BOOTBLOCK_KBC_RTC_TABLE		;
;---------------------------------------;
	public	bootblock_kbc_rtc_table
	public	bootblock_kbc_rtc_table_end
bootblock_kbc_rtc_table		label	byte
	include	bkbcrtc.inc
bootblock_kbc_rtc_table_end	label	byte
;---------------------------------------;
;	BOOTBLOCK_FDC_TABLE		;
;---------------------------------------;
	public	bootblock_fdc_table
	public	bootblock_fdc_table_end
bootblock_fdc_table		label	byte
	include	bfdc.inc
bootblock_fdc_table_end	label	byte
;---------------------------------------;
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
_text	ends
	end
