	page	,132
	title	EXTRA FUNCTIONS IN INT16
;---------------------------------------------------------------;
; NOTE:	Do not destroy SS,DS,ES,EBP unless otherwise specified.	;
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
	include	rt.equ
	include	makeflag.equ
;---------------------------------------;
	extrn	empty_8042_input_buffer:near
	extrn	cmos_data_in_x:near
	extrn	cmos_data_out_x:near
	extrn	get_cmos_item:near
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_I16_STARTS
_I16_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;
;				INT-16.ASM MODULE			;
; this routine gets control from from INT-16 ISR by JMP to support any	;
; special int-16 function if any. if you do not have any special func,	;
; simply return control to INT-16 ISR by JMP. otherwise do the special	;
; function and return control to INT-16 ISR by JMP.			;
; *********************************************************************	;
; *********************************************************************	;
; *******							*******	;
; *******			SPECIAL NOTE			*******	;
; *******							*******	;
; *******	Do not return control using IRET or RETF 2	*******	;
; *******	Always return control by JMP instruction	*******	;
; *******	with (AH) unchanged.				*******	;
; *******	special_int_16:					*******	;
; *******		....					*******	;
; *******		....					*******	;
; *******		JMP	special_int_16_end		*******	;
; *******							*******	;
; *******	THIS WAS A BUG ON PREVIOUS RELEASES.		*******	;
; *******	IBM-3270 program needs this procedure.		*******	;
; *******							*******	;
; *******	Final return value of (AH) will be changed	*******	;
; *******	inside original INT-16 routine.			*******	;
; *******							*******	;
; *******			07/07/93			*******	;
; *******							*******	;
; *********************************************************************	;
; *********************************************************************	;
; here is how INT-16 code will look like.				;
;int_16	proc	far							;
;	...								;
;	jmp	special_int_16						;
;special_int_16_end:							;
;	...								;
;	...								;
;int_16	endp								;
;=======================================================================;
;				SPECIAL_INT_16				;
;  input : 								;
;	ah	function#						;
;	stack	available						;
;  register usage -- do not destroy any register including (AH)		;
; *********************************************************************	;
; *********************************************************************	;
; *******							*******	;
; *******		DO NOT DESTROY (AH)			*******	;
; *******							*******	;
; *********************************************************************	;
; *********************************************************************	;
;-----------------------------------------------------------------------;
; New Functions in INT-16
;
;  1. SET CPU SPEED
;     Input		: AH = function# F0h
;			  AL = speed
;				00 low speed
;				01 low speed
;				02 high speed
;				03-FF..RESERVED (no action will taken if used)
;     Output		: None
;     Register Destroyed: None
;
;  2. RETURN CURRENT CPU SPEED
;     Input		: AH = function# F1h
;     Output		: AL = speed
;				00 low speed
;				01 low speed
;				02 high speed
;     Register Destroyed: AL
;
;  3. RETURN CACHE CONTROLLER STATUS
;     Input		: AH = function# F4h
;			  AL = 00h
;     Output		: AL = cache controller status
;				00 not present
;				01 enabled
;				02 disabled
;			  CX = cache size in KBytes
;				bit 15	 = 1..cache size information NOT valid
;					   0..cache size information valid
;				bit 14-0 = cache size in KBytes
;			  DH = cache write technology
;				bit 7	 = 1..cache write information NOT valid
;					   0..cache write information valid
;				bit 6-1  = RESERVED (set to 0)
;				bit 0	 = 0..write-through cache
;					   1..write-back cache
;			  DL = cache type
;				bit 7	 = 1..cache type information NOT valid
;					   0..cache type information valid
;				bit 6-1	 = RESERVED (set to 0)
;				bit 0	 = 0..direct mapped
;					   1..2-way set associative
;
;     Register Destroyed: AL CX DX if successful
;			  NONE if status can not be determined
;
;  4. ENABLE CACHE CONTROLLER
;     Input		: AH = function# F4h
;			  AL = 01h
;     Output		: NONE
;
;  5. DISABLE CACHE CONTROLLER
;     Input		: AH = function# F4h
;			  AL = 02h
;     Output		: NONE
;-----------------------------------------------------------------------;
	public	special_int_16		; special int 16 func if any
	extrn	special_int_16_end:near
