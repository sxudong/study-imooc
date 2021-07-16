;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1997, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**********************************************************************;
;*****************************************************************;
; Chipset Specific Functions For ACPI Support - REQUIRED          ;
;                                                                 ;
;   This file is required for proper ACPI support. This file is   ;
;   included by ACPITBL.ASM, and contains chipset hooks which     ;
;   must be ported for the generic/chipset source code.           ;
;*****************************************************************;

;*****************************************************************;
; Porting Step #1 - Include any chipset equate/include files      ;
;*****************************************************************;
	include	makeflag.equ
	include	sis530.equ
;*****************************************************************;
; Porting Step #2 - Before porting hooks in this file, go to      ;
;                   ACPI_CSS.EQU. Define additional chipset       ;
;                   specific equates which are located in         ;
;                   ACPI_CSS.EQU (REQUIRED for ACPITBL.ASM)       ;
;*****************************************************************;

;*****************************************************************;
; Porting Step #3 - Implement the functions below. They will be   ;
;                   called by ACPITBL.ASM when the ACPI Tables    ;
;                   are built during POST.                        ;
;                   NOTE: Use Int 1Ah to access PCI Config Space. ;
;*****************************************************************;
	include		p6.equ
;-----------------------------------------------------------------------;
; acpi_css_pmregs_base_addr (PORTING OPTIONAL)				;
;									;
; Destroys DX, returns PM Base Address in DX				;
; 	Input:		None						;
;	Output:		DX	PM Base Address				;
;	Destroys:	DX						;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
; This hook should be used for chipsets that locate all ACPI-related	;
; registers at a fixed offset from a base address (i.e. Intel PIIX4).	;
; - This hook is to be used locally (only for functions in this file).	;
; Chipsets which do not define ACPI register locations as base + fixed	;
; offset (i.e. OPTi Firestar Plus) do not require this hook.		;
;-----------------------------------------------------------------------;
acpi_css_pmregs_base_addr	proc	near

	mov	edx,MKF_PM_BASE_ADDRESS

	ret
acpi_css_pmregs_base_addr	endp

;-----------------------------------------------------------------------;
; acpi_css_clear_status_flags (PORTING REQUIRED)			;
;									;
;  Clear ACPI status Flags before building the tables			;
;  No input, no output							;
;  DO NOT DESTROY ANY REGISTERS						;
; This hook clears all ACPI Status/Event registers before building the	;
; ACPI tables (to avoid spurious events). Clear the contents of all	;
; applicable registers here.
;-----------------------------------------------------------------------;
acpi_css_clear_status_flags	proc	private

	pusha


	call	acpi_css_pmregs_base_addr

	add	dx,14h
	in	al,dx
	jmp	short $+2
	jmp	short $+2
	out	dx,al

	inc	dx
	in	al,dx
	jmp	short $+2
	jmp	short $+2
	out	dx,al

	inc	dx
	in	al,dx
	jmp	short $+2
	jmp	short $+2
	out	dx,al

	inc	dx
	in	al,dx
	jmp	short $+2
	jmp	short $+2
	out	dx,al

	popa

	ret
acpi_css_clear_status_flags	endp

;-----------------------------------------------------------------------;
; acpi_css_return_sci_vector (PORTING REQUIRED)				;
;									;
;	Input:		none						;
;	Output:		DX	SCI IRQ (i.e. IRQ 9 returned as 0009h)	;
;	Destroys:	EDX						;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
;									;
; Return IRQ allocated to SCI.						;
;-----------------------------------------------------------------------;
acpi_css_return_sci_vector	proc	private
	push	ax
	push	bx
	push	cx
	push	di
	mov	ax,0b109h		; Read Byte
	mov	di,06ah
	mov	bx,S5595_PCI2ISA_DEV_FUNC_NUM 
	int	1ah
	and	cl,0fh
	movzx	dx,cl
	pop	di
	pop	cx
	pop	bx
	pop	ax
	ret
acpi_css_return_sci_vector	endp

;-----------------------------------------------------------------------;
; acpi_css_return_smi_port (PORTING REQUIRED)				;
;									;
;	Input:		none						;
;	Output:		EDX	Port used for software SMI		;
;	Destroys:	EDX						;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
;									;
; Return Software SMI Command Port Address (hex value)			;
; - on chipsets with hard-coded address, return address in EDX		;
; - on chipsets where software SMI command port address can be modified,;
;   read from appropriate register(s) and return current value		;
;-----------------------------------------------------------------------;
acpi_css_return_smi_port	proc	private

	mov	edx,MKF_PM_BASE_ADDRESS+35h
	push	ax
	push	bx
	push	cx
	push	di
	mov	ax,0b109h		; Read Byte
	mov	di,008h
	mov	bx,S5595_PCI2ISA_DEV_FUNC_NUM 
	int	1ah
	cmp	cl,01h
	pop	di
	pop	cx
	pop	bx
	pop	ax
	jnz	short @f
	mov	dl,32h
@@:
	ret
acpi_css_return_smi_port	endp

