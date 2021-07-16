        page    ,132
        title   HOOKS for BOOT BLOCK BIOS, SYSTEM BIOS, PnP Flash NVRAM
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
;  this file will be linked with both Boot Block Code and normal BIOS   ;
;  runtime code.                                                        ;
;  this file needs to be self contained i.e. this file should not have  ;
;  any external reference other than those declared below.              ;
;-----------------------------------------------------------------------;
        include makeflag.equ
        include mbiosmac.mac
;-----------------------------------------------------------------------;
        extrn   pgm_kbc:near
        extrn   delay_50ms:near
;-----------------------------------------------------------------------;
;               AMI KEYBOARD CONTROLLER COMMANDS                        ;
;-----------------------------------------------------------------------;
;  Port Pin     Command to make it HIGH         Command to make it LOW  ;
;  --------     -----------------------         ----------------------  ;
;  P10          B8                              B0                      ;
;  P11          B9                              B1                      ;
;  P12          BA                              B2                      ;
;  P13          BB                              B3                      ;
;  P14 *        CC                              C4                      ;
;  P15 *        CD                              C5                      ;
;  P22          BC                              B4                      ;
;  P23          BD                              B5                      ;
;  -------------------------------------------------------------------- ;
;  Note: Command for P14 and P15 are available only in MEGAKEY. All     ;
;  other commands are available in all AMI Keyboard Controllers.        ;
;-----------------------------------------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
        assume  cs:cgroup
.486p
; (CORE0071+)>
;-----------------------------------------------------------------------;
;                       GET_ROM_IMAGE                                   ;
;-----------------------------------------------------------------------;
; this routine maps the whole ROM iamge to a system address and returns ;
; that system address to the caller.                                    ;
;-----------------------------------------------------------------------;
;               IMPLEMENTATION OF THIS ROUTINE IS MANDATORY             ;
;-----------------------------------------------------------------------;
; input :                                                               ;
;       NMI, all interrupts are disabled                                ;
;       DS, ES can be set to 0 for 4GB access                           ;
;       CS <> F000                                                      ;
;       EDI     32bit absolute address of scratch buffer                ;
;       stack   available                                               ;
; output:                                                               ;
;       NC      Successful                                              ;
;               ESI 32bit absolute start address where ROM is mapped    ;
;               CX  ROM size in unit of 64k                             ;
;       CY      Error                                                   ;
; register usage : DO NOT destroy any register except CX, ESI           ;
; NOTE: 1. Do not destroy the current status of C,D,E,F segments.       ;
;       2. CS is assured to be NOT equal to F000 so that F000 ROM can   ;
;       enabled (if needed).                                            ;
;       3. The scratch buffer is of 1MByte in length.                   ;
; ================== Example of Implementation ======================== ;
; Example-1. ROM can be mapped at 4GB address and ROM is 256K.          ;
;  Step-1. Program the chipset register to enable ROM mapping at 4GB.   ;
;  Step-2. Return ESI = FFFC0000 and CX = 4.                            ;
; Example-2. ROM can be mapped at 4GB address and ROM is 128K.          ;
;  Step-1. Program the chipset register to enable ROM mapping at 4GB.   ;
;  Step-2. Return ESI = FFFC0000 and CX = 2.                            ;
; Example-3. ROM can NOT be mapped at 4GB address and ROM is 256K.      ;
;  See the U063000.DOC for implementation for this example.             ;
;-----------------------------------------------------------------------;
        public  get_rom_image
get_rom_image:
        push    ax
        pushf
        cli
if MKF_256K_BIOS
        mov     ah,040h
        call    read_sio_byte
        or      al,03h
        call    write_sio_byte
        mov     esi,0fffc0000h
        mov     cx,4
else
        mov     ah,040h
        call    read_sio_byte
        or      al,02h
        call    write_sio_byte
        mov     esi,0fffe0000h
        mov     cx,2
endif
        popf
        pop     ax
        clc
        ret

