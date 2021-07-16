        page    ,132
        title   CHIPSET INIT/MEMORY SIZING
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
;---------------------------------------;
        include mbiosmac.mac
        include mbiosequ.equ
        include makeflag.equ
;---------------------------------------;
        extrn   u_sis5595_pci2isa_init_table:byte
        extrn   u_sis530_init_table:byte

        extrn   read_sio_byte_x:near
        extrn   read_pci_byte_x:near
        extrn   write_sio_byte_x:near
        extrn   write_pci_byte_x:near
        extrn   cmos_data_in:near
        extrn   cmos_data_out:near
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.586p
;---------------------------------------;
        public  _MEMORY_STARTS
_MEMORY_STARTS  label   byte            ; marks start of module
;-----------------------------------------------------------------------;
;                       U_POWER_ON_INIT                                 ;
;-----------------------------------------------------------------------;
;  this routine is invoked just after bios gets control at power-on.    ;
;  NOTHING IS DEFINED (except EDX) ON ENTRY TO THIS ROUTINE.            ;
;  input :                                                              ;
;       EDX     cpu id                                                  ;
;       SS = CS                                                         ;
;       stack   not available                                           ;
;  output:                                                              ;
;       none                                                            ;
;  register usage : can destroy any register except EDX,SS,FS,GS        ;
;  NOTE: 1. this routine can be used to enable RTC/KBC, etc. if KBC/RTC ;
;        is handled by the chipset.                                     ;
;        2. if KBC/RTC is handled by onboard I/O chipset, then selected ;
;        I/O chipset routines will handle KBC/RTC, this routine does not;
;        need to do anything.                                           ;
;-----------------------------------------------------------------------;
        public  u_power_on_init
        public  oem_u_power_on_init_end
        extrn   oem_u_power_on_init:near
        extrn   u_power_on_init_end:near
u_power_on_init:
        mov     ebp, edx                        ;Save CPUID in EBP

        mov     si,offset cgroup:u_sis5595_pci2isa_init_table
u_sio_init:
        mov     ah,cs:[si]
        or      ah,ah
        jz      u_sio_init_done

        jmp_di  read_sio_byte_x
        inc     si
        and     al,cs:[si]
        inc     si
        or      al,cs:[si]
        inc     si
        jmp_di  write_sio_byte_x
        jmp     short u_sio_init
u_sio_init_done:

        mov     ah,45h                          ; Open APC
        jmp_di  read_sio_byte_x         
        mov     bx,ax                           ; Save Reg.45h to BX
        or      al,02h                  
        jmp_di  write_sio_byte_x        

        mov     ax,8787h                        ; APC Register 07h  
        ret_sp  cmos_data_in
        and     al,0feh                         ; Clear KPR_LST  
        xchg    al,ah
        ret_sp  cmos_data_out

        mov     ax,8383h                        ; APC Register 03h 
        ret_sp  cmos_data_in
        or      al,040h                         ; Enable APC Function
        and     al,not 2ch                      ; Disable Ring/RTC/STREQ0
        xchg    al,ah                           ; 
        ret_sp  cmos_data_out
                                                
        mov     ax,bx                           ; Close APC       
        jmp_di  write_sio_byte_x                ; Restore Reg.45h 

        mov     si,offset cgroup:u_sis530_init_table
u_pci_init:
        mov     ah,cs:[si]
        or      ah,ah
        jz      u_pci_inti_done
        jmp_di  read_pci_byte_x
        inc     si
        and     al,cs:[si]
        inc     si
        or      al,cs:[si]
        inc     si
        jmp_di  write_pci_byte_x
        jmp     short u_pci_init
u_pci_inti_done:

; set all IRQs to edge trigger
        xor     ax, ax
        mov     dx, 04D0h
        out     dx, al
        jmp     short $+2
        inc     dx
        out     dx,al
        jmp     short $+2

