        page    ,132
        title.  ITE8661F Serial Port B Runtime Functions
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
; $Header: /BIOS/PORTING/IO.112/IT8661F/RI61FCB.ASM 1   98/06/04 12:00a $
;
; $Revision: 1 $
;
; $Date: 98/06/04 12:00a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/PORTING/IO.112/IT8661F/RI61FCB.ASM $
; 
; 1     98/06/04 12:00a Chung
; Initial release.
; 
;*****************************************************************;
;---------------------------------------;
        include devnode.equ
        include io.equ
;---------------------------------------;
        public  IT8661FSerialPortB
;---------------------------------------;
        extrn   IT8661FCommonRegisterInit:near
        extrn   IT8661FReadIO           :near
        extrn   IT8661FWriteIO          :near
        extrn   IT8661FRead6061         :near
        extrn   IT8661FWrite6061        :near
        extrn   get_cmos_item           :near
        extrn   set_cmos_item_checksum  :near

        extrn   Q_IT8661F_COMB_PORT     :abs

;       extrn   RtDummyRet:near
;       extrn   set_portB_decode_select(RtDummyRet):near
        extrn   IT8661SerialConfigTable :near
;---------------------------------------;

;---------------------------------------;
;       C O D E     S E G M E N T       ;
;---------------------------------------;
.386
cgroup  group   _text
_text segment word public USE16 'CODE'
         assume cs:CGROUP


;SerialConfigTable:
;        dw      0000h, 03f8h, 02f8h, 03e8h, 02e8h


;---------------------------------------;
; Peripheral Table Structure            ;
;---------------------------------------;-------------------------------------;
; This table should be the only public label defined in this file.  It        ;
; contains pointers to the peripheral module's data and functions.            ;
;-----------------------------------------------------------------------------;
IT8661FSerialPortB      label word

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

        dw DummyReturn                  ;Pointer to FloppySetDensity routine


;---------------------------------------;
; Device Node Data                      ;
;---------------------------------------;-------------------------------------;
; This block of data forms the device node that describes the configuration   ;
; options available to this peripheral device.                                ;
;-----------------------------------------------------------------------------;
DevNodeData     label byte
;         Size     Node Number  Device ID       Base Type       Sub Type        IF Type         Attributes
;         -----    -----------  --------------  --------------  --------------  --------------  ----------------------------------------------
sd_node < NODELEN, 0,           ID_16550_PORT,  BT_COMMUN,      ST_RS232,       IF_STD_RS232,   SDN_ATTR_DYNAMIC_CFG >
        port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 2F8h, 2F8h, 8, 8 >  ;Port 2F8 - 2FF
        irq_descriptor  < IRQ_DESC_TAG,  0000000000001000b >   ;IRQ 3
        END_OF_ALLOCATED_RESOURCES
        DEPENDENT_FUNCTION_START
                port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 3F8h, 3F8h, 8, 8 >  ;Port 3F8 - 3FF
                irq_descriptor  < IRQ_DESC_TAG,  0000000000010000b >   ;IRQ 4,3
        DEPENDENT_FUNCTION_START
                port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 2F8h, 2F8h, 8, 8 >  ;Port 2F8 - 2FF
                irq_descriptor  < IRQ_DESC_TAG,  0000000000001000b >   ;IRQ 4,3
        DEPENDENT_FUNCTION_START
                port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 3E8h, 3E8h, 8, 8 >  ;Port 3E8 - 3EF
                irq_descriptor  < IRQ_DESC_TAG,  0000000000010000b >   ;IRQ 4,3
        DEPENDENT_FUNCTION_START
                port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 2E8h, 2E8h, 8, 8 >  ;Port 2E8 - 2EF
                irq_descriptor  < IRQ_DESC_TAG,  0000000000001000b >   ;IRQ 4,3
        END_OF_ALTERNATE_RESOURCES
        END_OF_COMPATIBLE_DEV_IDS
