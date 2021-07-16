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

ifndef RT32
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
	pubproc rth_pci_get_last_bus
	pubproc rth_pci_get_hw_mech
	pubproc rth_pci_special_cycle
	pubproc rth_pci_read_cfg
	pubproc rth_pci_write_cfg
	pubproc rth_pci_get_irq_reg
;---------------------------------------;
	extproc rtpci_read_cfg_byte
	extproc rtpci_write_cfg_byte
	extproc	rth_chipset_route_pci_irq
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
	include	setupequ.ext
;------------------------------------------------------------------------------;
;                                                                              ;
;                              16 Bit Code only                                ;
;                                                                              ;
;------------------------------------------------------------------------------;

;---------------------------------------;
; rth_pci_get_irq_priority_map          ;
;---------------------------------------;--------------------------------------;
; This function returns an ordered list of all possible IRQ levels             ;
; that may be routed to the given PCI bus#/device#.  If some IRQ levels have   ;
; already been routed to the PCI bus, then the list may be affected.  The      ;
; function dih_pci_route_irq (see below) must be able to route any of the IRQ  ;
; levels in the list to the given bus#/device# without affecting previous IRQ  ;
; routing.  This function should return a prioritized list of IRQ levels for   ;
; the given bus#/device#.  The list should be written into the caller's buffer ;
; (at DS:SI) and should be terminated with a zero byte.  The list should       ;
; contain one byte for each IRQ level that can be routed to the slot.          ;
;                                                                              ;
; NOTE: This function is called only during POST (in real mode).               ;
;                                                                              ;
; Input: BL = Device/Function number to route IRQ to                           ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number to route IRQ to                                       ;
;        DL = PCI Int pin that the device uses                                 ;
;             (01=IntA, 02=IntB, 03=IntC, 04=IntD).                            ;
;        DS:SI = buffer to hold list of routable IRQ levels (17 bytes max)     ;
;                                                                              ;
; Output: List of IRQ levels in caller's buffer (DS:SI)                        ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
	extrn	rth_check_reg_for_irq:near
	public	irq_map
	public	rth_pci_get_irq_priority_map

rth_pci_get_irq_priority_map	proc near
	pusha

	push	ds
	push	cs
	pop	ds
	push	dx
	call	rth_pci_get_irq_reg	;Returns AL=chip reg, DX=IRQ bit map
	mov	di, dx			;Save IRQ bit map in DI
	pop	dx
	pop	ds
	jc	get_map_done		;Br if unknown device

	or	al, al
	jz	get_map_done		;Br if Device/Int Pin is not connected
	cmp	al, 0F0h
	jae	get_map_not_routed_yet	;Br if Device/Int Pin is hardwired

;----------------- Chipset dependant code starts here ------------------------

;  Check to see if this chipset reg has already been programmmed to route an
;  IRQ.  If it has, then just put that one IRQ into the caller's buffer (at
;  DS:SI), inc SI, then jump to get_map_done.  AL contains chipset register
;  from the IRQ Routing Table above.  DI must be preserved through this code.

	call	rth_check_reg_for_irq	; AL = 00 IRQ not routed yet
					;    <>00 already routed IRQ
	or	al,al			; IRQ routed already ?
	jz	not_routed_yet
;  IRQ already routed..
	mov	byte ptr [si], al	;Put byte into caller's buffer
	inc	si
	jmp	short get_map_done
not_routed_yet:
;----------------- Chipset dependant code ends here ---------------------------

	;This chipset reg has not been used to route an IRQ yet.  DX contains
	;a bit map of IRQs that can be routed to the given Device/Int Pin.
	;Scan through the irq_map list below and copy into the caller's buffer
	;any IRQ levels that have a bit set in DX.

get_map_not_routed_yet:
;  BH, BL = bus#, dev#, func#, DL = 1/2/3/4 for INTA/B/C/D
	call	manual_irq_selection	; check IRQ selection and if selected
					; put the IRQ in buffer and INC SI
	mov	bx, offset cgroup:irq_map
