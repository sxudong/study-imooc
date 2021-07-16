
	page	,132
	title	CPU CONFIGURATION MODULE
;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
	.486p

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

;-----------------------------------------------------------------------------;

	Extrn		GetResetID:near

	include	cpu.cfg			; 
if (James)
	include triton2.equ
endif
	include		cpustruc.inc
	include		cpumac.inc
	include		cpuequ.inc

CCRIndexTbl	db	0c0h, 0c1h, 0c2h, 0c3h, 0e8h, 0e9h, 020h, 0f0h


		    comment ú

		    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		    º	       FlushCacheStandard	   º
		    ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		    º  This routine invalidates internal   º
		    º  cache for any CPU in a standard way.º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Environment   : Stack available     º
		    º  Invoked	     : At any time	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Input	     : AL   = CPU#	   º
		    º		       CX   = FuncField	   º
		    º		       ECX+ = Extended	   º
		    º			      FuncField	   º
		    º		       EDX  = ResetID	   º
		    º  Output	     : CF = 0 (JNC) as	   º
		    º		       successful	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Registers Destroyed: none 	   º
		    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		    ú


Public	FlushCacheStandard
FlushCacheStandard	proc	near

	test	cl,00000010b		; WB/WT ?
	clc				; CF = 0
	jz	wt_fic			; WT cache
	wbinvd				; Invalidate WB cache
	ret
wt_fic:
;;;;	invd				; Invalidate WT cache
	wbinvd				; Invalidate WB cache....
	ret

FlushCacheStandard	endp



;*****************************************************************************;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


DummyEnableCache		PROC	NEAR

	mov	ah,4			; CPU vendor is not supported in BIOS
	stc
	ret

DummyEnableCache		ENDP

DummyDisableCache		PROC	NEAR

	mov	ah,4			; CPU vendor is not supported in BIOS
	stc
	ret

DummyDisableCache		ENDP

DummyInitCPU@Shutdown		PROC	NEAR

	ret

DummyInitCPU@Shutdown		ENDP

DummyFlushCache			PROC	NEAR

	mov	ah,4			; CPU vendor is not supported in BIOS
	stc
	ret

DummyFlushCache			ENDP

DummyDisableBTB			PROC	NEAR

	ret

DummyDisableBTB			ENDP

DummyEnableBTB			PROC	NEAR

	ret

DummyEnableBTB			ENDP

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

	Public	Vendor_Runtime_Data_Base
	Public	Vendor_Runtime_Data_Base_End

Vendor_Runtime_Data_Base:

