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
; $Header: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/mppost.asm 2     9/16/97 11:22a Juand $
;
; $Revision: 2 $
;
; $Date: 9/16/97 11:22a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/OEM/GENERIC/630/Intel/440BX/Desktop CR/OEMPORT/mppost.asm $
; 
; 2     9/16/97 11:22a Juand
; Fixed Int15 routing in the MPTable
; Added PIIX4 equates
;
; 1     9/15/97 5:56p Juand
;
; 1     9/11/97 6:41p Juand
;
; 1     6/05/97 12:42p Debkumar
;
; 1     1/31/97 1:15p Debkumar
; New files for 62700.
;
; 1     1/13/97 2:22p Debkumar
; New file for 6.27.00.
;
; 1     1/02/97 11:39a Debkumar
;
; 3     12/30/96 2:36p Debkumar
; Version 6.26.02
;
; 2     9/03/96 5:15p Mandal
; 6.26 for USA
;
; 1     6/17/96 2:35p Mandal
;
; 1     3/22/96 2:34p Mandal
; MP source added to source safe.
;
;*****************************************************************;
	include		mptable.equ
	include		mptable.inc
	include		mptable.mac
	include		makeflag.equ
	include		piix4.equ

;*****************************************************************;
;
;	MPPOST.ASM
;
;	This file contains porting hooks for creating
;	MultiProcessing table entries.
;
; The following things must be done to port this file to a particular
; chipset:
;
; 1) Add an equate file to the include section to define the chipset
; register equates.  Specifically, the equates are needed for the ISA
; bridge registers for the PIRQ Interrupt Route Control Registers (usually
; at offset 60h - 63h in the ISA bridge's PCI config space).
;
; 2) Modify the "secondary_ide" interrupt INTIN# value in the
; "create_io_interrupt_entries" function.  It is currently set to
; route the secondary IDE to INTIN #20 from IRQ #15.
;
; 3) Determine if EXTSMI# signal is routed to an INTIN# line on the I/O
; APIC.  The "create_io_interrupt_entries" function currently has this
; interrupt type routed to INTIN #23 on the I/O APIC.  If this is different,
; then the code should be changed to reflect the different interrupt used.
;
; 4) The table "apic_intin_table" must be modified to match the hardware
; routing of the I/O APIC INTIN# lines above the standard INTIN#0 thru
; INTIN#15 (ISA interrupts).  This table is arranged so that the first
; entry corresponds to the PIRQ0, second to PIRQ1, etc.  In the released
; file, INTIN#16 was tied to PIRQ0, INTIN#17 to PIRQ1, INTIN#18 to PIRQ2,
; and INTIN#19 to PIRQ3.
;
; 5) In the "map_irq_to_intin" function, there are two constants that are
; used to represent the register addresses of the PCI to ISA Bridge's PIRQ
; registers (offset 60h - 63h).  These are hardware dependent upon the PCI
; configuration space (PCI device number) of the PCI-to-ISA Bridge.  Replace
; the equates below (PCI_ISA_DEV_FUNC, PIRQ0_REGISTER, PIRQ3_REGISTER) with
; appropriate values.
;
	PCI_ISA_DEV_FUNC	equ	INTEL_PIIX4_DEV_FUNC
	PIRQ0_REGISTER		equ	IPIIX4_REG_PIRQ_RC0	;Reg. 60h
	PIRQ3_REGISTER		equ	IPIIX4_REG_PIRQ_RC3	;Reg 63h

cgroup  group   _text
_text   segment word    public  USE16   'CODE'
	assume  cs:cgroup

.486p

;-------------------------------;
; CREATE_IO_INTERRUPT_ENTRIES	;
;-------------------------------;
;	Description:		This routine decides interrupt routing to I/O APICs.
;	Input:			ES:DI =	Pointer in MP table where entry needs to be made
;	Output:			ES:DI = Pointer in MP table after entry completion
;	Stack:			Available
;	Registers destroyed:	EAX, BX, CX, DX
;-------------------------------;
	extrn	get_max_pci_bus_number:near
	public	create_io_interrupt_entries
create_io_interrupt_entries	proc	near
	mov	bl,0			; start with INTIN #0
count_interrupts:
	push	bx
;
; Interrupt is owned by ISA (not owned by PCI)
;
	call	get_max_pci_bus_number
	inc	cl			; point to ISA bus
	mov	bh,cl			; bh has source bus number
	mov	cl,bl			; INITIN same as IRQ
	cmp	bl,2			; except INITN2
	jne	ISA_IRQ_valid
	xor	bl,bl			; IRQ 0 -> INITIN 2
