        page    ,132
        title.  IT8661F Parallel Port Runtime Functions
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
; $Header: /BIOS/PORTING/IO.112/IT8661F/RI61FLPE.ASM 1  98/06/04 12:00a $
;
; $Revision: 1 $
;
; $Date: 98/06/04 12:00a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/PORTING/IO.112/IT8661F/RI61FLPE.ASM $
; 
; 1     98/06/04 12:00a Chung
; Initial release.
; 
;*****************************************************************;
;---------------------------------------;
        include devnode.equ
        include io.equ
;---------------------------------------;
        public  IT8661FParallelPortExt
;---------------------------------------;
        extrn   IT8661FCommonRegisterInit:near
        extrn   IT8661FReadIO           :near
        extrn   IT8661FWriteIO          :near
        extrn   IT8661FRead6061         :near
        extrn   IT8661FWrite6061        :near

        extrn   get_cmos_item           :near
        extrn   set_cmos_item_checksum  :near

        extrn   get_lpt_irq_info        :near
        extrn   set_Lpt_irq             :near
        extrn   get_Lpt_ecp_dma_info    :near
        extrn   set_lpt_ecp_dma_channel :near

        extrn   Q_IT8661F_LPT_PORT      :abs
        extrn   Q_IT8661F_LPT_MODE      :abs
        extrn   Q_IT8661F_LPT_IRQ       :abs
        extrn   Q_IT8661F_LPT_ECP_DMA   :abs

        extrn   RtDummyRet              :near
        extrn   set_lpt_decode_select(RtDummyRet):near
        extrn   set_lpt_dma_select(RtDummyRet):near
;---------------------------------------;

;---------------------------------------;
;       C O D E     S E G M E N T       ;
;---------------------------------------;
.386
cgroup  group   _text
_text segment word public USE16 'CODE'
         assume cs:CGROUP


ParallelConfigTable:
        dw      0000h,  0378h,  0278h,  03BCh

LptDmaBitMask:
        db      00001011b               ;DMA 3,1,0


;---------------------------------------;
; Peripheral Table Structure            ;
;---------------------------------------;-------------------------------------;
; This table should be the only public label defined in this file.  It        ;
; contains pointers to the peripheral module's data and functions.            ;
;-----------------------------------------------------------------------------;
IT8661FParallelPortExt  label word

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
sd_node < NODELEN, 0,           ID_LPT_PORT,    BT_COMMUN,      ST_PARALLEL,    IF_STD_PARALLEL,SDN_ATTR_DYNAMIC_CFG >
        port_descriptor <PORT_DESC_TAG, PD_FLAG_DECODE_16, 0378h, 0378h, 04h, 08h >
        port_descriptor <PORT_DESC_TAG, PD_FLAG_DECODE_16, 0000h, 0000h, 00h, 00h >
        irq_descriptor  <IRQ_DESC_TAG,  0000000010000000b >  ;IRQ 7
        dma_descriptor  <DMA_DESC_TAG,  00000000b, DD_FLAG_WIDTH_8 + DD_FLAG_MASTER + DD_FLAG_COUNT_BYTE + DD_FLAG_SPEED_COMP>
        END_OF_ALLOCATED_RESOURCES
        DEPENDENT_FUNCTION_START
          port_descriptor <PORT_DESC_TAG, PD_FLAG_DECODE_16, 0378h, 0378h, 04h, 08h >
          port_descriptor <PORT_DESC_TAG, PD_FLAG_DECODE_16, 0000h, 0000h, 00h, 00h >
          irq_descriptor  <IRQ_DESC_TAG,  0000000010100000b >  ;IRQ 7,5
          dma_descriptor  <DMA_DESC_TAG,  00000000b, DD_FLAG_WIDTH_8 + DD_FLAG_MASTER + DD_FLAG_COUNT_BYTE + DD_FLAG_SPEED_COMP>
        DEPENDENT_FUNCTION_START
          port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0278h, 0278h, 04h, 08h >
          port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0000h, 0000h, 00h, 00h >
          irq_descriptor  < IRQ_DESC_TAG,  0000000010100000b >  ;IRQ 7,5
          dma_descriptor  < DMA_DESC_TAG,  00000000b, DD_FLAG_WIDTH_8 + DD_FLAG_MASTER + DD_FLAG_COUNT_BYTE + DD_FLAG_SPEED_COMP >
        DEPENDENT_FUNCTION_START
          port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 03bch, 03bch, 04h, 04h >
          port_descriptor < PORT_DESC_TAG, PD_FLAG_DECODE_16, 0000h, 0000h, 00h, 00h >
          irq_descriptor  < IRQ_DESC_TAG,  0000000010100000b >  ;IRQ 7,5
          dma_descriptor  < DMA_DESC_TAG,  00000000b, DD_FLAG_WIDTH_8 + DD_FLAG_MASTER + DD_FLAG_COUNT_BYTE + DD_FLAG_SPEED_COMP >
        END_OF_ALTERNATE_RESOURCES
        END_OF_COMPATIBLE_DEV_IDS