special_int_16:
;---------------------------------------;
;  extra function for new Flash support
	push	bp
	cmp	ah,0e0h
	jnz	si16_00			; Not E0
	movzx	bp,al			; BP = subfunc#	
	sub	bp,10h
	cmp	bp,(offset special_int_16_e0_10_table_end-offset special_int_16_e0_10_table)/2
	jae	si16_00			; Not 10h onwards
	shl	bp,1
	cli				; disable interrupt
	call	[cgroup:special_int_16_e0_10_table+bp]
	pop	bp
	jmp	special_int_16_end	; goback to normal INT-16 ISR
si16_00:
	pop	bp
;---------------------------------------;
	push	ds
	push	si
	push	0040h
	pop	ds			; DS = 0040h
	mov	si,ax
;---------------------------------------;
IF	MKF_EXTRA_INT16_F0		; INT16 Func F0-F4 supported
	cmp	ah,0f0h			; special func ?
	jae	sp16_00			; yes..
ENDIF
;---------------------------------------;
	cmp	ah,0e0h			; flash func ?
	jnz	sp16_01			; no.. jmp to sp16_01 to exit int-16
sp16_e0:
	and	si,00ffh		; get the function number
	cmp	si,00ffh		; cpu reset func ?
	jnz	sp16_03			; no
	mov	si,offset cgroup:ah_e0_ff
	jmp	short sp16_02
sp16_03:
	cmp	si,(offset special_int_16_e0_table_end-offset special_int_16_e0_table)/2
	jae	sp16_01			; invalid func
	shl	si,1
	mov	si,[cgroup:special_int_16_e0_table+si]
	jmp	short sp16_02
sp16_00:
;---------------------------------------;
IF	MKF_EXTRA_INT16_F0		; INT16 Func F0-F4 supported
	shr	si,08h
	and	si,000fh
	cmp	si,(offset special_int_16_table_end-offset special_int_16_table)/2
	jae	sp16_01			; invalid func
	shl	si,1
	mov	si,[cgroup:special_int_16_table+si]
ENDIF
;---------------------------------------;
sp16_02:
	cli				; disable interrupt
	call	si
sp16_01:
	pop	si
	pop	ds
	jmp	special_int_16_end	; goback to normal INT-16 ISR
;-----------------------------------------------------------------------;
special_int_16_e0_10_table		label	word
	dw	offset cgroup:ah_e0_10	; 10h
	dw	offset cgroup:ah_e0_11	; 11h
special_int_16_e0_10_table_end		label	word
;-----------------------------------------------------------------------;
special_int_16_e0_table		label	word
	dw	offset cgroup:ah_e0_0	; get version no. of bios-flash interface
	dw	offset cgroup:ah_e0_1	; byte request for saving chipset env.
	dw	offset cgroup:ah_e0_2	; save chipset environment
	dw	offset cgroup:ah_e0_3	; restore chipset environment
	dw	offset cgroup:ah_e0_4	; set Vpp = low
	dw	offset cgroup:ah_e0_5	; set Vpp = high
	dw	offset cgroup:ah_e0_6	; flash write protect
	dw	offset cgroup:ah_e0_7	; flash write enable
	dw	offset cgroup:ah_e0_8	; flash select
	dw	offset cgroup:ah_e0_9	; flash deselect
	dw	offset cgroup:ah_e0_a	; verify allocation memory
	dw	offset cgroup:ah_e0_b	; save internal cache status
	dw	offset cgroup:ah_e0_c	; restore internal cache status
