	page	,132
	title	END MARKER OF SMBIOS RUNTIME IMAGE
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
cgroup	group	_text
_text	segment	para	public	'CODE'	; alignment MUST be PARA !!!!!!!!
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_SMBRUNE_STARTS
_SMBRUNE_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
	public	smbios_runtime_code_end
smbios_runtime_code_end:
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
;---------------------------------------------------------------;
	public	_SMBRUNE_ENDS
_SMBRUNE_ENDS	label	byte		; marks end of module
;---------------------------------------------------------------;
_text	ends
END
