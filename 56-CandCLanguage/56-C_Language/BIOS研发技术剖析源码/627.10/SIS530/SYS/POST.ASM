        page    ,132
        title   POST HOOKS
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
        include setupequ.ext
        include makeflag.equ
        include devnode.equ
        include rt.equ

;---------------------------------------;
        extrn   PCI_init_begin:byte                     
        extrn   PCI_init_end:byte
        extrn   PISAC_init_begin:byte
        extrn   PISAC_init_end:byte  
        extrn   PMU_init_begin:byte
        extrn   PMU_init_end:byte
        extrn   write_chip_byte_x:near 
        extrn   read_chip_byte_x:near
        extrn   write_pci_byte:near 
        extrn   read_pci_byte:near
        extrn   write_sio_byte:near 
        extrn   read_sio_byte:near 
        extrn   write_usb_byte:near
        extrn   write_pmu_byte:near
        extrn   check_100mhz_cpu_bus:near
        extrn   ReadCCR:near
        extrn   WriteCCR:near
        extrn   disable_l2_cache:near
;---------------------------------------;
        extrn   update_stnd_cmos_checksum:near
        extrn   update_extd_cmos_checksum:near
        extrn   cmos_data_in:near
        extrn   cmos_data_in_x:near
        extrn   cmos_data_out:near
        extrn   cmos_data_out_x:near
        extrn   check_cmos_data:near
        extrn   get_cmos_item:near
        extrn   check_cmos_8e:near
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _POST_STARTS
_POST_STARTS    label   byte            ; marks start of module
;-----------------------------------------------------------------------;
;               THE HOOKS ARE IN ORDER OF EXECUTION                     ;
;-----------------------------------------------------------------------;
;                       GET_SMI_SEG_SIZE                                ;
;-----------------------------------------------------------------------;
;  check point          : 07                                            ;
;  this routine is called from RM.ASM while filling CPU related info.   ;
;  this routine returns SMI code segment value and SMI code segment size;
;  for all CPUs supported by the motherboard.                           ;
;  input :                                                              ;
;       al      cpu vendor# for which SMI information is to be returned ;
;       ah      = 00 for bootstarp CPU                                  ;
;               <>00 for application CPU                                ;
;       cl      CPU number                                              ;
;       edx     CPU power-on reset id                                   ;
;       ebx     bit 15-0  = CPU function field                          ;
;               bit 31-16 = CPU extended function field                 ;
;       stack   available                                               ;
;  output:                                                              ;
;       ax      SMI code segment size                                   ;
;       ebx     SMI code segment                                        ;
;  register usage..can destroy any register except EBP,DS,ES,FS,GS      ;
;                                                                       ;
;  NOTE:                                                                ;
;       1. CPU Vendor number is as follows:                             ;
;               00 = Intel                                              ;
;               01 = Cyrix                                              ;
;               02 = AMD                                                ;
;               03 = IBM                                                ;
;               04 = TI                                                 ;
;               05 = UMC                                                ;
;               06-FF..RESERVED for future use                          ;
;       2. SMI code segment is defined as follows:                      ;
;               3000h means SMI code is at  3000:0                      ;
;               A000h means SMI code is at  A000:0                      ;
;               3800h means SMI code is at  3800:0                      ;
;               10000h means SMI code is at 10000:0 i.e. 1M:0           ;
;       3. SMI code segment size is defined as follows:                 ;
;               = 00 SMI Not supported                                  ;
;               <>00 SMI code segment size                              ;
;                       bit3-0  0000..disabled  (SMI not supported)     ;
;                               0001..4KBytes                           ;
;                               0010..8KBytes                           ;
;                               0011..16KBytes                          ;
;                               0100..32KBytes                          ;
;                               0101..64KBytes                          ;
;                               0110..128KBytes                         ;
;                               0111..256Kbytes                         ;
;                               1000..512KBytes                         ;
;                               1001..1MBytes                           ;
;                               1010..2MBytes                           ;
;                               1011..4MBytes                           ;
;                               1100..8MBytes                           ;
;                               1101..16MBytes                          ;
;                               1110..32MBytes                          ;
;                               1111..4Gbytes                           ;
;                       bit15-4 not used (should be returned as 0000)   ;
;                                                                       ;
;       4. this routine is invoked by CALL instruction.                 ;
;       5. the routine may have to read from CMOS registers to get SMI  ;
;          code segment and size in case these parameters are setup     ;
;          configurable.                                                ;
;       6. the CS can not be assumed as F000.                           ;
;-----------------------------------------------------------------------;
        public  get_smi_seg_size
get_smi_seg_size        proc    near
        mov     al, 05h                 ;64KB SMI Seg.
        mov     ebx, 0000A000h          ;SMI Seg. @ A000:0
        ret
