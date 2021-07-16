        page    ,132
        title . PCI/PnP Device Name Display
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
        include pci.equ
        include pnp.equ
        include devnode.equ
        include rt.equ
	include	sis530.equ
	include	makeflag.equ
;---------------------------------------;
					; (CORE0228-)>
	include	me5.equ
	include	me9.equ
;        extrn   MsgPnpDevices:abs
;        extrn   MsgPciDevices:abs
;        extrn   MsgPciSlot:abs
;        extrn   MsgPciOnboard:abs
;        extrn   MsgPciBridge:abs
;
;        extrn   StrDevVga:abs
;        extrn   StrDevUnknown:abs
;        extrn   StrDevScsi:abs
;        extrn   StrDevIde:abs
;        extrn   StrDevRaid:abs
;        extrn   StrDevMassStorage:abs
;        extrn   StrDevEthernet:abs
;        extrn   StrDevTokenRing:abs
;        extrn   StrDevNetwork:abs
;        extrn   StrDevVga:abs
;        extrn   StrDevDisplay:abs
;        extrn   StrDevMultimedia:abs
;        extrn   StrDevMemory:abs
;        extrn   StrDevPciBridge:abs
;        extrn   StrDevPcmciaBridge:abs
;        extrn   StrDevCardBus:abs
;        extrn   StrDevBridge:abs
;        extrn   StrDevIoPort:abs
;        extrn   StrDevSystemDevice:abs
;        extrn   StrDevInputDevice:abs
;        extrn   StrDevDockingStation:abs
;        extrn   StrDevProcessor:abs
;        extrn   StrDevFirewire:abs
;        extrn   StrDevSsa:abs
;        extrn   StrDevUsb:abs
;        extrn   StrDevFibreChannel:abs
;        extrn   StrDevSerialBus:abs
;        extrn   StrIrq:abs

        extrn   read_cursor_posn:near
        extrn   set_cursor_posn:near
        extrn   display_message_set:near

        public  DisplayPnpPciDevices

;---------------------------------------;

cgroup  group   _text
_text   segment word use16 public 'CODE'
assume  cs:cgroup
assume  ds:cgroup
assume  es:cgroup
.386

;---------------------------------------;

DevTypeEntry    struc
BaseClass       db ?
SubClass        db ?
DevTypeStr      db ?
DevTypeEntry    ends

DevTypeTableStart       label byte

;              Base    Sub
;              Class   Class   Pointer to Description String
;----------------------------------------------------------------------
DevTypeEntry < 00h,    00h,    StrDevScsi            >
DevTypeEntry < 00h,    01h,    StrDevVga             >
DevTypeUnknown label byte
DevTypeEntry < 00h,    80h,    StrDevUnknown         >

DevTypeEntry < 01h,    00h,    StrDevScsi            >
DevTypeEntry < 01h,    01h,    StrDevIde             >
DevTypeEntry < 01h,    04h,    StrDevRaid            >
DevTypeEntry < 01h,    80h,    StrDevMassStorage     >

DevTypeEntry < 02h,    00h,    StrDevEthernet        >
DevTypeEntry < 02h,    01h,    StrDevTokenRing       >
DevTypeEntry < 02h,    80h,    StrDevNetwork         >

DevTypeEntry < 03h,    00h,    StrDevVga             >
DevTypeEntry < 03h,    80h,    StrDevDisplay         >

DevTypeEntry < 04h,    80h,    StrDevMultimedia      >
DevTypeEntry < 05h,    80h,    StrDevMemory          >

DevTypeEntry < 06h,    04h,    StrDevPciBridge       >
DevTypeEntry < 06h,    05h,    StrDevPcmciaBridge    >
DevTypeEntry < 06h,    07h,    StrDevCardBus         >
DevTypeEntry < 06h,    80h,    StrDevBridge          >

DevTypeEntry < 07h,    80h,    StrDevIoPort          >
DevTypeEntry < 08h,    80h,    StrDevSystemDevice    >
DevTypeEntry < 09h,    80h,    StrDevInputDevice     >
DevTypeEntry < 0Ah,    80h,    StrDevDockingStation  >
DevTypeEntry < 0Bh,    80h,    StrDevProcessor       >

