;-----------------------------------------------------------------------;
;                       ICS9148ReadByte                                 ;
;-----------------------------------------------------------------------;
; Input :                                                               ;
; Output:                                                               ;
; Register destroyed: None                                              ;
;-----------------------------------------------------------------------;
ICS9148ReadByte         PROC    PUBLIC
        ret
ICS9148ReadByte         ENDP


;-----------------------------------------------------------------------;
;                       ICS9148WriteByte                                ;
;-----------------------------------------------------------------------;
; Input : (AL) ICS9148 data                                             ;
; Output: None                                                          ;
; Register destroyed: None                                              ;
;-----------------------------------------------------------------------;
ICS9148WriteByte        PROC    PUBLIC
        pusha
        push    ax
        call    PreEnableI2CBus         ;I2C bus Data/Clock active level High
        call    EnableI2CBus            ;Enable I2C bus

StrI2CRd:
        call    StrI2CCycle

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM write
        mov     dh, 01001011b    ; I2C data
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      CommandTimingErr

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM address
        mov     dh, 00000000b    ; I2C data
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      AddressTimingErr

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM address
        mov     dh, 11100000b    ; I2C data, byte count is 07h ( 00000111b )
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      AddressTimingErr

        call    CsI2CDummy

        pop     ax
        mov     dh, al

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM read
;;;     mov     dh, 00101111b    ; I2C data
;       mov     dh, 00010010b    ; I2C data
;          bit 0 ---+|||| |+--- bit 7 , spread spectrum modulation
;          bit 1 ----+||+-+---- bit 6:4 , cpu/pci/agp clock
;                     |+------- bit 3 , frequency selection
;                     +-------- bit 2, must be 0
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      WriteTimingErr

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM read
        mov     dh, 11110000b    ; I2C data
;bit 0 , CPUCLK0 ---+|||+--+--- bit 7:4 , reserved
;bit 1 , CPUCLK1 ----+||
;bit 2 , CPUCLK2 -----+|
;bit 3 , CPUCLK3 ------+
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      WriteTimingErr

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM read
        mov     dh, 11111110b    ; I2C data
;bit 0 , PCICLK0 ---+||||||+--- bit 7 , reserved
;bit 1 , PCICLK1 ----+||||+---- bit 6 , PCICLK_F
;bit 2 , PCICLK2 -----+||+----- bit 5 , AGPO
;bit 3 , PCICLK3 ------+|
;bit 4 , PCICLK4 -------+
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      WriteTimingErr

        call    CsI2CDummy


        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM read
        mov     dh, 11111111b    ; I2C data
;bit 0 , SDRAM 0 ---+||||||+--- bit 7 , SDRAM 7
;bit 1 , SDRAM 1 ----+||||+---- bit 6 , SDRAM 6
;bit 2 , SDRAM 2 -----+||+----- bit 5 , SDRAM 5
;                      |+------ bit 4 , SDRAM 4
;                      +------- bit 3 , SDRAM 3
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      WriteTimingErr

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM read
        mov     dh, 11110000b    ; I2C data
;bit 0 , SDRAM 8 ---+|||+--+--- bit 7:4 , reserved
;bit 1 , SDRAM 9 ----+||
;bit 2 , SDRAM 10 ----+|
;bit 3 , SDRAM 11 -----+
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      WriteTimingErr

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM read
        mov     dh, 11001000b    ; I2C data
;bit 0 , REF1    ---+||||+-+--- bit 7:5 , reserved
;bit 1 , REF0    ----+||+------ bit 4 , AGP1
;                     ++------- bit 3:2 , reserved
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      WriteTimingErr

        call    CsI2CDummy

        mov     ah, 08h          ; 8 bits need to program SDRAM EEPROM read
        mov     dh, 00000000b    ; I2C data
;                   ++++++++--- bit 7:0 , reserved
        mov     dl, 11111111b    ; I2C clock
        call    csI2CCmd

        call    ChkAck
;;;     jc      WriteTimingErr

        call    CsI2CDummy
        call    PreStpI2CCycle
;       jmp     NxtI2CSDRAM

CommandTimingErr:
;       push    dx
;       mov     dx, offset CmdFail_Msg
;       call    Disp_String
;       pop     dx

;       push    dx
;       mov     dx, offset Address_Msg
;       call    Disp_String
;       pop     dx
;       jmp     NxtI2CSDRAM

AddressTimingErr:
;       push    dx
;       mov     dx, offset AddFail_Msg
;       call    Disp_String
;       pop     dx

;       push    dx
;       mov     dx, offset Address_Msg
;       call    Disp_String
;       pop     dx
;       jmp     NxtI2CSDRAM

ReadTimingErr:
;       push    dx
;       mov     dx, offset RdFail_Msg
;       call    Disp_String
;       pop     dx

;       push    dx
;       mov     dx, offset Address_Msg
;       call    Disp_String
;       pop     dx
;       jmp     NxtI2CSDRAM

WriteTimingErr:
;       push    dx
;       mov     dx, offset WrFail_Msg
;       call    Disp_String
;       pop     dx

;       push    dx
;       mov     dx, offset Address_Msg
;       call    Disp_String
;       pop     dx
;       jmp     NxtI2CSDRAM

OutFisTimingErr:
;       push    dx
;       mov     dx, offset NoData_Msg
;       call    Disp_String
;       pop     dx

;       push    dx
;       mov     dx, offset Address_Msg
;       call    Disp_String
;       pop     dx

NxtI2CSDRAM:
        call    PreEnableI2Cbus
I2COK:
        popa
        ret
ICS9148WriteByte        ENDP
