        page    ,132
        title.  IT8661F Common Bootblock Routines
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
; $Header: /BIOS/PORTING/IO.112/IT8661F/BI61FX.ASM 1    98/06/04 12:00a $
;
; $Revision: 1 $
;
; $Date: 98/06/04 12:00a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/PORTING/IO.112/IT8661F/BI61FX.ASM $
; 
; 1     98/06/04 12:00a Chung
; Initial release.
; 
;*****************************************************************;
;---------------------------------------;
        include mbiosmac.mac
;---------------------------------------;
        extrn   IoIndexPort:near
        extrn   IoDataPort:near
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
; IT8661FBBlkWriteIO_x                  ;
;---------------------------------------;-------------------------------------;
; This routine writes to a given IT8661F register.                            ;
;                                                                             ;
; Input:  AL = Register number to write                                       ;
;         AH = Data to write                                                  ;
;         BL = Logical Device Number                                          ;
;         DI = Return address                                                 ;
;         Stack not available                                                 ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: EAX, EBX, ECX                                                     ;
;-----------------------------------------------------------------------------;
IT8661FBBlkWriteIO_x    proc near
        mov     cx, dx                          ;Save DX
        shl     ecx, 16
        
        shl     eax, 16                         ;Save AX
        shl     ebx, 16                         ;Save BX
        
; Enter MB PnP Mode
        xor     bx, bx
        cmp     word ptr cs:IoIndexPort, 03F0h
        je      @F
        add     bx, 4
        cmp     word ptr cs:IoIndexPort, 03BDh
        je      @F
        add     bx, 4                           ;Must be 370h
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
        
; Write Data
        shr     ebx, 16                         ;BL = Logical Device Number
        mov     al, 7                           ;Select Logical Device
        out     dx, al
        inc     dx                              ;DX = Data Port
        mov     al, bl
        out     dx, al
        dec     dx                              ;DX = Index Port
        shr     eax, 16                         ;AX = Data/Register to write
        out     dx, al
        inc     dx                              ;DX = Data Port
        xchg    ah, al                          ;Write Data
        out     dx, al
        
; Exit MB PnP Mode
        dec     dx                              ;DX = Index Port
        mov     al, 2                           ;CR 02
        out     dx, al
        inc     dx                              ;DX = Data Port
        jmp     $+2
        out     dx, al
        
        shr     ecx, 16
        mov     dx, cx
        jmp     di
IT8661FBBlkWriteIO_x    endp


;-----------------------------------------------------------------------------;
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