;  Do OEM specific stuff
        jmp     oem_u_power_on_init     ; in OEMMEMRY.ASM
oem_u_power_on_init_end:

        mov     edx, ebp                        ;Restore CPUID

        jmp     u_power_on_init_end

;-----------------------------------------------------------------------;
;                               U_CP_INIT                               ;
;-----------------------------------------------------------------------;
; check_point           : D3                                            ;
; This routine is used to do chipset register initialisation and memory ;
; sizing.                                                               ;
; input :                                                               ;
;       refresh not started (start the refresh through timer if refresh ;
;                           is not controlled by chipset)               ;
;       SS      = CS                                                    ;
;       DS      0000H                                                   ;
;       ES      0000H                                                   ;
;       DS & ES set to 4GB limit                                        ;
;       stack   NOT available                                           ;
; register usage : can destroy any register except EBP,DS,ES,FS,GS      ;
; Note:                                                                 ;
; 1. Set BIOS size to 128K.                                             ;
; 2. Do memory sizing.                                                  ;
;-----------------------------------------------------------------------;
        public  u_cp_init
        public  oem_u_cp_init_end
        extrn   u_cp_init_end:near
        extrn   oem_u_cp_init:near
u_cp_init:
        jmp     oem_u_cp_init           ; in OEMMEMRY.ASM
oem_u_cp_init_end:

if (MKF_NCPU eq 2)
        jmp     u_init_local_apic
u_init_local_apic_end:
endif

        jmp     cas_latency_set
cas_latency_set_end:

        jmp     cp_init_x
cp_init_x_end:

        jmp     cache_test      ;return bl
cache_test_end:

%out === Memory refresh starts after memory sizing ===
;---------------------------------------;
;       START MEMORY REFRESH            ;
;---------------------------------------;
        extrn   refresh_low_value:byte
        mov     al,00h                  ; initialise DMA-PAGE reg.
        out     8fh,al                  ; (used in MEMORY REFRESH)
        mov     al,01010100b            ; start CH_1 (REFRESH)
        out     timer_control_port,al   ; one byte count used
        io_delay
        mov     al,cgroup:refresh_low_value; low byte count
        out     timer_1_port,al
        mov     cx,100h                 ; 400h..01/11/95
        xor     di,di
        mov     es,di                   ; ES = 0
wpulse1:
        stosb
        loop    wpulse1

        jmp     u_cp_init_end

;------------------------------------------------;
sdram                   = 1
;-----------------------------------------------;
DATA_PATTERN1           EQU     012345678H
DATA_PATTERN2           EQU     087654321H
DATA_PATTERN3           EQU     05a5a5a5aH
DATA_PATTERN4           EQU     0a5a5a5a5H
;-----------------------------------------------;
;***************************************************************************;
        PushNS          macro   Reg
                shl     Reg,16
        endm
;***************************************************************************;
        PopNS           macro   Reg
                shr     Reg,16
        endm
;***************************************************************************;
;---------------------------------------;
;       JMP_DI MACRO DEFINITION         ;
;---------------------------------------;
jmp_BX  macro   dummy                   ; goto routine & back (via DI)
        local   llll                    ; local label
        mov     BX,offset cgroup:llll   ; return address
        jmp     dummy
llll:
endm

;---------------------------------------;
;       AW_DELAY MACRO DEFINITION               ;
;---------------------------------------;
aw_delay macro

        out    0e0h,al
endm


init_dram label byte
         db     056h,002h

         db     063h,007h

         db     05ch,010h
         db     05ch,090h
         db     05ch,050h
         db     05ch,000h
         db     05ch,020h
         db     05ch,020h
         db     05ch,020h
         db     05ch,020h
         db     05ch,020h
         db     05ch,020h

         db     063h,004h

         db     0ffh

cp_init_x:
;;============>init the initiail reg value
       mov si,offset cgroup:init_dram  ;; init reg 60 - 6F for memory sizing
