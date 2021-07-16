        page    60,132
        title   UNCOMPRESSED BIOS START CODE
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
        include mbiosequ.equ            ; bios global constants
        include mbiosmac.mac            ; bios coding macro definition
        include bblkinit.equ
;---------------------------------------;
        public  u_bios_suru
        public  ptr_to_source_buffer

        extrn   u_power_on_init:near
        public  u_power_on_init_end

        extrn   u_cp_init:near
        public  u_cp_init_end

        extrn   rom_filename:byte
        extrn   boot_block_flag:byte
        extrn   refresh_low_value:byte
        extrn   bootblock_fdc_table:byte
        extrn   bootblock_fdc_table_end:byte
        extrn   bootblock_kbc_rtc_table:byte
        extrn   bootblock_kbc_rtc_table_end:byte
        extrn   go_to_flat_mode:near
        extrn   fixed_delay:near
        extrn   search_compressed_module:near
        extrn   ib_free:near
        extrn   cmos_data_in:near
        extrn   cmos_data_out:near
        extrn   restore_cpuid:near
        extrn   check_ctrl_home:near
        extrn   check_main_bios_checksum:near
        extrn   form_rom_image:near
        extrn   get_start_of_init_code:near
;---------------------------------------;
        extrn   int_0e:word
        extrn   diskette_parameter_table:word
        extrn   int_40:word
        extrn   init_8237_dma:near
        extrn   enable_internal_cache:near
        extrn   disable_internal_cache:near
        extrn   flash_program:near
        extrn   display_blink_halt:near
        extrn   display_on_port:near

        extrn   floppy_cntlr_err:byte
        extrn   file_abs_msg:byte
        extrn   flp_ins_msg:byte
        extrn   read_err_msg:byte
        extrn   flp_read_msg:byte
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
;---------------------------------------;
        public  _UB_STARTS
_UB_STARTS      label   byte            ; marks start of module
;---------------------------------------;
u_bios_suru:
        cli                             ; test under CLI mode
        cld                             ; ensure direction
        mov     ax,cs
        mov     ss,ax
        jmp     u_power_on_init
u_power_on_init_end:
;---------------------------------------;
;       ENABLE RTC, KBC if controlled by;
;        on-board I/O chipset..         ;
;---------------------------------------;
        mov     si,offset cgroup:bootblock_kbc_rtc_table
kbcrtc_00:
        cmp     si,offset cgroup:bootblock_kbc_rtc_table_end
        jae     kbcrtc_end
        lods    cs:word ptr [si]        ; AX = routine offset
        mov     sp,offset cgroup:kbcrtc_01
        jmp     ax                      ; do not destroy EDX, SI, SS, SP
        even
kbcrtc_01:
        dw      offset cgroup:kbcrtc_02
kbcrtc_02:
        jmp     short kbcrtc_00
kbcrtc_end:
;---------------------------------------;
;       Disable NMI and PARITY          ;
;---------------------------------------;
        mov     al,0ch
        out     61h,al                  ; disable parity
        check_point_ini 0d0h            ; ========== D0
        mov     ebp,edx                 ; store bit31-16 of EDX in bit31-16 of EBP
;---------------------------------------;
;       VERIFY CHECKSUM                 ;
;---------------------------------------;
        ret_sp  get_start_of_init_code  ; DS:DI = ptr to bios header+1
; DS:DI = ptr to start of init code
        mov     si,di                   ; start offset of init code
        mov     cx,di                   ; start offset of init code
        neg     cx                      ; CX = init code size in bytes
        shr     cx,3                    ; CX = init code size #of qwords
        xor     eax,eax                 ; result of checksum
checksum_1:
        add     eax,cs:[si]
        add     si,08h
        add     eax,cs:[si-4]
        loop    checksum_1
        jnz     $                       ; checksum bad, halt
        check_point_ini 0d1h            ; ========== D1
;---------------------------------------;
;       KEYBOARD CONTROLLER TEST        ;
;---------------------------------------;
        in      al,64h
        and     al,04h                  ; sys bit unchanged
        mov     ah,al                   ; save sys bit
        mov     al,0aah                 ; BAT command AA
        out     64h,al
kb_2:
        jcxz    $+2
        in      al,64h
        test    al,1
        jz      kb_2
        in      al,60h                  ; BAT result 55
        mov     al,60h
        out     64h,al                  ; command byte
