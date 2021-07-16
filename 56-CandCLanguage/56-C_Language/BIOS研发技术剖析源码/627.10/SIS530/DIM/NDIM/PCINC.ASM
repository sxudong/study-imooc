        page    ,132
        title .                 PCI Non Compliant Device Initializer
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
BAD_VGA_ATTRIBUTE       EQU     00000001b; bit-0 = 1 for bad VGA device
IGNORE_BIT3_0_DEV_ID    EQU     00010000b; bit-4 = 1 ignore bit3-0 of Device ID
IGNORE_BIT7_4_DEV_ID    EQU     00100000b; bit-5 = 1 ignore bit7-4 of Device ID
;---------------------------------------;
        include dim.equ
        include devnode.equ
        include rt.equ
        include escd.equ
        include pci.equ
        include pnp.equ
;---------------------------------------;

        public configure_bad_pci_devs
        public check_bad_pci_device

;---------------------------------------;

        extrn EscdFuncNum: byte
        extrn EscdSlotNum: byte
        extrn OwnerWork: byte
        extrn bad_pci_device_flag:byte

        extrn configure_pci_irq: near
        extrn dih_pci_get_info: near
        extrn dih_pci_check_disabled:near
        extrn check_isa_vga:near

;---------------------------------------;


cgroup  group   _text
_text   segment byte public 'CODE'
        assume  cs:cgroup
.386


;---------------------------------------;
; check_bad_pci_no_disable              ;
;---------------------------------------;--------------------------------------;
; This function is called from DI-PCI func_0 just before each device is        ;
; disabled.  If the device is a non-compliant PCI device that should not be    ;
; disabled, then return with CF set.                                           ;
;                                                                              ;
; Input: ECX = Vendor/Device ID (Vendor ID in lower word, device ID in upper)  ;
;                                                                              ;
; Output: CF = Clear if OK to disable this device                              ;
;              Set if device should not be disabled                            ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;                                                                              ;
; NOTE: The difference between this function and dih_pci_prot_dev is:          ;
;       this routine will protect devices that will not function properly if   ;
;       they are disabled. But this device will get configured by the PCI code ;
;       in the normal initialisation process. For example, Tseng Lab VGA, etc. ;
;                                                                              ;
;       The function dih_pci_prot_dev is to be used to protect a device which  ;
;       should not be disabled, configured, or touched at all by the PCI code. ;
;       For example, on-board PCI chipsets Neptune, Mercury, SIS, etc.         ;
;------------------------------------------------------------------------------;
check_bad_pci_no_disable        proc near
        push    eax
        push    si

        mov     si, offset cgroup:bad_pci_no_disable_table
check_nodis_next:
        db      2eh                     ;CS:
        lodsd                           ;Get Vendor/Device ID from table
        inc     eax                     ;Check for FFFFFFFF
        clc
        jz      check_nodis_done        ;Br if at end of table
        dec     eax
        cmp     eax, ecx
        jne     check_nodis_next        ;Br if no match
        stc                             ;Do not disable device

check_nodis_done:
        pop     si
        pop     eax
        ret
check_bad_pci_no_disable        endp


;---------------------------------------;
; bad_pci_no_disable_table              ;
;---------------------------------------;--------------------------------------;
; This table contains an entry for each PCI device that should not be disabled.;
; It is used by the routine check_bad_pci_no_disable.  Each entry in the table ;
; is a dword, with the upper word containing the PCI device's ID and the lower ;
; word containing the PCI device's Vendor ID.  The table must end with a dword ;
; set to 0FFFFFFFFh.                                                           ;
;------------------------------------------------------------------------------;
bad_pci_no_disable_table:
        dd      3202100ch               ;TSENG LAB ET4000 VGA card
        dd      3207100ch               ;TSENG LAB ET4000 VGA card
	dd	05301039h		;Host Bridge for SiS 530
        dd      0FFFFFFFFh              ;End of table marker


;---------------------------------------;
; configure_bad_pci_devs                ;
;---------------------------------------;--------------------------------------;
; This function steps through the bad_pci_device_table for any devices that    ;
; may be present in the system.  If a device is found that has an entry in the ;
; table, then it is configured and the resources that the device uses are      ;
; allocated.                                                                   ;
;                                                                              ;
; Input: DS = ES = _dimdata Segment                                            ;
;        SI = Offset of the NVRam workspace (in _dimdata seg)                  ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
configure_bad_pci_devs  proc near
        pushad

        mov     bp, si

        mov     EscdFuncNum, 0          ;Make sure we don't use ESCD data
        mov     EscdSlotNum, INVALID_SLOT_NUM