NODELEN = DevNodeDataEnd - DevNodeData
DevNodeDataEnd  label byte

; Format of Device Node Data
;-------------------------------------------------
DevNodeDataBlock        struc
        NodeData        sd_node <>
        LptPort         port_descriptor <>
        EcpPort         port_descriptor <>
        LptIrq          irq_descriptor <>
        LptDMA          dma_descriptor <>
DevNodeDataBlock        ends

LptDependentNode        struc
        LptPort         port_descriptor <>
        EcpPort         port_descriptor <>
        LptIrq          irq_descriptor <>
        LptDma          dma_descriptor <>
LptDependentNode        ends

; Format of ConfigTableEntry
;-------------------------------------------------
ConfigTableEntry        struc
        PortAddress     dw ?
        PortSize        db ?
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
  ConfigTableEntry <    0000h,       00h >  ;Disabled
  ConfigTableEntry <    0378h,       08h >  ;Port 378-37B
  ConfigTableEntry <    0278h,       08h >  ;Port 278-27B
  ConfigTableEntry <    03BCh,       04h >  ;Port 3BC-3BF 

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
        
; Get LPT IRQ
        mov     al, Q_IT8661F_LPT_IRQ
        call    get_cmos_item           ;AL = 0/1 for IRQ5/IRQ7
        mov     bx, 0020h               ;Assume IRQ5
        jz      GetEcpDmaFromCmos
        mov     bl, 80h                 ;IRQ7
        
GetEcpDmaFromCmos:                      ;BX = LPT IRQ mask
; Get LPT DMA
        xor     cl, cl                  ;CL = 0 if not in ECP mode
        mov     al, Q_IT8661F_LPT_MODE
        call    get_cmos_item           ;AL=0/1/2/3 for Normal/EPP/ECP/EPP+ECP
        mov     ch, al                  ;CH=0/1/2/3 for Normal/EPP/ECP/EPP+ECP
        cmp     ch, 2
        jb      GetAddressFromCmos      ;BR if not in ECP mode
        
        mov     al, Q_IT8661F_LPT_ECP_DMA
        call    get_cmos_item           ;AL = 0/1/2/3 for DMA0/DMA1/DMA2/DMA3
        xor     ah, ah
        xor     dx, dx
        bts     dx, ax
        mov     cl, dl                  ;CL = LPT ECP DMA mask
        
GetAddressFromCmos:
; Get parallel port address
        mov     al, Q_IT8661F_LPT_PORT
        call    get_cmos_item           ;AL = 0/1/2/3/4 for
                                        ;     AUTO/Disabled/378/278/3BC
        dec     al
        jns     GetNodeNotAuto          ;Br if not set to AUTO
        call    GetHardwareConfig       ;Read config directly from hardware
        call    GetHardwareIrqMask      ;BX = IRQ channel (mask)
        call    GetHardwareDMAMask      ;CL = LPT ECP DMA (mask)

GetNodeNotAuto:                         ;AL = Entry # in DeviceConfigTable
        or      al, al
        jnz     RtnStaticInfoToNode     ;BR if enabled
        xor     bx, bx                  ;Force No IRQ if LPT is disabled
        xor     cl, cl                  ;Force No DMA if LPT is disabled

RtnStaticInfoToNode:                    ;AL = Entry # in DeviceConfigTable
                                        ;BX = LPT IRQ mask
                                        ;CH = 0/1/2/3 for Normal/EPP/ECP/EPP+ECP
                                        ;CL = LPT DMA Mask
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
        call    GetHardwareMode         ;Read Mode from hardware(CH)
        call    GetHardwareDMAMask      ;CL = LPT ECP DMA (mask)
        call    GetHardwareIrqMask      ;BX = IRQ channel (mask)
        call    GetHardwareConfig       ;AL = Entry # in DeviceConfigTable
        or      al, al
        jnz     RtnDynamicInfoToNode    ;BR if enabled
        xor     bx, bx                  ;Force No IRQ if LPT is disabled
        xor     cl, cl                  ;Force No DMA if LPT is disabled

