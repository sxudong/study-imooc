        page    ,132
        title   POST HOOKS (NO PORTING NEEDED IN GENERAL)
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
;*****************************************************************;
;---------------------------------------;
        include mbiosmac.mac
        include mbiosequ.equ
        include cf.equ
        include biosdata.dat
        include makeflag.equ
        include setupequ.ext
        include silent.equ
        include makeflag.equ
;---------------------------------------;
        extrn   frequency_high:near
        extrn   frequency_low:near
        extrn   check_cmos_data:near
        extrn   get_cmos_reg_mask_x:near
        extrn   reset_e05b:near
        extrn   proc_shutdown:near
        extrn   check_cmos_8e:near
        extrn   ide_prim_base_addr:word
        extrn   ide_sec_base_addr:word
        extrn   ide_prim_irq:byte
        extrn   ide_sec_irq:byte
        extrn   bios_scratch:byte
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _NPOST_STARTS
_NPOST_STARTS   label   byte            ; marks start of module
;-----------------------------------------------------------------------;
;                       INIT_BEFORE_KB_BAT                              ;
;-----------------------------------------------------------------------;
; check_point           : 0B                                            ;
; This routine can be used if any special work involved before 8042     ;
; keyboard controller initialization after power-on/soft reset.         ;
; input:                                                                ;
;       DS      0000H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        extrn   cmos_data_in_x:near
        extrn   cmos_data_out_x:near
	extrn	open_extend_cmos:near
	extrn	close_extend_cmos:near
        public  init_before_kb_bat
init_before_kb_bat:
	test	bp,cmos_bat_err_bit+cmos_csum_err_bit
	jz	check_data_code
	mov	ax,0ffc0h		
clear_stand_cmos:
	call	cmos_data_out_x			; Write 0ffh
	inc	al
	cmp	al,0feh
	jnz	clear_stand_cmos
	pushf
	call	open_extend_cmos
	mov	ax,0080h
clear_extend_cmos:
	call	cmos_data_out_x			; Write 000h 
	inc	al
	jnz	clear_extend_cmos
	call	close_extend_cmos
	popf
check_data_code:
        mov     eax, cs:[0f47bh]
        mov     dx,ax
        bswap   eax
        mul     ah
        mul     dx
        add     ah,al
        mov     al,ah
        and     al,0fh
        shr     ah,4
        add     ah,al

        mov     al,0b3h
        call    cmos_data_in_x
        mov     dl,al
        and     al,01111100b
        shr     al,2
        cmp     al,ah
        jz      bios_version_ok
        shl     ah,2
        and     dl,10000011b
        or      ah,dl
        mov     al,0b3h
        call    cmos_data_out_x
        or      bp,cmos_csum_err_bit    ; set soft error
        mov     ax,5c8eh
        call    cmos_data_out_x
bios_version_ok:
        ret
;-----------------------------------------------------------------------;
;               INIT_AFTER_KB_BAT       ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;               BEFORE_VECTOR           ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;                               SET_MEMORY                              ;
;-----------------------------------------------------------------------;
; check_point           : 27                                            ;
; This routine is called for any init before memory test.               ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
	extrn	irq_map:byte
	extrn	pci_irq_avail_table:byte
        public  set_memory
set_memory:
	mov	ax,0b102h
	mov	cx,0350h
	mov	dx,109eh
	sub	si,si
	int	1ah
        push    ds
        push    cs
        pop     ds
	jnc	irq_route_table_done
        extrn   ms_irq_route_table_sign:byte
        mov     si,offset cgroup:ms_irq_route_table_sign
        push    si
        mov     cx, [si+6]
        xor     ax,ax
@@:
        lodsb
        add     ah,al
        loop    @b
        neg     ah
        pop     si
        mov     [si+31],ah
irq_route_table_done:
	mov	di,offset cgroup:irq_map
	add	di,7
	mov	cx,4
	mov	si,offset cgroup:pci_irq_avail_table
check_peri_irq:
	lodsb
	inc	si
	call	get_cmos_item
	dec	al
	jnz	@f
	dec	si
	lodsb
	mov	[di],al
	inc	di
@@:
	loop	check_peri_irq
	pop	ds
        ret