;  search for the device presence in all dev# (0-1F) in func#0, Bus# 0 only

        xor     bx, bx                  ;BH = Bus#, BL  bit7-3 = Dev#
                                        ;               bit2-0 = Func#
bad_pci_continue:
        mov     ecx, 0ffffffffh         ;Init Device ID, Vendor ID
        mov     di, PCI_REG_VENDID
        mov     ah, RT_PCI_READ_CFG_DWORD
        CALL_RT_FUNCTION                ;ECX = Device ID, Vendor ID from PCI Bus
        mov     dx, cx                  ;DX = Vendor ID from PCI Bus
        shr     ecx, 16                 ;CX = Device ID from PCI Bus
        mov     di, offset cgroup:bad_pci_device_table

bad_pci_next_entry:
;  DX, CX   = Vendor ID, Device ID
;  CS:DI    = Offset of the entry in bad_pci_device_table

        cmp     byte ptr cs:[di], 0     ;Look at size of this entry
        jz      bad_pci_not_found       ;Br if no more device entry in table

        call    check_vendor_device_id  ;Vendor ID and Device ID match ?
        jnz     bad_pci_not_this_entry  ;Br if does not match

;  Vendor ID, Device ID matches with an entry in the table
;  BH, (BL) = Bus#, (device#, func#)
;  DX, CX   = Vendor ID, Device ID
;  CS:DI    = Offset of the entry in bad_pci_device_table
;  BP       = Offset of the NVRam workspace (in _dimdata seg)
;  DS = ES  = _dimdata Segment

;        extrn   dih_check_offboard_vga:near
;        call    dih_check_offboard_vga  ;12/18/96
;        jc      bad_pci_not_this_entry  ;Br if to keep it disabled..12/18/96
        call    dih_pci_check_disabled
        jc      bad_pci_not_this_entry  ;Br if device is not present

        call    init_bad_pci_device     ;Try to initialize the device

bad_pci_not_this_entry:
        movzx   ax, byte ptr cs:[di]    ;AX = length of this entry in the table
        add     di, ax                  ;ptr to next entry
        jmp     short bad_pci_next_entry

bad_pci_not_found:
        add     bl, 08h
        jnz     bad_pci_continue        ;try the next device#

        popad
        ret
;---------------------------------------; 02/14/96

configure_bad_pci_devs  endp

;---------------------------------------;
; check_vendor_device_id                ;
;---------------------------------------;--------------------------------------;
; This function finds whther the given Vendor ID and Device ID is present in   ;
; the bad_pci_device_table.                                                    ;
;                                                                              ;
; Input:  DX = Vendor ID of device                                             ;
;         CX = Device ID of device                                             ;
;         DI = Offset of the entry in bad_pci_device_table (in CS)             ;
; Output: Zero Flag Set   (ZR) means match found                               ;
;         Zero Flag ReSet (NZ) means match not found                           ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
check_vendor_device_id  proc    near

        pusha

        cmp     dx, cs:[di+1]           ;Vendor ID matches ?
        jnz     check_vendor_device_done;Br if Vendor ID does not match

; 05/15/96 Meaning of upper four bits in attribute field is different
; than how it is treated in the previous code.
;       mov     al, cs:[di+5]           ;Previous code 05/15/96 ;AL = attribute from table
;       and     ax, 00f0h               ;Previous code 05/15/96 ;Save Device ID bit info to ignore
;       shr     al, 04h                 ;Previous code 05/15/96 ;AX = bit mask to ignore in Device ID
;       not     ax                      ;Previous code 05/15/96 ;AX = AND mask for Device ID
        mov     ax,0ffffh               ;AX = AND mask for Device ID
        test    byte ptr cs:[di+5],IGNORE_BIT3_0_DEV_ID ;Ignore bits 3-0 of Device ID?
        jz      short @f                ;Br if checking bits 3-0
        and     al,0f0h                 ;Mask off bits 3-0
@@:
        test    byte ptr cs:[di+5],IGNORE_BIT7_4_DEV_ID ;Ignore bits 7-4 of Device ID?
        jz      short @f                ;Br if checking bits 7-4
        and     al,00fh                 ;Mask off bits 7-4