ISA_IRQ_valid:
;if MKF_INC_EISA
;else
;	cmp	bl,15			; INTEL has Sec IDE routed to INTIN #20
;	jne	not_sec_ide
;	mov	cl,20
;not_sec_ide:
;endif
	mov	ax,BUS_DEFAULT_TRIGGER OR BUS_DEFAULT_POLARITY
	call	add_interrupt
next_interrupt:
	pop	bx
	inc	bl			; Next INTIN pin
	cmp	bl,15			; first 15 INITIN# interrupts
	jbe	count_interrupts
;
; Next we have to route any existing PCI interrupts.  Basically, the INTIN#
; entry in the MP Table is made if there are one or more PCI slot devices
; connected to that APIC interrupt pin.  This determination is made by
; reading each bus/device/function to see if there is a valid device there,
; then reading the interrupt line and pin register. Then using that info,
; comparing to see which PIRQx register the IRQ is routed to.  The matching
; INTIN# is determined from the "apic_intin_table" defined below.  If the
; PIRQx matches and the INTIN# matches, then an entry is made.
;
if MKF_EXTENDED_APIC
count_pci_interrupts:
	push	bx
	call	add_pci_interrupt	; If interrupt owned by PCI ..
	pop	bx			; .. then entry was added
	inc	bl
	cmp	bl,22			; check up to 22 INTIN#'s
	jbe	count_pci_interrupts
;
; Finally, we have to add the interrupt for SMI.  Intel recommends that
; this be connected to INTIN#23 of the first installed APIC.  If this is
; different on the OEM motherboard design, then the appropriate change
; must be made.
;
; BL = source bus IRQ (ignored, set to zero)
; BH = bus number (interrupt is owned by the ISA bus)
; CL = INTIN# (default to 23)
;
	xor	bl,bl			; source bus IRQ
	call	get_max_pci_bus_number	; number of PCI busses
	inc	cl			; add 1 to point to ISA bus
	mov	bh,cl
	mov	cl,23			; SMI INTIN#
	mov	ax,BUS_DEFAULT_TRIGGER OR BUS_DEFAULT_POLARITY
	call	add_interrupt
endif
create_io_interrupt_exit:
	ret
create_io_interrupt_entries	endp

if MKF_EXTENDED_APIC
;-------------------------------;
; ADD_PCI_INTERRUPT		;
;-------------------------------;
;	Description:		This routine checks if the interrupt is routed to PCI
;				bus and makes corresponding interrupt entries.
;	Input:			BL = 	INTIN on I/O APIC
;				ES:DI =	Pointer to end of MP table
;	Output:			CY = 1	Interrupt not owned by PCI
;				CY = 0	Interrupt owned by PCI
;				ES:DI =	Pointer to end of MP table
;	Stack:			Available
;	Registers destroyed:	EAX, DX, SI
;-------------------------------;
add_pci_interrupt	proc	near
	push	bx				; save important registers
	push	cx
	push	di
	mov	si,di				; si = di = table pointer
	mov	dh,bl				; dh = bl = INTIN number
	call	get_max_pci_bus_number
	mov	bh,cl				; bh = bus number of last PCI bus
count_bus_numbers:
	mov	bl,01fh				; maximum possible device number on a bus
count_device_numbers:
	push	bx				; save bx
	shl	bl,3				; device number in bits [7:3]
	mov	di,PCI_REG_VENDID
	extrn	read_pci_cfg_word:near		; returns word in CX
	call	read_pci_cfg_word		; returns word in CX
	cmp	cx,0ffffh			; Is device present?
	je	skip_device			; no... skip_device
	xor	dl,dl				; assume single function
						; dl is function counter
	mov	di,PCI_REG_HEADER_TYPE
	call	read_pci_cfg_word		; returns word in CX
	test	cl,MULTI_FUNC_BIT		; multi-function device?
	jz	count_function_numbers		; no...
	mov	dl,7				; check all 7 possible functions
count_function_numbers:
	and	bl,0f8h				; zero out function part of bl
	or	bl,dl				; BL = (device number shl 3) or (function number)
	mov	di,PCI_REG_VENDID
	call	read_pci_cfg_word		; returns word in CX
	cmp	cx,0ffffh			; is valid function?
	je	skip_function			; no... skip function
;
; Valid device here...
;
;	BL - (device num shl 3) or (func num)
;	BH - bus number
;
	mov	di,PCI_REG_INT_LINE
	call	read_pci_cfg_word		; returns IRQ in cl, ch is INTA,B,C,D
