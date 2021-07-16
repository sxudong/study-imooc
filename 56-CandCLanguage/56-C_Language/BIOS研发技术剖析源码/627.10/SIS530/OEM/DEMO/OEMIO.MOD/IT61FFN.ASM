        page    ,132
        title.  ITE8661F Parallel Port External Functions
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
        public  IT8661F_Lpt_Addr_Xfn
        public  IT8661F_Lpt_Mode_Xfn
        public  IT8661F_Lpt_Dma_Xfn
        public  IT8661F_Lpt_Irq_Xfn
;---------------------------------------;
        extrn   STR_DISABLED            :abs
        extrn   STR_RESERVED            :abs
        extrn   STR_END                 :abs
        extrn   STR_IT8661F_NA          :abs
        extrn   STR_IT8661F_AUTO        :abs
        extrn   STR_IT8661F_378         :abs
        extrn   STR_IT8661F_278         :abs
        extrn   STR_IT8661F_3BC         :abs
        extrn   STR_IT8661F_NORMAL      :abs
        extrn   STR_IT8661F_EPP         :abs
        extrn   STR_IT8661F_ECP         :abs
        extrn   STR_IT8661F_EPPECP      :abs
        extrn   STR_IT8661F_0           :abs
        extrn   STR_IT8661F_1           :abs
        extrn   STR_IT8661F_3           :abs
        extrn   STR_IT8661F_4           :abs
        extrn   STR_IT8661F_5           :abs
        extrn   STR_IT8661F_7           :abs
        extrn   STR_IT8661F_9           :abs
        extrn   STR_IT8661F_10          :abs
        extrn   STR_IT8661F_11          :abs
        extrn   STR_IT8661F_12          :abs
;---------------------------------------;
        extrn   PERIPHERAL_CODE_NOT_PRESENT:abs
        
        extrn   Q_IT8661F_IR_PORT (PERIPHERAL_CODE_NOT_PRESENT):abs
        extrn   Q_IT8661F_LPT_PORT (PERIPHERAL_CODE_NOT_PRESENT):abs
        extrn   Q_IT8661F_LPT_MODE (PERIPHERAL_CODE_NOT_PRESENT):abs
;---------------------------------------;
        extrn   get_cmos_buffer_item:near
        extrn   get_setup_$_ptr:near
;---------------------------------------;

;---------------------------------------;
;       C O D E     S E G M E N T       ;
;---------------------------------------;
.386
cgroup  group   _text
_text segment word public USE16 'CODE'
         assume cs:CGROUP

;-----------------------------------------------------------------------;
LptAddrStruc    label   byte
        db      STR_IT8661F_AUTO, STR_DISABLED
        db      STR_IT8661F_378, STR_IT8661F_278, STR_IT8661F_3BC, STR_END

LptEPPAddrStruc label   byte
        db      STR_IT8661F_AUTO, STR_DISABLED
        db      STR_IT8661F_378, STR_IT8661F_278, STR_END

IT8661F_Lpt_Addr_Xfn    proc    near
        mov     bx, offset cgroup:LptAddrStruc
        mov     al, Q_IT8661F_LPT_MODE
        call    get_cmos_buffer_item    ;AL = 0/1/2/3 for SPP/EPP/ECP/EPP+ECP
        cmp     al, 1
        jne     common_normal_exit
        
        mov     bx, offset cgroup:LptEPPAddrStruc
        jmp     short common_normal_exit
IT8661F_Lpt_Addr_Xfn    endp


;-----------------------------------------------------------------------;
LptEppEcpModeStruc      label   byte
        db      STR_IT8661F_NORMAL, STR_IT8661F_EPP, STR_IT8661F_ECP, STR_IT8661F_EPPECP

LptEcpModeStruc label   byte
        db      STR_IT8661F_NORMAL, STR_RESERVED, STR_IT8661F_ECP, STR_END
                
IT8661F_Lpt_Mode_Xfn    proc    near
        mov     al, Q_IT8661F_LPT_PORT
        call    get_cmos_buffer_item    ;AL=0/1/2/3/4 for Auto/Disable/378/278/3BC
        dec     al
        jz      common_shaded_NA_exit   ;BR if disabled
        
        mov     bx, offset cgroup:LptEcpModeStruc
        cmp     al, 3                   ;Check for 3BC
        je      common_normal_exit
        
        mov     bx, offset cgroup:LptEppEcpModeStruc
        jmp     short common_normal_exit