get_map_copy_table:
	movzx	ax, byte ptr cs:[bx]	;Get next byte from table
	bt	di, ax			;Copy bit number AX of BX into CF
	jnc	get_map_skip_bit	;Br if bit not set in DX
	mov	byte ptr [si], al	;Put byte into caller's buffer
	inc	si
get_map_skip_bit:
	inc	bx
	or	al, al
	jnz	get_map_copy_table	;Repeat the copy loop until 0 found

get_map_done:
	mov	byte ptr [si], 0	;Put a zero to mark end of buffer
	popa
	ret
rth_pci_get_irq_priority_map	endp

;irq_map		db	11, 10, 9, 12, 5, 3, 7, 4, 15, 14, 0
;irq_map		db	11, 10, 9, 15, 5, 3, 7, 4, 14, 0
irq_map         db      10, 11, 12, 9, 5, 15, 14, 0, 0, 0, 0, 0
;------------------------------------------------------------------------------;
manual_irq_selection:
;  BH, BL, DL
;  DS:SI = ptr to buffer
;  register destroyed : AL BX CX SI
	push	di
	and	bl,0f8h			; discard func#
	xchg	bl,bh
	movzx	cx, byte ptr cs:rth_pci_device_count
	mov	di, offset cs:rth_pci_irq_routing_table
mis_02:
	cmp	bx, word ptr ((pci_irq_entry ptr cs:[di]).pirq_bus_number)
	je	mis_01			;Br if found bus,dev
	add	di, size pci_irq_entry	;DI points to next entry in table
	loop	mis_02
	jmp	short mis_00		; not found
mis_01:
	mov	al,(pci_irq_entry ptr cs:[di]).pirq_phys_slot; phy slot#
	dec	al			; slot# can not be zero
	cmp	al,(offset cgroup:xlat_slot_setupq_table_end-offset cgroup:xlat_slot_setupq_table)
	jae	mis_00			; slot# invalid
	mov	bx,offset cgroup:xlat_slot_setupq_table
	xlat	cgroup:xlat_slot_setupq_table; AL = setup question#
	db	9ah			; CALL FAR F000:EED5 (CHECK_CMOS_DATA)
	dw	0eed5h
	dw	0f000h
	jz	mis_00			; AUTO
	mov	ds:byte ptr [si],al
	inc	si
mis_00:
	pop	di
	ret
xlat_slot_setupq_table		label	byte
	db	q_pci_slot1_irq
	db	q_pci_slot2_irq
	db	q_pci_slot3_irq
	db	q_pci_slot4_irq
xlat_slot_setupq_table_end	label	byte
;------------------------------------------------------------------------------;
endif

;------------------------------------------------------------------------------;
;                                                                              ;
;                              16/32 Bit Code                                  ;
;                                                                              ;
;------------------------------------------------------------------------------;

;---------------------------------------;
; rth_pci_route_irq                     ;
;---------------------------------------;--------------------------------------;
; This function is to physically route an IRQ to a PCI bus#/device#.           ;
; The IRQ level that must be routed should be one from the list that was       ;
; returned by dih_pci_get_irq_priority_map (see above).                        ;
;                                                                              ;
; NOTE: This function is assembled twice, once for real mode code, and once    ;
;       for 32 bit protected mode code.  All calls must be made using the      ;
;       callproc macro.  Do not modify and segment registers.                  ;
;                                                                              ;
; Input: AL = IRQ level to route to the PCI device                             ;
;        BL = Device/Function number to route IRQ to                           ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number to route IRQ to                                       ;
;        DL = PCI Int pin that the device uses                                 ;
;             (01=IntA, 02=IntB, 03=IntC, 04=IntD).                            ;
;        DS = F000 (or selector pointing to F000 if called in 16-bit protected ;
;             mode).  If called in 32-bit protected mode the DS selector will  ;
;             be set to the same base as the CS selector and will not          ;
;             necessarily be F0000 (some software calls with DS = CS = 0 base) ;
;             This means that in the 32-bit code, no offset in CS should be    ;
;             accessed directly.  You must first get the value of EIP by       ;
;             making a call from a known offset and popping the return         ;
;             address, and then subtracting the offset of that address from    ;
;             the popped value.  The resulting value must be added to any      ;
;             CS:offset before that label is accessed.                         ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
defproc rth_pci_route_irq
	pusha

	mov	ah, al			;Save IRQ level in AH
	callproc rth_pci_get_irq_reg	;Returns AL=chip reg, DX=IRQ bit map
	jc	route_irq_done		;Br if unknown device

	or	al, al
	stc				;Set CF in case this jz jumps
	jz	route_irq_done		;Br if Device/Int Pin is not connected
	cmp	al, 0F0h
	jae	route_irq_success	;Br if Device/Int Pin is hardwired