special_int_16_e0_table_end	label	word
;-----------------------------------------------------------------------;
;	AH_E0..FLASH PROGRAMMING UTILITY				;
;  input :								;
;	AH	function# E0h						;
;	AL	subfunction#						;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register usage : all registers (except return registers) must be	;
;		    saved except SI					;
;-----------------------------------------------------------------------;
;	AH_E0_0..GET VERSION NUMBER OF BIOS-FLASH INTERFACE		;
;  input :								;
;	AH	function# E0h						;
;	AL	00							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;		BX = Version number in BCD format			;
;		CX = attribute						;
;			bit-0 = 0..A16 inversion not available		;
;		   		1..A16 inversion available		;
;			bit-1 = 0..bootblock not programmable		;
;				1..bootblock portion programmable	;
;			bit15-2....reserved for future use (set to 0)	;
;  register destroyed : AL, BX, CX					;
;-----------------------------------------------------------------------;
ah_e0_0		proc	near
	mov	bx,350h			; BIOS-FLASH interface ver 3.50
;	xor	cx,cx
;;;;	or	cl,1			; bit-0 = 1..A16 inversion available
;ahe0_0_00::
;;;;	or	cl,2			; make bootblock programmable
	mov	cx,02h
;	call	off_cyrix		; WT_ALLOC = 0 if Cyrix 6x86 M1
ah_e0_exit::
	mov	al,0fah			; set success flag
	clc	
	ret
ah_e0_0		endp
;-----------------------------------------------------------------------;
;	AH_E0_1..REQUEST NUMBER OF BYTE FOR SAVING CHIPSET ENVIRONMENT	;
;  input :								;
;	AH	function# E0h						;
;	AL	01							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;		BX = # of bytes needed to save chipset environment	;
;  register destroyed : AL, BX						;
;-----------------------------------------------------------------------;
ah_e0_1		proc	near
	mov	bx,3h			; 3 bytes needed
	jmp	short ah_e0_exit
ah_e0_1		endp
;-----------------------------------------------------------------------;
;	AH_E0_2..SAVE AND PREPARE CHIPSET ENVIRONMENT			;
;  input :								;
;	AH	function# E0h						;
;	AL	02							;
;	DS	0040h							;
;	ES:DI	pointer to start of buffer where chipset		;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
	extrn	prepare_chipset_for_flash_programming:near
ah_e0_2		proc	near
	call	prepare_chipset_for_flash_programming
	jmp	short ah_e0_exit
ah_e0_2		endp
;-----------------------------------------------------------------------;
;	AH_E0_3..RESTORE CHIPSET ENVIRONMENT				;
;  input :								;
;	AH	function# E0h						;
;	AL	03							;
;	DS	0040h							;
;	ES:DI	pointer to start of buffer where chipset		;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
ah_e0_3		proc	near
;	call	check_cyrix		; Cx6x86 M1 found ?
;	jnz	ah_e0_exit		; no
;  Cx6x86 found, return with error, this will force system to reboot even
;  in case of non-fatal error
;	stc				; error
	jmp	short ah_e0_exit
;;	ret
ah_e0_3		endp
;-----------------------------------------------------------------------;
;	AH_E0_4..SET Vpp LOW						;
;  input :								;
;	AH	function# E0h						;
;	AL	04							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
	extrn	make_vpp_low:near
	extrn	Q_USB_LEGACY_ENABLE:abs
ah_e0_4		proc	near
	call	make_vpp_low
	mov	al,Q_USB_LEGACY_ENABLE
	call	get_cmos_item
	jz	ah_e0_exit 
	pushad
COMMENT ~
	mov	dx,pac_reg+pac_pam4_index
	mov	bx,0dc00h
get_usb_segment:
	call	read_chip_reg
	mov	ah,al
	and	al,30h
	cmp	al,30h
	jz	get_usb_segment_done
	sub	bh,04h
	and	ah,03h
	cmp	ah,03h
	jz	get_usb_segment_done
	sub	bh,04h
	dec	dx
	cmp	dl,pac_pam0_index
	jnz	get_usb_segment
