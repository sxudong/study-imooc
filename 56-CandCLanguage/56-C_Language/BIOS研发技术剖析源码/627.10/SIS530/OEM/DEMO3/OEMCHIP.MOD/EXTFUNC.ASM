        page    ,132
        title   EXTERNAL FUNCTIONS IN SETUP
;---------------------------------------------------------------;
; NOTE: Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.
;---------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1996, American Megatrends Inc.        **;
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
;-----------------------------------------------------------------;
; History
;-----------------------------------------------------------------;
; Symbols:
;
; >>>   Modification START
; <<<   Modification END
; +     Code Added
; -     Code Removed
;
; (CORE0218) James Wed 03-03-1999
; Include external functions for setup to display event logs.
;-----------------------------------------------------------------;
; $Header: /BIOS/GENERIC/627/INTEL/440BX/Desktop PIIX4/SYS/EXTFUNC.ASM 5     9/05/97 5:23p Juand $
;
; $Revision: 5 $
;
; $Date: 9/05/97 5:23p $
;*****************************************************************;
;*****************************************************************;
; Revision History
; ----------------
; $Log: /BIOS/GENERIC/627/INTEL/440BX/Desktop PIIX4/SYS/EXTFUNC.ASM $
; 
; 5     9/05/97 5:23p Juand
; Implemented external functions for Standby and Suspend time out
; options.
;
; 3     9/04/97 10:47a Juand
; Changed N/A string and Hex strings for Desktop.
;
; 2     9/03/97 11:26a Juand
; Removed Runtime Functions and used External Functions instead.
;
; 1     8/18/97 4:58p Juand
;
; 6     8/13/97 2:59p Juand
;
; 5     8/06/97 12:26p Juand
;
; 4     8/01/97 11:10a Juand
;
; 3     7/29/97 7:04p Juand
; Added runtime functions for AGP related setup options
;
; 2     7/21/97 2:10p Juand
;
; 1     7/15/97 3:24p Juand
;
; 1     1/31/97 12:46p Debkumar
; New files for 62700.
;
; 2     1/13/97 2:28p Debkumar
; Modified for 6.27.00.
;
; 1     1/02/97 11:40a Debkumar
;
; 5     12/30/96 2:36p Debkumar
; Version 6.26.02
;
; 4     9/03/96 5:15p Mandal
; 6.26 for USA
;
; 1     6/17/96 2:34p Mandal
;
; 3     3/21/96 5:24p Mandal
; (c)1996 and phone no changed.
;
; 2     1/12/96 5:38p Dickh
; Added SourceSafe keywords to track revision history.
;
;*****************************************************************;
;---------------------------------------;
        include setupequ.ext
        include setupmsg.equ
        include makeflag.equ
;---------------------------------------;
;---------------------------------------;
;;Core BIOS Externs
        extrn   _temp_buffer:byte
        extrn   _common_cmos_buffer:byte
        extrn   _old_cmos_buffer:byte
        extrn   get_cmos_reg_mask_x:near
        extrn   get_cmos_buffer_item:near
        extrn   set_cmos_buffer_item:near
        extrn   Get_Language_No:near

        extrn   Get_$_Ptr:near
;---------------------------------------;
;;Chipset BIOS Externs
        extrn   get_vendor_name:near
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _EXTFUNC_STARTS
_EXTFUNC_STARTS label   byte            ; marks start of module
;-----------------------------------------------------------------------;

