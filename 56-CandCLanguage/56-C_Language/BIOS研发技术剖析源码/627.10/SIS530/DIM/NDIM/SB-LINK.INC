;  return codes
success 		equ	00h
invalid_parameter	equ	81h
buffer_too_small	equ	82h
not_implemented 	equ	86h

minimum_buffer_size	equ	3	; Depend On Chipset

ifndef	RT32
	public	sb_link_bios
sb_link_bios:
	mov	ah,invalid_parameter	; Invalid Parameter
	add	sp,0002h		; discard return address
	cmp	bx,0e8ch		; SB-Link Signature?
	jnz	short sb_00		; No, Error and Exit
	mov	ah,not_implemented
	cmp	al,06h
	ja	short sb_00
	push	bx
	movzx	bx,al
	shl	bx,1
	mov	ax,cgroup:word ptr [sb_link_func_table+bx]
	pop	bx
	push	edi
	movzx	edi,di
	push	ds
	push	es
	pop	ds
	call	ax
	pop	ds
	pop	edi
sb_00:
	cmp	ah,01h
	cmc				; status in return carry flag
	sti
	retf	0002

;-----------------------------------------------------------------------;
;			      SB_LINK_FUNC_TABLE			;
;-----------------------------------------------------------------------;
sb_link_func_table	label	byte
	dw	offset cgroup:rth_sb_link_func_00	; subfunc 00h
	dw	offset cgroup:rth_sb_link_func_01	; subfunc 01h
	dw	offset cgroup:rth_sb_link_func_02	; subfunc 02h
	dw	offset cgroup:rth_sb_link_func_03	; subfunc 03h
	dw	offset cgroup:rth_sb_link_func_04	; subfunc 04h
	dw	offset cgroup:rth_sb_link_func_05	; subfunc 05h
	dw	offset cgroup:rth_sb_link_func_06	; subfunc 06h
sb_link_func_table_end	label	byte
endif

	pubproc rth_sb_link_func_00
defproc rth_sb_link_func_00
;; Function 0 / Get Information
;;	mov	al,1			; Serialize IRQ positive active polarity
	mov	al,0			; Serialize IRQ negative active polarity
	mov	ch,11101011b		; Available DMAs are 7,6,5,3,1,0
	callproc get_sb_link_info
	mov	dx,bx			; SB-LINK Signature
	mov	bx,0100h		; Version 1.00
	mov	ah,success
	ret

endproc rth_sb_link_func_00

	pubproc rth_sb_link_func_01
defproc rth_sb_link_func_01
;; Function 1 / Save DMA Channel (Chipset Register)
	callproc check_dma_valid
	jnc	short sb_01_00		; (AH=81h)
	cmp	word ptr [edi], minimum_buffer_size
	jae	short sb_01_01
	mov	ah,buffer_too_small	; (AH=82h)
	mov	word ptr [edi], minimum_buffer_size
sb_01_00:
	ret
sb_01_01:
	pushf
	pushad
	mov	esi,edi
	inc	esi			; Skip Buffer Field
	inc	esi			; Skip Buffer Field
;; Save PCI DMA Configuration Register(s)
	callproc get_sb_link_dma_chip_reg
	mov	[esi],al
	popad
	popf
	mov	ah,success
	ret
endproc rth_sb_link_func_01

	pubproc rth_sb_link_func_02
defproc rth_sb_link_func_02
;; Function 2 / Set DMA Channel (Chipset Register) to PC/PCI
	callproc check_dma_valid
	jnc	short sb_02_00		; (AH=81h)
	pushf
	pusha
;; Setup PCI DMA Configuration Register(s)
	callproc set_sb_link_dma_chip_reg
	popa
	popf
	mov	ah,success
sb_02_00:
	ret
endproc rth_sb_link_func_02

	pubproc rth_sb_link_func_03
defproc rth_sb_link_func_03
;; Function 3 / Restore DMA Channel Configuration Function
	callproc check_dma_valid
	jnc	short sb_03_00		; (AH=81h)
	cmp	word ptr [edi], minimum_buffer_size
	jae	short sb_03_01
	mov	ah,buffer_too_small	; (AH=82h)
	mov	word ptr [edi], minimum_buffer_size
sb_03_00:
	ret
sb_03_01:
	pushf
	pushad
	mov	esi,edi
	inc	esi			; Skip Buffer Field
	inc	esi			; Skip Buffer Field
;; Restore PCI DMA Configuration Register(s)
	callproc restore_sb_link_dma_chip_reg
	popad
	popf
	mov	ah,success
	ret
endproc rth_sb_link_func_03

	pubproc rth_sb_link_func_04
