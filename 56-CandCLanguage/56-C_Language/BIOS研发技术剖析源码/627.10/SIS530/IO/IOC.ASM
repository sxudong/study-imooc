	page	,132
	title	dummy I/O module
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
;---------------------------------------;
        include dim.equ
        include devnode.equ
        include rt.equ
        include pci.equ
        include io.equ
        include escd.equ
        include mbiosmac.mac
	include sis530.equ
        include makeflag.equ	
;---------------------------------------;
        public  SiS5513IdeController
;---------------------------------------;
        extrn   get_cmos_item:near
        extrn   set_cmos_item_checksum:near
        extrn   cpu_freq:word
        extrn   read_pci_byte:near
        extrn   Q_SIS5513_IDE_CONTROLLER:abs
        extrn	Q_SIS5513_PREFETCH_PM:abs
        extrn	Q_SIS5513_PREFETCH_PS:abs
        extrn	Q_SIS5513_PREFETCH_SM:abs
        extrn	Q_SIS5513_PREFETCH_SS:abs
        extrn   ide_prim_base_addr:word
        extrn   ide_sec_base_addr:word
	extrn	get_processor_info:near
	extrn	read_ide_word:near
;---------------------------------------;


;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text segment word public USE16 'CODE'
	 assume	cs:CGROUP
.486p

;---------------------------------------;
; Peripheral Table Structure            ;
;---------------------------------------;-------------------------------------;
; This table should be the only public label defined in this file.  It        ;
; contains pointers to the peripheral module's data and functions.            ;
;-----------------------------------------------------------------------------;
SiS5513IdeController    label word

        dw PTFLAG_INVISIBLE_NODE        ;Flags (Node is invisible after boot)

        dw DevNodeData                  ;Pointer to device node data

        dw GetNodeStatic                ;Pointer to GetNodeStatic routine
        dw GetNodeDynamic               ;Pointer to GetNodeDynamic routine
        dw SetNodeStatic                ;Pointer to SetNodeStatic routine
        dw SetNodeDynamic               ;Pointer to SetNodeDynamic routine

        dw RegisterInit                 ;Pointer to RegisterInit routine
        dw GetAutoStatus                ;Pointer to GetAutoStatus routine

        dw IdeSetMode                   ;Pointer to IdeSetMode routine

        dw AdjustSetup                  ;Pointer to AdjustSetup routine
        dw IsrInstall                   ;Pointer to IsrInstall routine

        dw InitHotKey                   ;Pointer to InitHotKey routine
        dw InitBufferPrfOptimal         ;Pointer to InitBufferPrfOptimal routine
        dw InitBufferPrfFailSafe        ;Pointer to InitBufferPrfFailSafe routine

        dw DummyRet                     ;Dummy Routine for 3Mode Floppy

;---------------------------------------;
; Device Node Data                      ;
;---------------------------------------;-------------------------------------;
; This block of data forms the device node that describes the configuration   ;
; options available to this peripheral device.                                ;
;-----------------------------------------------------------------------------;
DevNodeData     label byte

;         Size     Node Number   Device ID        Fill w/ Dev/Func #   Fill w/ Bus #    IF Type              Attributes
;         -----    -----------   --------------   ------------------   --------------   ------------------   ----------------------------------------------
sd_node < NODELEN, 0,            55131039h,      0,                   0,               IF_DUAL_PCI_BM_IDE,  SDN_ATTR_DYNAMIC_CFG >
        fport_descriptor < FPORT_DESC_TAG, 000h, 0 >
        fport_descriptor < FPORT_DESC_TAG, 000h, 0 >
        irq_descriptor   < IRQ_DESC_TAG,   0000000000000000b >
        fport_descriptor < FPORT_DESC_TAG, 000h, 0 >
        fport_descriptor < FPORT_DESC_TAG, 000h, 0 >
        irq_descriptor   < IRQ_DESC_TAG,   0000000000000000b >
        port_descriptor  < PORT_DESC_TAG,  PD_FLAG_DECODE_16, 100h, 0FFF0h, 10h, 10h > ;10h ports anywhere between 100h and FFF0h
        END_OF_ALLOCATED_RESOURCES
        DEPENDENT_FUNCTION_START
                fport_descriptor < FPORT_DESC_TAG, 1F0h, 8 >            ;Port 1F0 - 1F7
                fport_descriptor < FPORT_DESC_TAG, 3F6h, 1 >            ;Port 3F6
                irq_descriptor   < IRQ_DESC_TAG,   0100000000000000b >  ;IRQ 14
                fport_descriptor < FPORT_DESC_TAG, 000h, 0 >            ;Port placeholder
                fport_descriptor < FPORT_DESC_TAG, 000h, 0 >            ;Port placeholder
                irq_descriptor   < IRQ_DESC_TAG,   0000000000000000b >  ;IRQ placeholder
                port_descriptor  < PORT_DESC_TAG,  PD_FLAG_DECODE_16, 100h, 0FFF0h, 10h, 10h > ;10h ports anywhere between 100h and FFF0h
        DEPENDENT_FUNCTION_START
                fport_descriptor < FPORT_DESC_TAG, 000h, 0 >            ;Port placeholder
                fport_descriptor < FPORT_DESC_TAG, 000h, 0 >            ;Port placeholder
                irq_descriptor   < IRQ_DESC_TAG,   0000000000000000b >  ;IRQ placeholder
                fport_descriptor < FPORT_DESC_TAG, 170h, 8 >            ;Port 170 - 177
                fport_descriptor < FPORT_DESC_TAG, 376h, 1 >            ;Port 376
                irq_descriptor   < IRQ_DESC_TAG,   1000000000000000b >  ;IRQ 15
                port_descriptor  < PORT_DESC_TAG,  PD_FLAG_DECODE_16, 100h, 0FFF0h, 10h, 10h > ;10h ports anywhere between 100h and FFF0h
        DEPENDENT_FUNCTION_START
                fport_descriptor < FPORT_DESC_TAG, 1F0h, 8 >            ;Port 1F0 - 1F7
                fport_descriptor < FPORT_DESC_TAG, 3F6h, 1 >            ;Port 3F6
                irq_descriptor   < IRQ_DESC_TAG,   0100000000000000b >  ;IRQ 14
                fport_descriptor < FPORT_DESC_TAG, 170h, 8 >            ;Port 170 - 177
                fport_descriptor < FPORT_DESC_TAG, 376h, 1 >            ;Port 376
                irq_descriptor   < IRQ_DESC_TAG,   1000000000000000b >  ;IRQ 15
                port_descriptor  < PORT_DESC_TAG,  PD_FLAG_DECODE_16, 100h, 0FFF0h, 10h, 10h > ;10h ports anywhere between 100h and FFF0h
        DEPENDENT_FUNCTION_END
        END_OF_ALTERNATE_RESOURCES
        END_OF_COMPATIBLE_DEV_IDS