get_smi_seg_size        endp
;-----------------------------------------------------------------------;
;                               CP_INIT                                 ;
;-----------------------------------------------------------------------;
; check_point           : 13                                            ;
; This routine is used to do chipset register initialisation, cache     ;
; sizing and testing.                                                   ;
; input :                                                               ;
;       DS      0000H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; output:                                                               ;
;       BL      bit-0 = 0 cache is bad                                  ;
;                       1 cache is good                                 ;
;               bit7-1= MUST BE returned as 0                           ;
; register usage -- can destroy any register except EBP,DS,ES,FS,GS     ;
; Note: 1. this routine MUST NOT DO the memory sizing because memory    ;
;       sizing is done in init code.                                    ;
;       2. this routine should do cache sizing and testing. Use the     ;
;       routines GO_TO_FLAT_MODE_STACK and COMEBACK_FROM_FLAT_MODE_STACK;
;       for going to and coming back from flat mode.                    ;
;       the L2 cache sizing/testing result can be overridden in         ;
;       OEM_L2_DETECT_CACHE routine in OEMPOST.ASM file.                ;
;       Another way is not to do the L2 cache sizing and testing here.  ;
;       Do the L2 cache sizing/testing OEM_L2_DETECT_CACHE routine in   ;
;       OEMPOST.ASM file according to the requirement. In that case, the;
;       deafult code in OEM_L2_DETECT_CACHE routine must do the L2 cache;
;       sizing and testing. And then the deafult code can be modified   ;
;       according to OEM requirement.                                   ;
;       3. this routine can be used to re-initisalise chipset parameters;
;       (which does not affect dram configuration) e.g. dram ws, cache  ;
;       ws, etc.                                                        ;
;       4. this routine MUST NOT TOUCH chipset registers which affects  ;
;       the dram configuration e.g. page mode, remapping, etc. these    ;
;       variables must be programmed in the init code and if setup      ;
;       changes any of this parameters, setup MUST reboot.              ;
;       5. This routine can be used to program the chipset register for ;
;       base memory size. Base memory size can be controlled by chipset ;
;       register bit or by setting non-cacheable region to ATBUS.       ;
;-----------------------------------------------------------------------;
        extrn   oem_detect_l2_cache:near
        extrn   open_apc_cmos:near
        extrn   close_apc_cmos:near
        public  cp_init
cp_init:

                                        ; (CORE0210+)>
ifdef MKF_CNVRAM
if MKF_CNVRAM
%out === CNVRAM activated ===
        extrn   check_cmos_8e:near
        call    check_cmos_8e           ; cmos good ?
        jz      cmos_is_good            ; yes..
        call    cnvram_to_cmos          ; copy cnvram to cmos if cnvram is good
cmos_is_good:
endif;  if MKF_CNVRAM
endif;  ifdef MKF_CNVRAM
                                        ; <(CORE0210+)

;; disable PME0# and PME1#
        mov     ah,04h
        call    read_apc_cmos
        and     al, not 18h             ; output mode for GPIO#5, GPIO#10
        or      al,22h                  ; set GPIO#5 and GPIO#10
        call    write_apc_cmos
        
        mov     ah,03h
        call    read_apc_cmos
        and     al, not 08h             ; GPIO#5
        call    write_apc_cmos
        
        mov     ah,07h
        call    read_apc_cmos
        and     al, not 80h             ; GPIO#10
        call    write_apc_cmos

        mov     al,Q_CACHE_TAG
        call    cmos_data_in
        shl     al,7
        mov     bl,al
        mov     ah,51h
        call    read_pci_byte
        and     al,not 80h
        or      al,bl
        call    write_pci_byte

;; single read disable for Cyrix CPU
        mov     ah,52h
        call    read_pci_byte
        push    ax
        call    get_processor_info
        pop     ax
        and     al,not 40h
        cmp     bl,1                    ; Cyrix CPU?
        jz      cyrix_cpu
        or      al,40h
cyrix_cpu:
        call    write_pci_byte
        

        call    check_cmos_8e                   ;CMOS checksum good ?
        jnz     ci_exit                         ;No, do not program SETUP

        test    bp, ins_key_err_bit             ;<INS> key pressed ?
        jnz     ci_exit                 ;Yes, do not program SETUP

        cli
        cld                             ;; Clear direction flag

        mov     bx,offset cgroup:PCI_init_begin
        mov     cx,offset cgroup:PCI_init_end
        sub     cx,bx
        shr     cx,1
cp_init_PCI:
        mov     ah,byte ptr cs:[bx]     ;; Get register index
        mov     al,byte ptr cs:[bx+1]   ;; Get register data
        call    write_pci_byte
        add     bx,02h                  ;; Point to next table entry
        loop    cp_init_PCI

        mov     bx,offset cgroup:PISAC_init_begin
        mov     cx,offset cgroup:PISAC_init_end
        sub     cx,bx
        shr     cx,1
