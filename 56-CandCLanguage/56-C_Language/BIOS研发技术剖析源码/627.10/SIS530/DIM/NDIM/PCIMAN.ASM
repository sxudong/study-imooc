	page	,132
	title .			PCI Manual Override Device Initializer
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
	include	dim.equ
	include devnode.equ
	include rt.equ
	include escd.equ
	include pci.equ
	include pnp.equ
;---------------------------------------;

	public pci_man_get_device_settings
	public pci_man_check_disabled
	public pci_man_prog_base_addr
	public pci_man_prog_rom_addr
	public pci_man_prog_irq
	public pci_man_get_latency

;---------------------------------------;

	extrn configure_pci_irq: near

	extrn OwnerWork: 	byte
	extrn PCIManOwner: 	byte
	extrn PciIOConflict: 	dword
	extrn PciIrqConflict: 	dword
	extrn PciMemConflict: 	dword
	extrn PciStatus: 	dword
	extrn EscdFuncNum:	byte 
	extrn EscdSlotNum:	byte

;---------------------------------------;

cgroup	group	_text
_text 	segment byte public 'CODE'
	assume	cs:cgroup
.386


;---------------------------------------;
; pci_man_get_device_settings           ;
;---------------------------------------;--------------------------------------;
; This routine reads manual settings for the given PCI device from CMOS and    ;
; returns the data in the form of the following structure:                     ;
;                                                                              ;
;   pci_man_settings	struc						       ;
;   pciman_flags	db ?		;Various flag bits		       ;
;                                       ; Bit 0: 0 = Disable the device        ;
;                                       ;        1 = Enable the device         ;
;                                       ; Bit 7-1: Reserved (set to 0)         ;
;   pciman_latency	db ?		;Value for latency timer reg	       ;
;   pciman_io_base	dw 4 dup (?)	;Values for 4 I/O base addr regs       ;
;   pciman_rom_base	dd ?		;Value for PCI Exp ROM base addr reg   ;
;   pciman_int_line     db ?            ;Int Line to use (Auto/A/B/C/D/Disable);
;   pciman_irq          db ?            ;IRQ to route to this Int Line         ;
;   pci_man_settings	ends						       ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        DS:SI = Pointer to buffer containing a pci_man_settings structure     ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Clear if device should be completely autoconfigured.            ;
;              Set if a device has one or more manually overridden config      ;
;              settings.                                                       ;
;        DS:SI = A pci_man_settings structure filled in with proper data if    ;
;                CF is set.                                                    ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
;  THE FOLLOWING ROUTINE IS NEEDED FOR GENERIC BIOS IMPLEMENTATION WHICH DOES
;  NOT IMPLEMENT SETUP QUESTION FOR EXPANSION ROM ADDRESS
FIRST_CMOS_REG		equ	51h	;Manual config CMOS data starts here
LAST_CMOS_REG		equ	68h	;Manual config CMOS data ends here
CMOS_BYTES_PER_SLOT	equ	06h	;#of CMOS registers used by a PCI SLOT
pci_man_get_device_settings	proc near
	pusha

	mov	di, si
	mov	cx, size pci_man_settings
	cld
	xor	al, al
	rep	stosb			;Initialize buffer to all auto config

	or	bh, bh
	jnz	get_dev_no_override	;Br if bus number <> 0
	test	bl, 07h
	jnz	get_dev_no_override	;Br if function number <> 0
	
	mov	al, 8Eh			;Read CMOS status reg
	call	read_cmos
	test	al, 0C1h
	jnz	get_dev_no_override	;Br if CMOS is bad or <INS> pressed

	shr	bl, 3			;BL = PCI Device #
	mov	ah, FIRST_CMOS_REG

get_dev_next_dev:
	push	ax
;Get byte 0 of cmos for IDSEL, latency timer
	mov	al, ah
	call	read_cmos		;AL bit 7:3 = IDSEL
					;   bit 2   = Not used
	xor	ecx, ecx		;   bit 1:0 = Latency timer
	mov	cl, al			;Save bits 1-0
	shr	al, 3
	and	al, 1Fh			;AL = IDSEL
	cmp	al, bl
	jne	get_dev_skip_dev	;Br if dev # does not match
	and	cl, 03h			;CL = Latency value 0/1/2/3
	inc	cl			;CL = 1/2/3/4
	shl	cl, 6			;CL = 40/80/C0/00
	jnz	get_dev_set_latency
	mov	cl, 0F8h