kb_3:
        jcxz    $+2
        in      al,64h
        test    al,2
        jnz     kb_3
        mov     al,ah
        or      al,61h                  ; keyboard enable, mouse disable
        out     60h,al
kb_4:
        jcxz    $+2
        in      al,64h
        test    al,2
        jnz     kb_4
;---------------------------------------;
;       Check for Wake Up               ;
;---------------------------------------;
; (CORE0071)>
;       extrn   u_wake_up:near
        extern  u_wake_up(u_wake_up_end):near
; <(CORE0071)
        public  u_wake_up_end
        jmp     u_wake_up
u_wake_up_end:
;---------------------------------------;
;       Save CPU-ID in CMOS 35,36       ;
;  Verify the data written in CMOS      ;
;---------------------------------------;
        mov     edx,ebp
cmos_not_good_yet:
        mov     al,0b5h                 ; access cmos 35h and disable NMI
        out     70h,al
        io_delay
        mov     al,dl
        out     71h,al
        io_delay
        mov     al,0b5h
        out     70h,al
        io_delay
        in      al,71h
        io_delay
        cmp     al,dl
        jnz     cmos_not_good_yet
        mov     al,0b6h
        out     70h,al
        io_delay
        mov     al,dh
        out     71h,al
;---------------------------------------;
;       START MEMORY REFRESH            ;
;---------------------------------------;
;---------------------------------------;
;       CHIPSET REGISTER PROGRAMMING    ;
;---------------------------------------;
        jmp_si  go_to_flat_mode         ; DS=ES=0 (4GB limit), GateA20 enabled
        check_point_ini 0d3h            ; ======== D3
        jmp     u_cp_init               ; init all chipset register
u_cp_init_end:
        check_point_ini 0d4h            ; ======== D4
;---------------------------------------;
;       512 KB MEMORY TEST              ;
;---------------------------------------;
        xor     ax,ax
        mov     es,ax
        mov     bx,es:word ptr [472h]   ; save 40:72
        mov     eax,5aa5a55ah
        mov     edx,eax
memory_test:
        xor     edi,edi
        mov     ecx,4000h*8             ; 512kb memory = 64k*8 dword
        db      67h
        rep     stosd
        xor     edi,edi
        mov     ecx,4000h*8             ; 512kb memory = 64k*8 dword
        db      67h
        repz    scasd
        jnz     $
        xor     eax,edx
        jz      memory_test
        mov     es:word ptr [472h],bx   ; restore 40:72
;---------------------------------------;
;;;;    jmp_si  comeback_from_flat_mode ; DS=ES=0 with 64KB limit
;---------------------------------------;
;       COPY 8K CODE TO SEGMENT 0       ;
;---------------------------------------;
        check_point_ini 0d5h            ; ======== D5
        ret_sp  get_start_of_init_code  ; DS:DI = ptr to bios header+1
; DS:DI = ptr to start of init code
        xor     ax,ax
        mov     ds,ax
        mov     ss,ax
        mov     sp,di                   ; SS:SP = 0000:start of init code
                                        ; DS = ES = 0 with 4GB access
        mov     si,di                   ; start offset of init code
        mov     cx,di                   ; start offset of init code
        neg     cx                      ; CX = init code size in bytes
        shr     cx,2                    ; CX = init code size #of dwords
        rep     movs es:dword ptr [di],cs:dword ptr [si]
        push    es
        push    offset cgroup:s0_00
        retf                            ; goto 0000:same address
s0_00:
        check_point_ini 0d6h            ; ======== D6
        call    check_ctrl_home         ; execute this routine from segment 0
        pushf
        call    form_rom_image          ; ESI = start address of buffer
                                        ;  CX = ROM size in 64k unit
        popf
        jz      cmb_03                  ; <CTRL><HOME> pressed, goto flash programming
        call    check_main_bios_checksum; verify BIOS checksum
        jnz     cmb_03                  ; checksum bad, goto flash programming
;---------------------------------------;
;       TRANSFER CONTROL TO MAIN BIOS   ;
;---------------------------------------;
        check_point_ini 0d7h            ; ======== D7