cp_init_PIC:
        mov     ah,byte ptr cs:[bx]     ;; Get register index
        mov     al,byte ptr cs:[bx+1]   ;; Get register data
        call    write_sio_byte
        add     bx,02h                  ;; Point to next table entry
        loop    cp_init_PIC


        mov     eax,80000964h           ;; clear REQUEST before clear ENABLE
        mov     dx,0cf8h
        out     dx,eax
        jmp     short $+2
        mov     dl,0fch
        in      eax,dx
        jmp     short $+2
        jmp     short $+2
        out     dx,eax

        mov     bx,offset cgroup:PMU_init_begin
        mov     cx,offset cgroup:PMU_init_end
        sub     cx,bx
        shr     cx,1
cp_init_PMU:
        mov     ah,byte ptr cs:[bx]     ;; Get register index
        mov     al,byte ptr cs:[bx+1]   ;; Get register data
        call    write_pmu_byte
        add     bx,02h                  ;; Point to next table entry
        loop    cp_init_PMU

        mov     dx,MKF_PM_BASE_ADDRESS+30h; Clear SMI status
        in      al,dx                   ;
        jmp     short $+2
        jmp     short $+2
        out     dx,al                   ;
                                        ;
        mov     dx,MKF_PM_BASE_ADDRESS+31h; Clear SMI ENABLE
        mov     al,0h                   ;
        out     dx,al                   ;

;;default is c0 for checkit rtc alarm test
        mov     ax,0c0feh                
        call    cmos_data_out_x     ; write cmos reg 7eh
        inc     ax
        call    cmos_data_out_x     ; write cmos reg 7fh

        mov     al,Q_RESUME_BY_RTC
        call    get_cmos_item
        jz      check_rtc_power_on_done
        mov     bh,03h
        call    read_apc_cmos
        or      bl,04h
        call    write_apc_cmos
check_rtc_power_on_done:
        mov     bh,03h
        call    read_apc_cmos
        and     bl,not 30h
        mov     al,Q_RING_ON
        call    get_cmos_item
        shl     al,4
        or      bl,al
        call    write_apc_cmos
        mov     ah, 070h
        call    read_sio_byte
        or      al, 01000000b
        call    write_sio_byte
;------------------------------------------
        mov     bh,05h
        call    read_apc_cmos
        and     bl,not 20h
        mov     al,q_hotkey
        call    get_cmos_item
        jz      set_hot_key_apc_cmos
        or      bl,20h
set_hot_key_apc_cmos:
        call    write_apc_cmos

        mov     al,Q_GRAPHIC_WIN
        call    get_cmos_item
        shl     al,4
        mov     bl,al
        mov     ah,094h
        call    read_pci_byte
        and     al,10001111b
        or      al,bl
        call    write_pci_byte

        call    oem_detect_l2_cache

ci_exit:

        mov     al,0b3h
        call    cmos_data_in
        and     al,01h
        mov     bl,al
;  BL = L2 cache sizing status
        ret

set_rtc_cmos:
        call    get_cmos_item
        aam
        shl     ah,4
        or      ah,al
        mov     al,bh
        call    cmos_data_in_x
        and     al,bl
        or      ah,al
        mov     al,bh
        call    cmos_data_out_x
        ret

;; Input: BH = APC Register Index
;; Output:BL = Value
;; Destroy: AL, BL
        public  read_apc_cmos
read_apc_cmos:
        pushf
        call    open_apc_cmos
        mov     al,bh
        call    cmos_data_in_x
        mov     bl,al
        call    close_apc_cmos
        popf
        ret

;; Input: BH = APC Register Index
;;        BL = Value
;; Output: None
;; Destroy: AX
write_apc_cmos:
        pushf
        call    open_apc_cmos
        mov     ax,bx
        xchg    al,ah
        call    cmos_data_out_x
        call    close_apc_cmos
        popf
        ret

;-----------------------------------------------------------------------;
;                               DO_MEMORY_SIZE                          ;
;-----------------------------------------------------------------------;
; check_point           : 57                                            ;
; This routine can be used for any base/extended memory size adjustment ;
; for memory hole programming, etc. before setup is called.             ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
;       [0040H:0013H]           base memory in KB as found in memory test
;       [cmos reg 30h,31h]      extd memory in kb as found in memory test
;       [cmos reg 35h,36h]      extd memory in 64kb as found in memory test
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; NOTE : 1. Progarm chipset registers for memory hole only.             ;
;        2. Update cmos register 17h,18h,30h,31h,35h,36h properly.      ;
;        3. Update cmos checksum.                                       ;
;-----------------------------------------------------------------------;
        extrn   oem_do_memory_size:near
        public  do_memory_size
