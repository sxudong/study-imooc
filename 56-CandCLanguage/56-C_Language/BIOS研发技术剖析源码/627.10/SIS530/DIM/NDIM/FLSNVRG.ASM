	page	,132
	title	PnP NVRam Runtime Functions support for Flash
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;---------------------------------------;
	include	mbiosmac.mac
	include rt.equ
	include pci.equ
	include dim.equ
	include	silent.equ		; (CORE0072+)
;---------------------------------------;
	public	rthnvr_read_nvr_byte
	public	rthnvr_read_nvr_word
	public	rthnvr_write_nvr_byte
	public	rthnvr_write_nvr_word
	public	rthnvr_write
	public	rt_pnp_inst_check_start
	public	rth_nvram_size
	public	rth_nvram_base

	extrn	rt_pnp_entry:byte
	extrn	rt_pnp_entry_prot:byte
	extrn	flash_found_table:byte

	extrn	flash_write_enable:near
	extrn	flash_write_disable:near

;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text	segment para public 'CODE'
	 assume	cs:CGROUP
.486p
;---------------------------------------;
; Plug and Play Installation Check      ;
;---------------------------------------;--------------------------------------;
; This structure signals runtime software that this BIOS supports the Plug and ;
; Play BIOS interface.  Runtime software will search F0000 to FFFF0 for this   ;
; structure on each paragraph boundary.  After validating this structure,      ;
; runtime software will either the real mode or 16 bit protected mode entry    ;
; points given below to make calls to Plug and Play runtime functions.         ;
;------------------------------------------------------------------------------;
rt_pnp_inst_check_start	label	byte
PnPIC_Signature		db '$PnP'
PnPIC_Revision		db 10h
PnPIC_Length		db offset CGROUP:rt_pnp_inst_check_end - CGROUP:rt_pnp_inst_check_start
PnPIC_ControlFlags	dw 00h
PnPIC_CheckSum		db 00h
PnPIC_EventFlagAddr	dd 00000000h
PnPIC_RMEntryOffset	dw offset CGROUP:rt_pnp_entry
PnPIC_RMEntrySegment	dw 0F000h
PnPIC_PMEntryOffset	dw offset CGROUP:rt_pnp_entry_prot
PnPIC_PMEntryBase	dd 000F0000h
PnPIC_OEMDevID		dd 00000000h
PnPIC_RMDataSegment	dw 0F000h
PnPIC_PMDataBase	dd 000F0000h
rt_pnp_inst_check_end	label	byte

;-----------------------------------------------------------------------;
;  RTH_NVRAM_BASE and RTH_NVRAM_SIZE will get updated according to the	;
;  flash part present in the system. for example, for Intel 28F001BX-T	;
;  these values are FFFFD000 and 1000 respectively but for AMD29F010	;
;  these values are FFFF8000 and 4000 respectively.			;
;-----------------------------------------------------------------------;
rth_nvram_base	dd	0FFFFD000h	;The 32 bit physical address of the
					;memory (Flash) that is used for NVRam.
					;This is needed so that protected mode
					;callers can build a proper descriptor
					;that the BIOS can use to access that
					;memory.  Make this 0 if this system
					;has no NVRam or NVRam is accessed via
					;I/O ports.
rth_nvram_size	dw	1000h		;NVRam size is 4k bytes
					;Make this 0 if this system has no NVRam
;---------------------------------------;
; rthnvr_read_nvr_byte                  ;
;---------------------------------------;--------------------------------------;
; This function reads one byte from NVRam and returns it in AL.                ;
;                                                                              ;
; Input:  SI = Offset of byte to read from NVRam                               ;
;         DS = Segment/Selector needed to access NVRam                         ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;         AL = Byte that was read from NVRam                                   ;
;                                                                              ;
; Destroys: AL                                                                 ;
;------------------------------------------------------------------------------;
rthnvr_read_nvr_byte	proc	near
	push	cx
	push	ax
	mov	al,00h			; AL = 00 -> read a byte
	call	read_word_nvram		; NC, AL = byte read
	pop	cx
	jc	rthnvr_rnb_00		; error
	mov	ah,ch			; restore original AH, AL = byte read
rthnvr_rnb_00:
	pop	cx
	ret
rthnvr_read_nvr_byte	endp