NODELEN = DevNodeDataEnd - DevNodeData
DevNodeDataEnd  label byte


; Format of ConfigTableEntry
;-------------------------------------------------
ConfigTableEntry        struc
        PriAddress1     dw ?
        PriSize1        db ?
        PriAddress2     dw ?
        PriSize2        db ?
        PriIrqMask      dw ?
        SecAddress1     dw ?
        SecSize1        db ?
        SecAddress2     dw ?
        SecSize2        db ?
        SecIrqMask      dw ?
ConfigTableEntry        ends


;---------------------------------------;
; DeviceConfigTable                     ;
;---------------------------------------;-------------------------------------;
; This table contains one entry for each possible device configuration        ;
; setting.  This table is only used by routines in this file.  This table is  ;
; used in two ways:                                                           ;
;                                                                             ;
; 1. During GetNode calls the device's configuration is read from CMOS or     ;
;    hardware and the device node data must be updated with proper values.    ;
;    Because of this, each entry should contain enough information to fill in ;
;    any fields in the device node that depend on the hardware's current      ;
;    settings.                                                                ;
;                                                                             ;
; 2. During SetNode calls the caller passes in a device node structure and    ;
;    requests that the device's configuration be updated in CMOS or directly  ;
;    in hardware.  In this case the variable fields in the device node data   ;
;    will be compared with each entry in the table.  If a match is found      ;
;    the value to write to CMOS (or hardware register) should be able to be   ;
;    derived from the entry number in the table.  For this reason, it is      ;
;    advantageous to put the table in the same order as CMOS setup values.    ;
;-----------------------------------------------------------------------------;
DeviceConfigTable:

;                    PriAddress1  PriSize1  PriAddress2  PriSize2  PriIrq  SecAddress1  SecSize1  SecAddress2  SecSize2  SecIrq
;                    -----------  --------  -----------  --------  ------  -----------  --------  -----------  --------  ------
  ConfigTableEntry <    0000h,       00h,      0000h,       00h,   0000h,     0000h,       00h,      0000h,       00h,   0000h >  ;Disabled
  ConfigTableEntry <    01F0h,       08h,      03F6h,       01h,   4000h,     0000h,       00h,      0000h,       00h,   0000h >  ;Primary
  ConfigTableEntry <    0000h,       00h,      0000h,       00h,   0000h,     0170h,       08h,      0376h,       01h,   8000h >  ;Secondary
  ConfigTableEntry <    01F0h,       08h,      03F6h,       01h,   4000h,     0170h,       08h,      0376h,       01h,   8000h >  ;Both

DeviceConfigTableEnd:


;---------------------------------------;
; RegisterInitTable                     ;
;---------------------------------------;-------------------------------------;
; This table contains register numbers and values that when written to the    ;
; device, initializes it but leaves it in a state that uses no resources.     ;
; All functions on the device must be left disabled so that when a scan for   ;
; off board devices is done, this device will not be detected.                ;
;-----------------------------------------------------------------------------;
BusDevFuncTable:
        db      '$$CT'
        db      01h                     ;Chipset Init Table Version
        db      'SiS5513 IDE Dev#/Func#, Bus#', 0 ;ASCIIZ description string
        dw      offset BusDevFuncTableEnd
        db      00h                     ;Reserved for chipset use
        db      'Dev#,Func#',0
        db      'Bus#',0
BusDevFuncTableStart:
BusDevFuncNumber label word
;              Device # /
;               Func #    	Bus #
;             --------  	--------
        db    S5513_DEV_FUNC_NUM,S5513_BUS_NUM ;Bus=0  Dev=0  Func=1
BusDevFuncTableEnd:

RegisterTable:
        db      '$$CT'
        db      01h                     ;Chipset Init Table Version
        db      'SiS5513 IDE Regs Init',0;ASCIIZ description string
        dw      offset RegisterInitTableEnd
        db      00h                     ;Reserved for chipset use
        db      'Register',0
        db      'Init Value',0

RegisterInitTableStart:
;                        Power
;             Register  On Value
;             --------  --------
        db      004h,   007h            ; Disable IDE
	db	00dh,	080h		; latency timer
        db      020h,   000h            ; Set Bus Master IDE base to 40000h
        db      021h,   000h
        db      022h,   000h
        db      023h,   000h
	db	02ch,	039h
	db	02dh,	010h
	db	02eh,	013h 
	db	02fh,	055h 
        db      040h,   000h            ; Reg 40h
        db      041h,   000h            ; Reg 41h
        db      042h,   000h            ; Reg 42h
        db      043h,   000h            ; Reg 43h
        db      044h,   000h            ; Reg 44h
        db      045h,   000h            ; Reg 45h
        db      046h,   000h            ; Reg 46h
        db      047h,   000h            ; Reg 47h
        db      048h,   003h            ; Reg 47h
        db      04aH,   0e0h
        db      04bh,   000h
        db      04ch,   000h
        db      04dh,   000h
        db      04eh,   000h
        db      04fh,   000h
        db      050h,   000h
;        db      051h,   002h
;;        db      051h,   001h
;        db      052h,   00Dh

RegisterInitTableEnd:
;;       db      000h,   000h            ;Reg xxh, do not allow reg 59h
                                        ;power-on init value to be changed
RegisterInitTableEndPgm label   byte