do_memory_size:
;  Do chipset specific generic stuff

        call    check_cmos_8e           ;CMOS checksum good ?
        jnz     skip_adjust_mem_cmos    ;No, Exit

; Adjust base memory
        mov     ah, ds:byte ptr [13h]
        mov     al, 95h                 ;Write CMOS 15h
        call    cmos_data_out_x
        mov     ah, ds:byte ptr [14h]
        mov     al, 96h                 ;Write CMOS 16h
        call    cmos_data_out_x

        mov     ax, 97B0h               ;Read cmos reg 30h
        call    cmos_data_in_x
        xchg    al, ah                  ;Write cmos reg 17h
        call    cmos_data_out_x
        mov     ax, 98B1h               ;Read cmos reg 31h
        call    cmos_data_in_x
        xchg    al, ah                  ;Write cmos reg 18h
        call    cmos_data_out_x

;; Recalculate the CMOS checksum
;       call    update_stnd_cmos_checksum
;       call    update_extd_cmos_checksum
        mov     ax,Q_CLEAR_NVRAM
        extrn   set_cmos_item_checksum:near
        call    set_cmos_item_checksum

skip_adjust_mem_cmos:
;  Do OEM specific stuff if any
        call    oem_do_memory_size              ; in OEMPOST.ASM

        ret

;-----------------------------------------------------------------------;
;                       PROGRAM_PARAMETERS_AFTER_SETUP                  ;
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
; NOTE: 1. program setup selected parameters including non-cacheable    ;
;       regions.                                                        ;
;       2. use check_cmos_data routine to get the value of any selected ;
;       parameters.                                                     ;
;       3. Leave all Shadow RAM regions as non-cacheable here. This is  ;
;       done in program_ws_shadow_cacheable.                            ;
;-----------------------------------------------------------------------;
        extrn   get_processor_info:near
        extrn   oem_program_parameters_after_setup:near
        public  program_parameters_after_setup
program_parameters_after_setup:

                                        ; (CORE0210+)>
ifdef MKF_CNVRAM
if MKF_CNVRAM
        extrn   cmos_to_cnvram:near
        call    cmos_to_cnvram
endif;  if MKF_CNVRAM
endif;  ifdef MKF_CNVRAM
                                        ; <(CORE0210+)

;  Do chipset specific generic stuff
;
; Program Setup Options
;
;       call    check_cmos_8e               ;CMOS checksum good ?
;       jnz     short ppas_skip_setup_prog  ;No, do not program Setup Options

;; Set USB controller enable/disable from CMOS SETUP
        mov     al,Q_USB_FUNCTION_ENABLE
        call    get_cmos_item
        jnz     usb_still_enable
        mov     ax,2f02h                ; Stop USB Host controller
        CALL_RT_FUNCTION
;; Disabled USB Command 
        mov     ax, 0400h
        call    write_usb_byte
;; Disabled USB Controller & PIRQ 
        mov     ax, 06280h
        call    write_sio_byte
usb_still_enable:
        call    oem_program_parameters_after_setup
ppas_skip_setup_prog:

        ret
;-----------------------------------------------------------------------;
;                       PROGRAM_WS_SHADOW_CACHEABLE                     ;
;-----------------------------------------------------------------------;
; check point           : A4                                            ;
; This routine is used to do any time dependent programming e.g. wait   ;
; state and to program the Shadow RAM caheability except system BIOS    ;
; F000 shadow ram cacheability (F000 shadow ram cacheability is done in ;
; COPY_RUNTIME_BIOS hook).                                              ;
; input :                                                               ;
;       SS      0030H                                                   ;
;       DS      0040H                                                   ;
;       ES      0000H                                                   ;
;       stack   available                                               ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
reg_struc               struc
        setup_Q         db      (?)
        reg_index       db      (?)
        mask_value      db      (?)     
        sis_dev_func_number dw  (?)
reg_struc               ends

        extrn   oem_program_ws:near
        extrn   program_ws_table_start:byte
        extrn   program_ws_table_end:byte
        public  program_ws_shadow_cacheable
program_ws_shadow_cacheable:
;  Do chipset specific generic stuf     
;       call    check_cmos_8e                   ;CMOS checksum good ?
;       jnz     short pwsc_skip_setup_prog      ;No, do not program Setup

        mov     si,offset cgroup:program_ws_table_start
pcow_00:
        mov     al,cgroup:(reg_struc ptr [si]).setup_Q
        call    get_cmos_item                   ;; al = value
        mov     bl,al                           ;; save in bl
        movzx   cx,cgroup:(reg_struc ptr [si]).mask_value
        mov     ah,cgroup:(reg_struc ptr [si]).reg_index
        mov     bh,cgroup:(reg_struc ptr [si]).mask_value
        mov     dx,cgroup:(reg_struc ptr [si]).sis_dev_func_number
        call    read_chip_byte_x                ;; al = current chip reg value
        bsf     cx,cx                           ;;get how many bit to shl
        not     bh
        and     al,bh                           ;; mask corresponding bit
        shl     bl,cl                           ;;get the cmos and adjust to or
        or      al,bl                           ;;set corresponding bit

        mov     dx,cgroup:(reg_struc ptr [si]).sis_dev_func_number
        call    write_chip_byte_x

