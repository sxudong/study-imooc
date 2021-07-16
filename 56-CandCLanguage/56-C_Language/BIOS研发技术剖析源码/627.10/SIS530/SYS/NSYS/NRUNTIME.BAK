        page    ,132
        title   RUNTIME HOOKS (NO PORTING NEEDED IN GENERAL)
;---------------------------------------------------------------;
; NOTE: Do not destroy EBP,SS,DS,ES,FS,GS unless otherwise specified.
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
;---------------------------------------;
        extrn   ide_prim_base_addr:word
        extrn   ide_sec_base_addr:word
        extrn   ide_prim_irq    :byte
        extrn   ide_sec_irq     :byte
        extrn   misc_info       :byte
;---------------------------------------;
        extrn   check_cmos_data:near
        extrn   proc_shutdown:near
        extrn   cmos_data_in_x:near
        extrn   cmos_data_out_x:near
        extrn   cmos_data_in:near
        extrn   cmos_data_out:near

        extrn   enable_l1_cache_wt:near
        extrn   enable_l1_cache_wb:near
        extrn   disable_l1_cache:near
        extrn   enable_l2_cache_wt:near
        extrn   enable_l2_cache_wb:near
        extrn   disable_l2_cache:near
        extrn   low_speed:near
        extrn   high_speed:near
;---------------------------------------;
        include mbiosmac.mac
        include mbiosequ.equ
        include cf.equ
        include silent.equ
        include makeflag.equ
        include setupequ.ext
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _NRUNTIMEX_STARTS
_NRUNTIMEX_STARTS       label   byte            ; marks start of module
;-----------------------------------------------------------------------;
;                       SET_SCRATCH_SEGMENT_SETUP                       ;
;-----------------------------------------------------------------------;
;  this routine is called from hot key setup. this routine returns the  ;
;  segment value (of length at least 32k) which can be used as scratch  ;
;  ram during setup.                                                    ;
;  input :                                                              ;
;       ds      0040h                                                   ;
;       stack   available                                               ;
;  output:                                                              ;
;       nc      scratch segment found                                   ;
;               ax  scratch segment                                     ;
;       cy      scratch segment not found                               ;
;  register usage..do not destroy any register except AX                ;
;                                                                       ;
;  SUGGESTED USE:                                                       ;
;  * this routine is supposed to look for any ram which can be used as  ;
;  scratch ram. use of shadow ram is suggested. if shadow is currently  ;
;  enabled then first disable the shadow and then make that segment R/W ;
;  and return the value of segment. the segment will be restored in     ;
;  RESTORE_SCRATCH_SEGMENT_SETUP routine.                               ;
;-----------------------------------------------------------------------;
        public  set_scratch_segment_setup
set_scratch_segment_setup       proc    near
        stc
        ret
set_scratch_segment_setup       endp
;-----------------------------------------------------------------------;
;                       RESTORE_SCRATCH_SEGMENT_SETUP                   ;
;-----------------------------------------------------------------------;
;  this routine is called from hot key setup. this routine restores the ;
;  segment value which is used as scratch ram during setup.             ;
;  input :                                                              ;
;       ax      scratch segment to be restored                          ;
;       stack   available                                               ;
;  output:                                                              ;
;       nc      scratch segment restored                                ;
;       cy      scratch segment not restored                            ;
;  register usage..do not destroy any register except AX                ;
;                                                                       ;
;  SUGGESTED USE:                                                       ;
;  * this routine is supposed to restore the contents of segment which  ;
;  was returned as scratch ram by SET_SCRATCH_SEGMENT_SETUP. if shadow  ;
;  was originally enabled then enable the shadow properly before return.;
;  make sure the shadow ram is write-protected before return.           ;
;-----------------------------------------------------------------------;
        public  restore_scratch_segment_setup
restore_scratch_segment_setup   proc    near
        stc
        ret
restore_scratch_segment_setup   endp
;-----------------------------------------------------------------------;
;                       FORCE_NO_OF_SECTORS                             ;
;-----------------------------------------------------------------------;
; check point           : 91                                            ;
; this routine is called from hard_disk_setup during POST. this routine ;
; will force the number of sectors which can be xferred at a time to a  ;
; working value. this routines is needed because some hard disk does not;
; work with the value it returned from identify drive command.          ;
; input :                                                               ;
;       AL      #of sectors that can be xferred at a time as obtained   ;
;               from identify drive command                             ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       AL      #of sectors that can be xferred at a time               ;
; register usage : can not destroy any register except AL               ;
;-----------------------------------------------------------------------;
        public  force_no_of_sectors
force_no_of_sectors     proc    near
;  if it is > 8, force it to 8..
;;      cmp     al,08h
;;      jbe     setm_04
;;      mov     al,08h
;;setm_04:
        ret
force_no_of_sectors     endp
;-----------------------------------------------------------------------;
;                       PROGRAM_HD_STANDBY                              ;
;-----------------------------------------------------------------------;
; Check point   : 91                                                    ;
; this routine is called from hard_disk_setup during POST. this programs;
; hard disk standby timer value.                                        ;
; input :                                                               ;
;       AL      timer value in unit of 5 sec                            ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       none                                                            ;
; register usage : can destroy any register except EBP, DS, ES          ;
; NOTE :                                                                ;
; The ATA Spec defines the following power down commands that may be    ;
; issued to the hard disk to set its power consumption mode:            ;
;       SET 1   SET 2                                                   ;
;       -----   -----                                                   ;
;        98h     e5h    Check Power Mode - If drive is in, going to, or ;
;                       recovering from standby mode, Sector Count Reg. ;
;                       is returned with 00h.  If drive is in idle mode,;
;                       return ffh in the Sector Count Reg.             ;
;        97h     e3h    Idle - Place drive in idle mode. If Sector Count;
;                       Reg is nonzero, start automatic power down      ;
;                       timer, if applicable.                           ;
;        95h     e1h    Idle Immediate - Drive immediately enters the   ;
;                       idle power state.                               ;
;        96h     e2h    Standby - Place drive in standby mode.  If Sec- ;
;                       tor Reg is nonzero, start automatic power down  ;
;                       timer, if applicable.                           ;
;        94h     e0h    Standby Immediate - Drive immediately enters the;
;                       standby power state.                            ;
;        99h     e6h    Set Sleep Mode - Place drive in sleep mode.     ;
;-----------------------------------------------------------------------;
        public  program_hd_standby
        extrn   set_standby_multiple:near
program_hd_standby      proc    near
        mov     ah,0e3h                 ; idle w/timer command (set 2)
        pusha                           ; Don't know what set_standby_multiple
                                        ; destroys, so saving all regs.
        call    set_standby_multiple
        popa                            ; Restore all regs.
        jnc     short hd_standby_programmend
        mov     ah,097h                 ; idle w/timer command (set 1)
        call    set_standby_multiple
hd_standby_programmend:
        ret