;  simulate hard reset by programming keyboard controller..
        mov     al,60h
        out     64h,al                  ; keyboard command byte
        call    ib_free
        mov     al,30h                  ; hard reset, disable kb, mouse
        out     60h,al
        call    ib_free
        in      al,60h                  ; consume data if any
;---------------------------------------;
        mov     bl,bblk_runtime_interface_module_id
        call    search_compressed_module
        jnz     $                       ; module not found
;  AX:BX = seg:off of start of uncompressed module
;  DI    = module size in bytes
        mov     cx,di
        mov     ds,ax
        mov     si,bx
        push    ram_segment-2000h
        pop     es
        xor     di,di
        push    es
        push    di
        rep     movsb
        call    restore_cpuid           ; restore EDX
;  EDX = CPUID at power-on
        retf                            ; goto 1000:0000 to uncompress runtime
                                        ; and to give control to runtime
;---------------------------------------;
;       MAIN BIOS CHECKSUM BAD or       ;
;        <CTRL><HOME> pressed..         ;
;       go to flash programming..       ;
;---------------------------------------;
cmb_03:
        push    es
;  initialize the IO chipset (if any) for Floppy
        mov     si,offset cgroup:bootblock_fdc_table
fdc_00:
        cmp     si,offset cgroup:bootblock_fdc_table_end
        jae     fdc_end
        lods    cs:word ptr [si]        ; AX = routine offset
        call    ax                      ; do not destroy SI
        jmp     short fdc_00
fdc_end:
        pop     es                      ; ES = 0000 with 4GB access
        push    0040h
        pop     ds                      ; DS = 0040h
;;;;    jmp     r_memory_0              ; goto flash programming
;---------------------------------------;
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
;---------------------------------------;
;       SETUP INTERRUPT VECTORS         ;
;---------------------------------------;
;;;;r_memory_0:
        check_point_ini 0e0h            ; ========== E0
        mov     ds:word ptr [13h],200h  ; base memory size
        xor     ax,ax
        mov     ds:word ptr [72h],ax    ; clear CTRL-ALT-DEL
        mov     es:word ptr [0eh*4],offset cgroup:int_0e
        mov     es:word ptr [0eh*4+2],ax
        mov     es:word ptr [1eh*4],offset cgroup:diskette_parameter_table
        mov     es:word ptr [1eh*4+2],ax
        mov     es:word ptr [13h*4],offset cgroup:int_40
        mov     es:word ptr [13h*4+2],ax