RtnDynamicInfoToNode:                   ;AL = Entry # in DeviceConfigTable
                                        ;BX = LPT IRQ mask
                                        ;CH = 0/1/2/3 for Normal/EPP/ECP/EPP+ECP
                                        ;CL = LPT ECP DMA Mask
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

; Set parallel port address
        call    NodeDataToConfigNumber  ;AL = Entry # in DeviceConfigTable
        jc      SetNodeDone             ;Br if invalid config was requested

        mov     ah, al                  ;AH = 0/1/2/3 for Disabled/378/278/3BC
        inc     ah                      ;AH = 1/2/3/4 for Disabled/378/278/3BC
        mov     al, Q_IT8661F_LPT_PORT
        call    set_cmos_item_checksum
        
; Set parallel port IRQ
        xor     ah, ah                  ;Assume IRQ5
        test    (DevNodeDataBlock ptr [si]).LptIrq.ides_irq_mask, 0020h
        jnz     SetDevIrqToCmos
        inc     ah                      ;IRQ7
SetDevIrqToCmos:                        ;AH = 0/1 for IRQ5/IRQ7
        mov     al, Q_IT8661F_LPT_IRQ
        call    set_cmos_item_checksum
        
SetEcpDmaToCmos:
; Set parallel port ECP DMA
        movzx   bx, (DevNodeDataBlock ptr [si]).LptDMA.ddes_dma_mask
        bsf     ax, bx
        jz      @F
        mov     ah, al                  ;AH = 0/1/2/3 for DMA0/DMA1/DMA2/DMA3
        mov     al, Q_IT8661F_LPT_ECP_DMA
        call    set_cmos_item_checksum
@@:
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
                                        ;AL = 0/1/2/3 for Disabled/378/278/3BC
        call    set_lpt_decode_select   ;configure the LPT I/O range in chipset
        call    SetHardwareConfig       ;Configure device to requested setting
        or      al, al
        jz      SetNodeDoneX

        mov     al, Q_IT8661F_LPT_MODE
        call    get_cmos_item           ;AL=0/1/2/3 for Normal/EPP/ECP/EPP+ECP
        call    IT8661FSetPPMode

        call    SetHardwareIrq          ;Configure device IRQ
        call    SetHardwareDma          ;Configure device DMA

SetNodeDoneX:
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
        mov     al, Q_IT8661F_LPT_PORT
        call    get_cmos_item           ;AL = 0/1/2/3/4 for
                                        ;     AUTO/Disabled/378/278/3BC
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
        pusha
        and     cs:IT8661FParallelPortExt, not PTFLAG_INVISIBLE_NODE
        call    GetHardwareConfig
        or      al, al
        jnz     @F                     ;BR if enabled
        or      cs:IT8661FParallelPortExt, PTFLAG_INVISIBLE_NODE
@@:
        call    GetHardwareMode         ;CH = 0/1/2/3 for Normal/EPP/ECP/EPP+ECP
        cmp     ch, 2                   ;check for ECP mode
        jb      @F                      ;BR if not in ECP
        mov     dword ptr cs:DevNodeData[3], ID_ECP_PORT
@@:
        popa
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
        push    ds
        push    es
        push    ax
        xor     ax, ax
        mov     ds, ax
        mov     es, ax
        lds     ax, ds:[17h * 4]
        mov     cs:OldInt17Vector, ax
        mov     cs:OldInt17Vector + 2, ds
        
        mov     ax, offset int_17_epp
        mov     es:[17h * 4], ax
        mov     ax, 0f000h
        mov     es:[17h * 4] + 2, ax
        pop     ax
        pop     es
        pop     ds
        ret
        
OldInt17Vector  dw      2 dup (0)

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
;       1            03 / 78             1           378                      ;
;       1            02 / 78             2           278                      ;
;       1            03 / BC             3           3BC                      ;
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
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        call    IT8661FReadIO           ;AL = Register value
        or      al, al
        jz      GetCfgDone              ;LPT disabled, done return 0
        
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        call    IT8661FRead6061         ;AX = LPT base address
        xor     bx, bx

