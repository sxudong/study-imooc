        page    ,132
        title.  IT8661F Floppy Controller Runtime Functions
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1998, American Megatrends, Inc.      **;
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
; $Header: /BIOS/PORTING/IO.112/IT8661F/RI61FFD.ASM 1   98/06/04 12:00a $
;
; $Revision: 1 $
;
; $Date: 98/06/04 12:00a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/PORTING/IO.112/IT8661F/RI61FFD.ASM $
; 
; 1     98/06/04 12:00a Chung
; Initial release.
; 
;*****************************************************************;
;---------------------------------------;
        include devnode.equ
        include io.equ
;---------------------------------------;
        public  IT8661FFloppyController
;---------------------------------------;
        extrn   IT8661FCommonRegisterInit:near
        extrn   IT8661FReadIO           :near
        extrn   IT8661FWriteIO          :near

        extrn   get_cmos_item           :near
        extrn   set_cmos_item_checksum  :near

        extrn   Q_IT8661F_FLOPPY_CONTROLLER:abs
;        extrn   Q_IT8661F_FLOPPY_SWAP   :abs
;        extrn   Q_IT8661F_FLOPPY_ACCESS :abs
;---------------------------------------;

;---------------------------------------;
;       C O D E     S E G M E N T       ;
;---------------------------------------;
.386
cgroup  group   _text
_text segment word public USE16 'CODE'
         assume cs:CGROUP


;---------------------------------------;
; Peripheral Table Structure            ;
;---------------------------------------;-------------------------------------;
; This table should be the only public label defined in this file.  It        ;
; contains pointers to the peripheral module's data and functions.            ;
;-----------------------------------------------------------------------------;
IT8661FFloppyController label word

        dw 0                            ;Flags
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

        dw FloppySetDensity             ;Pointer to FloppySetDensity routine


;---------------------------------------;
; Device Node Data                      ;
;---------------------------------------;-------------------------------------;
; This block of data forms the device node that describes the configuration   ;
; options available to this peripheral device.                                ;
;-----------------------------------------------------------------------------;
DevNodeData     label byte
;         Size     Node Number  Device ID       Base Type       Sub Type        IF Type         Attributes
;         -----    -----------  --------------  --------------  --------------  --------------  ----------------------------------------------
sd_node < NODELEN, 0,           ID_FLOPPY_CONT, BT_MASS_STORAGE,ST_FLOPPY,      IF_STD_FLOPPY,  SDN_ATTR_DYNAMIC_CFG >
;       port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 3F0h, 3F0h, 1, 6 >         ;Port 3F0 - 3F5
        port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 03f0h, 03f0h, 04h, 06h >
        irq_descriptor  < IRQ_DESC_TAG,  0000000001000000b >   ;IRQ 6
        dma_descriptor  < DMA_DESC_TAG,  0000000000000100b, DD_FLAG_WIDTH_8 + DD_FLAG_MASTER + DD_FLAG_COUNT_BYTE + DD_FLAG_SPEED_COMP >;Ch 2, 08h
        END_OF_ALLOCATED_RESOURCES
        DEPENDENT_FUNCTION_START
;               port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 3F0h, 3F0h, 1, 6 >          ;Port 3F0 - 3F5
                port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 03f0h, 03f0h, 04h, 06h >
                irq_descriptor  < IRQ_DESC_TAG,  0000000001000000b >   ;IRQ 6
                dma_descriptor  < DMA_DESC_TAG,  00000100b, DD_FLAG_WIDTH_8 + DD_FLAG_MASTER + DD_FLAG_COUNT_BYTE + DD_FLAG_SPEED_COMP > ;DMA 2
        END_OF_ALTERNATE_RESOURCES
        END_OF_COMPATIBLE_DEV_IDS
NODELEN = DevNodeDataEnd - DevNodeData
DevNodeDataEnd  label byte

; Format of Device Node Data
;-------------------------------------------------
DevNodeDataBlock        struc
        NodeData        sd_node <>
        FloppyPort      port_descriptor <>
        FloppyIrq       irq_descriptor <>
        FloppyDma       dma_descriptor <>
DevNodeDataBlock        ends

; Format of ConfigTableEntry
;-------------------------------------------------
ConfigTableEntry        struc
        PortAddress     dw ?
        PortSize        db ?
        IrqMask         dw ?
        DmaMask         db ?
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
;    Because of this each entry should contain enough information to fill in  ;
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

;                    PortAddress  PortSize  IrqMask  DmaMask 
;                    -----------  --------  -------  ------- 
  ConfigTableEntry <    0000h,       00h,    0000h,    00h  >  ;Disabled
  ConfigTableEntry <    03F0h,       06h,    0040h,    04h  >  ;Enabled