NODELEN = DevNodeDataEnd - DevNodeData
DevNodeDataEnd  label byte

; Format of Device Node Data
;-------------------------------------------------
DevNodeDataBlock        struc
        NodeData        sd_node <>
        ComPort         port_descriptor <>
        ComIrq          irq_descriptor <>
DevNodeDataBlock        ends

; Format of ConfigTableEntry
;-------------------------------------------------
ConfigTableEntry        struc
        PortAddress     dw ?
        PortSize        db ?
        IrqMask         dw ?
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

;                    PortAddress  PortSize  IrqMask
;                    -----------  --------  -------
  ConfigTableEntry <    0000h,       00h,    0000h  >  ;Disabled
  ConfigTableEntry <    03F8h,       08h,    0010h  >  ;Port 3F8-3FF / IRQ 4
  ConfigTableEntry <    02F8h,       08h,    0008h  >  ;Port 2F8-2FF / IRQ 3
  ConfigTableEntry <    03E8h,       08h,    0010h  >  ;Port 3E8-3EF / IRQ 4
  ConfigTableEntry <    02E8h,       08h,    0008h  >  ;Port 2E8-2EF / IRQ 3

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
        mov     al, Q_IT8661F_COMB_PORT
        call    get_cmos_item           ;AL = 0/1/2/3/4/5 for
                                        ;     AUTO/Disabled/3F8/2F8/3E8/2E8
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

        mov     ah, al                  ;AH = 0/1/2/3/4 for
                                        ;     Disabled/3F8/2F8/3E8/2E8
        inc     ah                      ;AH = 1/2/3/4/5 for
                                        ;     Disabled/3F8/2F8/3E8/2E8
        mov     al, Q_IT8661F_COMB_PORT
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
                                        ;AL = 0/1/2/3/4 for
                                        ;     Disabled/3F8/2F8/3E8/2E8
;       call    set_portB_decode_select ;configure the COMB I/O range in chipset
        call    SetHardwareConfig       ;Configure device to requested setting
        clc

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
        mov     al, Q_IT8661F_COMB_PORT
        call    get_cmos_item           ;AL = 0/1/2/3/4/5 for
                                        ;     AUTO/Disabled/3F8/2F8/3E8/2E8
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
        and     cs:IT8661FSerialPortB, not PTFLAG_INVISIBLE_NODE
        call    GetHardwareConfig
        or      al, al
        jnz     @F                      ;Br if enabled
        or      cs:IT8661FSerialPortB, PTFLAG_INVISIBLE_NODE
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
;   Value Read     Value Read       Entry # in       Config                   ;
;   From CR30    From CR60/CR61  DeviceConfigTable   Setting                  ;
;  ------------   ------------   -----------------   --------                 ;
;       0            XX / XX             0           Disabled                 ;
;       1            03 / F8             1           3F8                      ;
;       1            02 / F8             2           2F8                      ;
;       1            03 / E8             3           3E8                      ;
;       1            02 / E8             4           2E8                      ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: AL = Entry number in DeviceConfigTable that represents the current  ;
;              configuration of the peripheral device.                        ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
GetHardwareConfig       proc near private
        push    bx
        mov     al, 30h                 ;Read register CR30
        mov     bl, 02h                 ;Select Logical Device 2 (COMB)
        call    IT8661FReadIO           ;AL = Register value
        or      al, al
        jz      GetCfgDone              ;COMB disabled, done return 0
        
        mov     bl, 02h                 ;Select Logical Device 2 (COMB)
        call    IT8661FRead6061         ;AX = COMB base address
        xor     bx, bx

MatchingConfigEntry:
        cmp     ax, cs:IT8661SerialConfigTable[bx]      ;AX = COMB base address
                                        ;BX = Index into config table
        je      ConfigTableEntryFound
        add     bx, 2                   ;Next config entry index
        cmp     bx, 8
        jle     MatchingConfigEntry
        xor     bl, bl                  ;Invalid config, force to zero