;-----------------------------------------------------------------------;
;               C000_CONTROL_BEFORE     ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;               C000_CONTROL_AFTER      ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;                       DISPLAY_CPU_NAME_PRATING_CLOCK                  ;
;-----------------------------------------------------------------------;
; check_point           : 37                                            ;
; This routine is called from SN.ASM at the end of sign-on message      ;
; display but before calling the hook after_sign_on_msg. this routine   ;
; displays the CPU name, PRating, clock, etc.                           ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       Cursor is located at column 0 of a particular row               ;
;       stack   available                                               ;
; output:                                                               ;
;       Cursor is expected to be at column 0 of a particular row which  ;
;       will not be same as the input row if this routine displays      ;
;       anything.                                                       ;
; register usage : do not destroy any register                          ;
;-----------------------------------------------------------------------;
        extrn   write_tty:near
        extrn   display_cpu_name_prating:near
        extrn   check_display_cpu_clock:near
        extrn   display_cpu_clock:near
        extrn   display_0d0a:near
        public  display_cpu_name_prating_clock
display_cpu_name_prating_clock:
        push    ax
        call    display_cpu_name_prating; display CPU name, PRating
        call    check_display_cpu_clock
        jc      short dcnpc_00          ; do not display CPU clock
        mov     al,' '
        call    write_tty
        mov     al,'-'
        call    write_tty
        mov     al,' '
        call    write_tty
        call    display_cpu_clock
dcnpc_00:
        call    display_0d0a            ; take cursor to col 0 of next row
        pop     ax
        ret
;-----------------------------------------------------------------------;
;                               AFTER_SIGN_ON_MSG                       ;
;-----------------------------------------------------------------------;
; check_point           : 37                                            ;
; This routine is called after normal sign-on message display.          ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; Note:                                                                 ;
; 1. At input, cursor is set to column 0 of new row.                    ;
; 2. Implement any new stuff to be displayed here.                      ;
; 3. After displaying the new stuff, set cursor to column 0 of next row.;
;-----------------------------------------------------------------------;
        public  after_sign_on_msg
after_sign_on_msg:
        ret
;-----------------------------------------------------------------------;
;                       DISPLAY_BEFORE_MEM_COUNTING                     ;
;-----------------------------------------------------------------------;
; check_point           : 39                                            ;
; This routine can be used to display any shared memory information.    ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; Note :                                                                ;
;       1. Cursor position is at same posn where memory counting will be;
;       displayed.                                                      ;
;       2. This routine can be used to display the Shared memory size.  ;
;-----------------------------------------------------------------------;
        extrn   read_cursor_posn:near
        extrn   set_cursor_posn:near
        public  display_before_mem_counting
display_before_mem_counting:
;        call    read_cursor_posn        ; read current cursor posn
;        push    dx

;  add code here to display any shared memory size, etc.

;        pop     dx
;        call    set_cursor_posn
        ret
;-----------------------------------------------------------------------;
;                               THREE84K_DISPLAY                        ;
;-----------------------------------------------------------------------;
; check_point           : 50                                            ;
; This routine returns the information whether extra 384K memory in the ;
; region A0000-FFFFF will be displayed in memory count during memory    ;
; testing.                                                              ;
; input :                                                               ;
;       BP      current count of 64k segments                           ;
;       DS      0040h                                                   ;
;       ES      0000h with 4GB limit                                    ;
;       stack   available                                               ;
; output:                                                               ;
;       BP      updated count of 64k segment                            ;
; register usage : DO NOT destroy any register                          ;
; NOTE :                                                                ;
; 1. Decide how many extra 64k need to be displayed and add that count  ;
;    to BP.                                                             ;
;    For example, if extra 128K to be displayed, ADD BP,2 and ret.      ;
;    For example, if extra 256K to be displayed, ADD BP,4 and ret.      ;
;    For example, if extra 384K to be displayed, ADD BP,6 and ret.      ;
; 2. Default code is                                                    ;
;               ADD BP,6        ; display extra 384k                    ;
;               RET                                                     ;
;-----------------------------------------------------------------------;
        public  three84k_display
three84k_display:
        add     bp,6                    ; display extra 384K
        ret