;----------------- Chipset dependant code starts here ------------------------

;  Program the chipset register in AL with the IRQ level in AH.
;  Also make sure this IRQ is set to level (or edge if needed) trigger.

	callproc rth_chipset_route_pci_irq; route IRQ

;----------------- Chipset dependant code ends here ---------------------------

route_irq_success:
	clc				;Indicate success
route_irq_done:
	popa
	ret
endproc rth_pci_route_irq


;---------------------------------------;
; rth_pci_get_irq_reg                   ;
;---------------------------------------;--------------------------------------;
; This function returns the chipset IRQ register that should be programmed in  ;
; order to route an IRQ to a given PCI device number / Int Pin number.  It     ;
; also returns a bitmap of IRQs that may be routed to the given Device/Int Pin.;
; This information is extracted from the PCI IRQ Routing Table above.          ;
;                                                                              ;
; NOTE: This function does not need to be modified for most platforms.         ;
;                                                                              ;
; NOTE: This function is assembled twice, once for real mode code, and once    ;
;       for 32 bit protected mode code.  All calls must be made using the      ;
;       callproc macro.  Do not modify and segment registers.                  ;
;                                                                              ;
; Input: BL = Device/Function number to route IRQ to                           ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number to route IRQ to                                       ;
;        DL = PCI Int pin that the device uses                                 ;
;             (01=IntA, 02=IntB, 03=IntC, 04=IntD).                            ;
;        DS = F000 (or selector pointing to F000 if called in 16-bit protected ;
;             mode).  If called in 32-bit protected mode the DS selector will  ;
;             be set to the same base as the CS selector and will not          ;
;             necessarily be F0000 (some software calls with DS = CS = 0 base) ;
;             This means that in the 32-bit code, no offset in CS should be    ;
;             accessed directly.  You must first get the value of EIP by       ;
;             making a call from a known offset and popping the return         ;
;             address, and then subtracting the offset of that address from    ;
;             the popped value.  The resulting value must be added to any      ;
;             CS:offset before that label is accessed.                         ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AL = Chipset IRQ register number from rth_pci_irq_routing_table      ;
;              in the file RTH-PCI.ASM                                         ;
;         DX = Bitmap of IRQs that can be routed to the given Device/Int Pin.  ;
;                Bit 0: If set, chipset can route IRQ 0 to the device/pin      ;
;                ...     ...                                                   ;
;                Bit 15: If set, chipset can route IRQ 15 to the device/pin    ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
defproc rth_pci_get_irq_reg
	assume	ds:cgroup
	push	ebx
	push	ecx
	push	esi

ifndef RT32

	extrn	rth_pci_device_count:byte
	extrn	rth_pci_irq_routing_table:byte
	movzx	cx, byte ptr ds:rth_pci_device_count
	mov	esi, offset ds:rth_pci_irq_routing_table
else
	push	ebx			;Save Bus/Dev/Func #
	call	dummy			;Push EIP on stack