;---------------------------------------;
; GetNodeStatic                         ;
;---------------------------------------;-------------------------------------;
; This function gets a device's configuration from CMOS.  The caller has      ;
; already copied the device node data into the caller's buffer (at DS:SI).    ;
; This function should read the node's configuration from CMOS and update     ;
; the variable fields in the node's current configuration section.  This      ;
; function is called during POST and runtime.                                 ;
;                                                                             ;
; Input:  AL = Node number                                                    ;
;         DS:SI = Pointer to the node                                         ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CF = Set if error getting node, clear if no error                   ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
GetNodeStatic   proc near private
        push	ax
        mov     al, Q_SIS5513_IDE_CONTROLLER
        call    get_cmos_item           ;AL=0/1/2/3 for Disabled/Pri/Sec/Both

        call    ConfigNumberToNodeData  ;Move proper values into node data

        pop	ax
        clc
        ret
GetNodeStatic   endp


;---------------------------------------;
; GetNodeDynamic                        ;
;---------------------------------------;-------------------------------------;
; This function gets a device's configuration directly from hardware.  The    ;
; caller has already copied the device node data into the caller's buffer     ;
; (at DS:SI).  This function should read hardware registers and update        ;
; the variable fields in the node's current configuration section.  This      ;
; function is called during POST and runtime.                                 ;
;                                                                             ;
; Input:  AL = Node number                                                    ;
;         DS:SI = Pointer to the node                                         ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CF = Set if error getting node, clear if no error                   ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
GetNodeDynamic  proc near private
        push	ax
	push	bx
	push	cx
	push	di
        call    GetHardwareConfig       ;AL = Entry # in DeviceConfigTable
        call    ConfigNumberToNodeData  ;Move proper values into node data
;-----< 03/04/96 Debug >----------------;
        or      al, al
        jz      GetNodeDymDone          ;Br if both channels are disabled

        mov     bx, word ptr cs:BusDevFuncNumber ;BX = IDE Bus/Dev/Func#
        mov     di, 20h                 ;DI = IDE Register 20 (BA4)
        mov     ah, RT_PCI_READ_CFG_WORD
        CALL_RT_FUNCTION                ;CX = IDE Bus master reg base addr
        and     cx, 0FFFCh              ;Mask off reserved bits

        mov     (DualBmIdeDevNodeData ptr [si]).BusPort.pdes_min_base, cx
        mov     (DualBmIdeDevNodeData ptr [si]).BusPort.pdes_max_base, cx
        mov     (DualBmIdeDevNodeData ptr [si]).BusPort.pdes_length, 10h
;---------------------------------------;
GetNodeDymDone:
	pop	di
	pop	cx
	pop	bx
	pop	ax
        clc
        ret
GetNodeDynamic  endp


;---------------------------------------;
; SetNodeStatic                         ;
;---------------------------------------;-------------------------------------;
; This function sets a device's configuration in CMOS.  This function is      ;
; called only during runtime.                                                 ;
;                                                                             ;
; Input:  AL = Node number                                                    ;
;         DS:SI = Pointer to the node                                         ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CF = Set if error setting node, clear if no error                   ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
SetNodeStatic   proc near private
        push	ax
	push	dx

        call    NodeDataToConfigNumber  ;AL = Entry # in DeviceConfigTable
        jc      SetNodeDone             ;Br if invalid config was requested

        mov     ah, al                  ;AH=0/1/2/3 for Disabled/Pri/Sec/Both
        mov     al, Q_SIS5513_IDE_CONTROLLER
        call    set_cmos_item_checksum
        clc

SetNodeDone:
        pop	dx
	pop	ax
        ret
SetNodeStatic   endp


;---------------------------------------;
; SetNodeDynamic                        ;
;---------------------------------------;-------------------------------------;
; This function sets a device's configuration directly into hardware.  This   ;
; function is called during POST and runtime.                                 ;
;                                                                             ;
; Input:  AL = Node number                                                    ;
;         DS:SI = Pointer to the node data                                    ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CF = Set if error setting node, clear if no error                   ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
SetNodeDynamic  proc near private
        push	ax
	push	bx
	push	dx

        call    NodeDataToConfigNumber  ;AL = Entry # in DeviceConfigTable
        jc      SetNodeDone             ;Br if invalid config was requested
        call    SetHardwareConfig       ;Configure device to requested setting

SetNodeDone:
        pop	dx
	pop	bx
	pop	ax
        ret
SetNodeDynamic  endp


;---------------------------------------;
; RegisterInit                          ;
;---------------------------------------;-------------------------------------;
; This function initializes the peripheral chip's registers to power on       ;
; defaults and prepares the chip for configuration.  The device should be     ;
; disabled so it is not detected as an off board device.                      ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
RegisterInit    proc near private
        pusha
        pushf                           ;Save CLI/STI state
        cli

;  init register present in the BCP modifiable table

        mov     si, offset cgroup:RegisterInitTableStart
        mov     dx, (offset cgroup:RegisterInitTableEndPgm - offset cgroup:RegisterInitTableStart) / 2
reg_init_next:
	lods	cgroup:word ptr [si]	;AL=reg.  AH=power on value
	movzx	di, al
	mov	cl, ah
	mov	bx, word ptr cs:BusDevFuncNumber
	mov	ah, RT_PCI_WRITE_CFG_BYTE
	CALL_RT_FUNCTION		;Write CL to register DI
        dec     dx
        jnz     reg_init_next           ;Br if more registers to be inited
        popf                            ;Restore CLI/STI state
        popa
        ret
RegisterInit    endp


;---------------------------------------;
; GetAutoStatus                         ;
;---------------------------------------;-------------------------------------;
; This function reports if a peripheral chip device is set to auto or manual  ;
; in CMOS.                                                                    ;
;                                                                             ;
; Input:  AL = Node number                                                    ;
;         Stack available                                                     ;
;                                                                             ;
; Output: AL = 0 If device is set to AUTO mode in CMOS                        ;
;              1 If device is set to MANUAL mode in CMOS                      ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
GetAutoStatus   proc near private
;        mov     al, Q_SIS5513_IDE_CONTROLLER
;        call    get_cmos_item           ;AL=0/1/2/3/4 for AUTO/Disabled/Pri/Sec/Both
;        jz      GetAutoDone             ;Br if set to auto
        mov     al, 1                   ;Return manual value