program_hd_standby      endp
;-----------------------------------------------------------------------;
;                       IDE_PRIM_IRQ_EXTRA                              ;
;-----------------------------------------------------------------------;
; This routine is called from hardware interrupt ISR for primary hard   ;
; disk controller. This routine can implement anything extra to be done ;
; in IRQ ISR. For example, for PCI BIOS the routine may have to read the;
; hard disk status register to clear the interrupt.                     ;
; input :                                                               ;
;       DS                      0040H                                   ;
;       CS:IDE_PRIM_BASE_ADDR   I/O base addr of primary controller     ;
; output:                                                               ;
;       none                                                            ;
; register usage : do not destory any register except AX                ;
;-----------------------------------------------------------------------;
        public  ide_prim_irq_extra
ide_prim_irq_extra      proc    near
        push    dx
        mov     dx,cgroup:ide_prim_base_addr; get I/O base address
        add     dx,07h                  ; status register
        in      al,dx
        pop     dx
        ret
ide_prim_irq_extra      endp
;-----------------------------------------------------------------------;
;                       IDE_SEC_IRQ_EXTRA                               ;
;-----------------------------------------------------------------------;
; This routine is called from hardware interrupt ISR for secondary hard ;
; disk controller. This routine can implement anything extra to be done ;
; in IRQ ISR. For example, for PCI BIOS the routine may have to read the;
; hard disk status register to clear the interrupt.                     ;
; input :                                                               ;
;       DS                      0040H                                   ;
;       CS:IDE_SEC_BASE_ADDR    I/O base addr of secondary controller   ;
; output:                                                               ;
;       none                                                            ;
; register usage : do not destory any register except AX                ;
;-----------------------------------------------------------------------;
        public  ide_sec_irq_extra
ide_sec_irq_extra       proc    near
        push    dx
        mov     dx,cgroup:ide_sec_base_addr; get I/O base address
        add     dx,07h                  ; status register
        in      al,dx
        pop     dx
        ret
ide_sec_irq_extra       endp
;-----------------------------------------------------------------------;
;                               V_TIMER_TICK                            ;
;                               TIMER_TICK                              ;
;-----------------------------------------------------------------------;
; This routine is hardware INT-8 during diagnostics mode. CPU can be in ;
; real or virtual mode, (DS = 40) always. This routine will get control ;
; if diagnostics switch is on and you may do any LED blinking or other  ;
; way of reporting that system is alive.                                ;
; input :                                                               ;
;       DS      0040H                                                   ;
; register usage : save all registers and flag                          ;
; use IRET to return to caller (remember this is INT-8 ISR)             ;
;-----------------------------------------------------------------------;
        public  v_timer_tick            ; INT-8 in virtual mode, diag sw on
        public  timer_tick              ; INT-8 in real mode, diag switch on
v_timer_tick:
        push    ax
        mov     al,ds:[12h]             ; 8042 input port byte
        test    al,00100000b            ; diag switch on ? pin-32 of 8042
        pop     ax
        jz      timer_tick              ; yes
        jmp     proc_shutdown           ; shutdown proc
timer_tick:
;------ DO any special LED blinking ----;
        push    ax
        mov     al,20h                  ; end of interrupt
        out     20h,al
        pop     ax
        iret
;-----------------------------------------------------------------------;
;               TIMER_INTERRUPT_INT8            ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;                       KB_INTERRUPT_INT9                               ;
;-----------------------------------------------------------------------;
; This routine will get control in every keyboard interrupt, any special;
; action can be done here. this is called from INT-9 ISR                ;
; input :                                                               ;
;       DS      40H                                                     ;
;       other registers already saved using PUSHA, ES is not saved.     ;
; register usage : can destroy any register except DS, ES               ;
;-----------------------------------------------------------------------;
        public  kb_interrupt_int9
        extrn   kb_interrupt_int9_end:near
kb_interrupt_int9:
        jmp     kb_interrupt_int9_end
;-----------------------------------------------------------------------;
;                       POWER_ON_INIT           ; Moved to RUNTIME.ASM
;-----------------------------------------------------------------------;
;                               HRESET_CLEAR                            ;
;-----------------------------------------------------------------------;
; If any initialization (e.g. detection CPU ID, etc.) is required in    ;
; power on/hard reset path.                                             ;
; input :                                                               ;
;       SS = CS                                                         ;
;       DX      CPU ID information                                      ;
;       all other registers are undefined including DS,ES,SP,EBP        ;
;       stack   not available                                           ;
; register usage : can destroy any register execept SS                  ;
;-----------------------------------------------------------------------;
        public  hreset_clear
        extrn   hreset_clear_end:near
hreset_clear:
        jmp     hreset_clear_end
;-----------------------------------------------------------------------;
;                               SRESET_CLEAR                            ;
;-----------------------------------------------------------------------;
; If any initialization is required in <ctrl><alt><del> soft reset or   ;
; shutdown path.                                                        ;
; input :                                                               ;
;       SS = CS                                                         ;
;       all other registers are undefined including DS,ES,SP,EBP        ;
;       stack   not available                                           ;
; register usage : can destroy any register execept SS                  ;
;-----------------------------------------------------------------------;
        public  sreset_clear            ; soft reset init, if any
        extrn   sreset_clear_end:near
sreset_clear:
        smsw    ax
        test    al,01h                  ; virtual mode ?
        jz      sreset_clear_00         ; no..skip generating CPU reset
        mov     ax,008fh                ; cmos reg 0Fh, shutdown code 00
        ret_sp  cmos_data_out_x
        ret_sp  enable_8042_bit_20      ; enable GateA20
        jmp     shutdown_cpu
sreset_clear_00:
        jmp     sreset_clear_end
;-----------------------------------------------------------------------;
;                               SHUTDOWN_7                              ;
;-----------------------------------------------------------------------;
; This routine is used to come back to real mode from virtual mode.     ;
; This shutdown code is not used by BIOS and can be used by porting if  ;
; necessary.                                                            ;
; input :                                                               ;
;       DS      0040h                                                   ;
;       ES      0000h                                                   ;
;       all registers are undefined                                     ;
;       stack   available                                               ;
;-----------------------------------------------------------------------;
        public  shutdown_7              ; can be used during memory config
        extrn   shutdown_77:near
shutdown_7:
        jmp     shutdown_77             ; USED IN MEMORY DETECTION
;-----------------------------------------------------------------------;
;                               SHUTDOWN_8                              ;
;-----------------------------------------------------------------------;
; This routine is used to come back to real mode from virtual mode.     ;
; This shutdown code is not used by BIOS and can be used by porting if  ;
; necessary.                                                            ;
; input :                                                               ;
;       DS      0040h                                                   ;
;       ES      0000h                                                   ;
;       all registers are undefined                                     ;
;       stack   available                                               ;
;-----------------------------------------------------------------------;
        public  shutdown_8              ; can be used during memory config
        extrn   shutdown_88:near
shutdown_8:                             ; user defined
        jmp     shutdown_88
