        page    ,132
        title.  ITE8661F Common Routines for COMA/COMB/LPT/Floppy/Ir
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
; $Header: /BIOS/PORTING/IO.112/IT8661F/RI61FX1.ASM 1   98/06/04 12:00a $
;
; $Revision: 1 $
;
; $Date: 98/06/04 12:00a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/PORTING/IO.112/IT8661F/RI61FX1.ASM $
; 
; 1     98/06/04 12:00a Chung
; Initial release.
; 
;*****************************************************************;
;---------------------------------------;
        include devnode.equ
        include io.equ
;---------------------------------------;
        extrn   get_cmos_item:near
;---------------------------------------;
        public  IT8661FCommonRegisterInit
        public  IT8661FReadIO
        public  IT8661FWriteIO
        public  IT8661FRead6061
        public  IT8661FWrite6061
;---------------------------------------;
        extrn   IoIndexPort             :near
        extrn   IoDataPort              :near
        extrn   RegisterInitTableStart  :near
        extrn   REGINITCOUNT            :abs
;---------------------------------------;

;---------------------------------------;
;       C O D E     S E G M E N T       ;
;---------------------------------------;
.386
cgroup  group   _text
_text segment word public USE16 'CODE'
         assume cs:CGROUP


IOKey           label   byte
        db      86h, 61h, 55h,  55h     ;For 3F0
        db      86h, 61h, 55h,  0AAh    ;For 3BD
        db      86h, 61h, 0AAh, 55h     ;For 370

ConfigKey       label   byte
        db      06ah, 0b5h, 0dah, 0edh, 0f6h
        db      0fbh, 07dh, 0beh, 0dfh, 06fh
        db      037h, 01bh, 00dh, 086h, 0c3h
        db      061h, 0b0h, 058h, 02ch, 016h
        db      08bh, 045h, 0a2h, 0d1h, 0e8h
        db      074h, 03ah, 09dh, 0ceh, 0e7h
        db      073h, 039h
ConfigKeyEnd:


;---------------------------------------;
; IT8661FCommonRegisterInit             ;
;---------------------------------------;-------------------------------------;
; This function initializes the peripheral chip's registers to power on       ;
; defaults and prepares the chip for configuration.                           ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FCommonRegisterInit       proc near
        pusha
        pushf                           ; Save CLI/STI state
        cli

        mov     dx, 3F2h                ; Disable int and dma bits in primary port
        xor     al, al
        out     dx, al

        mov     cx, REGINITCOUNT
        mov     si, offset cgroup:RegisterInitTableStart

reg_init_next:
        db      2eh                     ; CS:
        lodsb           
        mov     bl, al                  ; BL = Logical Device Number
        db      2eh                     ; CS:
        lodsw                           ; AH = Data, AL = Register Number
        call    IT8661FWriteIO
        loop    reg_init_next

        popf                            ; Restore CLI/STI state
        popa
        ret
IT8661FCommonRegisterInit       endp


;---------------------------------------;
; IT8661FReadIO                         ;
;---------------------------------------;-------------------------------------;
; This routine reads a given IT8661F register.                                ;
;                                                                             ;
; Input:  AL = Register number to read                                        ;
;         BL = Logical Device Number                                          ;
;         Stack available                                                     ;
;                                                                             ;
; Output: AL = Byte read from register                                        ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FReadIO   proc near
        push    dx
        call    EnterConfig
        call    SelectLogicalDevice
        mov     dx, word ptr cs:IoIndexPort     ;DX = index port address
        out     dx, al                          ;Select I/O register
        jcxz    short $+2
        mov     dx, word ptr cs:IoDataPort      ;DX = data port address
        in      al, dx                          ;AL = data
        jcxz    short $+2
        call    ExitConfig
        pop     dx
        ret
IT8661FReadIO   endp


;---------------------------------------;
; IT8661FWriteIO                        ;
;---------------------------------------;-------------------------------------;
; This routine writes to a given IT8661F register.                            ;
;                                                                             ;
; Input:  AL = Register number to write                                       ;
;         AH = Data to write                                                  ;
;         BL = Logical Device Number                                          ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FWriteIO  proc near
        push    dx
        call    EnterConfig
        call    SelectLogicalDevice
        mov     dx, word ptr cs:IoIndexPort     ;DX = index port address
        out     dx, al                          ;Select I/O register
        jcxz    short $+2
        mov     dx, word ptr cs:IoDataPort      ;DX = data port address
        xchg    al, ah                          ;AH = Reg #, AL = Data to write
        out     dx, al
        jcxz    short $+2
        xchg    al, ah                          ;AH = Data, AL = Reg #
        call    ExitConfig
        pop     dx
        ret
IT8661FWriteIO  endp


;---------------------------------------;
; SelectLogicalDevice                   ;
;---------------------------------------;-------------------------------------;
; This routine selects the logical device of the IT8661F.                     ;
;                                                                             ;
; Input:  BL = Logical Device Number                                          ;
;         Stack available                                                     ;
;                                                                             ;
; Output: None                                                                ;
;                                                                             ;
; Destroys: None                                                              ;
;-----------------------------------------------------------------------------;
SelectLogicalDevice     proc near private
        push    ax
        push    dx
        mov     dx, word ptr cs:IoIndexPort     ;DX = index port address
        mov     al, 07h                         ;Logical device register
        out     dx, al
        jcxz    short $+2
        mov     dx, word ptr cs:IoDataPort      ;DX = data port address
        mov     al, bl
        out     dx, al
        pop     dx
        pop     ax
        ret
