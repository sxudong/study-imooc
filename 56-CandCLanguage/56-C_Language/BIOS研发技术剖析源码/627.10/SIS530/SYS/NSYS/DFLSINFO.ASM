	page	,132
	title	DUMMY FLASH SUPPORT TABLE
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
	include	makeflag.equ
	include	oemmake.equ
;-----------------------------------------------------------------------;
;  this file contains a table having the information of different Flash	;
;  part support present in the BIOS.					;
;-----------------------------------------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;-----------------------------------------------------------------------;
;			FLASH_SUPPORT_TABLE				;
;  this table contains a table having the different Flash part support	;
;  present in the BIOS.							;
;-----------------------------------------------------------------------;
	public	flash_found_table
	public	flash_support_table
	public	flash_support_table_end
		;  flash routine table offset,		start of NVRAM, start of boot block
flash_found_table	label	byte
;---------------------------------------;
;  this entry will be initialized with the proper entry of the flash part found
flash_support_entry_start	label	byte
	dw	0FFFFh,					0FFFFh,		0FFFFh
flash_support_entry_end		label	byte
;---------------------------------------;
flash_support_table	label	byte
no_of_flash_support_table	label	byte
if	MKF_AMD2M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					0A000h,		0C000h
endif
endif

if	MKF_SST2M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					0A000h,		0C000h
endif
endif

if	MKF_ATMEL2M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					0A000h,		0C000h
endif
endif

if	MKF_WINBOND2M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					0A000h,		0C000h
endif
endif

if	MKF_INTEL2M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					0A000h,		0C000h
endif
endif

if	MKF_CATALYST2M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					0A000h,		0C000h
endif
endif

if	MKF_AMD1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					08000h,		0C000h
endif
endif

if	MKF_SST1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0E000h
else
	dw	0FFFFh,					0D000h,		0E000h
endif
endif
	
if	MKF_WINBOND1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0E000h
else
	dw	0FFFFh,					0D000h,		0E000h
endif
endif
	
if	MKF_ATMEL1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0E000h
else
	dw	0FFFFh,					0D000h,		0E000h
endif
endif

if	MKF_MEGAFLASH1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0E000h
else
	dw	0FFFFh,					0D000h,		0E000h
endif
endif

if	MKF_MXIC1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0C000h
else
	dw	0FFFFh,					08000h,		0C000h
endif
endif

if	MKF_MXICP1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0E000h
else
	dw	0FFFFh,					0D000h,		0E000h
endif
endif

if	MKF_INTEL1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0E000h
else
	dw	0FFFFh,					0D000h,		0E000h
endif
endif

if	MKF_CATALYST1M
if	MKF_NO_NVRAM
	dw	0FFFFh,					0FFFFh,		0E000h
else
	dw	0FFFFh,					0D000h,		0E000h
endif
endif

no_of_flash_support_table_end	label	byte

	dw	0FFFFH,					0FFFFH,		0FFFFH	; END OF TABLE
flash_support_table_end	label	byte
;-----------------------------------------------------------------------;
	public	no_of_flash_supported
	public	flash_support_entry_size
flash_support_entry_size equ	(flash_support_entry_end-flash_support_entry_start)
no_of_flash_supported	equ	(no_of_flash_support_table_end-flash_support_table)/6
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
_text	ends
	end