DevTypeEntry < 0Ch,    00h,    StrDevFirewire        >
DevTypeEntry < 0Ch,    02h,    StrDevSsa             >
DevTypeEntry < 0Ch,    03h,    StrDevUsb             >
DevTypeEntry < 0Ch,    04h,    StrDevFibreChannel    >
DevTypeEntry < 0Ch,    80h,    StrDevSerialBus       >

DevTypeTableEnd label byte

;---------------------------------------;


;---------------------------------------;
; DisplayPnpPciDevices                  ;
;---------------------------------------;--------------------------------------;
; This function displays all the names of all Plug and Play ISA devices and    ;
; all PCI devices that are present in the system.                              ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
DisplayPnpPciDevices    proc near
        pushad
        push    ds
        push    es

        push    cs                      ;Set DS = ES = CS
        push    cs
        pop     ds
        pop     es

        call    read_cursor_posn        ;DH,DL = row,col
        dec     dh
        call    set_cursor_posn
        xor     ax, ax
        call    DisplayPnpDevices
        adc     ax, 0                   ;AX += 0 if no PnP cards, 1 otherwise
        call    DisplayPciDevices
        mov     eax, 'ผออศ'
        call    DisplayHorizLine        ;Display 'ศออออออออ...ออออออออผ'
PciPnpExit:
        pop     es
        pop     ds
        popad
        ret
DisplayPnpPciDevices    endp


;---------------------------------------;
; DisplayPnpDevices                     ;
;---------------------------------------;--------------------------------------;
; This function displays the name of each PnP ISA card in the system.          ;
;                                                                              ;
; Input: DS = ES = CS                                                          ;
;                                                                              ;
; Output: ZF = Set if one or more PnP cards were displayed                     ;
;              Clear if no PnP cards were displayed                            ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
DisplayPnpDevices       proc near
        pusha
        push    eax

        xor     bp, bp                  ;Reset device counter
        call    GetPnpMaxCsnAndRdp      ;Returns CL = Max CSN, DX = Read Data Port
        or      cl, cl
        jz      DispPnPDone             ;Br if no PnP ISA cards in system
                                        ;CLC already

        mov     eax, 'น  ฬ'
        call    DisplayHorizLine        ;Display 'ฬออออออออฯออออออออน'
        mov     bh, MsgPnpDevices
        call    DisplayStringSet5       ;Display 'บ Plug and Play ISA Devices:'
        mov     al, 76
        call    MoveToColumn            ;Put cursor at end of line
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        call    Display3Spaces

        call    PnpInitializationKey    ;Move all PnP cards to the Sleep state
        mov     bl, cl                  ;BL = Number of PnP ISA cards

DispPnpNextCard:
        test    bp, 1
        jnz     @f                      ;Br if # of devices is odd number
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        mov     al, ' '
        call    DisplayChar             ;Display ' '
        jmp     short DisplayPnpStart
@@:     mov     al, 40
        call    MoveToColumn            ;Put cursor at middle of line

DisplayPnpStart:
        mov     al, bl                  ;AL = CSN to wake
        call    PnpWakeCsn              ;Wake one PnP ISA card
        mov     cx, 9                   ;Read device ID, serial #, and Cksum
@@:
        call    ReadResourceByte
        jc      DispPnpUnknownCard      ;Br if card timed out on read
        loop    @b
DispPnpNextDesc:
        call    ReadResourceByte        ;AL = Descriptor tag
        jc      DispPnpUnknownCard      ;Br if card timed out on read
        mov     bh, al                  ;BH = Descriptor tag
	or	al,al
	jz	GotoNextDesc
        test    al, 80h                 ;Upper bit set means large resource desc
        jnz     DispPnpLargeDesc        ;Br if large descriptor
        and     ax, 0007h               ;Small desc length is in bits 2-0
        jmp     short DispPnpReadIt     ;AX = # of bytes to follow
DispPnpLargeDesc:
        call    ReadResourceByte        ;Returns next resource data byte in AL
        jc      DispPnpUnknownCard      ;Br if timeout waiting for ready bit
        mov     ah, al
        call    ReadResourceByte        ;Returns next resource data byte in AL
        jc      DispPnpUnknownCard      ;Br if timeout waiting for ready bit
        xchg    al, ah                  ;AX = # of bytes to follow

