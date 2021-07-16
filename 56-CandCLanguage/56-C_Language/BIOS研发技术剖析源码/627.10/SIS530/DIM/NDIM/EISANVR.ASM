	page	,132
	title .			Hooks into Run Time NVRam Functions
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
cmos_page_sel_reg	equ	0c00h
cmos_page_data_reg	equ	0800h
;---------------------------------------;

ifndef RT32
	.286
else
	.386
endif

;---------------------------------------;
	include rt.equ
	include pci.equ
	include mac32.mac
	include dim.equ
;---------------------------------------;
	pubproc rthnvr_read_nvr_byte
	pubproc rthnvr_read_nvr_word
	pubproc rthnvr_write_nvr_byte
	pubproc rthnvr_write_nvr_word
	pubproc rthnvr_write

	public	rth_nvram_size
	public	rth_nvram_base
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
ifndef RT32
	cgroup	group	_text
	_text segment para public 'CODE'
		 assume	cs:CGROUP
	.386
else
	.386
	cgroup	group	_runtime32
	_runtime32 segment para public USE32 'CODE'
		 assume	cs:cgroup
endif


;------------------------------------------------------------------------------
;---------------------------------------;
; Plug and Play Installation Check      ;
;---------------------------------------;--------------------------------------;
; This structure signals runtime software that this BIOS supports the Plug and ;
; Play BIOS interface.  Runtime software will search F0000 to FFFF0 for this   ;
; structure on each paragraph boundary.  After validating this structure,      ;
; runtime software will either the real mode or 16 bit protected mode entry    ;
; points given below to make calls to Plug and Play runtime functions.         ;
;------------------------------------------------------------------------------;
ifndef RT32
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
PnPIC_RMDataSegment	dw 00000h	; These should match RTH_NVRAM_BASE
PnPIC_PMDataBase	dd 00000000h	; defined below

rt_pnp_inst_check_end:

endif

;---------------------------------------;
rth_nvram_size	dw	2000h		;NVRam size is 8k bytes
					;Make this 0 if this system has no NVRam
rth_nvram_base	dd	00000000h	;The 32 bit physical address of the
					;memory (Flash) that is used for NVRam.
					;This is needed so that protected mode
					;callers can build a proper descriptor
					;that the BIOS can use to access that
					;memory.  Make this 0 if this system
					;has no NVRam or NVRam is accessed via
					;I/O ports.  This value should match
					;PnPIC_RMDataSegment in RTH.ASM.
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
defproc rthnvr_read_nvr_byte

rthnvr_read_nvr_byte_x::
	pushf				; save current interrupt status
	cli				; disable interrupt
	push	bx			;
	push	dx			;
	mov	bx,si
	mov	dx,cmos_page_sel_reg
	in	al,dx			; read present value
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	and	al,11100000b		; do not modify 3 most significant bits
	or	al,bh			; al=page #
	out	dx,al
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	mov	dx,cmos_page_data_reg	; CMOS base page register
	mov	dl,bl
	in	al,dx			; (al) = data read
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	pop	dx			;
	pop	bx			;
	popf				; restore interrupt status
	clc
	ret

endproc rthnvr_read_nvr_byte

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
defproc rthnvr_read_nvr_word
	call	rthnvr_read_nvr_byte_x
	mov	ah,al
	inc	si
	call	rthnvr_read_nvr_byte_x
	xchg	al,ah
	dec	si
	clc
	ret
endproc rthnvr_read_nvr_word

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
defproc rthnvr_write_nvr_byte
	pushf				; save current interrupt status
	cli				; disable interrupt
	push	bx			;
	push	dx			;
	push	ax			;
	mov	ah,al
	mov	bx,di
	mov	dx,cmos_page_sel_reg
	in	al,dx			; read present value
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	and	al,11100000b		; do not modify 3 most significant bits
	or	al,bh			; al=page #
	out	dx,al
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	mov	al,ah			; data to write
	mov	dx,cmos_page_data_reg	; CMOS base page register
	mov	dl,bl
	out	dx,al			; write the data
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	pop	ax			;
	pop	dx			;
	pop	bx			;
	popf				; restore interrupt status
	clc
	ret
endproc rthnvr_write_nvr_byte


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
defproc rthnvr_write_nvr_word
	callproc	rthnvr_write_nvr_byte
	xchg	al,ah
	inc	di	
	callproc	rthnvr_write_nvr_byte
	xchg	al,ah
	dec	di
	clc
	ret
endproc rthnvr_write_nvr_word


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
defproc rthnvr_write
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
	callproc rthnvr_write_nvr_byte
	inc	di
	loop	write_nvr_block	
	clc
	xor	ax, ax			;AX = Code for no error

write_nvram_done:
	pop	edi
	pop	esi
	pop	ecx
	ret

endproc rthnvr_write

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
ifndef RT32
	_text ends
else
	_runtime32 ends
endif
	 end