id_loop_1:
        mov ah,byte ptr cs:[si]
        cmp ah,0ffh
        jz  short id_loop_1_end
        mov al,byte ptr cs:[si+1]
        jmp_di write_pci_byte_x
        inc si
        inc si
        jmp short id_loop_1
id_loop_1_end:

;;=================================================================
;       EXTRN   csMem_MatrixJBX:near
;       EXTRN   csMem_MatrixsJBX:near
;       EXTRN   csPattern_TestJBX:near
;EDO_DRAM       =       1
;SDRAM          =       1

; assume bank 0,1,2 was set as FP,TYPE3,SINGLE SIDE,64bit
; assume ds,es:0~4G
STARTDRAMSIZE:
        MOV     AH,062H                         ; bank pointer
;---------------------------------------------------------------;
BANKSTART:
        mov     dx,ax
        pushns  edx                             ; save bank pointer

;---------------------------------------------------------------;
        jmp_di  read_pci_byte_x
        or      al,00bh                         ; low nibble already '3'
        jmp_di  write_pci_byte_x                ; Pre-set SDRAM present
;---------------------------------------------------------------;
ram_test_begin:
        mov     al,0                    ; pre-set dram ma_type as none
        jmp_bx  cspattern_testjbx       ; make sure dram present once more
        jnz     bankdone                ; and put data pattern into offset 0

        jmp_bx  csmem_matrixsjbx        ; output= al (actully ma_type+1)

BANKDONE:
;---------------------------------------------------------------;
        dec     al

        popns   edx                     ; save dram type
        mov     dl,al
        pushns  edx

        cmp     al,0ffh
        jz      no_dram

        mov     al,2bh
        jmp_di  write_pci_byte_x

normal_dram_dside_detect:
        xor     edi,edi                                         ; test the other side
        mov     dword ptr es:[edi+10000000h],Data_pattern1      ; write 256M+0
        mov     dword ptr es:[edi+10000008h],Data_pattern2      ; write 256M+8
        cmp     dword ptr es:[edi+10000000h],Data_pattern1
        jz      double_side_prsnt

clear_dside_dram:
        and     al, not 020h
        jmp_di  write_pci_byte_x

double_side_prsnt:
no_dram:
        popns   edx
        mov     ax,dx
        push    edx

        mov     bl,al
        jmp_di  read_pci_byte_x
        cmp     bl,0ffh
        jz      should_clear_cfg
        and     al,0f0h
        or      al,bl
        jmp     @f
should_clear_cfg:
        mov     cl,ah                   ; get correct bank enable bit
        and     cl,07h
        mov     bh,1
        shl     bh,cl
        mov     bl,ah

        mov     ah,63h
        jmp_di  read_pci_byte_x
        not     bh
        and     al,bh                   ; clear bank to be test
        jmp_di  write_pci_byte_x

        mov     ah,bl
        mov     al,0
@@:
        jmp_di  write_pci_byte_x

        dec     AH                      ;DECREASE BANK POINTER
        cmp     ah, 60h
        jb      sizing_done

        mov     dx,ax
        pushns  edx

        mov     cl,ah                   ; get correct bank enable bit
        and     cl,07h
        mov     bh,1
        shl     bh,cl

        mov     ah,63h
        jmp_di  read_pci_byte_x
        or      al,bh
        jmp_di  write_pci_byte_x

bank_finish:
        popns   edx
        mov     ax,dx

        jmp     bankstart

sizing_done:
        mov     ah, 063h
        jmp_di  read_pci_byte_x

        test    al,07h
        Jnz     DRAM_SIZING_DONE
        xor     ecx,ecx
@@:     in      al,80h                  ; NO DRAM COMES HERE
        inc     al
        out     80h,al
        db      67h
        loop    $
        jmp     @b
DRAM_SIZING_DONE:
;;=================================================
        jmp   cp_init_x_end                     ;end