DispPnpReadIt:
        mov     cx, ax                  ;CX = # of resource bytes to read
        cmp     bh, END_TAG
        je      DispPnpUnknownCard      ;Br if no more resource data in card

DispCharNextDescByte:
        call    ReadResourceByte        ;Returns next resource data byte in AL
        jc      DispPnpUnknownCard      ;Br if timeout waiting for ready bit
        cmp     bh, ANSI_STRING_TAG
        jne     @f                      ;Br if this is not a ANSI string descriptor
        cmp     cx, 36
        jb      DispPnpLimitStrLen      ;Br if string is not too long
        mov     cx, 36                  ;Limit string length
DispPnpLimitStrLen:
        call    DisplayChar             ;Display character in AL
@@:     loop    DispCharNextDescByte    ;Read all bytes in descriptor
GotoNextDesc:
        cmp     bh, ANSI_STRING_TAG
        jne     DispPnpNextDesc         ;Br if this was not a ANSI string descriptor
        jmp     short DispPnpCardDone

DispPnpUnknownCard:
        mov     bh, StrDevUnknown
        call    DisplayStringSet5       ;Display 'Unknown Device'

DispPnpCardDone:
        test    bp, 1
        jz      @f                      ;Br if # of devices is even number
        mov     al, 76
        call    MoveToColumn            ;Put cursor at end of line
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        call    Display3Spaces
@@:
        inc     bp
        dec     bl                      ;Next CSN
        jnz     DispPnpNextCard         ;Br if more CSN to look at

        test    bp, 1
        jz      @f                      ;Br if # of devices is even number
        mov     al, 76
        call    MoveToColumn            ;Put cursor at end of line
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        call    Display3Spaces
@@:
        mov     ax, (PNP_REG_CFG_CONTROL * 100h) + PNP_CMD_WAIT_FOR_KEY
        call    PnpWriteReg             ;Return all devs to Wait for Key state

        stc                             ;Indicate cards were displayed

DispPnPDone:
        pop     eax
        popa
        ret
DisplayPnpDevices       endp

;---------------------------------------;
; GetPnpMaxCsnAndRdp                    ;
;---------------------------------------;--------------------------------------;
; This function returns the Maiximum PnP ISA Card Select Number and the current;
; Read Data Port that should be used to access PnP ISA cards.                  ;
;                                                                              ;
; Input: DS = ES = CS                                                          ;
;                                                                              ;
; Output: CL = Maximum PnP ISA CSN                                             ;
;         DX = Current Read Data Port                                          ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
GetPnpMaxCsnAndRdp      proc near
        push    ax
        push    bp
        sub     sp, 6                   ;Six byte buffer on stack
        mov     bp, sp                  ;BP = ptr to buffer

        push    0F000h                  ;BIOS selector
        push    ss                      ;Segment of buffer
        push    bp                      ;Offset of buffer
        push    40h                     ;Get PnP ISA Config Structure function
        mov     ah, RT_PNP_FUNCTION     ;Updates DevNodeNum with next node num
        CALL_RT_FUNCTION                ;Call PnP function
        add     sp, 8                   ;Clean up stack

        mov     cl, (pnp_isa_cfg ptr [bp]).pnpcfg_max_csn
        mov     dx, (pnp_isa_cfg ptr [bp]).pnpcfg_read_data_port

        add     sp, 6                   ;Get rid of six byte buffer
        pop     bp
        pop     ax
        ret
GetPnpMaxCsnAndRdp      endp


;---------------------------------------;
; PnpInitializationKey                  ;
;---------------------------------------;--------------------------------------;
; This function outputs the Plug and Play ISA initialization key to the        ;
; PNP_INDEX_PORT.  This causes all PnP ISA devices to go from "Wait for Key"   ;
; state to "Sleep" state.                                                      ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
PnpInitializationKey    proc near
        push    ax
        push    cx
        push    dx

        mov     dx, PNP_INDEX_PORT
        xor     al, al
        out     dx, al                  ;Clear LFSR by writing 00 to it twice
        out     dx, al
        mov     al, LFSR_INIT_VALUE
        mov     cx, 32

InitKeyNextByte:
        out     dx, al                  ;Write next byte in isolation key
        mov     ah, al                  ;Shift AL once to right and set bit 7
        shr     ah, 1                   ; to (bit 0) XOR (bit 1)
        xor     ah, al
        shr     ah, 1
        rcr     al, 1
        loop    InitKeyNextByte         ;Repeat until 32 values are output

        pop     dx
        pop     cx
        pop     ax
        ret