;; PaiLin debug {
comment !
;---------------------------------------------------------------------------;
;                PCI Grant Timer                                            ;
;---------------------------------------------------------------------------;
Grant_Timer_PCI1 proc near
Grant_Timer_PCI proc near
        push    ax

        mov     di,offset _temp_buffer
        push    di
        push    es
        push    ds
        pop     es
        mov     cx,0fh
        mov     al,STR_RESERVED         ; init 16bytes
        rep     stosb
        mov     al,STR_AUTO
        stosb
        pop     es
        pop     di

        mov     al,Q_PCI_GRANT_TIMER1
        call    get_cmos_buffer_item
        mov     dh, al
        mov     al,Q_PCI_GRANT_TIMER
        call    get_cmos_buffer_item
        mov     dl, al
        pop     ax
        cbw
        add     dx, ax

        mov     al,Q_PCI_GRANT_TIMER
        mov     ah, dl
        call    set_cmos_buffer_item
        mov     al,Q_PCI_GRANT_TIMER1
        mov     ah, dh
        call    set_cmos_buffer_item

        mov     cx, 0
        mov     si,(offset _temp_buffer) + 3
loop_again:
        push    cx
        mov     al, 4
        mul     cl
        mov     cl, al

        mov     ax, dx
        shr     ax, cl
        and     ax, 000fh
        or      al, 30h
        cmp     al, 39h
        jbe     @f
        add     al, 7
@@:
        mov     byte ptr ds:[si], al
        dec     si

        pop     cx
        inc     cx
        cmp     cx, 4
        jb      loop_again

        mov     bx,offset _temp_buffer
        mov     dx,ds
        mov     ah, 00h

        retf
Grant_Timer_PCI endp
Grant_Timer_PCI1        endp
;---------------------------------------------------------------------------;
;                CPU Idle Timer for PCI                                     ;
;---------------------------------------------------------------------------;
Idle_Timer_PCI  proc near
        push    ax

        mov     al,Q_IDLE_TIMER_PCI
        call    get_cmos_buffer_item
        mov     dl, al
        pop     ax
        add     dl, al
        mov     ah, dl
        mov     al,Q_IDLE_TIMER_PCI
        call    set_cmos_buffer_item


        xchg    al,ah
;       aam
;       or      ax,3030h
;       cmp     al,39h
;       jbe     @f
;       add     al,07h
;@@:
;       cmp     ah,39h
;       jbe     @f
;       add     al,07h
;@@:
;       xchg    al,ah
;       mov     bx,offset _temp_buffer
;       mov     ds:[bx],ax
;       xor     al,01
;       mov     ah,00h
;       mov     dx,ds

        mov     dx, ax
        mov     cx, 0
        mov     si,(offset _temp_buffer) + 1
loop_again:
        push    cx
        mov     al, 4
        mul     cl
        mov     cl, al

        mov     ax, dx
        shr     ax, cl
        and     ax, 000fh
        or      al, 30h
        cmp     al, 39h
        jbe     @f
        add     al, 7
@@:
        mov     byte ptr ds:[si], al
        dec     si

        pop     cx
        inc     cx
        cmp     cx, 2
        jb      loop_again

        mov     word ptr ds:[si+3], 0
        mov     bx,offset _temp_buffer
        mov     dx,ds
        mov     ah, 00h

        retf
Idle_Timer_PCI  endp
;---------------------------------------;
end-comment !
;; } PaiLin debug
;---------------------------------------------------------------------------;
;                Share memory size                                          ;
;---------------------------------------------------------------------------;
SHARE_MEMORY_zlist label        byte
db      STR_RESERVED,STR_2MB,STR_4MB,STR_8MB,STR_END
NA_zlist label  byte
db     STR_IT8661F_NA,STR_IT8661F_NA,STR_IT8661F_NA,STR_IT8661F_NA
;db      STR_WIN877_NA,STR_WIN877_NA,STR_WIN877_NA,STR_WIN877_NA

Share_memory    proc near
        mov     ax,cs
        cmp     ax,0f000h
        mov     ah,2
        mov     bx,offset cgroup:SHARE_MEMORY_zlist
        jnz     short setting_done
        mov     al,Q_SHARE_MEMORY
        call    get_cmos_buffer_item
        jnz     setting_done
        mov     ah,3
        mov     bx,offset cgroup:NA_zlist
setting_done:
        mov     dx,cs
        retf
Share_memory    endp
if (MKF_CUSTOMER eq 7788)
;;---------------------------------------------------------------------------;
;;                Share memory size                                         ;
;;---------------------------------------------------------------------------;
DISABLE_ENABLE_zlist label      byte
db      STR_DISABLE,STR_ENABLE
VGA_WRITE_CYCLE proc near
        mov     al,Q_SHARE_MEMORY
        call    get_cmos_buffer_item
        mov     ah,2                    ;default is Normal
        jnz     short @f

        mov     ax,Q_VGA_READ_CYCLE
        call    set_cmos_buffer_item

        mov     ax,Q_VGA_WRITE_CYCLE
        call    set_cmos_buffer_item

        mov     ah,3
