        page    ,132
        title   RUNTIME HOOKS
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
;---------------------------------------;
        include mbiosmac.mac
        include mbiosequ.equ
        include cf.equ
        include rt.equ
        include setupequ.ext
        include makeflag.equ
;---------------------------------------;
        extrn   flush_internal_cache:near
        extrn   enable_internal_cache:near
        extrn   disable_internal_cache:near
        extrn   check_cmos_data:near
        extrn   get_cmos_item:near
        extrn   cmos_data_in:near
        extrn   cmos_data_in_x:near
        extrn   cmos_data_out:near
        extrn   cmos_data_out_x:near
	extrn	read_sio_byte:near
	extrn	write_sio_byte:near
	extrn	write_pci_byte:near
	extrn	go_to_flat_mode_stack:near
	extrn	comeback_from_flat_mode_stack:near
;---------------------------------------;

;---------------------------------------;
cgroup  group   _text
;_text   segment word    public  'CODE'
_text   segment para    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _RUNTIME_STARTS
_RUNTIME_STARTS label   byte            ; marks start of module

;-----------------------------------------------------------------------;
;                       DISABLE_L1_CACHE                                ;
;-----------------------------------------------------------------------;
;  this routine disables internal cache by cpu routine and chipset      ;
;  programming.                                                         ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : do not destroy any register                         ;
;-----------------------------------------------------------------------;
        public  disable_l1_cache
disable_l1_cache:
        call    disable_internal_cache  ; disable internal cache in CPU
;  write the code here to disable internal cache thorugh chipset, if needed.
;  if the chipset internal cache needs to be disabled before CPU internal
;  cache, then change the order.
        ret


;-----------------------------------------------------------------------;
;                       ENABLE_L1_CACHE_WT                              ;
;-----------------------------------------------------------------------;
;  this routine enables internal cache in write-through mode by cpu     ;
;  routine and chipset programming.                                     ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : do not destroy any register                         ;
;  NOTE: If L1 cache is Write-Back Only, then JMP to ENABLE_L1_CACHE_WB ;
;-----------------------------------------------------------------------;
        public  enable_l1_cache_wt
enable_l1_cache_wt:
        call    enable_internal_cache   ; enable internal cache in CPU
;  program chipset register to enable internal cache in write-thorugh mode
;  if needed. if the chipset internal cache needs to be enabled before
;  CPU internal cache, then change the order.
        ret


;-----------------------------------------------------------------------;
;                       ENABLE_L1_CACHE_WB                              ;
;-----------------------------------------------------------------------;
;  this routine enables internal cache in write-back mode by cpu        ;
;  routine and chipset programming.                                     ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : do not destroy any register                         ;
;  NOTE: If L1 cache is Write-Thru Only, then JMP to ENABLE_L1_CACHE_WT ;
;-----------------------------------------------------------------------;
        public  enable_l1_cache_wb
enable_l1_cache_wb:
        call    enable_internal_cache   ; enable internal cache in CPU
;  program chipset register to enable internal cache in write-back mode
;  if needed. if the chipset internal cache needs to be enabled before
;  CPU internal cache, then change the order.
        ret


;-----------------------------------------------------------------------;
;                       DISABLE_L2_CACHE                                ;
;-----------------------------------------------------------------------;
;  this routine disables external cache using chipset programming with  ;
;  proper flushing.                                                     ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       CX      0000..cache disabling not done                          ;
;               FFFF..cache disabling done                              ;
;  register usage : do not destroy any register except AX CX DX         ;
;                   remember to save 32-bit registers if used           ;
;-----------------------------------------------------------------------;
        public  disable_l2_cache
disable_l2_cache:
	xor	cx,cx			; cache disabling not done
        mov     ah,051h
        call    read_pci_byte
        test    al, 80h                 ; Check if cache is disabled.
        jz      short disable_already                   ; Cache already disabled.
        pushf
	call    flush_sis596_L2
        mov     ah,051h
        call    read_pci_byte
        and     al,01110111b		;something strange
        call    write_pci_byte
        popf
        mov     cx,-1
disable_already:
        ret


;-----------------------------------------------------------------------;
;                       ENABLE_L2_CACHE_WT                              ;
;-----------------------------------------------------------------------;
;  this routine enables external cache in write-through mode using      ;
;  chipset programming with proper flushing.                            ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       CX      0000..cache enabling not done                           ;
;               FFFF..cache enabling done                               ;
;  register usage : do not destroy any register except AX CX DX         ;
;                   remember to save 32-bit registers if used           ;
;  NOTE: If L2 cache is Write-Back Only, then JMP to ENABLE_L2_CACHE_WB.;
;  This routine will be called only if L2 cache is good.                ;
;-----------------------------------------------------------------------;
        public  enable_l2_cache_wt
