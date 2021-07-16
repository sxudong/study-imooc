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
	include rt.equ
	include pci.equ
	include dim.equ
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

	extrn	get_chipset_values:near
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
PnPIC_RMDataSegment	dw 0F000h	; These should match rth_nvram_base
PnPIC_PMDataBase	dd 000F0000h
rt_pnp_inst_check_end	label	byte

rth_nvram_base	dd	000F0000h	;The 32 bit physical address of the
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
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rthnvr_read_nvr_byte	proc	near
	push	cx
	push	ax
	call	read_word_nvram		; AX = word read
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
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
rthnvr_read_nvr_word	proc	near
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
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;         AX = Word that was read from NVRam                                   ;
;                                                                              ;
; Destroys: AX                                                                 ;
;------------------------------------------------------------------------------;
read_word_nvram	proc	near
	push	ds
	push	si
	push	dx
	push	cx
	push	bx

	call	check_flash_presence	; flash found ?
	jc	rwn_err			; error
;  AX = start offset of NVRAM..
	add	si,ax			; DS:SI = ptr to byte in NVRAM

;---------------------------------------; 01/06/96
;  DS = ESCD Segment/Selector
;  input in (GS) to this routine contains the BIOS Segment/Selector.
;
;  Since this routine does not access NVRAM area below 4GB address,
;  use GS to access NVRAM area BECAUSE some test softwares (e.g. NVRAM.EXE,
;  NSP BIOSTEST.EXE, etc.) do not pass ESCD Segment/Selector (which should
;  be used to access NVRAM area) properly
	mov	ax,gs
	mov	ds,ax
	mov	ax,cs
	cmp	ax,0f000h
	jnz	x1			; protected mode
	mov	ax,0f000h
	mov	ds,ax
x1:
;---------------------------------------; 01/06/96

	call	get_chipset_values
	jc	rwn_err			; error
;  DX = data port..
;  AH = value to disable F000 shadow RAM..
;  AL = value to restore F000 shadow RAM..
	pushf
	cli
	push	cs
	push	offset cgroup:read_byte_end
	pusha
	mov	al,ah			; AL = F000 shadow disable
	jmp	read_word
read_byte_end:
	popf
	mov	ax,cx			; AX = word read
	clc
rwn_err:
	pop	bx
	pop	cx
	pop	dx
	pop	si
	pop	ds
	ret
read_word_nvram	endp
;---------------------------------------;
align	16
	public	read_word
read_word:
	out	dx,al			; disable F0000-FFFFF shadow
	out	dx,al			; disable F0000-FFFFF shadow
	out	dx,al			; disable F0000-FFFFF shadow
	out	dx,al			; disable F0000-FFFFF shadow
	out	dx,al			; disable F0000-FFFFF shadow
	popa
	mov	cx,[si]			; read word from ROM
	out	dx,al			; restore F0000-FFFFF shadow
	out	dx,al			; restore F0000-FFFFF shadow
	out	dx,al			; restore F0000-FFFFF shadow
	out	dx,al			; restore F0000-FFFFF shadow
	out	dx,al			; restore F0000-FFFFF shadow
	retf
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
;	mov	byte ptr es:[di], al
;	clc
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
;	mov	word ptr es:[di], ax
;	clc
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

	mov	cx, cs:rth_nvram_size	;Get size defined in RTH.ASM
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
	pushad
	pushf				;Save state of IF
	cli
	pusha
	call	flash_write_enable	; enable write to flash
	popa
	push	es
	push	ds
	push	es
	push	ds
	pop	es			; ES:SI = source buffer
	pop	ds			; DS:DI = NVRAM storage
	call	check_flash_presence	; flash part found ?
	jc	flash_skip_write	; no flash part found
;  AX = start offset of NVRAM..
	add	di,ax			; DS:DI = ptr to byte in NVRAM

;---------------------------------------; 01/06/96
;  DS = ESCD Segment/Selector
;  input in (GS) to this routine contains the BIOS Segment/Selector.
;
;  Since this routine does not access NVRAM area below 4GB address,
;  use GS to access NVRAM area BECAUSE some test softwares (e.g. NVRAM.EXE,
;  NSP BIOSTEST.EXE, etc.) do not pass ESCD Segment/Selector (which should
;  be used to access NVRAM area) properly
	mov	ax,gs
	mov	ds,ax
	mov	ax,cs
	cmp	ax,0f000h
	jnz	x2			; protected mode
	mov	ax,0f000h
	mov	ds,ax
x2:
;---------------------------------------; 01/06/96

	mov	bx,cgroup:word ptr flash_found_table
	call	cs:word ptr [bx+2]	; erase
	jc	flash_skip_write	;Br if error erasing
	call	cs:word ptr [bx+4]	; program
flash_skip_write:
	pushf				;Save status of programming flash
	pusha
	call	flash_write_disable	; disable write to flash
	popa
	popf
	pop	ds
	pop	es
	jc	flash_write_error
	popf				;Restore state of IF
	clc				;Indicate success
flash_write_done:
	popad
	ret
flash_write_error:
	popf				;Restore state of IF
	stc				;Indicate failure
	jmp	short flash_write_done

flash_write	endp

;---------------------------------------;
;	CHECK_FLASH_PRESENCE		;
;  input :				;
;	none				;
;  output:				;
;	nc	flash present		;
;		ax  start offset of NVRAM
;	cy	flash not found		;
;  register destroyed : AX		;
;---------------------------------------;
check_flash_presence	proc	near
	mov	ax,cgroup:word ptr flash_found_table+2; start offset of NVRAM
	cmp	cgroup:word ptr flash_found_table,0ffffh
	cmc
	ret
check_flash_presence	endp
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
_text	ends
end
