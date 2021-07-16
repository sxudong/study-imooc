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
;****************************************************************************;
	include pci.equ
CFG_SPACE_INDEX_REG	equ	0CF8h	;For systems with config mechanism 1
CFG_SPACE_DATA_REG	equ	0CFCh

;---------------------------------------;

	public  smi_pci_read_cfg
	public  smi_pci_write_cfg
	public  smi_pci_find_device

;---------------------------------------;


usbdgroup	group	usbdseg
usbdseg segment page public 'DATA'
usbdseg	ends


cgroup	group	_text
_text 	segment word public 'CODE'

	assume	cs:cgroup
	assume	ds:usbdgroup
	assume	es:usbdgroup

.586p

;---------------------------------------;
; smi_pci_read_cfg                      ;
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
smi_pci_read_cfg	proc	near
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
smi_pci_read_cfg	endp


;---------------------------------------;
; smi_pci_write_cfg                     ;
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
smi_pci_write_cfg	proc	near
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

smi_pci_write_cfg	endp


;---------------------------------------;
; smi_pci_find_device                   ;
;---------------------------------------;--------------------------------------;
; This function searches for PCI devices that match a given vendor/device ID.  ;
;                                                                              ;
; Input: EDX = Vendor/Device ID                                                ;
;              Bit[31:16] = Device ID                                          ;
;              Bit[15:00] = Vendor ID                                          ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;         BH = PCI bus number                                                  ;
;         BL = Device / Function number                                        ;
;              Bits 7-3: PCI device number                                     ;
;              Bits 2-0: Function number within the device                     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
smi_pci_find_device	proc near
COMMENT ~
	push	ecx
	push	bp
	push	si
	push	di

	xor	bx, bx			;BL will count dev nums, BH will count busses
					;Only search bus 0 for USB HC
find_dev_dev_loop:
	mov	bp, bx			;Save Bus # / Dev index
	shl	bl, 3			;Put device number in bits 7-3

	mov	di, PCI_REG_HEADER_TYPE
	mov	si, PCI_REG_ADDRESS_BYTE
	call	smi_pci_read_cfg
	test	cl, MULTI_FUNC_BIT
	jz	find_dev_single_func	;Br if device has single function
	or	bl, 7			;Must scan all functions (7-0)
find_dev_single_func:

find_dev_func_loop:
	mov	di, PCI_REG_VENDID	;DI = Vendor/Device ID register
	mov	si, PCI_REG_ADDRESS_DWORD
	call	smi_pci_read_cfg	;Returns ECX = Vendor/Device ID

	cmp	ecx, edx		;EDX was passed in, ECX was just set
	clc				;Clear CF in case this jz jumps
	jz	find_dev_found		;Br if found the device

find_dev_next_func:
	test	bl, 7
	jz	find_dev_next_dev	;Br if searched through function 0
	dec	bl			;Try next function on the device
	jmp	short find_dev_func_loop

find_dev_next_dev:
	mov	bx, bp			;Restore Bus # / Dev index
	inc	bl			;Next device index
	cmp	bl, MAX_PCI_DEVICE_NUM
	jbe	find_dev_dev_loop	;Br if more devices for this bus

	stc				;Indicate device not found

find_dev_found:
	pop	di
	pop	si
	pop	bp
	pop	ecx
~
	ret
smi_pci_find_device	endp




ifdef DOS_DEBUG

refresh_port	equ 61h

pm_fixed_delay	proc near
	push	ax
fixed_delay_1:
	in	al,refresh_port
	test	al,00010000b
	jz	fixed_delay_1
	dec	cx
	jz	fixed_delay_2
fixed_delay_3:
	in	al,refresh_port
	test	al,00010000b
	jnz	fixed_delay_3
	dec	cx
	jnz	fixed_delay_1
fixed_delay_2:
	pop	ax
	ret
	ret
pm_fixed_delay	endp


write_kb_cntlr_data	proc near
	ret
write_kb_cntlr_data	endp


wrt_kb_output_buf_cmd	proc near
	ret
wrt_kb_output_buf_cmd	endp


endif

	assume	ds:nothing
	assume	es:nothing
	assume	cs:nothing

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