SelectLogicalDevice     endp


;---------------------------------------;
; IT8661FReadGlobal                     ;
;---------------------------------------;-------------------------------------;
; This routine reads a given IT8661F register.                                ;
;                                                                             ;
; Input:  AL = Register number to read                                        ;
;         Stack available                                                     ;
;                                                                             ;
; Output: AL = Byte read from register                                        ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FReadGlobal       proc near
        push    dx
        call    EnterConfig
        mov     dx, word ptr cs:IoIndexPort     ;DX = index port address
        out     dx, al
        jcxz    short $+2
        mov     dx, word ptr cs:IoDataPort      ;DX = data port address
        in      al, dx
        call    ExitConfig
        pop     dx
        ret
IT8661FReadGlobal       endp


;---------------------------------------;
; IT8661FWriteGlobal                    ;
;---------------------------------------;-------------------------------------;
; This routine writes to a given IT8661F register.                            ;
;                                                                             ;
; Input:  AL = Register number to write                                       ;
;         AH = Data to write                                                  ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FWriteGlobal      proc near
        push    ax
        push    dx
        call    EnterConfig
        mov     dx, word ptr cs:IoIndexPort     ;DX = index port address
        out     dx, al                          ; Select I/O register
        jcxz    short $+2
        mov     dx, word ptr cs:IoDataPort      ;DX = data port address
        xchg    al, ah                          ; AH = Reg #, AL = Data to write
        out     dx, al
        jcxz    short $+2
        xchg    al, ah                          ; AH = Data, AL = Reg #
        call    ExitConfig
        pop     dx
        pop     ax      
        ret
IT8661FWriteGlobal      endp


;---------------------------------------;
; EnterConfig                           ;
;---------------------------------------;-------------------------------------;
; This routine puts the IT8661F into MB PnP Mode.                             ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         Stack available                                                     ;
;                                                                             ;
; Output: None                                                                ;
;                                                                             ;
; Destroys: None                                                              ;
;-----------------------------------------------------------------------------;
EnterConfig     proc near private
        cli
        pusha

        xor     bx, bx
        cmp     word ptr cs:IoIndexPort, 03F0h
        je      @F
        add     bx, 4
        cmp     word ptr cs:IoIndexPort, 03BDh
        je      @F
        add     bx, 4                           ;Must be 0370h
@@:
        mov     dx, 279h
        mov     cx, 4

SelectIndexPort:
        mov     al, cs:IOKey[bx]
        out     dx, al
        inc     bx
        loop    SelectIndexPort
        
        mov     dx, word ptr cs:IoIndexPort
        xor     bx, bx
        mov     cx, offset ConfigKeyEnd - offset ConfigKey
        
SendConfigKey:
        mov     al, cs:ConfigKey[bx]
        out     dx, al
        inc     bx
        loop    SendConfigKey
        
        popa
        ret
EnterConfig     endp


;---------------------------------------;
; ExitConfig                            ;
;---------------------------------------;-------------------------------------;
; This routine takes the IT8661F out of MB PnP Mode.                          ;
;                                                                             ;
; Input:  Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
ExitConfig      proc near private
        push    ax
        push    dx
        mov     dx, word ptr cs:IoIndexPort     ;DX = index port address
        mov     al, 2                           ;CR 02
        out     dx, al
        inc     dx
        jmp     short $+2
        out     dx, al                          ;Escape configuration mode
        pop     dx
        pop     ax
        ret
ExitConfig      endp


;---------------------------------------;
; IT8661FWrite6061                      ;
;---------------------------------------;-------------------------------------;
; This routine writes to IT8661F register 60 and 61.                          ;
;                                                                             ;
; Input:  AH = Data to write to register 60                                   ;
;         AL = Data to write to register 61                                   ;
;         BL = Logical Device Number                                          ;
;         Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FWrite6061                proc near
        push    cx
        mov     cx, ax
        mov     al, 60h                 ; Write to register CR60
        call    IT8661FWriteIO
        mov     ah, cl
        inc     al                      ; Write to register CR61
        call    IT8661FWriteIO
        mov     ax, cx
        pop     cx
        ret
IT8661FWrite6061                endp


;---------------------------------------;
; IT8661FRead6061                       ;
;---------------------------------------;-------------------------------------;
; This routine reads IT8661F register 60 and 61.                              ;
;                                                                             ;
; Input:  Nothing                                                             ;
;         BL = Logical Device Number                                          ;
;         Stack available                                                     ;
;                                                                             ;
; Output: AX = Data in register 60 and 61                                     ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
IT8661FRead6061         proc near
        mov     al, 60h                 ; Read from register CR60
        call    IT8661FReadIO
        mov     ah, al
        mov     al, 61h                 ; Read from register CR61
        call    IT8661FReadIO
        ret
IT8661FRead6061         endp


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