;
; Take the IRQ from this device, and see if it matches the INTIN# passed
; into this function.
;
;	dh has INTIN#
;	cl has IRQ from intline register
;
	call	map_irq_to_intin
	jc	skip_function
;
;	cl has INTIN# to add
;	ch has INTA/B/C/D as 1/2/3/4
;	bl has device number shl 3
;	bh has bus number
;
	mov	di,si				; di has table pointer
	dec	ch				; make PCI interrupt 0-based
	push	bx
	and	bl,0f8h
	shr	bl,1				; bl has device number shl 2
	or	bl,ch				; bl has source bus IRQ
	mov	ax,BUS_ACTIVE_LOW OR BUS_LEVEL_TRIGGER
	call	add_interrupt
	pop	bx
	mov	si,di				; si has table pointer
skip_function:
	dec	dl				; next function
	jns	count_function_numbers
skip_device:
	pop	bx
	dec	bl				; next device
	jns	count_device_numbers
	dec	bh				; next bus
	jns	count_bus_numbers
	pop	di					; restore registers
	pop	cx
	pop	bx
	cmp	si,di				; did we add a entry (si > di)?
	jne	PCI_interrupt_added		; table pointer did not change
	stc
	ret
PCI_interrupt_added:
	mov	di,si				; restore table pointer from si
	clc
	ret
add_pci_interrupt	endp
;-------------------------------;
; MAP_IRQ_TO_INTIN		;
;-------------------------------;
;	Description:		This routine takes the IRQ that is assigned to the
;				PCI device, and determines which PIRQ register value
;				matches.  The routing to the correct I/O APIC INTIN#
;				is done through the apic_intin_table.
;	Input:			CL - IRQ routed to PCI device
;				DH - INTIN#
;	Output:			CL - INTIN# to be added to MP Table
;				CY - SET, don't create MP entry
;				CY - CLR, ok to create MP entry
;	Stack:			Available
;	Registers destroyed:	CL, AL
;-------------------------------;
;
; I\O APIC PCI INTIN# Routing Table (this table must be modified to
; reflect the actual hardware design.
;
apic_intin_table:
	db	16	; INTIN# number for PIRQ0 (60H)
	db	17	; INTIN# number for PIRQ1 (61H)
	db	18	; INTIN# number for PIRQ2 (62H)
	db	19	; INTIN# number for PIRQ3 (63H)
map_irq_to_intin	proc	near
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	mov	ch,cl			; save IRQ away for later
	mov	bx,PCI_ISA_DEV_FUNC
	mov	di,PIRQ0_REGISTER
	mov	si,offset apic_intin_table
miti_00:
	extrn	read_pci_cfg_byte:near	; get PIRQx value
	call	read_pci_cfg_byte	; get PIRQx value
	lodsb	cs:[si]			; get INTIN# corresponding to PIRQx
	cmp	ch,cl			; does the IRQ match this PIRQ?
	jne	short miti_next_pirq	; jump if not
	cmp	dh,al			; does the INTIN# match?
	je	short miti_intin_found	; jump if so
miti_next_pirq:
	inc	di			; point to next PIRQx
	cmp	di,PIRQ3_REGISTER	; checked all PIRQs yet?
	jbe	short miti_00		; jump if not
	stc				; indicate failure ..
	jmp	short @F		; .. and return
miti_intin_found:
	clc				; indicate success ..
@@:
	pop	di
	pop	si
	pop	dx
	pop	cx
	mov	cl,al			; get INTIN#
	pop	bx
	ret			; .. and return
map_irq_to_intin	endp
endif
;-------------------------------;
; ADD_INTERRUPT			;
;-------------------------------;
;	Description:		This routine creates the actual interrupt table entry.
;	Input:			AX =	Interrupt Properties
;				BL = 	Source bus IRQ
;				BH = 	Source bus number
;				CL =	Destination INTIN on I/O APIC
;				ES:DI =	Pointer in MP table where entry needs to be made
;	Output:			ES:DI = Pointer in MP table after entry completion
;	Stack:			Available
;	Registers destroyed:	EAX
;-------------------------------;
add_interrupt	proc	near
	push	ax				; save the interrupt properties
	mov	ax,INTERRUPT_ENTRY_TYPE		; interrupt entry type
	stosb
;
; First we need to decide which typr of interrupt it is.  If it is
; INTIN #0, it is an EXTINT_TYPE, if it is INTIN #23, it is an SMI_TYPE,
; otherwise it is an INTR_TYPE.
;
	mov	ax,INTR_TYPE			; default to INTR type
	or	cl,cl				; is it INTIN #0?
	jnz	check_smi_intr			; jump if not
	mov	ax,EXTINT_TYPE			; EXTINT type interrupt
	jmp	@F