defproc rth_sb_link_func_04
;; Function 4 / Save Serial IRQ Configuration Function
	cmp	word ptr [edi], minimum_buffer_size
	jae	short sb_04_00
	mov	ah,buffer_too_small	; (AH=82h)
	mov	word ptr [edi], minimum_buffer_size
	ret
sb_04_00:
	pushf
	pushad
	mov	esi,edi
	inc	esi			; Skip Buffer Field
	inc	esi			; Skip Buffer Field
;; Get Serial IRQ Configuration Register
	callproc get_sb_link_sirq_chip_reg
	mov	[esi],al
	popad
	popf
	mov	ah,success
	ret
endproc rth_sb_link_func_04

	pubproc rth_sb_link_func_05
defproc rth_sb_link_func_05
;; Function 5 / Enable Serial IRQ Function
	pushf
	pusha
;; Enable Chipset Serial IRQ Function
	callproc set_sb_link_sirq_chip_reg
	popa
	popf
	mov	ah,success
	ret
endproc rth_sb_link_func_05

	pubproc rth_sb_link_func_06
defproc rth_sb_link_func_06
;; Function 6 / Restore Serial IRQ Configuration Function
	cmp	word ptr [edi], minimum_buffer_size
	jae	short sb_06_00
	mov	ah,buffer_too_small	; (AH=82h)
	mov	word ptr [edi], minimum_buffer_size
	ret
sb_06_00:
	pushf
	pushad
	mov	esi,edi
	inc	esi			; Skip Buffer Field
	inc	esi			; Skip Buffer Field
;; Restore Serial IRQ Configuration Register(s)
	callproc restore_sb_link_sirq_chip_reg
	popad
	popf
	mov	ah,success
	ret
endproc rth_sb_link_func_06

defproc check_dma_valid
	cmp	cl,7
	ja	short check_dma_valid_done
	push	cx
	push	ax
	movzx	cx,cl
	mov	ax,11101011b
	bt	ax,cx			; Check Valid DMA Channels
	pop	ax
	pop	cx
check_dma_valid_done:
	mov	ah,invalid_parameter	; (AH=81h)
	ret
endproc check_dma_valid

	extproc rtpci_write_cfg_byte
	extproc rtpci_write_cfg_word
	extproc rtpci_read_cfg_byte
	extproc rtpci_read_cfg_word

;-----------------------------------------------------------------------;
;			 SB-Link Porting Code Start			;
;-----------------------------------------------------------------------;
;			  GET_SB_LINK_INFOMATION			;
;-----------------------------------------------------------------------;
; this subrouting reports some information like as REQ/GNT pin, serial	;
; IRQ active polarity, available DMA channel(s) etc.			;
; by the caller.							;
; Input :								;
;	None								;
; Output:								;
;	CL	= 1 Platform Using REQ/GNT A Pin			;
;		= 2 Platform Using REQ/GNT B Pin			;
;		= 4 Platform Using REQ/GNT C Pin			;
;	stack	available						;
;  register usage : DO NOT destroy any registers			;
;-----------------------------------------------------------------------;
	pubproc get_sb_link_info
defproc get_sb_link_info
;	mov	cl, 01h 		; REQ/GNT A (OEM need to change)
	ret
endproc get_sb_link_info

;-----------------------------------------------------------------------;
;			GET_SB_LINK_DMA_CHIP_REG			;
;-----------------------------------------------------------------------;
; this subrouting reads chipset DMA configuration register(s) specified ;
; by the caller.							;
; Input :								;
;	CL	DMA Channel Number(0-7) 				;
; Output:								;
;	AL	DMA Channel Configuration				;
;	stack	available						;
;  register usage : can destroy any registers except ESI, DS, ES	;
;-----------------------------------------------------------------------;
	pubproc get_sb_link_dma_chip_reg
defproc get_sb_link_dma_chip_reg
;	push	cx
;	mov	bx,(INTEL_PIIX4_BUS shl 8)+INTEL_PIIX4_DEV_FUNC
;	mov	di,IPIIX4_PCIDMA_CON_H
;	callproc rtpci_read_cfg_word	;Returns in CX
;	pop	ax
;	xchg	cx,ax
;	shl	cl,1
;	shr	ax,cl
;	and	al,03h
	ret
endproc get_sb_link_dma_chip_reg

;-----------------------------------------------------------------------;
;			SET_SB_LINK_DMA_CHIP_REG			;
;-----------------------------------------------------------------------;
; this subrouting sets chipset DMA configuration register(s) to PC/PCI	;
; specified by the caller.						;
; Input :								;
;	CL	DMA Channel Number(0-7) 				;
; Output:								;
;	None								;
;	stack	available						;
;  register usage : can destroy any 16-bit registers except ES, DS	;
;-----------------------------------------------------------------------;
	pubproc set_sb_link_dma_chip_reg