get_usb_segment_done:
	movzx	ebx,bx
	shr	ebx,4
~
	mov	ebx,80000h
        mov     cl,00h                  ; Enumerate, Beep
        mov     ax,2f01h                ; Start USB Host
;        CALL_RT_FUNCTION
	push	cs
	push	offset cgroup:ah_e0_4_0
	push	cs
	push	0e008h
	retf
ah_e0_4_0:
	popad
	jmp	short ah_e0_exit
ah_e0_4		endp
;-----------------------------------------------------------------------;
;	AH_E0_5..SET Vpp High						;
;  input :								;
;	AH	function# E0h						;
;	AL	05							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
	extrn	make_vpp_high:near
ah_e0_5		proc	near
	call	make_vpp_high
	mov	al,Q_USB_LEGACY_ENABLE
	call	get_cmos_item
	jz	ah_e0_exit 
	push	ax
        mov     ax,2f02h                ; Stop USB Host controller
;        CALL_RT_FUNCTION
	push	cs
	push	offset cgroup:ah_e0_5_0
	push	cs
	push	0e008h
	retf
ah_e0_5_0:
	pop	ax
	jmp	short ah_e0_exit
ah_e0_5		endp
;-----------------------------------------------------------------------;
;	AH_E0_6..FLASH WRITE PROTECT					;
;  input :								;
;	AH	function# E0h						;
;	AL	06h							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
	extrn	flash_write_disable:near
ah_e0_6		proc	near
	call	flash_write_disable
	jmp	short ah_e0_exit
ah_e0_6		endp
;-----------------------------------------------------------------------;
;	AH_E0_7..FLASH WRITE ENABLE					;
;  input :								;
;	AH	function# E0h						;
;	AL	07h							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
	extrn	flash_write_enable:near
ah_e0_7		proc	near
	call	flash_write_enable
	jmp	short ah_e0_exit
ah_e0_7		endp
;-----------------------------------------------------------------------;
;	AH_E0_8..FLASH SELECT						;
;  input :								;
;	AH	function# E0h						;
;	AL	08h							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
ah_e0_8		proc	near
	jmp	short ah_e0_exit
ah_e0_8		endp
;-----------------------------------------------------------------------;
;	AH_E0_9..FLASH DE-SELECT					;
;  input :								;
;	AH	function# E0h						;
;	AL	09h							;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
ah_e0_9		proc	near
	jmp	short ah_e0_exit
ah_e0_9		endp
;-----------------------------------------------------------------------;
;	AH_E0_A..VERIFY ALLOCATED MEMORY				;
;  input :								;
;	AH	function# E0h						;
;	AL	0Ah							;
;	ES	specified memory segment				;
;	BX	memory size in number of paragraphs			;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
ah_e0_a		proc	near
	jmp	short ah_e0_exit
ah_e0_a		endp
;-----------------------------------------------------------------------;
;	AH_E0_B..SAVE INTERNAL CACHE STATUS				;
;  input :								;
;	AH	function# E0h						;
;	AL	0Bh							;
;	ES:DI	pointer to start of buffer where internal cache		;
;		status will be saved					;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
ah_e0_b		proc	near
	jmp	short ah_e0_exit
ah_e0_b		endp
;-----------------------------------------------------------------------;
;	AH_E0_C..RESTORE INTERNAL CACHE STATUS				;
;  input :								;
;	AH	function# E0h						;
;	AL	0Ch							;
;	ES:DI	pointer to start of buffer where internal cache		;
;		status will be restored					;
;	DS	0040h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;  register destroyed : AL						;
;-----------------------------------------------------------------------;
ah_e0_c		proc	near
	jmp	short ah_e0_exit