;-----------------------------------------------------------------------;
;                       PS2MOUSE_EDGE_LEVEL                             ;
;-----------------------------------------------------------------------;
; check point   : 80                                                    ;
; this routine is called during mouse initialisation of PS/2 mouse to   ;
; program the irq level to edge triggered or level triggered.           ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EP, SS, DS, ES       ;
;-----------------------------------------------------------------------;
        public  ps2mouse_edge_level
ps2mouse_edge_level     proc    near
        ret
;  if the programming is needed then remove the above RET and activate the
;  following code..
;;      cli                             ; disable interrupts
;;      mov     dx,4d1h                 ;
;;      in      al,dx                   ; (al) = read current status
;;      jcxz    short $+2               ; i/o delay
;;      jcxz    short $+2               ; i/o delay
;;      or      al,00010000b            ; set as level triggered
;;      out     dx,al                   ;
;;      sti                             ; enable interrupts
;;      ret
ps2mouse_edge_level     endp
;-----------------------------------------------------------------------;
;                       CHECK_KB_RESET                                  ;
;-----------------------------------------------------------------------;
; check point   : 80                                                    ;
; this routine is called before kb initialization to check whether to   ;
; issue KB reset or not.                                                ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       nc      do not give kb reset                                    ;
;       cy      give kb reset                                           ;
; register usage : can destroy any register except EP, SS, DS, ES       ;
;-----------------------------------------------------------------------;
        public  check_kb_reset
check_kb_reset:
        clc                     ; do not give kb reset
        ret
;-----------------------------------------------------------------------;
;               BEFORE_SETUP            ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;                               AFTER_SETUP                             ;
;-----------------------------------------------------------------------;
; check_point           : 88                                            ;
; This routine can be used for any programming after cmos setup.        ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        public  after_setup
after_setup:
        ret
;-----------------------------------------------------------------------;
;                               ADJUST_SETUP                            ;
;-----------------------------------------------------------------------;
; check_point           : 8C                                            ;
; This routine can be used to do any programming even if cmos setup is  ;
; not executed.                                                         ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; 1. program setup selected parameters including non-cacheable regions. ;
; 2. use check_cmos_data routine to get the value of any selected       ;
; parameters. DO NOT ACCESS ABSOLUTE CMOS REGISTERS.                    ;
;-----------------------------------------------------------------------;
        extrn   enable_l1_cache:near
        extrn   disable_l1_cache:near
        extrn   enable_l2_cache:near
        extrn   _led_on_8042:byte
        extrn   read_8042_input_port:near
        extrn   kbc_lock:near
        extrn   program_parameters_after_setup:near
        extern  program_peripheral_setup_parameters(dummy_ret):near
        extrn   dummy_ret:near
        extrn   init_gpc_apm:near
        public  adjust_setup
adjust_setup:
        mov     al,q_acpi_os
        call    check_cmos_data
        jz      short as_00             ; not ACPI OS
        or      cgroup:bios_scratch,acpi_aware_os_bit; Bit-5 = 1 -> ACPI OS
as_00:
;  form INT-15 func E820 table information..
        call    form_e820_table         ; form E820 information
;  program setup selected chipset parameters..
        call    program_parameters_after_setup; program chipset setup parameters
;  program setup selected I/O chipset parameters, if any..
        call    program_peripheral_setup_parameters; program I/O setup parameters
;---------------------------------------;
if      MKF_ACPI_SUPPORT
        extrn   rsd_ptr_header:byte
;  build ACPI table
        xor     eax,eax
        mov     si,offset cgroup:rsd_ptr_header
        mov     cs:dword ptr [si],eax   ; clear 'RSD PTR ' signature
        mov     cs:dword ptr [si+4],eax
        test    cgroup:bios_scratch,acpi_aware_os_bit; ACPI OS
        jz      short as_01                     ; not ACPI OS
        push    es
        push    ds
        push    cs
        pop     ds
        xor     si,si
        push    0f000h
        pop     es
        xor     di,di
        xor     cx,cx
        extrn   copy_to_shadow:near
        call    copy_to_shadow
        pop     ds
        pop     es
        extrn   build_acpi_table:near
        call    build_acpi_table        ; ACPI table building
