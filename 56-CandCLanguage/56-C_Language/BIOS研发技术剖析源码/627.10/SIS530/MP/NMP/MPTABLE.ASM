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
;
;	MPTABLE.ASM
;
;	This file contains the main module for creating
;	MultiProcessing table entries.
;
;*****************************************************************;
	include		mptable.equ
	include		mptable.inc
	include		mptable.mac
	include		cpustruc.def
	include		makeflag.equ

cgroup  group   _text
_text   segment para    public  USE16   'CODE'
	assume	cs:cgroup
.486p
;
;	Chipset routines external references
;
	extern	process_OEM_ID_entry:near
	extern	process_product_ID_entry:near
	extern	process_OEM_table_entry:near
	extern	get_local_apic_address:near
	extern	create_io_interrupt_entries:near
;-----------------------------------------------------------------------;
;			JMP TABLE OF MPS MODULE				;
;-----------------------------------------------------------------------;
	jmp	short generate_mp_table	; offset 0 = generate MP table
	nop				; make sure it takes 3 bytes
;-----------------------------------------------------------------------;
;			GENERATE_MP_TABLE				;
;-----------------------------------------------------------------------;
; check point : AB							;
; this routine is called from GS1.ASM to build MP Configuration Table.	;
; this routine builds the MP Configuration Table in lower RAM 50:0.	;
; input :								;
;	none								;
; output:								;
;	DS:SI	ptr to start of MP Configuration Table in RAM		;
;	CX	length of MP Configuration Table (in Byte)		;
;		= 0000 -> MP table was not built			;
;		<>0000 -> MP table was built				;
; register destroyed : ALL except FS GS				 	;
;-----------------------------------------------------------------------;
generate_mp_table:
	call	go_to_flat_mode_stack_far
;
; First check for APIC enabled, if it is not, we don't really have
; any reason to create an MP table now do we...
;
	mov	cx,0000h		; CX = 0000 MP table not built
	cmp	ds:dword ptr [0fee00030h],0FFFFFFFFh; local APIC present ?
	jz	short gmt_00		; local APIC not present

	call	search_for_ioapic	; is there an IO APIC?
	push	0050h
	pop	es			; create MP table at ES:0000 (50:0)
	jnz	short gmt_00		; jump if not
;
; First, we create MP configuration table in lower ram and then copy it
; to F000 shadow RAM and then update MP Floating Point structure properly
; depending on where we put the MP configuration table in F000 shadow RAM
; update the MP Floating Point structure checksum
;
        call    create_mps_table
; CX = length of MP Configuration table
gmt_00:
	push	es
	push	cx
	call    comeback_from_flat_mode_stack_far
	pop	cx
	pop	ds
	xor	si,si			; DS:SI = ptr to start of MP table in RAM
	retf
;-----------------------------------------------------------------------;

COMMENT~
*****************************************************************************************

       SEARCH_FOR_IOAPIC


       Description:            This procedure will determine if there is an
       			       IO APIC in the system, and will ruturn the
			       result in the carry flag.

       Input:                  Already in big real mode with DS,ES set to 00 with 4GB limit

       Output:                 ZF = 1, IO APIC is found
       			       ZF = 0, no IO APIC found

       Stack:                  Available

       Registers destroyed:    NONE

*****************************************************************************************
~
search_for_ioapic	proc	near
	pushad

	mov	esi,DEFAULT_IO_APIC_BASE_ADDRESS
	xor	eax,eax		; five bytes of code to load eax ..
	inc	eax		; .. with a 1 (IOAPIC Version Register number)
	mov	[esi], eax
	mov	eax,[esi+IO_APIC_REGISTER_WINDOW]
	cmp	al,011h			; is there an I/O APIC in the system?
					; sets ZF if so, else resets ZF
	popad
	ret
search_for_ioapic	endp

COMMENT~
*****************************************************************************************

       CREATE_MPS_TABLE


       Description:            This procedure will create the MultiProcessor Specification
                               table.

       Input:                  ES =    Pointer to table destination
                                       Table will be built at ES:0
                               DS =    Pointer to 64K scratch RAM segement

       Output:                 CX =    Length of MP Configuration Table in Byte
       			       ES:0000 Ptr to start of MP Configuration Table

       Stack:                  Available

       Registers destroyed:    All general purpose