enable_l2_cache_wt:
	xor	cx, cx
     	mov	ah, 051h
     	call    read_pci_byte           	;Read the register from 530.
	test	al, 10000000b			; not enabled
	jnz	short enable_wt
	test	al, 00001000b
	jz	wt_already
enable_wt:
     	or      al, 11000000b           	;L2 cache enable
	call    write_pci_byte
	call    flush_sis596_L2

        and     al, 10110111b
    	call    write_pci_byte
 	mov     cx, -1
wt_already:

        ret


;-----------------------------------------------------------------------;
;                       ENABLE_L2_CACHE_WB                              ;
;-----------------------------------------------------------------------;
;  this routine enables external cache in write-back mode using         ;
;  chipset programming with proper flushing.                            ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       CX      0000..cache enabling not done                           ;
;               FFFF..cache enabling done                               ;
;  register usage : do not destroy any register except AX CX DX         ;
;                   remember to save 32-bit registers if used           ;
;  NOTE: If L2 cache is Write-Thru Only, then JMP to ENABLE_L2_CACHE_WT ;
;  This routine will be called only if L2 cache is good.                ;
;-----------------------------------------------------------------------;
        public  enable_l2_cache_wb
enable_l2_cache_wb:
;        call    flush_sis596_L2
	xor	cx, cx					; not done yet

        mov     ah, 051h
        call    read_pci_byte           ;Read the register from 5591.
	test	al, 10000000b			; enable?
	jz	enable_wb	
	test	al, 00001000b
	jnz	wb_already
enable_wb:
        or      al, 11000000b           ;L2 cache enable, Write back mode
        call    write_pci_byte
        call    flush_sis596_L2
	or      al, 00001000b
        call    write_pci_byte
        mov     cx, -1
wb_already:

        ret


;-----------------------------------------------------------------------;
;                       FLUSH_ALL_CACHE                                 ;
;-----------------------------------------------------------------------;
;  this routine flushes all cache (internal and external). this routine ;
;  is called whenever something is written in shadow ram from core bios.;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : do not destroy any register                         ;
;  Note:                                                                ;
;  1. This routine should flush the external cache and internal cache.  ;
;     The order of flushing may depend on the chipset.                  ;
;  2. Call FLUSH_INTERNAL_CACHE to flush internal cache.                ;
;  3. If flat mode is needed for external cache flushing, use the routine
;  GO_TO_FLAT_MODE_STACK to go to flat mode, flush cache and use the    ;
;  routine COMEBACK_FROM_FLAT_MODE_STACK for coming back to normal mode.;
;  4. If external cache is disabled at this time, do not flush (it will ;
;  take time) externl cache.                                            ;
;  5. Write this routine in two parts for example,                      ;
;       a) for external cache flush, write FLUSH_EXTERNAL_CACHE routine,;
;       which can also be used from DISABLE_L2_CACHE which needs to     ;
;       b) flush external cache before disabling the external cache.    ;
;       for internal cache flush, use FLUSH_INTERNAL_CACHE routine.     ;
;-----------------------------------------------------------------------;
        public  flush_all_cache
flush_all_cache:

        call    flush_internal_cache            ; Call cpu routine to flush

        ret

flush_sis596_L2         proc    near
        pushf
        cli
        push    ds
        push    es
        pushad
 	
	mov	al,0b3h
	call	cmos_data_in
	test	al,01h
	jz	flush_external_cache_end

        mov     ah,051h
        call    read_pci_byte
	push	ax
        call    go_to_flat_mode_stack
	pop	cx

        and     cl,00110000b            ;; get cache size
        shr     cl,4                    ;; bit-2,1
	mov	esi,256*512
        shl     esi,cl                  ;; Get twice size of cache.
	mov	ecx,100000h		;; 1MB
        xchg    ecx,esi
        cld
	db	66h
        db	67h
        rep     lodsd

        call    comeback_from_flat_mode_stack

flush_external_cache_end:
        popad
        pop     es
        pop     ds
        popf
        ret
flush_sis596_L2         endp


;-----------------------------------------------------------------------;
;                               HIGH_SPEED                              ;
;-----------------------------------------------------------------------;
;  this routine changes to high speed using chipset programming.        ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       CX      0000..speed switching not done                          ;
;               FFFF..speed switching done                              ;
;  register usage : do not destroy any register except AX CX DX         ;
;                   remember to save 32-bit registers if used           ;
;-----------------------------------------------------------------------;
        public  high_speed