skip_load_value:
        add     si, TYPE (reg_struc)    ;; next
        cmp     si, offset cgroup:program_ws_table_end
        jb      pcow_00
        

        mov     ah,81h                  ; A2's setting
        call    read_pci_byte
        and     al,not 0c0h
        or      al,80h
        call    write_pci_byte
        
        mov     ah,82h
        call    read_pci_byte
        or      al,0eh
        call    write_pci_byte
        
;; check if system memory > cacheable size (cache size * 2^7), then disable reg.81 bit 6
        call    get_total_memory_size
        shr     eax,10                  ; KB base
        mov     ebx,eax                 ; save total memory size in ebx
        mov     ah,51h
        call    read_pci_byte
        test    al,80h
        jz      disable_read_cycle
        and     al,30h                  ; keep cache size bits
        shr     al,4
        mov     cl,al
        mov     eax,100h
        shl     eax,cl

        shl     eax,7                   ; cache size * 2^7
        cmp     ebx,eax
        ja      disable_read_cycle
        

        mov     ah,81h                  ; A2's setting
        call    read_pci_byte
        or      al,40h
        call    write_pci_byte

disable_read_cycle:
;----------------------------------------------------------------------------;

;=======================================
; Reg56 modified by SETUP
;=======================================
;       mov     al, Q_MDLE_DELAY
;       call    get_cmos_item
;       shl     al, 04h                 ; shift to upper 4 bits
;       mov     bl, al                  ; get CMOS value save to BL
;        mov     ah, 056h
;        call    read_pci_byte
;       and     al, 00001111b           ; Keep other 4 bits!
;       or      al, bl                  ; Mask CMOS value with BL
;        call    write_pci_byte

;=======================================
; Reg80(bit7~bit5)  for  Mainmum burstable address
;=======================================
        mov     al,Q_MAX_BURSTABLE
        call    get_cmos_item
        mov     bl, al
        shl     bl, 5                   ; get CMOS value save to BL
        mov     ah, 080h
        call    read_pci_byte
        and     al, 00011111b           ; Keep other 5 bits!
        or      al, bl                  ; Mask CMOS value with BL
        call    write_pci_byte

        mov     ax, 08460h
        call    write_pci_byte
;       mov     al,Q_PCI_GRANT_TIMER1
;       call    get_cmos_item
        mov     ax, 08500h
        call    write_pci_byte
;=======================================
; Reg86 for CPU Idle Timer for PCI
;=======================================
;       mov     al,Q_IDLE_TIMER_PCI
;       call    get_cmos_item
        mov     ax, 08603h
        call    write_pci_byte

;; for VGA report memory in AEh, AFh
        call    get_total_memory_size
        shr     eax,20
        mov     bx,ax
        mov     ah,0aeh
        call    write_pci_byte
        mov     ah,0afh
        mov     al,bh
        call    write_pci_byte

;  Do OEM specific stuff if any
        call    oem_program_ws
pwsc_skip_setup_prog:
        ret
;-----------------------------------------------------------------------;
;                       SPECIAL_CONFIG_DISPLAY                          ;
;-----------------------------------------------------------------------;
; check point           : AA                                            ;
; this routine is called from system_configuration_display to display   ;
; any special configuration.                                            ;
; input :                                                               ;
;       ds      0040h                                                   ;
;       es      0000h                                                   ;
;       stack available                                                 ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
;-----------------------------------------------------------------------;
        extrn   oem_special_config_display:near
        extrn   ecc_disabled_msg:abs
        extrn   wait_input_char:near
        extrn   display_message_set:near
        public  special_config_display
special_config_display:
;  Do chipset specific generic stuff
;  Do OEM specific stuff if any
        call    oem_special_config_display
        ret
;-----------------------------------------------------------------------;
;                       GET_MEM_INFO                                    ;
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
;               bit-31..2 = Reserved                                    ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; NOTE: 1. Set both start address and size to 0000 for a region which   ;
;       does not exist.                                                 ;
;       2. This routine should read the chipset registers to return the ;
;       parameters (this parameters MUST NOT BE READ FROM CMOS).        ;
;-----------------------------------------------------------------------;
        public  get_mem_info
get_mem_info:
        call    get_total_memory_size
        mov     esi,eax
        xor     eax,eax
        xor     ebx,ebx
        xor     ecx,ecx
        xor     edx,edx
        xor     edi,edi
        ret