@@:
        mov     bx,offset cgroup:DISABLE_ENABLE_zlist
        mov     dx,cs
        retf
VGA_WRITE_CYCLE endp
endif
COMMENT ~
;---------------------------------------------------------------------------;
;                Single_read                                                ;
;---------------------------------------------------------------------------;
SINGLE_READ_zlist label byte
db      STR_DISABLED,STR_ENABLED,str_end

Single_read     proc near
        call    get_vendor_name
        cmp     bl,01
        mov     ah,2                    ;default is Normal
        jne     @f
        mov     al,Q_SINGLE_READ
        xor     ah,ah
        call    set_cmos_buffer_item
        mov     ah,3
@@:
        mov     bx,offset cgroup:SINGLE_READ_zlist
        mov     dx,cs
        retf
Single_read     endp
~

everyday db     "Every Day",0
;-----------------------------------------------------------------------;
rtc_resmue_date_ef      proc near
        mov     ah,Q_RESUME_BY_RTC_DATE
        mov     bx,1f00h                ; BH=High Limit/BL=Low limit
        call    show_decimal
        retf
rtc_resmue_date_ef      endp
rtc_resmue_hour_ef      proc near
        mov     ah,Q_RESUME_BY_RTC_HOUR
        mov     bx,1700h                ; BH=High Limit/BL=Low limit
        call    show_decimal
        retf
rtc_resmue_hour_ef      endp
rtc_resmue_minute_ef    proc near
        mov     ah,Q_RESUME_BY_RTC_MINUTE
        mov     bx,3B00h                ; BH=High Limit/BL=Low limit
        call    show_decimal
        retf
rtc_resmue_minute_ef    endp
rtc_resmue_second_ef    proc near
        mov     ah,Q_RESUME_BY_RTC_SECOND
        mov     bx,3B00h                ; BH=High Limit/BL=Low limit
        call    show_decimal
        retf
rtc_resmue_second_ef    endp
        public  show_decimal
show_decimal    proc    near
        push    es
        push    ds
        pop     es

        call    clear_temp_buffer

        xchg    al,ah                   ; AH=+/-1 AL=Question
        push    ax
        call    get_cmos_buffer_item
        pop     dx
        add     al,dh

        cmp     al,bl
        jae     @f
        mov     al,bh
@@:     cmp     al,bh
        jbe     @f
        mov     al,bl
        or      dh,dh
        jns     @f
        mov     al,bh
@@:
        mov     dh,al

        mov     ax,dx
        call    set_cmos_buffer_item
        mov     bx,offset _temp_buffer
        cmp     ax,Q_RESUME_BY_RTC_DATE
        jnz     everyday_done
        mov     si,offset cgroup:everyday
        mov     cx,5
        mov     di,bx
        db      02eh
        rep     movsw
        jmp     short skip_number

everyday_done:
        xchg    al,ah
        aam
        or      ax,3030h
        xchg    al,ah
        mov     ds:[bx],ax
skip_number:
        mov     al,Q_RESUME_BY_RTC
        call    get_cmos_buffer_item
        xor     al,01
        mov     ah,al
        mov     dx,ds
        pop     es
        ret
show_decimal    endp

clear_temp_buffer       proc    near
        push    ax
        mov     cx,05
        xor     ax,ax
        mov     di,offset _temp_buffer
        rep     stosw
        pop     ax
        ret
clear_temp_buffer       endp

conv_ax  proc    near
        mov     cx,10
lop5:   xor     dx,dx
        div     cx
        or      ax,ax
        jz      lab5
        push    dx
        call    lop5
        pop     dx
lab5:   mov     al,dl
        add     al,30h
        stosb
        ret
conv_ax  endp

sys_temp_proc   proc    far
        push    es
        push    ds
        pop     es
        call    clear_temp_buffer
        mov     ax,27h
        call    read_lm78_reg
        jnz     lm78_absent
        mov     di,offset _temp_buffer
        mov     bx,di
; Jeff, Wed 09-30-1998 >>>
        test    al,80h          ;temp(C)=(reading*140+8792)/168.7
        pushf
        jz      positive_value1
        neg     al
positive_value1:
        mov     ah,140
        mul     ah
        mov     cx,8792
        popf
        jz      positive_value2
        sub     cx,ax
        mov     ax,cx
        jmp     process_div
