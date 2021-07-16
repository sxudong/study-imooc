	page	,132
	title	FPU SETUP/RUNTIME MODULE
	.286p
	.387
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
;*****************************************************************************;
;*****************************************************************;

cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
;*****************************************************************************;



Public				IsFPU?
IsFPU?				proc	near
;
;    This routine checks whether system has
;    co-processor or not.
;	Input	: none
;	Output	: ZF = 0 (JNZ) : No co-processor found
;		     = 1 (JZ)  : Co-processor found
;    Register destroyed : AX
;    DO NOT USE ANY STACK


	.386p
	mov	ax,3c69h		; Dummy pattern
	fninit				; Initialize FPU
	fnstsw	ax			; AX = Status word (should be 0)
	or	al,al			; Set ZF, JZ = present, JNZ = absent
	ret
	.286p

IsFPU?				endp
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
