page	60,132
title.			GPMDM.ASM
.tfcond

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
;-----------------------------------------------;
;	THIS MODULE HAS THE DUMMY CODE FOR	;
;	     GREEN PC POWER MANAGEMENT		;
;-----------------------------------------------;

cgroup	group	_text
_text	segment word	public	'CODE'
	assume cs:cgroup

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

	public	gpc_version			;
	public	init_smram			;
	public	init_smram_early_post		;
	public	apm_version			;

;-----------------------------------------------;
;		INCLUDE  FILES			;
;-----------------------------------------------;

	include	biosdata.dat			; main core bios data file

;-----------------------------------------------;
;		   EQUATES USED			;
;-----------------------------------------------;

bios_data_seg		equ	40h		;

;-----------------------------------------------;

.386p
;-----------------------------------------------;
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
;---------------------------------------------------------------;
;		GREEN PC CODE VERSION NO.			;
;---------------------------------------------------------------;

gpc_version	label	byte

	db	00h				;

;---------------------------------------------------------------;
;		GREEN PC APM CODE VERSION NO.			;
;---------------------------------------------------------------;

apm_version	label	byte

	db	00h				;

;---------------------------------------------------------------;
;		     INIT_SMRAM_EARLY_POST			;
;---------------------------------------------------------------;
;			  INIT_SMRAM				;
;---------------------------------------------------------------;
;	Input :	(CS) SMI code source segment			;
;		STACK PRESENT					;
;	Output: (CY) 00 successful				;
;		(CY) 01 error					;
;	Register destroyed : NONE				;
; NOTE :							;
;  *  Control comes here to initialize smram with the smi handler
;  *  This routine is called from the main bios	hook 'SPECIAL_	;
;     CONFIG_DISPLAY' at check point 0AAh			;
;---------------------------------------------------------------;

init_smram_early_post	proc	near
init_smram	proc	near

	push	ds				;
	push	bios_data_seg			;
	pop	ds				; (ds) = bios standard data segment (40H)
	and	sys_info,11001111b		; clear bits 5,4
	pop	ds				;
	stc					; (cy) = 01 for unsuccessful
	ret

init_smram	endp
init_smram_early_post	endp

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
;---------------------------------------------------------------;

.286p

_text	ends
	end
