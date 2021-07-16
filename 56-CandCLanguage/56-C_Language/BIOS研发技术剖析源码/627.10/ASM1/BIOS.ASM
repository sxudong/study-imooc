	page	,132
	title .				PROCESSOR_TIMER_PARITY_REFRESH_NMI TEST
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
	include	mbiosequ.equ		; bios global constants
	include	mbiosmac.mac		; bios coding macro definition
	include	cf.equ
;---------------------------------------;
	extrn	check_point_no_stack:near
	extrn	check_point_stack:near

	public	bios_suru
	public	shutdown_0
	public	shutdown_77
	public	shutdown_88

	extrn	shutdown_1:near		; shutdown after memory error
	extrn	shutdown_2:near		; v_mode exception intr error
	extrn	_shutdown_33:near	; shutdown after memory test
	extrn	shutdown_4:near		; boot loader request shutdown
	extrn	shutdown_5:near		; user defined shutdown routine
	extrn	_shutdown_66:near	; shutdown during memory test to display memory size
	extrn	shutdown_7:near		; unused, (chipset memory detection)
	extrn	shutdown_8:near		; unused, (soft reset)
	extrn	shutdown_9:near		; shutdown after block move
	extrn	shutdown_a:near		; user defined shutdown routine

	extrn	init_8259_80287:near	; shut 4/5, init 8259, 80287
	extrn	disable_video:near
	extrn	clear_64k_memory:near
	extrn	int_isr:near

	extrn	_power_on_delay:byte
	extrn	_software_delay:byte
	extrn	ram_segment:word
	extrn	flush_all_cache:near

	extrn	power_on_init:near
	public	power_on_init_end
	extrn	hreset_clear:near
	public	hreset_clear_end
	extrn	sreset_clear:near
	public	sreset_clear_end
	extern	StopUsbHostController(dummy_ret):near
	extrn	dummy_ret:near
	extrn	disable_all_cache:near
	extrn	shutdown_init:near
	public	shutdown_init_end
	extrn	decompress_post_init:near
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_BIOS_STARTS
_BIOS_STARTS	label	byte		; marks start of module
;---------------------------------------;
;	FLAGS TEST (SF,ZF,PF,CF)	;
;   ;---;---;---;---;---;---;---;---;	;
;   ; S ; Z ; x ; A ; x ; P ; x ; C ;	;
;   ;---;---;---;---;---;---;---;---;	;
;     HARD RESET OR SHUTDOWN RESET	;
;---------------------------------------;
;	SHUTDOWN PROCESSING		;
;---------------------------------------;
bios_suru:
	cli				; test under CLI mode
	cld				; ensure direction
	mov	ax,cs
	mov	ss,ax
; $$$CORE0036+ >>>
	extern	wake_up(wake_up_end):near
	public	wake_up_end
	jmp	wake_up			; check for wakeup
wake_up_end:				; control will come here only if wake up is not needed
; $$$CORE0036+ <<<
	jmp	power_on_init
power_on_init_end:
	in	al,kb_stat_port		; if sys_flag bit is set
	test	al,00000100b		; then soft reset else power on
	jnz	shut_5			; not power-on
;---------------------------------------;
;	VANILLA MEMORY PATCH		;
;---------------------------------------;
ifdef	VANILLA_BIOS
;---------------------------------------;
;  save CPUID in cmos 35h(DL), 36h(DH)
	extrn	cmos_data_out:near
	extrn	_refresh_value:byte
	mov	ebp,edx
	mov	al,0b5h
	mov	ah,dl
	ret_sp	cmos_data_out
	mov	al,0b6h
	mov	ah,dh
	ret_sp	cmos_data_out
;  start memory refresh..
	mov	al,00h			; initialise DMA-PAGE reg.
	out	8fh,al			; (used in MEMORY REFRESH)
	io_delay
	mov	al,01010100b		; start CH_1 (REFRESH)
	out	43h,al			; one byte count used
	io_delay
	mov	al,cgroup:_refresh_value; low byte count
	out	41h,al
	mov	cx,100h			; 400h..01/11/95
	xor	di,di
	mov	es,di
wpulse1:
	stosb
	loop	wpulse1
;---------------------------------------;
	extrn	vanilla_patch_offset:near
	cmp	cgroup:word ptr vanilla_patch_offset,0ffffh
	jz	ret_off			; no routine
	mov	sp,offset cgroup:sp_ret_off
	jmp	vanilla_patch_offset-1
	even
sp_ret_off:
	dw	offset cgroup:ret_off
	dw	0f000h
ret_off:
endif
;---------------------------------------;
	jmp	hreset_clear		; hard reset init (if any)