PnpInitializationKey    endp


;---------------------------------------;
; PnpWakeCsn                            ;
;---------------------------------------;--------------------------------------;
; This function wakes one Plug and Play card causing it to go into "Isolation" ;
; state.  A CSN value of 00h will wake all boards that have not been assigned  ;
; a CSN since they were reset.                                                 ;
;                                                                              ;
; Input: AL = CSN of Plug and Play ISA card to Wake                            ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
PnpWakeCsn      proc near
        push    ax
        push    cx

        mov     ah, PNP_REG_WAKE
        call    PnpWriteReg
        mov     cx, REFRESH_TICKS_IN_250us * 4 ;Delay 1ms
        mov     ah, RT_FIXED_DELAY
        CALL_RT_FUNCTION

        pop     cx
        pop     ax
        ret
PnpWakeCsn      endp


;--------------------------------------;
; ReadResourceByte                     ;
;--------------------------------------;---------------------------------------;
; This function returns the next byte of resource data from the Plug and Play  ;
; ISA device that is currently in "isolation" state.                           ;
;                                                                              ;
; Input:  DX = PnP ISA Read Data Port                                          ;
;                                                                              ;
; Output: CF = Clear if no error, set if timeout waiting for resource data     ;
;              ready bit to go high                                            ;
;         AL = Next byte of resource data                                      ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ReadResourceByte        proc near
        push    bx

        mov     bx, 0FFFFh              ;Retry count
res_byte_wait:
        mov     al, PNP_REG_STATUS
        call    PnpReadReg              ;Read PnP ISA status reg
        test    al, PNP_STAT_RES_READY
        jnz     res_byte_ready          ;Br if next byte of resource data ready
        dec     bx                      ;Dec retry counter
        jnz     res_byte_wait           ;Br if more retries are left
        stc                             ;Indicate failure (timeout)
        jmp     short res_byte_done

res_byte_ready:
        mov     al, PNP_REG_RESOURCE_DATA
        call    PnpReadReg              ;Read next resource data byte
        clc

res_byte_done:
        pop     bx
        ret
ReadResourceByte        endp


;---------------------------------------;
; PnpWriteReg                           ;
;---------------------------------------;--------------------------------------;
; This function writes a byte to a Plug and Play ISA register.  Depending on   ;
; what state the PnP ISA device(s) are in, the data may go to one or all       ;
; PnP ISA devices in the system.                                               ;
;                                                                              ;
; Input: AH = Plug and Play ISA register number (see PNP.EQU)                  ;
;        AL = Data to write to register                                        ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
PnpWriteReg     proc near
        push    dx

        xchg    al, ah
        mov     dx, PNP_INDEX_PORT      ;Write index
        out     dx, al
        xchg    al, ah
        mov     dx, PNP_WR_DATA_PORT    ;Write data
        out     dx, al
        pop     dx
        ret
PnpWriteReg     endp


;---------------------------------------;
; PnpReadReg                            ;
;---------------------------------------;--------------------------------------;
; This function reads a byte from a Plug and Play ISA register.  The device    ;
; that is currently in the "wake" state will respond to the read.              ;
;                                                                              ;
; Input: AL = Plug and Play ISA register number (see PNP.EQU)                  ;
;        DX = PnP ISA Read Data Port                                           ;
;                                                                              ;
; Output: AL = Data read from register                                         ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
PnpReadReg      proc near
        push    dx
        mov     dx, PNP_INDEX_PORT      ;Write index
        out     dx, al
        pop     dx
        in      al, dx                  ;Read data
        ret
PnpReadReg      endp







;---------------------------------------;
; DisplayPciDevices                     ;
;---------------------------------------;--------------------------------------;
; This function displays the slot number, device class and device ID of all    ;
; PCI devices in the system.                                                   ;
;                                                                              ;
; Input: DS = ES = CS                                                          ;
;        AX = 00, no PnP card displayed                                        ;
;           <>00, PnP card displayed                                           ;
;                                                                              ;
; Output: CF = Set if one or more PCI devices were displayed                   ;
;              Clear if no PCI devices were displayed                          ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
DisplayPciDevices       proc near
        pushad

        push    ax
        mov     ax, 0B101h              ;PCI BIOS present function
        int     1Ah                     ;Returns CL = Max PCI bus number
        pop     ax
        cmc
        jnc     DispPciDone             ;Br if no PCI BIOS present

        or      ax, ax                  ;Any PnP card displayed ?
        mov     eax, 'นออฬ'
        jnz     YesPnP                  ;Br if some PnP card displayed
        mov     eax, 'น  ฬ'