;-----------------------------------------------------------------------;
;                               SHUTDOWN_INIT                           ;
;-----------------------------------------------------------------------;
; This routine is required if some special work involved during shutdown;
; processing before passing control to proper shutdown routine,         ;
; example:- CR0, 287/387 bit set/reset, 287/387 emulation bit.          ;
; input :                                                               ;
;       SS = CS                                                         ;
;       SI = shutdown code, (00..0A)                                    ;
;       stack   not available                                           ;
; output:                                                               ;
;       none                                                            ;
; register usage : can destroy any register except SI                   ;
;-----------------------------------------------------------------------;
        public  shutdown_init           ; any init during shutdown
        extrn   shutdown_init_end:near
        extrn   go_to_flat_mode_stack:near
        extrn   comeback_from_flat_mode_stack:near
        extrn   InitLocalApic:near
shutdown_init:
        mov     ax,si
        cmp     al,5
        jz      si_02                   ; for shutdown 5,9,A
        cmp     al,9
        jz      si_02
        cmp     al,0ah
        jnz     si_00
si_02:
        mov     ax,30h
        mov     ss,ax                   ; set SS and SP
        mov     sp,100h
if (MKF_NCPU eq 2)
        push    si
        call    go_to_flat_mode_stack
        call    InitLocalApic
        call    comeback_from_flat_mode_stack
        pop     si
endif
        call    enable_l1_cache         ; enable internal cache
si_00:
        jmp     shutdown_init_end
;-----------------------------------------------------------------------;
;                               SHUTDOWN_CPU                            ;
;-----------------------------------------------------------------------;
; this is called from INT-15 ISR                                        ;
; this routine gets control if CPU type is 80286 which needs reset to go;
; to real mode. if you have fast CPU reset option through chipset reg.  ;
; or any other mechanism, use that option else use standard shutdown    ;
; (8042 command FE)                                                     ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  register usage : can destroy any register                            ;
;-----------------------------------------------------------------------;
        public  shutdown_cpu            ; shutdown processor
        public  shutdown_8042
shutdown_cpu:
        cli
;-- here write the code for fast reset--;
shutdown_8042:
        cli
;  control may come here from SRESET_CLEAR where SS/SP is not set..
;  so on-line coding is used..
        mov     al,0feh                 ; shutdown command to 8042
        out     64h,al                  ; issue command
        hlt                             ; goto system halt
        jmp     short $-1               ; ensure halt
;-----------------------------------------------------------------------;
;                               ENABLE_ADDR_BIT_20                      ;
;-----------------------------------------------------------------------;
;  this is called from INT-15 ISR.                                      ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register except AX, CX            ;
;-----------------------------------------------------------------------;
        public  enable_addr_bit_20      ; fast GA20 enable
        extrn   enable_8042_bit_20:near
        extrn   enable_fast_ga20:near
enable_addr_bit_20:
        mov     ax,offset cgroup:enable_fast_ga20
        mov     cx,offset cgroup:enable_8042_bit_20
eab20_00:
        test    cgroup:misc_info,fast_gate_a20_bit
        jz      eab20_01                ; fast GA20 not allowed
        push    cx
        call    ax                      ; use Fast Gate20 method
        pop     cx
        jz      eab20_02                ; done
eab20_01:
        call    cx                      ; use 8042 method
eab20_02:
        ret                             ; NZ/ZR = 0/1, error/no error
;-----------------------------------------------------------------------;
;                               DISABLE_ADDR_BIT_20                     ;
;-----------------------------------------------------------------------;
;  this is called from INT-15 ISR.                                      ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register except AX, CX            ;
;-----------------------------------------------------------------------;
        public  disable_addr_bit_20     ; fast GA20 disable
        extrn   disable_8042_bit_20:near
        extrn   disable_fast_ga20:near
disable_addr_bit_20:
        mov     ax,offset cgroup:disable_fast_ga20
        mov     cx,offset cgroup:disable_8042_bit_20
        jmp     short eab20_00
;-----------------------------------------------------------------------;
;                               INT-15.ASM MODULE                       ;
; this routine is called from INT-15 ISR to support any special int-15  ;
; function if any. if you do not have any special func, simply return   ;
; control to INT-15 ISR by RET. otherwise balance stack and return      ;
; control to caller of INT-15 by IRET or RET 2.                         ;
; here is how INT-15 code will look like.                               ;
;int_15 proc    far                                                     ;
;       cmp     ah,87h                                                  ;
;       jz      int_15_87                                               ;
;       call    special_int_15                                          ;
;       ...                                                             ;
;int_15_87:                                                             ;
;       ...                                                             ;
;int_15 endp                                                            ;
;=======================================================================;
; EXAMPLE:  INT15 function to GATE-A20 support.                         ;
;           input :     (ah)    24h                                     ;
;                       (al)    03h                                     ;
;           output:     (ah)    return code                             ;
;                               00h  successful                         ;
;                               86h  function not supported             ;
;                       (NC)    successful                              ;
;                       (CY)    unsuccessful                            ;
;                       if successful                                   ;
;                       (bx)    bit 0..0 = GateA20 not supported on 8042;
;                                      1 = GateA20 supported on 8042    ;
;                               bit 1..0 = GateA20 not supported with   ;
;                                          bit-1 of I/O port 92H        ;
;                                      1 = GateA20 supported with bit-1 ;
;                                          of I/O port 92H              ;
; Let us assume the chipset concerned has the support for GateA20 thru' ;
; bit-1 of I/O port 92H. In this case SPECIAL_INT_15 shoule be like as  ;
; follows:                                                              ;
;                                                                       ;
; special_int_15:                                                       ;
;       cmp     ah,24h                  ; func# 24h ?                   ;
;       jnz     si15_00                 ; no..                          ;
;       cmp     al,03h                  ; subfunc# 03h ?                ;
;       jnz     si15_00                 ; no..                          ;
;       POP     BX                      ; ===VERY VERY IMPORTANT===     ;
;                                       ; discard return address        ;
;       mov     bx,02h                  ; bit 1 = 1..GateA20 thru' bit-1;
;                                       ; of I/O port 92H               ;
;       sti                             ; enable interrupt              ;
;       xor     ah,ah                   ; AH = 00..successful           ;
;                                       ; NC..successful                ;
; x??   proc    far                                                     ;
;       ret     0002                                                    ;
; x??   endp                                                            ;
;                                                                       ;
; si15_00:                                                              ;
;       ret                                                             ;
;-----------------------------------------------------------------------;
;                               SPECIAL_INT_15                          ;
;-----------------------------------------------------------------------;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  register usage : do not destroy any register                         ;
;-----------------------------------------------------------------------;
        public  dummy_ret
        extrn   bios_scratch:byte
        extrn   oem_special_int_15:near
        extern  check_bu(dummy_ret):near
        extern  VumaInt15EntryPoint(dummy_ret):near
        extrn   apm_real_mode_entry:near
        public  special_int_15          ; special int 15 func if any
special_int_15:
;---------------------------------------;
if      MKF_ACPI_SUPPORT
        cmp     ah,88h                  ; fn# 88h ?
        jz      func_88
        cmp     ax,0e801h               ; fn# E801h ?
        jnz     short osi15_00          ; no