dummy:	pop	ebx			;EBX = EIP = xxxx0000 + offset dummy
	sub	ebx, offset cs:dummy	;EBX = xxxx0000

	movzx	esi, word ptr [ebx+0E009h]
	movzx	esi, word ptr [esi+ebx+0E00Ch-0FFFFh] ;ESI points to rth_pci_device_limit
	add	esi, ebx
	movzx	ecx, byte ptr [esi+1]	;ECX = rth_pci_device_count
	add	esi, 4			;ESI points to rth_pci_irq_routing_table
	pop	ebx			;Restore Bus/Dev/Func #
endif

	and	bl, 0F8h		;Zero out function number
	xchg	bh, bl			;Swap Bus # and Dev # to match table

get_irq_next_dev:
	cmp	word ptr ((pci_irq_entry ptr [esi]).pirq_bus_number), bx
	je	get_irq_found_dev	;Br if found proper bus#/dev#
	add	esi, size pci_irq_entry	;ESI points to next entry in table
	loop	get_irq_next_dev
	stc				;Indicate error
	jmp	short get_irq_done

get_irq_found_dev:
	lea	esi, (pci_irq_entry ptr [esi]).pirq_inta_reg
	dec	dl			;DL = 0/1/2/3 for Int A/B/C/D
	mov	dh, dl
	shl	dl, 2			;DL = 0/4/8/C for Int A/B/C/D
	sub	dl, dh			;DL = 0/3/6/9 for Int A/B/C/D
	movzx	ebx, dl			;EBX = 0/3/6/9 for Int A/B/C/D
	add	esi, ebx		;ESI points to chipset reg value
	mov	al, byte ptr [esi]	;AL = chipset reg value
	mov	dx, word ptr [esi+1]	;DX = bitmap of routable IRQs
	clc

get_irq_done:
	pop	esi
	pop	ecx
	pop	ebx
	ret
	assume	ds:nothing
endproc rth_pci_get_irq_reg


;---------------------------------------;
; rth_pci_search_xlat                   ;	MOVED TO OEMRPCI.ASM
;---------------------------------------;
; rth_pci_get_last_bus                  ;
;---------------------------------------;--------------------------------------;
; This function returns the number of the last PCI bus in the system.  If the  ;
; system has one PCI bus this function should return 0.                        ;
;                                                                              ;
; NOTE: This function does not need to be modified for most platforms.         ;
;                                                                              ;
; NOTE: This function is assembled twice, once for real mode code, and once    ;
;       for 32 bit protected mode code.  All calls must be made using the      ;
;       callproc macro.  Do not modify and segment registers.                  ;
;                                                                              ;
; Input:  None                                                                 ;
;                                                                              ;
; Output: CL = Bus number of last PCI bus                                      ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
	extproc rtpci_read_cfg_word
defproc	rth_pci_get_last_bus
	push	ax
	push	bx
	push	dx
	push	di
	push	cx			;Keep this last on stack

	xor	dl, dl			;Default Max Bus is 0
	mov	bx, 0000h		;Bus 0 / Device 00 / Func 0
last_bus_next_dev:
	mov	di, PCI_REG_SUB_TYPE
	callproc rtpci_read_cfg_word	;Returns Base class / Sub class in CX
	jc	last_bus_skip_dev	;Br if error reading CFG space
	cmp	cx, (BT_BRIDGE * 100h) + ST_PCI_BR
	jne	last_bus_skip_dev	;Br if not a PCI-PCI bridge

	mov	di, PPB_REG_SUB_BUS_NUM
	callproc rtpci_read_cfg_byte	;Returns Subordinate bus # in CL
	jc	last_bus_skip_dev	;Br if error reading CFG space
	cmp	cl, dl
	jbe	last_bus_skip_dev	;Br if <= current Max Bus #
	mov	dl, cl			;Update Max Bus #

