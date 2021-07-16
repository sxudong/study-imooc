        page    ,132
        title .                         Device Initializer Hooks
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
        include dim.equ
        include devnode.equ
        include rt.equ
        include escd.equ
        include pci.equ
        include pnp.equ
        include makeflag.equ
        include setupequ.ext
	include sis530.equ
;---------------------------------------;

        public dih_sys_func_0
        public dih_sys_func_1
        public dih_sys_func_2
        public dih_sys_func_3
        public dih_sys_func_4
        public dih_sys_func_5
        public dih_sys_mem_shadowable
        public dih_sys_config_done

ifdef ISA
        public dih_isa_func_0
        public dih_isa_func_1
        public dih_isa_func_2
        public dih_isa_func_3
        public dih_isa_func_4
        public dih_isa_func_5
        public dih_isa_reserve_irq_mem
endif

ifdef EISA
        public  dih_eisa_handle_cfg_mem
        public  program_cachability_sram
        public  program_cachability_sram_final
endif

ifdef PNP
        public dih_pnp_func_0
        public dih_pnp_func_1
        public dih_pnp_func_2
        public dih_pnp_func_3
        public dih_pnp_func_4
endif

ifdef PCI
        public dih_pci_func_0
        public dih_pci_check_ide
        public dih_pci_func_1
        public dih_pci_func_2
        public dih_pci_func_3
        public dih_pci_func_4
        public dih_pci_func_5
        public dih_pci_get_info
        public dih_pci_prot_dev
        public dih_pci_ignore_escd_irq
        extrn  dih_pci_prot_dev_table:byte
        extrn  dih_pci_prot_dev_table_end:byte
endif


;---------------------------------------;

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

cgroup  group   _text
_text   segment byte public 'CODE'
        assume  cs:cgroup
.386


;---------------------------------------;
; Protected IO Ports for Legacy Devices ;
;---------------------------------------;

        public dih_sys_legacy_port_table_start
        public dih_sys_legacy_port_table_end

dih_sys_legacy_port_table_start:

LegacyPort < 170h, 8 >                  ;170 - 17F: Secondary HDC
LegacyPort < 1F0h, 8 >                  ;1F0 - 1FF: Primary HDC
LegacyPort < 200h, 8 >                  ;200 - 207: Game port
LegacyPort < 250h, 2 >                  ;250 - 251: Bestlink suggestion
LegacyPort < 278h, 4 >                  ;278 - 27B: Parallel port
LegacyPort < 2E8h, 8 >                  ;2E8 - 2EF: Serial port
LegacyPort < 2F8h, 8 >                  ;2F8 - 2FF: Serial port
LegacyPort < 370h, 8 >                  ;370 - 377: Secondary FDC
LegacyPort < 378h, 4 >                  ;378 - 37B: Parallel port
LegacyPort < 3B0h, 12>                  ;3B0 - 3BC: Monochrome adapter
LegacyPort < 3BCh, 4 >                  ;3BC - 3BF: Parallel port
LegacyPort < 3C0h, 32>                  ;3C0 - 3DF: Various CGA/EGA/VGA
LegacyPort < 3E8h, 8 >                  ;3E8 - 3EF: Serial port
LegacyPort < 3F8h, 8 >                  ;3F8 - 3FF: Serial port

;Remove these comments to protect the EISA ID ports
if      MKF_INC_EISA
LegacyPort < 00C80h, 4 >                ;EISA ID Ports - Slot 0
LegacyPort < 01C80h, 4 >                ;EISA ID Ports - Slot 1
LegacyPort < 02C80h, 4 >                ;EISA ID Ports - Slot 2
LegacyPort < 03C80h, 4 >                ;EISA ID Ports - Slot 3
LegacyPort < 04C80h, 4 >                ;EISA ID Ports - Slot 4
LegacyPort < 05C80h, 4 >                ;EISA ID Ports - Slot 5
LegacyPort < 06C80h, 4 >                ;EISA ID Ports - Slot 6
LegacyPort < 07C80h, 4 >                ;EISA ID Ports - Slot 7
LegacyPort < 08C80h, 4 >                ;EISA ID Ports - Slot 8
LegacyPort < 09C80h, 4 >                ;EISA ID Ports - Slot 9
LegacyPort < 0AC80h, 4 >                ;EISA ID Ports - Slot A
LegacyPort < 0BC80h, 4 >                ;EISA ID Ports - Slot B
LegacyPort < 0CC80h, 4 >                ;EISA ID Ports - Slot C
LegacyPort < 0DC80h, 4 >                ;EISA ID Ports - Slot D
LegacyPort < 0EC80h, 4 >                ;EISA ID Ports - Slot E
LegacyPort < 0FC80h, 4 >                ;EISA ID Ports - Slot F
endif

dih_sys_legacy_port_table_end:
;==============================================================================;
;                                                                              ;
;                   System Board Device Initializer Hooks                      ;
;                                                                              ;
;==============================================================================;

;---------------------------------------;
; dih_sys_func_0 (Reset,Detect,Disable) ;
;---------------------------------------;--------------------------------------;
; This function is called by the System Board Device Initializer (DI-SYS.ASM)  ;
; during function 0 (Reset, Detect, and Disable).  The following things should ;
; be done here if needed:                                                      ;
;                                                                              ;
; - Reset and disable any on board devices such as serial ports, parallel      ;
;   ports, HDD / FDD controllers, etc. that are not disabled by the peripheral ;
;   code.                                                                      ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_sys_func_0  proc near
        clc
        ret
dih_sys_func_0  endp