;;;;hreset_clear_end:
;;;;	jmp	shutdown_0x		; hard reset, goto regs. test
shut_5:
	jmp	sreset_clear		; GA20 disable and other....
sreset_clear_end:
	mov	al,8fh			; shutdown address
	out	cmos_addr_port,al	; mask NMI & select shut byte
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	in	al,cmos_data_port	; read shutdown code
	mov	ah,00
	mov	si,ax			; save in (SI)
	mov	al,8fh			; shutdown address
	jcxz	short $+2		; i/o delay
	out	cmos_addr_port,al
	mov	al,00			; clear shutdown byte
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	out	cmos_data_port,al
	mov	ax,cs
	mov	ss,ax
	mov	ax,si			; restore shutdown code
	cmp	al,04h			; for BOOT loader shutdown
	jz	shut_1			; & for USER defined shutdown
	cmp	al,05h			; initialize 8259 (#1, #2)
	jz	shut_1			; and (DS), (SS), (SP), STI
	cmp	al,0ah			; if shut code > 10
	jbe	shut_2			; bypass intr. init
	jmp	short shutdown_0	; then hard reset
;---------------------------------------;
;	INIT 8259 for SHUTDOWN 04, 05	;
;---------------------------------------;
shut_1:
	mov	bx,level_2_int*256+level_1_int
	ret_sp	init_8259_80287		; shut 4/5, init 8259, 80287
;---------------------------------------;
;	INTERNAL CACHE IS ALWAYS ON	;
;---------------------------------------;
shut_2:
	jmp	shutdown_init
shutdown_init_end:
	mov	ax,40h			; global data segment (ah) = 0
	mov	ds,ax			; setup (DS)
	mov	al,00h			; global extra segment (ah) = 0
	mov	es,ax			; setup (ES)
	mov	al,30h			; global stack segment (ah) = 0
	mov	ss,ax			; setup (SS)
	mov	sp,0100h		; setup (SP)
	shl	si,1			; prepare index
	jmp	[si+cgroup:shut_jmp_tbl]; brunch with intr. disabled
;---------------------------------------;
;	SHUTDOWN JMP TABLE		;
;---------------------------------------;
	even
shut_jmp_tbl	label	word
	dw	offset cgroup:shutdown_0; hard reset
	dw	offset cgroup:shutdown_1; used for block move internal shutdown
	dw	offset cgroup:shutdown_2; v_mode exception intr error
	dw	offset cgroup:_shutdown_33; shutdown after memory test
	dw	offset cgroup:shutdown_4; shutdown for boot loader
	dw	offset cgroup:shutdown_5; shutdown (with intr. init)
	dw	offset cgroup:_shutdown_66; shutdown during memory test to display memory size
	dw	offset cgroup:shutdown_7; unused, (chipset memory detection)
	dw	offset cgroup:shutdown_8; unused, (soft reset)
	dw	offset cgroup:shutdown_9; shutdown after block move
	dw	offset cgroup:shutdown_a; shutdown (w/o intr. init)
;---------------------------------------;
hreset_clear_end:
shutdown_0x:				; hard reset
	mov	al,8dh
	out	cmos_addr_port,al	; NMI OFF
;---------------------------------------;
shutdown_0:				; hard reset
shutdown_77:				; unused
shutdown_88:				; unused
	check_point_si	03h		; ======== 03
	mov	ax,cs
	mov	ss,ax
	xor	bp,bp
	mov	ds,bp			; set (DS) = 0
	mov	es,bp			; set (ES) = 0
	jmp_di	disable_video
	in	al,kb_stat_port		; if sys_flag bit is set
	test	al,00000100b		; then soft reset else power on
	jz	not_cnt_alt_del		; power on
	cmp	ds:word ptr [0472h],1234h
	jnz	cnt_alt_del
yes_cnt_alt_del:
	or	bp,soft_reset_bit	; msb used for soft reset
	jmp	short cnt_alt_del
not_cnt_alt_del:
	cmp	ds:word ptr [0472h],1234h
	jz	yes_cnt_alt_del
	or	bp,power_on_bit
cnt_alt_del:
;;;;	ret_sp	clear_64k_memory	; clear segment 0
	mov	ax,30h
	mov	ss,ax			; set stack
	mov	sp,100h
	check_point	05h		; ======== 05
;;	call	StopUsbHostController	; disable USB host controller
;;	call	disable_all_cache	; disable all cache
	call	disable_all_cache	; disable all cache
	call	StopUsbHostController	; disable USB host controller
	mov	ax,cs
	mov	ss,ax
	ret_sp	clear_64k_memory	; clear segment 0
	mov	ax,30h
	mov	ss,ax			; set stack
	mov	sp,100h
	check_point	06h		; ======== 06
	call	decompress_post_init
	extrn	_bios_to_rm:near
	jmp	_bios_to_rm
;---------------------------------------;
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
;			COPY_CONTROL_TO_RAM				;
;  this routine copies 64k code to ram segment and give control to ram.	;
;  input :								;
;	none								;
;	stack	available						;
;  output:								;
;	none								;
;  register destroyed..ALL except DS, ES, BP				;
;-----------------------------------------------------------------------;
	extrn	copy_64k_memory:near
	public	copy_control_to_ram
copy_control_to_ram	proc	near
	push	es
	push	ds
	mov	es,cgroup:ram_segment
	push	cs
	pop	ds			; source segment
	call	copy_64k_memory
;  transfer control to ram segment..
	push	es			; ram_segment
	push	offset cgroup:xxx
	retf
xxx:
	pop	ds
	pop	es
xxx_exit:
	ret
copy_control_to_ram	endp
;-----------------------------------------------------------------------;
;			COPY_TO_SHADOW					;
;-----------------------------------------------------------------------;
;  this routine copies the code to asked shadow.			;
;  input :								;
;	ES:DI	destn seg:off						;
;	DS:SI	source segment:offset					;
;	CX	#of bytes to move					;
;		0000 = 64k copy						;
;	stack	available						;
;  output:								;
;	none								;
;  register destroyed..ALL except DS, ES, BP				;
;-----------------------------------------------------------------------;
	extrn	move_bytes:near
	extrn	enable_shadow_write:near
	extrn	disable_shadow_write:near
	public	copy_to_shadow
copy_to_shadow	proc	near
	pushf
	cli				; disable interrupt
	call	enable_shadow_write	; enable write to shadow
	call	move_bytes		; move bytes
	call	flush_all_cache		; flush all cache
	call	disable_shadow_write	; enable write to shadow
	popf
	ret
copy_to_shadow	endp
;-----------------------------------------------------------------------;
	extrn	e000_read_rom_write_x:near
	extrn	e000_read_ram_write_rom:near
	extrn	e000_read_x_write_ram:near
	extrn	f000_read_rom_write_x:near
	extrn	f000_read_ram_write_rom:near
	extrn	f000_read_x_write_ram:near
	public	do_f000_read_rom_write_x
	public	do_f000_read_ram_write_rom
	public	do_f000_read_x_write_ram
	public	do_e000_read_rom_write_x
	public	do_e000_read_ram_write_rom
	public	do_e000_read_x_write_ram
;---------------------------------------;
ifdef	VANILLA_BIOS
do_f000_read_rom_write_x:
	call	f000_read_rom_write_x
	mov	al,15			; offset to table of fn#
	jmp	short vanilla_patch
do_f000_read_ram_write_rom:
	call	f000_read_ram_write_rom
	mov	al,18			; offset to table of fn#
	jmp	short vanilla_patch
do_f000_read_x_write_ram:
	call	f000_read_x_write_ram
	mov	al,21			; offset to table of fn#
	jmp	short vanilla_patch
do_e000_read_rom_write_x:
	call	e000_read_rom_write_x
	mov	al,24			; offset to table of fn#
	jmp	short vanilla_patch
do_e000_read_ram_write_rom:
	call	e000_read_ram_write_rom
	mov	al,27			; offset to table of fn#
	jmp	short vanilla_patch
do_e000_read_x_write_ram:
	call	e000_read_x_write_ram
	mov	al,30			; offset to table of fn#
vanilla_patch:
	push	bx
	mov	bx,cgroup:word ptr vanilla_patch_offset
	inc	bx
	jz	dop_00			; no routine
	dec	bx
	cbw				; AX = offset to jmp table
	add	bx,ax
	push	cs
	push	offset cgroup:dop_00
	push	cs
	push	bx
	retf
dop_00:
	pop	bx
	ret
;---------------------------------------;
else					; NORMAL BIOS CODE
do_f000_read_rom_write_x:
	jmp	f000_read_rom_write_x
do_f000_read_ram_write_rom:
	jmp	f000_read_ram_write_rom
do_f000_read_x_write_ram:
	jmp	f000_read_x_write_ram
do_e000_read_rom_write_x:
	jmp	e000_read_rom_write_x
do_e000_read_ram_write_rom:
	jmp	e000_read_ram_write_rom
do_e000_read_x_write_ram:
	jmp	e000_read_x_write_ram
endif
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
;---------------------------------------;
	public	_BIOS_ENDS
_BIOS_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end