@@:
        mov     bx, cs:[di+3]           ;Get Device ID from table
        and     bx, ax                  ;Mask off Device ID from table
        and     ax, cx                  ;Mask off Device ID from PCI Bus
; Should compare AX with BX here.
;       cmp     ax, cx                  ;Previous code 05/15/96 ;Device ID matches ?
        cmp     ax, bx                  ;Device ID matches ?

check_vendor_device_done:
        popa
        ret

check_vendor_device_id  endp

;---------------------------------------;
; init_bad_pci_device                   ;
;---------------------------------------;--------------------------------------;
; This function configures one non-compliant PCI device using resource data    ;
; from the bad_pci_device_table.  All resources used by the device are         ;
; allocated.                                                                   ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        DX = Vendor ID of device                                              ;
;        CX = Device ID of device                                              ;
;        DI = Offset of the entry in bad_pci_device_table (in CS)              ;
;        BP = Offset of the NVRam workspace (in _dimdata seg)                  ;
;        DS = ES = _dimdata Segment                                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
init_bad_pci_device     proc near
        pushad

        mov     si, di
        push    si                      ;Save start of table entry

        mov     di, offset OwnerWork    ;Use this global as workspace
        mov     (owner_pci ptr [di]).own_pci_sig, OWNTYPE_PCI
        mov     (owner_pci ptr [di]).own_pci_bus, bh
        mov     (owner_pci ptr [di]).own_pci_devfunc, bl
        shl     ecx, 16                 ;Combine Vendor/Dev ID
        mov     cx, dx                  ;Also fills in own_pci_devid
        mov     dword ptr (owner_pci ptr [di]).own_pci_vendid, ecx
        cmp     ecx, 0140104bh          ; Buslogic SCSI Vendor/Device ID.
        jnz     @f
        mov     (owner_pci ptr [di]).own_pci_sig, OWNTYPE_ISA
@@:
        mov     (owner_pci ptr [di]).own_pci_rsvd, 0

; Allocate I/O port entries

        add     si, 7                   ;SI = ptr to # of I/O port entries
        movzx   cx, byte ptr cs:[si]    ;CX = number of I/O port entries
        inc     si                      ;SI = ptr to cfg space reg
        jcxz    bad_dev_no_ports
bad_dev_next_port:
        push    cx                      ;Save number of I/O port entries
        push    si                      ;Save ptr to cfg space reg

        inc     si                      ;SI = ptr length of I/O port block
        mov     dx, cs:[si]             ;DX = length of I/O port block
        inc     si
        inc     si                      ;SI = ptr to number of options
        movzx   cx, byte ptr cs:[si]    ;CX = number of options

        inc     si                      ;SI = ptr to 1st base addr option
bad_dev_next_p_option:

; For doing PCI compliant I/O parsing.
; The resource manager returns the allocated resource in AX, so save all
; registers besides AX on the stack.
        push    bx                      ;
        push    cx                      ;
        push    dx                      ;
        push    di                      ;
        push    si                      ;
        push    bp                      ;

        mov     cx, cs:[si]             ;CX = base addr of I/O port block
        mov     bx, cx                  ;BX also = base addr
        mov     si, 1                   ;Alignment = byte

; For doing PCI compliant I/O parsing
; If requested I/O range (CX) = 0ffffh, then treat this resource for the
; noncompliant card as a PCI compliant resource.
        cmp     cx, 0ffffh              ;PCI compliant?
        jne     short non_pci_compliant_io
        xor     bx, bx                  ;BX=Min base addr = 00000h
        mov     cx, dx                  ;CX=Size of I/O range
        dec     cx                      ;CX=Size of I/O range - 1
        not     cx                      ;CX=properly aligned max I/O address.
        mov     si, dx                  ;SI=Size of I/O range
non_pci_compliant_io:

        mov     ax, (RM_ALLOC_PORT * 100h) + RESFLAG_PORT_DECODE16
        CALL_RESMGR                     ;Call Resource Manager to allocate port

; For doing PCI compliant I/O parsing.
; The resource manager returns the allocated resource in AX, so restore all
; registers besides AX from the stack.
        pop     bp                      ;
        pop     si                      ;
        pop     di                      ;
        pop     dx                      ;
        pop     cx                      ;
        pop     bx                      ;

        jnc     bad_dev_prog_port       ;Br if alloc succeeded
        inc     si
        inc     si                      ;SI = ptr to next base addr option
        loop    bad_dev_next_p_option   ;Try all options
        pop     si                      ;Balance stack
        pop     cx
        jmp     bad_dev_conflict        ;Br if unresolvable conflict