as_01:
endif
;---------------------------------------;
;  program bootup speed..
IF      MKF_TURBO_SWITCH
        and     ds:byte ptr [16h],11011111b; bit-5 = 0..currently high speed
        mov     ah,cgroup:_led_on_8042
        or      ah,ah
        jz      flohi_1                 ; no turbo switch selected
        mov     al,q_turbo_switch
        push    ax
        call    check_cmos_data         ; check setup option
        pop     ax
        jz      flohi_1                 ; setup option says disabled
        or      ds:byte ptr [16h],40h   ; bit-6 = turbo function enabled
        call    kbc_lock                ; lock KBC
        call    read_8042_input_port
        push    ax
        and     ds:byte ptr [16h],7fh   ; bit-7 = current pin status = 0
        and     al,ah
        and     al,01111111b
        jz      flohi_x
        or      ds:byte ptr [16h],80h   ; bit-7 = current pin status = 1
flohi_x:
        pop     ax
        or      ah,ah                   ; in bit-7 = 1 then if pin-x = 1
        js      flohi_0                 ;               then high speed
        not     al                      ; if bit-7 = 0 then if pin-x = 1
flohi_0:                                ;               then low speed
        and     al,ah
        and     al,01111111b
        jz      flohi_2                 ; goto low speed
flohi_1:
ENDIF
;---------------------------------------;
        mov     al,q_bootup_speed
        call    check_cmos_data
        jz      flohi_2
        call    frequency_high
        jmp     short flohi_3
flohi_2:
        call    frequency_low
flohi_3:
        ret
;-----------------------------------------------------------------------;
;               FORCE_NO_OF_SECTORS             ; Moved to NRUNTIME.ASM
;-----------------------------------------------------------------------;
;               GET_HD_STANDBY_VALUE_PM         ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;               GET_HD_STANDBY_VALUE_PS         ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;               GET_HD_STANDBY_VALUE_SM         ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;               GET_HD_STANDBY_VALUE_SS         ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;               C800_CONTROL_BEFORE             ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;               C800_CONTROL_AFTER              ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;                       GET_AUTO_KEY_LOCK_TIME_OUT                      ;
;-----------------------------------------------------------------------;
; check point           : 9B                                            ;
; this routine is called from keyboard controller timer programming. this
; routine will be called if it is not a Green PC. in case of Green PC   ;
; corresponding functionality will be implemented by different timers   ;
; in keyboard controller. if it is not a Green PC, then user can make use
; of this feature to lock the keyboard.                                 ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       ZR      auto key lock disabled                                  ;
;               AL = 00                                                 ;
;       NZ      auto key lock enabled                                   ;
;               AL = time out value in Minutes                          ;
; register usage : can not destroy any register except AX               ;
;-----------------------------------------------------------------------;
        public  get_auto_key_lock_time_out
get_auto_key_lock_time_out:
        xor     al,al                   ; disabled..AL = 00..ZR
        ret
;  by default auto key lock time out is disabled..
;  if auto key lock time out to be enabled..calculate the time out value from
;  user selection in which case, some setup option must be implemented..if
;  no cmos option is available, some default timing value (5min) must be
;  returned..
;;      mov     al,05h                  ; 5 min
;;      or      al,al                   ; NZ
;;      ret
;-----------------------------------------------------------------------;
;                               INIT_BEFORE_FINIT                       ;
;-----------------------------------------------------------------------;
; check point           : 9B                                            ;
; before co-processor check, if any initialization is required.         ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       (ZF)    0, check co-proc                                        ;
;               1, do not check co-proc                                 ;
; if (ZF) = 0 then init_after_finit will be called.                     ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        public  init_before_finit
init_before_finit:
        or      sp,sp                   ; (ZF) = 0, test coproc
        ret
;-----------------------------------------------------------------------;
;                               INIT_AFTER_FINIT                        ;
;-----------------------------------------------------------------------;
; check point           : 9D                                            ;
; after co-processor check, if any initializationis required.           ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        public  init_after_finit
init_after_finit:
        ret
;-----------------------------------------------------------------------;
;                               POST_DIAG_LOOP                          ;
;-----------------------------------------------------------------------;
; check point           : A2                                            ;
; if diag switch is on, this routine gets control after soft error      ;
; messages are displayed. do any special operation, then give control   ;
; to begining of diagnostics.                                           ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        public  post_diag_loop
post_diag_loop:
        jmp     reset_e05b