ah_e0_c		endp
;-----------------------------------------------------------------------;
;	AH_E0_FF..GENERATE CPU RESET 					;
;  input :								;
;	AH	function# E0h						;
;	AL	FFh							;
;	DS	0040h							;
;  output:								;
;	NONE								;
;  register destroyed : AX						;
;-----------------------------------------------------------------------;
        extern	StopUsbHostController(dummy_ret):near
	extrn	dummy_ret:near
	extrn	generate_hard_reset:near
ah_e0_ff	proc	near
	mov	ax,0c08eh
	call	cmos_data_out_x		; destroy CMOS checksum
	call	generate_hard_reset
;	call	StopUsbHostController	; disable USB host controller
;	call	empty_8042_input_buffer
;	mov	si,cs:word ptr [0fea8h]
;	mov	dx,cs:[si+0ch]		; DX = power-on CPU ID
;	db	0eah			; JMP FAR F000:FFF0
;	dw	0fff0h
;	dw	0f000h
ah_e0_ff	endp
;-----------------------------------------------------------------------;
;	AH_E0_10..GET FLASH INFO					;
;  input :								;
;	AH	function# E0h						;
;	AL	10h							;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;		BX = Version# in BCD					;
;		CX = #of Flash parts supported by BIOS (1-based)	;
;		DX = Index# of the Flash Part detected by BIOS (0-based);
;  register destroyed : AL BX CX DX					;
;-----------------------------------------------------------------------;
	extrn	flash_support_table:byte
	extrn	no_of_flash_supported:abs
ah_e0_10	proc	near
	mov	bx,0350h		; Ver# 3.50
	mov	cx,no_of_flash_supported
	mov	dx,cgroup:word ptr flash_support_table
	cmp	dx,0ffffh
	jz	ahe010_00		; BIOS did not install any flash part
	xor	dx,dx
ahe010_00:
	jmp	ah_e0_exit
ah_e0_10	endp
;-----------------------------------------------------------------------;
;	AH_E0_11..READ ROM BYTES					;
;  input :								;
;	AH	function# E0h						;
;	AL	11h							;
;		CX = #of bytes to be read				;
;		ES:DI = ptr to read buffer				;
;		DS:SI = ptr to start ROM address			;
;  output:								;
; 	CY 	Error							;
;	NC	Success							;
;		AL = 0FAH 						;
;		CX = #of bytes read					;
;  register destroyed : AL CX						;
;-----------------------------------------------------------------------;
	extrn	e000_read_rom_write_x:near
	extrn	f000_read_rom_write_x:near
	extrn	e000_read_ram_write_rom:near
	extrn	f000_read_ram_write_rom:near
ah_e0_11	proc	near
	pusha
	call	e000_read_rom_write_x
	call	f000_read_rom_write_x
	dec	cx
	rep	movsb
	movsb
	call	e000_read_ram_write_rom
	call	f000_read_ram_write_rom
	popa
	jmp	ah_e0_exit
ah_e0_11	endp
COMMENT ~
;-----------------------------------------------------------------------;
;			CYRIX Cx6x86 M1 Subroutines			;
;-----------------------------------------------------------------------;
;			OFF_CYRIX					;
;  this routine disbales WT_ALLOC bit (bit-0) in CCR5 in M1 cpu.	;
;  input :								;
;	none								;
;  output:								;
;	none								;
;  register destroyed : none						;
;-----------------------------------------------------------------------;
	extern	ReadCCR(dummy_ret):near
	extern	WriteCCR(dummy_ret):near
off_cyrix:
	pusha
	call	check_cyrix
	jnz	oc_00			; Cx6x86 not found
	call	unlock_ccr
	mov	al,0e9h
	call	ReadCCR
	and	ah,0feh			; bit-0 WT_ALLOC = 0
	call	WriteCCR
	call	lock_ccr
oc_00:
	popa
	ret
;-----------------------------------------------------------------------;
;			CHECK_CYRIX_M1					;
;  this routine checks whether current CPU is Cyrix M1.			;
;  input :								;
;	none								;
;  output:								;
;	zr	Cyrix M1						;
;	nz	not Cyrix M1						;
;  register destroyed : none						;
;-----------------------------------------------------------------------;
	extrn	get_processor_info:near