positive_value2:
        add     ax,cx
process_div:
        mov     cx,10
        mul     cx
        mov     cx,1687
        div     cx
; Jeff, Wed 09-30-1998 <<<
        push    ax
        call    conv_ax
        mov     eax,2f43f8h
        stosd
        dec     di
        pop     ax
        mov     ah,9
        mul     ah
        xor     dx,dx
        mov     cx,5
        div     cx
        add     ax,32
        call    conv_ax
        mov     ax,046f8h
        stosw
lm78_absent:
        mov     ah,1
        mov     dx,ds
        pop     es
        retf
sys_temp_proc   endp

cpu_fan_proc    proc    far
        mov     ax,0828h
        call    common_fan
        retf
cpu_fan_proc    endp

sys_fan_proc    proc    far
        mov     ax,0429h
        call    common_fan
        retf
sys_fan_proc    endp

common_fan      proc    near
        push    es
        push    ds
        pop     es
        call    clear_temp_buffer
        call    read_lm78_reg
        jnz     fan_lm78_absent
        mov     bx,ax
        cmp     al, 0feh                               ; Check if FAN take out!
        mov     ax,0
        jae     short no_cpu_fan
        mov     ax,bx
        mul     ah
        mov     bx,ax
        cmp     bx,15h
        jb      short no_cpu_fan
        mov     dx,14h
        mov     ax,05265h
        div     bx
no_cpu_fan:
        mov     di,offset _temp_buffer
        mov     bx,di
        call    conv_ax
        mov     eax,'MPR '
        stosd
fan_lm78_absent:
        mov     ah,1
        mov     dx,ds
        pop     es
        ret
common_fan      endp

in0_proc        proc    far
        mov     al,020h
        mov     bx,595
        call    common_in
        retf
in0_proc        endp

in1_proc        proc    far
        mov     al,021h
        mov     bx,1000
        call    common_in
        retf
in1_proc        endp

in2_proc        proc    far
        mov     al,022h
        mov     bx,1000
        call    common_in
        retf
in2_proc        endp

in3_proc        proc    far
        mov     al,023h
        mov     bx,1000
        call    common_in
        retf
in3_proc        endp

common_in       proc    near
        push    es
        push    ds
        pop     es
        call    clear_temp_buffer
        mov     ah,al
        push    bx
        call    read_lm78_reg
        pop     bx
        jnz     in_lm78_absent
        mov     di,offset _temp_buffer
        cmp     ah,25h
        jb      @f
        push    ax
        mov     al,'-'
        stosb
        pop     ax
@@:
        mov     ah,10h
        mul     ah
        xor     dx,dx
        div     bx
        push    dx
        call    conv_ax
        mov     al,'.'
        stosb
        pop     ax
        xor     dx,dx
        mov     si,1000
        mul     si
        div     bx
        mov     dx,ax
        cmp     ax,100
        ja      @f
        mov     al,'0'
        stosb
        cmp     dx,10
        ja      @f
        stosb
@@:
        mov     ax,dx
        call    conv_ax
        mov     ax,'V '
        stosw
in_lm78_absent:
        mov     bx,offset _temp_buffer
        mov     ah,1
        mov     dx,ds
        pop     es
        ret
common_in       endp

read_lm78_reg   proc    near
        push    dx
        mov     dx,cs
        cmp     dx,0f000h
        jnz     not_in_bios
        mov     dx,295h
        out     dx,al
        mov     ch,80h
        loop    $
        inc     dx
        in      al,dx
        mov     ch,80h
        loop    $
        cmp     al,al
not_in_bios:
        mov     bx,offset _temp_buffer
        pop     dx
        ret
read_lm78_reg   endp

;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1996, American Megatrends Inc.        **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**             6145-F, Northbelt Parkway, Norcross,            **;
;**                                                             **;
;**             Georgia - 30071, USA. Phone-(770)-246-8600.     **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;
if (MKF_EVENT_LOG)                      ; (CORE0218+)>
        include eventfun.inc
endif                                   ; <(CORE0218+)

        public  _EXTFUNC_ENDS
_EXTFUNC_ENDS   label   byte                    ; marks end of module
;---------------------------------------;
_text   ends
        end