;-----------------------------------------------------------------------;
;               E000_CONTROL_BEFORE             ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;               E000_CONTROL_AFTER              ; Moved to OEMPOST.ASM
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
;                       GET_SHADOW_STATUS       ; Moved to OEMPOST.ASM
;-----------------------------------------------------------------------;
;                       GET_POST_INFO           ; Moved to OEMPOST.ASM  ;
;-----------------------------------------------------------------------;
;                       CHECK_POST_RAM                                  ;
;-----------------------------------------------------------------------;
;  this routine makes code segment of POST write enabled.               ;
;  input :                                                              ;
;       none                                                            ;
;  output:                                                              ;
;       none                                                            ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        extrn   get_shadow_status:near
        extrn   e000_read_x_write_ram:near
        extrn   f000_read_x_write_ram:near
        extrn   copy_control_to_ram:near
        public  check_post_ram
check_post_ram:
        call    get_shadow_status       ; F000 R/W possible
        jc      cpr_00                  ; no
        test    di,01h                  ; shadow R/W possible ?
        jz      cpr_00                  ; no
        test    cs:bios_scratch,02h     ; E000 shadow enabled ?
        jz      cpr_02                  ; yes..no need for E000
        call    e000_read_x_write_ram   ; make E000 write enabled
cpr_02:
        call    f000_read_x_write_ram   ; make F000 write enabled
cpr_01:
        ret
cpr_00:
;  shadow R/W not possible..
;  execute POST from RAM..
        call    copy_control_to_ram     ; copy and give control in RAM
        ret
;-----------------------------------------------------------------------;
;                       RESTORE_SHADOW_AFTER_POST                       ;
;-----------------------------------------------------------------------;
;  this routine restores shadow rams after POST is executed from RAM.   ;
;  input :                                                              ;
;       none                                                            ;
;  output:                                                              ;
;       none                                                            ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        extrn   e000_read_ram_write_rom:near
        extrn   f000_read_ram_write_rom:near
        extrn   copy_control_to_shadow:near
        public  restore_shadow_after_post
restore_shadow_after_post:
        mov     ax,cs
        cmp     ax,0f000h               ; POST from F000 ?
        jnz     rsap_00                 ; no
        test    cs:bios_scratch,02h     ; E000 shadow enabled ?
        jz      rsap_02                 ; yes..no need for E000
        call    e000_read_ram_write_rom ; make E000 write protected
rsap_02:
        call    f000_read_ram_write_rom ; make F000 write protected
        ret
rsap_00:
;  copy current POST code segment to F000 RAM..
        push    es
        push    ds
        push    0f000h
        pop     es
        xor     di,di                   ; ES:DI = destn
        push    cs
        pop     ds
        xor     si,si                   ; DS:SI = source
        xor     cx,cx                   ; 64kbytes copy
        call    copy_control_to_shadow  ; copy and xfer control to F000 shadow
        pop     ds
        pop     es
        ret
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
;                               FORM_E820_TABLE                         ;
;-----------------------------------------------------------------------;
;  this routine forms the information tables for INT-15 E820 function.  ;
;  input :                                                              ;
;       CS is writable                                                  ;
;       DS      0040h                                                   ;
;       ES      0000h                                                   ;
;       stack   available                                               ;
;  output:                                                              ;
;       table formed                                                    ;
;  register destroyed : NONE                                            ;
;  NOTE : 1. do not assume CS to be F000.                               ;
;-----------------------------------------------------------------------;
        extrn   read_cmos_word:near
        extrn   e820_info_table:byte
        extrn   get_cmos_item:near
form_e820_table proc    near
        push    es
        push    ds
        pushad
        pushf
        cli
;  this code will update the table in shadow ram value with the proper
;  extended memory size information for INT-15 Func E820H.
        call    get_memory_info
        jc      f_e820_exit             ; routine not implemented
        mov     ebp,esi