high_speed:
        xor     cx,cx                   ; speed switching not done
        ret


;-----------------------------------------------------------------------;
;                               LOW_SPEED                               ;
;-----------------------------------------------------------------------;
;  this routine changes to low speed using chipset programming.         ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       CX      0000..speed switching not done                          ;
;               FFFF..speed switching done                              ;
;  register usage : do not destroy any register except AX CX DX         ;
;                   remember to save 32-bit registers if used           ;
;-----------------------------------------------------------------------;
        public  low_speed
low_speed:
        xor     cx,cx                   ; speed switching not done
        ret


;-----------------------------------------------------------------------;
;                       ENABLE_FAST_GA20                                ;
;-----------------------------------------------------------------------;
;  this enables GateA20 line using fast Gate20 method. this routine is  ;
;  called only if Fast Gate A20 is enabled through BCP.                 ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       ZR      Gate20 enabled by this routine                          ;
;       NZ      Gate20 not enabled by this routine                      ;
; register usage : DO NOT destroy any register except AX, CX            ;
; NOTE: 1. if gateA20 is enabled by this routine, Core BIOS will        ;
;       not touch gateA20 anymore.                                      ;
;       2. if gateA20 is not enabled by this routine, Core BIOS         ;
;       will enable gateA20 thru' KBC.                                  ;
;-----------------------------------------------------------------------;
        public  enable_fast_ga20
enable_fast_ga20:
      or      sp,sp                   ; NZ = not done
      ret
;-------------------------------JD End-------------------------------
;        mov     al, 02h
;        out     92h, al
;        cmp     sp, sp                  ; (ZF) = 1
;        ret


;-----------------------------------------------------------------------;
;                       DISABLE_FAST_GA20                               ;
;-----------------------------------------------------------------------;
;  this disables GateA20 line using fast Gate20 method. this routine is ;
;  called only if Fast Gate A20 is enabled through BCP.                 ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       ZR      gate20 disabled by this routine                         ;
;       NZ      gate20 not disabled by this routine                     ;
; register usage : DO NOT destroy any register except AX, CX            ;
; NOTE: 1. if gateA20 is enabled by this routine, Core BIOS will        ;
;       not touch gateA20 anymore.                                      ;
;       2. if gateA20 is not enabled by this routine, Core BIOS         ;
;       will disable gateA20 thru' KBC.                                 ;
;-----------------------------------------------------------------------;
        public  disable_fast_ga20
disable_fast_ga20:
      or      sp,sp                   ; NZ = not done
      ret
;-------------------------------JD End-------------------------------
;        mov     al, 00h
;        out     92h, al
;        cmp     sp, sp                  ; (ZF) = 1
;        ret


;-----------------------------------------------------------------------;
;                       POWER_ON_INIT                                   ;
;-----------------------------------------------------------------------;
;  this routine is invoked just after bios gets control.                ;
;  NOTHING IS DEFINED (except EDX) ON ENTRY TO THIS ROUTINE.            ;
;  input :                                                              ;
;       edx     cpu id if hard reset                                    ;
;       ss      = cs                                                    ;
;       stack   not available                                           ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : can destroy any register except EDX, SS             ;
;  Note: This routine can be used to implement resume from 5V suspend,  ;
;        etc.                                                           ;
;-----------------------------------------------------------------------;
        public  power_on_init
        public  oem_power_on_init_end
        extrn   power_on_init_end:near
        extrn   oem_power_on_init:near
power_on_init:
        jmp     oem_power_on_init       ; do any OEM specific stuff
oem_power_on_init_end:
        jmp     power_on_init_end
;-----------------------------------------------------------------------;
;                       DISABLE_ALL_CACHE                               ;
;-----------------------------------------------------------------------;
; check_point           : 05                                            ;
; this routine must disable cache at this time, if system has external  ;
; cache. in case of soft reset, this routine should disable all PCI     ;
; cards or generate a hard reset.                                       ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : can destroy any register except  DS, ES, EBP         ;
; 1. this routine should disable both internal and external cache.      ;
; 2. in case of soft reset, this routine should generate hard reset. if ;
;    hard reset generation is NOT possible, the default code will start ;
;    BIOS fresh from ROM.                                               ;
;-----------------------------------------------------------------------;
        public  disable_all_cache
disable_all_cache:
;; if the external cache needs to be disabled first, use this code..
        call    disable_l2_cache        ; disable external cache
        call    disable_l1_cache        ; disable internal cache
        in      al,64h                  ; if sys_flag bit is set
        test    al,00000100b            ; then soft reset else power on
        jnz     dac_00                  ; soft reset, so generate hard reset
        ret