;---------------------------------------;
; rthnvr_read_nvr_word                  ;
;---------------------------------------;--------------------------------------;
; This function reads one word from NVRam and returns it in AX.                ;
;                                                                              ;
; Input:  SI = Offset of byte to read from NVRam                               ;
;         DS = Segment/Selector needed to access NVRam                         ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;         AX = Word that was read from NVRam                                   ;
;                                                                              ;
; Destroys: AX                                                                 ;
;------------------------------------------------------------------------------;
rthnvr_read_nvr_word	proc	near
	mov	al,0ffh			; AL <> 00 -> read a word
	call	read_word_nvram		; AX = word read
	ret
rthnvr_read_nvr_word	endp

;---------------------------------------;
; read_word_nvram                       ;
;---------------------------------------;--------------------------------------;
; This function reads one word from NVRam and returns it in AX.                ;
;                                                                              ;
; Input:  SI = Offset of byte to read from NVRam                               ;
;         DS = Segment/Selector needed to access NVRam                         ;
;	  AL = 00 read a byte                                                  ;
;	  AL <>00 read a word                                                  ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;         AL/AX = Byte/Word that was read from NVRam                           ;
;                                                                              ;
; Destroys: AX                                                                 ;
;------------------------------------------------------------------------------;
read_word_nvram	proc	near
	call	check_flash_presence	; flash found ?
	jc	rwn_err			; error
	pushf
	cli
	push	es
	push	ds
	push	esi
	movzx	esi,si
	call	go_to_big_mode		; call	go_to_flat_mode_stack
	pushf				; NC/CY = not/yes real mode when the routine was invoked
					; if CY then ZR/NZ = GA20 status (dis/en)abled
	jnc	rw_00			; not in real mode
	add	esi,cgroup:rth_nvram_base
;  read from NVRAM..
rw_00:
	or	al,al			; read a byte/word
	mov	al,ds:[esi]		; read a byte from ROM
	jz	rw_02			; read byte
	mov	ax,ds:[esi]		; read a word from ROM
rw_02:
	popf				; CY = real mode
					; if CY then ZR/NZ = GA20 status (dis/en)abled
	jnc	rw_01			; no, so assume protected mode
;  real mode..come back to real mode..
	call	comeback_from_big_mode	; call	comeback_from_flat_mode_stack
rw_01:
;  AL/AX = read byte/word..
	pop	esi
	pop	ds
	pop	es
	popf
	clc
rwn_err:
	ret
read_word_nvram	endp
;---------------------------------------;
; rthnvr_write_nvr_byte                 ;
;---------------------------------------;--------------------------------------;
; This function writes one byte to NVRam.  This function should only be        ;
; supported if NVRam may be written one byte at a time.  If Flash is being     ;
; used for NVRam, then this function should just return with CF set.           ;
;                                                                              ;
; Input:  AL = Byte to write to NVRam                                          ;
;         DI = Offset into NVRam where byte should be written                  ;
;         ES = Segment/Selector needed to access NVRam                         ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rthnvr_write_nvr_byte	proc	near
	stc
	ret
rthnvr_write_nvr_byte	endp


;---------------------------------------;
; rthnvr_write_nvr_word                 ;
;---------------------------------------;--------------------------------------;
; This function writes one word to NVRam.  This function should only be        ;
; supported if NVRam may be written one word at a time.  If Flash is being     ;
; used for NVRam, then this function should just return with CF set.           ;
;                                                                              ;
; Input:  AX = Word to write to NVRam                                          ;
;         DI = Offset into NVRam where word should be written                  ;
;         ES = Segment/Selector needed to access NVRam                         ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rthnvr_write_nvr_word	proc	near
	stc
	ret
rthnvr_write_nvr_word	endp


;---------------------------------------;
; rthnvr_write                          ;
;---------------------------------------;--------------------------------------;
; This function writes the entire contents of NVRam from a buffer supplied by  ;
; the caller.                                                                  ;
;                                                                              ;
; Input: DS:(E)SI = Buffer of data to write to NVRam                           ;
;        ES:(E)DI = Seg/Offset of NVRam (caller passes in whatever is returned ;
;                   by the rtnvr_get_escd_size function)                       ;
;                                                                              ;
; Output: CF  = Set if error, cleared otherwise                                ;
;         AX = Non zero return code if CF set (see RT.EQU)                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rthnvr_write	proc	near