;---------------------------------------;
;       INITIALISE DMA CONTROLLER       ;
;---------------------------------------;
        out     dma_1_byte_ptr_ff_reset,al; data not important (#1)
        io_delay
        out     dma_2_byte_ptr_ff_reset,al; data not important (#2)
        mov     al,00000000b
        io_delay
        out     dma_unit_1_command_port,al; enable DMA unit (#1)
        io_delay
        out     dma_unit_2_command_port,al; enable DMA unit (#2)
        call    init_8237_dma           ; initialize DMA unit #1, #2
        mov     al,00000000b
        out     dma_unit_2_writ_req_reg,al; clear write request reg
        io_delay
        out     dma_unit_2_mask_s_r_reg,al; clear mask set/reset reg
;---------------------------------------;
;       8259 INTERRUPT CNTLR TEST       ;
;---------------------------------------;
intr_0:
        mov     al,00010001b            ; icw1, edge, icw4
        out     i_c_s_port,al           ; int cntlr slave port
        io_delay
        out     i_c_m_port,al           ; int cntlr master port
        io_delay
        mov     al,level_1_int          ; start vector for intr #2
        out     i_s_m_port,al
        io_delay
        mov     al,level_2_int          ; start vector for intr #1
        out     i_m_m_port,al
        io_delay
        mov     al,02                   ; setup icw3, slave, level 2
        out     i_s_m_port,al
        io_delay
        mov     al,04                   ; setup icw3, master, level 2
        out     i_m_m_port,al
        io_delay
        mov     al,01                   ; setup icw4, 8086 mode,slave
        out     i_s_m_port,al
        io_delay
        out     i_m_m_port,al           ; setup icw4 for master
        io_delay
        mov     al,11111111b            ; (#2) mask value
        out     i_s_m_port,al
        io_delay
        mov     al,10111111b            ; (#1) mask value
        out     i_m_m_port,al
;---------------------------------------;
;       ENABLE INTERNAL CACHE           ;
;---------------------------------------;
        call    enable_internal_cache
;;;;    jmp     int_19
;-----------------------------------------------------------------------;
;                               INT19                                   ;
;  this routine replaces the normal INT19 used for booting OS. it does  ;
;  the following:                                                       ;
;  * checks for diskette (must be in DOS format) to be inserted in the  ;
;    floppy drive A:.                                                   ;
;  * search for the presence of a pre-defined file (say, BIOS.ROM) in   ;
;    the diskette.                                                      ;
;  * if not found, informs the user and starts afresh.                  ;
;  * reads BIOS.ROM file from the diskette into RAM.                    ;
;  * in case of any error during reading, it informs the user and starts;
;    afresh.                                                            ;
;  * program the flash.                                                 ;
;-----------------------------------------------------------------------;
ptr_to_source_buffer    equ     100000h ; 1m:0 has the full BIOS file data
read_file_segment       equ     2000h   ; segment where BIOS file is being read
sec_1_buffer            equ     0500h   ; offset where 1st sector is being read
dir_cluster_buffer      equ     0600h   ; offset where dir sector is being read
                                        ; and where cluster#s of the file is being stored
drive_number            equ     0000h   ; 00 for A:, 01 for B:
no_of_bytes_dir_entry   equ     0020h   ; 32 bytes per director entry
end_of_cluster          equ     0ffffh  ; end of cluster indicator
;---------------------------------------;
;;;;int_19:
        check_point_ini 0edh            ; ======== ED
;  F000 segment is free and can be programmed freely..
;---------------------------------------;
;       FLOPPY UNIT INITIALISATION      ;
;---------------------------------------;
        sti
        extrn   floppy_diskette_setup:near
        call    floppy_diskette_setup   ; floppy cntlr & data setup
        jnc     dse_00                  ; ok
                                        ; (CORE0211+)>
        public  dummy_ret
        extern  atapi_setup(dummy_ret):near
        call    atapi_setup             ; ATAPI controller/device setup
        jnc     short dse_00            ; ok
                                        ; <(CORE0211+)
        mov     si,offset cgroup:floppy_cntlr_err
        jmp     display_blink_halt      ; display and halt
dse_00:
;---------------------------------------;
;  set DS, ES for reading the 1st sector of the diskette..
        xor     ax,ax
        mov     ds,ax
        mov     es,ax
;  ask user to insert the diskette in drive A:..
        check_point_ini 0eeh            ; ======== EE
i19_02_00:
        mov     si,offset cgroup:flp_ins_msg; inform user to insert diskette
i19_02:
        call    display_on_port         ; in drive A:
        mov     cx,8000h
        call    fixed_delay
i19_00:
;  reset diskette system..
        mov     ah,00h                  ; reset func#
        mov     dl,drive_number         ; drive A:
        int     13h                     ; reset
;  read sector 1, hd 0, cyl 0..
        mov     bx,sec_1_buffer         ; ES:BX ptr to buffer
        mov     si,bx                   ; ES:BX = ES:SI
        mov     cx,0001h                ; CH = cyl#, CL = sec#
        mov     dh,00h                  ; DH = hd#, DL = drv#
        mov     ax,0201h                ; read 1 sector
        int     13h
        jnc     i19_01                  ; ok..
        cmp     ah,80h                  ; drive not ready ?
        jz      i19_02_00               ; yes..so try again..
        cmp     ah,06h                  ; media change ?
        jz      i19_00                  ; yes..so try again..
        pusha
        check_point_ini 0efh            ; ======== EF
        popa
i19_03:
;  read error..
        mov     si,offset cgroup:read_err_msg; read error
        jmp     short i19_02            ; display error and retry..
i19_01:
;  ES:BX = ES:SI = DS:BX = DS:SI..ptr to content of sec 1, hd 0, cyl 0 of diskette in drive A:..
        pusha
        mov     si,offset cgroup:flp_read_msg; indicate floppy reading going on
        call    display_on_port
        popa
;  find absolute start sector# of root directory..
        mov     al,[si+10h]             ; AL = #of FATs
        mov     ah,00h                  ; AX = #of FATs
        mul     word ptr [si+16h]       ; multiply by #of sectors per FAT
                                        ; AX = #of sectors occupied by FATs
                                        ; !!!! DX destroyed by MUL instruction
        add     ax,[si+1ch]             ; add #of hidden sectors
        add     ax,[si+0eh]             ; add #of reserved sectors
;  AX = absolute start sector# of root directory..
        mov     bp,ax                   ; BP = abs start sector# of root directory
        mov     ax,no_of_bytes_dir_entry; 32 bytes per director entry
        mul     word ptr [si+11h]       ; multiply by #of entries in directory
                                        ; DX:AX = #of bytes in root directory
        div     word ptr [si+0bh]       ; divide by #of bytes per sector
        or      dx,dx
        jz      i19_04
        inc     ax
i19_04:
;  AX = #of sectors occupied by root directory..
;  BP = abs start sector# of root directory..
        mov     cx,ax                   ; CX = #of sectors in root directory
        add     ax,bp                   ; AX = start absolute sector# of data area
        mov     [si],ax                 ; save start absolute sector# of data area
        mov     ax,[si+0bh]             ; #of bytes per sector
        mov     bl,no_of_bytes_dir_entry; 32 bytes per directory entry
        div     bl                      ; AL = #of entries in one dir sector
        mov     ah,00h
        mov     di,ax                   ; DI = #of entries in one dir sector
i19_05:
        pusha
        check_point_ini 0f0h            ; ======== F0
        popa
        mov     ax,bp                   ; absolute sector# of next root dir sector
        push    cx
        push    di
        mov     si,sec_1_buffer         ; DS:SI ptr to floppy BPB informn
        call    find_sector_head_cyl    ; calculate cyl#, head#, sector#
        mov     bx,dir_cluster_buffer   ; ES:BX ptr to buffer
        mov     ax,0201h                ; read 1 sector
        int     13h
        jc      i19_03                  ; error..
i19_06:
;  search for the pre-defined file name..
        push    di
        mov     di,bx                   ; ES:DI ptr to dir entry
        mov     si,offset cgroup:rom_filename; DS:SI ptr to pre-defined ROM filename
        mov     cx,000bh                ; 11 bytes in filename
        repz    cmps cs:byte ptr [si],es:byte ptr [di]; match filename in directory
        pop     di
        jz      i19_07                  ; filename found..
        add     bx,no_of_bytes_dir_entry; ptr to next dir entry
        dec     di
        jnz     i19_06                  ; continue searching in this dir sector
        pop     di                      ; DI = #of entries in one dir sector
        pop     cx
        inc     bp                      ; abs sector# of next dir sector
        loop    i19_05                  ; goto search in next dir sector
        pusha
        check_point_ini 0f1h            ; ======== F1
        popa
;  file not found..
        mov     si,offset cgroup:file_abs_msg
        jmp     i19_02
i19_07:
        pop     di
        pop     cx
;  file found in root dirctory..ES:BX  ptr to concerned dir entry..
;  store the cluster#s of the file serially in the dir_cluster_buffer..
        mov     di,dir_cluster_buffer
        mov     ax,es:[bx+1ah]          ; start cluster# of the file from the
                                        ; concerned directory entry
        mov     [di],ax                 ; save the start cluster number
;  read the FAT sectors one by one at scratch segment..
        mov     si,sec_1_buffer
        mov     bp,[si+16h]             ; BP = #of sectors in a FAT
        push    ds
        mov     bx,0040h
        mov     ds,bx                   ; DS = 0040h
        mov     bx,ds:[0013h]           ; #of 1Ks memory below 1M
        pop     ds
        shr     bx,06h                  ; #of 64Ks memory below 1M
        dec     bx
        shl     bx,0ch                  ; BX = last segment below 640K
        mov     es,bx                   ; ES = segment where fat sectors is
                                        ; going to be read
        pusha
        check_point_ini 0f2h            ; ======== F2
        popa
        xor     bx,bx                   ; fat_segment:0 will have the FAT sectors
        mov     dx,00h*256+drive_number ; DH,DL = head# of 1st sect, drive#
        mov     cx,0001h                ; CH,CL = cyl#, sec# of 1st sector
i19_08:
        call    find_next_sector_hd_cyl ; find sec#, hd#, cyl# of next sector
;  read next FAT sector..
;  DH,DL = head# of next FAT sector, drive#..
;  CH,CL = cyl#, sector# of next FAT sector..
        mov     ax,0201h                ; read one FAT sector at a time
        int     13h
        jc      i19_03_00               ; read error..
        add     bx,[si+0bh]             ; update ptr to buffer
        dec     bp
        jnz     i19_08                  ; read all FAT sectors
;  all FAT sectors are read at ES:0000..
;  DS:SI  ptr to BPB information..
;  DS:DI  ptr to cluster# storage area..
        mov     ax,[di]                 ; get start cluster# of the file
        inc     di
        inc     di
        call    find_store_cluster_nos  ; find and store the cluster#s
;  all cluster#s (WORD) of the file are stored serially
;       at DS:dir_cluster_buffer..
;  DS:SI  ptr to BPB information..
;  read the file cluster by cluster..
        mov     di,dir_cluster_buffer
        xchg    si,di
;  DS:SI  ptr to cluster# storage area..
;  DS:DI  ptr to BPB information..
        mov     dword ptr [di+80h],ptr_to_source_buffer; init ptr to source buffer
        mov     bp,[di+0dh]
        and     bp,00ffh                ; BP = #of sectors per cluster
        pusha
        check_point_ini 0f3h            ; ======== F3
        popa
i19_10:
        lodsw                           ; get next cluster#
        cmp     ax,0ffffh               ; end of file ?
        jz      i19_09                  ; yes..
        push    read_file_segment       ; segment:0 where next cluster will be read
        pop     es
        xor     bx,bx
        push    bx
        call    read_1_cluster
        pop     bx
        jc      i19_03_00               ; read error
;  copy the read data to the source buffer
;  ES:BX = ptr to read data, BP = #of sectors read
;  DS:DI = ptr to BPB information
        pushad
        mov     ax,[di+0bh]             ; #of bytes per sector
        mul     bp
        push    dx
        push    ax
        pop     ecx                     ; ECX = #of bytes read
        push    di
        mov     edi,dword ptr ds:[di+80h]; EDI = ptr to source buffer
        movzx   esi,bx
        push    es
        push    ds
        push    es
        pop     ds                      ; DS:ESI = ptr to read data
        push    0000h
        pop     es                      ; ES = 0000 with 4GB access
                                        ; ES:EDI = ptr to final source buffer
        rep     movs es:byte ptr [edi],ds:byte ptr [esi]
        pop     ds
        pop     es
        pop     si                      ; DS:SI = ptr to BPB information
        mov     dword ptr ds:[si+80h],edi; update ptr to source buffer
        popad
        jmp     short i19_10            ; continue..
i19_03_00:
        jmp     i19_03                  ; read error..
i19_09:
        mov     ecx,ds:dword ptr [di+80h]; ptr to end of file+1
        sub     ecx,ptr_to_source_buffer; ECX = file size in bytes
        shr     ecx,15                  ; ECX = file size in unit of 32k
;  BIOS ROM file is read from floppy diskette and is stored
;       in 1m:0000 onwards depending on size of the file
;  all the scratch data area which has been used for reading the diskette is
;       NOT needed anymore and can NOW be re-used for scratch data area for
;       somethingelse..
;---------------------------------------;
        cli
;  ECX = file size in unit of 32k
;  start operating on flash..
        pushad
        check_point_ini 0f5h            ; ======== F5
        call    disable_internal_cache  ; disable internal cache
        popad
        call    flash_program           ; detect, erase, program flash
        jc      i19_15                  ; error..display and halt
;  successful..generate cpu reset..
;  make sure floppy goes off after flash programming
        mov     dx,3f2h                 ; DIGITAL OUTPUT REGISTER PORT
        mov     al,0ch                  ; turn of MOTOR
        out     dx,al
;---------------------------------------;
;  CS:SI = ptr to message/beep codes..
;  enable GateA20..
        call    display_on_port         ; display program successful
        mov     al,60h
        out     64h,al
        call    ib_free
        mov     al,75h                  ; disable kb, set sys bit
        out     60h,al
        call    ib_free
        in      al,60h
        mov     bl,cgroup:boot_block_flag; get boot block flag
        test    bl,02h                  ; destroy CMOS checksum ?
        jz      no_csum_destroy         ; no
        mov     ax,0c08eh               ; destroy CMOS checksum
        call    cmos_data_out
no_csum_destroy:
        test    bl,01h                  ; reboot ?
        jnz     halt                    ; no
;  reboot after successful flash programming
        call    restore_cpuid           ; restore EDX
;;;;    jmp     far F000:FFF0
        db      0eah                    ; goto ROM
        dw      0fff0h
        dw      0f000h
halt:
        mov     al,0fh
        out     61h,al
        jmp     short halt
i19_15:
        jmp     display_blink_halt
;---------------------------------------;
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
;-----------------------------------------------;
;       READ_1_CLUSTER          ROUTINE         ;
;                                               ;
;  this routine reads the asked cluster form the;
;  file                                         ;
;  input :                                      ;
;       ax      cluster#                        ;
;       bp      #of sectors/cluster             ;
;       ds:di   ptr to scratch area             ;
;       es:bx   pointer to read buffer          ;
;  output:                                      ;
;       nc      ok                              ;
;       cy      error                           ;
;                                               ;
;  register destroyed..AX BX CX DX              ;
;-----------------------------------------------;
read_1_cluster  proc    near
        push    bp                      ; BP = #of sectors per cluster
        call    find_sec_hd_cyl_cluster ; find start sector#, head#, cyl# for
                                        ; the cluster concerned
r_c_03:
;  CH,CL = cyl#, start sector#..
;  DH,DL = head#, drive#..
;  BP    = #of sectors yet to be read..
        mov     ax,0201h                ; read 1 sector at a time
        int     13h                     ; read the sectors
        jc      r_c_01                  ; error..CY already..
r_c_skip:
        mov     ax,[di+0bh]             ; #of bytes per sector
        add     bx,ax                   ; update buffer address
        jnz     r_c_02
        inc     byte ptr [di+02h]       ; update file size in unit of 64k
        mov     ax,es
        add     ax,1000h
        mov     es,ax
r_c_02:
        dec     bp                      ; all sectors in the cluster read ?
        jz      r_c_00                  ; yes..
;  find next sector, hd#, cyl# of the next sector in that cluster..
        push    si
        mov     si,di
        call    find_next_sector_hd_cyl ; next sector#, hd#, cyl# of that cluster
        pop     si
        jmp     short r_c_03            ; read next sector fo cluster
r_c_00:
;  successful reading of cluster..
        clc                             ; NC..
r_c_01:
        pop     bp                      ; restore #of sectors per cluster
        ret
read_1_cluster  endp
;---------------------------------------;
;       FIND_SEC_HD_CYL_CLUSTER         ;
;  this routine finds the sector#, head#,
;  cyl# for the given cluster#          ;
;  input :                              ;
;       ax      cluster#                ;
;    ds:di      pointer to scratch storage
;  output:                              ;
;       cl      bit 5-0  sector#        ;
;               bit 7-6  high 2-bits of ;
;                        10-bit cyl#    ;
;       ch      low 8-bits of 10-bit cyl#
;       dh      head#                   ;
;       dl      hard disk#              ;
;---------------------------------------;
find_sec_hd_cyl_cluster         proc    near
        dec     ax
        dec     ax                      ; subtract 02 from cluster#
        mov     dl,[di+0dh]             ; multiply by #of sectors/cluster
        xor     dh,dh
        mul     dx
        add     ax,[di]                 ; add starting abs sector# of data area
        push    si
        mov     si,di                   ; DS:SI ptr to scratch area
        call    find_sector_head_cyl    ; find sector#, head#, cyl#, disk#
        pop     si
        ret
find_sec_hd_cyl_cluster         endp
;---------------------------------------;
;       FIND_NEXT_SECTOR_HD_CYL         ;
;  this routine finds the sector#, head#,
;  cyl# of the next sector              ;
;  input :                              ;
;       cl      bit 5-0  present sector#;
;               bit 7-6  high 2-bits of ;
;                        10-bit cyl#    ;
;       ch      low 8-bits of 10-bit cyl#
;       dh      present head#           ;
;    ds:si      ptr to scratch area     ;
;  output:                              ;
;       cl      bit 5-0  next sector#   ;
;               bit 7-6  high 2-bits of ;
;                        10-bit cyl#    ;
;       ch      low 8-bits of 10-bit cyl#
;       dh      head#                   ;
;  register destroyed..AX CX DH         ;
;---------------------------------------;
find_next_sector_hd_cyl         proc    near
        mov     al,cl
        and     al,3fh                  ; AL = sector# of previous  sector
        xchg    cl,ch
        shr     ch,6                    ; CX = 10-bit cyl# of previous sector
        inc     al                      ; next sector#
        cmp     al,[si+18h]             ; sector crosses boundary ?
        jbe     r_10                    ; no..
;  sector crosses boundary..
        mov     al,1                    ; sector#
        inc     dh                      ; increment head#
        cmp     dh,[si+1ah]             ; head crosses boundary ?
        jb      r_10                    ; no..
        mov     dh,00                   ; yes..new head#..
        inc     cx                      ; new cyl#
r_10:
;  AL = sector# of the next sector ..
;  DH = head#   of the next sector ..
;  CX = cyl#    of the next sector ..
        xchg    cl,ch                   ; CH = low 8-bits of 10-bit cyl#
        shl     cl,6                    ; CL = bit 7-6  high 2bit of 10bit cyl#
        or      cl,al                   ;      bit 5-0  sector#
        ret
find_next_sector_hd_cyl         endp
;---------------------------------------;
;       FIND_SECTOR_HEAD_CYL            ;
;  this routine finds the corresponding ;
;  sector#, head#, cyl# for a given     ;
;  absolute sector#                     ;
;  input :                              ;
;       ax      absolute sector#        ;
;    ds:si      ptr to bpb informn      ;
;  output:                              ;
;       cl      bit 5-0  sector#        ;
;               bit 7-6  high 2-bits of ;
;                        10-bit cyl#    ;
;       ch      low 8-bits of 10-bits cyl#
;       dh      head#                   ;
;       dl      drive#                  ;
;  register destroyed..AX CX DX         ;
;---------------------------------------;
find_sector_head_cyl    proc    near
        xor     dx,dx
        div     word ptr [si+18h]       ; divide by #of sectors/track
        inc     dl
        mov     cl,dl                   ; CL = sector# (1-based)
        xor     dx,dx
        div     word ptr [si+1ah]       ; divide by #of heads
        mov     dh,dl                   ; DH = head# (0-based)
        mov     ch,al                   ; CH = low 8-bits of 10-bit cyl#
        shl     ah,6
        or      cl,ah                   ; CL = bit 7-6 high 2bits of 10bit cyl#
                                        ;      bit 5-0 sector#
        mov     dl,drive_number         ; DL = drive#
        ret
find_sector_head_cyl    endp
;---------------------------------------;
;       FIND_STORE_CLUSTER_NOS          ;
;  this routine finds the cluster#s of  ;
;  the file and stores them serially    ;
;  input :                              ;
;       ax      starting cluster#       ;
;    ds:di      ptr to area where the   ;
;               cluster#s are to be stored
;    es:0000    contain FAT sectors     ;
;  output:                              ;
;       none                            ;
;  register destroyed..AX BX CX DX DI   ;
;---------------------------------------;
find_store_cluster_nos  proc    near
        push    es
        push    ds
        push    es
        push    ds
        pop     es
        pop     ds                      ; exchange DS and ES
fcn_00:
;  12-bit FAT..
        mov     cx,ax                   ; save last cluster#
        mov     bx,3
        mul     bx
        shr     ax,1                    ; multiply cluster# by 1.5
;  AX = offset into the FAT pointing to the entry that maps the cluster just
;       used..that entry contains the next cluster# of the file..
;  CX = last cluster# being used..
        mov     bx,ax
        mov     ax,[bx]                 ; get the content of the entry in FAT
        test    cl,1                    ; last cluster# even/odd ?
        jz      fcn_02                  ; last cluster# even..keep low 12-bits
        shr     ax,04h                  ; last cluster# odd..keep high 12-bits
fcn_02:
        and     ax,0fffh                ; AX = next cluster#
        stosw                           ; store next cluster#
        cmp     ax,0ff8h                ; end of file ?
        jb      fcn_00                  ; no..
        pop     ds
        pop     es
        mov     word ptr [di-02h],end_of_cluster; mark end of file cluster
                                                ; with FFFF
dummy_ret::                             ; (CORE0211+)
        ret
find_store_cluster_nos  endp
;---------------------------------------;
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
        public  _UB_ENDS
_UB_ENDS        label   byte            ; marks end of module
;---------------------------------------;
_text   ends
        end