check_cyrix:
	pushad
	call	get_processor_info	; AX = function field
	and	ah,01100000b
	cmp	ah,00100000b		; ZR/NZ = Cx6x86 found/not found
	popad
	ret
;-----------------------------------------------------------------------;
;			UNLOCK_CCR					;
;  this routines locks/unlocks access to CCR registers in Cyrix M1.	;
;  input :								;
;	none								;
;  output:								;
;	zr	Cyrix M1						;
;	nz	not Cyrix M1						;
;  register destroyed : AX BX						;
;-----------------------------------------------------------------------;
unlock_ccr:
	mov	bl,10h
uc_00:
	mov	al,0c3h
	call	ReadCCR
	or	ah,bl
	and	ah,0feh
	call	WriteCCR
	ret
lock_ccr:
	mov	bl,00h
	jmp	short uc_00
~
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
IF	MKF_EXTRA_INT16_F0		; INT16 Func F0-F4 supported
	extrn	frequency_low:near
	extrn	frequency_high:near
	extrn	cache_off:near
	extrn	cache_on:near
special_int_16_table		label	word
	dw	offset cgroup:ah_f0	; set cpu speed
	dw	offset cgroup:ah_f1	; return cpu speed
	dw	offset cgroup:ah_invalid; invalid function
	dw	offset cgroup:ah_invalid; invalid function
	dw	offset cgroup:ah_f4	; external cache
special_int_16_table_end	label	word
;-----------------------------------------------------------------------;
;	AH_F0..SET CPU SPEED						;
;  input :								;
;	AH	function# F0h						;
;	AL	speed							;
;		00 low speed						;
;		01 low speed						;
;		02 high speed						;
;		03-FF..RESERVED (no action will taken if used)		;
;	DS	0040h							;
;  output:								;
;	none								;
;  register usage..all registers must be saved except SI		;
;-----------------------------------------------------------------------;
ah_f0	proc	near
	cmp	al,02h			; high speed ?
	ja	ahf0_00			; invalid speed..no action
	mov	si,offset cgroup:frequency_high
	jz	ahf0_01			; high speed
	mov	si,offset cgroup:frequency_low
ahf0_01:
	push	cx
	call	si			; change speed
	pop	cx
	mov	ah,0f0h			; set ah not changed
ahf0_00:
ah_invalid::
	ret
ah_f0	endp
;-----------------------------------------------------------------------;
;	AH_F1..RETURN CPU SPEED						;
;  input :								;
;	AH	function# F1h						;
;	DS	0040h							;
;  output:								;
;	AL	speed							;
;		00 low speed						;
;		01 low speed						;
;		02 high speed						;
;  register usage..all registers must be saved except SI		;
;-----------------------------------------------------------------------;
ah_f1	proc	near
	mov	al,00h			; return code for low speed
	test	ds:byte ptr [0016h],00100000b; bit-5 = 0/1..high/low speed
	jnz	ahf1_00			; low speed
	mov	al,02h			; return code for high speed
ahf1_00:
	ret
ah_f1	endp
;-----------------------------------------------------------------------;
;	AH_F4..CACHE							;
;  input :								;
;	AH	function# F1h						;
;	AL	subfunction#						;
;	DS	0040h							;
;  output:								;
;  register usage..all registers (except return registers) must be	;
;		   saved except SI					;
;-----------------------------------------------------------------------;
ah_f4	proc	near
	or	al,al			; subfunc# 00h ?
	jz	ahf4_00			; yes..
	mov	si,offset cgroup:cache_off
	cmp	al,02h			; subfunc# 02h ?
	ja	ahf4_03			; invalid subfunction
	jz	ahf4_02			; subfunc# 02h
	mov	si,offset cgroup:cache_on
ahf4_02:
	push	cx
	call	si			; enable/disable external cache
	or	ch,ch			; cache operation done ?
	pop	cx
	jmp	short ahf4_03