;;stc				;These two lines may be added during
;;ret				;development, so that it is possible to
				;boot the system without NVRam code.

	push	ecx
	push	esi
	push	edi

	mov	cx, cs:rth_nvram_size	;Get size defined
	mov	ax, RT_ESCD_INVALID	;Error code for no ESCD
	stc				;Set CF in case following jcxz jumps
	jcxz	write_nvram_done	;Br if no NVRam on this system

	push	bx
	push	cx
	push	si
	pushf
	xor	bl, bl			;BL will accumulate checksum
	mov	(nvr_header ptr [si]).nvrhd_nvram_checksum, bl
	cld
write_nvram_cksum:
	lodsb				;AL = next byte from caller's buffer
	add	bl, al
	loop	write_nvram_cksum
	popf
	pop	si
	pop	cx			;Update NVRam cksum in caller's buffer
	neg	bl
	mov	(nvr_header ptr [si]).nvrhd_nvram_checksum, bl
	pop	bx

	call	flash_write
	mov	ax, 0			;AX = Code for no error
	jnc	write_nvram_done	;Br if Flash written OK
	mov	ax, RT_ESCD_READ_ERROR

write_nvram_done:
	pop	edi
	pop	esi
	pop	ecx
	ret

rthnvr_write	endp


;---------------------------------------;
; flash_write                           ;
;---------------------------------------;--------------------------------------;
; This function erases and writes the NVRam contents in Flash from a buffer    ;
; supplied by the caller.                                                      ;
;                                                                              ;
; Input: DS:SI = Buffer of data to write to NVRam                              ;
;        ES:DI = Seg/Offset of NVRam (caller passes in whatever is returned    ;
;                by the rtnvr_get_escd_size function)                          ;
;           CX = Size of Flash block to write                                  ;
;                                                                              ;
; Output: CF  = Set if error, cleared otherwise                                ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
flash_write	proc	near

	call	check_flash_presence	; flash part found ?
	jc	fw_err			; no flash part found
	push	ds
	push	es
	pushad
	pushf				;Save state of IF
	cli
	movzx	esi,si
	movzx	edi,di
	push	ds
	call	go_to_big_mode		; call	go_to_flat_mode_stack
	pop	ds
	pushf				; NC/CY = not/yes real mode when the routine was invoked
					; if CY then ZR/NZ = GA20 status (dis/en)abled
	jnc	fw_00			; not in real mode
	add	edi,cgroup:rth_nvram_base
fw_00:
	call	flash_write_enable	; make flash R/W
	push	es
	push	ds
	push	es
	push	ds
	pop	es			; ES:SI = source buffer
	pop	ds			; DS:DI = NVRAM storage
	mov	bx,cgroup:word ptr flash_found_table
	call	cs:word ptr [bx+2]	; erase
	jc	flash_skip_write	; Br if error erasing
	call	cs:word ptr [bx+4]	; program
flash_skip_write:
	pushf				; save status of programming flash
	call	flash_write_disable	; make flash write protected
	popf
	pop	ds
	pop	es
	mov	al,00h			; AL = 00 for success
	jnc	flash_write_done	; success
	mov	al,0ffh			; AL <> 00 for error
flash_write_done:
	popf				; CY = real mode
					; if CY then ZR/NZ = GA20 status (dis/en)abled
	jnc	fw_01			; no, so assume protected mode
	call	comeback_from_big_mode	; call	comeback_from_flat_mode_stack
fw_01:
	popf
	cmp	al,1
	cmc				; NC/CY = success/error
	popad
	pop	es
	pop	ds
fw_err:
	ret

flash_write	endp

;---------------------------------------;
;	CHECK_FLASH_PRESENCE		;
;  input :				;
;	none				;
;  output:				;
;	nc	flash present		;
;	cy	flash not found		;
;  register destroyed : None		;
;---------------------------------------;
check_flash_presence:
	cmp	cgroup:word ptr flash_found_table,0ffffh
	jz	cfp_00			; flash support not present
	cmp	cgroup:rth_nvram_base,00000000h
	jz	cfp_00			; no NVRAM
	cmp	cgroup:rth_nvram_size,0000h
	jnz	cfp_01			; NC, flash & NVRAM present
cfp_00:
	stc				; error
cfp_01:
	ret