bad_dev_prog_port:
        pop     si                      ;Restore ptr to cfg space reg
        push    di                      ;Save ptr to owner_pci struc
        movzx   di, byte ptr cs:[si]    ;DI = offset within cfg space
        movzx   ecx, ax                 ;ECX = base addr of I/O port block
        mov     ah, RT_PCI_WRITE_CFG_DWORD
        CALL_RT_FUNCTION                ;Write ECX to cfg register
        pop     di                      ;Restore ptr to owner_pci struc
        pop     cx                      ;Restore number of I/O port entries

        movzx   ax, byte ptr cs:[si+3]  ;Get option count (number of words)
        shl     ax, 1                   ;AX = number of bytes of options
        add     si, 4                   ;Add 4 bytes for fixed info
        add     si, ax                  ;Add [ax] bytes for options
                                        ;SI now ptr to next cfg space register
        loop    bad_dev_next_port
bad_dev_no_ports:

; Allocate memory entries

        movzx   cx, byte ptr cs:[si]    ;CX = number of memory entries
        inc     si                      ;SI = ptr to cfg space reg

        or      cx,cx                   ;CX = 0?
        jz      bad_dev_no_memory       ;Br if there are no memory entries

bad_dev_next_memory:
        push    cx                      ;Save number of memory entries
        push    si                      ;Save ptr to cfg space reg

        inc     si                      ;SI = ptr length of memory block
        mov     edx, cs:[si]            ;EDX = length of memory block
        add     si, 4
        movzx   cx, byte ptr cs:[si]    ;CX = number of options

        inc     si                      ;SI = ptr to 1st base addr option
bad_dev_next_m_option:
        pop     ax                      ;Get copy of ptr to base add reg
        push    ax

; For doing PCI compliant memory parsing
; The resource manager returns the allocated resource in EAX, so save all
; registers besides EAX on the stack.
        push    ebx                     ;
        push    ecx                     ;
        push    edx                     ;
        push    edi                     ;
        push    esi                     ;
        push    ebp                     ;

        mov     bx, ax                  ;BX = ptr to base add reg
        mov     ax, (RM_ALLOC_MEM * 100h) + 0   ;Assume memory is not a ROM
        mov     ecx, cs:[si]            ;ECX = base addr of memory block
        cmp     byte ptr cs:[bx], 30h
        jne     @f                      ;Br if not programming exp rom reg
        cmp     ecx, 100000h
        jb      @f                      ;Br if address is below 1MB
        or      al, RESFLAG_MEM_EXP_ROM ;Allocate memory as exp ROM to copy down
@@:
        mov     ebx, ecx                ;EBX also = base addr
        mov     esi, 1                  ;Alignment = byte

; For doing PCI compliant memory parsing
; If requested memory range (ECX) = 0ffffffffh, then treat this resource
; for the noncompliant card as a PCI compliant resource.
        cmp     ecx, 0ffffffffh         ;PCI compliant?
        jne     short non_pci_compliant_mem
        xor     ebx, ebx                ;EBX=Min base addr = 00000000h
        mov     ecx, edx                ;ECX=Size of memory range
        dec     ecx                     ;ECX=Size of memory range - 1
        not     ecx                     ;ECX=properly aligned max memory address.
        mov     esi, edx                ;ESI=Size of memory range
non_pci_compliant_mem:

        CALL_RESMGR                     ;Call Resource Manager to allocate port

; For doing PCI compliant memory parsing
; The resource manager returns the allocated resource in EAX, so restore all
; registers besides EAX from the stack.
        pop     ebp                     ;
        pop     esi                     ;
        pop     edi                     ;
        pop     edx                     ;
        pop     ecx                     ;
        pop     ebx                     ;

        jnc     bad_dev_prog_memory     ;Br if alloc succeeded
        add     si, 4                   ;SI = ptr to next base addr option
        loop    bad_dev_next_m_option   ;Try all options
        pop     si                      ;Balance stack
        pop     cx
        jmp     bad_dev_conflict        ;Br if unresolvable conflict