func_88:
        test    cgroup:bios_scratch,acpi_aware_os_bit; Bit-5 = 1 -> ACPI OS
        jz      short osi15_00          ; not ACPI OS

        extrn   acpi_int15_fn88:near
        extrn   acpi_int15_fne801:near

        cmp     ax,0e801h
        jnz     acpi_int15_fn88         ; ACPI INT15 Fn 88h in RUNACPI.ASM
        jmp     acpi_int15_fne801       ; ACPI INT15 Fn E801h in RUNACPI.ASM

osi15_00:
endif
;---------------------------------------;
        call    oem_special_int_15      ; OEM specific INT15 function
        cmp     ah,053h                 ; APM function ?
        jne     si15_00                 ; no
        jmp     apm_real_mode_entry     ; execute APM function
si15_00:
        cmp     ax,0F401h               ; VUMA function ?
        jne     si15_01                 ; no
        jmp     VumaInt15EntryPoint     ; execute VUMA function
si15_01:
        jmp     check_bu                ; check for BIOS upgrade func
;-----------------------------------------------------------------------;
;                               FD_SPEED_LOW                            ;
;-----------------------------------------------------------------------;
; this routine is called to support low speed floppy verify if reqd.    ;
; input :                                                               ;
;       ds      0040h                                                   ;
;       stack   available                                               ;
; output :                                                              ;
;       (ZF)    0, if you do not need low speed during verify           ;
;               else set to low speed and CALL COMOUT, then make (ZF) = 1
;                                                                       ;
; ==============================NOTE====================================;
; MAKE SURE ONLY (zf) IS CHANGED IN OUTPUT. THE carry FLAG CAN NOT BE   ;
; CHANGED.                                                              ;
; YOU ARE ADVISED TO USE THE FOLLOWING CODE ALWAYS.                     ;
; ==============================NOTE====================================;
;                                                                       ;
; register usage : do not destroy any register                          ;
;-----------------------------------------------------------------------;
        public  dummy_ret
        public  fd_speed_low            ; low speed floppy format, if reqd.
fd_speed_low:
;  for no speed change..
        or      sp,sp                   ; ZF = 0
dummy_ret:
        ret

;; need to go to low speed..
;;      00. save necessary registers to be used in steps 01, 02.
;;      01. save current speed status.
;;      02. goto low speed.
;;      03. restore registers which are saved in step 00.

;;      04. execute COMOUT rotuine. COMOUT routine has output in carry flag.
;;          DO NOT dsetroy carry flag after this.
;;              extrn   comout: near
;;              call    comout          ; send command /parameters to FP controller

;;      05. save necessary registers registers (including flag) to be used
;;          in steps 06.
;;      06. restore current speed status.
;;      07. restore registers including flags which are saved in step 05.

;;      08. exit with (ZF) set to 1. DO NOT CHANGE ANY OTHER FLAG.
;;              PUSH    AX
;;              MOV     AL,0FFH
;;              INC     AL              ; (ZF) = 1
;;                                      ; NOTE THAT inc al AFFECTS zf ONLY
;;              POP     AX
;;              RET
;-----------------------------------------------------------------------;
;               NMI_PARITY_CHECK                ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;               DISPLAY_PARITY_ADDRESS          ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;       PREPARE_CHIPSET_FOR_FLASH_PROGRAMMING   ; Moved to RUNTIME.ASM
;-----------------------------------------------------------------------;
;                               PRP_DELAY                               ;
;-----------------------------------------------------------------------;
; this routine is called to provide sufficient io recovery time between ;
; consecutive io operation in serial/printer port.                      ;
; NOTE: this routine is called from INT-14 and INT-17 ISR by a CALL     ;
; instruction and must return by RET. This CALL and RET instruction     ;
; themselves consume 8 clocks approx (actual clocks depends on CPU type).
; if 8 clocks is enough, NO extra delay is needed.                      ;
; input :                                                               ;
;       stack   available                                               ;
; output :                                                              ;
;       none                                                            ;
; register usage : do not destroy any register                          ;
; NOTE: in normal cases, no extra delay is required.                    ;
;-----------------------------------------------------------------------;
        public  prp_delay
prp_delay       proc    near
        jcxz    short $+2
        jcxz    short $+2
        jcxz    short $+2
        jcxz    short $+2
        jcxz    short $+2
        jcxz    short $+2
        ret
prp_delay       endp
;-----------------------------------------------------------------------;
;                               WEITEK_CHECK                            ;
;-----------------------------------------------------------------------;
; called from INT-11 ISR. set bit-24 of EAX if weitek is present i.e.   ;
; EAX = 0100 0000                                                       ;
; input :                                                               ;
;       none                                                            ;
;       stack   available                                               ;
; register usage : do not destroy any register except EAX               ;
;-----------------------------------------------------------------------;
        public  weitek_check            ; weitek check if any.
weitek_check:
        xor     eax,eax                 ; weitek not present
        ret

;; if weitek is present remove two line of code above and add the following
;; code.
;;      mov     eax,01000000h           ; bit-24 = 0/1  weitek absent/present
;;      ret
;-----------------------------------------------------------------------;
;                               SPECIAL_INT_1A                          ;
;-----------------------------------------------------------------------;
; this routine is called from INT-1A ISR to support any special int-1A  ;
; function if any. if you do not have any special func, simply return   ;
; control to INT-1A ISR. otherwise do the special function and return   ;
; control to caller of INT-1A by IRET or RET 2.                         ;
; here is how INT-16 code will look like.                               ;
;int_1a proc    far                                                     ;
;       ...                                                             ;
;       jmp     special_int_1a                                          ;
;special_int_1a_end:                                                    ;
;       ...                                                             ;
;       ...                                                             ;
;int_1a endp                                                            ;
;-----------------------------------------------------------------------;
;  input :                                                              ;
;       ah      function#                                               ;
;       stack   available                                               ;
;  register usage : do not destroy any register                         ;
;-----------------------------------------------------------------------;
        public  special_int_1a
        extrn   special_int_1a_end:near
special_int_1a:
        jmp     special_int_1a_end
;-----------------------------------------------------------------------;
;                       CHANGE_SPEED            ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;                       ENABLE_L1_CACHE                                 ;
;-----------------------------------------------------------------------;
;  this routine enables internal cache (WB or WT) mode by cpu           ;
;  routine and chipset programming.                                     ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : do not destroy any register                         ;
;-----------------------------------------------------------------------;
        public  enable_l1_cache
enable_l1_cache:
        push    ax
        mov     al,q_internal_cache
        call    check_cmos_data
        cmp     al,1
        pop     ax
        jbe     el1c_1
        call    enable_l1_cache_wb
        ret
el1c_1:
        call    enable_l1_cache_wt
        ret
;-----------------------------------------------------------------------;
;                       ENABLE_L2_CACHE                                 ;
;-----------------------------------------------------------------------;
;  this routine enables external cache (WB or WT) mode by chipset       ;
;  programming.                                                         ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : do not destroy any register                         ;
;-----------------------------------------------------------------------;
        public  enable_l2_cache