;  EBP = total memory memory size in bytes
;  ECX, EDX = memory region1 32-bit start address, size in bytes
;  EAX, EBX = memory region2 32-bit start address, size in bytes
;  DI   bit-0 = 0..memory region1 is a HOLE region
;               1..memory region1 is a non-cacheable region
;       bit-1 = 0..memory region2 is a HOLE region
;               1..memory region2 is a non-cacheable region
;       bit15-2....unused (set to 0)
        shr     di,1                    ; region1 is a hole ?
        jnc     f_e820_100              ; yes
        xor     ecx,ecx                 ; force hole1 does not exist
        xor     edx,edx
f_e820_100:
        shr     di,1                    ; region2 is a hole ?
        jnc     f_e820_101              ; yes
        xor     eax,eax                 ; force hole2 does not exist
        xor     ebx,ebx
f_e820_101:
        push    ax
        mov     ax,9596h                ; cmos reg 16h(H), 15h(L)
        call    read_cmos_word
        movzx   esi,ax
        pop     ax
        shl     esi,0ah                 ; base memory in bytes
        push    ds
        pop     es                      ; ES = 0040h..BIOS data segment
;  ES = BIOS data segment 0040h..
        push    cs
        pop     ds                      ; DS = CS
;  ESI = base memory size in bytes
;  EBP = total memory memory size in bytes
;  ECX, EDX = memory hole1 32-bit start address, size in bytes
;  EAX, EBX = memory hole2 32-bit start address, size in bytes
;  form the information the E820_INFO_TABLE..
;  the table is already initialzed with 00..
        mov     di,offset cgroup:e820_info_table
        push    eax
        push    bx
;  base memory information..
        test    es:sys_info,80h         ; EBDA allocated ?
        pushf
        jz      f_e820_00               ; no EBDA
        sub     esi,00000400h           ; base memory size reduced by 1K (size of EBDA)
f_e820_00:
        xor     eax,eax                 ; base memory 32-bit start addr
        mov     bl,ram_os
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
        popf
        jz      f_e820_01               ; no EBDA
;  extended BIOS data area (EBDA) information..
        mov     eax,esi                 ; EBDA 32-bit start address
        mov     esi,00000400h           ; EBDA size in bytes (1Kbytes)
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
f_e820_01:
        mov     al,Q_USB_FUNCTION_ENABLE
        call    get_cmos_item
        jz      check_usb_keyboard_done
        mov     al,Q_USB_LEGACY_ENABLE
        call    get_cmos_item
        jz      check_usb_keyboard_done
        mov     eax,000dc000h           ; system BIOS 32-bit start address
        mov     esi,00004000h           ; system BIOS size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
check_usb_keyboard_done:
;  system BIOS information..
        mov     eax,000f0000h           ; system BIOS 32-bit start address
        mov     esi,00010000h           ; system BIOS size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
;  extended memory information..
        mov     ax,0b5b6h
        call    read_cmos_word          ; AX = ext mem size in 64K chunks
        shl     eax,10h                 ; EAX = ext mem size in bytes
        mov     esi,eax                 ; ext mem size in bytes

;---------------------------------------;
if      MKF_ACPI_SUPPORT                ; ACPI SUPPORT
%out Modified code for E820, in NPOST.ASM
        test    cgroup:bios_scratch,acpi_aware_os_bit; ACPI OS ?
        pushf
        jz      short f_e820_07         ; no
        sub     esi,(64*1024)           ; Base address = TOM-64KB
f_e820_07:
        mov     eax,00100000h           ; ext memory 32-bit start address
        mov     bl,ram_os               ; indicate RAM available to OS
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
        popf                            ; ACPI OS ?
        pop     bx
        pop     eax
        jz      short f_e820_08         ; not ACPI OS
        push    eax
	push	bx			; (CORE0226+)
        push    esi
        mov     eax,ebp
        sub     eax,(64*1024)           ; Base address = TOM-64KB
        mov     esi,00008000h           ; 64KB in size
        mov     bl,ram_acpi_data
        call    fill_e820_info          ; fill info and update ptr and
        mov     eax,ebp                 ; Get Top of memory
        sub     eax,(32*1024)           ; Base address = TOM-64KB
        mov     esi,00008000h           ; 64KB in size
        mov     bl,ram_acpi_nvs
        call    fill_e820_info          ; fill info and update ptr and
        pop     esi
	pop	bx			; (CORE0226+)
        pop     eax