;---------------------------------------;
; dih_sys_func_1 (Static Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the System Board Device Initializer (DI-SYS.ASM)  ;
; during function 1 (Static Device Init).  The following steps should be done  ;
; here:                                                                        ;
;                                                                              ;
; - Allocate a block of memory just below the very top of address space (4GB). ;
;   The block should have a size large enough to protect the any BIOS image    ;
;   or other memory that is visible there from being allocated by the resource ;
;   manager.  This memory region will be "off limits" for any device to use.   ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_sys_func_1  proc near
        mov     di, offset OwnerWork    ;Use this global as workspace
        mov     (owner_sys ptr [di]).own_sys_sig, OWNTYPE_SYS
        mov     (owner_sys ptr [di]).own_sys_nodenum, 0FFh
        mov     (owner_sys ptr [di]).own_sys_rsvd, 0
        mov     (owner_sys ptr [di]).own_sys_devid, 0FFFFFFFFh
        mov     dword ptr (owner_sys ptr [di]).own_sys_rsvd2, 0
 ; Reserve the memory spaces at F0000000/FFFFFFFF
        mov     ebx, 0f0000000h         ;Min and Max base addresses are
        mov     ecx, ebx
	mov	edx, 0fffffffh
        mov     esi, 1                  ;Alignment is byte
        xor     al, al                  ;All flags are 0
        mov     ah, RM_ALLOC_MEM
        CALL_RESMGR                     ;Call Resource Manager to allocate
        clc
        ret
dih_sys_func_1  endp


;---------------------------------------;
; dih_sys_func_2 (Output Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the System Board Device Initializer (DI-SYS.ASM)  ;
; during function 2 (Output Device Init).  This function should examine the    ;
; device ID of the currently selected boot output device in NVRam.  If this    ;
; device ID matches the device ID of a system device node that is capable of   ;
; being an output device, then the device should be enabled and its resources  ;
; should be allocated.  If the current boot output device (in NVRam) is set to ;
; DEVTYPE_DEFAULT, then any onboard device capable of functioning as an        ;
; output device should be enabled and its resources should be allocated.  If   ;
; the BD_FLAG_NO_DEV_CHECK bit is not set in the nvrhd_output.bd_flags word in ;
; NVRam, then this function should (if possible) only enable the output device ;
; if there is (for example) a monitor connected.                               ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if boot output device was found, set if not found.      ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_sys_func_2  proc near
        stc                             ;Indicate no device found
        ret
dih_sys_func_2  endp


;---------------------------------------;
; dih_sys_func_3 (Input Device Init)    ;
;---------------------------------------;--------------------------------------;
; This function is called by the System Board Device Initializer (DI-SYS.ASM)  ;
; during function 3 (Input Device Init).  Normally there will be nothing to do ;
; here, because DI-SYS.ASM will use the keyboard controller as the boot input  ;
; device.                                                                      ;
;                                                                              ;
; This function can be used to implement a non-standard boot input device (one ;
; example of this would be redirecting console I/O to a serial port).  When    ;
; implementing a non-standard input device this function should examine the    ;
; device ID of the currently selected boot input device in NVRam.  If this     ;
; device ID matches the device ID of the non-standard input device, this       ;
; function should enable the device and allocate the device's resources.  If   ;
; a non-standard boot input device is found and successfully initialized, this ;
; function should return with CF clear.  Note: A non-standard boot input       ;
; device must provide an Int 09h interface.                                    ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if a boot input device was found, set if not found.     ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_sys_func_3  proc near
        stc                             ;Indicate no device found
        ret
dih_sys_func_3  endp


;---------------------------------------;
; dih_sys_func_4 (IPL Device Init)      ;
;---------------------------------------;--------------------------------------;
; This function is called by the System Board Device Initializer (DI-SYS.ASM)  ;
; during function 4 (IPL Device Init).  This function should examine the       ;
; device ID of the currently selected IPL device in NVRam.  If this            ;
; device ID matches the device ID of a system device node that is capable of   ;
; being an IPL device, then the device should be enabled and its resources     ;
; should be allocated.  If the current IPL device (in NVRam) is set to         ;
; DEVTYPE_DEFAULT, then any onboard device capable of functioning as an        ;
; IPL device should be enabled and its resources should be allocated.  If      ;
; the BD_FLAG_NO_DEV_CHECK bit is not set in the nvrhd_ipl.bd_flags word in    ;
; NVRam, then this function should (if possible) only enable the IPL device    ;
; if there is (for example) a monitor connected.                               ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if boot output device was found, set if not found.      ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_sys_func_4  proc near
        stc                             ;Indicate no device found
        ret
dih_sys_func_4  endp


;---------------------------------------;
; dih_sys_func_5 (General Device Init)  ;
;---------------------------------------;--------------------------------------;
; This function is called by the System Board Device Initializer (DI-SYS.ASM)  ;
; during function 5 (General Device Init).  If there are any configurable      ;
; system device nodes that need to be enabled before boot, this function       ;
; should enable them and allocate their resources.                             ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_sys_func_5  proc near
        clc                             ;Indicate success
        ret
dih_sys_func_5  endp


;---------------------------------------;
; dih_sys_config_done                   ;
;---------------------------------------;--------------------------------------;
; This function is called after all devices of all types have been configured. ;
;                                                                              ;
; Input: DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_sys_config_done     proc near

; The following code is included when the debug switch is set in the makefile.
; This code will copy the entire resource map (which is built during POST) into
; shadow memory at DC00:0.  You can then run the utility RESMAP.EXE to display
; the resource map in a readable form.  NOTE: This code will destroy any option
; ROM that is shadowed at DC00:0 so don't enable it if you are using a board
; which needs DC00:0.

ifdef INC_DEBUG
        pusha
        push    es

        mov     dl, 7
        mov     al, 1
        call    dih_sys_mem_shadow      ;Set DC00 - DFFF to R/W RAM

        mov     di, 0DC00h              ;ES:DI = DC00:0
        mov     es, di
        xor     di, di
        mov     cx, 4000h               ;16k
        xor     al, al
        cld
        rep     stosb                   ;Clear out DC00 - DFFF

        xor     di, di
        mov     si, ds:ResMapStart      ;DS:SI = Resource Map
        mov     cx, ds:ResMapEnd
        sub     cx, si                  ;CX = Number od bytes in Resource Map
        rep     movsb

        mov     dl, 7
        mov     al, 2
        call    dih_sys_mem_shadow      ;Set DC00 - DFFF to WP RAM

        pop     es
        popa
endif
if MKF_ACPI_SUPPORT
	pusha
	mov	al,Q_ACPI_OS
	call	check_cmos_data_far
	jz	get_acpi_irq_done
        mov     di, offset OwnerWork
        mov     (owner_pci ptr [di]).own_pci_sig, OWNTYPE_PCI
        mov     (owner_pci ptr [di]).own_pci_bus, 00h
        mov     (owner_pci ptr [di]).own_pci_devfunc, 09h
        mov     dword ptr (owner_pci ptr [di]).own_pci_vendid, 00091039h
        mov     (owner_pci ptr [di]).own_pci_rsvd, 0
;; Get available IRQs from PCI IRQ map
        mov     si, 3612h
	sub	bx,bx
	mov	ax,bx
get_acpi_irq_map:
	lodsb
	or	al,al
	jz	short get_acpi_irq_map_done
	bts	bx,ax
	jmp	short get_acpi_irq_map
get_acpi_irq_map_done:
	push	bx
        mov     ax, RM_ALLOC_IRQ * 100h + RESFLAG_NO_ALLOC
        CALL_RESMGR
	pop	bx
	jnc	got_acpi_irq

        mov     ax, RM_ALLOC_IRQ * 100h + RESFLAG_SHARE
        CALL_RESMGR
	jc	get_acpi_irq_done
got_acpi_irq:
	bsf	cx,ax
	or	cl,80h				; Enable by SMI route
	mov	bx,S5595_BUS_NUM + S5595_PCI2ISA_DEV_FUNC_NUM
	mov	di,6ah
        mov     ah,RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION
get_acpi_irq_done:
	popa
endif
        ret
dih_sys_config_done     endp


;---------------------------------------;
; dih_sys_mem_shadowable                ;
;---------------------------------------;--------------------------------------;
; This function reports whether or not a given memory block is set to shadow   ;
; enabled in CMOS.                                                             ;
;                                                                              ;
; Input:  DL = Block to check: 0=C000, 1=C400, 2=C800, 3=CC00                  ;
;                              4=D000, 5=D400, 6=D800, 7=DC00                  ;
;                                                                              ;
; Output: CF = Set if shadow is disabled for this block in CMOS                ;
;              Clear if shadow is enabled for this block in CMOS               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
shadow_ques_table       label   byte
        db      q_c0000_shadow
        db      q_c0000_shadow
        db      q_c8000_shadow
        db      q_cc000_shadow
        db      q_d0000_shadow
        db      q_d4000_shadow
        db      q_d8000_shadow
        db      q_dc000_shadow

dih_sys_mem_shadowable  proc near
        pusha
        mov     bx,offset cgroup:shadow_ques_table
        mov     al,dl
        xlat    cgroup:shadow_ques_table
        call    check_cmos_data_far     ; AL = 00 disabled, <>00 enabled
        cmp     al,1                    ; CY = disabled, NC = enabled
        popa
        ret
dih_sys_mem_shadowable  endp

;---------------------------------------;
; check_cmos_data_far                   ;
;---------------------------------------;--------------------------------------;
; This function returns the value of the given setup item.                     ;
;                                                                              ;
; Input:  AL = setup question structure#                                       ;
;                                                                              ;
; Output: ZF = Set if it is disabled in CMOS setup                             ;
;              Clear if it is enabled in CMOS setup                            ;
;         AL = right justified value of the given setup item                   ;
;                                                                              ;
; Destroys: AX                                                                 ;
;------------------------------------------------------------------------------;
        public  check_cmos_data_far
check_cmos_data_far     proc    near
        db      9ah                     ; CALL FAR F000:EED5
        dw      0eed5h
        dw      0f000h
        ret
check_cmos_data_far     endp
COMMENT ~
;---------------------------------------;
; get_processor_info_far                ;
;---------------------------------------;--------------------------------------;
; This function returns the processor information                              ;
;                                                                              ;
; Input:  none                                                                 ;
;                                                                              ;
; Output: EBX bit11-9 = init info                                              ;
;                       00/01/02/03 => 386/486/586/686                         ;
; Destroys: ALL registers                                                      ;
;------------------------------------------------------------------------------;
        public  get_processor_info_far
get_processor_info_far  proc    near
        db      9ah                     ; CALL FAR F000:EEC6
        dw      0eec6h
        dw      0f000h
        ret
get_processor_info_far  endp
~
;==============================================================================;
;                                                                              ;
;                      ISA Device Initializer Hooks                            ;
;                                                                              ;
;==============================================================================;

ifdef ISA

;---------------------------------------;
; dih_isa_func_0 (Reset,Detect,Disable) ;
;---------------------------------------;--------------------------------------;
; This function is called by the ISA Initializer (DI-ISA.ASM)                  ;
; during function 0 (Reset, Detect, and Disable).                              ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_isa_func_0  proc near
        clc
        ret
dih_isa_func_0  endp


;---------------------------------------;
; dih_isa_func_1 (Static Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the ISA Initializer (DI-ISA.ASM)                  ;
; during function 1 (Static Device Init).                                      ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_isa_func_1  proc near
        mov     al,Q_CLEAR_NVRAM
        call    check_cmos_data_far
        jz      no_reset_nvram
        or      SysStatus, STAT_SYS_NVRAM_CKSUM
no_reset_nvram:
        clc
        ret
dih_isa_func_1  endp


;---------------------------------------;
; dih_isa_func_2 (Output Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the ISA Initializer (DI-ISA.ASM)                  ;
; during function 2 (Output Device Init).                                      ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if boot output device was found, set if not found.      ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_isa_func_2  proc near
        stc                             ;Indicate no device found
        ret
dih_isa_func_2  endp


;---------------------------------------;
; dih_isa_func_3 (Input Device Init)    ;
;---------------------------------------;--------------------------------------;
; This function is called by the ISA Initializer (DI-ISA.ASM)                  ;
; during function 3 (Input Device Init).                                       ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if a boot input device was found, set if not found.     ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_isa_func_3  proc near
        stc                             ;Indicate no device found
        ret
dih_isa_func_3  endp


;---------------------------------------;
; dih_isa_func_4 (IPL Device Init)      ;
;---------------------------------------;--------------------------------------;
; This function is called by the ISA Initializer (DI-ISA.ASM)                  ;
; during function 4 (IPL Device Init).                                         ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if boot output device was found, set if not found.      ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_isa_func_4  proc near
        stc                             ;Indicate no device found
        ret
dih_isa_func_4  endp


;---------------------------------------;
; dih_isa_func_5 (General Device Init)  ;
;---------------------------------------;--------------------------------------;
; This function is called by the ISA Initializer (DI-ISA.ASM)                  ;
; during function 5 (General Device Init).                                     ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_isa_func_5  proc near
        clc
        ret
dih_isa_func_5  endp


;---------------------------------------;
; dih_isa_reserve_irq_mem               ;
;---------------------------------------;--------------------------------------;
; This function allows DMAs, IRQs, a memory block to be reserved for standard  ;
; ISA cards.  If this function is used, setup should contain some questions    ;
; such as:  IRQ  9 used by ISA: Yes/No                                         ;
;           IRQ 10 used by ISA: Yes/No                                         ;
;           IRQ 11 used by ISA: Yes/No                                         ;
;           ...                 ...                                            ;
;           ISA memory block base address: Disabled/C800/CC00/.../DC00         ;
;           ISA memory block size: 8k/16k/32k/64k                              ;
; These setup questions are very useful for users who are mixing ISA, PCI, and ;
; Plug-and-Play ISA cards in the same system and do not want to run the ICU.   ;
; These questions are MANDATORY for systems that have no NVRam and therefore   ;
; cannot run the ICU.  Any IRQs and/or memory block returned by this function  ;
; will not be allocated to any PCI or PnP ISA device.                          ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: AX = Bitmap of DMA channels that should be reserved for standard ISA ;
;              cards, these DMA channels will not be assigned to any PnP device;
;                 Bit   0: If set, DMA 0 is reserved for ISA cards             ;
;                 Bit   1: If set, DMA 1 is reserved for ISA cards             ;
;                 ...     ...                                                  ;
;                 Bit   6: If set, DMA 6 is reserved for ISA cards             ;
;                 Bit   7: If set, DMA 7 is reserved for ISA cards             ;
;                 Bit15-8: Not Used (initlaized to 0)                          ;
;         CX = Bitmap of IRQs that should be reserved for standard ISA cards,  ;
;              these IRQs will not be assigned to any PCI or PnP ISA device.   ;
;                 Bit  0: If set, IRQ 0 is reserved for ISA cards              ;
;                 Bit  1: If set, IRQ 1 is reserved for ISA cards              ;
;                 ...     ...                                                  ;
;                 Bit 14: If set, IRQ 14 is reserved for ISA cards             ;
;                 Bit 15: If set, IRQ 15 is reserved for ISA cards             ;
;         EBX = Absolute 32 bit base address of memory block that should be    ;
;               reserved for standard ISA cards, the memory block defined by   ;
;               EBX and EDX will not be assigned to any PCI or PnP ISA device. ;
;               For example: To reserve a 16k block of memory at D000:0 for    ;
;                            an ISA card, set EBX=0D0000h and EDX=4000h.       ;
;         EDX = Size of memory block to be reserved for ISA (see above).  Set  ;
;               to 0000h if no ISA memory block is needed.                     ;
;                                                                              ;
; Destroys: AX CX EBX EDX                                                      ;
;------------------------------------------------------------------------------;
isa_dma_table           label   byte
        db      q_dma0_used_by_isa, 0
        db      q_dma1_used_by_isa, 1
        db      q_dma3_used_by_isa, 3
        db      q_dma5_used_by_isa, 5
        db      q_dma6_used_by_isa, 6
        db      q_dma7_used_by_isa, 7
isa_dma_table_end       label   byte

isa_irq_table           label   byte
        db      q_irq3_used_by_isa, 3
        db      q_irq4_used_by_isa, 4
        db      q_irq5_used_by_isa, 5
        db      q_irq7_used_by_isa, 7
        db      q_irq9_used_by_isa, 9
        db      q_irq10_used_by_isa, 10
        db      q_irq11_used_by_isa, 11
        db      q_irq14_used_by_isa, 14
        db      q_irq15_used_by_isa, 15
isa_irq_table_end       label   byte

dih_isa_reserve_irq_mem proc near
        push    si
        mov     si,offset cgroup:isa_irq_table
        mov     cx,(offset cgroup:isa_irq_table_end-offset cgroup:isa_irq_table)/2
        xor     dx,dx
dihirim_00:
        push    cx
        lods    cgroup:byte ptr [si]    ; AL = setup structure#
        call    check_cmos_data_far
        mov     cl,al
        lodsb   cgroup:byte ptr [si]    ; AL = bit posn
        xchg    al,cl
        movzx   ax,al
        shl     ax,cl
        or      dx,ax
        pop     cx
        loop    dihirim_00
;  DX = bit map of IRQs reserved for ISA
        push    dx                      ; save DX = bit map of IRQs reserved for ISA
        mov     si,offset cgroup:isa_dma_table
        mov     cx,(offset cgroup:isa_dma_table_end-offset cgroup:isa_dma_table)/2
        xor     dx,dx
dihirim_02:
        push    cx
        lods    cgroup:byte ptr [si]    ; AL = setup structure#
        call    check_cmos_data_far
        mov     cl,al
        lodsb   cgroup:byte ptr [si]    ; AL = bit posn
        xchg    al,cl
        shl     al,cl
        or      dl,al
        pop     cx
        loop    dihirim_02
;  DL = bit map of DMAs reserved for ISA
        push    dx                      ; save DL = bit map of DMAs reserved for ISA
        xor     edx,edx                 ; ISA mem block size = 0 (disabled)
        mov     ebx,edx
        mov     al,q_mem_size_used_by_isa
        call    check_cmos_data_far
        jz      dihirim_01              ; no mem reserved by ISA
        movzx   eax,al
        add     eax,0dh
        bts     edx,eax                 ; EDX = mem size in bytes
        mov     al,q_mem_base_used_by_isa
        call    check_cmos_data_far
        movzx   ebx,al
        shl     ebx,0eh
        add     ebx,0c0000h             ; EBX = mem base used by isa
dihirim_01:
        pop     ax                      ; AL = bit map of DMAs reserved for ISA
        pop     cx                      ; CX = bit map of IRQs reserved for ISA
        pop     si
        ret
dih_isa_reserve_irq_mem endp

endif ;ISA


;==============================================================================;
;                                                                              ;
;                      EISA Device Initializer Hooks                           ;
;                                                                              ;
;==============================================================================;

ifdef EISA

;---------------------------------------;
;       HANDLE_CFG_MEM  ROUTINE         ;
;  CALLED FROM DI-EISA.ASM              ;
;               FOR SLOT INITIALISATION ;
;               (FROM MEMORY_INIT)      ;
;  Input : (al) memory conf byte        ;
;        : (ds:si) points to data area  ;
;        : (bx) pointer to memory block ;
;      Preserve all registers           ;
;---------------------------------------;

dih_eisa_handle_cfg_mem proc    near

        ret

dih_eisa_handle_cfg_mem endp

;---------------------------------------;
;    PROGRAM_CACHABILITY_SRAM ROUTINE   ;
;   CALLED FROM POST DIAG 	        ;
;   RELATED TO CACHABILITY SRAM         ;
;---------------------------------------;

program_cachability_sram        proc    near

        ret

program_cachability_sram        endp

;---------------------------------------;
; PROGRAM_CACHABILITY_SRAM_FINAL ROUTINE;
;   CALLED FROM POST DIAG ??????        ;
;   RELATED TO CACHABILITY SRAM         ;
;---------------------------------------;

program_cachability_sram_final  proc    near

        ret

program_cachability_sram_final  endp
;---------------------------------------;

endif ;EISA



;==============================================================================;
;                                                                              ;
;                Plug and Play ISA Device Initializer Hooks                    ;
;                                                                              ;
;==============================================================================;

ifdef PNP

;---------------------------------------;
; dih_pnp_func_0 (Reset,Detect,Disable) ;
;---------------------------------------;--------------------------------------;
; This function is called by the Plug & Play Device Initializer (DI-PNP.ASM)   ;
; during function 0 (Reset, Detect, and Disable).                              ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pnp_func_0  proc near
        clc
        ret
dih_pnp_func_0  endp


;---------------------------------------;
; dih_pnp_func_1 (Static Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the Plug & Play Device Initializer (DI-PNP.ASM)   ;
; during function 1 (Static Device Init).                                      ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pnp_func_1  proc near
        clc
        ret
dih_pnp_func_1  endp


;---------------------------------------;
; dih_pnp_func_2 (Output Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the Plug & Play Device Initializer (DI-PNP.ASM)   ;
; during function 2 (Output Device Init).                                      ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if boot output device was found, set if not found.      ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pnp_func_2  proc near
        stc                             ;Indicate no device found
        ret
dih_pnp_func_2  endp


;---------------------------------------;
; dih_pnp_func_3 (Input Device Init)    ;
;---------------------------------------;--------------------------------------;
; This function is called by the Plug & Play Device Initializer (DI-PNP.ASM)   ;
; during function 3 (Input Device Init).                                       ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if a boot input device was found, set if not found.     ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pnp_func_3  proc near
        stc                             ;Indicate no device found
        ret
dih_pnp_func_3  endp


;---------------------------------------;
; dih_pnp_func_4 (IPL Device Init)      ;
;---------------------------------------;--------------------------------------;
; This function is called by the Plug & Play Device Initializer (DI-PNP.ASM)   ;
; during function 4 (IPL Device Init).                                         ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if boot output device was found, set if not found.      ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pnp_func_4  proc near
        stc                             ;Indicate no device found
        ret
dih_pnp_func_4  endp


;---------------------------------------;
; dih_pnp_func_5 (General Device Init)  ;       Moved to OEMPDIM.ASM
;---------------------------------------;
; dih_check_pnp_device_func_5_table     ;       Moved to OEMPDIM.ASM
;---------------------------------------;

endif ;PNP



;==============================================================================;
;                                                                              ;
;                      PCI Device Initializer Hooks                            ;
;                                                                              ;
;==============================================================================;

ifdef PCI

;---------------------------------------;
; dih_pci_func_0 (Reset,Detect,Disable) ;
;---------------------------------------;--------------------------------------;
; This function is called by the PCI Device Initializer (DI-PCI.ASM)           ;
; during function 0 (Reset, Detect, and Disable).                              ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if this function disables all of the devices (in this case  ;
;                  the PCI core will not attempt to disable PCI devices)       ;
;              Clear if the core should go ahead and disable all PCI devices   ;
;                  (except those devices that are protected by dih_pci_prot_dev;
;                  which is defined below)                                     ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pci_func_0  proc near
        clc
        ret
dih_pci_func_0  endp

;---------------------------------------;
; dih_pci_func_1 (Static Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the PCI Device Initializer (DI-PCI.ASM)           ;
; during function 1 (Static Device Init).                                      ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if this function handles all static devices (in this case   ;
;                  the core will not call dih_pci_check_ide below)             ;
;              Clear if this function does nothing (in this case the core will ;
;                  initialize any static devices and will call the             ;
;                  dih_pci_check_ide function below)                           ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pci_func_1  proc near
        clc
        ret
dih_pci_func_1  endp

;---------------------------------------;
; dih_pci_check_ide                     ;
;---------------------------------------;--------------------------------------;
; This function is called by the Device Initialization Manager (DIM.ASM)       ;
; at the start of function 1 (Static Device Init).  This function is used to   ;
; implement the setup questions for off board PCI IDE controller.              ;
;                                                                              ;
; This function uses three setup questions:                                    ;
;                                                                              ;
; Off Board PCI IDE:                 Auto/Slot1/Slot2/Slot3/Slot4/Slot5/Slot6  ;
; Off Board PCI IDE Primary IRQ:     Disabled/IntA/IntB/IntC/IntD/Hardwired    ;
; Off Board PCI IDE Secondary IRQ:   Disabled/IntA/IntB/IntC/IntD/Hardwired    ;
;                                                                              ;
; The following things should be done here:                                    ;
; 1a. Read the setup question Q_PCI_OFFBOARD_IDE.                              ;
;     If it is set to Auto, then exit this function.                           ;
; 1b. If it is set to Slot 1/2/3/4/5/6, then translate the slot # into a       ;
;     PCI bus/device/function number (function part will always be 0).         ;
; 2.  Read the device's vendor/device ID and save it in the variable           ;
;     dih_manual_ide_id.  This will make it a protected device and prevent the ;
;     device from getting programmed by the normal PCI configuration routines. ;
; 3a. Read the setup question Q_PCI_OFFBOARD_IDE_PRI_IRQ.                      ;
; 3b. If it is set to Disabled, then go to step 4.                             ;
; 3c. If it is set to IntA/B/C/D, then route and allocate IRQ 14 to the PCI    ;
;     bus/device from step 1.                                                  ;
; 3d. If it is set to Hardwired, then allocate IRQ 14, but don't route it.     ;
; 3c. Allocate ports 1F0-1F7 and 3F6 to the device.                            ;
; 4a. Read the setup question Q_PCI_OFFBOARD_IDE_SEC_IRQ.                      ;
; 4b. If it is set to Disabled, then goto step 5.                              ;
; 4c. If it is set to IntA/B/C/D, then route and allocate IRQ 15 to the PCI    ;
;     bus/device from step 1.                                                  ;
; 4d. If it is set to Hardwired, then allocate IRQ 15, but don't route it.     ;
; 4c. Allocate ports 170-177 and 376 to the device.                            ;
; 5.  Enable the device by writing to its command register.                    ;
; 6.  Return                                                                   ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_pci_check_ide       proc near
        pushad

        mov     dword ptr dih_manual_ide_id, 0FFFFFFFFh ;Init scratch data

; 1a. Read the setup question Q_PCI_OFFBOARD_IDE.
;     If it is set to Auto, then exit this function.

        mov     al, Q_PCI_OFFBOARD_IDE
        call    check_cmos_data_far     ;AL = 0/1/../6 for Auto/Slot1/../Slot6
        jz      check_ide_done          ;Br if set to Auto

; 1b. If it is set to Slot 1/2/3/4/5/6, then translate the slot # into a
;     PCI bus/device/function number (function part will always be 0).

        mov     ah, RT_PCI_SLOT_TO_DEV
        CALL_RT_FUNCTION                ;Translate slot AL to bus/dev in BX
        jc      check_ide_done          ;Br if unknown PCI slot number

        mov     di, PCI_REG_SUB_TYPE
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION
        cmp     ch,03h                  ; class code = VGA ?
        jz      vga_found               ; yes..
        cmp     cx,0001h                ; class code = old VGA ?
vga_found:
        jz      check_ide_done          ;Br if this slot number is VGA
; 2.  Read the device's vendor/device ID and save it in the variable
;     dih_manual_ide_id.  This will make it a protected device and prevent the
;     device from getting programmed by the normal PCI configuration routines.

        mov     di, PCI_REG_VENDID
        mov     ah, RT_PCI_READ_CFG_DWORD
        CALL_RT_FUNCTION                ;Read Vendor ID & Device ID
        mov     dword ptr dih_manual_ide_id, ecx ;Save vendor ID and Device ID

        mov     di, offset OwnerWork    ;Make an owner_pci structure for resmgr
        mov     (owner_pci ptr [di]).own_pci_sig, OWNTYPE_PCI
        mov     (owner_pci ptr [di]).own_pci_bus, bh
        mov     (owner_pci ptr [di]).own_pci_devfunc, bl
        mov     dword ptr (owner_pci ptr [di]).own_pci_vendid, ecx
        mov     (owner_pci ptr [di]).own_pci_rsvd, 0

; 3a. Read the setup question Q_PCI_OFFBOARD_IDE_PRI_IRQ.
; 3b. If it is set to Disabled, then go to step 4.

        xor     cx, cx                  ;CH <> 00 primary enabled
                                        ;CL <> 00 secondary enabled
        mov     al, Q_PCI_OFFBOARD_IDE_PRI_IRQ
        call    check_cmos_data_far     ;AL = 0/1/../5 for Disabled/IntA/B/C/D/Hardwired
        mov     ch, al
        jz      check_ide_secondary     ;Br if primary IRQ is disabled

        push    cx
; 3c. If it is set to IntA/B/C/D, then route and allocate IRQ 14 to the PCI
;     bus/device from step 1.

        cmp     al, 4
        ja      check_ide_pri_hardwired ;Br if primary IRQ is set to hardwired

        mov     dl, al                  ;DL = 1/2/3/4 for IntA/B/C/D
        mov     al, 0Eh                 ;AL = IRQ 14
        mov     ah,RT_PCI_ROUTE_IRQ
        CALL_RT_FUNCTION                ;Route IRQ to the device

; 3d. If it is set to Hardwired, then allocate IRQ 14, but don't route it.

check_ide_pri_hardwired:
        pusha
        mov     bx, 0100000000000000b   ;Bit 14 = IRQ 14
        mov     di, offset OwnerWork    ;Point ES:DI to owner_pci structure
        mov     ax, RM_ALLOC_IRQ * 100h
        CALL_RESMGR                     ;Call Resource Manager to allocate IRQ
        popa

        mov     cl, 0Eh                 ;IRQ 14
        mov     di, PCI_REG_INT_LINE
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION                ;Write Int Line register with IRQ 14

; 3c. Allocate ports 1F0-1F7 and 3F6 to the device.

        mov     ecx, 1F0h                  ;Base address
        mov     dx, 8                      ;Size
        mov     di, PCI_REG_FIRST_BASE_ADD ;Offset in config space
        call    alloc_and_prog_pci_ioaddr  ;Allocate and program base addr reg

        mov     ecx, 3F6h                  ;Base address
        mov     dx, 1                      ;Size
        mov     di, PCI_REG_FIRST_BASE_ADD+4 ;Offset in config space
        call    alloc_and_prog_pci_ioaddr  ;Allocate and program base addr reg

; 4a. Read the setup question Q_PCI_OFFBOARD_IDE_SEC_IRQ.
; 4b. If it is set to Disabled, then go to step 5.

        pop     cx
check_ide_secondary:
        mov     al, Q_PCI_OFFBOARD_IDE_SEC_IRQ
        call    check_cmos_data_far     ;AL = 0/1/../5 for Disabled/IntA/B/C/D/Hardwired
        mov     cl, al
        jz      check_ide_enable        ;Br if secondary IRQ is disabled

        push    cx
; 4c. If it is set to IntA/B/C/D, then route and allocate IRQ 15 to the PCI
;     bus/device from step 1.

        cmp     al, 4
        ja      check_ide_sec_hardwired ;Br if secondary IRQ is set to hardwired

        mov     dl, al                  ;DL = 1/2/3/4 for IntA/B/C/D
        mov     al, 0Fh                 ;AL = IRQ 15
        mov     ah,RT_PCI_ROUTE_IRQ
        CALL_RT_FUNCTION                ;Route IRQ to the device

; 4d. If it is set to Hardwired, then allocate IRQ 15, but don't route it.

check_ide_sec_hardwired:
        pusha
        mov     bx, 1000000000000000b   ;Bit 15 = IRQ 15
        mov     di, offset OwnerWork    ;Point ES:DI to owner_pci structure
        mov     ax, RM_ALLOC_IRQ * 100h
        CALL_RESMGR                     ;Call Resource Manager to allocate IRQ
        popa

        mov     cl, 0Fh                 ;IRQ 15
        mov     di, PCI_REG_INT_LINE
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION                ;Write Int Line register with IRQ 15

; 4e. Allocate ports 170-177 and 376 to the device.

        mov     ecx, 170h                  ;Base address
        mov     dx, 8                      ;Size
        mov     di, PCI_REG_FIRST_BASE_ADD+8 ;Offset in config space
        call    alloc_and_prog_pci_ioaddr  ;Allocate and program base addr reg

        mov     ecx, 376h                  ;Base address
        mov     dx, 1                      ;Size
        mov     di, PCI_REG_FIRST_BASE_ADD+0Ch ;Offset in config space
        call    alloc_and_prog_pci_ioaddr  ;Allocate and program base addr reg

; 5.  Enable the device by writing to its command register.

        pop     cx
check_ide_enable:
        jcxz    check_ide_disable       ;Br if neither controller is enabled
        mov     cx, CMD_IO_SPACE + CMD_MEM_SPACE + CMD_BUS_MASTER
check_ide_disable:
        mov     di, PCI_REG_COMMAND
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION                ;Write CX to command register

check_ide_done:
        popad
        ret
dih_pci_check_ide       endp

;---------------------------------------;
; alloc_and_prog_base_addr              ;
;---------------------------------------;--------------------------------------;
; This function allocates an I/O port block from the resource manager and then ;
; programs the given PCI device / register with the base address.              ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        DI = PCI register to program                                          ;
;        ECX = I/O port base address                                           ;
;        DX = Size of I/O port block in bytes                                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
alloc_and_prog_pci_ioaddr       proc near
        push    ax

        pusha
        mov     si, dx                  ;SI = alignment (same as size)
        mov     bx, cx                  ;BX = min base addr (same as max in CX)
        mov     di, offset OwnerWork
        mov     ax, (RM_ALLOC_PORT * 100h) + RESFLAG_PORT_DECODE16
        CALL_RESMGR                     ;Call Resource Manager to allocate port
        popa

        mov     ah, RT_PCI_WRITE_CFG_DWORD
        CALL_RT_FUNCTION                ;Write ECX to PCI device BX, register DI

        pop     ax
        ret
alloc_and_prog_pci_ioaddr       endp

;---------------------------------------;
; dih_pci_func_2 (Output Device Init)   ;
;---------------------------------------;--------------------------------------;
; This function is called by the PCI Device Initializer (DI-PCI.ASM)           ;
; during function 2 (Output Device Init).                                      ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if boot output device was found, set if not found.      ;
;         FoundDevID   = Device ID of device that was found (if CF clear)      ;
;         FoundDevFunc = Device/Func number of device found (if CF clear)      ;
;                          Bits 7-3: PCI device number                         ;
;                          Bits 2-0: Function number within dev                ;
;         FoundDevBus  = Bus number of device that was found (if CF clear)     ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
	public	check_isa_vga
dih_pci_func_2  proc near
;; Have DRAM in bank0?
	mov	bx, S530_BUS_NUM * 100h + S530_DEV_FUNC_NUM
        mov     di, 063h
        mov     ah, RT_PCI_READ_CFG_BYTE
        CALL_RT_FUNCTION
	test	cl,01h
	jnz	short do_share_memory
	call	auto_detect_local_share
	jz	skip_share_memory
	mov	bx, S530_BUS_NUM * 100h + S530_DEV_FUNC_NUM
        mov     di, 0afh
	mov	cl, 0ffh
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION
	jmp	short skip_share_memory
do_share_memory:
	mov	al,Q_SHARE_MEMORY
	call	check_cmos_data_far
	jnz	short check_share_memory
;; Here, We must be check if system only one V.G.A on the M/B!
	push	si
	mov	ecx, BT_DISPLAY * 100h * 100h
	mov	si,1
	mov	ah,RT_PCI_FIND_CLASS
        CALL_RT_FUNCTION
	pop	si
	jnc	short skip_share_memory
check_share_memory:
	call	auto_detect_local_share
	jz	short skip_share_memory
	call	setup_share_memory
skip_share_memory:

        mov     FindDevID,0
	mov	al,q_pri_display_card
	call	check_cmos_data_far
	jz	check_pci_apg_done
        mov     FindDevIncBus, -1       ;Search busses highest to lowest
	jmp	short check_isa_vga
check_pci_apg_done:
	push	si
	mov	ecx, ST_OLD_VGA * 100h
	sub	si,si
	mov	ah,RT_PCI_FIND_CLASS
        CALL_RT_FUNCTION
	pop	si
	jc  	short check_isa_vga
	or	bh,bh
	jnz	short check_isa_vga
        mov     word ptr FindDevType, BT_OLD_DEVICE * 100h + ST_OLD_VGA
check_isa_vga::
        push    ds

        push    40h
        pop     ds
        mov     word ptr ds:[72h],0000h

        push    0c000h
        pop     ds
        cmp     word ptr ds:[0],0aa55h
        pop     ds
        jnz     short @f
        mov     PCICommandValue,0
@@:
COMMENT ~
        push    ds
        mov     ax,0de00h
        mov     ds,ax
        mov     al,ds:[0]
        cmp     al,0ffh
        pop     ds
        jz      @f
        pusha
        xor     bx,bx
        mov     di,72h
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION
	or	ch,1fh
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION
        db      09ah
        dw      0
        dw      0de00h
        int     3
        popa
@@:
~
        stc                             ;Indicate no device found
        ret
dih_pci_func_2  endp


;---------------------------------------;
; dih_pci_func_3 (Input Device Init)    ;
;---------------------------------------;--------------------------------------;
; This function is called by the PCI Device Initializer (DI-PCI.ASM)           ;
; during function 3 (Input Device Init).                                       ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if a boot input device was found, set if not found.     ;
;         FoundDevID   = Device ID of device that was found (if CF clear)      ;
;         FoundDevFunc = Device/Func number of device found (if CF clear)      ;
;                          Bits 7-3: PCI device number                         ;
;                          Bits 2-0: Function number within dev                ;
;         FoundDevBus  = Bus number of device that was found (if CF clear)     ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pci_func_3  proc near
        stc                             ;Indicate no device found
        ret
dih_pci_func_3  endp


;---------------------------------------;
; dih_pci_func_4 (IPL Device Init)      ;
;---------------------------------------;--------------------------------------;
; This function is called by the PCI Device Initializer (DI-PCI.ASM)           ;
; during function 4 (IPL Device Init).                                         ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Cleared if IPL device was found, set if not found.              ;
;         FoundDevID   = Device ID of device that was found (if CF clear)      ;
;         FoundDevFunc = Device/Func number of device found (if CF clear)      ;
;                          Bits 7-3: PCI device number                         ;
;                          Bits 2-0: Function number within dev                ;
;         FoundDevBus  = Bus number of device that was found (if CF clear)     ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pci_func_4  proc near
        mov     FindDevID,0
        stc                             ;Indicate no device found
        ret
dih_pci_func_4  endp


;---------------------------------------;
; dih_pci_func_5 (General Device Init)  ;
;---------------------------------------;--------------------------------------;
; This function is called by the PCI Device Initializer (DI-PCI.ASM)           ;
; during function 5 (General Device Init).                                     ;
;                                                                              ;
; Input: SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if error, cleared otherwise                                 ;
;                                                                              ;
; Preserves: DS, ES, BP (all other registers are destroyed)                    ;
;------------------------------------------------------------------------------;
dih_pci_func_5  proc near
	cmp	byte ptr dih_manual_ide_id,022h
	jnz	@f
	mov	di, offset OwnerWork	;Use this global as workspace
	mov	(owner_isa ptr [di]).own_isa_sig, OWNTYPE_ISA
	mov	(owner_isa ptr [di]).own_isa_slot, 0
	mov	(owner_isa ptr [di]).own_isa_func, 0
	mov	dword ptr ((owner_isa ptr [di]).own_isa_vendid), 0
	mov	(owner_isa ptr [di]).own_isa_rsvd2, 0
	mov	bx, 020h			; Reserved IRQ 5
	mov	ax, RM_ALLOC_IRQ * 100h
	CALL_RESMGR
@@:
        clc
        ret
dih_pci_func_5  endp

;---------------------------------------;
; dih_pci_prot_dev                      ;
;---------------------------------------;--------------------------------------;
; This function is called by DI-PCI.ASM before configuring or disabling any    ;
; PCI device.  This function should examine the Vendor/Device ID to make sure  ;
; it is not a chipset device or any other device which should no be configured ;
; by DI-PCI.                                                                   ;
;                                                                              ;
; Input: ECX = Vendor / Device ID of device about to be configured (Vendor ID  ;
;              is in low word, Device ID is in high word)                      ;
;                                                                              ;
; Output: CF = Set if device should not be configured and just left alone.     ;
;              Clear if device is ok to enable/disable/configure/etc.          ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_pci_prot_dev        proc near

        push    si
        push    eax
        mov     eax, dword ptr dih_manual_ide_id
        inc     eax
        jz      check_prot
        dec     eax
        cmp     eax,ecx                 ; already configured ?
        jz      prot_dev_found          ; yes
check_prot:

        mov     si,offset cgroup:dih_pci_prot_dev_table
check_prot_0:
        cmp     si,offset cgroup:dih_pci_prot_dev_table_end
        jae     prot_dev_exit           ; NC, ok configure device
        lods    cgroup:dword ptr [si]   ; get next vend id, dev id
        cmp     eax,ecx
        jnz     check_prot_0
prot_dev_found:
        stc
prot_dev_exit:
        pop     eax
        pop     si
        ret
dih_pci_prot_dev        endp

;---------------------------------------;
; dih_pci_ignore_escd_irq               ;
;---------------------------------------;--------------------------------------;
; This function is called by DI-PCI.ASM before configuring PCI device.         ;
;                                                                              ;
; Input:  None                                                                 ;
;                                                                              ;
; Output: CF = Clear to ignore IRQ used on last boot (last boot information is ;
;              stored in ESCD)                                                 ;
;              Set to use IRQ used on last boot (last boot information is      ;
;              stored in ESCD)                                                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_pci_ignore_escd_irq proc    near

        clc                             ; ignore IRQ used on last boot
        ret

dih_pci_ignore_escd_irq endp

;---------------------------------------;
; dih_pci_check_keep_enabled            ;       MOVED TO OEMPDIM.ASM
;---------------------------------------;
; dih_pci_get_info                      ;
;---------------------------------------;--------------------------------------;
; This function is called by DI-PCI.ASM to request various information about   ;
; PCI device configuration.                                                    ;
;                                                                              ;
; Input: DS = _dimdata Segment                                                 ;
;                                                                              ;
; Output: AL = Value to use when programming PCI Latency Timer registers       ;
;         AH = Value to use when programming PCI Cache Line Size registers     ;
;         DX = Various flags:                                                  ;
;              Bit 5: If set, enable VGA Palette Snoop feature                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_pci_get_info        proc near
        mov     al, q_pci_palette_snoop
        call    check_cmos_data_far     ;AL = 0/1 disabled/enabled
        shl     ax,5
        mov     dx,ax
dpgi_00:

	mov	al,20h
	or	bx,bx
	jz	@f

        mov     al, q_pci_latency_timer
        call    check_cmos_data_far     ;AL = 0/1/../7
        inc     al
        mov     ah,20h
        mul     ah
        jnc     @f
        mov     al,0f8h
@@:
        mov     ah, 8                   ;Cache Line Size value for Pentium
        ret
dih_pci_get_info        endp

;pci_latency_timer_table label   byte
;        db      20h, 40h, 60h, 80h, 0a0h, 0c0h, 0e0h, 0f8h


;---------------------------------------;
; dih_pci_bridge_check_disabled         ;
;---------------------------------------;--------------------------------------;
; This function is called just before enabling any PCI to PCI bridge that is   ;
; found in the system.  This function can prevent the bridge from being enabled;
; or it may change any register in the bridge before it is enabled.            ;
;                                                                              ;
; Input: BL = Device/Function number of PCI to PCI bridge                      ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of PCI to PCI bridge                                  ;
;                                                                              ;
; Output: CF = Set if device should be disabled                                ;
;              Clear if device is ok to enable/configure/etc.                  ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_pci_bridge_check_disabled   proc near
	xchg	cl,ch
	mov	di, 1Bh
	mov	ah, RT_PCI_WRITE_CFG_BYTE
	CALL_RT_FUNCTION		;Write CL to Max Lat register
        clc
        ret
dih_pci_bridge_check_disabled   endp

;---------------------------------------;
; dih_pci_get_max_io_base               ;
;---------------------------------------;--------------------------------------;
; This function is called from ALLOC_BUS_RESOURCES routine while allocating    ;
; resources for all buses. This function allows porting engineer to limit the  ;
; maximum IO base address that can be used by any PCI Bus.                     ;
;                                                                              ;
; Input:  CX = 0000 -> this indicates the max IO base address is FFFF          ;
; Output: CX = Max IO base address that can be allocated + 1                   ;
;               e.g. If maxm IO base address that can be allocated is 7FFF then;
;               the return value in CX should be 8000h                         ;
; Destroys: Should not destroy any register except CX                          ;
; NOTE:                                                                        ;
; To assign from 8000h, this can avoid many problems of network  ;
; card. In this case CX should be returned as 8000h.                           ;
; System halted when loading *.flt drivers during installation of;
; of OS/2 Warp, maxm IO base address should be limited to F800h. So in this    ;
; case, return value in CX should be F800h.                                    ;
; Deafult code is RET i.e. CX unmodified.                                      ;
;------------------------------------------------------------------------------;
dih_pci_get_max_io_base proc    near
        mov     cx,0e000h
        ret
dih_pci_get_max_io_base endp

;---------------------------------------;
; dih_disable_pci_vga_irq               ;
;---------------------------------------;--------------------------------------;
; This function is called from CONFIGURE_PCI_IRQ routine while configuring VGA ;
; devices. If no IRQ should be allocated, return with CF set else BIOS will    ;
; follow the normal path of allocating IRQ.                                    ;
;                                                                              ;
; Input: BL = Device/Function number to route IRQ to                           ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number to route IRQ to                                       ;
;        DH = IRQ level that should be routed to the device (FF means any IRQ  ;
;             may be used)                                                     ;
;        DL = PCI Int pin that the device uses                                 ;
;             (01=IntA, 02=IntB, 03=IntC, 04=IntD).                            ;
;        DI = owner_pci structure ready for calls to the Resource Manager      ;
;        SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: CF = Set if no IRQ should be allocated                               ;
;              Reset if IRQ should be allocated normally                       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
dih_disable_pci_vga_irq proc near
        pusha
        or      bh,bh
        jnz     determine_by_setup
        mov     ah, RT_PCI_LAST_ONBOARD_BUS
        CALL_RT_FUNCTION                ;AL = Last on board bus number
        jc      disable_pci_vga_irq_done
determine_by_setup:
        mov     al,Q_PCI_VGA_IRQ
        call    check_cmos_data_far
        cmp     al,1
        cmc                             ; NC/CY = allocate/don't allocate IRQ
disable_pci_vga_irq_done:
        popa
        ret
dih_disable_pci_vga_irq endp


;------------------------------------------------------------------------------;

        public  dih_check_offboard_vga
dih_check_offboard_vga:
        clc
        ret

;<<<------------------------------------;

;<<<-------------------------------------------------------------------------;
;	Auto detect AGP using local or share memory			     ;
;	step 1: Enable AGP command in bridge control of Pci-to-PCI bridge    ;
;		(offset 3eh bit 3)					     ;
;	step 2: Enable AGP device command register (offset 04h = 07)         ;
;	setp 3: Read hard trap 						     ;
;	setp 4: close all enable bit, include PtoP bridge and AGP device     ;
;----------------------------------------------------------------------------;
auto_detect_local_share:
;; step 1
	mov	bx, SIS_AGP_P2P_BUS_NUM * 100h + SIS_AGP_P2P_DEV_FUNC_NUM
        mov     di, PPB_REG_BRIDGE_CONTROL
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION
	or	cl, BC_VGA_ENABLE
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION
;; step 2
;; Get A.G.P Bridge Secondary Bus Number
	mov	di, PPB_REG_SEC_BUS_NUM
        mov     ah, RT_PCI_READ_CFG_BYTE
        CALL_RT_FUNCTION
	mov	bh,cl
	mov	bl,0			; Device 0 /Function 0
;; step 3
;; check OnChip VGA Present?
        mov     di, PCI_REG_VENDID
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION
	cmp	cx, 1039h
	jnz	short detect_share_done

        mov     di, PCI_REG_COMMAND
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION
	or	cl, CMD_BUS_MASTER + CMD_MEM_SPACE + CMD_IO_SPACE
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION
;; step 4
	call	read_hard_trap
;; step 5
	pushf
        mov     di, PCI_REG_COMMAND
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION
	and	cl, not (CMD_BUS_MASTER + CMD_MEM_SPACE + CMD_IO_SPACE)
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION

	mov	bx, SIS_AGP_P2P_BUS_NUM * 100h + SIS_AGP_P2P_DEV_FUNC_NUM
        mov     di, PPB_REG_BRIDGE_CONTROL
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION
	and	cl, not BC_VGA_ENABLE
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION
	popf
	ret
detect_share_done:
	cmp	ax,ax			; ZF = 1
	ret

read_hard_trap:
	mov	ax,0586h	; open password
	call	set_VGA_port

	mov	ah,0dh
	call	get_VGA_port
	mov	cl,al
	mov	ax,0500h	; close password
	call	set_VGA_port

	test	cl,01h
	ret

setup_share_memory:
	mov	al,08eh
	out	70h,al
	jcxz	short $+2
	jcxz	short $+2
	in	al,71h
	jcxz	short $+2
	test	al,0c0h
;; Allocate 2MB for share memory.
	mov	ch,50h
        jnz     set_share_memory_reg

	mov	al,Q_SHARE_MEMORY_SIZE
	call	check_cmos_data_far	; AL = 00 disabled, <>00 enabled
	shl	al,04h
	or	al,40h
	mov	ch,al

set_share_memory_reg:
	mov	bx, S530_BUS_NUM *100h + S530_DEV_FUNC_NUM
        mov     di, 063h
        mov     ah, RT_PCI_READ_CFG_BYTE
        CALL_RT_FUNCTION
	or	cl,ch
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------------------
;	set VGA port
;	input: ah=index	; al=data
;----------------------------------------
set_VGA_port:
	push	dx
	mov	dx,03c4h
	xchg	al,ah
	out	dx,al
	jcxz	short $+2

	inc	dx
	xchg	al,ah
	out	dx,al
	jcxz	short $+2
	pop	dx
	ret

;----------------------------------------
;	get VGA port
;	input: ah=index
;	output: al=data
;----------------------------------------
get_VGA_port:
	push	dx
	mov	dx,03c4h
	xchg	al,ah
	out	dx,al
	jcxz	short $+2

	inc	dx
	xchg	al,ah
	in	al,dx
	jcxz	short $+2
	pop	dx
	ret

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
_text   ends
        end