dac_00:
;  soft reset, so generate hard reset
;  following code disables all PCI cards and simulate hard reset. if
;  hard reset generation is possible (e.g. using CF9 port), generate hard
;  reset here............................................................
        jmp     generate_hard_reset_x   ; generate hard reset
;-----------------------------------------------------------------------;
;                       COPY_RUNTIME_BIOS                               ;
;-----------------------------------------------------------------------;
; check_point           : B1                                            ;
; This routine is called just before booting (issue of INT-19) after    ;
; displaying the system configurations.                                 ;
; Program system BIOS cacheability in this routine.                     ;
; input:                                                                ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP, DS, ES          ;
;-----------------------------------------------------------------------;
        public  copy_runtime_bios
copy_runtime_bios:

;; for power on by alarm
	mov	al,0feh
	call	cmos_data_in_x
	mov	ah,al
	mov	al,0ffh
	call	cmos_data_out_x

        sub     dx,dx

        ret

;-----------------------------------------------------------------------;
;                       GENERATE_HARD_RESET                             ;
;-----------------------------------------------------------------------;
; this routine is called from setup if system needs to reboot on exit   ;
; from setup. this routine is also called from INT-16 func FFh after    ;
; Flash programming to generate hard reset.                             ;
; so control will go back to caller only if hard reset generation is    ;
; not possible.                                                         ;
; input :                                                               ;
;       stack   available                                               ;
;       all other registers are undefined                               ;
; output:                                                               ;
;       none                                                            ;
; register usage : can destroy any register                             ;
; NOTE:                                                                 ;
; 1. this routine is invoked by CALL instruction.                       ;
; 2. CS should not be assumed as F000.                                  ;
; 3. this routine should disable internal cache                         ;
; (CALL DISABLE_L1_CACHE is already there).                             ;
; 4. if chipset also controls internal cache, chipset registers should  ;
; also be programmed to disable internal cache.                         ;
; 5. generate CPU hard reset.                                           ;
; 6. if CPU reset generation is NOT possible, just disable internal     ;
; cache and return.                                                     ;
;-----------------------------------------------------------------------;
        extrn   oem_disable_all_cache:near
	extrn	fixed_delay:near
	extrn	open_extend_cmos:near
	extrn	close_extend_cmos:near

memory_setup_qeustion	label byte
	db	q_cas_latency
	db	0

        public  generate_hard_reset
generate_hard_reset:

					; (CORE0210+)>
ifdef MKF_CNVRAM
if MKF_CNVRAM
	call	check_cmos_8e		; cmos good ?
	jnz	no_update		; no..
	call	cmos_to_cnvram
no_update:
endif;	if MKF_CNVRAM
endif;	ifdef MKF_CNVRAM
					; <(CORE0210+)

        call    disable_l1_cache        ; disable internal cache
generate_hard_reset_x:
        call    oem_disable_all_cache   ; OEM specific stuff

	mov	si,offset cgroup:memory_setup_qeustion
	sub	ax,ax
getmemorycmositem:
	db	2eh			; CS:
	lodsb
	or	al,al
	jz	memorysetupmirrordone
	call	get_cmos_item			
	shl	ah,1
	or	ah,al
	jmp	short getmemorycmositem

memorysetupmirrordone:
	mov	al,ah
	not	al
	shl	al,04h
	or	ah,al
	call	open_extend_cmos		;
	mov	al,80h				;
	call	cmos_data_out_x			;
	call	close_extend_cmos		;

;;=====================================================================;;
	mov	dx,3c4h
	mov	al,1
	out	dx,al
	jmp	short $+2
	inc	dx
	in	al,dx
	jmp	short $+2
	or	al,20h
	out	dx,al
	jmp	short $+2
	jmp	short $+2
;;=====================================================================;;
	mov	cx,4000h			; Delay
	call	fixed_delay

	mov	ah,63h
	call	read_sio_byte
	or	al,18h
	call	write_sio_byte

	jmp	$
