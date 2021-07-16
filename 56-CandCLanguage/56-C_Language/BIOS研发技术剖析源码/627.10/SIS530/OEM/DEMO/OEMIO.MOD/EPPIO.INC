;;      page    ,132
;;      title   IT8661F Specific EPP support routines
.386
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1998, American Megatrends Inc.        **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**             6145-F, Northbelt Parkway, Norcross,            **;
;**                                                             **;
;**             Georgia - 30071, USA. Phone-(770)-246-8600.     **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;

extrn   cmos_data_in_x:near
extrn   update_extd_cmos_checksum:near

;-----------------------------------------------------------------------
; get_io_lpt_port_info
;
; Returns interrupt level for the LPT port and its capabilities.
;-----------------------------------------------------------------------
;
; Input:        DX = LPT I/O port base address
;
; Output:       AL = Interrupt level of EPP port (0-15)
;                  = FF if interrupts not supported
;               BL = I/O Capabilities
;                       bit 0 = Multiplexor present
;                       bit 1 = PS/2 bi-directional capable
;                       bit 2 = Daisy chain present
;                       bit 3 = ECP capable
;
; Register Usage: AX, BL
;
;-----------------------------------------------------------------------
IT8661F_IO_CAPABILITY   equ     00001010b       ; ECP, Daisy, PS/2, MUX

get_io_lpt_port_info    proc    near    private
        push    dx
        push    bx
        call    GetHardwareIrqMask      ;BX = IRQ channnel (mask)
                                        ;Destroyed DX
        bsf     bx, bx
        jnz     @F
        mov     bl, 0ffh
@@:
        mov     al, bl
        pop     bx
        mov     bl, IT8661F_IO_CAPABILITY       ; It8680 mode supports
        pop     dx
        ret
get_io_lpt_port_info    endp


;-----------------------------------------------------------------------
; get_io_lpt_port_addr
;
; Returns the address setting for the hardware LPT port.
;-----------------------------------------------------------------------
;
; Input:        None
;
; Output:       DX = port address
;                  = 0 if LPT port disabled
;
; Register Usage: DX
;
;-----------------------------------------------------------------------
get_io_lpt_port_addr    proc    near    private
        push    ax
        push    bx
        call    GetHardwareConfig       ;AL = 0/1/2/3 for Disabled/378/278/3BC
        movzx   bx, al
        shl     bx, 1
        mov     dx, word ptr cs:Xlatable[bx]
        pop     bx
        pop     ax
        ret
        
Xlatable:
        dw      0, 378h, 278h, 3BCh
        
get_io_lpt_port_addr    endp


;-----------------------------------------------------------------------
; set_io_lpt_port_mode
;
; Set the LPT port to the mode specified in AL.
;-----------------------------------------------------------------------
;
; Input:        AL = mode bits
;                       0 - compatibility mode
;                       1 - Bi-directional mode
;                       2 - EPP mode
;                       3 - ECP mode
;                       4 - EPP emulation (via standard parallel port)
;
; Output:       AH = error code
;
; Register Usage: AX
;
;-----------------------------------------------------------------------
set_io_lpt_port_mode    proc    near    private
        push    bx
        mov     ah, epp_cmd_not_supported
        or      al, al
        jz      sippm_exit              ; no mode specified, exit
        and     al, 1fh
        cmp     al, 8                   ; max is bit 3
        ja      sippm_exit              ; error, exit
        bsf     ax, ax
        mov     bx, offset XlatTable
        xlat    cs:[bx]
        call    IT8661FSetPPMode
        xor     ah, ah                  ;no error
sippm_exit:
        pop     bx
        ret
        
XlatTable:
        db      0, 0, 1, 2
        
set_io_lpt_port_mode    endp


;-----------------------------------------------------------------------
; get_io_lpt_port_mode
;
; Returns the current operating mode of the LPT port.
;-----------------------------------------------------------------------
;
; Input:        None
;
; Output:       AL = current mode (bits)
;                       0 - compatibility mode
;                       1 - Bi-directional mode
;                       2 - EPP mode
;                       3 - ECP mode
;                       4 - EPP software emulation
;                       7 - EPP port interrupts enabled
;
; Register Usage: AX
;
;-----------------------------------------------------------------------
get_io_lpt_port_mode    proc    near    private
        push    dx
        push    bx
        
;get port interrupt status
        add     dx, 2                   ;control register
        in      al, dx
        and     al, 10h
        shl     al, 3                   ;move to bit 7
        mov     ah, al
        
;get mode from hardware
        mov     al, 0f0h
        mov     bl, 03h                 ;select logical dev 3 (LPT)
        call    IT8661FReadIO           ;AL = 0/1/2 for Normal/EPP/ECP
        mov     bx, offset cs:XlatTable
        xlat    cs:[bx]
        or      al, ah
        
        pop     bx
        pop     dx
        ret
        
XlatTable:
        db      00000000b, 00000100b, 00001000b
        
get_io_lpt_port_mode    endp