YesPnP:
        call    DisplayHorizLine        ;Display 'ฬออออออออ...ออออออออน'
        mov     bh, MsgPciDevices
        call    DisplayStringSet5       ;Display 'บ PCI Devices:'
        mov     al, 76
        call    MoveToColumn            ;Put cursor at end of line
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        call    Display3Spaces

        mov     dh, cl                  ;DH = Max PCI bus
        xor     bh, bh                  ;Start with bus 0
        xor     bp, bp                  ;Zero out device counter

DispPciNextBus:
        xor     bl, bl                  ;Start with device 0

DispPciNextDev:
        shl     bl, 3                   ;Put device num in upper 5 bits

        mov     ax, 0B10Ah              ;PCI BIOS Read Config Dword function
        mov     di, PCI_REG_VENDID
        int     1Ah                     ;Returns ECX = Vend/Dev ID
        inc     ecx
        jz      DispPciSkipDev          ;Br if device's Vend/Dev ID = FFFFFFFF

        mov     ax, 0B108h              ;PCI BIOS Read Config Byte function
        mov     di, PCI_REG_HEADER_TYPE
        int     1Ah                     ;Returns CL = Header Type byte
        mov     dl, 0                   ;Assume max function number is 0
        test    cl, MULTI_FUNC_BIT
        jz      DispPciNextFunc         ;Br if HT[7] is clear (single function)
        mov     dl, 7                   ;Max function number is 7

DispPciNextFunc:
        and     bl, 11111000b           ;Clear function number
        or      bl, dl                  ;Set low 3 bits to currrent function number

        mov     ax, 0B10Ah              ;PCI BIOS Read Config Dword function
        mov     di, PCI_REG_VENDID
        int     1Ah                     ;Returns ECX = Vend/Dev ID
        inc     ecx
        jz      DispPciSkipFunc         ;Br if function's Vend/Dev ID = FFFFFFFF
	cmp	ecx,0530103ah		; 
        jz      DispPciSkipFunc         ;Br if Host Bridge
	cmp	ecx,0001103ah		; 
        jz      DispPciSkipFunc         ;Br if APG Controller
	cmp	ecx,0009103ah
        jz      DispPciSkipFunc         ;Br if PM Controller

        dec     ecx                     ;ECX = vendor / device ID
        call    DisplayOnePciDevice
        jc      DispPciSkipFunc         ;Br if device was not displayed
        inc     bp

DispPciSkipFunc:
        dec     dl                      ;Next function number
        jns     DispPciNextFunc         ;Br if not past func 0

DispPciSkipDev:
        shr     bl, 3                   ;Put device num in lower 5 bits
        inc     bl
        cmp     bl, MAX_PCI_DEVICE_NUM
        jbe     DispPciNextDev          ;Br if not past max PCI dev number

        inc     bh                      ;Next bus number
        cmp     bh, dh
        jbe     DispPciNextBus          ;Br if not past max PCI bus number

        test    bp, 1
        jz      @f                      ;Br if # of devices is even number
        mov     al, 76
        call    MoveToColumn            ;Put cursor at end of line
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        call    Display3Spaces
@@:     
        stc                             ;Indicate devices were displayed

DispPciDone:
        popad
        ret
DisplayPciDevices       endp


