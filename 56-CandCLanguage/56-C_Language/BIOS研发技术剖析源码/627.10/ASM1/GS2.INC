;;	page	,132
;;	title .						GO TO BOOT
;;	.286p
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
;*****************************************************************;
;---------------------------------------;
;;	include	mbiosequ.equ		; bios global constant
;;	include	biosdata.dat		; bios glpbal data segment
;;	include	mbiosmac.mac		; bios coding macro definition
;;	include	cf.equ
;---------------------------------------;
	extrn	decompress_setup_boot:near
	extrn	copy_runtime_bios:near	; copy PCI/PnP runtime BIOS to shadow
;;	extrn	shutdown_4:near		; INT-19 boot loader
;;	extrn	check_point_stack:near

	public	boot_int19
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
;;cgroup	group	_text
;;_text	segment	word	public	'CODE'
;;	assume	cs:cgroup
;---------------------------------------;
;;	public	_GS2_STARTS
;;_GS2_STARTS	label	byte		; marks start of module
;---------------------------------------;
;	 BOOT PROGRAM (INT 19)		;
;---------------------------------------;
boot_int19:
	check_point	0b0h		; ======== b0
	call	decompress_setup_boot	; decompress setup code for hot-key setup
	check_point	0b1h		; ======== b1
	call	copy_runtime_bios
	check_point	00h		; ======== 00
	mov	dummy_word,0000h	; init 40:72
	jmp	shutdown_4		; execute BOOT
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
;---------------------------------------;
;;	public	_GS2_ENDS
;;_GS2_ENDS	label	byte			; marks end of module
;---------------------------------------;
;;_text	ends
;;	end