;-----------------------------------------------------------------------;
;       PREPARE_CHIPSET_FOR_FLASH_PROGRAMMING           ; Moved from NRUNTIME.ASM
;-----------------------------------------------------------------------;
; This routine is called from extra INT-16 func E002h which prepares the;
; chipset for flash programming. This function is used by Flash program ;
; utility AMIFLASH.                                                     ;
; input :                                                               ;
;       none                                                            ;
;       stack   available                                               ;
; output:                                                               ;
;       none                                                            ;
; register usage : Do not destroy any register                          ;
; Note:                                                                 ;
; 1. Disable external cache and internal cache.                         ;
; 2. Disable power management.                                          ;
; 3. Disable all shadow rams.                                           ;
; 4. Enable E000 and F000 ROM and set BIOS size to 128K.                ;
;-----------------------------------------------------------------------;
        public  prepare_chipset_for_flash_programming
        extrn   e000_read_rom_write_x:near
        extrn   f000_read_rom_write_x:near
        extrn   oem_prepare_chipset_for_flash_programming:near
prepare_chipset_for_flash_programming:
        call    disable_l1_cache
        call    disable_l2_cache
        call    e000_read_rom_write_x
        call    f000_read_rom_write_x
        call    oem_prepare_chipset_for_flash_programming
        ret
COMMENT ~
;-----------------------------------------------------------------------;
;               DISABLE_POWER_MANAGEMENT                                ;
;-----------------------------------------------------------------------;
; This routine is called from extra INT-16 func E002h which prepares the;
; chipset for flash programming. This function is used by Flash program ;
; utility AMIFLASH.                                                     ;
; input :                                                               ;
;       none                                                            ;
;       stack   available                                               ;
; output:                                                               ;
;       none                                                            ;
; register usage : Do not destroy any register                          ;
; Note:                                                                 ;
; 1. This routine should disable ALL power managent timers, disable all ;
; system events & break events, disable generation of SMI for all       ;
; associated hardware events EXCEPT SMI generation for USB.             ;
; PLEASE NOTE that if USB Keyboard is enabled, USB SMI generation MUST  ;
; remain enabled, otherwise AMIFLASH utility will NOT get any keystrokes;
; from USB keyboard.                                                    ;
; 2. This routine should relocate the USB Bus Master data area from     ;
; EE00:0000 to some other shadow RAM in C or D segment. Currently since ;
; BIOS is 128K size, the USB Bus Master data area can be relocated to   ;
; DE00:0000 (note that this is not valid if BIOS size is more than 128K);
;-----------------------------------------------------------------------;
        public  disable_power_management
disable_power_management:
        pushad

if      MKF_USB_SUPPORT
;  USB support is present
        mov     ax,2f02h                ; Stop USB Host controller
        CALL_RT_FUNCTION

        mov     al,Q_USB_LEGACY_ENABLE
        extrn   check_cmos_data:near
        call    check_cmos_data
        jz      dpm_00                  ; USB Legacy disabled

;  WRITE CODE HERE to Enable both Read and Write to some other SHADOW RAM
;  area say (DE00:0000). This shadow RAM area will be used from nowon for
;  USB Bus Mastering....................................................


;  start USB Host at new Bust Master data area
;  EBX = 32-bit absolute address for new Bus Master data area
        mov     ebx,000DE000h           ; Bus Mastering address DE00:0000
        mov     cl,00h                  ; Enumerate, Beep
        mov     ax,2f01h                ; Start USB Host
        CALL_RT_FUNCTION

dpm_00:

;  WRITE CODE HERE TO DISABLE ALL SMI GENERATION except USB SMI


;  WRITE CODE HERE TO DISABLE ALL SYSTEM EVENTS and BREAK EVENTS



;---------------------------------------;
else
;---------------------------------------;
;  USB support is NOT present
;  WRITE CODE HERE TO DISABLE ALL SMI

;--------------- CHIPSET PORTING ---------------;

        call    get_pm_base_addr

        mov     si, offset cgroup:global_smi_disable_table
        mov     cx, (offset cgroup:global_smi_disable_table_end - offset cgroup:global_smi_disable_table) / 5

_01_dpm_prog_pmio_loop:
        push    cx                              ;Save Number of entries
        lods    word ptr cs:[si]                ;Get bits to set
        mov     bx, ax                          ;BX = bits to set
        lods    word ptr cs:[si]                ;Get bits to reset
        mov     cx, ax                          ;CX = bits to reset
        lods    byte ptr cs:[si]                ;Get reg#.
        push    dx                              ;Save PM Base Address
        movzx   ax, al
        add     dx, ax                          ;DX = I/O register
        in      ax, dx                          ;AX = data
        not     cx                              ;CX = AND mask
        and     ax, cx                          ;Clear bits
        or      ax, bx                          ;Set bits
        out     dx, ax                          ;Write data
        pop     dx                              ;Restore PM Base Address
        pop     cx                              ;Restore Number of entries
        loop    short _01_dpm_prog_pmio_loop    ;Process next entry

