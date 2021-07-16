	page	,132
	title	FLASH SUPPORT TABLE
;-----------------------------------------------------------------------;
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
;-----------------------------------------------------------------------;
	include makeflag.equ
;-----------------------------------------------------------------------;
;  this file contains a table having the information of different Flash ;
;  part support present in the BIOS.					;
;-----------------------------------------------------------------------;
cgroup	group	_text
_text	segment word	public	'CODE'
	assume	cs:cgroup
.486p
;-----------------------------------------------------------------------;
;			FLASH_SUPPORT_TABLE				;
;  this table contains a table having the different Flash part support	;
;  present in the BIOS. 						;
;-----------------------------------------------------------------------;
	public	flash_support_table
	public	flash_support_table_end
; (CORE0071)>
	public	flash_found_table
		;  flash routine table offset,		start of NVRAM, start of boot block
flash_found_table	label	byte
;---------------------------------------;
;  this entry will be initialized with the proper entry of the flash part found
flash_support_entry_start	label	byte
	dw	0FFFFh, 				0FFFFh, 	0FFFFh
flash_support_entry_end 	label	byte
flash_support_table	label	byte
		;  flash routine table offset,		start of NVRAM, start of boot block
flash_support_table	label	byte
if	MKF_GPNV_FLASH
;-------------------------------------------------------; with GPNV support
if MKF_256K_BIOS
;---------------
if	MKF_AMD
	extern	amd_29f002(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:amd_29f002,		0FFFFh,		0C000h
else
	dw	offset cgroup:amd_29f002,		08000h,		0C000h
endif
endif

if	MKF_SST
	extern	sst_29ee020(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:sst_29ee020,		0FFFFh,		0C000h
else
	dw	offset cgroup:sst_29ee020,		08000h,		0C000h
endif
endif

if	MKF_ATMEL
	extern	atmel_29c020(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:atmel_29c020,		0FFFFh,		0C000h
else
	dw	offset cgroup:atmel_29c020,		08000h,		0C000h
endif
endif

if	MKF_WINBOND
							; (CORE0216+)>
if	MKF_AT49F002T
	extern	atmel_49f002t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:atmel_49f002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:atmel_49f002t,		08000h,		0C000h
endif
endif
							; <(CORE0216+)

	extern	winbond_29c020(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:winbond_29c020,		0FFFFh,		0C000h
else
	dw	offset cgroup:winbond_29c020,		08000h,		0C000h
endif
endif

							; (CORE0215+)>
if	MKF_MOSEL_V29C51002T
	extern	mosel_v29c51002t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:mosel_v29c51002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:mosel_v29c51002t,		08000h,		0C000h
endif
endif
							; <(CORE0215+)
							; (CORE0208+)>
if	MKF_MXIC_29F002T
	extern	mxic_29f002t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_29f002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:mxic_29f002t,		08000h,		0C000h
endif
endif
							; <(CORE0208+)
							; (CORE0224+)>
if	MKF_PMC29F002T
	extern	pmc_29f002t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:pmc_29f002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:pmc_29f002t,		08000h,		0C000h
endif
endif
							; <(CORE0224+)
if	MKF_MXIC_P
if	MKF_NO_NVRAM
	extern	mxic_28f2000p(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000p,		0FFFFh, 	0C000h
else
	extern	mxic_28f2000p(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000p,		04000h, 	0C000h
endif
endif

if	MKF_MXIC_T
if	MKF_NO_NVRAM
	extern	mxic_28f2000t(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000t,		0FFFFh, 	0C000h
else
	extern	mxic_28f2000t(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000t,		08000h, 	0C000h
endif
endif


if	MKF_INTEL
	extern	intel_28f002bxt(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:intel_28f002bxt,		0FFFFh,		0C000h
else
	dw	offset cgroup:intel_28f002bxt,		08000h,		0C000h
endif
endif

else	; not MKF_256K_BIOS
;-------;

if	MKF_AMD
	extern	amd_29f010(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:amd_29f010,		0FFFFh,		0C000h
else
	dw	offset cgroup:amd_29f010,		04000h,		0C000h
endif
endif

if	MKF_SST
	extern	sst_29ee010(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:sst_29ee010,		0FFFFh,		0E000h
else
	dw	offset cgroup:sst_29ee010,		0C000h,		0E000h
endif
endif

if	MKF_WINBOND
	extern	winbond_29ee011(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:winbond_29ee011,		0FFFFh,		0E000h
else
	dw	offset cgroup:winbond_29ee011,		0C000h,		0E000h
endif
endif

if	MKF_ATMEL
	extern	atmel_29c010(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:atmel_29c010,		0FFFFh,		0E000h
else
	dw	offset cgroup:atmel_29c010,		0C000h,		0E000h
endif
endif

if	MKF_MXIC
	extern	mxic_28f1000(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_28f1000,		0FFFFh,		0C000h
else
	dw	offset cgroup:mxic_28f1000,		04000h,		0C000h
endif
endif

if	MKF_MXIC_P
	extern	mxic_28f1000p(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_28f1000p,		0FFFFh,		0E000h
else
	dw	offset cgroup:mxic_28f1000p,		0C000h,		0E000h
endif
endif

							; (CORE0213+)>
if	MKF_MXIC_29F001T
	extern	mxic_29f001t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_29f001t,		0FFFFh,		0E000h
else
	dw	offset cgroup:mxic_29f001t,		0C000h,		0E000h
endif
endif
							; <(CORE0213+)

if	MKF_INTEL
	extern	intel_28f001bxt(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:intel_28f001bxt,		0FFFFh,		0E000h
else
	dw	offset cgroup:intel_28f001bxt,		0C000h,		0E000h
endif
endif

endif	; if MKF_256K_BIOS
;-------;

else
;-------------------------------------------------------; without GPNV support

if MKF_256K_BIOS
;---------------

if	MKF_AMD
	extern	amd_29f002(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:amd_29f002,		0FFFFh,		0C000h
else
	dw	offset cgroup:amd_29f002,		0A000h,		0C000h
endif
endif

if	MKF_SST
	extern	sst_29ee020(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:sst_29ee020,		0FFFFh,		0C000h
else
	dw	offset cgroup:sst_29ee020,		0A000h,		0C000h
endif
endif

if	MKF_ATMEL
	extern	atmel_29c020(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:atmel_29c020,		0FFFFh,		0C000h
else
	dw	offset cgroup:atmel_29c020,		0A000h,		0C000h
endif
endif

							; (CORE0216+)>
if	MKF_AT49F002T
	extern	atmel_49f002t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:atmel_49f002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:atmel_49f002t,		0A000h,		0C000h
endif
endif
							; <(CORE0216+)
if	MKF_WINBOND
	extern	winbond_29c020(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:winbond_29c020,		0FFFFh,		0C000h
else
	dw	offset cgroup:winbond_29c020,		0A000h,		0C000h
endif
endif

							; (CORE0215+)>
if	MKF_MOSEL_V29C51002T
	extern	mosel_v29c51002t(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:mosel_v29c51002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:mosel_v29c51002t,		0A000h,		0C000h
endif
endif
							; <(CORE0215+)
							; (CORE0208+)>
if	MKF_MXIC_29F002T
	extern	mxic_29f002t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_29f002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:mxic_29f002t,		0A000h,		0C000h
endif
endif
							; <(CORE0208+)
							; (CORE0224+)>
if	MKF_PMC29F002T
	extern	pmc_29f002t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:pmc_29f002t,		0FFFFh,		0C000h
else
	dw	offset cgroup:pmc_29f002t,		0A000h,		0C000h
endif
endif
							; <(CORE0224+)
if	MKF_MXIC_P
if	MKF_NO_NVRAM
	extern	mxic_28f2000p(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000p,		0FFFFh, 	0C000h
else
	extern	mxic_28f2000p(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000p,		08000h, 	0C000h
endif
endif

if	MKF_MXIC_T
if	MKF_NO_NVRAM
	extern	mxic_28f2000t(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000t,		0FFFFh, 	0C000h
else
	extern	mxic_28f2000t(dummy_flash):byte		; (CORE0073)
	dw	offset cgroup:mxic_28f2000t,		0A000h, 	0C000h
endif
endif


if	MKF_INTEL
	extern	intel_28f002bxt(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:intel_28f002bxt,		0FFFFh,		0C000h
else
	dw	offset cgroup:intel_28f002bxt,		0A000h,		0C000h
endif
endif

else	; MKF_256K_BIOS
;-------;

if	MKF_AMD
	extern	amd_29f010(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:amd_29f010,		0FFFFh,		0C000h
else
	dw	offset cgroup:amd_29f010,		08000h,		0C000h
endif
endif

if	MKF_SST
	extern	sst_29ee010(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:sst_29ee010,		0FFFFh,		0E000h
else
	dw	offset cgroup:sst_29ee010,		0D000h,		0E000h
endif
endif

if	MKF_WINBOND
	extern	winbond_29ee011(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:winbond_29ee011,		0FFFFh,		0E000h
else
	dw	offset cgroup:winbond_29ee011,		0D000h,		0E000h
endif
endif

if	MKF_ATMEL
	extern	atmel_29c010(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:atmel_29c010,		0FFFFh,		0E000h
else
	dw	offset cgroup:atmel_29c010,		0D000h,		0E000h
endif
endif

if	MKF_MXIC
	extern	mxic_28f1000(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_28f1000,		0FFFFh,		0C000h
else
	dw	offset cgroup:mxic_28f1000,		08000h,		0C000h
endif
endif

if	MKF_MXIC_P
	extern	mxic_28f1000p(dummy_flash):byte		; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_28f1000p,		0FFFFh,		0E000h
else
	dw	offset cgroup:mxic_28f1000p,		0D000h,		0E000h
endif
endif

; (CORE0213+)>
if	MKF_MXIC_29F001T
	extern	mxic_29f001t(dummy_flash):byte
if	MKF_NO_NVRAM
	dw	offset cgroup:mxic_29f001t,		0FFFFh,		0E000h
else
	dw	offset cgroup:mxic_29f001t,		0D000h,		0E000h
endif
endif
; <(CORE0213+)

if	MKF_INTEL
	extern	intel_28f001bxt(dummy_flash):byte	; (CORE0073)
if	MKF_NO_NVRAM
	dw	offset cgroup:intel_28f001bxt,		0FFFFh,		0E000h
else
	dw	offset cgroup:intel_28f001bxt,		0D000h,		0E000h
endif
endif

endif	; MKF_256K_BIOS

endif
;-------------------------------------------------------;
no_of_flash_support_table_end	label	byte
	dw	0FFFFH,					0FFFFH,		0FFFFH	; END OF TABLE
flash_support_table_end	label	byte
;-----------------------------------------------------------------------;
	public	no_of_flash_supported
no_of_flash_supported	equ	(no_of_flash_support_table_end-flash_support_table)/6
	public	flash_support_entry_size
flash_support_entry_size equ	(flash_support_entry_end-flash_support_entry_start)
					; (CORE0073+)>
;---------------------------------------;
	public	dummy_flash
dummy_flash	label	byte
	dw	offset cgroup:no_id
no_id:
	or	sp,sp			; nz = flash not found
	ret
;---------------------------------------;
					; <(CORE0073+)
; <(CORE0071)
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
;-----------------------------------------------------------------------;
_text	ends
	end