f_e820_08:

;;>>
        sub     ebp,(64*1024)           ; Base address = TOM-64KB
;;<<

else                                    ; NO ACPI SUPPORT

        mov     eax,00100000h           ; ext memory 32-bit start address
        mov     bl,ram_os               ; indicate RAM available to OS
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
        pop     bx
        pop     eax
endif
;---------------------------------------;
;  EBP = total memory memory size in bytes
;  ECX, EDX = memory hole1 32-bit start address, memory hole1 size in bytes
;  EAX, EBX = memory hole2 32-bit start address, memory hole2 size in bytes
;  make sure that ECX, EDX has the lower hole information..
        push    ebx
        or      ebx,edx
        pop     ebx
        jz      f_e820_02               ; all holes disabled
        cmp     ecx,eax
        jb      f_e820_03               ; hole1 at lower address than hole2
;  hole2 is at lower address than hole1..
        xchg    ecx,eax                 ; exchange start address info
        xchg    edx,ebx                 ; exchange size info
f_e820_03:
;  memory hole1 is at lower address now..
;  ECX, EDX = memory hole1 32-bit start address, memory hole1 size in bytes
;  EAX, EBX = memory hole2 32-bit start address, memory hole2 size in bytes
        or      edx,edx                 ; hole1 exists ?
        jnz     f_e820_02               ; no
        mov     ecx,eax                 ; put hole2 as hole1
        mov     edx,ebx
        xor     eax,eax                 ; make hole2 not exist
        xor     ebx,ebx
f_e820_02:
;  EBP = total memory memory size in bytes
;  ECX, EDX = 32-bit start address, size in bytes of the memory hole at lower address
;  EAX, EBX = 32-bit start address, size in bytes of the other memory hole
        jecxz   f_e820_04               ; no memory hole
;  fill hole1 data structure..
        push    eax
        push    bx
        mov     eax,ecx                 ; memory hole1 32-bit start address
        mov     esi,edx                 ; memory hole1 size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
        pop     bx
        pop     eax
        or      ebx,ebx                 ; hole2 present ?
        jz      f_e820_05               ; no
;  hole2 present, check whether hole1 is below 1MB..if yes, do not fill
;  above hole1 information..
        cmp     ecx,100000h             ; hole1 at below 1MB ?
        jb      f_e820_06               ; yes
;  fill abobe hole1 information..
        push    eax
        push    bx
        add     ecx,edx                 ; ecx = 32-bit start address above hole1
        mov     esi,eax                 ; hole2 32-bit start address
        mov     eax,ecx                 ; 32-bit start address above hole1
        sub     esi,ecx                 ; size = hole2 start - (hole1 start + hole1 size)
                                        ; ESI = above hole1 size in bytes
        mov     bl,ram_os               ; indicate RAM available to OS
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
        pop     bx
        pop     eax
f_e820_06:
;  fill hole2 information..
;  EAX = hole2 32-bit start address
        push    bx
        mov     esi,ebx                 ; hole2 size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
        pop     bx
        cmp     eax,100000h             ; hole2 at below 1MB ?
        jb      f_e820_04               ; yes
;  fill above hole2 information..
        add     eax,ebx                 ; EAX = 32-bit start address above hole2
;  EBP = total memory size in bytes..
        sub     ebp,eax                 ; size = (tot. memory onboard) - (above hole2 start)
        jz      f_e820_04               ; exit
;  EXA = 32-bit start address above hole2
        mov     esi,ebp                 ; above hole2 size in bytes
        mov     bl,ram_os               ; indicate RAM available to OS
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
        jmp     short f_e820_04         ; exit
f_e820_05:
        cmp     ecx,100000h             ; hole1 at below 1MB ?
        jb      f_e820_04               ; yes
;  fill above hole 1 data structure..
        add     ecx,edx
;  EBP = total memory size in bytes..
        sub     ebp,ecx                 ; size = total memory onboard - above hole start
        jz      f_e820_04
        mov     eax,ecx                 ; above hole start addresss
        mov     esi,ebp                 ; above hole size
        mov     bl,ram_os               ; indicate RAM available to OS
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
f_e820_04:
if (MKF_NCPU eq 2)
;  fill I/O APIC memory..
        mov     eax,0fec00000h          ; I/O APIC memory mapped 32-bit start address
        mov     esi,00001000h           ; I/O APIC memory mapped space size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
