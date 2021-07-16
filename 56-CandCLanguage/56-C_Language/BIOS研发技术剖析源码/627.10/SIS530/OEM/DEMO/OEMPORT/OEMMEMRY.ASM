	page	,132
	title	OEM HOOKS AT POWER-ON AND MEMORY SIZING
;---------------------------------------------------------------;
; NOTE:	Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.
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
;---------------------------------------;
	include	mbiosmac.mac
	include makeflag.equ
;---------------------------------------;
	public	u_sis5595_pci2isa_init_table
	public	u_sis530_init_table
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_OEMMEMRY_STARTS
_OEMMEMRY_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;			OEM_U_POWER_ON_INIT				;
;-----------------------------------------------------------------------;
;  this routine is to do any OEM specific stuff at POWER-ON after the	;
;  chipset specific stuff is done at U_POWER_ON_INIT.			;
;  NOTHING IS DEFINED (except EDX) ON ENTRY TO THIS ROUTINE.		;
;  input :								;
;	EDX	cpu id							;
;	SS = CS								;
;	stack	not available						;
;  output:								;
;	none								;
;  register usage : can destroy any register except EDX,SS,FS,GS	;
;-----------------------------------------------------------------------;
	public	oem_u_power_on_init
	extrn	cmos_data_in:near
	extrn	write_pmu_byte_x:near
	extrn	read_pmu_byte_x:near
	extrn	oem_u_power_on_init_end:near
	extrn	read_sio_byte_x:near
	extrn	write_sio_byte_x:near
oem_u_power_on_init:
	mov	ax,07388h
	jmp_di	write_pmu_byte_x

;; turn off ACPI led
	mov	ah,045h
	jmp_di	read_sio_byte_x
	or	al,02h
	jmp_di	write_sio_byte_x

	mov	al,04h
	out	70h,al
	jmp	short $+2
	in	al,71h
	jmp	short $+2
	or	al,08h
	and	al, not 03h
	jmp	short $+2
	out	71h,al

	mov	ah,045h
	jmp_di	read_sio_byte_x
	and	al,not 02h
	jmp_di	write_sio_byte_x

	jmp	oem_u_power_on_init_end
;-----------------------------------------------------------------------;
;				OEM_U_CP_INIT				;
;-----------------------------------------------------------------------;
; check_point		: D3						;
; This routine is called from U_CP_INIT after memory sizing is done and	;
; can be used to do OEM specific initialisation.			;
; input :								;
;	refresh	started							;
;	SS	= CS							;
;	DS	0000H							;
;	ES	0000H							;
;	DS & ES set to 4GB limit					;
;	stack	NOT available						;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
;-----------------------------------------------------------------------;
	public	oem_u_cp_init		; chipset register programming
	extrn	oem_u_cp_init_end:near
oem_u_cp_init:
if (MKF_ONCHIP_LM78)
;; Start LM78 Function
	mov	al,40h
;	mov	dx,295h
	mov	dx,MKF_LM78_BASE_ADDRESS
	out	dx,al
	jmp	short $+2
	mov	al,1
	inc	dx
	out	dx,al
endif

	jmp	oem_u_cp_init_end
;-----------------------------------------------------------------------;
;		INITIALIZATION TABLES USED IN U_CP_INIT			;
;  Put all the tables which are used in U_CP_INIT hook in MEMORY.ASM	;
;  and may be different for different OEMs.				;
;-----------------------------------------------------------------------;
u_sis5595_pci2isa_init_table label byte
;		Reg.	AND	OR
if MKF_256K_BIOS
	db	040h,	000h,	0cbh
else
	db	040h,	000h,	0cah
endif
	db	045h,	000h,	020h
	db	048h,	008h,	0f7h
if (MKF_USB_SUPPORT)
        db      062h,	030h,	0c0h          ; usbirq enable
else
        db      062h,	030h,	080h          ; usbirq disable
endif
	db	064h,	000h,	034h
	db	06dh,	0fdh,	002h		; Enable I2C 
	db	070h,	0e3h,	01ch		
	db	07bh,	0efh,	080h		; Enabled LM78
        db      091h,	000h,	MKF_PM_BASE_HIGH; ACPI_BASE_ADDRESS high address
        db      090h,	03fh,	MKF_PM_BASE_LOW ; ACPI_BASE_ADDRESS low address
	db	004h,	0fch,	003h
	db	000h				; END

u_sis5595_pci2isa_init_table_end label byte

u_sis530_init_table label byte
;		Reg.	AND	OR
	db	051h,	0bfh,	00h		;
;	db	055h,	030h,	0bh		;
	db	055h,	030h,	0dh		;
	db	058h,	0afh,	050h		;
	db	087h,	011h,	044h		;
	db	05dh,	0f7h,	008h		; Set CAS Latency 3
	db	064h,	001h,	000h		; Memory Buffer Strength
	db	064h,	0fch,	000h		; Memory Buffer Strength
	db	06bh,	000h,	MKF_PM_BASE_HIGH
	db	06ah,	01eh,	MKF_PM_BASE_LOW+1
	db	076h,	017h,	008h		; !!Legacy USB!!
	db	004h,	0fdh,	002h		; Enable Memory Space
	db	000h				; END
u_sis530_init_table_end label byte


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
	public	_OEMMEMRY_ENDS
_OEMMEMRY_ENDS	label	byte		; marks end of module
;---------------------------------------;
_text	ends
	end