get_dev_set_latency:			;CL = 40/80/C0/F8
	mov	(pci_man_settings ptr [si]).pciman_latency, cl

;Get bytes 1/2/3/4 from CMOS and program I/O base address

	xor	bx, bx
get_dev_next_io:
	inc	ah
	mov	al, ah
	call	read_cmos		;AL = 00/40/41/42/.../FF
	movzx	cx, al
	jcxz	get_dev_set_iobase	;Br if base addr is auto
	shl	cx, 2			;CX = 100/104/108/.../3FC
	cmp	cx, 100h
	jae	get_dev_set_iobase	;Br if base addr is not disabled
	mov	cx, 0FFFFh
get_dev_set_iobase:			;CX = 100/104/108/.../3FC/FFFF
	mov	(pci_man_settings ptr [si+bx]).pciman_io_base, cx
	inc	bx
	inc	bx
	cmp	bl, 8
	jb	get_dev_next_io		;Br if not done with all 4 I/Os

; Get byte 5 from CMOS and program Int Line, IRQ and device enable/disable

	inc	ah
	mov	al, ah
	call	read_cmos		;AL bit 2-0: 0->5 = Auto/A/B/C/D/Disable
					;   bit 3  : 0/1 = enabled/disabled
	mov	cl, al			;   bit 7-4: IRQ to route (if bit 2-0 valid)
	test	al, 08h
	jnz	get_dev_buffer_done	;Br if device is disabled
	or	(pci_man_settings ptr [si]).pciman_flags, 01h
get_dev_dis_done:
	and	cl, 07h
	cmp	cl, 4
	jbe	get_dev_set_int_line	;Br if Int Line not disabled
	mov	cl, 0FFh
get_dev_set_int_line:
	mov	(pci_man_settings ptr [si]).pciman_int_line, cl
	shr	al, 4			;AL = IRQ to route
	mov	(pci_man_settings ptr [si]).pciman_irq, al

	lea	di, (pci_man_settings ptr [si]).pciman_io_base
	mov	cx, 13			;4 I/O (8 bytes) + 1 Exp ROM (4 bytes)
	xor	al, al			;  + Int Line (1 byte)
	repz	scasb
	jnz	get_dev_buffer_done	;Br if one or more manual settings
	pop	ax
	jmp	short get_dev_no_override

get_dev_buffer_done:
	pop	ax
	stc
	jmp	short get_dev_done

get_dev_skip_dev:
	pop	ax
	add	ah, CMOS_BYTES_PER_SLOT	;CMOS reg for next device
	cmp	ah, LAST_CMOS_REG
	jb	get_dev_next_dev	;Br if more devs in CMOS

get_dev_no_override:
	clc

get_dev_done:
	popa
	ret
pci_man_get_device_settings	endp

;---------------------------------------;
;  THE FOLLOWING ROUTINE IS NEEDED FOR THE BIOS IMPLEMENTATION WHICH DOES
;  IMPLEMENT SETUP QUESTION FOR EXPANSION ROM ADDRESS

;---------------------------------------;
; pci_man_check_disabled                ;
;---------------------------------------;--------------------------------------;
; This function will be called only if one or more settings for a device are   ;
; set to manual override.  This function should check the enable/disable bit   ;
; in the pci_man_settings structure passed in and return CF set properly.      ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        DS:SI = Pointer to buffer containing a pci_man_settings structure     ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if device should be disabled                                ;
;              Clear if device should be configured using the manual setting(s);
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_man_check_disabled	proc near
	test	(pci_man_settings ptr [si]).pciman_flags, 01h
	jnz	check_dis_done		;Br if enabled (CF is already clear)
	stc
check_dis_done:
	ret
pci_man_check_disabled	endp