;GetAutoDone:
        ret
GetAutoStatus   endp

;---------------------------------------;
; IdeSetMode                            ;
;---------------------------------------;-------------------------------------;
; This routine programs an peripheral IDE controller to operate a given PIO   ;
; mode.  This routine should examine the base address, and/or PCI bus/dev/func;
; number that is passed in and take action only if the call is for the device ;
; that this routine is controlling (return CF clear).  If this call is not    ;
; for this device, just return with carry set.                                ;
;                                                                             ;
; Input:  BL = PIO mode to program                                            ;
;         BH = 80h: If programming master drive                               ;
;              81h: If programming slave drive                                ;
;	 EBX = Bit31 0/1 -> ATA/ATAPI Device				      ;
;	       Bit30-16.....Reserved (set to 0)				      ;
;         DI = Base I/O port address of controller to program (1F0h,170h,...) ;
;         SI = PCI bus/device/function number of controller to program        ;
;         DX = Controller's bus master I/O port base address                  ;
;	 ECX = Bit31-24 Sync DMA information				      ;
;	  		00000000: Drive does not support DMA                  ;
;			01000nnn: Sync DMA mode, nnn = mode value             ;
;	       Bit15-8	(CH) Non-Sync DMA information                         ;
;			00000000: Drive does not support DMA                  ;
;			00010nnn: Singleword DMA mode, nnn = mode value       ;
;			00100nnn: Multiword  DMA mode, nnn = mode value       ;
;              Bit7-0   (CL) IORDY information                                ;
;			00h: If drive does not support IORDY                  ;
;			FFh: If drive supports IORDY                          ;
;         CF = Set so dummy routines may just return                          ;
;                                                                             ;
; Output: BL = PIO mode actually programmed                                   ;
;         CL = 00h: If host does not support IORDY                            ;
;              FFh: If host supports IORDY                                    ;
;	  CH = updated DMA information                                        ;
;	       00000000: If DMA should not be used                            ;
;	       00010nnn: Singleword Non-Sync DMA mode, nnn = mode value       ;
;	       00100nnn: Multiword  Non-Sync DMA mode, nnn = mode value       ;
;	       01000nnn: Sync DMA mode, nnn = mode value                      ;
;         CF = Clear if call was for this device                              ;
;              Set if call was not for this device                            ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IdeSetMode      proc near private
        push    bp
        push    di
        push    esi
        push    edx
        push    eax

;  check for VendorID and DeviceID for BusDevFuncNumber to be same as SiS5513..

;  check for PCI IDE enabled..
        mov     ah, 04h                 ; command byte
        call    read_bcp_config_reg
        test    al, 01h                 ; enabled ?
        jz      SetModeNotForMe         ;Br if not for this device
;  check the base address..
        mov     al, 00h                 ;AL = 00 for primary master (PM)
        cmp     di, cs:ide_prim_base_addr
        jz      SetModePrimarySecondary ;Br if primary controller
        cmp     di, cs:ide_sec_base_addr
        jnz     SetModeNotForMe         ;Br if not for this device
        mov     al, 02h                 ;AL = 02 for secondary master (SM)
SetModePrimarySecondary:
        cmp     bl, 04h                 ;maxm PIO mode = 4
        jbe     SetGivenModeOk
        mov     bl, 04h                 ;force PIO mode 4
SetGivenModeOk:
        push    bx
        and     bh, 01h
        add     bh, al                  ;BH = 0/1/2/3 for PM/PS/SM/SS
        mov     dl, bh                  ;DL = 0/1/2/3 for PM/PS/SM/SS
        pop     bx                      ;BL = mode to be programmed
	call    program_pio_timing_values
	call	program_ultra_dma
SetModeDone:
        clc
        mov     cl, 0ffh                ;CL = FF, Host supports IORDY
SetModeDoneErr:
        pop     eax
        pop     edx
        pop     esi
        pop     di
        pop     bp
        ret

SetModeNotForMe:
        xor     cx, cx                  ;CH = 00, no DMA, CL = 00, host does not support IORDY
        stc
        jmp     short SetModeDoneErr

IdeSetMode      endp


;-------------------------------;
; PROGRAM_PIO_TIMING_VALUES     ; CHIPSET SPECIFIC CODE
;-------------------------------;---------------------------------------;
; This routine must program the PIO mode paramters.                     ;
; input :                                                               ;
;       BL = PIO mode to be programmed                                  ;
;       DL = 0 for Primary Master.                                      ;
;            1 for Primary Slave.                                       ;
;            2 for Secondary Master.                                    ;
;            3 for Secondary Slave.                                     ;
;	ebx.31=cdrom or hard
;	ecx=31...24
;       stack   available                                               ;
; output:                                                               ;
;       None. PIO mode is programmed                                    ;
; register usage -- No registers destroyed.                             ;
;-----------------------------------------------------------------------;
; For 33 Mhz PCI Clock - These values will also work for 25Mhz PCI Clock;
; --------------------                                                  ;
; Mode          Active Time     Recovery Time                           ;
; ----          -----------     -------------                           ;
; 4             3 PCICLK        1 PCICLK                                ;
; 3             3 PCICLK        3 PCICLK                                ;
; 2             6 PCICLK        8 PCICLK                                ;
; 1             6 PCICLK        10 PCICLK                               ;
; 0             8 PCICLK        12 PCICLK                               ;
;                                                                       ;
; Table for Advanced PIO mode timing values for Onboard PCI IDE.        ;
; Note : If this table is read as a word value, the Recovery Time will  ;
; come in the high byte and the Active Time will come in the low byte.  ;
;COMMENT %
advanced_pio_mode_timing_table_66  label   byte                            ;
;;              Active Time     Recovery Time   Mode of Drive           ;
        db      000b,           0000b           ; Mode 0                ;
        db      110b,           0111b           ; Mode 1                ;
        db      100b,           0100b           ; Mode 2                ;
        db      011b,           0011b           ; Mode 3                ;
        db      011b,           0001b	;0011b           ; Mode 4                ;
        db      011b,           0001b           ; Mode 5                ;