enable_l2_cache:
        push    ax
        mov     al,033h
        call    cmos_data_in_x
        test    al,1
        jz      el2c_2
        mov     al,q_internal_cache
        call    check_cmos_data         ; 0/1/2, disabled/wt/wb
        jz      el2c_2
        mov     al,q_external_cache
        call    check_cmos_data         ; 0/1/2, disabled/wt/wb
        jz      el2c_2                  ; disbaled
        cmp     al,1
        jz      el2c_1                  ; wt
        call    enable_l2_cache_wb      ; wb
        pop     ax
        ret
el2c_1:
        call    enable_l2_cache_wt
el2c_2:
        pop     ax
        ret
;-----------------------------------------------------------------------;
;                       GET_PIO_MODE_VALUE                              ;
;-----------------------------------------------------------------------;
;  this routine returns the highest PIO mode supported by the hard disk.;
;  input :                                                              ;
;       ds:bx   ptr to buffer containing the output of indentify drive  ;
;               command                                                 ;
;  output:                                                              ;
;       bl      mode value                                              ;
;       si      = 0000..drive supports IORDY                            ;
;               = FFFF..drive does not support IORDY                    ;
;  register destroyed : BX SI                                           ;
;-----------------------------------------------------------------------;
        public  get_pio_mode_value
get_pio_mode_value      proc    near
        push    di
        push    cx
        push    ax
        push    dx

        mov     di,bx                   ; DS:DI = ptr to buffer
        xor     si,si                   ; SI = 0000..drive does not support IORDY

        mov     bl,ds:byte ptr [di+51*2+1]; bit15-8 of word 51 = mode
        test    ds:byte ptr [di+53*2],02h; bit-1 of word 53 = 1 ?
        jz      pio_00                  ; word 64-70 are not valid

        test    ds:byte ptr [di+49*2+1],08h; bit-11 of word 49 = 1 ?
        jz      pio_no_iordy            ; no, drive does not support IORDY
        mov     si,0ffffh               ; SI = FFFF...drive supports IORDY
pio_no_iordy:

        mov     al,ds:byte ptr [di+64*2]; Get Advanced PIO mode value

        test    al,02h                  ; bit1 = 1 Mode 4 ?
        jnz     pio_mode_4              ; yes..

        test    al,01h                  ; bit0 = 1 Mode 3 ?
        jz      pio_00                  ; no..

        mov     bl,3                    ; Advanced PIO mode = 3
        jmp     short pio_00

pio_mode_4:
        mov     bl,4

pio_00:
        pop     dx
        pop     ax
        pop     cx
        pop     di
        ret
get_pio_mode_value      endp
COMMENT ~
pio_bit_check_table     label   byte
        db      01h             ; bit-0 for mode-0
        db      02h             ; bit-1 for mode-1
        db      04h             ; bit-2 for mode-2 to mode-4
        db      04h             ; bit-2 for mode-2 to mode-4
        db      04h             ; bit-2 for mode-2 to mode-4

        public  get_pio_mode_value
get_pio_mode_value      proc    near
        push    di
        push    cx
        push    ax
        mov     di,bx                   ; DS:DI = ptr to buffer
        xor     si,si                   ; SI = 0000..drive does not support IORDY
        test    ds:byte ptr [di+53*2],02h; bit-1 of word 53 = 1 ?
        jnz     pio_10                  ; word 64-70 are valid
pio_02:
        mov     bl,ds:byte ptr [di+51*2+1]; bit15-8 of word 51 = mode
;  word 64-67 are NOT valid..
;  BL = mode value..
        push    bx
        mov     al,bl
        mov     bx,offset cgroup:pio_bit_check_table
        xlat    cgroup:pio_bit_check_table; AL = bit to be checked
        pop     bx
;;;     test    ds:byte ptr [di+01h],al ; bit set ?
;;;     jnz     pio_00
;;;     mov     bl,00h                  ; force mode-0
;  BL = mode value..
        jmp     short pio_00
pio_10:
        mov     ax,ds:word ptr [di+67*2]; cycle time without IORDY
        call    get_pio_mode_from_cycle_time; BL = PIO mode
        test    ds:byte ptr [di+49*2+1],08h; bit-11 of word 49 = 1 ?
        jz      pio_00                  ; no, drive does not support IORDY
;  drive supports IORDY
        mov     ax,ds:word ptr [di+68*2]; cycle time with IORDY
        call    get_pio_mode_from_cycle_time; BL = PIO mode
;  AX = cycle time, BL = calculated mode
;  calculated mode value >= 3, check bit7-0 of word 64
;  bit7-0 of word 64 is bit map definition..
;       bit-0 = 1..mode 3 supported
;       bit-1 = 1..mode 4 supported
        mov     cl,bl
        sub     cl,03h
        jb      pio_01                  ; < mode 3, no need to check word 64
        mov     ch,1
        shl     ch,cl
        test    ds:byte ptr [di+64*2],ch; bit-x of word 64 = 0 ?
        jz      pio_02                  ; drive does not support advanced PIO mode
pio_01:
        mov     si,0ffffh               ; SI = FFFF...drive supports IORDY
pio_00:
        pop     ax
        pop     cx
        pop     di
        ret
get_pio_mode_value      endp
;---------------------------------------;
get_pio_mode_from_cycle_time:
;  input :  AX = cycle time
;  output:  BL = mode
;  register destroyed..BX
        xor     bx,bx
        or      ax,ax                   ; cycle time = 00 => mode 0
        jz      gmfct_00
        cmp     ax,383
        ja      gmfct_00                ; mode 0
        inc     bx
        cmp     ax,240
        ja      gmfct_00                ; mode 1
        inc     bx
        cmp     ax,180
        ja      gmfct_00                ; mode 2
        inc     bx
        cmp     ax,120
        ja      gmfct_00                ; mode 3
        inc     bx                      ; mode 4
gmfct_00:
        ret
;---------------------------------------;
get_pio_cycle_time_from_mode:
;  input :  BL = mode
;  output:  AX = cycle time
;  register destroyed..AX
        mov     ax,120
        cmp     bl,4
        ja      gctfm_01                ; invalid mode, assume 600ns
        jz      gctfm_00                ; mode 4, 120ns
        mov     ax,180
        cmp     bl,3
        jz      gctfm_00                ; mode 3, 180ns
        mov     ax,240
        cmp     bl,2
        jz      gctfm_00                ; mode 2, 240ns
        mov     ax,383
        cmp     bl,1
        jz      gctfm_00                ; mode 1, 383ns
gctfm_01:
        mov     ax,600                  ; mode 0, 600ns
gctfm_00:
        ret
~
;-----------------------------------------------------------------------;
;                       GET_DMA_MODE_VALUE                              ;
;-----------------------------------------------------------------------;
;  this routine returns the highest DMA mode supported by the hard disk.;
;  input :                                                              ;
;       ds:bx   ptr to buffer containing the output of indentify drive  ;
;               command                                                 ;
;  output:                                                              ;
;       ECX     Bit15-8 (CH) Non-Sync DMA mode information              ;
;                               = 00 Non-Sync DMA not supported         ;
;                               <>00 Non-Sync DMA mode                  ;
;               Bit31-24 Sync DMA mode information                      ;
;                               = 00 Sync DMA not supported             ;
;                               <>00 Sync DMA mode                      ;
;  register destroyed : ECX Bit33-8 (i.e. CL can NOT be destroyed)      ;
;-----------------------------------------------------------------------;
        public  get_dma_mode_value