;---------------------------------------;
; DisplayOnePciDevice                   ;
;---------------------------------------;--------------------------------------;
; This function displays the slot number and device type of one PCI device.    ;
;                                                                              ;
; Input: ECX = Vendor / Device ID of device to be displayed (Vendor ID         ;
;              is in low word, Device ID is in high word)                      ;
;        BL  = Device/Function number of device                                ;
;                 Bits 7-3: PCI device number                                  ;
;                 Bits 2-0: Function number within the device                  ;
;        BH  = Bus number of device                                            ;
;        BP  = Count of PCI devices displayed                                  ;
;        DS = ES = CS                                                          ;
;                                                                              ;
; Output: CF = Clear if device was displayed                                   ;
;              Set if device was not displayed                                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
DisplayOnePciDevice     proc near
        pusha

        mov     ax, 0B109h              ;PCI BIOS Read Config Word function
        mov     di, PCI_REG_SUB_TYPE
        int     1Ah                     ;Returns CH = Base class CL = Sub class
        mov     dx, cx                  ;DX = Class code
        cmp     dh, 6
        jne     @f                      ;Br if not a bridge class device
        cmp     dl, 4
        jb      DispOnePciSkipDev       ;Br if Host, ISA, EISA, or MCA bridge
@@:
        test    bp, 1
        jnz     @f                      ;Br if # of devices is odd number
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        mov     al, ' '
        call    DisplayChar             ;Display ' '
        jmp     short DisplayPciStart
@@:     mov     al, 40
        call    MoveToColumn            ;Put cursor at middle of line

DisplayPciStart:
        call    PciXlatDevToSlot        ;Returns AL = PCI slot number (0 = onboard)
        or      al, al
        jnz     DispPhysSlot            ;Br if device is in physical slot

	push	bx
	mov	bx, SIS_AGP_P2P_BUS_NUM	+ SIS_AGP_P2P_DEV_FUNC_NUM
        mov     ax, 0B108h              ;PCI BIOS Read Config Byte function
        mov     di, 19h
        int     1Ah                     ;Returns CL = Secondary Bus Number
	pop	bx
	cmp	bh,cl
	jnz	not_agp
	push	bx
;	extrn	agp_display:abs
	mov	bh,agp_display
        mov     bl,09h                  ; string set#
        call    display_message_set
	pop	bx
        jmp     short DispDevType


not_agp:
        or      bh, bh
        push    bx
        mov     bh, MsgPciOnboard
        jz      @f                      ;Br if bus number is 0
        mov     bh, MsgPciBridge
@@:     call    DisplayStringSet5       ;Display 'PCI Onboard ' or 'PCI Bridge  '
        pop     bx
        jmp     short DispDevType

DispPhysSlot:
        push    bx
        mov     bh, MsgPciSlot
        call    DisplayStringSet5       ;Display 'PCI '
        pop     bx
;---------------------------------------;
;;      add     al, '0'                 ;Convert AL to ASCII digit
;;      call    DisplayChar
;;      mov     al, ' '
;;      call    DisplayChar
;;      call    DisplayChar
        cmp     al, 64d
        jbe     dsp_00
        mov     al,' '
        call    DisplayChar
        jmp     short dsp_03
dsp_00:
        call    ConvertBcd              ; AL = BCD number
;        push    ax
;        shr     al,04h
;        jnz     dsp_01
;        mov     al,' '
;        jmp     short dsp_02
;dsp_01:
;        add     al,'0'
;dsp_02:
;        call    DisplayChar
;        pop     ax
        and     al,0fh
        add     al,'0'
dsp_03:
        call    DisplayChar
;        mov     al, ' '
;        call    DisplayChar
        mov     al, ' '
        call    DisplayChar
;---------------------------------------;

DispDevType:
        call    GetPciDeviceType        ;Display device type

COMMENT ~	
	push	ds
	push	0de00h
	pop	ds
	cmp	byte ptr ds:[0],0ffh
	pop	ds
	jz	@f

	pusha
        mov     ax,2f02h                ; Stop USB Host controller
        CALL_RT_FUNCTION

	db	09ah
	dw	0
	dw	0de00h
	int	3
	popa
@@:
~
;---------------------------------------; Added 08/11/97
        mov     di, PCI_REG_VENDID
        mov     ax, 0B10Ah              ;PCI BIOS Read Config Byte function
        int     1Ah
	cmp	ecx, 00011061h		; XTEC VGA ?
	jz	dsp_04
;---------------------------------------; Added 12/18/96
;  Display IRQ for the PCI device
        mov     di, PCI_REG_INT_LINE    ;offset 3ch
        mov     ax, 0B108h              ;PCI BIOS Read Config Byte function
        int     1Ah
	cmp	bx,S5513_BUS_NUM + S5513_DEV_FUNC_NUM; OnBoard IDE?
	jnz	not_ide			; Br, if not IDE device number
	mov	di, 4ah
        mov     ax, 0B108h              ;PCI BIOS Read Config Byte function
        int     1Ah
	mov	ch,0
	test	cl,02h			; Primary IDE enabled?
	jz	check_ide2		; Br, if IDE disabled
	mov	ch,0eh