;-----------------------------------------------------------------------;
;               MAP_PHYSICAL_ROM_TO_SYSTEM_ADDRESS                      ;
;-----------------------------------------------------------------------;
; this routine maps the given ROM space to a system address so that the ;
; returned system address can be used in lieu of physical ROM address   ;
; for accessing the ROM space.                                          ;
;-----------------------------------------------------------------------;
;               IMPLEMENTATION OF THIS ROUTINE IS MANDATORY             ;
;-----------------------------------------------------------------------;
; input :                                                               ;
;       NMI, all interrupts are disabled                                ;
;       DS, ES can be set to 0 for 4GB access                           ;
;       CS <> F000                                                      ;
;       EDI     32bit physical absolute start address of ROM space      ;
;       ECX     Physical ROM address range in bytes                     ;
;       stack   available                                               ;
; output:                                                               ;
;       NC      Successful                                              ;
;               EDI 32bit start system address where ROM is mapped      ;
;       CY      Error                                                   ;
; register usage : DO NOT destroy any register except EDI               ;
; NOTE: 1. Do not destroy the current status of C,D,E,F segments.       ;
;       2. CS is assured to be NOT equal to F000 so that F000 ROM can   ;
;       enabled (if needed).                                            ;
; ================== Example of Implementation ======================== ;
; Example-1. ROM can be mapped at 4GB address.                          ;
;  Step-1. Program the chipset register to enable ROM mapping at 4GB.   ;
;  Step-2. Return ESI = OR  EDI,0FFF00000.                              ;
; Example-2. ROM can NOT be mapped at 4GB address.                      ;
;  See the U063000.DOC for implementation for this example.             ;
;-----------------------------------------------------------------------;
        public  map_physical_rom_to_system_address
map_physical_rom_to_system_address:
        or      edi,0fff00000h
        clc
        ret
;-----------------------------------------------------------------------;
;               METHOD_MAPPING_PHYSICAL_ROM_TO_SYSTEM_ADDRESS           ;
;-----------------------------------------------------------------------;
; this routine returns the information about the method used to map a   ;
; physical ROM address to a system address in the                       ;
; MAP_PHYSICAL_ROM_TO_SYSTEM_ADDRESS routine.                           ;
;-----------------------------------------------------------------------;
;               IMPLEMENTATION OF THIS ROUTINE IS MANDATORY             ;
;-----------------------------------------------------------------------;
; input :                                                               ;
;       none                                                            ;
;       stack   available                                               ;
; output:                                                               ;
;       NC      physical ROM address is mapped below 4GB                ;
;       CY      physical ROM address is not mapped below 4GB, some other;
;               method is used to map a physical ROM address            ;
; register usage : DO NOT destroy any register                          ;
; NOTE: 1. Return NC or CY depending on whether ROM is mapped at 4GB or ;
;       not.                                                            ;
;-----------------------------------------------------------------------;
        public  method_mapping_physical_rom_to_system_address
method_mapping_physical_rom_to_system_address:
        clc                             ; NC, mapped below 4GB
        ret
; <(CORE0071+)
;-----------------------------------------------------------------------;
;                       E000_READ_ROM_WRITE_X                           ;
;-----------------------------------------------------------------------;
; this routine is used to enable E000 ROM and ROMCS (chip select) so that
; read comes from E000 ROM                                              ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register                          ;
; NOTE: 1. program chipset registers to enable E000 rom and ROMCS so that
;       any read E000 segment comes from E000 ROM. where write will go  ;
;       is don't care.                                                  ;
;       2. in this routine, CS should NOT be assumed as F000.           ;
;-----------------------------------------------------------------------;
        public  e000_read_rom_write_x
e000_read_rom_write_x:
        pushf
        push    ax
        cli

        mov     ah,040h
        call    read_sio_byte
if MKF_256K_BIOS
        or      al,03h
else
        or      al,02h
endif
        call    write_sio_byte

        mov     ah,74h
        call    read_pci_byte
        and     al,NOT 88h              ; read disable 
        call    write_pci_byte

        mov     ah,75h
        call    read_pci_byte
        and     al,NOT 88h              ; read disable
        jmp     short e_f_common
;-----------------------------------------------------------------------;
;                       E000_READ_X_WRITE_RAM                           ;
;-----------------------------------------------------------------------;
; this routine is used to enable E000 RAM and make it write enabled.    ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register                          ;
; NOTE: 1. program chipset registers to enable E000 shadow RAM and      ;
;       make E000 shadow writeable.                                     ;
;       2. if read ram and write ram is possible, then make read ram    ;
;       and write ram. ELSE make write ram, don't care about read.      ;
; =========== USB Needs Read RAM and Write RAM =======================  ;
;       3. in this routine, CS should NOT be assumed as F000.           ;
;-----------------------------------------------------------------------;
        public  e000_read_x_write_ram
e000_read_x_write_ram:
        pushf
        push    ax
        cli

        mov     ah,74h
        call    read_pci_byte
        or      al,0aah                         ; read/write enable 
        call    write_pci_byte

        mov     ah,75h                  
        call    read_pci_byte
        or      al,0aah                         ; read/write enable 
        jmp     short e_f_common
;-----------------------------------------------------------------------;
;                       E000_READ_RAM_WRITE_ROM                         ;
;-----------------------------------------------------------------------;
; this routine is used to make E000 shadow RAM Read enabled and write   ;
; protected.                                                            ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register                          ;
; NOTE: 1. program chipset registers to make E000 shadow read enabled   ;
;       and write protected so that read comes from E000 shadow RAM and ;
;       write goes to E000 ROM.                                         ;
;       2. this routine code is NOT executed from F000 segment.         ;
;-----------------------------------------------------------------------;
        public  e000_read_ram_write_rom