ahf4_00:
;-----------------------------------------------------------------------;
;  subfunction# 00h..return cache controller status			;
;     Input		: AH = function# F4h				;
;			  AL = 00h					;
;     Output		: 						;
;			  AL = cache controller status			;
;			  CX = cache size in KBytes			;
;			  DH = cache write technology			;
;			  DL = cache type				;
;     Register Destroyed: AX CX DX if successful			;
;			  NONE if status can not be determined		;
;-----------------------------------------------------------------------;
	mov	al,33h			; cmos reg 33h..enable NMI
	call	cmos_data_in_x
	test	al,00000001b		; bit-0 = 0/1..cache bad/good
	jnz	ahf4_06			; external cache present
;  external cache not present..check for internal cache..
	smsw	ax
	or	ah,ah
	mov	al,00h			; return code for cache not present
	jnz	ahf4_05			; 386/286 cpu..no internal cache
ahf4_06:
	mov	al,01h			; return code for cache enabled
	test	ds:byte ptr [0016h],00010000b; bit-4 = 0/1..cache dis/en abled
	jnz	ahf4_05			; cache enabled
	mov	al,02h			; return code for cache disabled
ahf4_05:
	call	get_cache_informn	; get cache information
ahf4_03:
	mov	ah,0f4h			; ah remain same as this routine is called
	ret
ah_f4	endp
;-----------------------------------------------------------------------;
;			GET_CACHE_INFORMN				;
;  this routine returns the external cache information.			;
;  input :								;
;	DS	0040h							;
;  	stack	available						;
;  output:								;
;	cx	cache size						;
;		bit 15	= 0/1..cache size information valid/invalid	;
;		bit 14-0= cache size in KBytes				;
;	dh	cache write technology					;
;		bit 7	= 0/1..cache write technology informn valid/invalid
;		bit 6-1 = RESERVED (set to 0)				;
;		bit 0	= 0..write-through cache			;
;			  1..write-back    cache			;
;	dl	cache type						;
;		bit 7	= 0/1..cache type information valid/invalid	;
;		bit 6-1 = RESERVED (set to 0)				;
;		bit 0	= 0..direct mapped cache			;
;			  1..2-way set associative cache		;
;  register usage -- DO NOT DESTROY ANY REGISTER except CX DX		;
;-----------------------------------------------------------------------;
get_cache_informn	proc	near
;  this routine has to return information of cache size in CX, of cache write
;  technology in DH, of cache type in DL..
;  DO NOT DESTROY ANY REGISTER EXCEPT CX, DX
;  let us take some examples:
;  example 1.	NONE OF THE INFORMATION IS AVAILABLE
;		in this case return value of CX = 8000h, DX = 8080h
;  example 2.	64KB CACHE, CACHE WRITE AND CACHE TYPE INFORMATION IS
;		NOT AVAILABLE
;		in this case return value of CX = 0040h, DX = 8080h
;  example 3.	WRITE-BACK CACHE, CACHE SIZE AND CACHE TYPE INFORMATION IS
;		NOT AVAILABLE
;		in this case return value of CX = 8000h, DX = 0180h
;  example 4.	2-WAY SET ASSOCIATIVE CACHE, CACHE SIZE AND CACHE WRITE
;		INFORMATION IS NOT AVAILABLE
;		in this case return value of CX = 8000h, DX = 8001h
;  example 5.	512KB, WRITE-THROUGH, DIRECT-MAPPED CACHE
;		in this case return value of CX = 0200h, DX = 0000h

	mov	cx,8000h		; cache size informn invalid
	mov	dx,8080h		; cache write, cache type informn invalid
	ret
get_cache_informn	endp
;-----------------------------------------------------------------------;
ENDIF
;-----------------------------------------------------------------------;
	public	_I16_ENDS
_I16_ENDS	label	byte		; marks end of module
;---------------------------------------;
_text	ends
	end