check_ide2:
	and	cl,04h			; Secondary IDE enabled?
	or	cx,cx
	jz	not_ide
	or	ch,ch
	jz	display_ide2
	push	cx
        mov     bh,StrIrq
        call    DisplayStringSet5
        mov     al,ch
        call    display_al
	pop	cx
display_ide2:
	or	cl,cl
	jz	ide_done
	mov	cl,0fh
	or	ch,ch
	jz	not_ide
        mov     al, ','
        call    DisplayChar             ;Display ','
	mov	al,cl
        call    display_al
ide_done:
	xor	cl,cl
not_ide:
        or      cl,cl
        jz      dsp_04                  ;Br if does not use IRQ
        cmp     cl,15
        ja      dsp_04                  ;Br if Invalid IRQ
        mov     bh,StrIrq
        call    DisplayStringSet5
        mov     al,cl
        extrn   display_al:near
        call    display_al
dsp_04:
;---------------------------------------; Added 12/18/96

        test    bp, 1
        jz      @f                      ;Br if # of devices is even number
        mov     al, 76
        call    MoveToColumn            ;Put cursor at end of line
        mov     al, 'บ'
        call    DisplayChar             ;Display 'บ'
        call    Display3Spaces
@@:
        clc                             ;Indicate device was displayed

DispOnePciSkipDev:
        popa
        ret
DisplayOnePciDevice     endp


;---------------------------------------;
; GetPciDeviceType                      ;
;---------------------------------------;--------------------------------------;
; This function translates a PCI device's base class and sub class code into   ;
; an string# and display the string.                                           ;
;                                                                              ;
; Input:  DH = PCI device base class code                                      ;
;         DL = PCI device sub class code                                       ;
;         DS = ES = CS                                                         ;
;                                                                              ;
; Output: None                                                                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
GetPciDeviceType        proc near
        pusha

        mov     si, offset cgroup:DevTypeTableStart
        mov     cx, (offset cgroup:DevTypeTableEnd - offset cgroup:DevTypeTableStart) / size DevTypeEntry

GetDeviceTypeNext:
        cmp     (DevTypeEntry ptr [si]).BaseClass, dh
        jne     GetDeviceTypeSkip       ;Br if base class does not match

        cmp     (DevTypeEntry ptr [si]).SubClass, dl
        je      GetDeviceTypeFound      ;Br if base and sub class match

        cmp     (DevTypeEntry ptr [si]).SubClass, 80h
        je      GetDeviceTypeFound      ;Br if base class matches and sub class is unknown

GetDeviceTypeSkip:
        add     si, size DevTypeEntry   ;Next entry in DevTypeTable
        loop    GetDeviceTypeNext

        mov     si, offset cgroup:DevTypeUnknown

GetDeviceTypeFound:
        mov     bh, (DevTypeEntry ptr [si]).DevTypeStr; BH = string#
        call    DisplayStringSet5
        popa
        ret
GetPciDeviceType        endp



;---------------------------------------;
; PciXlatDevToSlot                      ;
;---------------------------------------;--------------------------------------;
; This function translates a PCI bus/dev/function number to a physical slot    ;
; number using the IRQ routing table.                                          ;
;                                                                              ;
; Input: BL  = Device/Function number of device                                ;
;                 Bits 7-3: PCI device number                                  ;
;                 Bits 2-0: Function number within the device                  ;
;        BH  = Bus number of device                                            ;
;                                                                              ;
; Output: AL = Physical slot number (0 if device is onboard or behind bridge)  ;
;                                                                              ;
; Destroys: AH                                                                 ;
;------------------------------------------------------------------------------;
PciXlatDevToSlot        proc near
        push    bx
        push    dx

        mov     dx, bx                  ;DX = bus/dev/func number
        and     dl, 0F8h                ;Clear function number
        mov     al, 1                   ;Start with slot 1