;;============================================
;;Input:none
;;outut:eax = physical address
;;============================================
        extrn   get_bank_size:near
        public  get_total_memory_size
get_total_memory_size:
        xor     ebx,ebx
        mov     cl,0

;;===get the total system memmory
get_mem_loop:
        xor     eax,eax
        mov     al,cl
        call    get_bank_size
        add     ebx,eax
        inc     cl
        cmp     cl,2
        jbe     short get_mem_loop
;;================================
;; for share memory
;; report memory = total- share
        mov     ah,63h
        call    read_pci_byte
        test    al,40h
        jz      short share_mem_disable
        and     ax,00110000b
        shr     al,04h
        mov     cl,al
        mov     al,01h
        shl     ax,cl
        sub     bx,ax
share_mem_disable:
;; for share memory

        mov     eax,ebx

        shl     eax,20
        ret

;-----------------------------------------------------------------------;
;                       GET_L2_CACHE_INFO                               ;
;-----------------------------------------------------------------------;
;  this routine is called from DMI POST INIT and system configuration   ;
;  display.                                                             ;
;  input :                                                              ;
;       none                                                            ;
;       stack   available                                               ;
;  output:                                                              ;
;       CY      routine not implemented                                 ;
;       NC      routine implemented                                     ;
;               AX  installed cache size (KB), 40h = 64KB, 200h = 512KB ;
;               CX  current cache information                           ;
;                   bit-15..10 = reserved (must be 0)                   ;
;                   bit-9..8 = cache mode                               ;
;                               00 -> write-through, 01 -> write-back   ;
;                               10 -> reserved,      11 -> unknown      ;
;                   bit-7 = current status                              ;
;                               0 -> disabled, 1 -> enabled             ;
;                   bit-6..5 = physical position relative to CPU        ;
;                               00 -> inside CPU, 01 -> outside CPU     ;
;                               10 -> reserved, 11 -> unknown           ;
;                       example: for (al)=2 in P54C, return bit-6..5=01 ;
;                               for (al)=2 in P6, return bit-6..5=00    ;
;                   bit-4 = reserved (must be 0)                        ;
;                   bit-3 = socket information                          ;
;                               0 = not socketed, 1 = socketed          ;
;                   bit-2..0 = cache level (1 to 8), 1 = L1, 2 = L2     ;
;               DX  current cache type (bit mapped)                     ;
;                   bit-15..7 = reserved (must be 0)                    ;
;                   bit-6 = 1 -> asynchronous                           ;
;                   bit-5 = 1 -> synchronous                            ;
;                   bit-4 = 1 -> pipeline burst                         ;
;                   bit-3 = 1 -> burst                                  ;
;                   bit-2 = 1 -> non-burst                              ;
;                   bit-1 = 1 -> unknown                                ;
;                   bit-0 = 1 -> reserved (must be 0)                   ;
;               BH  cache speed in nanosecs                             ;
;               BL  error correction type(See SMBIOS Specification)     ;
;               DI  bit-15..8 = System Cache Type(See SMBIOS Specification)
;                   bit-7..0 = Associativity (See SMBIOS Specification) ;
;  register usage : do not destroy any register except AX, BX, CX, DX, DI
; note: Do not get value from CMOS setup question, read chipset register;
;       to get current cache information.                               ;
;-----------------------------------------------------------------------;
        public  get_l2_cache_info
        public  get_external_cache_info
get_external_cache_info:
get_l2_cache_info:
        mov     ah,51h
        call    read_pci_byte
;; cx== outside CPU, not socketed, L2
        mov     cx,0022h
        test    al,80h          ;; test enable
        jz      L2_not_enable
        or      cx,0080h
L2_not_enable:
        test    al,08h          ;; test WB
        jz      L2_not_WB
        or      cx,0100h
L2_not_WB:
        and     al,00110000b    ;; get cache size
        shr     al,4h
        push    cx
        mov     cl,al
        mov     bx,0100h        ; 100h = 256k
        shl     bx,cl
        mov     ax,bx
        pop     cx

        mov     dx,0010h
        mov     bx,0503h
        mov     di,0103h
        clc
        ret

