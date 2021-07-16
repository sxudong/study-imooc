        page    ,132
        title.  IT8661F Floppy Controller Auto
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
; $Header: /BIOS/PORTING/IO.112/IT8661F/BI61FFDA.asm 1          98/06/04 12:00a $
;
; $Revision: 1 $
;
; $Date: 98/06/04 12:00a $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/PORTING/IO.112IT8661F/BI61FFDA.ASM $
; 
; 1     98/06/04 12:00a Chung
; Initial release.
; 
;*****************************************************************;
;---------------------------------------;
        include mbiosmac.mac
;---------------------------------------;
;       C O D E     S E G M E N T       ;
;---------------------------------------;
.386
cgroup  group   _text
_text segment word public USE16 'CODE'
         assume cs:CGROUP


;---------------------------------------;
; IT8661FBBlkFloppyControllerAuto       ;
;---------------------------------------;-------------------------------------;
; This function detects the presence FDC and enables the peripheral chip's FDC;
; if no offboard FDC is found.                                                ;
;                                                                             ;
; Input:  Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
        extrn   fixed_delay:near
        extrn   IT8661FBBlkWriteIO_x:near
        extrn   IT8661FBBlkFloppyControllerOff:near
        public  IT8661FBBlkFloppyControllerAuto
IT8661FBBlkFloppyControllerAuto proc    near
        pushad
        call    IT8661FBBlkFloppyControllerOff  ;Turn off on-board FDC
        mov     dx, 3f2h
        xor     al, al          
        out     dx, al                  ;Write 0 to port 3f2h..turn on reset
        mov     cx, 9
        call    fixed_delay
        mov     al, 4
        out     dx, al                  ;Write 4 to port 3f2h..turn off reset
        mov     cx, 9
        call    fixed_delay
        mov     dx, 3f4h                ;Read status port 3f4h
        in      al, dx
        cmp     al, 80h                 ;RQM ready ?
        jz      fdcauto_00              ;Yes, off-board floppy present
        
;  off-board FDC not found, enable on-board FDC
        mov     bl, 00h                 ;Select Logical Device 0 (FDC)
        mov     ax, 0130h               ;Enable FDC
        jmp_di  IT8661FBBlkWriteIO_x
        
fdcauto_00:
        popad
        ret
IT8661FBBlkFloppyControllerAuto endp


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