DevToSlotNextSlot:
;;        mov     bx, 0FFFFh
        mov     ah, RT_PCI_SLOT_TO_DEV
        CALL_RT_FUNCTION                ;Translate slot AL to bus/dev in BX
        cmp     bx, dx
        je      DevToSlotFound          ;Br if found slot in IRQ routing table
        inc     al
        cmp     al, 64d
        jb      DevToSlotNextSlot       ;Br if not past slot 64

        mov     al, 0                   ;Indicate on-board / behind bridge

DevToSlotFound:
        pop     dx
        pop     bx
        ret
PciXlatDevToSlot        endp


;---------------------------------------;
; DisplayHorizLine                      ;
;---------------------------------------;--------------------------------------;
; This function displays the name of each PnP ISA card in the system.          ;
;                                                                              ;
; Input: EAX = Byte 0: Character to use for leftmost character on line         ;
;              Byte 1: Character to use for body of the line                   ;
;              Byte 2: Character to use for middle character on line           ;
;              Byte 3: Character to use for rightmost character of the line    ;
;        DS = ES = CS                                                          ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
DisplayHorizLine        proc near
        push    cx

        call    DisplayChar             ;Display leftmost character

        ror     eax, 8
        cmp     al, ' '                 ;Space ?
        jnz     HorizLineBody
        mov     al, 76
        call    MoveToColumn            ;Move cursor to col 76
        jmp     short HorizLineRight
HorizLineBody:
        mov     cx, 75
HorizLineNext0:
        call    DisplayChar             ;Display left half of body character 37 times
        loop    HorizLineNext0

;        ror     eax, 8
;        call    DisplayChar             ;Display middle character
        
;        rol     eax, 8
;        mov     cx, 37
;HorizLineNext1:
;        call    DisplayChar             ;Display right half of body character 37 times
;        loop    HorizLineNext1

HorizLineRight:
        ror     eax, 16
        call    DisplayChar             ;Display rightmost character

        call    Display3Spaces
        
        pop     cx
        ret
DisplayHorizLine        endp


;---------------------------------------;
; Display3Spaces                        ;
;---------------------------------------;--------------------------------------;
; This function displays three space characters.                               ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
Display3Spaces  proc near
        push    ax

        mov     al, ' '
        call    DisplayChar
        call    DisplayChar
        call    DisplayChar

        pop     ax
        ret
Display3Spaces  endp

;---------------------------------------;
; DisplayStringSet5                     ;
;---------------------------------------;--------------------------------------;
; This routine displays the given string from String Set 5.                    ;
;                                                                              ;
; Input: BH = String#                                                          ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
DisplayStringSet5       proc    near
        pusha
        mov     bl, 05h                 ;String set#
        call    display_message_set     ;Display the string
        popa
        ret
DisplayStringSet5       endp


;---------------------------------------;
; DisplayChar                           ;
;---------------------------------------;--------------------------------------;
; This routine displays one ASCII character.                                   ;
;                                                                              ;
; Input: AL = ASCII character to display                                       ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
        extrn   write_tty:near
DisplayChar     proc near
        push    ax
        push    bx
        call    write_tty
        pop     bx
        pop     ax
        ret
DisplayChar     endp


;---------------------------------------;
; MoveToColumn                          ;
;---------------------------------------;--------------------------------------;
; This function moves the cursor to the given column on the current line.      ;
;                                                                              ;
; Input: AL = Column number to move to (0 - 79)                                ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
MoveToColumn    proc near
        pusha

        push    ax
        call    read_cursor_posn
        pop     ax

        mov     dl, al                  ;DL = new cursor column
        call    set_cursor_posn

        popa
        ret
MoveToColumn    endp

;---------------------------------------;
; ConvertBcd                            ;
;---------------------------------------;--------------------------------------;
; This function converts binary to BCD.                                        ;
;                                                                              ;
; Input: AL = Binary number (<= 99)                                            ;
;                                                                              ;
; Output: AL = BCD                                                             ;
;                                                                              ;
; Destroys: AX                                                                 ;
;------------------------------------------------------------------------------;
ConvertBcd:
;;        push    cx
;;        movzx   ax,al
;;        mov     cl,10                   ; convert to decimal
;;        div     cl                      ; divide by 10
;;;  AH, AL = remainder, quotient
;;        shl     al,04h
;;        or      al,ah
;;        pop     cx
        aam
        shl     ah,04h
        or      al,ah
        ret

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