;-----------------------------------------------------------------------;
;                       DMI_MEM_MODULE_INFO                             ;
;-----------------------------------------------------------------------;
;  this routine is called from DMI POST INIT code to return information ;
;  about the concerned MEMORY MODULE.                                   ;
;  input :                                                              ;
;       AL      memory module# (1 based)                                ;
;       stack   available                                               ;
;  output:                                                              ;
;       CY      routine not implemented                                 ;
;       NC      routine implemented                                     ;
;               AL  memory bank connection                              ;
;                   bit-7..4 = lower RAS line                           ;
;                   bit-3..0 = upper RAS line                           ;
;                   example: if bank connected to RAS 2&3, return (al)=23h;
;               AH  memory module current speed in ns                   ;
;                   example: for 60ns memory return (ah)=3ch (60 decimal);
;               CX  current memory type (bit mapped)                    ;
;                   bit-15..9 = reserved (must be 0)                    ;
;                   bit-8 = 1 -> DIMM                                   ;
;                   bit-7 = 1 -> SIMM                                   ;
;                   bit-6 = 1 -> ECC                                    ;
;                   bit-5 = 1 -> Parity                                 ;
;                   bit-4 = 1 -> EDO                                    ;
;                   bit-3 = 1 -> fast page mode                         ;
;                   bit-2 = 1 -> standard                               ;
;                   bit-1 = 1 -> unknown                                ;
;                   bit-0 = 1 -> reserved (must be 0)                   ;
;               BL  installed memory size                               ;
;                   bit-7 = 1 -> double bank, 0 -> single bank          ;
;                   bit-6..0 = n where memory module size = 2^n MB      ;
;                   example: for 16MB memory module, bit-6..0 = 4       ;
;                       bit-6..0 = 7Dh -> size unknown                  ;
;                                = 7Eh -> reserved (do not use)         ;
;                                = 7Fh -> not installed                 ;
;  register usage : do not destroy any register except AX, BL, CX       ;
;-----------------------------------------------------------------------;
        public  dmi_mem_module_info
        public  get_mem_module_info
get_mem_module_info:
dmi_mem_module_info:
        push    dx

;; set no RAS connect   
        mov     bl,al                   ; save memory module #
        dec     al                      ; which bank in base 0
        jnz     not_bank_0
        mov     ax,0001h                ; Bank 0 connection
        jmp     @f
not_bank_0:
        test    al,1
        jz      not_bank_1
        mov     ax,0023h                ; Bank 1 connection
        jmp     @f
not_bank_1:
        mov     ax,00ffh                ; Bank 2 connection
@@:
        push    ax
        mov     al,bl                   ; restore memory module #

        mov     cl,al
        mov     bl,al                   ; make a memory module copy in bl
        dec     bl
        mov     dl,bl
;; for some transfer
        cmp     cl,3
        jnz     not_dimm_3
        inc     cl
not_dimm_3:
;; detect dimm is install memory
        mov     ah,63h
        call    read_pci_byte
        test    al,cl
        jz      dimm_empty
        mov     cx,0500h                ; SDRAM, DIMM

;; detect memory size in bank
        mov     al,bl
        call    get_bank_size
        mov     bl,-1
not_zero_yet:
        inc     bl
        shr     ax,1
        cmp     ax,0
        jnz     short not_zero_yet
        
;; detect single side memory or double side
        add     dl,60h
        mov     ah,dl
        call    read_pci_byte
        and     al,20h
        shl     al,2
        or      bl,al

        jmp     short check_memory_module_done
dimm_empty:
        mov     ax,000fh                ; speed unknown, no RAS connect
        mov     bl,7fh                  ; memory not install
        mov     cx,0002h                ; memory unknown
check_memory_module_done:

        pop     ax
        pop     dx

        clc
        ret
;-----------------------------------------------------------------------;
;                       GET_SMBIOS_STRUCTURES_INFO                      ;
;-----------------------------------------------------------------------;
        public  get_smbios_structures_info
get_smbios_structures_info:
        ret