;;%
;;-------------------------------;                                       ;
;; For above 33 Mhz PCI Clock.                                           ;
;; --------------------------                                            ;
;; Currently, the PCI Bus Clock cannot be auto detected. Once this is    ;
;; possible, the Timing values will have to be programmed automatically. ;
;; Currently the values are being programmed for 33Mhz.                  ;
;; Mode          Active Time     Recovery Time                           ;
;; ----          -----------     -------------                           ;
;; 4             4 PCICLK        4 PCICLK                                ;
;; 3             4 PCICLK        4 PCICLK                                ;
;; 2             6 PCICLK        10 PCICLK                               ;
;; 1             8 PCICLK        12 PCICLK                               ;
;; 0             8 PCICLK        12 PCICLK                               ;
;;                                                                       ;
;; Table for Advanced PIO mode timing values for Onboard PCI IDE.        ;
;; Note : If this table is read as a word value, the Recovery Time will  ;
;; come in the high byte and the Active Time will come in the low byte.  ;
;;COMMENT %
;advanced_pio_mode_timing_table_75  label   byte
;;;                Active Time     Recovery Time   Mode of Drive           ;
;        db      000b,           0000b           ; Mode 0                ;
;        db      000b,           0000b           ; Mode 1                ;
;;        db      111b,           1011b           ; Mode 2                ;
;;        db      101b,           0101b           ; Mode 3                ;
;;        db      101b,           0101b           ; Mode 4                ;
;;	db	101b,		0101b		; Mode 5 Hogan debug
;        db      110b,           1010b           ; Mode 2                ;
;        db      100b,           0100b           ; Mode 3                ;
;        db      100b,           0100b           ; Mode 4                ;
;	db	100b,		0100b		; Mode 5 Hogan debug
;;%
;-------------------------------;                                       ;
; Table for Programming Recovery Time Control.                          ;
; Note : It is assumed that the Active Time Control Register is         ;
; the register following the Recover Time Control Register.             ;
onboard_pci_ide_timing_registers        label   byte                    ;
        db      40h             ; For Primary Master                    ;
        db      42h             ; For Primary Slave                     ;
        db      44h             ; For Secondary Master                  ;
        db      46h             ; For Secondary Slave                   ;
;-----------------------------------------------------------------------;
program_pio_timing_values :
.386p
; SiS-551x BIOS - Chipset Bug in Revision A1.
; If this code is included, the Int-19 loader is unable to give control
; to the Operating System. This is happening with the IDE driver provided
; by SiS too. If the driver is loaded and Int-19 is issued, the System
; hangs. Therefore, currently a return has been put at the beginning.

        pusha

        push	ebx			; Save Mode value.
        xor     bh, bh
        shl     bx, 1                   ; Get mode * 2

;;==========     hogan add for differ PIO timing
;	pushad
;        call    get_processor_info
;	cmp     bl,1
;	jne     pio_66			;not CYRIX
;	mov	ax,cgroup:cpu_freq
;	cmp 	ax,85h			;<= 133MHZ
;	jbe	pio_66
;	popad
;        mov     bx, word ptr cs:advanced_pio_mode_timing_table_75[bx]
;	jmp     pio_assign
;pio_66:
;	popad
	mov     bx, word ptr cs:advanced_pio_mode_timing_table_66[bx]
pio_assign:
;;====================================================================


; bh = recovery time, bl = active time.
        movzx   si, dl                  ; SI = Hard disk table index.
        mov     ah, byte ptr cs:onboard_pci_ide_timing_registers[si] ; ah = reg#
        mov     al, bh                  ; al = Recovery time.
        call    write_bcp_config_reg
        inc     ah
        mov     al, bl                  ; al = Active time
        call    write_bcp_config_reg
	pop	ebx			; Restore Mode value = BX.

;; for A3 stepping
	push	ax
	mov	ah,08h			; chipset Revision
	call	read_pci_byte
	xor	ah,ah
	cmp	al,02
	pop	ax
	ja	short cdrom_a3_normal
	test	ebx,80000000h		; CDROM
 	jnz	no_prefetch
cdrom_a3_normal:

;	test	ecx,40000000h		; when sync DMA mode then no prefetch
;	jnz	no_prefetch

	movzx   ax, dl                  ;Dl = 0/1/2/3 for PM/PS/SM/SS
	cmp     dl,0			;Dl = 0/1/2/3 for PM/PS/SM/SS
	jne     @f
        mov     al, Q_SIS5513_PREFETCH_PM
        call    get_cmos_item
	jmp	get_channel
@@:
	cmp	dl,1
	jne     @f
        mov     al, Q_SIS5513_PREFETCH_PS
        call    get_cmos_item
	jmp	get_channel
@@:
	cmp	dl,2
	jne     @f
        mov     al, Q_SIS5513_PREFETCH_SM
        call    get_cmos_item
	jmp	get_channel
@@:
	cmp 	dl,3
	jne     @f
        mov     al, Q_SIS5513_PREFETCH_SS
        call    get_cmos_item
@@:
get_channel:
	jz	@f
;	mov	cl,al
	mov	cl,dl
;; disable prefetch/postwrite if A3 stepping
;        mov	ah, 011h		; enable prefetch / postwrite
	mov	ah,08h			; chipset Revision
	call	read_pci_byte
	xor	ah,ah
	cmp	al,02
	ja	short stepping_a3
enable_postwrite:
        mov	ah, 011h		; eable prefetch / postwrite
stepping_a3:
	shl	ah,cl
	mov	cl,ah

	mov	ah,04bh
	call	read_bcp_config_reg
	or	al, cl
	call	write_bcp_config_reg
@@:
; for A3 stepping
	jmp	program_channel_done