DeviceConfigTableEnd:


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
        pusha
        mov     al, Q_IT8661F_FLOPPY_CONTROLLER
        call    get_cmos_item           ;AL = 0/1/2 for AUTO/Disabled/Enabled
        dec     al
        jns     GetNodeNotAuto          ;Br if not set to AUTO
        call    GetHardwareConfig       ;Read config directly from hardware

GetNodeNotAuto:                         ;AL = Entry # in DeviceConfigTable
        call    ConfigNumberToNodeData  ;Move proper values into node data
        popa
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
        pusha
        call    GetHardwareConfig       ;AL = Entry # in DeviceConfigTable
        call    ConfigNumberToNodeData  ;Move proper values into node data
        popa
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
        pusha
        call    NodeDataToConfigNumber  ;AL = Entry # in DeviceConfigTable
        jc      SetNodeDone             ;Br if invalid config was requested

        mov     ah, al                  ;AH = 0/1 for Disabled/Enabled
        inc     ah                      ;AH = 1/2 for Disabled/Enabled
        mov     al, Q_IT8661F_FLOPPY_CONTROLLER
        call    set_cmos_item_checksum
        clc

SetNodeDone:
        popa
        ret
SetNodeStatic   endp


;---------------------------------------;
; SetNodeDynamic                        ;
;---------------------------------------;-------------------------------------;
; This function sets a device's configuration directly into hardware.  This   ;
; function is called during POST and runtime.                                 ;
;                                                                             ;
; Input:  AL = Node number                                                    ;
;         DS:SI = Pointer to the node                                         ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CF = Set if error setting node, clear if no error                   ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
SetNodeDynamic  proc near private
        pusha
        call    NodeDataToConfigNumber  ;AL = Entry # in DeviceConfigTable
        jc      SetNodeDone             ;Br if invalid config was requested
                                        ;AL = 0/1 for Disabled/Enabled
        call    SetHardwareConfig       ;Configure device to requested setting

SetNodeDone:
        popa
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
        call    IT8661FCommonRegisterInit

        pusha
;        mov     al, Q_IT8661F_FLOPPY_SWAP
;        call    get_cmos_item           ;AL = 0/1 for drive swap disable/enable
;        shl     al, 2
;        mov     bh, al
	mov	bh,0

;        mov     al, Q_IT8661F_FLOPPY_ACCESS
;        call    get_cmos_item           ;AL = 0/1 for access normal/read-only
;        or      bh, al

        mov     bl, 00h                 ;Logical Device 00 (FDC)
        mov     ax, 0f0f0h
        call    IT8661FReadIO
        and     al, 11111010b
        or      al, bh
        xchg    al, ah
        call    IT8661FWriteIO
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
        mov     al, Q_IT8661F_FLOPPY_CONTROLLER
        call    get_cmos_item           ;AL = 0/1/2 for AUTO/Disabled/Enabled
        jz      GetAutoDone             ;Br if set to auto
        mov     al, 1                   ;Return manual value
GetAutoDone:
        ret
GetAutoStatus   endp


;---------------------------------------;
; IdeSetMode                            ;
;---------------------------------------;-------------------------------------;
; This routine should set the mode/DMA timing of an IDE peripheral device.    ;
;                                                                             ;
; Input:  PIO mode / DMA timing                                               ;
;         Stack available                                                     ;
;                                                                             ;
; Output:                                                                     ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IdeSetMode      proc near private
        ret
IdeSetMode      endp


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
AdjustSetup     proc near private
        push    ax
        and     cs:IT8661FFloppyController, not PTFLAG_INVISIBLE_NODE
        call    GetHardwareConfig
        or      al, al
        jnz     @F                      ;Br if enabled
        or      cs:IT8661FFloppyController, PTFLAG_INVISIBLE_NODE
@@:
        pop     ax
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
;   Value Read       Entry # in       Config                                  ;
;   From CR30     DeviceConfigTable   Setting                                 ;
;  ------------   -----------------   --------                                ;
;       0                 0           Disabled                                ;
;       1                 1           Enabled                                 ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: AL = Entry number in DeviceConfigTable that represents the current  ;
;              configuration of the peripheral device.                        ;
;                                                                             ;
; Destroys: AL                                                                ;
;-----------------------------------------------------------------------------;
GetHardwareConfig       proc near private
        push    bx
        mov     al, 30h                 ;Read register CR30
        mov     bl, 00h                 ;Select Logical Device 0 (FDC)
        call    IT8661FReadIO           ;AL = Register value
        pop     bx
        ret
GetHardwareConfig       endp