bad_dev_prog_memory:
        pop     si                      ;Restore ptr to cfg space reg
        push    di                      ;Save ptr to owner_pci struc
        movzx   di, byte ptr cs:[si]    ;DI = offset within cfg space
        mov     ecx, eax                ;ECX = base addr of memory block
        cmp     di, 30h
        jne     bad_dev_not_exp_rom     ;Br if not programming exp rom reg
        or      cl, 1                   ;Turn on exp rom enable bit
bad_dev_not_exp_rom:
        mov     ah, RT_PCI_WRITE_CFG_DWORD
        CALL_RT_FUNCTION                ;Write ECX to cfg register
        pop     di                      ;Restore ptr to owner_pci struc
        pop     cx                      ;Restore number of memory entries

        movzx   ax, byte ptr cs:[si+5]  ;Get option count (number of dwords)
        shl     ax, 2                   ;AX = number of bytes of options
        add     si, 6                   ;Add 6 bytes for fixed info for memory info
        add     si, ax                  ;Add [ax] bytes for options
                                        ;SI now ptr to next cfg space register

        dec     cx                      ;
        jnz     bad_dev_next_memory     ;

bad_dev_no_memory:

; Allocate IRQ entry

        pop     si
        push    si
        add     si, 6                   ;Point DI to IRQ entry
        db      2Eh                     ;CS:
        lodsb                           ;Get IRQ byte
        or      al, al

        jnz     bad_dev_irq             ;Br if device needs IRQ
        mov     di, PCI_REG_INT_LINE    ;DI=IRQ reg. (03ch)
        mov     cl, 0ffh                ;CL=Unknown/Unrouted IRQ.
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION                ;Write CL to cfg register
        jmp     short bad_dev_no_irq    ;
bad_dev_irq:

        mov     dh, al                  ;DH = IRQ needed / FF for any IRQ
        mov     dl, 1                   ;Int Pin reg value (assume INTA)
        push    si                      ;Save SI
        mov     si, bp                  ;SI = ptr to NVRam workspace
        call    configure_pci_irq       ;Returns alloc'd IRQ in CL
        pop     si                      ;Restore SI
        jnc     bad_dev_no_irq          ;Br if alloc'd IRQ ok
        jmp     bad_dev_conflict        ;Br if unresolvable conflict
bad_dev_no_irq:

        ;Finally, initialize the Max Latency and Cache Line Size registers, and
        ;then enable the device by writing to its command register.

        call    dih_pci_get_info        ;Returns AL=Latency val, AH=Cache Line

        mov     cx, ax                  ;CL = value to write to Latency reg
        mov     di, PCI_REG_LATENCY
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION                ;Write CL to Max Lat register

        xchg    cl, ch                  ;CL = value to write to Cache Ln Sz reg
        mov     di, PCI_REG_LINE_SIZE
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION                ;Write CL to Cache Line Size register

        mov     cx, STAT_RESET_ALL      ;Reset all status bits
        mov     di, PCI_REG_STATUS
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION                ;Write CX to status register

        pop     si                      ;ptr to start of bad device table
        push    si
        test    cs:byte ptr [si+5], BAD_VGA_ATTRIBUTE;VGA ?
        jz      bad_not_vga             ;Br if not

        mov     di, offset OwnerWork
        mov     ah, RM_ALLOC_STD_VGA
        CALL_RESMGR                     ;Allocate standard VGA resources

        xor     cx, cx                  ;Command register value
        test    ds:byte ptr bad_pci_device_flag, BAD_VGA_ATTRIBUTE;Any VGA already enabled ?
        jnz     bad_vga_done            ;Br if done already
        mov     ds:byte ptr bad_pci_device_flag, BAD_VGA_ATTRIBUTE
	call	check_isa_vga
        jz      short bad_vga_done
	extrn	q_pri_display_card:abs
	mov	al,q_pri_display_card
;	call	check_cmos_data_far
        db      9ah                     ; CALL FAR F000:EED5
        dw      0eed5h
        dw      0f000h
	jz	short bad_not_vga
	push	cx
	push	si
	mov	ecx, BT_DISPLAY * 100h * 100h
	sub	si,si
	mov	ah,RT_PCI_FIND_CLASS
        CALL_RT_FUNCTION
	pop	si
	pop	cx
	jc	short bad_not_vga
	or	bh,bh
	jnz	short bad_vga_done
bad_not_vga:
        mov     cx, CMD_IO_SPACE + CMD_MEM_SPACE + CMD_BUS_MASTER + CMD_SPECIAL_CYCLE + CMD_MEM_INVALIDATE + CMD_SERR