;; for A3 stepping
no_prefetch:
	cmp	dl,2			; dl = 0/1/2/3 PM/PS/SM/SS
	jnc	secondry_channel	; jmp if SM or SS
	mov	ah,04bh			
	call	read_bcp_config_reg
	cmp	dl,1
	jz	primary_slave
	and	al, not	11h
	jmp	short @f		
primary_slave:
	and	al, not 22h		
@@:
	call	write_bcp_config_reg
	jmp	program_channel_done	
secondry_channel:
	mov	ah,04bh
	call	read_bcp_config_reg
	cmp	dl,3
	jz	secondry_slave
	and	al, not	44h
	jmp	short @f		
secondry_slave:
	and	al, not 88h		
@@:
	call	write_bcp_config_reg
program_channel_done:

; Enable Prefetch count of primary or secondary channel.
        mov     ah, 4ch                 ; Assume primary channel.
        cmp     dl, 2                   ; Primary channel ?
        jb      put_prefetch_depth_count
        mov     ah, 4eh                 ; Secondary channel.
put_prefetch_depth_count :
; AH = PCI_IDE_DEVICE_FUNC_NUMBER.
        xor     al, al                  ; prefetch count (low) = 0
        call    write_bcp_config_reg
        inc     ah                      ; next reg#
        mov     al, 02h                 ; prefetch count (low) = 0
        call    write_bcp_config_reg
;
	popa
        ret


;-------------------------------;
; program_ultra_dma		; CHIPSET SPECIFIC CODE
;-------------------------------;---------------------------------------;
; This routine must program the Ultra DMA/33 mode paramters.            ;
; input :                                                               ;
;       BL = PIO mode to be programmed                                  ;
;       DL = 0 for Primary Master.                                      ;
;            1 for Primary Slave.                                       ;
;            2 for Secondary Master.                                    ;
;            3 for Secondary Slave.                                     ;
;	ebx.31=cdrom or hard
;	ecx=31...24
;       stack   available                                               ;
; output:                                                               ;
;	  CH = updated DMA information                                        ;
;	       00000000: If DMA should not be used                            ;
;	       00010nnn: Singleword Non-Sync DMA mode, nnn = mode value       ;
;	       00100nnn: Multiword  Non-Sync DMA mode, nnn = mode value       ;
;	       01000nnn: Sync DMA mode, nnn = mode value                      ;
;       None. PIO mode is programmed                                    ;
; register usage --  cx				                        ;
;-----------------------------------------------------------------------;
advanced_udma_mode_timing_table  label   byte
        db      1111b			; mode 0      
        db      1101b      		; mode 1
        db      1011b      		; mode 2
        db      1010b      		; mode 3
        db      1001b      		; mode 4

program_ultra_dma:
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi

	shr	ecx,16
	test    ch,01000000b
	jz	no_ultra_DMA

;;------------------------------------;;
;; prevent DMA/66 using 40 pins cable ;;
;; IDE register 48h bit 4 : channel 0 ;;
;; IDE register 48h bit 5 : channel 1 ;;
;; If register value = 1 : 40pin cable;;
;; 		     = 0 : 80pin cable;;
;;------------------------------------;;
	and	dl,03h
	cmp	dl,01h
	mov	bl,00010000b
	jbe	@f
	shl	bl,01h
@@:
	mov	ah,48h
	call	read_bcp_config_reg
	test	al,bl
	jz	@f
	and	ch,not 07h		;; clear UDMA mode value
	or	ch,02h			;; set UDMA value 2
@@:
;;------------------------------------;;

	mov	bl,ch
  	and	bl,00000111b
  	xor	bh,bh
;	xor	bl,00000011b		; mode2 10->chipset65 01
;	shl	bl,5			; mode1 01->chipset65 10
;	or	bl,10000000b		; mode0 00->chipset65 11
;        movzx   si, dl                  ; SI = Hard disk table index.
        mov     bx, word ptr cs:advanced_udma_mode_timing_table[bx]
        shl	bx,4
        movzx     si, dl
        mov     ah, byte ptr cs:onboard_pci_ide_timing_registers[si] ; ah = reg#
	inc	ah
	call	read_bcp_config_reg
	or	al, bl
	call	write_bcp_config_reg

no_ultra_DMA:
	pop	esi
	pop	edx
	mov	bx,cx
	pop	ecx
	mov	cx,bx
	pop	ebx
	pop	eax
	ret

;-----------------------------------------------------------------------;

;---------------------------------------;
; Input: ah = register#
;        al = data to be written
;        word ptr cs:BusDevFuncNumber = Bus/Dev/Func#
; Registers destroyed:  None
;---------------------------------------;
write_bcp_config_reg:

        push    di
        push    cx
        push    bx
        push    ax
        movzx   di, ah                  ; DI = reg#
        mov     bx, word ptr cs:BusDevFuncNumber ;BX = SiS5513 IDE Bus/Dev/Func#
        mov     ah, RT_PCI_WRITE_CFG_BYTE
        mov     cl, al                  ; CL = data to be written
        CALL_RT_FUNCTION
        pop     ax
        pop     bx
        pop     cx
        pop     di
        ret

;---------------------------------------;
; Input:  ah = register#
;         word ptr cs:BusDevFuncNumber = Bus/Dev/Func#
; Output: al = data read
; Registers destroyed:  None
;---------------------------------------;
read_bcp_config_reg:
        push    di
        push    cx
        push    bx
        push    ax
        movzx   di, ah                  ; DI = reg#
        mov     bx, word ptr cs:BusDevFuncNumber ;BX = SiS5513 IDE Bus/Dev/Func#
        mov     ah, RT_PCI_READ_CFG_BYTE
        CALL_RT_FUNCTION
        pop     ax                      ; restore AH
        mov     al, cl                  ; AL = data read
        pop     bx
        pop     cx
        pop     di
        ret


;---------------------------------------;
; AdjustSetup                           ;
;---------------------------------------;-------------------------------------;
; This routine programs any peripheral chip specific parameters which need to ;
; be programmed after SETUP e.g. Serial Port FIFO enable, Parallel Port       ;
; Direction, etc.  Please note that before setup, these parameters should be  ;
; set to disabled (normal) setting.  This routine is called from ADJUST_SETUP ;
; hook in PC1.ASM file.                                                       ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
        extrn   check_cmos_data:near