check_smi_intr:
	cmp	cl,23				; is it INTIN #23?
	jnz	@F				; jump if not
	mov	ax,SMI_TYPE			; default to SMI type
@@:	stosb
;
; If the interrupt is the RTC (IRQ8) the modes are EDGE and HIGH.
;
	pop	ax				; restore interrupt properties
	cmp	cl,8				; is it IRQ8?
	jnz	short @F			; jump if not
	mov	ax,BUS_EDGE_TRIGGER OR BUS_ACTIVE_HIGH
@@:	stosw
	mov	al,bh				; bus number
	stosb
	mov	al,bl				; source bus IRQ
	stosb
	mov	al,DEFAULT_IO_APIC_ID		; destination IO APIC
	stosb
	mov	al,cl				; destination INTIN
	stosb
	inc	word ptr es:[MP_Header.Entry_Count]	; increment number of entries
	ret
add_interrupt	endp
;-------------------------------;
; PROCESS_OEM_ID_ENTRY		;
;-------------------------------;
;	Description:		This routine makes the OEM entry in MP table header.
;	Input:			ES:DI = Pointer in MP table where entry needs to be made
;	Output:			ES:DI = Pointer in MP table after entry completion
;	Stack:			Available
;	Registers destroyed:    EAX
;-------------------------------;
process_OEM_ID_entry	proc	near
;
; To create an OEM ID, use the following syntax:
;
;      	Set_OEM_ID	<string>	where string is upto 8 characters
;
;	For example,
;			Set_OEM_ID <AMI>
;
; To use OEM ID from makefile use the following syntax:
;
;	Set_OEM_ID	%OEM
;
; To create a blank OEM ID, either use makefile and leave OEM ID blank
; in makefile or use the following:
;
;	Set_OEM_ID
;
;-------------------------------;
	Set_OEM_ID	%OEM		; pick OEM ID from makefile
	ret
process_OEM_ID_entry	endp
;-------------------------------;
; PROCESS_PRODUCT_ID_ENTRY	;
;-------------------------------;
;	Description:		This routine makes the product entry in MP table header.
;	Input:			ES:DI = Pointer in MP table where entry needs to be made
;	Output:			ES:DI = Pointer in MP table after entry completion
;	Stack:			Available
;	Registers destroyed:    EAX
;-------------------------------;
process_product_ID_entry	proc	near
;
; To create a product ID, use the following syntax:
;
;      	Set_Product_ID	<string>	where string is upto 8 characters
;
;	For example,
;			Set_Product_ID <VOYAGER>
;
; To use product ID from makefile use the following syntax:
;
;	Set_Product_ID	%PROD
;
; To create a blank product ID, either use makefile and leave product ID blank
; in makefile or use the following:
;
;	Set_Product_ID
;
;-------------------------------;
	Set_Product_ID	%PROD		; pick Product ID from makefile
	ret
process_product_ID_entry	endp

;-------------------------------;
; PROCESS_OEM_TABLE_ENTRY	;
;-------------------------------;
;	Description:		This routine makes the entry for a OEM table (if present)
;				in the MP header.
;	Input:			ES:DI = Pointer in MP table where entry needs to be made
;	Output:			ES:DI = Pointer in MP table after entry completion
;	Stack:			Available
;	Registers destroyed:	EAX
;-------------------------------;
process_OEM_table_entry	proc	near
;
; To declare an OEM Table, use the following syntax:
;
;	Declare_OEM_Table 	Pointer_in_flat_mode, Table_size_in_bytes
;
;	For example, for a 100h byte table at F000:4000, use:
;
;		Declare_OEM_Table 	0F4000h, 100h
;
; If no table is present, just use:
;
;	Declare_OEM_Table
;
;-------------------------------;
	Declare_OEM_Table
	ret
process_OEM_table_entry	endp

;-------------------------------;
; GET_LOCAL_APIC_ADDRESS	;
;-------------------------------;
;	Description:		This routine will return the CPU's local apic address
;	Input:			None
;	Output:			EAX = 	Local APIC Address
;	Stack:			Available
;	Registers destroyed:	EAX
;-------------------------------;
get_local_apic_address	proc	near
	mov	eax,DEFAULT_LOCAL_APIC_ADDRESS		; Default LOCAL APIC Address
	ret
get_local_apic_address	endp

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
_text   ends
	end