;---------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;
;			GO_TO_BIG_MODE					;
;  this routine checks whether this call is made in real mode or not.	;
;  if the call is made in real mode, it goes to flat protected mode and	;
;  sets DS, ES with 4GB limit starting at physical address 00000000 and	;
;  comes back to real mode with DS, ES limit set to 4GB.		;
;  input :                                                          	;
;	stack	available						;
;  output:								;
;	NMI and interrupts disabled					;
;	DS, ES set to 4GB limit with base 0000h				;
;	NC	routine was called in (not real mode)			;
;		so it is assumed the routine was called in protected mode
;	CY	routine was called in (real mode)			;
;		so this routine went to big real mode			;
;		ZF	GA20 status					;
;			ZR GA20 was disabled when the routine was invoked
;			NZ GA20 was enabled  when the routine was invoked
;  registers destroyted: DS, ES						;
;  NOTE: this routine is invoked by CALL				;
;-----------------------------------------------------------------------;
	extrn	enable_addr_bit_20:near
	public	go_to_big_mode		; (CORE0072+)
go_to_big_mode:
	pushad
					; (CORE0072+)>
	extrn	bios_scratch:byte
	test	cs:byte ptr bios_scratch,bios_post_complete_bit; POST/Runtime ?
	jz	short gtbm_02		; POST, so real mode
					; <(CORE0072+)
	mov	ax,cs
	cmp	ax,0f000h
	clc				; NC for not in real mode
	jnz	gtbm_01			; not in real mode
gtbm_02:
	cli				; Disable interrupts
;  check the GA20 status..
;  compare 256bytes at 0:0 with FFFF:10
;  if match, GA20 is disabled else GA20 is enabled
	push	0000h
	pop	ds			; DS = 0000
	push	0ffffh
	pop	es			; ES = FFFF
	mov	cx,100h/4		; #of Dwords in 256bytes
	xor	si,si
	mov	di,0010h
	repz	cmpsd
	pushf				; save GA20 status ZR/NZ = disabled/enabled
	jnz	gtbm_00			; GA20 is already enabled
	call	enable_addr_bit_20	; enable GateA20
gtbm_00:
	mov	dx,0018h		; selector for flat segment
	call	go_big_mode		; go to protected mode and comeback to real mode
	popf				; ZR/NZ = GA20 status
	stc				; routine went to big real mode
gtbm_01:
	popad
	ret				; return to caller
;-----------------------------------------------------------------------;
;			COMEBACK_FROM_BIG_MODE				;
;-----------------------------------------------------------------------;
;  this routine comes back to real mode with DS, ES with 64KB limit at	;
;  starting address 0000:0000.						;
;  input :                                                          	;
;	GA20 is currently enabled					;
;	ZF	GA20 final status					;
;		ZR final status of GA20 is disabled			;
;		NZ final status of GA20 is enabled			;
;	stack	available						;
;  output:								;
;	NMI and interrupts disabled					;
;	DS, ES set to 64KB limit with base 0000h			;
;  registers destroyted: DS, ES						;
;  NOTE: this routine is invoked by CALL				;
;-----------------------------------------------------------------------;
	extrn	disable_addr_bit_20:near
	public	comeback_from_big_mode	; (CORE0072+)
comeback_from_big_mode:
	pushad
	cli				; Disable interrupts
	pushf
	mov	dx,0010h		; selector
	call	go_big_mode
	popf
	jnz	cfbm_00			; keep GA20 enabled
	call	disable_addr_bit_20	; disable GateA20
cfbm_00:
	popad
	ret
;-----------------------------------------------------------------------;
;				GO_BIG_MODE				;
;  this routine goes to protected mode, sets the DS, ES to the given	;
;  selector, comes back to real mode and sets DS, ES to 0000.		;
;  input :								;
;	dx	selector						;
;  output:								;
;	DS, ES	set to 0000						;
;  register destroyed..EAX, DS, ES					;
;-----------------------------------------------------------------------;
	extrn	big_gdt:byte
go_big_mode:
	mov	al,8dh			; Disable NMI
	out	70h,al
	lgdt	cgroup:fword ptr big_gdt+8
	mov	eax,cr0
	or	al,01h
	mov	cr0,eax			; in protected mode
	db	0e9h,00h,00h		; Flush instruction queue - JMP (NEAR)
					; to next instruction
	mov	ax,dx			; selector
	mov	ds,ax			; DS = selector
	mov	es,ax			; ES = selector

	mov	eax,cr0			; come back into real mode with DS,ES
	and	al,0feh
	mov	cr0,eax
	db	0e9h,00h,00h		; Flush instruction queue - JMP (NEAR)
					; to next instruction
	xor	ax,ax
	mov	ds,ax			; DS = ES = 0
	mov	es,ax			;
	ret
;-----------------------------------------------------------------------;
_text	ends
end