AdjustSetup     proc near private
        ret
AdjustSetup     endp


;---------------------------------------;
; IsrInstall                            ;
;---------------------------------------;-------------------------------------;
; This routine may hook any interrupt vector.  This hook will be called only  ;
; when the BIOS is running from RAM, so any old vector address may be saved   ;
; in the code segment for chaining.                                           ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IsrInstall      proc near private
        ret
IsrInstall      endp


;---------------------------------------;
; InitHotKey                            ;
;---------------------------------------;-------------------------------------;
; This routine can be used to do any peripheral programming after hot key     ;
; setup is run and system does not need to reboot. this routine is called     ;
; from HOT_KEY_ADJUST_SETUP.                                                  ;
;                                                                             ;
; Input:  Pointer to _old_cmos_buffer and _common_cmos_buffer ?.............. ;
;         DS = Segment of _old_cmos_buffer and _common_cmos_buffer            ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
InitHotKey      proc near private
        ret
InitHotKey      endp


;---------------------------------------;
; InitBufferPrfOptimal                  ;
;---------------------------------------;-------------------------------------;
; This routine can be used to update _common_cmos_buffer in peripheral setup  ;
; screen when user loads optimal values.  This routine is called from         ;
; CMOS_SETUP.                                                                 ;
;                                                                             ;
; Input:  Pointer to _common_cmos_buffer ?.................                   ;
;         DS = ES = Segment of _common_cmos_buffer                            ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
InitBufferPrfOptimal    proc near private
        ret
InitBufferPrfOptimal    endp


;---------------------------------------;
; InitBufferPrfFailSafe                 ;
;---------------------------------------;-------------------------------------;
; This routine can be used to update _common_cmos_buffer in peripheral setup  ;
; screen when user loads fail safe values.  This routine is called from       ;
; CMOS_SETUP.                                                                 ;
;                                                                             ;
; Input:  Pointer to _common_cmos_buffer ?.................                   ;
;         DS = ES = Segment of _common_cmos_buffer                            ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
InitBufferPrfFailSafe   proc near private
        ret
InitBufferPrfFailSafe   endp

;---------------------------------------;
; GetHardwareConfig                     ;
;---------------------------------------;-------------------------------------;
; This routine determines the current configuration of the peripheral device  ;
; by reading directly from its registers.  The value returned is an entry     ;
; number in the DeviceConfigTable.                                            ;
;                                                                             ;
;   Value Read     Value Read                                                 ;
;   From           From             Entry # in       Config                   ;
;   Reg 4A:2       Reg 4A:1      DeviceConfigTable   Setting                  ;
;  ------------   ------------   -----------------   --------                 ;
;       0              0                 0           Disabled                 ;
;       0              1                 1           Primary                  ;
;       1              0                 2           Secondary                ;
;       1              1                 3           Both                     ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: AL = Entry number in DeviceConfigTable that represents the current  ;
;              configuration of the peripheral device.                        ;
;                                                                             ;
; Destroys: AH                                                   ;
;-----------------------------------------------------------------------------;
GetHardwareConfig       proc near private

; First check if IDE has been disabled by writting 0 to RX04
        mov     ah, 04h
        call    read_bcp_config_reg
        and     al, 07h                 ; Disabled ?
        jz      ghc_exit                ; Yes.. AL = 0

        mov     ah, 4ah
        call    read_bcp_config_reg
        and     al, 00000110b           ; Keep bit2,1
        shr     al, 1                   ; Right adjustified

ghc_exit:
        ret
GetHardwareConfig       endp


;---------------------------------------;
; SetHardwareConfig                     ;
;---------------------------------------;-------------------------------------;
; This routine sets the current configuration of the peripheral device by     ;
; writing directly to its registers.                                          ;
;                                                                             ;
;                       Value Read     Value Read                             ;
;      Entry # in       From           From          Config                   ;
;   DeviceConfigTable   Reg 4A:2       Reg 4A:1      Setting                  ;
;  ------------------   -----------   ------------   --------                 ;
;           0               0              0         Disabled                 ;
;           1               0              1         Primary                  ;
;           2               1              0         Secondary                ;
;           3               1              1         Both                     ;
;                                                                             ;
; Input:  AL = Entry number in DeviceConfigTable                              ;
;         DS:SI = Pointer to the node data                                    ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: AX, BX                                               	;
;-----------------------------------------------------------------------------;
SetHardwareConfig       proc near private

	push	ax
	push	ax
	push	ecx
	push	di

	mov	bx, word ptr cs:BusDevFuncNumber ;BX = IDE Bus/Dev/Func#
	movzx	ecx, (DualBmIdeDevNodeData ptr [si]).PriPort1.fpdes_base
	mov	di, 10h
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to IDE Reg 10h

	mov	cx,(DualBmIdeDevNodeData ptr [si]).PriPort2.fpdes_base
	mov	di, 14h
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to IDE Reg 14h

	mov	cx, (DualBmIdeDevNodeData ptr [si]).SecPort1.fpdes_base
	mov	di, 18h
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to IDE Reg 18h

	mov	cx,(DualBmIdeDevNodeData ptr [si]).SecPort2.fpdes_base
	mov	di, 1ch
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to IDE Reg 1ch

	mov	cx, (DualBmIdeDevNodeData ptr [si]).BusPort.pdes_min_base
	mov	di, 20h			;DI = IDE Register 20 (BA4)
	mov	ah, RT_PCI_WRITE_CFG_DWORD
	CALL_RT_FUNCTION		;Write ECX to IDE Reg 20h


	pop	di
	pop	ecx
	pop	bx

	mov	bh, 05h

        or      bl,bl                   ; to be disabled ?
        jnz     enable_5513             ; no..
	mov	bh, 0
enable_5513:
;program_channels
; BL = input value of AL
        shl     bl, 1                   ; shift to bit1,2

        mov     ah, 4ah
        call    read_bcp_config_reg
        and     al, 11111001b
        or      al, bl
        call    write_bcp_config_reg

