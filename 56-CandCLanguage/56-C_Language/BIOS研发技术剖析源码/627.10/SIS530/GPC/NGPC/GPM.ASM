page	60,132
title.			GPM.ASM
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
;	   THIS MODULE HAS THE CODE FOR		;
;	     GREEN PC POWER MANAGEMENT		;
;-----------------------------------------------;

cgroup	group	_text
_text	segment word	public	'CODE'
	assume cs:cgroup

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

	public	gpc_version			;

	public	smi_code_begin			;

;-----------------------------------------------;
;		INCLUDE  FILES			;
;-----------------------------------------------;

	include	gpm.cfg				; green PC configuration file
	include	gpmcseg.dat			; code segment data file in equate form
	include	biosdata.dat			; main core bios data file
	include	gpmcpu.mac			; macro file for different CPUs
	include	gpmcpu.equ			; equate file for different CPUs
	include	gpm.equ				; equate file
	include	gpm.dat				; data file
	include	cssgpm.equ			; include file for chipset specific equates
	include	cssgpm.dat			; include file for chipset data area
	include	gpm.mac				; macro file
	include makeflag.equ

;-----------------------------------------------;
;		   ORGBASE EQUATE		;
;-----------------------------------------------;
;  Moved to GPM.EQU as this equate needs to be	;
;  shared by USB code. GPM.EQU file is also	;
;  included in USB code. 08/22/1996		;
;-----------------------------------------------;

;;;orgbase		equ	8000h		;

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
;			  ORG 8000H				;
;---------------------------------------------------------------;

smi_code_begin	label	byte

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
;   SUPPORT FOR APM/GREEN PC CODE USED AS STAND ALONE MODULE	;
;---------------------------------------------------------------;
;			INIT_SMRAM_FAR				;
;---------------------------------------------------------------;
;			  ORG 8000H				;
;---------------------------------------------------------------;

init_smram_far	proc	far

	call	init_smram			;
	retf

init_smram_far	endp

;---------------------------------------------------------------;
;			GPC_VERSION OFFSET			;
;---------------------------------------------------------------;
;			  ORG 8004H				;
;---------------------------------------------------------------;

	dw	cgroup:gpc_version - cgroup:smi_code_begin ; keeps the address of 'GPC_VERSION' label

;---------------------------------------------------------------;
;			APM_VERSION_OFFSET			;
;---------------------------------------------------------------;
;			  ORG 8006H				;
;---------------------------------------------------------------;

	dw	cgroup:apm_version - cgroup:smi_code_begin ; keeps the address of 'APM_VERSION' label

;---------------------------------------------------------------;
;		  INIT_SMRAM_EARLY_POST_FAR			;
;---------------------------------------------------------------;
;			  ORG 8008H				;
;---------------------------------------------------------------;

init_smram_early_post_far	proc	far

	call	init_smram_early_post		;
	retf

init_smram_early_post_far	endp

;---------------------------------------------------------------;
;			USB_VERSION OFFSET			;
;---------------------------------------------------------------;
;			  ORG 800CH				;
;---------------------------------------------------------------;

	extern	usb_version(dummy_string):byte

	dw	cgroup:usb_version		; keeps the address of 'USB_VERSION' label

;---------------------------------------------------------------;
;			FUTURE USAGE AREA			;
;---------------------------------------------------------------;
;			  ORG 800EH				;
;---------------------------------------------------------------;

	db	8 dup (?)			; available area for future usage

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
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;		RUN TIME CORE BIOS SMI HANDLER CODE		;
;---------------------------------------------------------------;
; All the code from here labelled as 'SMI_CODE_BEGIN' to the end;
; of the file labelled as 'SMI_CODE_END' will be copied to the	;
; smram. This code will execute in smram during the handling of	;
; smi. Any of these routines can be used during	 smi post as they
; will be available. Please make sure that any code needed during
; smi handler should be added after the label 'SMI_CODE_BEGIN'	;
; and before the label 'SMI_CODE_END'.				;
;---------------------------------------------------------------;
;	  FIXED ENTRY POINT FOR IRQ BASED REAL MODE APM		;
;---------------------------------------------------------------;
;			    ORG 8016H				;
;---------------------------------------------------------------;
;	Input : As defined by the APM function			;
;	Output: As defined by the APM function			;
;	Register destroyed : As defined by the APM function	;
;---------------------------------------------------------------;

irq_apm_real_mode_entry_ext	proc	near

;	jmp	short irq_apm_real_mode_entry	; IRQ based APM real mode entry (ORG 8016H)
;	nop					;