if (CPU_INTEL)
VNDRRUNSTRUC	{\
		offset	EnableIntelCache,
		offset	DisableIntelCache,
		offset	InitIntelCPU@Shutdown,
		offset	FlushIntelCache,
		offset	DisableIntelBTB,
		offset	EnableIntelBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

if (CPU_CYRIX)
VNDRRUNSTRUC	{\
		offset	EnableCyrixCache,
		offset	DisableCyrixCache,
		offset	InitCyrixCPU@Shutdown,
		offset	FlushCyrixCache,
		offset	DisableCyrixBTB,
		offset	EnableCyrixBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

if (CPU_AMD)
VNDRRUNSTRUC	{\
		offset	EnableAMDCache,
		offset	DisableAMDCache,
		offset	InitAMDCPU@Shutdown,
		offset	FlushAMDCache,
		offset	DisableAMDBTB,
		offset	EnableAMDBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

if (CPU_IBM)
VNDRRUNSTRUC	{\
		offset	EnableIBMCache,
		offset	DisableIBMCache,
		offset	InitIBMCPU@Shutdown,
		offset	FlushIBMCache,
		offset	DisableIBMBTB,
		offset	EnableIBMBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

if (CPU_TI)
VNDRRUNSTRUC	{\
		offset	EnableTICache,
		offset	DisableTICache,
		offset	InitTICPU@Shutdown,
		offset	FlushTICache,
		offset	DisableTIBTB,
		offset	EnableTIBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

if (CPU_UMC)
VNDRRUNSTRUC	{\
		offset	EnableUMCCache,
		offset	DisableUMCCache,
		offset	InitUMCCPU@Shutdown,
		offset	FlushUMCCache,
		offset	DisableUMCBTB,
		offset	EnableUMCBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

if (CPU_SGS)
VNDRRUNSTRUC	{\
		offset	EnableSGSThCache,
		offset	DisableSGSThCache,
		offset	InitSGSThCPU@Shutdown,
		offset	FlushSGSThCache,
		offset	DisableSGSThBTB,
		offset	EnableSGSThBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

if (CPU_IDT)
VNDRRUNSTRUC	{\
		offset	EnableIDTCache,
		offset	DisableIDTCache,
		offset	InitIDTCPU@Shutdown,
		offset	FlushIDTCache,
		offset	DisableIDTBTB,
		offset	EnableIDTBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif

; $$$CPU0014+ >>>
if (CPU_RISE)
VNDRRUNSTRUC	{\
		offset	EnableRiseCache,
		offset	DisableRiseCache,
		offset	InitRiseCPU@Shutdown,
		offset	FlushRiseCache,
		offset	DisableRiseBTB,
		offset	EnableRiseBTB\
		}
else
VNDRRUNSTRUC	{\
		offset	DummyEnableCache,
		offset	DummyDisableCache,
		offset	DummyInitCPU@Shutdown,
		offset	DummyFlushCache,
		offset	DummyDisableBTB,
		offset	DummyEnableBTB\
		}
endif
; $$$CPU0014+ <<<

Vendor_Runtime_Data_Base_End:

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

; $$$CPU0007- >>>
;Public			cpu_selection_table
;Public			cpu_selection_table_end
;cpu_selection_table:
;
;;			Vendor# to check	Vendor# can be replaced with
;;			----------------	----------------------------
;	db		0,			2
;	db		1,			3
;	db		1,			4
;	db		1,			6
;
;cpu_selection_table_end:
; $$$CPU0007- <<<

Public		_clock_difference_table
_clock_difference_table:

;---------------------------------------;
;	_CLOCK_DIFFERENCE_TABLE		;
;---------------------------------------;
; This table contains the number of	;
; clock difference between "DIV BX" and	;
; "DIV BL" instructions for each vendor.;
; This is needed to compute CPU clock	;
; frequency.				;
;---------------------------------------;
; Table entries are in the order of the	;
; vendor number.			;
;---------------------------------------;

	db	8			; For Intel
	db	8			; For Cyrix
	db	8			; For AMD
	db	8			; For IBM
	db	8			; For TI
	db	10			; For UMC
	db	8			; For SGS Thomson



Public	_max_vendor_support
	_max_vendor_support	EQU	9

;Public	_ccp_vendor_support
;_ccp_vendor_support:
;	db	07Fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;Public	_ccp_cpu_support
;_ccp_cpu_support:

;Vendor# - 0
;-------
;	db	0FFh, 0FFh, 0FFh, 001h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;Vendor# - 1
;-------
;	db	0FFh, 0FFh, 001h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;Vendor# - 2
;-------
;	db	0FFh, 01Fh, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;Vendor# - 3
;-------
;	db	0FFh, 001h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;Vendor# - 4
;-------
;	db	07Fh, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;Vendor# - 5
;-------
;	db	001h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;Vendor# - 6
;-------
;	db	003h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
;	db	000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;

Public		_ccp_version
		_ccp_version	db	'CPU-3.03 ',0
;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;
	include	freq.inc		; CPU frequency tables
if (CPU_INTEL) or (CPU_AMD)
	include	rintel.inc		; Runtime Intel routines
endif
if (CPU_CYRIX) or (CPU_TI) or (CPU_IBM) or (CPU_SGS)
	include	rcyrix.inc		; Runtime Cyrix routines
endif
if (CPU_AMD)
	include	ramd.inc		; Runtime AMD routines
endif
if (CPU_IBM)
	include	ribm.inc		; Runtime IBM routines
endif
if (CPU_TI)
	include	rti.inc			; Runtime TI routines
endif
if (CPU_UMC)
	include	rumc.inc		; Runtime UMC routines
endif
if (CPU_SGS)
	include	rsgs.inc		; Runtime SGS-Thomson routines
endif
if (CPU_IDT)
	include	ridt.inc		; Runtime IDT routines
endif
if (CPU_RISE)
	include	rrise.inc		; Runtime Rise routines
endif
;-----------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------;

	_text	ends
	END