get_dma_mode_value      proc    near
        push    si
        push    ax
        push    cx
;  DS:BX = ptr to buffer

;;;;    mov     ch,00h                  ; init DMA mode value
        xor     ecx,ecx                 ; init DMA mode value

        test    ds:byte ptr [bx+49*2+1],01h; Non-Sync DMA supported ?
        jz      short check_sync_dma    ; no
        mov     ch,ds:byte ptr [bx+52*2+1]; bit15-8 of word 52 = single word Non-Sync DMA mode
        test    ds:byte ptr [bx+53*2],02h; bit-1 of word 53 = 1 ?
        jnz     short non_sync_dma_00   ; word 64-70 are valid
;  word 64-67 are NOT valid..
;  CH = single word Non-Sync DMA mode value..
        cmp     ch,02h                  ; maxm is single word Non-Sync DMA mode-2
        jbe     short non_sync_dma_01   ; valid Non-Sync DMA mode
        mov     ch,00h                  ; force Non-Sync DMA mode-0
        jmp     short non_sync_dma_01
non_sync_dma_00:
;  word 64-67 are valid..
        mov     al,ds:byte ptr [bx+62*2]; single word Non-Sync DMA transfer capibility
        call    get_dma_mode_from_capibility; CL = Non-Sync DMA mode
        push    cx
        mov     ax,ds:word ptr [bx+65*2]; multiword Non-Sync DMA cycle time
        mov     si,offset cgroup:non_sync_dma_mode_time_table
        call    get_dma_mode_from_cycle_time; CL = Non-Sync DMA mode
;  CL = multiword Non-Sync DMA mode, check this value with word 63
;  bit7-0 of word 63 is bit map definition..
;       bit-0 = 1..multiword mode 0 supported
;       bit-1 = 1..multiword mode 1 supported
;       bit-2 = 1..multiword mode 2 supported
        mov     al,1
        shl     al,cl
        test    ds:byte ptr [bx+63*2],al; bit-x of word 63 = 0 ?
        pop     ax                      ; AL = single word Non-Sync DMA mode
        jz      short non_sync_dma_02   ; drive does not support multiword Non-Sync DMA mode
        mov     ch,cl
        or      ch,20h                  ; bit-5 = 1..multi word Non-Sync DMA
        jmp     short check_sync_dma
non_sync_dma_02:
;  drive does not support found multiword Non-Sync DMA mode
        mov     ch,al                   ; use single word Non-Sync DMA mode
non_sync_dma_01:
        or      ch,10h                  ; bit-4 = 1..single word Non-Sync DMA
check_sync_dma:
;  CH = Non-Sync DMA information
;  check for Sync DMA
        rol     ecx,16
;----------------------------------------;
COMMENT ~               this code is according to Intel Spec Sep 20, 1996.
;                       Spec is changed in ATA Untra-DMA spec Oct 26, 1996.
        test    ds:byte ptr [bx+53*2],04h; bit-2 of word 53 = 1 ?
        jz      short sync_dma_00       ; word 84-85 are NOT valid, Sync DMA not supported
;  word 84-85 are valid..Sync DMA supported
        mov     ax,ds:word ptr [bx+85*2]; Sync DMA cycle time
        mov     si,offset cgroup:sync_dma_mode_time_table
        call    get_dma_mode_from_cycle_time; CL = Sync DMA mode
;  CL = Sync DMA mode, check this value with word 84
;  bit7-0 of word 84 is bit map definition..
;       bit-0 = 1..Sync DMA mode 0 supported
;       bit-1 = 1..Sync DMA mode 1 supported
;       bit-2 = 1..Sync DMA mode 2 supported
        mov     al,1
        shl     al,cl
        test    ds:byte ptr [bx+84*2],al; bit-x of word 84 = 0 ?
        jz      short sync_dma_00       ; drive does not support Sync DMA mode
        mov     ch,cl
        or      ch,40h                  ; bit-6 = 1..Sync DMA
sync_dma_00:
END OF COMMENT ~

;  this code is according to ATA Ultra-DMA spec Oct 26, 1996
        test    ds:byte ptr [bx+53*2],04h; bit-2 of word 53 = 1 ?
        jz      short sync_dma_00       ; word 88 are NOT valid, Sync DMA not supported
;  bit7-0 of word 88 is bit map definition..
;       bit-0 = 1..Sync DMA mode 0 supported
;       bit-1 = 1..Sync DMA mode 1 supported
;       bit-2 = 1..Sync DMA mode 2 supported
        mov     al,ds:byte ptr [bx+88*2]; get bit7-0 of word 88
	and	ax,01fh			; keep bit0-4 for mode 0-4
	jz	sync_dma_00		; not supported..
	push	bx
	bsr	bx,ax			; bx = index from ultra dma mode
	mov	ch,bl
	or	ch,40h			; bit-6 = 1..Ultra DMA
	pop	bx
sync_dma_00:
;----------------------------------------;
        rol     ecx,16
        pop     ax
        mov     cl,al                   ; restore CL
        pop     ax
        pop     si
        ret
get_dma_mode_value      endp
;---------------------------------------;
get_dma_mode_from_capibility:
;  input :  AL = bit mapped capibility
;  output:  CL = mode
;  register destroyed..CX
        mov     cx,0200h                ; CH = bit to test, CL = mode
        test    al,01h                  ; bit-0 set ?
        jz      gdmfc_01                ; no, assume mode 0
gdmfc_00:
        test    al,ch                   ; bit set ?
        jz      gdmfc_01                ; no
        inc     cl
        shl     ch,01h                  ; next bit
        jnz     gdmfc_00
gdmfc_01:
        ret
;---------------------------------------;
get_dma_mode_from_cycle_time:
;  input :  AX = cycle time
;           CS:SI = ptr to table of cycle time
;  output:  CL = mode
;  register destroyed..CX
        xor     cx,cx
        or      ax,ax                   ; cycle time = 00 => mode 0
        jz      gdmfct_00
        cmp     ax,cs:word ptr [si]
        ja      gdmfct_00               ; mode 0
        inc     cx
        cmp     ax,cs:word ptr [si+2]
        ja      gdmfct_00               ; mode 1
        inc     cx                      ; mode 2
gdmfct_00:
        ret
;-----------------------------------------------------------------------;
non_sync_dma_mode_time_table            label   byte
        dw      150                     ;  > 150ns -> Non-Sync DMA Mode 0
        dw      120                     ;  > 120ns -> Non-Sync DMA Mode 1
                                        ; <= 120ns -> Non-Sync DMA Mode 2
non_sync_dma_mode_time_table_end        label   byte
;-----------------------------------------------------------------------;
sync_dma_mode_time_table                label   byte
        dw      75                      ;  > 75ns -> Sync DMA Mode 0
        dw      55                      ;  > 55ns -> Sync DMA Mode 1
                                        ; <= 55ns -> Sync DMA Mode 2