MatchingConfigEntry:
        cmp     ax, cs:ParallelConfigTable[bx]  ;AX = LPT base address
                                        ;BX = Index into config table
        je      ConfigTableEntryFound
        add     bx, 2                   ;Next config entry index
        cmp     bx, 6
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
; GetHardwareIrqMask                    ;
;---------------------------------------;-------------------------------------;
; This routine determines the current IRQ configuration of the peripheral     ;
; device by reading directly from its registers, then converts it into a mask ;
; value.                                                                      ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: BX = IRQ Mask                                                       ;
;                                                                             ;
; Destroys: BX, DX                                                            ;
;-----------------------------------------------------------------------------;
GetHardwareIrqMask      proc near private
        push    ax
        call    get_lpt_irq_info        ;CF = 0/1 for IO/System IRQ routing
                                        ;BX = IRQ channel (mask)
                                        ;DX = IRQ available (not used here)
        jc      GetHardwareIrqMaskDone  ;BR if system chipset routes IRQ
        
        mov     al, 70h                 ;Read register CR 70h
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        call    IT8661FReadIO           ;AL = Register value
        xor     bx, bx
        xor     ah, ah
        bts     bx, ax                  ;BX = IRQ Mask

GetHardwareIrqMaskDone:
        pop     ax
        ret
GetHardwareIrqMask      endp


;---------------------------------------;
; GetHardwareDMAMask                    ;
;---------------------------------------;-------------------------------------;
; This routine determines the current DMA configuration of the peripheral     ;
; device by reading directly from its registers, then converts it into a mask ;
; value.                                                                      ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CL = DMA Mask                                                       ;
;                                                                             ;
; Destroys: CL, DL                                                            ;
;-----------------------------------------------------------------------------;
GetHardwareDMAMask              proc near private
        push    ax
        push    bx
        call    get_lpt_ecp_dma_info    ;CF = 0/1 for IO/System DMA routing
                                        ;CL = LPT ECP DMA (mask)
                                        ;DL = LPT ECP DMA available (not used here)
        jc      GetHardwareDmaMaskDone  ;BR if system chipset routes DMA

        xor     cl, cl                  ;Clear DMA mask in not ECP mode
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        mov     al, 0f0h                ;Read IR mode register
        call    IT8661FReadIO           ;AL = Register value
        test    al, 00000010b
        jz      GetHardwareDmaMaskDone  ;BR if not in ECP mode

        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        mov     al, 74h                 ;Read register CR 74h
        call    IT8661FReadIO           ;AL = Register value
        xor     ah, ah
        xor     cl, cl
        bts     cx, ax                  ;CL DMA Mask

GetHardwareDmaMaskDone:
        pop     bx
        pop     ax
        ret
GetHardwareDMAMask              endp


;---------------------------------------;
; GetHardwareMode                       ;
;---------------------------------------;-------------------------------------;
; This routine determines the current MODE configuration of the peripheral    ;
; device by reading directly from its registers, then converts it into a mask ;
; value.                                                                      ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: CH = LPT Mode                                                       ;
;                                                                             ;
; Destroys: CH                                                                ;
;-----------------------------------------------------------------------------;
GetHardwareMode         proc near private
        push    ax
        push    bx
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        mov     al, 0f0h                ;Read LPT mode register
        call    IT8661FReadIO           ;AL = Register value
        and     al, 00000011b
        mov     ch, al
        pop     bx
        pop     ax
        ret
GetHardwareMode         endp


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
;          1                 1             03             78        378       ;
;          2                 1             02             78        278       ;
;          3                 1             03             BC        3BC       ;
;                                                                             ;
; Input:  AL = Entry number in DeviceConfigTable                              ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: AX, BX                                                            ;
;-----------------------------------------------------------------------------;
SetHardwareConfig       proc near private
        push    ax
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        mov     ax, 0030h               ;Disable LPT
        call    IT8661FWriteIO
        mov     ax, 0000h               ;Clear Address
        call    IT8661FWrite6061
        mov     ax, 0070h               ;Clear IRQ
        call    IT8661FWriteIO
        mov     ax, 0074h               ;Clear DMA
        call    IT8661FWriteIO
        pop     ax
        
        movzx   bx, al
        shl     bx, 1                   ;BX = Index into translation table
        jz      SetHwCfgDone            ;Br if LPT is to be disabled
        
        mov     ax, cs:ParallelConfigTable[bx]  ;AX = value to write to register CR60/61
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        call    IT8661FWrite6061        ;Write LPT address to register CR60/61
        
        mov     ax, 0130h               ;Enable LPT
        call    IT8661FWriteIO
        