bad_vga_done:
        mov     di, PCI_REG_COMMAND
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION                ;Write CX to command register

        clc                             ;Indicate success
        jmp     short bad_dev_done

bad_dev_conflict:
        ;An unresolvable conflict has occurred, so zero out all base address
        ;registers, the exp ROM register, the Int Line register and the
        ;command register.

        mov     di, PCI_REG_FIRST_BASE_ADD
        xor     ecx, ecx                ;Write 0 to the upper half of 64 bit reg
                                        ;BH/BL has bus/device/function number
config_dev_base_clear:
        mov     ah, RT_PCI_WRITE_CFG_DWORD
        CALL_RT_FUNCTION                ;Clear base add reg
        add     di, 4                   ;Point to next base address register
        cmp     di, PCI_REG_LAST_BASE_ADD
        jbe     config_dev_base_clear   ;Br if more base address registers

        mov     di, PCI_REG_ROM_BASE_ADD
        mov     ah, RT_PCI_WRITE_CFG_DWORD
        CALL_RT_FUNCTION                ;Clear Exp ROM reg

        mov     di, PCI_REG_INT_LINE
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        CALL_RT_FUNCTION                ;Clear Int Line reg

        mov     di, PCI_REG_COMMAND
        mov     ah, RT_PCI_WRITE_CFG_WORD
        CALL_RT_FUNCTION                ;Clear command register

        mov     di, offset OwnerWork    ;Point ES:DI to owner_pci structure
        mov     ah, RM_FREE_DEVICE
        CALL_RESMGR                     ;Call ResMgr free device's resources

        stc                             ;Indicate failure

bad_dev_done:
        pop     si                      ;Get rid of ptr to table entry on stack
        popad
        ret
init_bad_pci_device     endp


;---------------------------------------;
; check_bad_pci_device                  ;
;---------------------------------------;--------------------------------------;
; This function checks the bad_pci_device_table for a given Device/Vendor ID.  ;
; If found, then the device has already been configured in static device init. ;
;                                                                              ;
; Input: BL = Device/Function number to initialize                             ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        BH = Bus number of device to initialize                               ;
;        ECX = Device/Vendor ID of device                                      ;
;                                                                              ;
; Output: CF = Set if device is a non-compliant PCI device that has already    ;
;                  been configured during static device init                   ;
;              Clear if device should be handled normally                      ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
check_bad_pci_device    proc near

        pushad                          ; pusha..BUG 12/18/96
        mov     dx, cx                  ;DX = Vendor ID from PCI Bus
        shr     ecx, 16                 ;CX = Device ID from PCI Bus
        mov     di, offset cgroup:bad_pci_device_table
check_bad_next_entry:
;  DX, CX   = Vendor ID, Device ID
;  CS:DI    = Offset of the entry in bad_pci_device_table
        cmp     byte ptr cs:[di], 0     ;Look at size of this entry
        jz      check_bad_done          ;Br if no more device entry in table
                                        ;Carry flag clear (NC)
;  DX,CX = Vendor ID, Device ID
;  CS:DI = Offset of the entry in bad_pci_device_table
        call    check_vendor_device_id  ;Vendor ID and Device ID match ?
        stc                             ;Set carry flag (CY) if match
        jz      check_bad_done          ;Br if device found in table
        movzx   ax, byte ptr cs:[di]    ;Get length of this entry
        add     di, ax                  ;CS:DI = ptr to next entry
        jmp     short check_bad_next_entry

check_bad_done:
        popad                           ; popa..BUG 12/18/96
        ret
;---------------------------------------; 02/14/96
check_bad_pci_device    endp