;---------------------------------------;
; pci_man_prog_base_addr                ;
;---------------------------------------;--------------------------------------;
; This function forces a PCI base address register to a manual override value. ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        DI = Offset in PCI config space of base address register              ;
;        DS:SI = Pointer to buffer containing a pci_man_settings structure     ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if base address register was not programmed and should be   ;
;              autoconfigured.                                                 ;
;              Clear if the base address register has been manually overridden.;
;         ZF = Valid only if CF is clear                                       ;
;              Set if manual override was successful                           ;
;              Clear if manual override would cause conflict                   ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_man_prog_base_addr	proc near
	pushad

	cmp	di, 1Ch
	ja	prog_base_auto		;Br if not one of 1st four base addr regs

	push	bx
	mov	bx, di
	sub	bx, 10h			;BX = 0/4/8/C
	shr	bx, 1			;BX = 0/2/4/6
	movzx	ecx, (pci_man_settings ptr [si+bx]).pciman_io_base
	pop	bx

	jcxz	prog_base_auto		;Br if addr is 0 (auto config)
	inc	cx
	clc				;Clear CF in case this jz jumps
	jz	prog_base_exit		;Br if addr was FFFF (disabled)
	dec	cx

	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write reg DI with ECX

	mov	dx, 8			;Assume 8 bytes of I/O if IDE
	cmp	cx, 1F0h
	je	prog_base_alloc		;Br if primary IDE
	cmp	cx, 170h
	je	prog_base_alloc		;Br if secondary IDE
	mov	dx, 4			;Assume 4 byte default
	cmp	ch, 03h			;3xx ?
	jnz	prog_base_alloc
	cmp	cl, 0F4h
	je	prog_base_ide		;Br if primary IDE
	cmp	cl, 74h
	je	prog_base_ide		;Br if secondary IDE
	cmp	cl, 0F0h
	je	prog_base_ide		;Br if primary IDE
	cmp	cl, 070h
	jnz	prog_base_alloc		;Br if not secondary IDE
prog_base_ide:
	mov	dx, 1			;1 byte for IDE control port
	and	cl, 0f0h
	or	cl, 06h			;CX = 3F6/376 for primary/secondary IDE

prog_base_alloc:
	push	bx
	mov	di, offset OwnerWork	;Point ES:DI to owner_pci structure
	mov	bx, cx			;Min base addr = Max base addr
	mov	si, 1			;Alignment = byte
	mov	ax, (RM_ALLOC_PORT * 100h) + RESFLAG_PORT_DECODE16
	CALL_RESMGR			;Call Resource Manager to allocate port
	pop	bx
	mov	al, 0FFh
	jnc	prog_base_done		;Br if alloc successful

	or	PciStatus, STAT_PCI_IO_CONFLICT
	shr	bl, 3			;BL = dev # (0/1/2/3/.../1F)
	xor	bh, bh
	bts	word ptr PciIOConflict, bx
	inc	al			;Make AL = 0
	clc

prog_base_done:
	inc	al			;AL will be 0 if successful, non-zero
prog_base_exit:				;  if a conflict
	popad
	ret

prog_base_auto:
	stc				;Indicate port should be autoconfigured
	jmp	short prog_base_exit

pci_man_prog_base_addr	endp


;---------------------------------------;
; pci_man_prog_rom_addr                 ;
;---------------------------------------;--------------------------------------;
; This function forces a the expansion ROM base address register to a manual   ;
; override value.                                                              ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        DI = Offset in PCI config space of expansion ROM base address reg     ;
;        DS:SI = Pointer to buffer containing a pci_man_settings structure     ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if base address register was not programmed and should be   ;
;              autoconfigured.                                                 ;
;              Clear if the base address register has been manually overridden.;
;         ZF = Valid only if CF is clear                                       ;
;              Set if manual override was successful                           ;
;              Clear if manual override would cause conflict                   ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_man_prog_rom_addr	proc near
	pushad

	mov	cx, (pci_man_settings ptr [si]).pciman_io_base
	jcxz	prog_rom_auto		;Br if 1st base addr is auto (0000)
	inc	cx
	jcxz	prog_rom_auto		;Br if 1st base addr is disabled (FFFF)

	mov	di, PCI_REG_VENDID
	mov	ah, RT_PCI_READ_CFG_DWORD
	CALL_RT_FUNCTION		;ECX = Vendor / Device ID
	cmp	cx, 104Bh		;Buslogic Vendor ID
	jne	prog_rom_auto		;Br if no match
	shr	ecx, 24			;CL = High byte of device ID
	cmp	cl, 10h
	jae	prog_rom_auto		;Br if Device ID >= 10xxh

	mov	di, offset PCIManOwner	;Point ES:DI to owner structure
	mov	(owner_isa ptr [di]).own_isa_sig, OWNTYPE_ISA
	mov	(owner_isa ptr [di]).own_isa_slot, 0
	mov	(owner_isa ptr [di]).own_isa_func, 0
	mov	dword ptr ((owner_isa ptr [di]).own_isa_vendid), 0
	mov	(owner_isa ptr [di]).own_isa_rsvd2, 0

	push	bx
	mov	edx, 4000h		;Size = 16k
	mov	ebx, 0C8000h		;Min base addr = C800:0
	mov	ecx, 0DC000h		;Max base addr = DC00:0
	mov	esi, 4000h		;Alignment = 16k
	mov	ax, (RM_ALLOC_MEM * 100h) + RESFLAG_MEM_SHADOW + RESFLAG_LO_TO_HI
	CALL_RESMGR			;Call Resource Manager to allocate mem
	pop	bx
	jc	prog_rom_auto		;Br if error in alloc

	mov	ecx, eax
	or	cl, 1
	mov	di, PCI_REG_ROM_BASE_ADD
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Program Exp ROM reg
	xor	al, al			;Clear CF and set ZF
	jmp	short prog_rom_done