;------------- CHIPSET PORTING END -------------;
;---------------------------------------;
endif
        popad
        ret
~
;-----------------------------------------------------------------------;
;               SET_INT_40_FLAG                 ; Moved from NRUNTIME.ASM
;               CLEAR_INT_40_FLAG               ; Moved from NRUNTIME.ASM
;               SET_INT_13_FLAG                 ; Moved from NRUNTIME.ASM
;               CLEAR_INT_13_FLAG               ; Moved from NRUNTIME.ASM
;-----------------------------------------------------------------------;
        extrn   oem_set_int_40_flag:near
        public  set_int_40_flag
set_int_40_flag:
        call    oem_set_int_40_flag
        ret
;-----------------------------------------------------------------------;
        extrn   oem_clear_int_40_flag:near
        public  clear_int_40_flag
clear_int_40_flag:
        call    oem_clear_int_40_flag
        ret
;-----------------------------------------------------------------------;
        extrn   oem_set_int_13_flag:near
        public  set_int_13_flag
set_int_13_flag:
        call    oem_set_int_13_flag
        ret
;-----------------------------------------------------------------------;
        extrn   oem_clear_int_13_flag:near
        public  clear_int_13_flag
clear_int_13_flag:
        call    oem_clear_int_13_flag
        ret

;-----------------------------------------------------------------------;
;                       LPT SUPPORT ROUTINES    ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;                       GET_LPT_IRQ_INFO        ; Moved to OEMRUN.ASM
;                       SET_LPT_IRQ             ; Moved to OEMRUN.ASM
;                       GET_LPT_ECP_DMA_INFO    ; Moved to OEMRUN.ASM
;                       SET_LPT_ECP_DMA_CHANNEL ; Moved to OEMRUN.ASM
;-----------------------------------------------------------------------;
;-----------------------------------------------------------------------;
;                       CHECK_100MHZ_CPU_BUS                            ;
;-----------------------------------------------------------------------;
;       Input:  None                                                    ;
;                                                                       ;
;       Output: ZR      CPU BUS is 100 MHz                              ;
;               NZ      CPU BUS is 66 MHz                               ;
;                                                                       ;
;       Registers Destroyed: None                                       ;
; Note: This route available after check point 24			;
;-----------------------------------------------------------------------;
        extrn   cpu_freq:word
        public  check_100mhz_cpu_bus
check_100mhz_cpu_bus    proc    near
	or	sp,sp
	ret
        push	eax
	push	ecx
	push	edx
	mov 	ecx,02ah
.586p
	rdmsr
.486p
	shr	eax,22
	and	ax,0fh
	push	bx
	mov	bx,offset cgroup:core_clock_freq_table
	db	2eh
	xlat
	pop	bx
	mov	cx,cpu_freq
	xchg	ax,cx
	mov	dx,10
	mul	dx
	div	cx
	cmp	al,100
	pop	edx
	pop	ecx
        pop	eax
        ret
check_100mhz_cpu_bus    endp

core_clock_freq_table label byte
	db	20,30,40,50,25,35,45,55,60,70,80,00,65,75,00,20

;;============================================
;;Input:al = 0,1,2
;;outut:ax = ? M size
;;============================================
	extrn	read_pci_byte:near
	public	get_bank_size
get_bank_size:
	push    bx
	push	cx
	push	dx
	push	si
	xor	dx,dx

	movzx	cx,al

	mov	ah,63h
        call    read_pci_byte
	bt	ax,cx
	jnc	no_dram_installed

	mov	ah,60h
	add	ah,cl
        call    read_pci_byte
	mov	cl,al
	mov	ch,al			; CH for check DRAM side
        and     al,0fh			; it is DRAM Type

;;the bank is SDRAM
        mov     bx,offset cgroup:sdram_size_translate_table 
get_size:
        db      2eh			; CS:
    	xlat

	movzx	dx,al

	shl	dx,1

	test	ch,00100000b
	jz	no_dram_installed;jmp if single size
	shl	dx,1
no_dram_installed:
	mov	ax,dx		; output ax

	pop     si
	pop	dx
	pop	cx
	pop	bx
	ret

sdram_size_translate_table     label   byte
                db   4                   ; no dram
                db   16                  ; 9*9
                db   16                  ; 10*10
                db   32                  ; 11*11
                db   08                  ; 12*12
                db   32                  ; 12*8
                db   32                  ; 12*9
                db   64                  ; 12*10
                db   16                  ; 12*11
                db   64                 ; 10*9
                db   64                 ; 11*9
                db   128                ; 11*10
                db   8                  ; 11*10