sync_dma_mode_time_table_end            label   byte
;-----------------------------------------------------------------------;
;                       INT-15 Function E820                            ;
;-----------------------------------------------------------------------;
;  input :                                                              ;
;       EBX     continuation value                                      ;
;       ES:DI   ptr to buffer to be filled in by BIOS                   ;
;       ECX     buffer size in bytes                                    ;
;       EDX     signature 'SMAP'                                        ;
;  output:                                                              ;
;       CY      error                                                   ;
;       NC      ok                                                      ;
;               EAX     'SMAP'                                          ;
;               ES:DI   ptr to buffer                                   ;
;               ECX     length of information in bytes as filled in     ;
;                       by BIOS                                         ;
;               EBX     continuation value                              ;
;-----------------------------------------------------------------------;
;                       BU SPECIFIC DATA AREA                           ;
;-----------------------------------------------------------------------;
; UPDATE_BLOCKS DW      #of update blocks (each of 2KBytes length) available
;                       for storage in NVRAM to initialized during POST
        public  update_blocks
update_blocks   dw      0000h   ; needed in P6 BIOS Upgrade functions

	public	micro_code_start_addr
micro_code_start_addr	dd	?
;-----------------------------------------------------------------------;
        public  e820_max_cont_value
        public  e820_info_table
e820_max_cont_value     dd      0ffffffffh; max continuation value
e820_info_table         db      12*size e820_info_struc dup (00)
;-----------------------------------------------------------------------;
        public  int_15_e820
int_15_e820:                            ; INT15, E820
        cmp     edx,'SMAP'              ; 534d4150h..signature string 'SMAP'
        jnz     i15e820_err             ; invalid call
        cmp     ebx,cgroup:e820_max_cont_value; valid continuation value ?
        jbe     i15e820_00              ; valid continuation value
;  illegal continuation call..return error..
i15e820_err:
        stc                             ; set carry to indicate an error
        jmp     short i15e820_exit
i15e820_00:
        cmp     ecx,00000014h           ; min buffer size is 20 bytes
        jb      i15e820_err             ; invalid buffer size
        cld                             ; clear direction flag
        push    edx                     ; save EDX i.e. 'SMAP'
;  initialize caller's buffer..
        mov     ecx,00000014h           ; #of bytes to be initialized
        push    ecx
        push    edi
        xor     al,al
        rep     stosb
        pop     edi
        pop     ecx                     ; returned buffer size in bytes
        mov     al,size e820_info_struc ; size of memory info structure
        mul     bl                      ; AX = pointer to table
        add     ax,offset cgroup:e820_info_table
        push    si
        mov     si,ax
;  lower 32-bit base address from above table to caller's buffer..
        lods    cs:dword ptr [si]
        mov     dword ptr es:[di],eax   ; low 32 bits of base address
;  lower 32-bit length from above table to caller's buffer..
        lods    cs:dword ptr [si]
        mov     dword ptr es:[di+8h],eax; low 32 bits of length in bytes
;  memory type from above table to caller's buffer..
        lods    cs:byte ptr [si]
        mov     byte ptr es:[di+10h],al ; memory type
        pop     si
;  restore continuation value from stack and calculate next continuation value
        inc     bx                      ; next continuation value
        cmp     bx,cgroup:word ptr e820_max_cont_value
        jbe     i15e820_01              ; more descriptor available
        mov     bx,0000h                ; last descriptor returned this time
i15e820_01:
        pop     eax                     ; EAX = 'SMAP'
        clc                             ; OK
i15e820_exit:
        retf    0002
;-----------------------------------------------------------------------;
;  following routine is needed for resolving externals which can be used;
;  for power management.                                                ;
;-----------------------------------------------------------------------;
;                       SET_INT_40_FLAG         ; Moved to RUNTIME.ASM
;                       CLEAR_INT_40_FLAG       ; Moved to RUNTIME.ASM
;                       SET_INT_13_FLAG         ; Moved to RUNTIME.ASM
;                       CLEAR_INT_13_FLAG       ; Moved to RUNTIME.ASM
;-----------------------------------------------------------------------;
        public  set_int_9_flag
        public  clear_int_9_flag
        public  set_int_14_flag
        public  clear_int_14_flag
        public  set_int_17_flag
        public  clear_int_17_flag
        public  set_int_74_flag
        public  clear_int_74_flag
set_int_9_flag:
clear_int_9_flag:
set_int_14_flag:
clear_int_14_flag:
set_int_17_flag:
clear_int_17_flag:
set_int_74_flag:
clear_int_74_flag:
        ret
;---------------------------------------;
        public  int_77
int_77:
        iret
;-----------------------------------------------------------------------;
;                       DISPLAY_IO_VERSION                              ;
;-----------------------------------------------------------------------;
;  this routine displays the I/O module version number.                 ;
;  input :                                                              ;
;       ds      = cs                                                    ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : can destroy any register execpt EBP, DS, ES         ;
;-----------------------------------------------------------------------;
        extrn   _io_version:byte
        extrn   display_message:near
        public  display_io_version
display_io_version:
        mov     si,offset cgroup:_io_version
        call    display_message
        ret
;-----------------------------------------------------------------------;
;                               CHECK_P6                                ;
;-----------------------------------------------------------------------;
;  this routine checks for presence of P6.                              ;
;  input :                                                              ;
;       none                                                            ;
;  output:                                                              ;
;       zr      P6 present                                              ;
;       nz      P6 absent                                               ;
;  register destroyed : None                                            ;
;-----------------------------------------------------------------------;
        extrn   get_processor_info:near
        public  check_p6
check_p6:
        or     sp,sp           ; ZF=0
        ret
COMMENT ~
IF      MKF_BUP6
        pushad
        call    get_processor_info
;  BH, BL = CPU#, vendor#
;  AX = bit11-9 generation Code (011 = P6)
        cmp     bl,00h                  ; Intel ?
        jnz     cp6_00                  ; no
        and     ah,0eh                  ; keep bit11-9 of AX
        cmp     ah,06h                  ; bit11-9 = 011 ?
cp6_00:
;  ZR/NZ = P6 present/absent
        popad
        ret
ELSE
        or      sp,sp                   ; NZ, P6 absent
        ret
ENDIF
~
;-----------------------------------------------------------------------;
;                       DETECT_FLASH_NVRAM                              ;
;-----------------------------------------------------------------------;
;  this routine detects the Flash part presence.                        ;
;  input :                                                              ;
;       CS writeable                                                    ;
;  output:                                                              ;
;       none                                                            ;
;  register destroyed : NONE                                            ;
;-----------------------------------------------------------------------;
; (CORE0071,CORE0072)>
	extrn	rth_nvram_base:dword
	extrn	rth_nvram_size:word
	extrn	flash_found_table:byte
	extrn	flash_support_table:byte
	extrn	flash_support_entry_size:abs
	extrn	flash_write_enable:near
	extrn	flash_write_disable:near
	public	detect_flash_nvram
detect_flash_nvram:
	push	ds
	pushad
	push	cs
	pop	ds