*****************************************************************************************
~
create_mps_table	proc	near

	cld					; Clear direction flag
	xor	di,di				; ES:DI pointer initialization

	call	create_table_header
	call	create_boot_proc_entry

	push	di			; save MP table pointer
	call	get_processor_info_far	; get number of CPUs (di destroyed)
	pop	di			; restore MP table pointer
	cmp	cl,2			; if number of processors < 2 ..
	jb	skip_app_entries	; .. no AP entries, don't create them
	call	create_app_proc_entries	; there must be at least one AP CPU

skip_app_entries:
	call	create_bus_entries
	call	create_io_apic_entries
	call	create_io_interrupt_entries
	call	create_local_interrupt_entries
	call	checksum_mp_table	; CX = length of MP Table
	ret
	
create_mps_table	endp


COMMENT~
*****************************************************************************************

       CREATE_TABLE_HEADER


       Description:		This routine will create the table header



       Input:                  ES:DI =	Pointer to table start

       Output:                 ES:DI = Pointer to table end

       Stack:                  Available

       Registers destroyed:    EAX, CX


*****************************************************************************************
~
create_table_header	proc	near


	mov	eax,PCMP_SIGNATURE_DWORD		; get the signature in DWORD form
	stosd						; write the MP signature

	add	di,SIZEOF MP_Header.Table_Length	; skip over table size

	mov	al,MP_SPEC_REVISION			; MPS revision
	stosb						; MP Spec revision
	add	di,SIZEOF MP_Header.CheckSum		; skip over checksum

	call	process_OEM_ID_entry			; OEM specific calls
	call	process_product_ID_entry
	call	process_OEM_table_entry
	
	xor	ax,ax
	stosw						; zero out the number of entries

	call	get_local_apic_address			; returns local apic address in eax
	stosd						; write the address
	
	mov	cx,SIZEOF MP_Header.reserved		; Zero out reserved entries
	xor	al,al
@@:	stosb
	loop	@B	
	
	ret
	
create_table_header	endp

COMMENT~
*****************************************************************************************

       CREATE_BOOT_PROC_ENTRY


       Description:            This procedure will fill the MP table in with
                               the BSP's information.

       Input:                  ES:DI = Pointer in MP table where entry needs to be made

       Output:                 ES:DI = Pointer in MP table after entry completion

       Stack:                  Available

       Registers Destroyed:

*****************************************************************************************
~

create_boot_proc_entry	proc	near
	push	ds

	push	edi			; not going to use AP info here
	call	get_processor_info_far
	pop	edi			; restore pointer to MP table

	mov	ds,si			; BSP struct's segment in lower 16 bits
	shr	esi,16			; offset in upper 16 bits

	mov	al,PROCESSOR_ENTRY_TYPE
	stosb				; create entry type

	mov	al,(CPUINFOSTRUC ptr ds:[si]).bCPUAPICID
	stosb				; CPU local APIC ID

	mov	al,(CPUINFOSTRUC ptr ds:[si]).bCPUAPICVer
	stosb				; CPU local APIC version

	mov	al,(BSP_CPU OR CPU_ENBLD)
	stosb				; CPU flags field

	mov	eax,(CPUINFOSTRUC ptr ds:[si]).dResetID
	stosd				; CPU processor ID

	mov	eax,(CPUINFOSTRUC ptr ds:[si]).dFeature
	stosd				; CPU Feature Flags

	mov	cx,SIZEOF Processor_entry.reserved	; zero out reserved entries
	xor	al,al
@@:	stosb
	loop	@B	

	inc	word ptr es:[MP_Header.Entry_Count]	; increment number of entries

	pop	ds
	ret
create_boot_proc_entry	endp



COMMENT~
*****************************************************************************************

       CREATE_APP_PROC_ENTRIES


       Description:            This procedure will fill the MP table in with
                               the Application Processor's information.  All
			       AP's that are found are done in this module

       Input:                  ES:DI = Pointer in MP table where entry needs to be made

       Output:                 ES:DI = Pointer in MP table after entry completion

       Stack:                  Available

       Registers Destroyed:

*****************************************************************************************
~

create_app_proc_entries	proc	near
	push	ds

	push	edi			; save MP table pointer
	call	get_processor_info_far
	mov	esi,edi			; get pointer into a register we can use
	pop	edi			; restore pointer to MP table
	movzx	cx,cl
	dec	cx			; only the number of AP's

;
; There may be more than one Application Processor, here we look for
; each one we find, and make an entry in the MP table.  If we got here
; at all, there is at least one AP.
;
	mov	ds,si			; AP struct's segment in lower 16 bits
	shr	esi,16			; offset in upper 16 bits