;---------------------------------------;
; bad_pci_device_table                  ;
;---------------------------------------;--------------------------------------;
; This table contains Vendor/Device IDs of non-compliant PCI devices and the   ;
; corresponding set of fixed resources that should be used for configuring     ;
; the device.                                                                  ;
;                                                                              ;
; The format of the table is as follows:                                       ;
;                                                                              ;
; Size     Description                                                         ;
; ----     ------------------------------------------------------------------  ;
; byte     Length of this table entry including this byte                      ;
; word     Vendor ID of PCI device                                             ;
; word     Device ID of PCI device                                             ;
; byte     Device Attribute                                                    ;
;          bit-0 = 1 Device is VGA                                             ;
;          bit3-1= Reserved for future use (set to 0)                          ;
;          bit-4 = 1 Ignore bit3-0 of Device ID                                ;
;          bit-5 = 1 Ignore bit7-4 of Device ID                                ;
;          bit7-6= Reserved for future use (set to 0)                          ;
; byte     IRQ information:                                                    ;
;              00 = device does not need an IRQ                                ;
;              01 - 0F = device must use this IRQ (1 - 15)                     ;
;              FF = device may use any IRQ                                     ;
;                                                                              ;
; byte     Number of I/O ports entries that follow                             ;
; byte     PCI config space register address                                   ;
; word     Length of I/O port block (in bytes)                                 ;
; byte     Number of base address options that follow                          ;
; word     Base address of I/O port block                                      ;
;              0 - FFFE = device must use this I/O port                        ;
;              FFFF = device may use any I/O port (PCI compliant)              ;
;                                                                              ;
; byte     Number of memory entries that follow                                ;
; byte     PCI config space register address                                   ;
; dword    Length of memory block (in bytes)                                   ;
; byte     Number of base address options that follow                          ;
; dword    Base address of memory block                                        ;
;              0 - FFFFFFFE = device must use this memory address              ;
;              FFFFFFFF = device may use any memory address (PCI compliant)    ;
;                                                                              ;
;------------------------------------------------------------------------------;
bad_pci_device_table    label byte

;;----------------------------- Tseng ET4000 VGA --------------------------------
;
et4000_vga_start:
db     offset et4000_vga_end - offset et4000_vga_start
dw     100Ch, 3207h                    ;ET4000 Vendor ID / Device ID
db     BAD_VGA_ATTRIBUTE               ;Device is VGA, ignore bit3-0 of Device ID
db     0FFh                            ;Device may use any IRQ

db     0                               ;Device uses no I/O port blocks

db     2                               ;Device uses 2 memory blocks

db     10h                             ;Base address register 0
dd     1000000h                        ;Size of memory block needed is 16M
db     4                               ;4 options for the base address
dd     7F000000h, 7E000000h, 7D000000h, 7C000000h

db     30h                             ;Expansion ROM Base address register
dd     8000h                           ;Size of memory block needed is 32k
db     1                               ;1 option for the base address
dd     80000000h

et4000_vga_end:

;;----------------------------- Tseng ET4000 VGA --------------------------------
;
et4000x_vga_start:
db     offset et4000x_vga_end - offset et4000x_vga_start
dw     100Ch, 3206h                    ;ET4000 Vendor ID / Device ID
db     BAD_VGA_ATTRIBUTE	       ;Device is VGA, ignore bit3-0 of Device ID
db     0FFh                            ;Device may use any IRQ

db     0                               ;Device uses no I/O port blocks

db     2                               ;Device uses 2 memory blocks

db     10h                             ;Base address register 0
dd     1000000h                        ;Size of memory block needed is 16M
db     4                               ;4 options for the base address
dd     7F000000h, 7E000000h, 7D000000h, 7C000000h

db     30h                             ;Expansion ROM Base address register
dd     8000h                           ;Size of memory block needed is 32k
db     2                               ;1 option for the base address
dd     80000000h,10000000h

et4000x_vga_end:
;----------------------------- Buslogic SCSI --------------------------------

buslogic_scsi_start:
db      offset buslogic_scsi_end - offset buslogic_scsi_start
dw      104bh, 0140h                    ;Buslogic SCSI Vendor ID / Device ID
db      00h                             ;Device is not VGA
db      0FFh                            ;Device may use any IRQ

db      1                               ;Device uses 1 I/O port block
db      10h                             ;Base address register 0
dw      4                               ;Size of I/O port block needed is 4 bytes
db      6                               ;6 options for the base address
dw      330h, 230h, 130h, 334h, 234h, 134h

db      1                               ;Device uses 1 memory block
db      30h                             ;Expansion ROM Base address register
dd      4000h                           ;Size of memory block needed is 16k
db      4                               ;4 options for the base address
dd      0DC000h, 0D8000h, 0D4000h, 0D0000h

buslogic_scsi_end:

; ---------------------------- CMD IDE and Forex IDE ----------------------------------
; These two IDE cards has same Vendor ID and same Device ID (How !!!!!!!!!!!!!!!!!!!!!)

forex_ide_start:
db      offset forex_ide_end - offset forex_ide_start
dw      1c1ch, 0001h                    ;Forex IDE Vendor ID / Device ID
db      00h                             ;Device is not VGA
db      0Eh                             ;Device must use IRQ 14