ConfigTableEntryFound:
        mov     al, bl                  ;AL = 2 * Entry number in DeviceConfigTable
        
GetCfgDone:
        shr     al, 1                   ;AL = Entry number in DeviceConfigTable
        pop     bx
        ret
GetHardwareConfig       endp


;---------------------------------------;
; SetHardwareConfig                     ;
;---------------------------------------;-------------------------------------;
; This routine sets the current configuration of the peripheral device by     ;
; writing directly to its registers.                                          ;
;                                                                             ;
;     Entry # in       Value Written  Value Written  Value Written  Config    ;
;  DeviceConfigTable     To CR30-0       To CR60        To CR61     Setting   ;
;  -----------------   ------------   ------------   ------------   --------  ;
;          0                 0             XX             XX        Disabled  ;
;          1                 1             03             F8        3F8       ;
;          2                 1             02             F8        2F8       ;
;          3                 1             03             E8        3E8       ;
;          4                 1             02             E8        2E8       ;
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
        push    ax
        mov     ax, 0030h               ;Disable COMB
        mov     bl, 02h                 ;Select Logical Device 2 (COMB)
        call    IT8661FWriteIO
        pop     ax
        
        movzx   bx, al
        shl     bx, 1                   ;BX = Index into translation table
        jz      SetHwCfgDone            ;Br if COMB is to be disabled
        
        mov     ax, cs:IT8661SerialConfigTable[bx]      ;AX = value to write to register CR60/61
        mov     bl, 02h                 ;Select Logical Device 2 (COMB)
        call    IT8661FWrite6061        ;Write COMA address to register CR60/61
        
        mov     ax, (DevNodeDataBlock ptr [si]).ComIrq.ides_irq_mask
        bsf     ax, ax
        mov     ah, al
        mov     al, 70h                 ;Select IRQ Register
        mov     bl, 02h                 ;Select Logical Device 2 (COMB)
        call    IT8661FWriteIO          ;Set H/W IRQ

        mov     ax, 0130h               ;Enable COMB
        mov     bl, 02h                 ;Select Logical Device 2 (COMB)
        call    IT8661FWriteIO
        
SetHwCfgDone:
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
        mov     (DevNodeDataBlock ptr [si]).ComPort.pdes_min_base, ax
        mov     (DevNodeDataBlock ptr [si]).ComPort.pdes_max_base, ax
        mov     al, (ConfigTableEntry ptr cs:[bx]).PortSize
        mov     (DevNodeDataBlock ptr [si]).ComPort.pdes_length, al
        mov     ax, (ConfigTableEntry ptr cs:[bx]).IrqMask
        mov     (DevNodeDataBlock ptr [si]).ComIrq.ides_irq_mask, ax

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
        mov     cx, (offset DeviceConfigTableEnd - offset DeviceConfigTable)/size ConfigTableEntry
        mov     bx, offset DeviceConfigTable
        mov     dx, (DevNodeDataBlock ptr [si]).ComPort.pdes_min_base
        xor     al, al                  ;AL will count entry number

ConfigNumberNext:
        cmp     (ConfigTableEntry ptr cs:[bx]).PortAddress, dx
        ;clc
        je      ConfigNumberFound       ;Br if port found in DeviceConfigTable

        add     bx, size ConfigTableEntry ;Point to next entry
        inc     al                      ;Keep track of which entry we are on
        loop    ConfigNumberNext        ;Try all entries in DeviceConfigTable
        stc                             ;Indicate error, invalid configuration

ConfigNumberFound:
        ret
NodeDataToConfigNumber  endp


;---------------------------------------;
; DummyReturn                           ;
;---------------------------------------;-------------------------------------;
; Input:  Nothing                                                             ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
DummyReturn     proc near private
        ret
DummyReturn     endp


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