;  fill Local APIC memory..
        mov     eax,0fee00000h          ; Local APIC memory mapped 32-bit start address
        mov     esi,00001000h           ; Local APIC memory mapped space size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value
endif
;  Unknow Memory ??
        mov     eax,0ffef0000h          ; remapped system BIOS 32-bit start address
        mov     esi,00010000h           ; system BIOS size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value

;  fill system BIOS information below 4GB..
        mov     eax,0ffff0000h          ; remapped system BIOS 32-bit start address
        mov     esi,00010000h           ; system BIOS size in bytes
        mov     bl,ram_res              ; indicate reserved RAM
        call    fill_e820_info          ; fill info and update ptr and
                                        ; update max cont value

f_e820_exit:
        popf
        popad
        pop     ds
        pop     es
        ret
form_e820_table endp
;-----------------------------------------------------------------------;
;                               FILL_E820_INFO                          ;
;-----------------------------------------------------------------------;
;  input :                                                              ;
;       EAX     start address                                           ;
;       ESI     size in bytes                                           ;
;       BL      memory type                                             ;
;       DS:DI   ptr to entry                                            ;
;  output:                                                              ;
;       DS:DI   ptr to next entry                                       ;
;  NOTE: this routine also updates the max continuation value.          ;
;-----------------------------------------------------------------------;
        extrn   e820_max_cont_value:byte
fill_e820_info  proc    near
        mov     dword ptr [di],eax      ; start address
        mov     dword ptr [di+04h],esi  ; size
        mov     byte ptr  [di+08h],bl   ; memory type
        add     di,size e820_info_struc ; ptr to next entry
        inc     dword ptr e820_max_cont_value; update cont value
        ret
fill_e820_info  endp
;-----------------------------------------------------------------------;
;                       GET_MEMORY_INFO                                 ;
;-----------------------------------------------------------------------;
;  check point  : 8C                                                    ;
;  this routine is called while generating table for INT-15 E820 func.  ;
;  input :                                                              ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
;  output:                                                              ;
;       cy      routine not implemented                                 ;
;       nc      routine implemented                                     ;
;       ESI     total memory size in bytes                              ;
;               (example, for 8MB total memory, ESI = 8192*1024bytes)   ;
;       ECX,EDX memory region1 32-bit start address, size in bytes      ;
;       EAX,EBX memory region2 32-bit start address, size in bytes      ;
;       EDI     bit-0 = Memory region1 information                      ;
;                       0..memory region1 is a HOLE region              ;
;                       1..memory region1 is a non-cacheable region     ;
;               bit-1 = Memory region2 information                      ;
;                       0..memory region2 is a HOLE region              ;
;                       1..memory region2 is a non-cacheable region     ;
;               bit-2 = Reserved                                        ;
;               bit-3 = 0 -> rest of memory L1 write-through            ;
;                       1 -> rest of memory L1 write-back               ;
;               bit-31..4 = Reserved                                    ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; NOTE: 1. Set both start address and size to 0000 for a region which   ;
;       does not exist.                                                 ;
;       2. This routine should read the chipset registers to return the ;
;       parameters (this parameters MUST NOT BE READ FROM CMOS).        ;
;-----------------------------------------------------------------------;
        public  get_memory_info
        extrn   get_mem_info:near
get_memory_info:
        call    get_mem_info    ; get all except bit-3 of (EDI)
        jc      getout
        push    ax
        mov     al,q_internal_cache
        call    check_cmos_data
        and     ax,3            ; 00,01,10,11 = dis,WT,WB,Reserved
        jz      getout1
        shl     al,2            ; bit-3 = 0/1 = WT/WB
getout1:
        or      di,ax           ; (set DI and NC)
        pop     ax
getout:
        ret
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
if MKF_EVENT_LOG			; (CORE0218+)>
 	include	event.inc
endif ;MKF_EVENT_LOG			; <(CORE0218+)
        public  _NPOST_ENDS
_NPOST_ENDS     label   byte                    ; marks end of module
;---------------------------------------;
_text   ends
end