last_bus_skip_dev:
	add	bl, 8			;Next PCI device
	jnc	last_bus_next_dev	;Try device 00 - 1F (BL = 00 - F8)

	pop	cx
	mov	cl, dl
	pop	di
	pop	dx
	pop	bx
	pop	ax
	ret
endproc rth_pci_get_last_bus


;---------------------------------------;
; rth_pci_get_hw_mech                   ;
;---------------------------------------;--------------------------------------;
; This function returns the hardware mechanisms supported by this system.      ;
; Any of the following constants can be used:                                  ;
;     PCI_SPEC_CYCLE_M1, PCI_CFG_SPACE_M1                                      ;
;     PCI_SPEC_CYCLE_M2, PCI_CFG_SPACE_M2                                      ;
;                                                                              ;
; NOTE: This function is assembled twice, once for real mode code, and once    ;
;       for 32 bit protected mode code.  All calls must be made using the      ;
;       callproc macro.  Do not modify and segment registers.                  ;
;                                                                              ;
; Input:  None                                                                 ;
;                                                                              ;
; Output: AL = Hardware mechanisms supported by this system:                   ;
;                 Bit 7-6: Reserved                                            ;
;                 Bit 5:   If 1, special cycle mechanism 2 is supported        ;
;                 Bit 4:   If 1, special cycle mechanism 1 is supported        ;
;                 Bit 3-2: Reserved                                            ;
;                 Bit 1:   If 1, configuration space mechanism 2 is supported  ;
;                 Bit 0:   If 1, configuration space mechanism 1 is supported  ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
defproc	rth_pci_get_hw_mech
	mov	al, PCI_CFG_SPACE_M1	;Config mechanism 1 is default
	ret
endproc rth_pci_get_hw_mech


;---------------------------------------;
; rth_pci_special_cycle                 ;
;---------------------------------------;--------------------------------------;
; This function is used to generate a special cycle on the specified PCI bus.  ;
; A special cycle "broadcasts" the data to all PCI devices on a bus.  The bus  ;
; number must be checked and carry should be set if the bus number is invalid. ;
;                                                                              ;
; NOTE: Special cycle is not supported here.  Modify this function only if     ;
;       special cycle support is needed.                                       ;
;                                                                              ;
; NOTE: This function is assembled twice, once for real mode code, and once    ;
;       for 32 bit protected mode code.  All calls must be made using the      ;
;       callproc macro.  Do not modify and segment registers.                  ;
;                                                                              ;
; Input:  BH = PCI bus number                                                  ;
;        EDX = Special cycle data                                              ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;         AH = Non zero return code if CF set (see RT.EQU)                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
defproc	rth_pci_special_cycle
	mov	ah, RT_INVALID_FUNC
	stc
	ret
endproc rth_pci_special_cycle


;---------------------------------------;
; rth_pci_read_cfg                      ;
;---------------------------------------;--------------------------------------;
; This function reads a dword from the configuration space of given device /   ;
; function.  The bus number must be checked and carry should be set if the bus ;
; number is invalid.                                                           ;
;                                                                              ;
; NOTE: This function should only be called from RT-PCI.ASM.  All other        ;
; callers must call the rt_entry (in RT.ASM) with AH containing the proper     ;
; function number (see RT.EQU).                                                ;
;                                                                              ;
; Input:  BH = PCI Bus number                                                  ;
;         BL = Device / Function number                                        ;
;              Bits 7-3: PCI device number                                     ;
;              Bits 2-0: Function number within the device                     ;
;         DI = Register number (must be dword aligned address, this value has  ;
;              already been checked for validity)                              ;
;         SI = One of the following values: PCI_REG_ADDRESS_BYTE               ;
;              PCI_REG_ADDRESS_WORD, or PCI_REG_ADDRESS_DWORD                  ;
;                                                                              ;
; Output: ECX, CX, CL = Data read from configuration space (width depends on   ;
;                       value of SI on entry)                                  ;
;         CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
defproc rth_pci_read_cfg
	push	eax
	push	dx

	mov	ah, 80h			;Set enable bit
	mov	al, bh
	shl	eax, 16
	mov	ax, di			;Add in register offset part
	mov	ah, bl			;Add in dev/func num part
	and	al, 0FCh		;Make address dword aligned
	mov	dx, CFG_SPACE_INDEX_REG
	pushf				;Save current state of IF and CLI
	cli
	out	dx, eax			;Set the index

	mov	dx, di			;Get original config register address
	and	dx, 03h			;Isolate lower 2 bits
	add	dx, CFG_SPACE_DATA_REG	;Add offset (0/1/2/3) to data addr

	cmp	si, PCI_REG_ADDRESS_BYTE
	jne	read_cfg_try_word
	in	al, dx			;Read the config register
	mov	cl, al
	jmp	short read_cfg_done