sdram_size_translate_table_end label   byte
;*******************************************************************************
if (MKF_TREND_ANTI_VIRUS)
	extrn	read_pci_byte:near
	extrn	write_pci_byte:near
align 16
	db	'$CHWY'			; signature for ChipAway to disable shadow write
disable_e800_shadow	proc	far
	push	ax
	mov	ah,75h
	call	read_pci_byte
	and	al,NOT 20h
	call	write_pci_byte
	pop	ax
	retf
disable_e800_shadow	endp
endif;	if (MKF_TREND_ANTI_VIRUS)
;-----------------------------------------------------------------------;
;			GPNV SUPPORT FOR IO MAPPED NVRAM		;
; Following routines are needed for GPNV support for IO Mapped NVRAM i.e.
; when GPNV_FLASH switch is set to 0 in Make file.			;
; If GPNV is supported as Memory Mapped NVRAM e.g. in Flash Block, these;
; routines are not needed.						;
;-----------------------------------------------------------------------;
IF	MKF_GPNV_SUPPORT
IFE	MKF_GPNV_FLASH
;------------- GPNV supported through IO Mapped NVRAM ------------------;
;-----------------------------------------------------------------------;
; Fill the following variables for the concerned IO Mapped NVRAM.	;
; Note thet GPNV Size must be a multiple of paragraph.			;
;-----------------------------------------------------------------------;
	public	gpnv_io_base
	public	gpnv_io_size
gpnv_io_base	dw	0000h		; start offset of GPNV
gpnv_io_size	dw	0000h		; GPNV Size in Bytes, this size must be
					; a multiple of paragraph
;-----------------------------------------------------------------------;
;			READ_GPNV_BYTE					;
; this routine is called both in real mode and protected mode to read a	;
; byte from GPNV.							;
; input :								;
;	AX	offset of GPNV from where the byte to be read		;
;	stack	available						;
; output:								;
;	AL	read byte						;
; register destroyed : AL						;
; NOTE :								;
; This routine can be called in real and protected mode, so do not assume
; anything about the segment registers.					;
;-----------------------------------------------------------------------;
	public	read_gpnv_byte
read_gpnv_byte:
	ret
;-----------------------------------------------------------------------;
;			READ_GPNV_BYTE					;
; this routine is called both in real mode and protected mode to read a	;
; word from GPNV.							;
; input :								;
;	AX	offset of GPNV from where the word to be read		;
;	stack	available						;
; output:								;
;	AX	read word						;
;		AH,AL = high byte, low byte				;
; register destroyed : AX						;
; NOTE :								;
; This routine can be called in real and protected mode, so do not assume
; anything about the segment registers.					;
;-----------------------------------------------------------------------;
	public	read_gpnv_word
read_gpnv_word:
	ret
;-----------------------------------------------------------------------;
;			WRITE_GPNV_BYTE					;
; this routine is called both in real mode and protected mode to write a;
; byte into GPNV.							;
; input :								;
;	AX	offset of GPNV from where the word to be read		;
;	BL	data to be written					;
;	stack	available						;
; output:								;
;	none								;
; register destroyed : none						;
; NOTE :								;
; This routine can be called in real and protected mode, so do not assume
; anything about the segment registers.					;
;-----------------------------------------------------------------------;
	public	write_gpnv_byte
write_gpnv_byte:
	ret
;-----------------------------------------------------------------------;
;			WRITE_GPNV_WORD					;
; this routine is called both in real mode and protected mode to write a;
; byte into GPNV.							;
; input :								;
;	AX	offset of GPNV from where the word to be read		;
;	BX	data to be written					;
;		BH, BL = high byte, low byte				;
;	stack	available						;
; output:								;
;	none								;
; register destroyed : none						;
; NOTE :								;
; This routine can be called in real and protected mode, so do not assume
; anything about the segment registers.					;
;-----------------------------------------------------------------------;
	public	write_gpnv_word
write_gpnv_word:
	ret
;-----------------------------------------------------------------------;
ENDIF
ENDIF

; (CORE0210+)>
ifdef MKF_CNVRAM
if MKF_CNVRAM
	extrn	go_to_flat_mode_stack	:near
	extrn	comeback_from_flat_mode_stack:near
	extrn   rth_nvram_base		:dword
	extrn   rth_nvram_size		:word
	extrn   scratch_segment		:word
	extrn	flash_write_enable	:near
	extrn	flash_write_disable	:near
	extrn	flash_found_table	:byte
	extrn	rth_nvram_size		:word
	extrn	rth_nvram_base		:dword
	extrn	check_cmos_8e		:near