;  detect the flash part present in the motherboard..
	call	flash_write_enable	; enable flash write
	mov	bx,offset cgroup:flash_support_table
dfn_02:
	mov	di,[bx]			; get ptr to next Flash part table
	mov	ax,[bx+2]		; PnP NVRAM base address
	mov	cx,[bx+4]		; boot block start address
	cmp	di,0ffffh		; end of table ?
	jz	dfn_01			; yes..no flash part found
	call	word ptr [di]		; find flash ID
	jz	dfn_01			; flash part found
	add	bx,flash_support_entry_size
	jmp	short dfn_02		; continue searching for flash part
dfn_01:
;  DI = FFFF, no flash found
;     <>FFFF, pointer to flash part table
;  flash part found..make this flash part entry as first entry in the table
;  and use the first entry from now on..
	mov	bx,offset cgroup:flash_found_table
	mov	ds:word ptr [bx],di
	mov	ds:word ptr [bx+2],ax
	mov	ds:word ptr [bx+4],cx
if	MKF_NO_NVRAM
else
if	MKF_FLASH_4GB
	or	eax,0ffff0000h
	mov	cgroup:rth_nvram_base,eax
	sub	cx,ax
	inc	ax
	jnz	dfn_03			; NVRAM present
	xor	ecx,ecx			; NVRAM absent, make size 0
	mov	cgroup:rth_nvram_base,ecx
dfn_03:
					; (CORE0071)>
; Always make NVRAM size = 4K because the
; DIM buffer is not enough for large NVRAM.
	or	cx,cx
	jz	dfn_04
	mov	cx,1000h		; 4k size
dfn_04:
	mov	cgroup:rth_nvram_size,cx
					; <(CORE0071)
endif
endif
	push	di
	call	flash_write_disable	; disable flash write
	pop	di
	mov	ax,0b4b4h		; bit-7 = 0/1 for NVRAM not/yes found
	call	cmos_data_in
	and	al,7fh			; clear bit-7
if	MKF_INC_EISA
else
	cmp	cgroup:word ptr rth_nvram_size,0000h
	jz	no_nvram
endif
	or	al,80h
no_nvram:
	xchg	al,ah
	call	cmos_data_out
	popad
	pop	ds
	ret
; <(CORE0071,CORE0072)
;-----------------------------------------------------------------------;
;                       KBC_LOCK                                        ;
;-----------------------------------------------------------------------;
;  this routine can be used to lock the keyboard controller during BIOS ;
;  POST/RUNTIME execution when interrupt vectors are already initialized;
;  input :                                                              ;
;       none                                                            ;
;  output:                                                              ;
;       CLI                                                             ;
;  register destroyed : AX                                              ;
;  NOTE :                                                               ;
;       1. must be invoked by CALL.                                     ;
;***********************************************************************;
; Algorithm:                                                            ;
; Step-0: Issue 60h command. Then Kb controller should wait for the next;
;         data byte.                                                    ;
; Step-1: Wait for both IB and OB free.                                 ;
; Step-2: If OB is full, then we need to read the data.                 ;
;         If IRQ1 or IRQ12 is enabled, then enable KB interface (this   ;
;         will nullify the previous 60h command) and make STI and go to ;
;         step-0.                                                       ;
;         If IRQ1 and IRQ12 both are disabled, read data from port 60h  ;
;         and go to step-1.                                             ;
; Step-3: Exit. Now kb controller is locked.                            ;
;**************************** PROBLEMS *********************************;
; Problem found on NON-AMI kb controllers using this KBC_LOCK routine.  ;
; Ex: After issuing 60h command, some kb controller takes next byte     ;
; (irrespective of whether it is output on port 60h or 64h) as data. In ;
; this case, change command 60h to command D1h (in step-0).             ;
;***********************************************************************;
;-----------------------------------------------------------------------;
        public  kbc_lock
kbc_lock:
        cli
        in      al,64h
        test    al,2
        jnz     kbc_lock
        mov     al,60h                  ; write command byte command
;;;;    mov     al,0d1h                 ; write o/p port command
        out     64h,al
        jcxz    $+2
klp_00:
        in      al,64h
        test    al,1                    ; op buffer full ?
        jnz     klp_01                  ; yes
        test    al,2                    ; ip buffer free ?
        jnz     klp_00                  ; no
        ret                             ; locked
klp_02:
        in      al,60h                  ; consume data
        jmp     short klp_00
klp_05:
        in      al,0a1h                 ; if IRQ12 is disabled, goto post
        test    al,10h
        mov     al,0a8h                 ; enable mouse interface
        jmp     short klp_06
klp_01:
        test    al,20h                  ; 0/1 = kb/mouse data
        jnz     klp_05
        in      al,21h                  ; if IRQ1 is disabled, goto post
        test    al,2
        mov     al,0aeh                 ; enable keyboard interface
klp_06:
        jnz     klp_02
        out     64h,al
        jcxz    $+2
klp_03:
        in      al,64h
        test    al,2                    ; ip buffer free ?
        jnz     klp_03                  ; no
        sti                             ; STI generates the interrupt after
        nop                             ; executing the next instruction
        nop
        jmp     short kbc_lock
;-----------------------------------------------------------------------;
;                       USER_DEFINED_ROUTINE                            ;
;-----------------------------------------------------------------------;
;  this is an user defined routine. this routine will be called from    ;
;  F000:EEE4. the specification and usage of this routine is also user  ;
;  definable.                                                           ;
;  input :                                                              ;
;       user defined                                                    ;
;  output:                                                              ;
;       user defined                                                    ;
;  register destroyed : user defined                                    ;
;  NOTE: this routine must return with RET (near).                      ;
;-----------------------------------------------------------------------;
        public  user_defined_routine
user_defined_routine:
					; (CORE0221+)>
;-----------------------------------------------------------------------;
;                       GEN_SMI_FOR_GPNV				;
;-----------------------------------------------------------------------;
; this routine is used to generate an SMI and calls back to		;
; user_defined_routine F000:EEE4 for GPNV functions (55h,56h,57h)	;
; Input :                                                              	;
;	BP	F000:BP to call in SMM					;
;	others are same as caller's					;
; Output:                                                              	;
;	same as	caller's						;
; NOTES: DO NOT DESTROY ANY CALLER'S REGISTERS BEFORE SMI GERENATED!	;
;-----------------------------------------------------------------------;
if (MKF_GPC_SUPPORT) and (MKF_GPNV_SUPPORT) and (MKF_GPNV_FLASH)
	public	gen_smi_for_gpnv
gen_smi_for_gpnv:
	rol	eax,16				; exchange ax+ and ax
	mov	ax,'GP'
	rol	eax,16				; eax+ = 'GP'
;;	out	0b2h,al				; Write to APM port to generate SMI
;; save dx
	shl	edx,16
	mov	dx,MKF_PM_BASE_ADDRESS+35h
	out	dx,al
endif
					; <(CORE0221+)
	ret
					; <(CORE0221+)
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
        public  _NRUNTIMEX_ENDS
_NRUNTIMEX_ENDS label   byte            ; marks end of module
;---------------------------------------;
_text   ends
        end