;----------------------------------------------;
;----------------------------------------------;
set_ma_type     macro   x
                xor     al,al
                or      al,x
                endm
;----------------------------------------------;
;----------------------------------------------;
;output ZF=0 means no dram
;  for 64/32 mix system
;       CF=0 means 64, 1 means 32
;  for pure 64 system
;       CF=0 means memory test good, 1 means memory bad
csPattern_TestJBX       proc    near    public
        MOV     DWORD PTR ES:[00h], DATA_PATTERN1   ;WRITE MEMORY
        aw_delay
        jcxz    $+2
        MOV     DWORD PTR ES:[08h], DATA_PATTERN2   ;CLEAR BUS
        aw_delay
        jcxz    $+2
        CMP     DWORD PTR ES:[00h], DATA_PATTERN1   ;MEMORY EXIST?
        aw_delay
        jcxz    $+2
        jnz     @f

        MOV     DWORD PTR ES:[04h], DATA_PATTERN3   ;WRITE MEMORY
        aw_delay
        jcxz    $+2
        MOV     DWORD PTR ES:[0ch], DATA_PATTERN4   ;CLEAR BUS
        aw_delay
        jcxz    $+2
        CMP     DWORD PTR ES:[04h], DATA_PATTERN3   ;MEMORY EXIST?
        aw_delay
        jcxz    $+2
        jnz     dram_32_present
        clc
@@:
        jmp     bx
dram_32_present:
        cmp     sp,sp
        stc
        jmp     bx
csPattern_TestJBX       endp

;----------------------------------------------;
;-----------------------------------------------;
SMA_C8   equ     00000800h
SMA_C9   equ     00001000h
SMA_Cc   equ     00004000h

SMA_Rc   equ     00004000h
SMA_Rd   equ     04000000h
SMA_Re   equ     08000000h
;-----------------------------------------------;
sma_none         equ     0000b   ;
sma_1_11_08      equ     0001b   ; 0
sma_1_13_08      equ     0010b   ; 1
sma_1_11_09      equ     0101b   ; 4
sma_1_13_09      equ     0110b   ; 5
sma_1_11_10      equ     1001b   ; 8
sma_1_13_10      equ     1010b   ; 9
sma_2_11_08      equ     1101b   ; c
sma_2_12_08      equ     0011b   ; 2
sma_2_13_08      equ     0100b   ; 3
sma_2_12_09      equ     0111b   ; 6
sma_2_13_09      equ     1000b   ; 7
sma_2_12_10      equ     1011b   ; a
sma_2_13_10      equ     1100b   ; b
;---------------------------------------;

csMem_MatrixSJBX        proc    near    public
        xor     edi,edi
;---------------------------------------------------------------;
; asymmetry dram detecting should be put here
        CMP     DWORD PTR ES:[edi+sMA_Cc],DATA_PATTERN1
        jcxz    $+2                             ;test a10
        Jne     two_bank_sdram                  ;mac8 valid , jmp

        CMP     DWORD PTR ES:[edi+sMA_C8],DATA_PATTERN1
        jcxz    $+2
        jne     one_bank_10c

        set_ma_type     sma_1_13_08

        CMP     DWORD PTR ES:[edi+sMA_Rd],DATA_PATTERN1
        jcxz    $+2
        jne     @f
        set_ma_type     sma_1_11_08
@@:     jmp     bx
one_bank_10c:
        CMP     DWORD PTR ES:[edi+sMA_C9],DATA_PATTERN1
        jcxz    $+2
        jne     one_bank_11c

        set_ma_type     sma_1_13_09
        CMP     DWORD PTR ES:[edi+sMA_Rd],DATA_PATTERN1
        jcxz    $+2
        jne     @f
        set_ma_type     sma_1_11_09
@@:     jmp     bx
one_bank_11c:
        set_ma_type     sma_1_13_10
        CMP     DWORD PTR ES:[edi+sMA_Rd],DATA_PATTERN1
        jcxz    $+2
        jne     @f
        set_ma_type     sma_1_11_10