SetHwCfgDone:
        ret
SetHardwareConfig       endp


;---------------------------------------;
; SetHardwareIrq                        ;
;---------------------------------------;-------------------------------------;
; This routine sets the current IRQ of the peripheral device by writing       ;
; directly to its registers.                                                  ;
;                                                                             ;
; Input:  DS:SI = Pointer to the node                                         ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: AX, BX                                                            ;
;-----------------------------------------------------------------------------;
SetHardwareIrq          proc near private
        mov     ax, (DevNodeDataBlock ptr [si]).LptIrq.ides_irq_mask
        bsf     bx, ax
        jnz     @F
        xor     bl, bl                  ;No IRQ
@@:
        mov     al, bl                  ;AL = LPT IRQ channel to route
        call    get_lpt_irq_info        ;CF = 0/1 for IO/System IRQ routing
        jnc     IOsetsIRQ               ;BR if IRQ is routed by I/O chipset
        call    set_Lpt_irq             ;IRQ set by system chipset
        ret

IOsetsIRQ:
        mov     ah, bl
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        mov     al, 70h                 ;Select IRQ Register
        call    IT8661FWriteIO          ;Set H/W IRQ
        ret
SetHardwareIrq          endp


;---------------------------------------;
; SetHardwareDMA                        ;
;---------------------------------------;-------------------------------------;
; This routine sets the current DMA of the peripheral device by writing       ;
; directly to its registers.                                                  ;
;                                                                             ;
; Input:  DS:SI = Pointer to the node                                         ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: AX, BX                                                            ;
;-----------------------------------------------------------------------------;
SetHardwareDMA          proc near private
        movzx   bx, (DevNodeDataBlock ptr [si]).LptDMA.ddes_dma_mask
        bsf     ax, bx
        jnz     @F                      ;BR if no DMA mask set
        mov     al, 4                   ;No DMA mask, set AL = 4 for No DMA
@@:                                     ;AL = 0/1/2/3/4 for DMA0/DMA1/DMA2/DMA3/None
        call    set_lpt_dma_select      ;configure the LPT DMA range in chipset
        call    get_lpt_ecp_dma_info    ;CF = 0/1 for IO/Sytem DMA Routing
        jnc     SetIT8661FDma           ;BR if DMA is routed by I/O Chipset
        call    set_lpt_ecp_dma_channel ;DMA routing by system chipset
        ret

SetIT8661FDma:
        mov     ah, al
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        mov     al, 074h                ;Select DMA Register
        call    IT8661FWriteIO          ;Set H/W DMA
        ret
SetHardwareDMA          endp


;---------------------------------------;
; ConfigNumberToNodeData                ;
;---------------------------------------;-------------------------------------;
; This routine copies data from the given ConfigTableEntry into the proper    ;
; fields in the node's resource descriptors.                                  ;
;                                                                             ;
; Input:  AL = Entry number in DeviceConfigTable                              ;
;         BX = LPT IRQ mask                                                   ;
;         CH = LPT mode                                                       ;
;         CL = DMA mask                                                       ;
;                                                                             ;
;         DS:SI = Pointer to buffer containing node structure                 ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
ECP_FLAGS       equ     DD_FLAG_WIDTH_8 + DD_FLAG_COUNT_BYTE + DD_FLAG_SPEED_COMP

ConfigNumberToNodeData  proc near private
        pusha

; Copy IRQ mask into the device node
        mov     (DevNodeDataBlock ptr [si]).LptIrq.ides_irq_mask, bx
; Copy DMA mask into the device node
        mov     (DevNodeDataBlock ptr [si]).LptDMA.ddes_dma_mask, cl

; Point DI to first dependent node
        mov     di, si
        add     di, (size DevNodeDataBlock) + 3 ;Point to start of dependent nodes

        cmp     ch, 02h
        jb      NotECPMode
        pusha
        mov     cx, 3
