	page	,132
	title .		PCI Multiple Host Bridge Hooks
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
	include dim.dat
;---------------------------------------;

	public pci_host_bridge_count
	public pci_host_bridge_table
	public compat_opb_busdev_num

	public pci_hb_set_sec_bus_num
	public pci_hb_set_sub_bus_num
	public pci_hb_program_limits
	public pci_hb_program_compat_limits
	public pci_hb_enable_vga

;---------------------------------------;

cgroup	group	_text
_text 	segment word public 'CODE'
	assume	cs:cgroup
.386


;------------------------------------------------------------------------------;
; Note: This code contains examples of how to implement a system with two host ;
; bridges on the Intel Orion chipset.                                          ;
;------------------------------------------------------------------------------;

pci_host_bridge_count	label byte
	db	2	;Number of PCI host bridges in system


; This table should have one entry (two bytes per entry) for each PCI host
; bridge that is present in the system.  If the system has a host bridge
; that operates in compatibility mode, then put that bridge at the top of
; the table.

pci_host_bridge_table	label byte
compat_opb_busdev_num	label word

;          Device Number SHL 3 +
;             Function Number       Bus Number
;          ---------------------    ----------
	db          0C8h,                00h
	db          0D0h,                00h


;---------------------------------------;
; pci_hb_set_sec_bus_num                ;
;---------------------------------------;--------------------------------------;
; This function should write the given value to a host bridge's Secondary Bus  ;
; Number register.  This register controls the PCI bus number of the bus that  ;
; is directly behind the host bridge.                                          ;
;                                                                              ;
; Input: BH = Bus number used to access host bridge's config registers (this   ;
;             value will be from one of the entries in the                     ;
;             pci_host_bridge_table)                                           ;
;        BL = Device/Function number used to access host bridge's              ;
;             config registers (this value will be from one of the entries in  ;
;             the pci_host_bridge_table)                                       ;
;        AL = Bus number to write to host bridge's Secondary Bus Number        ;
;             register                                                         ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_hb_set_sec_bus_num	proc near
	pusha

	mov	di, opb_bus_number_index
	mov	cl, al
	mov	ah, RT_PCI_WRITE_CFG_BYTE
	CALL_RT_FUNCTION		;Write CL to device BH/BL, register DI

	popa
	ret
pci_hb_set_sec_bus_num	endp


;---------------------------------------;
; pci_hb_set_sub_bus_num                ;
;---------------------------------------;--------------------------------------;
; This function should write the given value to a host bridge's Subordinate Bus;
; Number register.  This register is used to set the bus number of the last    ;
; hierarchical PCI bus behind the host bridge.                                 ;
;                                                                              ;
; Input: BH = Bus number used to access host bridge's config registers (this   ;
;             value will be from one of the entries in the                     ;
;             pci_host_bridge_table)                                           ;
;        BL = Device/Function number used to access host bridge's              ;
;             config registers (this value will be from one of the entries in  ;
;             the pci_host_bridge_table)                                       ;
;        AL = Bus number to write to host bridge's Subordinate Bus Number      ;
;             register                                                         ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_hb_set_sub_bus_num	proc near
	pusha

	mov	di, opb_sub_bus_number_index
	mov	cl, al
	mov	ah, RT_PCI_WRITE_CFG_BYTE
	CALL_RT_FUNCTION		;Write CL to device BH/BL, register DI

	popa
	ret
pci_hb_set_sub_bus_num	endp


;---------------------------------------;
; pci_hb_program_limits                 ;
;---------------------------------------;--------------------------------------;
; This function programs a bridge chip's I/O, memory, and prefetchable memory  ;
; decode ranges with values from the PCIBusTable.                              ;
;                                                                              ;
; Input: SI = Pointer to bus's entry in PCIBusTable                            ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_hb_program_limits	proc near
	pushad

	mov	bl, (pci_bus_entry ptr [si]).pbe_parent_bus_dev
	mov	bh, (pci_bus_entry ptr [si]).pbe_parent_bus

	cmp	bx, cgroup:compat_opb_busdev_num
	jz	skip_limit_prog		;Br if on compat OPB

	;Set I/O base address

	mov	dx, (pci_bus_entry ptr [si]).pbe_io_start
	mov	cx, (pci_bus_entry ptr [si]).pbe_io_size
	jcxz	skip_io_region		;Br if no I/O region to program
	add	cx, dx			;CX = End address+1 of I/O region
	dec	cx			;CX = End address of I/O region
	and	cx, 0FFF0h		;Low 4 bits of end address are reserved
	shl	ecx, 16			;Upper word of ECX = end addr of I/O
	mov	cx, dx			;CX = Start address of I/O region
	and	cx, 0FFF0h		;Bits 3:1 are reserved
	or	cl, 01h			;Set bit 0, to enable I/O region decode
	mov	di, opb_io_space_range_1_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI
	mov	di, opb_io_space_range_2_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI

skip_io_region:

	;Set memory end address

	mov	edx, (pci_bus_entry ptr [si]).pbe_mem_start
	mov	ecx, (pci_bus_entry ptr [si]).pbe_mem_size
	jecxz	skip_mem_region		;Br if no mem region to program
	add	ecx, edx		;ECX = End address+1 of mem region
	dec	ecx			;ECX = End address of mem region
	shr	ecx, 20			;Align address bit 20 with register bit 0
	mov	di, opb_high_mem_gap_end_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI

	;Set memory base address (all OPBs)

	mov	ecx, edx		;ECX = Start address of mem region
	shr	ecx, 20			;Align address bit 20 with register bit 0
	bts	ecx, 31			;Set bit 31 to enable mem region decode
	mov	di, opb_high_mem_gap_start_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI

skip_mem_region:

	;Set set prefetchable memory (frame buffer) base address
	mov	ecx, (pci_bus_entry ptr [si]).pbe_pfmem_start

	;Set set prefetchable memory (frame buffer) size
	mov	ecx, (pci_bus_entry ptr [si]).pbe_pfmem_size

skip_limit_prog:

	popad
	ret
pci_hb_program_limits	endp


;---------------------------------------;
; pci_hb_program_compat_limits          ;
;---------------------------------------;--------------------------------------;
; This function should be used to program the compatibility host bridge so that;
; it does not decode I/O and memory used by other host bridges.                ;
;                                                                              ;
; Input: SI = Pointer to bus's entry in PCIBusTable                            ;
;        DI = Pointer PCIBusTable entry for entire PCI system                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_hb_program_compat_limits	proc near
	pushad

	mov	bl, (pci_bus_entry ptr [si]).pbe_parent_bus_dev
	mov	bh, (pci_bus_entry ptr [si]).pbe_parent_bus

	;Program the compatibility OPB to not decode the region of I/O space
	;that is being used by all other OPBs.

	mov	dx, (pci_bus_entry ptr [si]).pbe_io_start
	add	dx, (pci_bus_entry ptr [si]).pbe_io_size ;DX = start of I/O used by non compat host bridges
	mov	cx, (pci_bus_entry ptr [di]).pbe_io_size
	sub	cx, (pci_bus_entry ptr [si]).pbe_io_size ;CX = size of I/O used by non compat host bridges
	jcxz	skip_cio_region		;Br if no I/O region to program
	add	cx, dx			;CX = End address+1 of I/O region
	dec	cx			;CX = End address of I/O region
	and	cx, 0FFF0h		;Low 4 bits of end address are reserved
	shl	ecx, 16			;Upper word of ECX = end addr of I/O
	mov	cx, dx			;CX = Start address of I/O region
	and	cx, 0FFF0h		;Bits 3:1 are reserved
					;Clear bit 0, to disable I/O region decode
	push	di
	mov	di, opb_io_space_range_1_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI
	mov	di, opb_io_space_range_2_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI
	pop	di

skip_cio_region:

	;Program the compatibility OPB to not decode the region of mem space
	;that is being used by all other OPBs.

	;Set memory end address

	mov	edx, (pci_bus_entry ptr [si]).pbe_mem_start
	add	edx, (pci_bus_entry ptr [si]).pbe_mem_size ;EDX = start of mem used by non compat host bridges
	mov	ecx, (pci_bus_entry ptr [di]).pbe_mem_size
	sub	ecx, (pci_bus_entry ptr [si]).pbe_mem_size ;ECX = size of mem used by non compat host bridges
	jecxz	skip_cmem_region	;Br if no mem region to program
	add	ecx, edx		;ECX = End address+1 of mem region
	dec	ecx			;ECX = End address of mem region
	shr	ecx, 20			;Align address bit 20 with register bit 0
	mov	di, opb_high_mem_gap_end_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI

	;Set memory base address

	mov	ecx, edx		;ECX = Start address of mem region
	shr	ecx, 20			;Align address bit 20 with register bit 0
					;Bit 31 is clear to disable mem region decode
	mov	di, opb_high_mem_gap_start_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to device BH/BL, register DI

skip_cmem_region:

	popad
	ret
pci_hb_program_compat_limits	endp


;---------------------------------------;
; pci_hb_enable_vga                     ;
;---------------------------------------;--------------------------------------;
; This function should enable the VGA decode feature of the host bridge.  The  ;
; bridge should be programmed to positively decode the memory region           ;
; A0000-BFFFF and I/O ports 3B4-3B5, 3BA, 3C0-3CA, 3CC, 3CE-3CF, 3D4-3D5,      ;
; and 3DA.                                                                     ;
;                                                                              ;
; Input: BH = Bus number used to access host bridge's config registers (this   ;
;             value will be from one of the entries in the                     ;
;             pci_host_bridge_table)                                           ;
;        BL = Device/Function number used to access host bridge's              ;
;             config registers (this value will be from one of the entries in  ;
;             the pci_host_bridge_table)                                       ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
pci_hb_enable_vga	proc near
	pusha

	;If the VGA is behind the compatibility OPB, then there is
	;nothing to do.

	cmp	bx, cgroup:compat_opb_busdev_num
	je	enable_vga_done		;Br if VGA is behind compat OPB

	;The VGA is behind a non-compatibility OPB so first we have to turn
	;off the VGA memory and I/O decoding in the compat OPB.

	push	bx
	mov	bx, cgroup:compat_opb_busdev_num

	mov	cl, 0			;Turn off A0000-BFFFF decode in compat OPB
	mov	di, opb_video_buffer_index
	mov	ah, RT_PCI_WRITE_CFG_BYTE
	CALL_RT_FUNCTION

	mov	ecx, 03D003B0h		;Turn off 3B0-3DF decode in compat OPB
	mov	di, opb_io_space_range_2_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION

	pop	bx

	;Now we have to turn on the VGA memory and I/O decode on the
	;noncompatibility OPB which has the VGA behind it.

	mov	cl, 00000010b		;Turn on A0000-BFFFF decode in noncompat OPB
	mov	di, opb_video_buffer_index
	mov	ah, RT_PCI_WRITE_CFG_BYTE
	CALL_RT_FUNCTION

	mov	ecx, 03D003B1h		;Turn on 3B0-3DF decode in noncompat OPB
	mov	di, opb_io_space_range_2_index
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION

enable_vga_done:
	popa
	ret
pci_hb_enable_vga	endp

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