;
; At this point, DS is the segment of the CPU info structure, and SI
; is the offset of the AP processor info structure.
;
cape_00:
	push	cx			; number of AP's
	push	si			; save pointer to "next"
	inc	si
	inc	si			; point to the CPU info table

	mov	al,PROCESSOR_ENTRY_TYPE
	stosb				; create entry type

	mov	al,(CPUINFOSTRUC ptr ds:[si]).bCPUAPICID
	stosb				; CPU local APIC ID

	mov	al,(CPUINFOSTRUC ptr ds:[si]).bCPUAPICVer
	stosb				; CPU local APIC version

	mov	al,CPU_ENBLD
	stosb				; CPU flags field

	mov	eax,(CPUINFOSTRUC ptr ds:[si]).dResetID
	stosd				; CPU processor ID

	mov	eax,(CPUINFOSTRUC ptr ds:[si]).dFeature
	stosd				; CPU Feature Flags

	mov	cx,SIZEOF Processor_entry.reserved	; zero out reserved entries
	xor	al,al
@@:	stosb
	loop	@B	

	inc	word ptr es:[MP_Header.Entry_Count]	; increment number of entries

	pop	si			; get the pointer to next back
	mov	si,word ptr ds:[si]	; get next AP pointer
	pop	cx			; number of AP's
	loop	cape_00			; jump if more to add

cape_exit:
	pop	ds
	ret
create_app_proc_entries	endp

COMMENT~
*****************************************************************************************

       CREATE_BUS_ENTRIES


       Description:            This procedure will enumerate all buses.

                               PCI bus numbers will be assigned values as per the
                               actual PCI values.  Remaining values will go to ISA or EISA.



       Input:                  ES:DI = Pointer in MP table where entry needs to be made

       Output:                 ES:DI = Pointer in MP table after entry completion

       Stack:                  Available

       Registers destroyed:    EAX, BL, CX, SI


*****************************************************************************************
~

create_bus_entries	proc	near

	xor	bl,bl					; BX holds bus number to add

; Create PCI BUS entries
	call	get_max_pci_bus_number			; get max PCI bus (0-based) in CX
	inc	cx					; make it one based
@@:
	Declare_Bus	bl, PCI_BUS

	inc	bl					; increment bus number
	loop	@B	

	Declare_Bus	bl, ISA_BUS
	inc	bl

if MKF_INC_EISA
	Declare_Bus	bl, EISA_BUS
	inc	bl
endif
	ret
	
create_bus_entries	endp


COMMENT~
*****************************************************************************************

       CREATE_IO_APIC_ENTRIES


       Description:		This routine will create I/O APIC entries



       Input:                  ES:DI =	Pointer in MP table where entry needs to be made

       Output:                 ES:DI = Pointer in MP table after entry completion

       Stack:                  Available

       Registers destroyed:    EAX


*****************************************************************************************
~
create_io_apic_entries	proc	near

	Declare_IO_APIC DEFAULT_IO_APIC_BASE_ADDRESS, DEFAULT_IO_APIC_ID
	ret
	
create_io_apic_entries	endp

COMMENT~
*****************************************************************************************

       CREATE_LOCAL_INTERRUPT_ENTRIES


       Description:		This routine routes interrupts to CPU's local apic.



       Input:                  ES:DI =	Pointer in MP table where entry needs to be made

       Output:                 ES:DI = Pointer in MP table after entry completion

       Stack:                  Available

       Registers destroyed:    All general purpose


*****************************************************************************************
~
create_local_interrupt_entries	proc	near

; Route EXTINT to local APIC
	mov	ax,LOCAL_INTR_ENTRY_TYPE		; interrupt entry type
	stosb

	mov	ax,EXTINT_TYPE				; EXTINT type interrupt
	stosb	

	mov	ax,BUS_DEFAULT_TRIGGER OR BUS_DEFAULT_POLARITY
	stosw
	
	xor	ax,ax					; source bus number = N/A
	stosb						; write 0
	
	stosb						; source bus IRQ = N/A; write 0
	
	mov	ax,ALL_LOCAL_APICS			; destination APICs
	stosb				
	
	xor	ax,ax					; EXTINT -> LINTIN0
	stosb

	inc	word ptr es:[MP_Header.Entry_Count]	; increment number of entries
	