defproc set_sb_link_dma_chip_reg
;	push	cx
;	mov	bx,(INTEL_PIIX4_BUS shl 8)+INTEL_PIIX4_DEV_FUNC
;	mov	di,IPIIX4_PCIDMA_CON_L
;	callproc rtpci_read_cfg_word	;Returns in CX
;	pop	ax
;	shl	al,1
;	xchg	ax,cx
;	ror	ax,cl
;	and	al,0fch
;	or	al,01h			; PC/PCI
;	rol	ax,cl
;	xchg	ax,cx
;	callproc rtpci_write_cfg_word
	ret
endproc set_sb_link_dma_chip_reg

;-----------------------------------------------------------------------;
;		       RESTORE_SB_LINK_DMA_CHIP_REG			;
;-----------------------------------------------------------------------;
; this subrouting restore chipset DMA configuration register(s) to	;
; original configuration specified by the caller.			;
; Input :								;
;	DS:ESI Pointer to Original DMA Channel Configuration		;
; Output:								;
;	None								;
;	stack	available						;
;  register usage : can destroy any registers except ES, DS		;
;-----------------------------------------------------------------------;
	pubproc restore_sb_link_dma_chip_reg
defproc restore_sb_link_dma_chip_reg
;	mov	bx,(INTEL_PIIX4_BUS shl 8)+INTEL_PIIX4_DEV_FUNC
;	mov	di,IPIIX4_PCIDMA_CON_L
;	push	cx
;	callproc rtpci_read_cfg_word	;Returns in CX
;	pop	ax
;	shl	al,1
;	xchg	cx,ax
;	ror	ax,cl
;	and	al,0fch
;	or	al,[esi]
;	rol	ax,cl
;	xchg	cx,ax
;	callproc rtpci_write_cfg_word
	ret
endproc restore_sb_link_dma_chip_reg

;-----------------------------------------------------------------------;
;			GET_SB_LINK_SIRQ_CHIP_REG			;
;-----------------------------------------------------------------------;
; this subrouting reads chipset serial IRQ configuration register(s)	;
; Input :								;
;	None								;
; Output:								;
;	AL	Serial IRQ Register Context				;
;	stack	available						;
;  register usage : can destroy any registers except ESI, ES, DS	;
;-----------------------------------------------------------------------;
	pubproc get_sb_link_sirq_chip_reg
defproc get_sb_link_sirq_chip_reg
;	mov	bx,(INTEL_PIIX4_BUS shl 8)+INTEL_PIIX4_DEV_FUNC
;	mov	di,IPIIX4_REG_SIRQ_CON
;	callproc rtpci_read_cfg_byte	;Returns in CL
;	mov	al,cl
	ret
endproc get_sb_link_sirq_chip_reg

;-----------------------------------------------------------------------;
;			SET_SB_LINK_SIRQ_CHIP_REG			;
;-----------------------------------------------------------------------;
; this subrouting enables chipset serial IRQ function.			;
; Input :								;
;	None								;
; Output:								;
;	None								;
;	stack	available						;
;  register usage : can destroy any 16-bit registers			;
;-----------------------------------------------------------------------;
	pubproc set_sb_link_sirq_chip_reg
defproc set_sb_link_sirq_chip_reg
;	mov	bx,(INTEL_PIIX4_BUS shl 8)+INTEL_PIIX4_DEV_FUNC
;	mov	di,IPIIX4_REG_SIRQ_CON
;	mov	cl,0d0h
;	callproc rtpci_write_cfg_byte
	ret
endproc set_sb_link_sirq_chip_reg

;-----------------------------------------------------------------------;
;		      RESTORE_SB_LINK_SIRQ_CHIP_REG			;
;-----------------------------------------------------------------------;
; this subrouting restore chipset serial IRQ configuration register(s)	;
; to original configuration.						;
; Input :								;
;	DS:ESI Pointer to Original Serial IRQ Configuration		;
; Output:								;
;	None								;
;	stack	available						;
;  register usage : can destroy any registers ES, DS			;
;-----------------------------------------------------------------------;
	pubproc restore_sb_link_sirq_chip_reg
defproc restore_sb_link_sirq_chip_reg
;	mov	bx,(INTEL_PIIX4_BUS shl 8)+INTEL_PIIX4_DEV_FUNC
;	mov	di,IPIIX4_REG_SIRQ_CON
;	mov	cl,[esi]
;	callproc rtpci_write_cfg_byte
	ret
endproc restore_sb_link_sirq_chip_reg