read_cfg_try_word:
	cmp	si, PCI_REG_ADDRESS_WORD
	jne	read_cfg_try_dword
	in	ax, dx			;Read the config register
	mov	cx, ax
	jmp	short read_cfg_done

read_cfg_try_dword:
	in	eax, dx			;Read the config register
	mov	ecx, eax

read_cfg_done:
	popf				;Restore state of IF
	pop	dx
	pop	eax
	clc
	ret
endproc rth_pci_read_cfg


;---------------------------------------;
; rth_pci_write_cfg                     ;
;---------------------------------------;--------------------------------------;
; This function writes a dword to the configuration space of given device /    ;
; function.  The bus number must be checked and carry should be set if the bus ;
; number is invalid.                                                           ;
;                                                                              ;
; NOTE: This function should only be called from RT-PCI.ASM.  All other        ;
; callers must call the rt_entry (in RT.ASM) with AH containing the proper     ;
; function number (see RT.EQU).                                                ;
;                                                                              ;
; Input:  BH = PCI Bus number                                                  ;
;         BL = Device / Function number                                        ;
;              Bits 7-3: PCI device number                                     ;
;              Bits 2-0: Function number within the device                     ;
;         DI = Register number (must be dword aligned address, this value has  ;
;              already been checked for validity)                              ;
;         SI = One of the following values: PCI_REG_ADDRESS_BYTE               ;
;              PCI_REG_ADDRESS_WORD, or PCI_REG_ADDRESS_DWORD                  ;
;         ECX, CX, CL = Data to write to configuration space (width depends on ;
;                       value of SI)                                           ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
defproc	rth_pci_write_cfg
	push	eax
	push	dx

	mov	ah, 80h			;Set enable bit
	mov	al, bh
	shl	eax, 16
	mov	ax, di			;Add in register offset part
	mov	ah, bl			;Add in dev/func num part
	and	al, 0FCh		;Make address dword aligned
	mov	dx, CFG_SPACE_INDEX_REG
	pushf				;Save current state of IF and CLI
	cli
	out	dx, eax			;Set the index

	mov	dx, di			;Get original config register address
	and	dx, 03h			;Isolate lower 2 bits
	add	dx, CFG_SPACE_DATA_REG	;Add offset (0/1/2/3) to data addr

	cmp	si, PCI_REG_ADDRESS_BYTE
	jne	write_cfg_try_word
	mov	al, cl
	out	dx, al			;Write the config register
	jmp	short write_cfg_done

write_cfg_try_word:
	cmp	si, PCI_REG_ADDRESS_WORD
	jne	write_cfg_try_dword
	mov	ax, cx
	out	dx, ax			;Write the config register
	jmp	short write_cfg_done

write_cfg_try_dword:
	mov	eax, ecx
	out	dx, eax			;Write the config register

write_cfg_done:
	popf				;Restore state of IF
	pop	dx
	pop	eax
	clc
	ret

endproc rth_pci_write_cfg
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
	include	sb-link.inc		; (CORE0202+)
ifndef RT32
	_text	 ends
else
	_runtime32 ends
endif
	 end
