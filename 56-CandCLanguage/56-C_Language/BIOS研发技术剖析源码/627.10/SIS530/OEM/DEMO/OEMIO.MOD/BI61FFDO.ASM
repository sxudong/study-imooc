        page    ,132
        title.  IT8661F Floppy Controller Disable
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
; IT8661FBBlkFloppyControllerOff        ;
;---------------------------------------;-------------------------------------;
; This function turns off the peripheral chip's FDC.                          ;
;                                                                             ;
; Input:  Stack available                                                     ;
;                                                                             ;
; Output: Nothing                                                             ;
;                                                                             ;
; Destroys: Nothing                                                           ;
;-----------------------------------------------------------------------------;
        extrn   IT8661FBBlkWriteIO_x:near
        public  IT8661FBBlkFloppyControllerOff
IT8661FBBlkFloppyControllerOff  proc    near
        pushad
        xor     bl, bl                  ;Select Logical Device 0 (FDC)
        mov     ax, 0030h               ;Deactivate
        jmp_di  IT8661FBBlkWriteIO_x
        popad
        ret
IT8661FBBlkFloppyControllerOff  endp


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