; enable ide globally in configuration space
        mov     ah, 04h
        call    read_bcp_config_reg
	and	al, not 07h
        or      al, bh                
        call    write_bcp_config_reg
	
	pop	ax
	
	or	ax,ax
	jz	short @f
;; for slove NT problem
	pusha
	mov	dx, (DualBmIdeDevNodeData ptr [si]).BusPort.pdes_min_base
	and	dl,0f0h
	add	dx,2			; Primary offset 02h
	in	al,dx
	jmp	short $+2
	or	al,60h
	jmp	short $+2
	out	dx,al
	
	add	dx,8			; Secondary offset 0ah
	in	al,dx
	jmp	short $+2
	or	al,60h
	jmp	short $+2
	out	dx,al
	popa
@@:
        ret
SetHardwareConfig       endp


;---------------------------------------;
; ConfigNumberToNodeData                ;
;---------------------------------------;-------------------------------------;
; This routine copies data from the given ConfigTableEntry into the proper    ;
; fields in the node's resource descriptors.                                  ;
;                                                                             ;
; Input:  AL = Entry number in DeviceConfigTable                              ;
;         DS:SI = Pointer to buffer containing node structure                 ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
ConfigNumberToNodeData  proc near private
        pusha

        mov     bl, size ConfigTableEntry
        mul     bl                      ;AX = <entry # (AL)> * <entry size>
        mov     bx, offset DeviceConfigTable
        add     bx, ax                  ;BX = proper ConfigTableEntry

        ;Copy fields from the given ConfigTableEntry into the device node
        ;before it is returned to the caller.

        mov     ax, (ConfigTableEntry ptr cs:[bx]).PriAddress1
        mov     (DualBmIdeDevNodeData ptr [si]).PriPort1.fpdes_base, ax
        mov     al, (ConfigTableEntry ptr cs:[bx]).PriSize1
        mov     (DualBmIdeDevNodeData ptr [si]).PriPort1.fpdes_length, al

        mov     ax, (ConfigTableEntry ptr cs:[bx]).PriAddress2
        mov     (DualBmIdeDevNodeData ptr [si]).PriPort2.fpdes_base, ax
        mov     al, (ConfigTableEntry ptr cs:[bx]).PriSize2
        mov     (DualBmIdeDevNodeData ptr [si]).PriPort2.fpdes_length, al

        mov     ax, (ConfigTableEntry ptr cs:[bx]).PriIrqMask
        mov     (DualBmIdeDevNodeData ptr [si]).PriIrq.ides_irq_mask, ax

        mov     ax, (ConfigTableEntry ptr cs:[bx]).SecAddress1
        mov     (DualBmIdeDevNodeData ptr [si]).SecPort1.fpdes_base, ax
        mov     al, (ConfigTableEntry ptr cs:[bx]).SecSize1
        mov     (DualBmIdeDevNodeData ptr [si]).SecPort1.fpdes_length, al

        mov     ax, (ConfigTableEntry ptr cs:[bx]).SecAddress2
        mov     (DualBmIdeDevNodeData ptr [si]).SecPort2.fpdes_base, ax
        mov     al, (ConfigTableEntry ptr cs:[bx]).SecSize2
        mov     (DualBmIdeDevNodeData ptr [si]).SecPort2.fpdes_length, al

        mov     ax, (ConfigTableEntry ptr cs:[bx]).SecIrqMask
        mov     (DualBmIdeDevNodeData ptr [si]).SecIrq.ides_irq_mask, ax

        ;The BIOS's resource manager needs to know the PCI bus/dev/func number
        ;of this PCI device so we must embed this data somewhere in the node.
        ;Stuff the device's PCI bus/dev/func number into the base and sub type
        ;fields of the device node.  This is ok because this node is only
        ;visible during POST and is invisible once the system boots.

        mov     bx, word ptr cs:BusDevFuncNumber ;BX = PIIX IDE Bus/Dev/Func#
        mov     (DualBmIdeDevNodeData ptr [si]).NodeData.sdn_base_type, bl
        mov     (DualBmIdeDevNodeData ptr [si]).NodeData.sdn_sub_type, bh

        popa
        ret
ConfigNumberToNodeData  endp


;---------------------------------------;
; NodeDataToConfigNumber                ;
;---------------------------------------;-------------------------------------;
; This routine examines the node data and determines which ConfigTableEntry   ;
; corresponds to the current configuration of the node.                       ;
;                                                                             ;
; Input:  AL = Node number                                                    ;
;         DS:SI = Pointer to the node data                                    ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CF = Clear if a ConfigTableEntry matching the node data was found   ;
;              Set if no ConfigTableEntry matches the node data (node data    ;
;              contains an invalid configuration)                             ;
;         AL = Entry number in DeviceConfigTable                              ;
;                                                                             ;
; Destroys: DX                                                                ;
;-----------------------------------------------------------------------------;
NodeDataToConfigNumber  proc near private

        mov     dx, (DualBmIdeDevNodeData ptr [si]).PriPort1.fpdes_base
        add     dx, (DualBmIdeDevNodeData ptr [si]).SecPort1.fpdes_base

        xor     al, al                  ;Entry number = 0
        or      dx, dx
        jz      ConfigNumberFound       ;Br if Pri and Sec both disabled (CF=0)

        inc     ax                      ;Entry number = 1
        cmp     dx, 1F0h
        je      ConfigNumberFound       ;Br if Pri enabled, Sec disabled (CF=0)

        inc     ax                      ;Entry number = 2
        cmp     dx, 170h
        je      ConfigNumberFound       ;Br if Sec enabled, Pri disabled (CF=0)

        inc     ax                      ;Entry number = 3
        cmp     dx, 1F0h + 170h
        je      ConfigNumberFound       ;Br if Pri and Sec both enabled (CF=0)

        stc                             ;Indicate error, invalid configuration

ConfigNumberFound:
        ret
NodeDataToConfigNumber  endp

;-----------------------------------------------------------------------------;
DummyRet        proc    near    private
        ret
DummyRet        endp
;-----------------------------------------------------------------------------;

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
_text	 ends
	 end