IT8661F_Lpt_Mode_Xfn    endp


;-----------------------------------------------------------------------;
LptDmaStruc     label   byte
        db      STR_IT8661F_0, STR_IT8661F_1, STR_RESERVED, STR_IT8661F_3

IT8661F_Lpt_Dma_Xfn     proc    near
        mov     al, Q_IT8661F_LPT_PORT
        call    get_cmos_buffer_item    ;AL=0/1/2/3/4 for Auto/Disable/378/278/3BC
        mov     bl, al
        dec     al
        jz      common_shaded_NA_exit   ;BR if disabled
        
        mov     al, Q_IT8661F_LPT_MODE
        call    get_cmos_buffer_item    ;AL = 0/1/2/3 for SPP/EPP/ECP/EPP+ECP
        cmp     al, 2
        jb      common_shaded_NA_exit   ;BR if not in ECP mode
        
        dec     bl                      ;BL = -1/0/1/2/3 for
                                        ;     Auto/Disable/378/278/3BC
        jns     @F                      ;BR if not in Auto
        mov     bh, STR_IT8661F_AUTO
        jmp     short common_shaded_exit;BR if in Auto mode
@@:
        mov     bx, offset cgroup:LptDmaStruc
        jmp     short common_normal_exit
IT8661F_Lpt_Dma_Xfn     endp


;-----------------------------------------------------------------------;
LptIrqStruc     label   byte
        db      STR_IT8661F_5, STR_IT8661F_7

IT8661F_Lpt_Irq_Xfn     proc    near
        mov     al, Q_IT8661F_LPT_PORT
        call    get_cmos_buffer_item    ;AL=0/1/2/3/4 for Auto/Disable/378/278/3BC
        dec     al
        jz      common_shaded_NA_exit   ;BR if disabled
        jns     @F                      ;BR if not in Auto
        
        mov     bh, STR_IT8661F_AUTO
        jmp     short common_shaded_exit;BR if in Auto mode
@@:
        mov     bx, offset cgroup:LptIrqStruc
        jmp     short common_normal_exit
IT8661F_Lpt_Irq_Xfn     endp


;-----------------------------------------------------------------------;
common_normal_exit:
        mov     dx, cs                  ;DX:BX -> option Z-structure
        mov     ah, 2                   ;Show structure as normal
                                        ;Composite function
        retf

common_shaded_NA_exit:
        mov     bh, STR_IT8661F_NA
        
common_shaded_exit:
        mov     bl, 2                   ;BL = String Set#, BH = string#
        call    get_setup_$_ptr         ;Get string offset
        mov     bx, ax                  ;DX:BX -> ASCII Z-String for option
        mov     ah, 1                   ;Structure to be shown shadowed
        retf
        

;-----------------------------------------------------------------------;
IrIrqStruc      label   byte
        db      STR_RESERVED, STR_RESERVED, STR_RESERVED        ;IRQ 0,1,2
        db      STR_IT8661F_3, STR_IT8661F_4, STR_IT8661F_5
        db      STR_RESERVED, STR_RESERVED, STR_RESERVED        ;IRQ 6,7,8
        db      STR_IT8661F_9, STR_IT8661F_10, STR_IT8661F_11, STR_IT8661F_12
        db      STR_END ;IRQ 13,14,15

IT8661F_Ir_Irq_Xfn      proc    near
        mov     al, Q_IT8661F_IR_PORT
        call    get_cmos_buffer_item    ;AL = 0/1/2/3/4/5 for
                                        ;     Auto/Disable/3F8/2F8/3E8/2E8
        dec     al
        jz      common_shaded_NA_exit   ;BR if disabled
        jns     @F                      ;BR if not in Auto
        mov     bh, STR_IT8661F_AUTO
        jmp     short common_shaded_exit;BR if in Auto mode
@@:
        mov     bx, offset cgroup:IrIrqStruc
        jmp     short common_normal_exit
IT8661F_Ir_Irq_Xfn      endp


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
