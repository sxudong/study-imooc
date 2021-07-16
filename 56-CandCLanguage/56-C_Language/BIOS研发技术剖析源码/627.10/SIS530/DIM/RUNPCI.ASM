	page	,132
	title .			Hooks into Run Time PCI Functions
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

ifndef	RT32
	.286
else
	.386
endif
;---------------------------------------;
	include rt.equ
	include pci.equ
	include devnode.equ
	include mac32.mac
;---------------------------------------;
        include mbiosmac.mac
	include makeflag.equ
	include sis530.equ
;---------------------------------------;
	extproc rtpci_read_cfg_byte
	extproc rtpci_write_cfg_byte
	extproc	rth_pci_get_irq_reg
;---------------------------------------;
CFG_SPACE_INDEX_REG	equ	0CF8h	;For systems with config mechanism 1
CFG_SPACE_DATA_REG	equ	0CFCh
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
ifndef RT32
	cgroup	group	_text
	_text segment word public 'CODE'
		 assume	cs:CGROUP
	.386
else
	.386
	cgroup	group	_runtime32
	_runtime32 segment word public USE32 'CODE'
		 assume	cs:cgroup
endif



ifndef RT32
;------------------------------------------------------------------------------;
;                                                                              ;
;                             16 Bit Code Only                                 ;
;                                                                              ;
;------------------------------------------------------------------------------;

;---------------------------------------;
; rth_pci_irq_routing_table             ;	MOVED TO OEMRPCI.ASM
;---------------------------------------;
; rth_check_reg_for_irq			;
;---------------------------------------;--------------------------------------;
; This function checks if this chipset reg has already been programmmed to     ;
; route an IRQ.                                                                ;
; NOTE: This function is called from RTH_PCI_GET_IRQ_PRIORITY_MAP routine.     ;
;                                                                              ;
; Input:  AL = chipset register						       ;
;         DL = PCI Int Pin device is using (1,2,3,4 -> INTA,INTB,INTC,INTD)    ;
; Output: AL = 00 if chipset register has not been programmed to route an IRQ  ;
;	     <>00 IRQ value with which chipset register has already been       ;
;		  programmed to route this IRQ.				       ;
; Destroys: AL only							       ;
;------------------------------------------------------------------------------;
	public rth_check_reg_for_irq
rth_check_reg_for_irq	proc near
        push    bx                       ; save registers
        push    cx
        push    di

	push	ax
        movzx   di,al                   ; DI = chipset reg.
        mov     bx,S5595_BUS_NUM+S5595_PCI2ISA_DEV_FUNC_NUM
        callproc rtpci_read_cfg_byte
	pop	ax
        mov     al,cl                   ; put IRQ into caller's buffer
        and     al,00001111b

        pop     di                      ; restore registers
        pop     cx
        pop     bx
	ret
rth_check_reg_for_irq	endp
;------------------------------------------------------------------------------;
endif	;ifndef RT32

;------------------------------------------------------------------------------;
;                                                                              ;
;                              16/32 Bit Code                                  ;
;                                                                              ;
;------------------------------------------------------------------------------;


;---------------------------------------;
; rth_chipset_route_pci_irq		;
;---------------------------------------;--------------------------------------;
; This function is physically routes the given IRQ by programming the given    ;
; chipset register. Also this function must set the IRQ to edge/level mode     ;
; properly.								       ;
;                                                                              ;
; NOTE: This function is assembled twice, once for real mode code, and once    ;
;       for 32 bit protected mode code.  All calls must be made using the      ;
;       callproc macro.  Do not modify and segment registers.                  ;
;                                                                              ;
; Input: AH = IRQ to route						       ;
;	 AL = chipset register						       ;
;                                                                              ;
; Output: NONE								       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
	pubproc rth_chipset_route_pci_irq
defproc rth_chipset_route_pci_irq
	pushf
	or	al, al
	jz	invalid_irq
	pusha

	push	ax	 		;Save Input parameters
	movzx	di, al
        mov     bx,S5595_BUS_NUM+S5595_PCI2ISA_DEV_FUNC_NUM
        callproc rtpci_read_cfg_byte
	pop	ax
        and     cl,01110000b
        or      cl,ah                   ; CL = data to write
	push	ax
        callproc rtpci_write_cfg_byte
	pop	ax	 		;Recover input parameters

	mov	bx, 1	 		;IRQ to set to level trigger
	mov	cl, ah
	shl	bx, cl
        mov     dx, 04D0h              	;Program 4D0,4D1h as level trigger
        in      al, dx
        jmp	short $+2
	or	al, bl
	out	dx, al
        jmp	short $+2
	inc	dx
	in	al, dx
        jmp	short $+2
        or      al, bh
        out     dx, al
	popa
invalid_irq:
	popf
	ret
endproc rth_chipset_route_pci_irq
;------------------------------------------------------------------------------;
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
	_text	 ends
else
	_runtime32 ends
endif
	 end