@@:     jmp     bx

two_bank_sdram:
        CMP     DWORD PTR ES:[edi+sMA_C8],DATA_PATTERN1
        jcxz    $+2
        jne     two_bank_10c

        set_ma_type     sma_2_13_08
        CMP     DWORD PTR ES:[edi+sMA_Re],DATA_PATTERN1
        jcxz    $+2
        jne     @f
        set_ma_type     sma_2_12_08
        CMP     DWORD PTR ES:[edi+sMA_Rd],DATA_PATTERN1
        jcxz    $+2
        jne     @f
        set_ma_type     sma_2_11_08
@@:     jmp     bx
two_bank_10c:
        CMP     DWORD PTR ES:[edi+sMA_C9],DATA_PATTERN1
        jcxz    $+2
        jne     two_bank_11c

        set_ma_type     sma_2_13_09
        CMP     DWORD PTR ES:[edi+sMA_Re],DATA_PATTERN1
        jcxz    $+2
        jne     @f
        set_ma_type     sma_2_12_09
@@:     jmp     bx
two_bank_11c:
        set_ma_type     sma_2_13_10
        CMP     DWORD PTR ES:[edi+sMA_Re],DATA_PATTERN1
        jcxz    $+2
        jne     @f
        set_ma_type     sma_2_12_10
@@:     jmp     bx
csMem_MatrixSJBX        endp

;*****************************************************************;
;*****************************************************************;
cas_latency_set:
        mov     ah,45h                  ; open external cmos
        jmp_di  read_sio_byte_x         
        or      al,08h                  
        jmp_di  write_sio_byte_x        

        mov     al,80h                   ; read external cmos offset 0h,bit0
        ret_sp  cmos_data_in             
        db      0d4h,10h                        ; AAM 10h
        xor     ah,al
        cmp     ah,0fh
        jnz     set_cas_latency_done
        test    al,1
        jnz     set_cas_latency_done

        mov     ah,05dh                  
        jmp_di  read_pci_byte_x          
        and     al, not 08h                      ; Set CAS Latency to 2
        jmp_di  write_pci_byte_x

set_cas_latency_done:
        mov     ah,45h                  ; Close external cmos
        jmp_di  read_sio_byte_x         
        and     al,not 08h              
        jmp_di  write_sio_byte_x        

        jmp     cas_latency_set_end

;---------------------------------------;
burst_sram              = 0
;---------------------------------------;
;       CACHE SIZING                    ;
;---------------------------------------;
cache_test:
.386p
;1.     INIT DEFAULT VALUE IF HARDWARE NOT SO RELIABLE.
;2.     FOR SIZING PURPOSE , FIRST WE SET :
;       A. F000 SEGMENT NONCACHEABLE (CHIPSET DEFAULT)
;       B. MAXIMUM CACHE SIZE (1MB)
;       C. ALWAYS HIT
;       D. WRITE TROUGH
;       E. 8 BIT TAGS

        mov     ah,051h
        jmp_di  read_pci_byte_x
        and     al,00000100b            ;decide linear or toggle by reg 7c.2
        or      al,0f1h                 ; cache exist,  1m sram, wt
        jmp_di  write_pci_byte_x        ; 8 bit tags, always hit

; ------------------------------------------------------;
if burst_sram

        ret_sp  enable_internal_cache

        xor     edi,edi
        mov     eax,11111111h
        stosd
        mov     eax,22222222h
        stosd
        mov     eax,33333333h
        stosd
        mov     eax,44444444h
        stosd
        mov     eax,55555555h
        stosd
        mov     eax,66666666h
        stosd
        mov     eax,77777777h
        stosd
        mov     eax,88888888h
        stosd

        xor     esi,esi
        mov     cx,8
        rep     lodsd

        xor     esi,esi
        lodsd
        cmp     eax,11111111h
        jnz     asyn_sram_installed
        lodsd
        cmp     eax,22222222h
        jnz     pburst_installed
        lodsd
        cmp     eax,33333333h
        jnz     pburst_installed
        jmp     short @f