;---------------------------------------;
; SetHardwareConfig                     ;
;---------------------------------------;-------------------------------------;
; This routine sets the current configuration of the peripheral device by     ;
; writing directly to its registers.                                          ;
;                                                                             ;
;     Entry # in       Value Written  Config                                  ;
;  DeviceConfigTable     To CR30      Setting                                 ;
;  -----------------   ------------   --------                                ;
;          0                 0        Disabled                                ;
;          1                 1        Enabled                                 ;
;                                                                             ;
; Input:  AL = Entry number in DeviceConfigTable                              ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: AX                                                                ;
;-----------------------------------------------------------------------------;
SetHardwareConfig       proc near private
        push    bx
        mov     ah, al
        mov     al, 30h                 ;AH = value to write, AL = CR30
        mov     bl, 00h                 ;Select Logical Device 0 (FDC)
        call    IT8661FWriteIO          ;Set H/W configuration
        pop     bx
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
        push    ax
        push    bx
  
        mov     bl, size ConfigTableEntry
        mul     bl                      ;AX = <entry # (AL)> * <entry size>
        mov     bx, offset DeviceConfigTable
        add     bx, ax                  ;BX = proper ConfigTableEntry

; Copy fields from the given ConfigTableEntry into the device node
; before it is returned to the caller.
        mov     ax, (ConfigTableEntry ptr cs:[bx]).PortAddress
        mov     (DevNodeDataBlock ptr [si]).FloppyPort.pdes_min_base, ax
        mov     (DevNodeDataBlock ptr [si]).FloppyPort.pdes_max_base, ax
        mov     al, (ConfigTableEntry ptr cs:[bx]).PortSize
        mov     (DevNodeDataBlock ptr [si]).FloppyPort.pdes_length, al

        mov     ax, (ConfigTableEntry ptr cs:[bx]).IrqMask
        mov     (DevNodeDataBlock ptr [si]).FloppyIrq.ides_irq_mask, ax

        mov     al, (ConfigTableEntry ptr cs:[bx]).DmaMask
        mov     (DevNodeDataBlock ptr [si]).FloppyDma.ddes_dma_mask, al

        pop     bx
        pop     ax
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
; Destroys: BX, CX, DX                                                        ;
;-----------------------------------------------------------------------------;
NodeDataToConfigNumber  proc near private
        xor     al, al                  ;Assume entry 0 in DeviceConfigTable
        cmp     (DevNodeDataBlock ptr [si]).FloppyPort.pdes_min_base, 0
        je      ConfigNumberFound       ;Br if device is disabled in node data
        inc     al                      ;Node data says enabled, so entry 1

ConfigNumberFound:
        ret
NodeDataToConfigNumber  endp


;---------------------------------------;
; FloppySetDensity                      ;
;---------------------------------------;-------------------------------------;
; This routine sets the floppy controller DENSEL pin to either high (for      ;
; normal drive) or low (for 3mode drive).                                     ;
;                                                                             ;
; Input:  DH = 0 Set DENSEL to high (normal mode)                             ;
;            = 1 Set DENSEL to low (3mode)                                    ;
;         DL = 00 for drive A                                                 ;
;            = 01 for drive B                                                 ;
;         Stack available                                                     ;
;                                                                             ;
; Output: None                                                                ;         
;                                                                             ;
; Destroys: None                                                              ;
;-----------------------------------------------------------------------------;
        extrn   fixed_delay:near

FloppySetDensity        proc near private
        push    ax
        push    bx
        mov     al, 0F0h                ;Read register CRF0
        xor     bl, bl                  ;Select Logical Device 0 (FDC)
        call    IT8661FReadIO           ;AL = Register value
        or      dh, dh                  ;DH = 0/1 for setting DENSEL pin
                                        ;     Normal(High)/Low
        jnz     SetDensityLow
        
;Normal density
        test    al, 00000010b           ;AL.1 = 0/1 for Normal/3-Mode
        jz      SetDensityExit          ;Exit if DENSEL already in normal state
        and     al, 11111101b
        jmp     short SetDensity
        
SetDensityLow:
        test    al, 00000010b           ;AL.1 = 0/1 for Normal/3-Mode
        jnz     SetDensityExit          ;Exit if DENSEL already in 3-Mode state
        or      al, 00000010b
        
SetDensity:
        mov     ah, al
        mov     al,0F0h
        xor     bl, bl
        call    IT8661FWriteIO          ;Set H/W configuration
;       mov     cx, 33334               ;500mS delay time
        mov     cx, 13333               ;200mS delay time
        call    fixed_delay             ;15uS each count
        
SetDensityExit:
        pop     bx
        pop     ax
        ret
FloppySetDensity        endp


;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1998, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
_text    ends
         end