e000_read_ram_write_rom:
        pushf
        push    ax
        cli

        mov     ah,74h                 ; read enbale/write disable
        call    read_pci_byte
        and     al,NOT 22h
        or      al,088h

        call    write_pci_byte

        mov     ah,75h                 ; read enbale/write disable 
        call    read_pci_byte
        and     al,NOT 22h
        or      al,088h
        jmp     short e_f_common

;-----------------------------------------------------------------------;
;                       F000_READ_ROM_WRITE_X                           ;
;-----------------------------------------------------------------------;
; this routine is used to enable F000 ROM.                              ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register                          ;
; NOTE: 1. program chipset registers to enable F000 rom so that any read;
;       F000 segment comes from F000 ROM.                               ;
;       2. in this routine, CS should NOT be assumed as F000.           ;
;-----------------------------------------------------------------------;
        public  f000_read_rom_write_x
f000_read_rom_write_x:
        pushf
        push    ax
        cli

        mov     ah,76h                 ; read disable
        call    read_pci_byte
        and     al,not 80h
        jmp     short e_f_common
;-----------------------------------------------------------------------;
;                       F000_READ_X_WRITE_RAM                           ;
;-----------------------------------------------------------------------;
; this routine is used to make F000 RAM Write enabled.                  ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register                          ;
; NOTE: 1. program chipset registers to make F000 shadow write enabled  ;
;       so that write goes to F000 shadow RAM.                          ;
;       2. if read ram and write ram is possible, then make read ram    ;
;       and write ram. ELSE make write ram, don't care about read.      ;
;-----------------------------------------------------------------------;
        public  f000_read_x_write_ram
f000_read_x_write_ram:                  ; F000 shadow ram write enabled
        pushf
        push    ax
        cli

        mov     ah,76h                 ; write enable
        call    read_pci_byte
        or      al,0a0h
        jmp     short e_f_common
;-----------------------------------------------------------------------;
;                       F000_READ_RAM_WRITE_ROM                         ;
;-----------------------------------------------------------------------;
; this routine is used to make F000 shadow RAM Read enabled and write   ;
; protected.                                                            ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : DO NOT destroy any register                          ;
; NOTE: 1. program chipset registers to make F000 shadow read enabled   ;
;       and write protected so that read comes from F000 shadow RAM and ;
;       write goes to F000 ROM.                                         ;
;       2. this routine code is NOT executed from F000 segment.         ;
;-----------------------------------------------------------------------;
        public  f000_read_ram_write_rom
f000_read_ram_write_rom:                ; F000 shadow ram read only
        pushf
        push    ax
        cli

        mov     ah,76h                 ; read enable/write disable
        call    read_pci_byte
        or      al,80h
        and     al,not 20h

e_f_common:

        call    write_pci_byte

        pop     ax
        popf
        ret


;-----------------------------------------------------------------------;
;               MAKE_VPP_HIGH           ; Moved to OEMFLASH.ASM
;-----------------------------------------------------------------------;
;               MAKE_VPP_LOW            ; Moved to OEMFLASH.ASM
;-----------------------------------------------------------------------;
;                       FLASH_WRITE_ENABLE                              ;
;-----------------------------------------------------------------------;
;  this routine enables write to Flash EPROM in E000,64K and F000,64K   ;
;  region.                                                              ;
;  input :                                                              ;
;       CLI                                                             ;
;       stack available                                                 ;
;  output:                                                              ;
;       none                                                            ;
; register usage : DO NOT destroy any register                          ;
;  NOTE:                                                                ;
;       1. if KBC pin is used to enable flash write, call "PGM_KBC"     ;
;          routine, specification of which is as follows:               ;
;               input : AL  command to be output to KBC                 ;
;               output: none                                            ;
;               register destroyed : AX                                 ;
;       2. for 50ms delay, call "DELAY_50MS" routine specification of   ;
;          which is as follows:                                         ;
;               input : none                                            ;
;               output: none                                            ;
;               register destroyed..none                                ;
;       3. CS should not be assumed to be F000.                         ;
;-----------------------------------------------------------------------;
        extrn   oem_flash_write_enable:near
        public  flash_write_enable
flash_write_enable      proc    near
;  write code here for chipset register programming which controls the
;  flash write signal
        pushf
        push    ax

        mov     ah,045h
        call    read_sio_byte
        and     al,11011011b ;BIT5-->0
        or      al,00000100b ;BIT2-->1 EPROM can be flashed
        call    write_sio_byte