asyn_sram_installed:
        mov     ah,051h
        mov     al,0fh
        jmp_di  write_pci_byte_x
        jmp     short @f
pburst_installed:
        mov     ah,052h
        jmp_di  read_pci_byte_x            ; PIPELINE_SRAM_INSTALLED
        and     al,0efh
        jmp_di  write_pci_byte_x

@@:
        ret_sp  disable_internal_cache

endif

        xor     ebx,ebx                 ;bl for retune cache good or bad
        xor     ecx,ecx                 ;for count dram size
        mov     DWORD PTR ES:[000000H],DATA_PATTERN1    ;
; ------------------------------------------------------;
check_size:
        CMP     DWORD PTR ES:[ecx+100000H],DATA_PATTERN1        ;
        jcxz    $+2
        jcxz    $+2
        JNE     X2MB_SRAM_EXIST
        CMP     DWORD PTR ES:[ecx+080000H],DATA_PATTERN1        ;
        jcxz    $+2
        jcxz    $+2
        JNE     X1MB_SRAM_EXIST
        CMP     DWORD PTR ES:[ecx+040000H],DATA_PATTERN1
        jcxz    $+2
        jcxz    $+2
        JNE     X512KB_SRAM_EXIST
        CMP     DWORD PTR ES:[ecx+020000H],DATA_PATTERN1
        jcxz    $+2
        jcxz    $+2
        JNE     X256KB_SRAM_EXIST
        JMP     SHORT NO_SRAM_EXIST
X2MB_SRAM_EXIST:
        INC     cl
X1MB_SRAM_EXIST:
        INC     cl
X512KB_SRAM_EXIST:
        INC     cl
X256KB_SRAM_EXIST:
        inc     bx


NO_SRAM_EXIST:
SIZE_GOT:
        shl     cl,4

        mov     si,cx
        pushns  esi

        mov     ax,0b3b3h
        ret_sp  cmos_data_in
        and     al,NOT 01h
        or      al,bl
        xchg    al,ah
        ret_sp  cmos_data_out

        mov     ah,051h
        jmp_di  read_pci_byte_x            ; PIPELINE_SRAM_INSTALLED
        and     al,00eh                 ;sizing mode->normal

        popns   esi
        mov     cx,si

        or      al,cl                   ;set cache size
        jmp_di  write_pci_byte_x

CACHE_SIZE_END:
        jmp     cache_test_end

; (CORE0211+)>
if (MKF_BOOTBLOCK_LS120)
;-----------------------------------------------------------------------;
;                       INIT_ATAPI_HARDWARE                             ;
; this routine enables/resets the ATAPI hardware. this routine is called;
; from the boot block code if no floppy controller is found.            ;
; input :                                                               ;
;       ds:si   ptr to information buffer                               ;
; output:                                                               ;
;       NC      successful                                              ;
;               ds:si ptr to filled information buffer                  ;
;       CY      error                                                   ;
; register usage : DO NOT destroy any register                          ;
; format of the information buffer:                                     ;
; offset        length  description                                     ;
; 0             WORD    #of entries that can be accommodated in the     ;
;                       supplied buffer. this value is supplied as input;
;                       value which indicates the maxm #of entries that ;
;                       can be put in the supplied buffer. this value is;
;                       updated in output depending on how many entries ;
;                       are put in the supplied buffer. each entry is of;
;                       6 bytes in length.                              ;
; 2-7           6BYTE   1st entry                                       ;
; |             |       |                                               ;
; N-N+7         6BYTE   Nth entry                                       ;
; format of each entry:                                                 ;
; offset        length  description                                     ;
; 0             WORD    Base Port Address                               ;
; 2             WORD    Control Port Address                            ;
; 4             BYTE    Drive Selection Parameter                       ;
; 5             BYTE    IRQ used                                        ;
; IMPLEMENTATION NOTES:                                                 ;
; this routine should do the following:                                 ;
; 1. Enable the ATAPI Hardware. this may need the configuring the ATAPI ;
; controller, route the IRQ.                                            ;
; 2. Reset all ATAPI controllers and wait for reset to be complete if   ;
; needed.                                                               ;
; 3. Fill the supplied information buffer properly.                     ;
;-----------------------------------------------------------------------;
io_delay        macro
        jcxz    $+2
        jcxz    $+2
