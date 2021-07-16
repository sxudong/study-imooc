	page	,132
	title	PnP NVRAM support for ISA type DALLAS CMOS Part
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
;*****************************************************************;
;*****************************************************************;

;-----------------------------------------------------------------------;
;  this equates are for the DALLAS part DS17A84/DS17A86 parts		;
;-----------------------------------------------------------------------;
cmos_bank_select_reg	equ	0ah
cmos_ext_addr_lsb	equ	050h
cmos_ext_addr_msb	equ	051h
cmos_ext_data		equ	053h
;---------------------------------------;
	include	dim.equ
;---------------------------------------;
	public	rthnvr_read_nvr_byte
	public	rthnvr_read_nvr_word
	public	rthnvr_write_nvr_byte
	public	rthnvr_write_nvr_word
	public	rthnvr_write

	public	rth_nvram_size
	public	rth_nvram_base
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text	segment para public 'CODE'
	assume	cs:CGROUP
.386p
;---------------------------------------;
; Plug and Play Installation Check      ;
;---------------------------------------;--------------------------------------;
; This structure signals runtime software that this BIOS supports the Plug and ;
; Play BIOS interface.  Runtime software will search F0000 to FFFF0 for this   ;
; structure on each paragraph boundary.  After validating this structure,      ;
; runtime software will either the real mode or 16 bit protected mode entry    ;
; points given below to make calls to Plug and Play runtime functions.         ;
;------------------------------------------------------------------------------;
	public	rt_pnp_inst_check_start
	extrn	rt_pnp_entry:near
	extrn	rt_pnp_entry_prot:near
rt_pnp_inst_check_start:
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
PnPIC_RMDataSegment	dw 00000h	;These should match rth_nvram_base
PnPIC_PMDataBase	dd 00000000h	; in RTH-NVR.ASM
rt_pnp_inst_check_end:
;---------------------------------------;
rth_nvram_base		dd 00000000h	;The 32 bit physical address of the
					;memory (Flash) that is used for NVRam.
					;This is needed so that protected mode
					;callers can build a proper descriptor
					;that the BIOS can use to access that
					;memory.  Make this 0 if this system
					;has no NVRam or NVRam is accessed via
					;I/O ports.  This value should match
					;PnPIC_RMDataSegment in RTH.ASM.
rth_nvram_size		dw 1000h	;NVRam size is 4k bytes
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
rthnvr_read_nvr_byte:
	pushf				; save current interrupt status
	cli				; disable interrupt
	push	bx
	mov	bh,ah
	mov	al,cmos_bank_select_reg
	call	read_nvram
	or	al,010h			; choose bank 1
	mov	ah,al
	mov	al,cmos_bank_select_reg
	call	write_nvram
	mov	ax,si
	mov	ah,al

	mov	al,cmos_ext_addr_lsb
	call	write_nvram
	mov	ax,si
				; al = low byte, ah = high byte
	mov	al,cmos_ext_addr_msb
	call	write_nvram
	mov	al,cmos_ext_data
	call	read_nvram

	push	ax
	mov	al,cmos_bank_select_reg
	call	read_nvram
	and	al,0efh			; choose bank 0
	mov	ah,al
	mov	al,cmos_bank_select_reg
	call	write_nvram
	pop	ax

	mov	ah,bh
	pop	bx
	popf				; restore interrupt status

	;If needed, insert code here that restores NVRam space status.

	clc
	ret

read_nvram:
	out	070h,al
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	in	al,071h	
	ret

write_nvram:
	out	070h,al
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	xchg	al,ah
	out	071h,al
	xchg	al,ah
	ret

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
rthnvr_read_nvr_word:
	call	rthnvr_read_nvr_byte
	mov	ah,al
	inc	si
	call	rthnvr_read_nvr_byte
	xchg	al,ah
	dec	si

	;If needed, insert code here that restores NVRam space status.

	clc
	ret

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
rthnvr_write_nvr_byte:
	pushf				; save current interrupt status
	cli				; disable interrupt
	push	ax
	push	ax
	mov	al,cmos_bank_select_reg
	call	read_nvram
	or	al,010h			; choose bank 1
	mov	ah,al
	mov	al,cmos_bank_select_reg
	call	write_nvram
	mov	ax,di
	mov	ah,al
	mov	al,cmos_ext_addr_lsb
	call	write_nvram
	mov	ax,di			; al = low byte, ah = high byte
	mov	al,cmos_ext_addr_msb
	call	write_nvram
	pop	ax
	mov	ah,al
	mov	al,cmos_ext_data
	call	write_nvram
	mov	al,cmos_bank_select_reg
	call	read_nvram
	and	al,0efh			; choose bank 0
	mov	ah,al
	mov	al,cmos_bank_select_reg
	call	write_nvram
	pop	ax
	popf				; restore interrupt status
	clc
	ret


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
rthnvr_write_nvr_word:
	call	rthnvr_write_nvr_byte
	xchg	al,ah
	inc	di	
	call	rthnvr_write_nvr_byte
	xchg	al,ah
	dec	di
	clc
	ret

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
rthnvr_write:
	push	ecx
	push	esi
	push	edi

	mov	cx, cs:rth_nvram_size	;Get size defined in RTH.ASM
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

write_nvr_block:
	lodsb
	call	rthnvr_write_nvr_byte
	inc	di
	loop	write_nvr_block	
	xor	ax, ax			; AX = Code for successful
					; NC = ok
write_nvram_done:
	pop	edi
	pop	esi
	pop	ecx
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
_text	ends
end