;  call any oem specific stuff
        call    oem_flash_write_enable  ; in OEMFLASH.ASM
        pop     ax
        popf

        ret
flash_write_enable      endp
;-----------------------------------------------------------------------;
;                       FLASH_WRITE_DISABLE                             ;
;-----------------------------------------------------------------------;
;  this routine disables write to Flash EPROM in E000,64K and F000,64K  ;
;  region.                                                              ;
;  input :                                                              ;
;       CLI                                                             ;
;       stack available                                                 ;
;  output:                                                              ;
;       none                                                            ;
; register usage : DO NOT destroy any register                          ;
;  NOTE:                                                                ;
;       1. if KBC pin is used to disable flash write, call "PGM_KBC"    ;
;          routine, specification of which is as follows:               ;
;               input : AL  command to be output to KBC                 ;
;               output: none                                            ;
;               register destroyed : AX                                 ;
;       2. for 50ms delay, call "DELAY_50MS" routine specification of   ;
;          which is as follows:                                         ;
;               input : none                                            ;
;               output: none                                            ;
;               register destroyed..none                                ;
;       3. CS should not be assumed to be F000.                         ;
;-----------------------------------------------------------------------;
        extrn   oem_flash_write_disable:near
        public  flash_write_disable
flash_write_disable     proc    near
;  write code here for chipset register programming which controls the
;  flash write signal
        pushf
        push    ax
        mov     ah,045h
        call    read_sio_byte
        and     al, 11011011b      ;BIT2-->0 EPROM CAN'T BE FLASHED AGAIN
        or      al, 00100000b      ;BIT5-->1
        call    write_sio_byte
;  call any oem specific stuff
        call    oem_flash_write_disable ; in OEMFLASH.ASM
        pop     ax
        popf

        ret
flash_write_disable     endp
;-----------------------------------------------------------------------;
;                       GET_CHIPSET_VALUES                              ;
;-----------------------------------------------------------------------;
;  this routine returns the chipset values. Please read the sample code ;
;  below for PCI and ISA chipset for better understanding.              ;
;  THIS ROUTINE WILL BE CALLED ONLY IN NORMAL BIOS POST/RUNTIME WHILE   ;
;  UPDATING PnP NVRAM. THIS ROUTINE IS NOT NEEDED IN BOOT BLOCK CODE.   ;
;  input :                                                              ;
;        none                                                           ;
;  output:                                                              ;
;       NC      successful                                              ;
;               BX  index port where register index should be written   ;
;               DX  data port where data should be written              ;
;               CL  chipset register#                                   ;
;               AL  current content of chipset register corresponding   ;
;                   to F000 segment. this value will be used to restore ;
;                   F000 segment status.                                ;
;               AH  data to be written to chipset register to disable   ;
;                   F000 shadow (to disable read from F000 shadow and   ;
;                   make F000 shadow write protected.)                  ;
;       CY      error                                                   ;
;  register usage : DO NOT destroy any register except AX, BX, CL, DX   ;
;=======================================================================;
if  NOT MKF_FLASH_4GB                   ; if flash access at 4GB selected
                                        ; this routine is not needed.
        public  get_chipset_values
get_chipset_values      proc    near

        pushf
        push    bx
        push    eax
        mov     dx,0cf8h
        mov     eax,80000074h           ; output reg index 74h (DWORD boundary)
        out     dx,eax                  ; note that register index is selected
                                        ; here and remain selected so that only
                                        ; data needs to be read/written to/from
                                        ; data port
        io_delay
        mov     dl,0feh                 ; DX = 0CFEh, data port to access Reg 76h
        in      al,dx                   ; AL = current value of SiS 530 reg 76h
                                        ;      (current status of F000 segment)
        mov     bl,al
        pop     eax
        mov     al,bl                   ; AL = current value of SiS 530 reg 76h
                                        ;      (current status of F000 segment)
        mov     ah,al
        and     ah,01011111b            ; AH = value to be written to Reg 76h
                                        ;      to disable read from F000 shadow RAM
                                        ;      and make F000 shadow write protected
        pop     bx
;;  AL = curr value of SiS 530 reg 76h
;;  AH = value for SiS 530 reg 76h to disable read from F000 shadow and make F000
;;       shadow write protected
;;  DX = data port for accessing SiS 530 Reg 76h
        popf
        clc                                     ;Success
        ret
get_chipset_values      endp
;---------------------------------------;
endif
;-----------------------------------------------------------------------;
        rwbs    =1
        rwws    =1
        rwdws   =0
        rwbns   =1
        rwwns   =0
        rwdwns  =0
        srwbs   =0
        srwws   =0
        srwdws  =0
        excmos  =1
        apcmos  =1
        include chpregrw.inc
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
_text   ends
        end