;-----------------------------------------------------------------------;
; acpi_css_setup_pm1a_evt_cnt (PORTING REQUIRED)			;
;									;
;	Input:		none						;
;	Output:		EDX		PM1a event Block Address	;
;			EBX		PM1a control Block Address	;
;	Destroys:	EDX, EBX					;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
; Return the starting address of the PM1A Register Block. If the PM1B	;
; block does not exist, this may be referred to by the chipset manual	;
; as the PM1 Block Address.						;
;-----------------------------------------------------------------------;
acpi_css_setup_pm1a_evt_cnt	proc	private

	call	acpi_css_pmregs_base_addr; edx = base address
	mov	ebx,edx
	add	edx,0			; PM1a_EVT_BLK = base + 0
	add	ebx,4			; PM1a_CNT_BLK = base + 4

	ret
acpi_css_setup_pm1a_evt_cnt	endp

;-----------------------------------------------------------------------;
; acpi_css_setup_pm1b_evt_cnt (PORTING REQUIRED)			;
;									;
;	Input:		none						;
;	Output:		EDX	PM1b event Block Address		;
;			EBX	PM1b control Block Address		;
;	Destroys:	EDX, EBX					;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
; Return the starting address of the PM1B Register Block. This block is	;
; not present on all chipsets. If the PM1B Block is not implemented,	;
; EDX & EBX should return as zero.					;
;-----------------------------------------------------------------------;
acpi_css_setup_pm1b_evt_cnt	proc	private
	xor	edx, edx	;; default - return 0 if PM1b not supported
	xor	ebx, ebx	;; default - return 0 if PM1b not supported

	ret
acpi_css_setup_pm1b_evt_cnt	endp

;-----------------------------------------------------------------------;
; acpi_css_setup_pm1_length (PORTING REQUIRED)				;
;									;
;	Input:		none						;
;	Output:		DL	PM1_EVT_LEN for FACS Table		;
;				(Length of PM1a_EVT_BLK + PM1b_EVT_BLK)	;
;			BL	PM1_CNT_LEN for FACS Table		;
;				(Length of PM1a_CNT_BLK + PM1b_CNT_BLK)	;
;	Destroys:	EDX, EBX					;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
; This hook returns the length (in bytes) of the PM1 Event and PM1	;
; Control blocks. On most chipsets DL=4 & BL=2.				;
;-----------------------------------------------------------------------;
acpi_css_setup_pm1_length	proc	private

	mov	dl,4
	mov	bl,2

	ret
acpi_css_setup_pm1_length	endp

;-----------------------------------------------------------------------;
; acpi_css_setup_pm2_blk (PORTING OPTIONAL)				;
;									;
;	Input:		none						;
;	Output:		EDX	PM2 Block Address			;
;			BL	PM2 Block Length			;
;	Destroys:	EDX, EBX					;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
;									;
; This function returns the address of the PM2 Register Block		;
; (PM2_CNT_BLK). This register block is not required by ACPI, and is	;
; not supported by all chipsets (used by OPTi Firestar, not used by	;
; Intel PIIX4). The function returns EDX=0 if PM2 is not present.	;
;-----------------------------------------------------------------------;
acpi_css_setup_pm2_blk		proc	private
	call	acpi_css_pmregs_base_addr; edx = base address
	add	dx,12h
	mov	bl, 1

	ret
acpi_css_setup_pm2_blk		endp

;-----------------------------------------------------------------------;
; acpi_css_setup_gpe0_blk (PORTING REQUIRED)				;
;									;
;	Input:		none						;
;	Output:		EDX	GPE0 Block Address			;
;			BL	GPE0 Block Length			;
;	Destroys:	EDX, EBX					;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
; This returns the I/O address & length of the General Purpose Event 0	;
; (GPE0) register block. BL is always a non-negative multiple of 2.	;
;-----------------------------------------------------------------------;
acpi_css_setup_gpe0_blk		proc	private

	call	acpi_css_pmregs_base_addr; edx = base address
	add	dx,014h
	mov	bl,8
	ret
acpi_css_setup_gpe0_blk		endp

;-----------------------------------------------------------------------;
; acpi_css_setup_gpe1_blk (PORTING REQUIRED)				;
;									;
;	Input:		none						;
;	Output:		EDX	GPE1 Block Address			;
;			BL	GPE1 Block Length			;
;	Destroys:	EDX, EBX					;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
; This returns the I/O address & length of the General Purpose Event 1	;
; (GPE1) register block. BL is always a non-negative multiple of 2.	;
; GPE1 is not required. If the chipset does not support it, EDX & BL	;
; should return as 0.							;
;-----------------------------------------------------------------------;
acpi_css_setup_gpe1_blk		proc	private
	xor	edx,edx
	xor	bl,bl
	ret
acpi_css_setup_gpe1_blk		endp

;-----------------------------------------------------------------------;
; acpi_css_setup_pm_tmr_blk (PORTING REQUIRED)				;
;									;
;	Input:		none						;
;	Output:		EDX	TMR Block Address			;
;			BL	TMR Block Length			;
;	Destroys:	EDX, EBX					;
;	DO NOT DESTROY ANY OTHER REGISTERS				;
; This function returns the I/O address & length of the Power Management;
; Timer block. BL will be either 3 (24 bit) or 4 (32 bit), depending on	;
; the chipset's configuration.						;
;-----------------------------------------------------------------------;
acpi_css_setup_pm_tmr_blk	proc	private

	call	acpi_css_pmregs_base_addr; edx = base address
	add	dx,8
	mov	bl,4
	ret
acpi_css_setup_pm_tmr_blk	endp

;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1997, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;