endm

        public  init_atapi_hardware
init_atapi_hardware:
        pushad
        mov     cx,ds:word ptr [si]     ; maxm #of entries that can be put in the supplied buffer
        stc                             ; CY, for error
        jcxz    short iah_00            ; no space in buffer
        push    cx

; Chipset porting START -------------------------------------------------;
%out === Porting for enabling IDE is needed ===
;; enable IDE
        extrn   read_ide_byte:near
        extrn   write_ide_byte:near
        mov     ah,4ah
        call    read_ide_byte
        or      al,06h
        call    write_ide_byte
        
        mov     ah,04h
        call    read_ide_byte
        or      al,05h
        call    write_ide_byte
; Chipset porting ENDS --------------------------------------------------;

; fill the output buffer
        pop     cx                      ; CX = maxm #of entries in the buffer
; DS:SI = ptr to start of the supplied buffer
        push    es
        push    ds
        pop     es
        mov     di,si                   ; ES:DI = ptr to start of buffer
        mov     ax,atapi_info_table_entries; #of entries in the atapi_info_table
        cmp     ax,cx                   ; within maxm limit ?
        jbe     short iah_02            ; yes
        mov     ax,cx
iah_02:
; AX = #of entries to be put in the supplied buffer
        stosw                           ; put the #of entries filled
        mov     cx,ax
        mov     si,offset cgroup:atapi_info_table; CS:SI = ptr to 1st entry in the table
iah_03:
; ES:DI = ptr to next entry in the supplied buffer
; CS:SI = ptr to next entry in the table
        push    cx
        mov     cx,size ATAPI_INFO_STRUC
        rep     movs es:byte ptr [di],cs:byte ptr [si]; copy the next entry
        pop     cx
        loop    iah_03
        pop     es
        clc                             ; NC, ATAPI hardware initialized
iah_00:
        popad
        ret
;-----------------------------------------------------------------------;
ATAPI_INFO_STRUC        struc
        wBasePort       dw      ?       ; base port address
        wControlPort    dw      ?       ; control port address
        bDeviceSelect   db      ?       ; device selection parameter
        bIRQ            db      ?       ; IRQ used
ATAPI_INFO_STRUC        ends

atapi_info_table        label   byte
        ATAPI_INFO_STRUC        {170h,376h,0b0h,0fh}    ; for secondary slave
        ATAPI_INFO_STRUC        {1f0h,3f6h,0a0h,0eh}    ; for primary master
        ATAPI_INFO_STRUC        {1f0h,3f6h,0b0h,0eh}    ; for primary slave
        ATAPI_INFO_STRUC        {170h,376h,0a0h,0fh}    ; for secondary master
;;##    ATAPI_INFO_STRUC        {170h,376h,0b0h,0fh}    ; for secondary slave
atapi_info_table_end    label   byte

atapi_info_table_entries        equ     (atapi_info_table_end-atapi_info_table)/(size ATAPI_INFO_STRUC)
endif;  if (MKF_BOOTBLOCK_LS120)
; <(CORE0211+)

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
if (MKF_NCPU eq 2)
        include uapic.inc
endif
;-----------------------------------------------------------------------;

        public  _MEMORY_ENDS
_MEMORY_ENDS    label   byte            ; marks end of module
;---------------------------------------;
_text   ends
        end
