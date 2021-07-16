 	page	,132
	title .				Device Initializer Hooks
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
	include	setupequ.ext
	include sis530.equ
	include makeflag.equ
;---------------------------------------;

	public dih_sys_mem_shadow

;---------------------------------------;
; dih_scratch_data                      ;
;---------------------------------------;--------------------------------------;
; This is a 128 byte scratch data area which can be used by any of the hook    ;
; functions in this file.  This scratch area is in the _dimdata segment which  ;
; is an input (DS, ES) to all of the functions in this file.                   ;
;                                                                              ;
; NOTE: Do not assume that this scratch area is initialized or zeroed out.     ;
;       You must initialize this scratch area according your needs.  A good    ;
;       place to do any initialization is in dih_sys_func_0 since it is the    ;
;       first hook to be called.                                               ;
;       This data area is not used by any of the core routines.                ;
;                                                                              ;
;------------------------------------------------------------------------------;

	extrn dih_scratch_data: byte
	extrn dih_manual_ide_id: byte

;---------------------------------------;

	extrn SysStatus: dword
	extrn IsaStatus: dword
	extrn EisaStatus: dword
	extrn PnPStatus: dword
	extrn PciStatus: dword

	extrn OwnerWork: byte

	extrn FindDevID: dword
	extrn FindDevSerial: dword
	extrn FindDevLogID: dword
	extrn FindDevType: dword
	extrn FindDevTypeMask: dword
	extrn FindDevInitAll: byte
	extrn FindDevInitAllBoot: byte

	extrn PnPFoundDevCSN: byte
	extrn PnPFoundDevID: dword
	extrn PnPFoundDevSer: dword
	extrn PnPFoundDevLID: dword

	extrn FindDevIncDev: byte
	extrn FindDevIncBus: byte
	extrn PCICommandValue: word
	extrn PCIFoundDevID: dword
	extrn PCIFoundDevFunc: dword
	extrn PCIFoundDevBus: dword

	extrn EscdFuncNum: byte
	extrn EscdSlotNum: byte

	extrn PCIROMMinBase: dword
	extrn PCIROMMaxBase: dword
	extrn MaxPCIBusNumber:byte

	extrn ResMapStart: word
	extrn ResMapEnd:   word

;---------------------------------------;

cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.586p

;==============================================================================;
;                                                                              ;
;                   System Board Device Initializer Hooks                      ;
;                                                                              ;
;==============================================================================;

;---------------------------------------;
; dih_sys_mem_shadow                    ;
;---------------------------------------;--------------------------------------;
; This function sets a given region of memory to one of three states:          ;
;   - Read from ROM / Write to ROM (write goes nowhere)                        ;
;   - Read from RAM / Write to RAM                                             ;
;   - Read from RAM / Write to ROM (RAM is write protected)                    ;
;                                                                              ;
; Input:  DL = Block to check: 0=C000, 1=C400, 2=C800, 3=CC00                  ;
;                              4=D000, 5=D400, 6=D800, 7=DC00                  ;
;         AL = State to set memory region to:                                  ;
;                0: Read from ROM / Write to ROM (write goes nowhere)          ;
;                1: Read from RAM / Write to RAM                               ;
;                2: Read from RAM / Write to ROM (RAM is write protected)      ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_sys_mem_shadow	proc near
	pushad
	push	ax
	mov	bx, S530_BUS_NUM + S530_DEV_FUNC_NUM
	mov	di, 70h
	mov	ah, RT_PCI_READ_CFG_DWORD
	CALL_RT_FUNCTION
	pop	ax
	xor	dl,01h
	shl	dl,02h
	xchg	edx,ecx
	ror	edx,cl
	and	dl,NOT 0ah
	or	al,al
	jz	shadow_read_disable
	or	dl,08h
shadow_read_disable:
	cmp	al,1
	jnz	shadow_write_disable
	or	dl,02h
shadow_write_disable:
	rol	edx,cl
	xchg	edx,ecx
	mov	ah,RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION
	popad
	ret
dih_sys_mem_shadow	endp


;==============================================================================;
;                                                                              ;
;                      PCI Device Initializer Hooks                            ;
;                                                                              ;
;==============================================================================;

ifdef PCI

;---------------------------------------;
; dih_pci_prog_frame_buf                ;	MOVED TO OEMPDIM.ASM
;---------------------------------------;
; dih_pci_check_disabled                ;	MOVED TO OEMPDIM.ASM
;---------------------------------------;
;---------------------------------------;
; dih_pci_prot_dev_table                ;
;---------------------------------------;--------------------------------------;
; This table contains the vendor ID and device ID of the PCI devices which     ;
; should be protected from configuring by the Core PCI configuarion routine.   ;
; For example, on-board PCI chipset.                                           ;
;------------------------------------------------------------------------------;
	public dih_pci_prot_dev_table
	public dih_pci_prot_dev_table_end
dih_pci_prot_dev_table	label	byte
		;Vendor ID	Device ID
	dw	1039h,		0008h	; SiS South Bridge
	dw	1039h,		0009h	; SiS PMU
	dw	1039h,		5513h	; SiS 5513 IDE 
	dw	100Ch,		3202h	; TSENG LAB ET4000 VGA Card
	dw	1061h, 		0001h	; XTEC VGA	
dih_pci_prot_dev_table_end	label	byte

;---------------------------------------;
; onboard_vga_device_func_number        ;	MOVED TO OEMPDIM.ASM
;---------------------------------------;

endif ;PCI

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