FixerECPLoop:
; Set ECP address
        mov     ax, (LptDependentNode ptr [di]).LptPort.pdes_min_base
        add     ax, 400h                ;AX = ECP address
        mov     (LptDependentNode ptr [di]).EcpPort.pdes_min_base, ax
        mov     (LptDependentNode ptr [di]).EcpPort.pdes_max_base, ax
        mov     (LptDependentNode ptr [di]).EcpPort.pdes_alignment, 4
        mov     (LptDependentNode ptr [di]).EcpPort.pdes_length, 3
; Set ECP DMA Mask
        mov     al, byte ptr cs:LptDmaBitMask
        mov     (LptDependentNode ptr [di]).LptDMA.ddes_dma_mask, al
        add     di, (size LptDependentNode) + 1
        loop    FixerECPLoop
        popa
NotECPMode:

        mov     dl, al                  ;DL = entry number
        mov     bl, size ConfigTableEntry
        mul     bl                      ;AX = <entry # (AL)> * <entry size>
        mov     bx, offset DeviceConfigTable
        add     bx, ax                  ;BX = proper ConfigTableEntry

; Copy fields from the given ConfigTableEntry into the device node
; before it is returned to the caller.
        mov     al, (ConfigTableEntry ptr cs:[bx]).PortSize
        mov     (DevNodeDataBlock ptr [si]).LptPort.pdes_length, al
        mov     ax, (ConfigTableEntry ptr cs:[bx]).PortAddress
        mov     (DevNodeDataBlock ptr [si]).LptPort.pdes_min_base, ax
        mov     (DevNodeDataBlock ptr [si]).LptPort.pdes_max_base, ax
        or      ax, ax
        jz      NodeUpdateDone          ;Br if disabled

        add     ax, 400h                ;AX = ECP address

; Update node according to port mode
        dec     ch                      ;CH=-1/0/1/2 for Normal/EPP/ECP/EPP+ECP
        js      ModeSPP                 ;Br if port set to Normal
        jz      Adjust_Node

; Set ECP mode node information
        mov     (DevNodeDataBlock ptr [si]).EcpPort.pdes_min_base, ax
        mov     (DevNodeDataBlock ptr [si]).EcpPort.pdes_max_base, ax
        mov     (DevNodeDataBlock ptr [si]).EcpPort.pdes_alignment, 4
        mov     (DevNodeDataBlock ptr [si]).EcpPort.pdes_length, 3
        mov     (DevNodeDataBlock ptr [si]).LptDMA.ddes_dma_flags, ECP_FLAGS
        mov     (DevNodeDataBlock ptr [si]).NodeData.sdn_if_type, IF_ECP
;;;     jmp     short Adjust_node

ModeSPP:
;旼컴컴컴컴컴커
;쿕ames 031996쳐컴컴컴컴컴컴컴컴컴컴컴컴;
;읕컴컴컴컴컴켸
; Please clear DMA resource to all dependent function nodes if not ECP
; And set all dependent functions' length to 4/8 for non-EPP/EPP
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�;
; DI = first dependent node address
Adjust_Node:
        cmp     dl, 3                   ;3BC is selected ?
        jne     NodeUpdateDone          ;No..
; Length = 4 for SPP (3BC)
        mov     (DevNodeDataBlock ptr [si]).LptPort.pdes_length, 4

NodeUpdateDone:
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
; Destroys: BX, CX, DX                                                        ;
;-----------------------------------------------------------------------------;
NodeDataToConfigNumber  proc near private
        mov     cx, (offset DeviceConfigTableEnd - offset DeviceConfigTable) / size (ConfigTableEntry)
        mov     bx, offset DeviceConfigTable
        mov     dx, (DevNodeDataBlock ptr [si]).LptPort.pdes_min_base
        xor     al, al                  ;AH will count entry number

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
; IT8661FSetPPMode                      ;
;---------------------------------------;-------------------------------------;
; This function sets the parallel port to mode specified in AL                ;
;                                                                             ;
; Input:  AL = 00000000b   Normal                                             ;
;            = 00000001b   EPP                                                ;
;            = 00000010b   ECP                                                ;
;            = 00000011b   EPP+ECP                                            ;
;                                                                             ;
; Output: None                                                                ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FSetPPMode        proc near private
        push    ax
        push    bx
        mov     ah, al
        mov     al, 0f0h
        mov     bl, 03h                 ;Select Logical Device 3 (LPT)
        call    IT8661FWriteIO
        pop     bx
        pop     ax
        ret
IT8661FSetPPMode        endp


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


include epp.inc


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