prog_rom_auto:
	stc
prog_rom_done:
	popad
	ret
pci_man_prog_rom_addr	endp
;---------------------------------------;
; pci_man_prog_irq                      ;
;---------------------------------------;--------------------------------------;
; This function forces an Interrupt Line register to a manual override         ;
; value and routes an IRQ to the given Int pin.                                ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        DI = Offset in PCI config space of Int Line register                  ;
;        DS:SI = Pointer to buffer containing a pci_man_settings structure     ;
;        BP = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if base address register was not programmed and should be   ;
;              autoconfigured.                                                 ;
;              Clear if the base address register has been manually overridden.;
;         ZF = Valid only if CF is clear                                       ;
;              Set if manual override was successful                           ;
;              Clear if manual override would cause conflict                   ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_man_prog_irq	proc near
	pusha

	mov	al, EscdFuncNum		;Save ESCD slot/func
	mov	ah, EscdSlotNum
	push	ax
	mov	EscdFuncNum, 0		;Make sure we don't use ESCD data
	mov	EscdSlotNum, INVALID_SLOT_NUM

	mov	dx, word ptr (pci_man_settings ptr [si]).pciman_int_line
	or	dl, dl			;DL = 0-5 : Auto/A/B/C/D/Disable, DH=IRQ
	stc
	jz	prog_irq_auto		;Br if Int Line is 0 (auto config)
	cmp	dl, 0FFh
	jne	prog_irq_manual		;Br if Int Line is not FF
	xor	cl, cl			;Force Int Line reg to 00 (disabled)
	mov	ah, RT_PCI_WRITE_CFG_BYTE
	CALL_RT_FUNCTION		;Write Int Line reg with CL
	xor	al, al			;CF clear, ZF set for successful
	jmp	short prog_irq_auto

prog_irq_manual:			;DH = IRQ needed / FF for any IRQ
	push	si			;DL = Int Pin reg value (assume INTA)
	mov	si, bp			;SI = ptr to NVRam workspace
	mov	di, offset OwnerWork	;Point ES:DI to owner_pci structure
	call	configure_pci_irq	;Returns alloc'd IRQ in CL
	pop	si			;Restore SI
	mov	al,0ffh			;set AL = FF so that INC AL makes ZF set
	jnc	prog_irq_done		;Br if alloc'd IRQ ok

	or	PciStatus, STAT_PCI_IRQ_CONFLICT
	shr	bl, 3			;BL = dev # (0/1/2/3/.../1F)
	xor	bh, bh
	bts	word ptr PciIrqConflict, bx
	xor	al, al			;Make AL = 0, and CF clear

prog_irq_done:
	inc	al			;ZF set for successful
					;   not set for conflict
prog_irq_auto:
	pop	ax
	mov	EscdFuncNum, al		;Restore ESCD slot/func
	mov	EscdSlotNum, ah

	popa
	ret
pci_man_prog_irq	endp


;---------------------------------------;
; pci_man_get_latency                   ;
;---------------------------------------;--------------------------------------;
; This function returns the manual override value to be used for the Max.      ;
; Latency register.                                                            ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        AL = Default value for the Max Latency register                       ;
;        BH = Bus number of device to initialize                               ;
;        DS:SI = Pointer to buffer containing a pci_man_settings structure     ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: AL = Value to use when programming the device's Max Latency reg.     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_man_get_latency	proc near
	cmp	(pci_man_settings ptr [si]).pciman_latency, 0
	jz	get_lat_auto
	mov	al, (pci_man_settings ptr [si]).pciman_latency
get_lat_auto:
	ret
pci_man_get_latency	endp



read_cmos	proc near
	or	al, 80h
	out	70h, al
	jcxz	$+2
	jcxz	$+2
	in	al, 71h
	ret
read_cmos	endp



_text	ends
	end

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

