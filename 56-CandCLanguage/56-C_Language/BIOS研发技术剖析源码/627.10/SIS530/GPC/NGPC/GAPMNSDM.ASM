page	60,132
title.		NON-SMI real/16 bit protected/32 bit protected mode dummy code...GAPMNSDM.ASM
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
;	  GREEN PC APM POWER MANAGEMENT		;
;-----------------------------------------------;

cgroup	group	_text
_text	segment word	public	'CODE'
	assume cs:cgroup

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
;-----------------------------------------------;
;     THIS MODULE IS CORE POWER MANAGEMENT	;
;   BIOS MODULE WHICH DOES NOT EXECUTE IN SMI	;
;-----------------------------------------------;
;     CODES ARE REAL/16 BIT PROTECTED MODE/	;
;	     32 BIT PROTECTED MODE		;
;-----------------------------------------------;
;      ROUTINES WILL BE CALLED AS FAR/NEAR	;
;-----------------------------------------------;	
;   ROUTINES & ENTRY POINTS USED FROM OUTSIDE	;
;-----------------------------------------------;

	public	apm_real_mode_entry		;
	public	apm_16bit_prot_mode_entry	;
	public	apm_32bit_prot_mode_entry	;

;-----------------------------------------------;

.386p
;-----------------------------------------------;
;	   EQUATES USED BY THIS MODULE		;
;-----------------------------------------------;

unsupported_func		equ	86h	; unsupported function

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
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;	     RUN TIME CORE BIOS ROM APM HANDLER CODE		;
;---------------------------------------------------------------;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;	  THIS MODULE WILL RESIDE IN F000 ROM SHADOW		;
;---------------------------------------------------------------;
;			APM_REAL_MODE_ENTRY			;
;---------------------------------------------------------------;

apm_real_mode_entry	proc	near

	mov	ah,unsupported_func		; function not supported
	add	sp,02h				; bypass caller
	stc					; (cy) = 01 for error
	retf	2

apm_real_mode_entry	endp

;---------------------------------------------------------------;
;		     APM_16BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

apm_16bit_prot_mode_entry	proc	near

	mov	ah,unsupported_func		; function not supported
	stc					; (cy) = 01 for error
	retf

apm_16bit_prot_mode_entry	endp

;---------------------------------------------------------------;
;		     APM_32BIT_PROT_MODE_ENTRY			;
;---------------------------------------------------------------;

apm_32bit_prot_mode_entry	proc	near

	mov	ah,unsupported_func		; function not supported
	stc					; (cy) = 01 for error
	retf

apm_32bit_prot_mode_entry	endp

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