db      2                               ;Device uses 2 I/O port blocks
db      10h                             ;Base address register 0
dw      8                               ;Size of I/O port block needed is 8 bytes
db      1                               ;1 option for the base address
dw      1F0h
db      14h                             ;Base address register 1
dw      1                               ;Size of I/O port block needed is 1 byte
db      1                               ;1 option for the base address
dw      3F6h

db      0                               ;Device no memory blocks

forex_ide_end:

; ---------------------------- PCtech RZ1000 IDE ----------------------------------
; These two IDE cards has same Vendor ID and same Device ID (How !!!!!!!!!!!!!!!!!!!!!)

pctech_ide_start:
db      offset pctech_ide_end - offset pctech_ide_start
dw      1042h, 1000h                    ;PCTech RZ1000 IDE Vendor ID / Device ID
db      00h                             ;Device is not VGA
db      0Eh                             ;Device must use IRQ 14

db      2                               ;Device uses 2 I/O port blocks
db      10h                             ;Base address register 0
dw      8                               ;Size of I/O port block needed is 8 bytes
db      1                               ;1 option for the base address
dw      1F0h
db      14h                             ;Base address register 1
dw      1                               ;Size of I/O port block needed is 1 byte
db      1                               ;1 option for the base address
dw      3F6h

db      0                               ;Device no memory blocks

pctech_ide_end:

;------ For S3 Vision 866/868/968, S3 Diamond Vision 968 -----------------
;  S3 Vision 866/868            Vendor ID, Device ID = 5333h, 8880h
;  S3 Vision     968            Vendor ID, Device ID = 5333h, 88F0h
;  S3 Diamond Vision 968        Vendor ID, Device ID = 5333h, 88B0h

s3_868_vga_start:
db      offset s3_868_vga_end - offset s3_868_vga_start
dw      5333h, 8880h                    ;Vision 868 Vendor ID / Device ID
db      IGNORE_BIT7_4_DEV_ID+BAD_VGA_ATTRIBUTE
                                        ;Device is VGA, ignore bit7-0 of Device ID
db      0FFh                            ;Device may use any IRQ

db      0                               ;Device uses no I/O port blocks

db      2                               ;Device uses 2 memory blocks

db      10h                             ;Base address register 0
dd      4000000h                        ;Size of memory block needed is 64M
db      4                               ;4 options for the base address
dd      80000000h, 90000000h, 0A0000000h, 0B0000000h

db      30h                             ;Expansion ROM Base address register
dd      8000h                           ;Size of memory block needed is 32k
db      4                               ;4 options for the base address
dd      7F000000h, 7E000000h, 7D000000h, 7C000000h

s3_868_vga_end:

;--------------------------- C&T 65548 -----------------------------
; Added entry for C&T Flat Panel 65548 VGA Controller
ct_65548_vga_start:
db      offset ct_65548_vga_end - offset ct_65548_vga_start
dw      102ch, 00dch                    ;C&T 65548 Vendor ID / Device ID
db      BAD_VGA_ATTRIBUTE               ;Device is VGA
db      0FFh                            ;Device may use any IRQ

db      0                               ;Device uses no I/O port blocks

db      1                               ;Device uses 1 memory blocks

db      30h                             ;Expansion ROM Base address register
dd      8000h                           ;Size of memory block needed is 32k
db      2                               ;2 options for the base address
dd      21800000h, 26000000h

ct_65548_vga_end:

;--------------------------- XTEC AGX016A VGA -----------------------------
xtec_vga_start:
db      offset xtec_vga_end - offset xtec_vga_start
dw      1061h, 0001h                    ;Xtec AGX016A Vendor ID / Device ID
db      BAD_VGA_ATTRIBUTE               ;Device is VGA
db      0FFh                            ;Device may use any IRQ

db      1                               ;Device uses 1 I/O port blocks

db      10h                             ;Base address register 0
dw      100h                            ;Size of port block needed is 256 bytes
db      2                               ;4 options for the base address
dw      8000h, 8100h

db      1                               ;Device uses 1 memory blocks

db      30h                             ;Expansion ROM Base address register
dd      8000h                           ;Size of memory block needed is 32k
db      1                               ;2 options for the base address
dd      0c0000h

xtec_vga_end:

;------------------------------ End of Table ---------------------------------

db      00h     ;End of table marker

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
_text   ends
        end
