	page	,132
	title	SMBIOS 2.1 IMPLEMENTATION
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
.xlist
	include	makeflag.equ
;	include	oemmake.equ		; $$$CORE0071-
	include	smb.cfg
	include	smbmacro.aid
	include	smbstruc.def
	include	smb.equ
	include	smbdata.mac
	include	smbdesc.def
.list
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_SMBDATA_STARTS
_SMBDATA_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;			SMBIOS DATA STRUCTURES				;
;-----------------------------------------------------------------------;
smbios_structures_start	label	byte
	handle = 0
	handle = CreateBiosInfo(handle)
	handle = CreateSysInfo(handle)
        handle = CreateBaseBoardInfo(handle)
	handle = CreateSysChassisInfo(handle)
	handle = CreateProcessorInfo(handle)
IF	DMI_VER
; processor cache information has been already created in CreateProcessorInfo
ELSE
	handle = CreateProcCacheInfo(handle)	; create Processor Cache Info for DMI 2.0
ENDIF
	handle = CreateCacheInfo(handle)	; create external Cache Info
	handle = CreateMemCtrlInfo(handle, handle+1)
	handle = CreateMemModuleInfo(handle)
	handle = CreatePortConnectorInfo(handle)
	handle = CreateSystemSlotInfo(handle)
	handle = CreateOnboardDeviceInfo(handle)
	handle = CreateOemStringInfo(handle)
	handle = CreateSystemConfigOptionInfo(handle)
	handle = CreateBiosLanguageInfo(handle)
;;	handle = CreateGroupAssociationInfo(handle)
;	handle = CreateBuiltinPointingDeviceInfo(handle)
;	handle = CreatePortableBatteryInfo(handle)
if MKF_EVENT_LOG				; (CORE0218+)>
	handle = CreateSystemEventLog(handle)
endif ;MKF_EVENT_LOG				; <(CORE0218+)
smbios_structures_end	label	byte
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
	public	_SMBDATA_ENDS
_SMBDATA_ENDS	label	byte		; marks end of module
;---------------------------------------------------------------;
_text	ends
END