;-----------------------------------------------------------------------;
;                       GET_BIOS_DETAILS                                ;
; this routine returns the BIOS information details.                    ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       ESI     offset:segment of BIOS Version string (not NULL terminated
;       EDI     offset:segment of BIOS Date string (not NULL terminated);
;       CX      BIOS Size in unit of 32k                                ;
;       EDX:EAX BIOS Characteristics                                    ;
;       BL      BIOS Characteristics Extension                          ;
;-----------------------------------------------------------------------;
        extrn   _bios_version:byte
        extrn   _bios_release_date:byte
        extrn   _bios_characteristics:byte
;       extrn   rom_size:byte           ; (CORE0072-) Not for 627
        public  get_bios_details
get_bios_details:
COMMENT ~
        push    offset cgroup:_bios_version
        push    cs
        pop     esi                     ; ESI = offset:segment of BIOS version string
        push    offset cgroup:_bios_release_date
        push    cs
        pop     edi                     ; EDI = offset:segment of BIOS date string
;       mov     cx,cgroup:word ptr rom_size
        mov     cx,2                    ; size in 64K Bytes
        shl     cx,1                    ; CX = BIOS Size in unit of 32k
        mov     eax,cgroup:dword ptr _bios_characteristics
        mov     edx,cgroup:dword ptr _bios_characteristics+4
        mov     bl,00h
~
        ret
;-----------------------------------------------------------------------;
;                       GET_CPU_CLOCK_DETAILS                           ;
; this routine returns the CPU Clock details.                           ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       AX      CPU internal clock in MHz                               ;
;       BX      external clock in MHz                                   ;
;-----------------------------------------------------------------------;
        extrn   cpu_freq:word
        public  get_cpu_clock_details
get_cpu_clock_details:
        mov     bx,66                   ; external clock in MHz
        call    check_100mhz_cpu_bus
        jnz     short @f
        mov     bl,100
@@:
        mov     ax,cgroup:cpu_freq      ; internal clock in MHz
        ret
;-----------------------------------------------------------------------;
;                       GET_BIOS_LANGUAGE_INFO                          ;
; this routine returns the currently selected language details.         ;
; input :                                                               ;
;       none                                                            ;
; output:                                                               ;
;       ES:DI   ptr to ASCIIZ string of currently selected language     ;
;  register usage : do not destroy any register except ES, DI           ;
;-----------------------------------------------------------------------;
        public  get_bios_language_info
%OUT    Modify this routine for Multi-Language Support
language_string db      'English',0
get_bios_language_info:
        push    cs
        pop     es
        mov     di,offset cgroup:language_string
        ret

; (CORE0210+)>
ifdef MKF_CNVRAM
if MKF_CNVRAM
        extrn   go_to_flat_mode_stack   :near
        extrn   comeback_from_flat_mode_stack:near
        extrn   rth_nvram_base          :dword
        extrn   rth_nvram_size          :word
        extrn   scratch_segment         :word
;-----------------------------------------------------------------------;
;                       CNVRAM_TO_CMOS                                  ;
;-----------------------------------------------------------------------;
; Input:                                                                ;
;       None                                                            ;
; Output:                                                               ;
;       CMOS get updated by cnvram                                      ;
;       CY      update failed                                           ;
;       NC      successful                                              ;
; Registers destroyed:                                                  ;
;       All except for EBP,DS,ES,FS,GS                                  ;
;-----------------------------------------------------------------------;
        extrn   read_whole_escd:near
cnvram_to_cmos:
        push    ds
        mov     di,cgroup:scratch_segment
        call    read_whole_escd         ; edi = 32-bit buffer start address
        mov     ds,cgroup:scratch_segment
        mov     si,cgroup:rth_nvram_size
        sub     si,90h                  ; DS:SI = pointed to header
        cmp     dword ptr ds:[si],'SOMC'; signature match ?
        jne     ctc_error               ; no.. error
        add     si,10h                  ; DS:SI = cnvram buffer start address

        mov     al,10h                  ; start from CMOS register #10h
ctc_loop:
        mov     ah,ds:[si]              ; get cmos in buffer
        call    cmos_data_out_x
        inc     si                      ; next in buffer
        inc     al                      ; next register#
        cmp     al,80h
        jb      ctc_loop


; clear error status for cmos
        and     bp,not (cmos_bat_err_bit+cmos_csum_err_bit+cmos_opt_err_bit)
        mov     ax,008eh
        call    cmos_data_out_x

        clc                             ; NC - ok
ctc_exit:
        pop     ds
        ret
ctc_error:
        stc                             ; CY - error
        jmp     short ctc_exit
endif;  if MKF_CNVRAM
endif;  ifdef MKF_CNVRAM
; <(CORE0210+)
;-----------------------------------------------------------------------;
;                       USB_BUS_MASTERING                               ;
;-----------------------------------------------------------------------;
; Input:                                                                ;
;       None                                                            ;
; Output:                                                               ;
;       EBX = Bus Mastering asddress                                    ;
; Register destroyed:                                                   ;
; Can destroy any registers except for ES, DS, EBP, FS, GS              ;
;-----------------------------------------------------------------------;
        public  usb_bus_mastering
usb_bus_mastering       proc    near
        push    es
        mov     dx,0dc00h
        mov     ax,0ffffh
next_segment:
        push    dx
        pop     es
        xor     di,di
        mov     cx,2000h
        repz    scasw
        jcxz    find_usb_segment
        sub     dh,04h
        cmp     dh,0c4h
        jz      usb_01
        jmp     short next_segment

find_usb_segment:
        xchg    dh,dl
        shr     dx,2
        sub     dl,030h
;; Make shadow segment readable 
        shr     dl,1
        mov     dh,0ah
        jc      short usb_00
        mov     dh,0a0h
usb_00:
        mov     ah,70h
        add     ah,dl
        call    read_pci_byte
        or      al,dh
        call    write_pci_byte

        xor     ebx,ebx
        mov     bx,es
        shl     ebx,4
usb_01:
        pop     es
        ret
usb_bus_mastering       endp
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
        public  _POST_ENDS
_POST_ENDS      label   byte                    ; marks end of module
;---------------------------------------;
_text   ends
        end