;-----------------------------------------------------------------------;
;			READ_WHOLE_ESCD					;
;-----------------------------------------------------------------------;
; Only works in 4GB method						;
; Input:								;
;	DI	segment of escd buffer					;
; Output:								;
;	EDI	32-bit address containing read escd data		;
; Registers destroyed:							;
;	None								;
;-----------------------------------------------------------------------;
	public	read_whole_escd
read_whole_escd:
	movzx	edi,di
	shl	edi,4			; edi = 32 bit buffer address
	push	ds
	push	es
	pushad
	call	go_to_flat_mode_stack
	mov	esi,cgroup:rth_nvram_base
	mov	cx,cgroup:rth_nvram_size
;	rep	movsb
rwe_loop:
	mov	al,byte ptr ds:[esi]
	out	0e0h,al
	mov	byte ptr es:[edi],al
	inc	esi
	inc	edi
	loop	rwe_loop
	call	comeback_from_flat_mode_stack
	popad
	pop	es
	pop	ds
	ret
;-----------------------------------------------------------------------;
;			CMOS_TO_CNVRAM					;
;-----------------------------------------------------------------------;
; Check if CNVRAM present, if it is absent then go update it.		;
; If CNVRAM is present ('CMOS' signature), check if it is same as	;
; buffer.  It gets updated if not same.					;
; Only works in 4GB method						;
; Input:								;
;	DI	segment of escd buffer					;
; Output:								;
;	EDI	32-bit address containing read escd data		;
; Registers destroyed:							;
;	All except for EBP,DS,ES,FS,GS					;
;-----------------------------------------------------------------------;
	public	cmos_to_cnvram
cmos_to_cnvram:
	push	ds
	push	es

	mov	di,cgroup:scratch_segment
	call	read_whole_escd		; edi = 32-bit buffer address

	call	go_to_flat_mode_stack	; flat mode
	mov	esi,edi
	add	si,cgroup:rth_nvram_size
	sub	si,90h			; 10h bytes header
	push	esi
	mov	bl,1			; bl=1, need to update
	mov	eax,'SOMC'		; eax = signature
	cmp	[esi],eax		; 'CMOS' ?
	jne	ctc_02		; not existed..
	mov	bl,0			; signature present, no need to update if cmos=cnvram
ctc_02:
	mov	dword ptr [esi],'SOMC'	; put signature 'CMOS'

	; Store CMOS value to buffer
	mov	ah,10h			; cmos register 10h
update_loop:
	mov	al,ah
	call	cmos_data_in_x
	cmp	al,[esi+10h]		; equal ?
	je	ctc_01			; yes..
	mov	bl,1			; not equal, bl=1 (need to update)
ctc_01:
	mov	[esi+10h],al		; put to buffer
	inc	ah			; next cmos register#
	inc	esi			; next buffer
	cmp	ah,80h			; total reached ?
	jb	update_loop		; not yet..

	or	bl,bl			; need to update ?
	pop	esi
	jz	ctc_exit		; no..
	push	esi

	; adjust escd checksum in buffer
	mov	esi,edi			; ds:esi = start address of nvram buffer
	mov	cx,cgroup:rth_nvram_size
	xor	bl, bl			; bl will accumulate checksum
	cld
do_cksum_loop:
	db	67h
	lodsb				; al = next byte from caller's buffer
	add	bl, al
	loop	do_cksum_loop
	neg	bl			; all sum must be zero
	pop	esi
	mov	[esi+4],bl		; value for adjusting checksum

	; write buffer to nvram
	mov	esi,edi
	mov	edi,cgroup:rth_nvram_base
	call	flash_write_enable	; make flash read write
	mov	cx,word ptr cgroup:rth_nvram_size
	mov	bx,cgroup:word ptr flash_found_table
	call	cs:word ptr [bx+2]	; erase
	jc	short flash_erasing_err ; Br. if erasing error
	call	cs:word ptr [bx+4]	; program es:[esi] to ds:[edi]
flash_erasing_err:
	call	flash_write_disable	; make flash read only

	call	comeback_from_flat_mode_stack; back to real mode

ctc_exit:
	pop	es
	pop	ds
	ret
endif;	if MKF_CNVRAM
endif;	ifdef MKF_CNVRAM
; <(CORE0210+)


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
;-----------------------------------------------------------------------;
        public  _RUNTIME_ENDS
_RUNTIME_ENDS   label   byte            ; marks end of module
;---------------------------------------;
_text   ends
        end