IF	IRQ_HANDLING_SUPPORT
	jmp	irq_apm_real_mode_entry		; IRQ based APM real mode entry
ELSE
	db	3 dup (?)			;
ENDIF

;	nop					;

irq_apm_real_mode_entry_ext	endp

;---------------------------------------------------------------;
;		 FIXED ENTRY POINT FOR CPU DETECT		;
;---------------------------------------------------------------;
;			INTEL_AMD_PLUS_DETECT			;
;---------------------------------------------------------------;
;			     ORG 8019H				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

intel_amd_plus_detect	proc	near

;	jmp	short intel_amd_plus_detect_ext	; INTEL/AMD PLUS CPU DETECT (ORG 800DH)
;	nop					;
	jmp	intel_cpu_smi_entry_ext		; INTEL/AMD PLUS CPU detected
;	nop					;

intel_amd_plus_detect	endp

;---------------------------------------------------------------;
;			AMD_NON_PLUS_IBM_DETECT			;
;---------------------------------------------------------------;
;			    ORG 801CH				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

amd_non_plus_ibm_detect	proc	near

;	jmp	short amd_non_plus_ibm_detect_ext; AMD non-PLUS/IBM CPU DETECT (ORG 8010H)
;	nop					;
	jmp	amd_cpu_smi_entry_ext		; AMD non-PLUS/IBM CPU DETECTED
;	nop					;

amd_non_plus_ibm_detect	endp

;---------------------------------------------------------------;
;			  CRX_TI_DETECT				;
;---------------------------------------------------------------;
;			     ORG 801FH				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

crx_ti_detect	proc	near

;	jmp	short crx_ti_detect_ext		; CYRIX/TI CPU DETECT (ORG 8013H)
;	nop					;
	jmp	crx_cpu_smi_entry_ext		; CYRIX/TI CPU DETECTED
;	nop					;

crx_ti_detect	endp

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
;		CPU DETECT & CONTROL TRANSFER ROUTINES		;
;---------------------------------------------------------------;
;		    INTEL_AMD_PLUS_DETECT_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

;intel_amd_plus_detect_ext	proc	near
;
;	jmp	short intel_cpu_smi_entry_ext	; INTEL/AMD PLUS CPU detected
;
;intel_amd_plus_detect_ext	endp

;---------------------------------------------------------------;
;		   AMD_NON_PLUS_IBM_DETECT_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

;amd_non_plus_ibm_detect_ext	proc	near
;
;	jmp	amd_cpu_smi_entry_ext		; AMD non-PLUS/IBM CPU DETECTED
;
;amd_non_plus_ibm_detect_ext	endp

;---------------------------------------------------------------;
;			CRX_TI_DETECT_EXT			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : ALL				;
;---------------------------------------------------------------;

;crx_ti_detect_ext	proc	near
;
;	jmp	crx_cpu_smi_entry_ext		; CYRIX/TI CPU DETECTED
;
;crx_ti_detect_ext	endp

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
;		GREEN PC CODE VERSION NO.			;
;---------------------------------------------------------------;

gpc_version	label	byte

	db	'GPC-1.11 ',00h			;

;-----------------------------------------------;

	public	dummy_string

dummy_string	label	byte

	db	00h				;

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
;		   INCLUDE FILES FOR CODE USAGE			;
;---------------------------------------------------------------;

	include	gpmcpu.inc			; multiple CPU support code

IF	IRQ_HANDLING_SUPPORT
	include	gpmirq.inc			; IRQ based power management support code
	include	gapmirq.inc			; IRQ based power management APM support code
ENDIF

	include	gpmsmi.inc			; SMI handling code (core part)
	include	gpmmisc.inc			; miscellaneous subroutines
	include	gpmlib.inc			; library files
	include	gpminit.inc			; smi initialisation code (core part)
IF	apm12_support
	include	gapm12.inc			; v1.2 APM support (core part)
ELSE
IF	apm11_support
	include	gapm11.inc			; v1.1 APM support (core part)
ELSE
	include	gapm10.inc			; v1.0 APM support (core part)
ENDIF
ENDIF
	include	gpmmp.inc			; SMI handling code for INTEL APIC multiprocessor

	include	gpm.css				; smi initialisation code + smi handling code (chipset part)
	include	gpmext.css			; smi handling code (chipset part)
	include	gapm.css			; APM code (chipset part)
IF	apm12_support
	include	gapm12.oem			; v1.2 APM code (chipset part)
ENDIF

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

smi_code_end	label	byte

;---------------------------------------------------------------;

.286p

_text	ends
	end