;
; Route NMI to local APIC
;
	mov	ax,LOCAL_INTR_ENTRY_TYPE		; interrupt entry type
	stosb

	mov	ax,NMI_TYPE				; NMI type interrupt
	stosb	

	mov	ax,BUS_DEFAULT_TRIGGER OR BUS_DEFAULT_POLARITY
	stosw
	
	xor	ax,ax					; source bus number = N/A
	stosb						; write 0
	
	stosb						; source bus IRQ = N/A; write 0
	
	mov	ax,ALL_LOCAL_APICS			; destination APICs
	stosb				
	
	mov	ax,1					; NMI -> LINTIN1
	stosb

	inc	word ptr es:[MP_Header.Entry_Count]	; increment number of entries
	
	ret
	
create_local_interrupt_entries	endp


COMMENT~
*****************************************************************************************

       CHECKSUM_MP_TABLE


       Description:            This routine checksums the MP table and stores its length
                               in the table header.



       Input:                  ES:DI = Pointer to end of MP table

       Output:                 CX = Length of MP table

       Stack:                  Available

       Registers destroyed:    AX, CX, SI, DI


*****************************************************************************************
~
checksum_mp_table	proc	near

	mov	word ptr es:[MP_Header.Table_Length],di	; store table length

	xor	ax,ax		; checksum
	mov	cx,di
	xor	si,si		
	
checksum_loop:
        lodsb	es:[si]
        add     ah,al
        loop    checksum_loop
        neg	ah

	mov	byte ptr es:[MP_Header.Checksum],ah	; store checksum
	mov	cx,di		; CX = length of MP table
	ret
	
checksum_mp_table	endp




COMMENT~
*****************************************************************************************

       GET_MAX_PCI_BUS_NUMBER


       Description:		This routine returns the maximum PCI bus number.



       Input:                  None

       Output:                 CX = 	Maximum PCI Bus number

       Stack:                  Available

       Registers destroyed:    CX


*****************************************************************************************
~
	public	get_max_pci_bus_number
get_max_pci_bus_number	proc	near

	push	ax
	push	bx
	push	edx
	
	xor	cx,cx
	mov	ax,0b101h
	int	1ah

	pop	edx
	pop	bx
	pop	ax
		
	ret
	
get_max_pci_bus_number	endp

COMMENT~
*****************************************************************************************

       READ_PCI_CFG_BYTE
       Description:	This routine reads a PCI config space byte

       Input:		BH =	Bus number
       			BL = 	(Device number SHL 3) or (Function number)
       			DI =	Register offset in device
       Output:		CL =	Config space byte
       Stack:		Available
       Registers destroyed:    CX
*****************************************************************************************
~
read_pci_cfg_byte	proc	near
	push	ax
	mov	ax,0b108h
	int	1ah
	pop	ax
	ret
read_pci_cfg_byte	endp


COMMENT~
*****************************************************************************************

       READ_PCI_CFG_WORD
       Description:		This routine reads a PCI config space word

       Input:		BH =	Bus number
       			BL = 	(Device number SHL 3) or (Function number)
       			DI =	Register offset in device
       Output:		CX =	Config space word
       Stack:		Available
       Registers destroyed:    CX
*****************************************************************************************
~
read_pci_cfg_word	proc	near
	push	ax
	mov	ax,0b109h
	int	1ah
	pop	ax
	ret
read_pci_cfg_word	endp
;-----------------------------------------------------------------------;
;			GET_PROCESSOR_INFO_FAR				;
;-----------------------------------------------------------------------;
get_processor_info_far:
	db	9ah			; GET_PROCESSOR_INFO at F000:EEC6
	dw	0eec6h
	dw	0f000h
	ret
;-----------------------------------------------------------------------;
;			GO_TO_FLAT_MODE_STACK_FAR			;
;-----------------------------------------------------------------------;
go_to_flat_mode_stack_far:
	db	9ah			; GO_TO_FLAT_MODE_STACK at F000:EEEA
	dw	0eeeah
	dw	0f000h
	ret
;-----------------------------------------------------------------------;
;		COMEBACK_FROM_FLAT_MODE_STACK_FAR			;
;-----------------------------------------------------------------------;
comeback_from_flat_mode_stack_far:
	db	9ah		; COMEBACK_FROM_FLAT_MODE_STACK at F000:EEED
	dw	0eeedh
	dw	0f000h
	ret
;-----------------------------------------------------------------------;
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
_text   ends
        end
