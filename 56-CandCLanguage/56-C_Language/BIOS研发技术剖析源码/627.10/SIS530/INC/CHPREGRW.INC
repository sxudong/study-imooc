.386p
ifdef   rw23s
if   rw23s
;-----------------------------------------------------------------------;
;                       CHIPSET SPECIFIC SUBROUTINES                    ;
;-----------------------------------------------------------------------;
;                               read_chip_reg                           ;
;-----------------------------------------------------------------------;
; for example, read_22_23, read_22_24, read_e0_e1, etc.                 ;
;-----------------------------------------------------------------------;
;  input : AH = reg to be read
;  output: AL = data read
;  register destroyed..AL
        public  read_22_23
        public  read_isa_reg
read_isa_reg:
read_22_23:
        mov     ah,al
        out     22h,al
        jmp     $+2
        jmp     $+2
        in      al,23h
        jmp     $+2
        jmp     $+2
        ret
;-----------------------------------------------------------------------;
;                               write_chip_reg                          ;
;-----------------------------------------------------------------------;
; for example, write_22_23, write_22_24, write_e0_e1, etc.              ;
;-----------------------------------------------------------------------;
;  input : AL = value to be write
;          AH = reg to be write
;  output: same as input
;  register destroyed..NONE
        public  write_22_23
        public  write_isa_reg
write_isa_reg:
write_22_23:
        xchg    ah,al
        out     22h,al
        jmp     $+2
        jmp     $+2
        xchg    ah,al
        out     23h,al
        jmp     $+2
        jmp     $+2
        ret
endif
endif
ifdef   rw23ns
if   rw23ns
;-----------------------------------------------------------------------;
;                               read_chip_reg_x                         ;
;-----------------------------------------------------------------------;
; for example, read_22_23_x, read_22_24_x, read_e0_e1_x, etc.           ;
;-----------------------------------------------------------------------;
;  input : AH = reg to be read
;  output: AL = data read
;  register destroyed..AL
        public  read_isa_reg_x
read_isa_reg_x:
read_22_23_x:
        mov     al,ah
        out     22h,al
        jmp     $+2
        jmp     $+2
        in      al,23h
        jmp     $+2
        jmp     $+2
        jmp     di
;-----------------------------------------------------------------------;
;                               write_chip_reg_x                        ;
;-----------------------------------------------------------------------;
; for example, write_22_23_x, write_22_24_x, write_e0_e1_x, etc.        ;
;-----------------------------------------------------------------------;
;  input : AL = value to be write
;          AH = reg to be write
;  output: same as input
;  register destroyed..NONE
        public  write_isa_reg_x
write_isa_reg_x:
write_22_23_x:
        xchg    ah,al
        out     22h,al
        jmp     $+2
        jmp     $+2
        xchg    ah,al
        out     23h,al
        jmp     $+2
        jmp     $+2
        jmp     di

endif
endif
ifdef   rwbs
if  rwbs
;-----------------------------------------------------------------------;
	public	read_chip_byte_x
        public  read_bri_byte
        public  read_pci_byte
        public  read_sio_byte
        public  read_ide_byte
        public  read_usb_byte
        public  read_pmu_byte
;  input : AH = reg to be read
;  output: AL = data read
;  register destroyed..AL
read_chip_byte_x:
	push	dx		;;to balance the stack
        jmp     @f
read_bri_byte:
        push    dx
        mov     dx,1000h
        jmp     @f
read_pmu_byte:
        push    dx
        mov     dx,0900h
        jmp     @f
read_pci_byte:
        push    dx
        mov     dx,0000h
        jmp     @f
read_sio_byte:
        push    dx
        mov     dx,0800h
        jmp     @f
read_ide_byte:
        push    dx
        mov     dx,0900h
        jmp     @f
read_usb_byte:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      al,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     cl,al
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        mov     al,cl
        pop     cx
        pop     dx
        ret
endif
endif
ifdef   rwws
if   rwws
        public  read_pci_word
        public  read_sio_word
        public  read_ide_word
        public  read_usb_word
;  input : AH = reg to be read
;  output: BX = data read
;  register destroyed..BX
read_pci_word:
        push    dx
        mov     dx,0000h
        jmp     @f
read_sio_word:
        push    dx
        mov     dx,0800h
        jmp     @f
read_ide_word:
        push    dx
        mov     dx,0900h
        jmp     @f
read_usb_word:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h           ; AD16 , DEV 5
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      ax,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     cx,ax
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        mov     bx,cx
        pop     cx
        pop     dx
        ret
endif
endif
ifdef   rwdws
if   rwdws
        public  read_pci_dword
        public  read_sio_dword
        public  read_ide_dword
        public  read_usb_dword
;  input : AH = reg to be read
;  output:EBX = data read
;  register destroyed..EBX
read_pci_dword:
        push    dx
        mov     dx,0000h
        jmp     @f
read_sio_dword:
        push    dx
        mov     dx,0800h
        jmp     @f
read_ide_dword:
        push    dx
        mov     dx,0900h
        jmp     @f
read_usb_dword:
        push    dx
        mov     dx,0a00h
@@:
        push    ecx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h           ; AD16 , DEV 5
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      eax,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     ecx,eax
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        mov     ebx,ecx
        pop     ecx
        pop     dx
        ret
endif
endif
ifdef   rwbns
if   rwbns
        public  read_pci_byte_x
        public  read_pmu_byte_x
        public  read_sio_byte_x
        public  read_ide_byte_x
        public  read_usb_byte_x
;  input : AH = reg to be read
;          DI = return address
;  output: AL = data read
;  register destroyed..EAH,AL,CX, DX
read_pmu_byte_x:
        mov     dx,0900h
        jmp     @F
read_pci_byte_x:
        mov     dx,0000h
        jmp     @F
read_sio_byte_x:
        mov     dx,0800h
        jmp     @F
read_ide_byte_x:
        mov     dx,0900h
        jmp     @F
read_usb_byte_x:
        mov     dx,0a00h
@@:
        xchg    ah,al
        mov     cx,ax
        mov     ch,cl
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      al,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     ah,ch
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        jmp     di
endif
endif
ifdef   rwwns
if   rwwns
        public  read_pci_word_x
        public  read_sio_word_x
        public  read_ide_word_x
        public  read_usb_word_x
;  input : AH = reg to be read
;          DI = return address
;  output: BX = data read
;  register destroyed..EAH,AL,BX,CX, DX
read_pci_word_x:
        mov     dx,0000h
        jmp     @F
read_sio_word_x:
        mov     dx,0800h
        jmp     @F
read_ide_word_x:
        mov     dx,0900h
        jmp     @F
read_usb_word_x:
        mov     dx,0a00h
@@:
        xchg    ah,al
        mov     cx,ax
        mov     ch,al
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      ax,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     bx,ax
        mov     ah,ch
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        jmp     di
endif
endif
ifdef   rwdwns
if   rwdwns
        public  read_pci_dword_x
        public  read_sio_dword_x
        public  read_ide_dword_x
        public  read_usb_dword_x
;  input : AH = reg to be read
;          DI = return address
;  output:EBX = data read
;  register destroyed..EAH,AL,EBX,CX, DX
read_pci_dword_x:
        mov     dx,0000h
        jmp     @F
read_sio_dword_x:
        mov     dx,0800h
        jmp     @F
read_ide_dword_x:
        mov     dx,0900h
        jmp     @F
read_usb_dword_x:
        mov     dx,0a00h
@@:
        xchg    ah,al
        mov     cx,ax
        mov     ch,cl
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      eax,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     ebx,eax
        mov     ah,ch
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        jmp     di
endif
endif
ifdef   rwbs
if   rwbs
	public	write_chip_byte_x
        public  write_bri_byte
        public  write_pci_byte
        public  write_sio_byte
        public  write_ide_byte
        public  write_usb_byte
        public  write_pmu_byte
;  input : AH = reg to be written
;          AL = data to be written
;  output: none
;  register destroyed..NONE
write_chip_byte_x:
        push	dx			;;to balance the stack
        jmp     @f
write_bri_byte:
        push    dx
        mov     dx,1000h
        jmp     @f
write_pmu_byte:
        push    dx
        mov     dx,0900h
        jmp     @f
write_pci_byte:
        push    dx
        mov     dx,0000h
        jmp     @f
write_sio_byte:
        push    dx
        mov     dx,0800h
        jmp     @f
write_ide_byte:
        push    dx
        mov     dx,0900h
        jmp     @f
write_usb_byte:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        mov     al,ch                           ; Restore AH (data)
        out     dx,al
        jcxz    short $+2
        jcxz    short $+2
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        pop     cx
        pop     dx
        ret
endif
endif
ifdef   rwws
if   rwws
        public  write_pci_word
        public  write_sio_word
        public  write_ide_word
        public  write_usb_word
;  input : AH = reg to be written
;          BX = data to be written
;  output: none
;  register destroyed..NONE
write_pci_word:
        push    dx
        mov     dx,0000h
        jmp     @f
write_sio_word:
        push    dx
        mov     dx,0800h
        jmp     @f
write_ide_word:
        push    dx
        mov     dx,0900h
        jmp     @f
write_usb_word:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        mov     ax,bx
        out     dx,ax
        jcxz    short $+2
        jcxz    short $+2
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        pop     cx
        pop     dx
        ret
endif
endif
ifdef   rwdws
if   rwdws
        public  write_pmu_dword
        public  write_pci_dword
        public  write_sio_dword
        public  write_ide_dword
        public  write_usb_dword
;  input : AH = reg to be written
;         EBX = data to be written
;  output: none
;  register destroyed..NONE
write_pmu_dword:
        push    dx
        mov     dx,0900h
        jmp     @f
write_pci_dword:
        push    dx
        mov     dx,0000h
        jmp     @f
write_sio_dword:
        push    dx
        mov     dx,0800h
        jmp     @f
write_ide_dword:
        push    dx
        mov     dx,0900h
        jmp     @f
write_usb_dword:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        mov     eax,ebx
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        pop     cx
        pop     dx
        ret
endif
endif
ifdef   rwbns
if   rwbns
        public  write_pci_byte_x
        public  write_pmu_byte_x
        public  write_sio_byte_x
        public  write_ide_byte_x
        public  write_usb_byte_x
;  input : AH = reg to be written
;          AL = data to be written
;          DI = return address
;  output: none
;  register destroyed..EAH, CX, DX
write_pmu_byte_x:
        mov     dx,0900h
        jmp     @F
write_sio_byte_x:
        mov     dx,0800h
        jmp     @F
write_ide_byte_x:
        mov     dx,0900h
        jmp     @F
write_pci_byte_x:
        mov     dx,0000h
        jmp     @F
write_usb_byte_x:
        mov     dx,0a00h

@@:
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     ah,cl
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        xchg    al,ch                           ; Restore AH (data)
        out     dx,al
        jcxz    short $+2
        jcxz    short $+2
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        jmp     di
endif
endif
ifdef   rwwns
if   rwwns
        public  write_pci_word_x
        public  write_sio_word_x
        public  write_ide_word_x
        public  write_usb_word_x
;  input : AH = reg to be written
;          BX = data to be written
;          DI = return address
;  output: none
;  register destroyed..EAH, CX, DX
write_sio_word_x:
        mov     dx,0800h
        jmp     @F
write_ide_word_x:
        mov     dx,0900h
        jmp     @F
write_pci_word_x:
        mov     dx,0000h
        jmp     @F
write_usb_word_x:
        mov     dx,0a00h
@@:
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     ax,bx
        mov     bx,cx
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        out     dx,ax
        jcxz    short $+2
        jcxz    short $+2
        mov     cx,bx
        mov     bx,ax
        mov     ax,cx
        xchg    ah,al
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        jmp     di
endif
endif

ifdef   rwdwns
if  rwdwns
        public  write_pci_dword_x
        public  write_sio_dword_x
        public  write_ide_dword_x
        public  write_usb_dword_x
;  input : AH = reg to be written
;         EBX = data to be written
;          DI = return address
;  output: none
;  register destroyed..EAH, CX, DX
write_sio_dword_x:
        mov     dx,0800h
        jmp     @F
write_ide_dword_x:
        mov     dx,0900h
        jmp     @F
write_pci_dword_x:
        mov     dx,0000h
        jmp     @F
write_usb_dword_x:
        mov     dx,0a00h
@@:
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     eax,ebx
        mov     bx,cx
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     cx,bx
        mov     ebx,eax
        mov     ax,cx
        xchg    ah,al
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        jmp     di
endif
endif
ifdef   srwbs
if   srwbs
;-----------------------------------------------------------------------;
        public  sread_pci_byte
        public  sread_sio_byte
        public  sread_ide_byte
        public  sread_usb_byte
	public	sread_pmu_byte
;  input : AH = reg to be read
;  output: AL = data read
;  register destroyed..AL
sread_pmu_byte:
	push	dx
	mov	dx,0900h
	jmp	@f
sread_pci_byte:
        push    dx
        mov     dx,0000h
        jmp     @f
sread_sio_byte:
        push    dx
        mov     dx,0800h
        jmp     @f
sread_ide_byte:
        push    dx
        mov     dx,0900h
        jmp     @f
sread_usb_byte:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      al,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     cl,al
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        mov     al,cl
        pop     cx
        pop     dx
        ret
endif
endif
ifdef   srwws
if   srwws
        public  sread_pci_word
        public  sread_sio_word
        public  sread_ide_word
        public  sread_usb_word
;  input : AH = reg to be read
;  output: BX = data read
;  register destroyed..BX
sread_pci_word:
        push    dx
        mov     dx,0000h
        jmp     @f
sread_sio_word:
        push    dx
        mov     dx,0800h
        jmp     @f
sread_ide_word:
        push    dx
        mov     dx,0900h
        jmp     @f
sread_usb_word:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h           ; AD16 , DEV 5
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      ax,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     cx,ax
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        mov     bx,cx
        pop     cx
        pop     dx
        ret
endif
endif
ifdef    srwdws
if    srwdws
        public  sread_pci_dword
        public  sread_sio_dword
        public  sread_ide_dword
        public  sread_usb_dword
        public  sread_pmu_dword
;  input : AH = reg to be read
;  output:EBX = data read
;  register destroyed..EBX
sread_pmu_dword:
        push    dx
        mov     dx,0900h
        jmp     @f
sread_pci_dword:
        push    dx
        mov     dx,0000h
        jmp     @f
sread_sio_dword:
        push    dx
        mov     dx,0800h
        jmp     @f
sread_ide_dword:
        push    dx
        mov     dx,0900h
        jmp     @f
sread_usb_dword:
        push    dx
        mov     dx,0a00h
@@:
        push    ecx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h           ; AD16 , DEV 5
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        in      eax,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     ecx,eax
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        mov     ebx,ecx
        pop     ecx
        pop     dx
        ret
endif
endif

ifdef    srwbs
if    srwbs
        public  swrite_pci_byte
        public  swrite_sio_byte
        public  swrite_ide_byte
        public  swrite_usb_byte
        public  swrite_pmu_byte
;  input : AH = reg to be written
;          AL = data to be written
;  output: none
;  register destroyed..NONE
swrite_pmu_byte:
	push	dx
	mov	dx,0900h
	jmp	@f
swrite_pci_byte:
        push    dx
        mov     dx,0000h
        jmp     @f
swrite_sio_byte:
        push    dx
        mov     dx,0800h
        jmp     @f
swrite_ide_byte:
        push    dx
        mov     dx,0900h
        jmp     @f
swrite_usb_byte:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        mov     al,ch                           ; Restore AH (data)
        out     dx,al
        jcxz    short $+2
        jcxz    short $+2
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        pop     cx
        pop     dx
        ret
endif
endif
ifdef    srwws
if    srwws
        public  swrite_pci_word
        public  swrite_sio_word
        public  swrite_ide_word
        public  swrite_usb_word
;  input : AH = reg to be written
;          BX = data to be written
;  output: none
;  register destroyed..NONE
swrite_pci_word:
        push    dx
        mov     dx,0000h
        jmp     @f
swrite_sio_word:
        push    dx
        mov     dx,0800h
        jmp     @f
swrite_ide_word:
        push    dx
        mov     dx,0900h
        jmp     @f
swrite_usb_word:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        mov     ax,bx
        out     dx,ax
        jcxz    short $+2
        jcxz    short $+2
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        pop     cx
        pop     dx
        ret
endif
endif
ifdef    srwdws
if    srwdws
        public  swrite_pci_dword
        public  swrite_sio_dword
        public  swrite_ide_dword
        public  swrite_usb_dword
        public  swrite_pmu_dword
;  input : AH = reg to be written
;         EBX = data to be written
;  output: none
;  register destroyed..NONE
swrite_pmu_dword:
        push    dx
        mov     dx,0900h
        jmp     @f
swrite_pci_dword:
        push    dx
        mov     dx,0000h
        jmp     @f
swrite_sio_dword:
        push    dx
        mov     dx,0800h
        jmp     @f
swrite_ide_dword:
        push    dx
        mov     dx,0900h
        jmp     @f
swrite_usb_dword:
        push    dx
        mov     dx,0a00h
@@:
        push    cx
        push    eax
        xchg    ah,al
        mov     cx,ax
        and     eax,000000fch
        or      eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     cl,03h
        add     dl,cl
        mov     eax,ebx
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dx,0cf8h
        and     eax,07fffffffh
        out     dx,eax
        pop     eax
        pop     cx
        pop     dx
        ret
endif
endif

ifdef rwlm78
if rwlm78
	public write_lm78_byte
	public read_lm78_byte
;==================================================
;	Write LM78 register
;  input = ah : index ;    al :	data
;==================================================
write_lm78_byte proc near
	push	dx
	push	ax
	mov	dx, LM78_BASE_ADDRESS+05h	;
;@@:
;	in	al, dx
;	test	al,80h
;	jnz	@b

	pop	ax
	xchg	al, ah
	out	dx, al
	jmp	$+2
	jmp	$+2
	xchg	ah, al
	inc	dx
	out	dx,al
	pop	dx
	ret
write_lm78_byte endp
;==================================================
;==================================================
;	Read LM78 register
;  input = ah : index ;  output   al :	data
;==================================================
read_lm78_byte proc near
	push	dx
	push	ax
	mov	dx, LM78_BASE_ADDRESS+05h	;
;@@:
;	in	al, dx
;	test	al,80h
;	jnz	@b

	pop	ax
	mov	al, ah
	out	dx, al
	jmp	$+2
	jmp	$+2

	inc	dx
	in	al,dx
	pop	dx
	ret
read_lm78_byte endp
;==================================================
endif
endif

ifdef  srw23s
if  srw23s
;-----------------------------------------------------------------------;
;                       CHIPSET SPECIFIC SUBROUTINES                    ;
;-----------------------------------------------------------------------;
;                               read_chip_reg                           ;
;-----------------------------------------------------------------------;
; for example, read_22_23, read_22_24, read_e0_e1, etc.                 ;
;-----------------------------------------------------------------------;
;  input : AH = reg to be read
;  output: AL = data read
;  register destroyed..AL
        public  sread_22_23
        public  sread_isa_reg
sread_isa_reg:
sread_22_23:
        mov     ah,al
        out     22h,al
        jmp     $+2
        jmp     $+2
        in      al,23h
        jmp     $+2
        jmp     $+2
        ret
;-----------------------------------------------------------------------;
;                               write_chip_reg                          ;
;-----------------------------------------------------------------------;
; for example, write_22_23, write_22_24, write_e0_e1, etc.              ;
;-----------------------------------------------------------------------;
;  input : AL = value to be write
;          AH = reg to be write
;  output: same as input
;  register destroyed..NONE
        public  swrite_22_23
        public  swrite_isa_reg
swrite_isa_reg:
swrite_22_23:
        xchg    ah,al
        out     22h,al
        jmp     $+2
        jmp     $+2
        xchg    ah,al
        out     23h,al
        jmp     $+2
        jmp     $+2
        ret
endif
endif
if    0
;---------------------------------------------------------------;
;       Following routines are for chipsets with indexed        ;
;       BYTE registers.....                                     ;
;               * SET_REG_BIT_BYTE ... set a bit                ;
;               * RESET_REG_BIT_BYTE ... clear a bit            ;
;               * RW_CHIP_REG_BYTE ... set/clear selected bit(s);
;               * READ_pci_BYTE ... read the indexed reg        ;
;               * WRITE_pci_BYTE ... write the indexed reg      ;
;       If you want to use those routines, please uncomment those
;---------------------------------------------------------------;
;                       SET_REG_BIT_BYTE                        ;
;---------------------------------------------------------------;
;       Input : (AL) index of the reg for which                 ;
;                    some bit has to be set                     ;
;               (CL) bit# to be set                             ;
;               STACK PRESENT                                   ;
;       Output: NONE                                            ;
;       Register destroyed : NONE                               ;
; NOTE :                                                        ;
;  *  Use this routine to set a bit for a chipset indexed byte reg
;---------------------------------------------------------------;

set_reg_bit_byte       proc    near
        mov     dx,di
        pushns  edx
        mov     bx,0ff01h                       ; (dh) = 'AND' mask
        shl     bl,cl                           ; (dl) = 'OR' mask
        ret_sp  rw_chip_reg_byte                ;
        popns   edx
        mov     di,dx
        jmp     di
set_reg_bit_byte       endp

;---------------------------------------------------------------;
;                     RESET_REG_BIT_BYTE                        ;
;---------------------------------------------------------------;
;       Input : (AL) index of the reg for which                 ;
;                    some bit has to be cleared                 ;
;               (CL) bit# to clear                              ;
;               STACK PRESENT                                   ;
;       Output: NONE                                            ;
;       Register destroyed :                                    ;
; NOTE :                                                        ;
;  *  Use this routine to clear a bit for a chipset indexed byte;
;     register.                                                 ;
;---------------------------------------------------------------;

reset_reg_bit_byte_x   proc    near
        mov     dx,di
        pushns  edx
        mov     bx,0100h                        ; (dl) = 'OR' mask
        shl     bh,cl                           ; get in proper bit position
        not     bh                              ; (dh) = 'AND' mask
        ret_sp  rw_chip_reg_byte_ret            ;
        popns   edx
        mov     di,dx
        jmp     di
reset_reg_bit_byte_x   endp

;---------------------------------------------------------------;
;                      RW_CHIP_REG_BYTE                         ;
;---------------------------------------------------------------;
;       Input : (AL) index to the reg to change                 ;
;               (DL) OR mask                                    ;
;               (DH) AND mask                                   ;
;               STACK PRESENT                                   ;
;       Output: NONE                                            ;
;       Register destroyed :                                    ;
; NOTE :                                                        ;
;  *  Use this routine to change selected bit(s) for a chipset  ;
;     indexed byte register.                                    ;
;---------------------------------------------------------------;

rw_chip_reg_byte_ret   proc    near

       jmp_di  read_pci_byte_x                 ; (ah) = data read
       and     al,bh                           ; use 'AND' mask
       or      al,bl                           ; use 'OR' mask
       jmp_di  write_pci_byte_x                ;
       ret

rw_chip_reg_byte_ret   endp
endif


ifdef   excmos
if   excmos

;;============================
; input         : none
; output        : none
; register destroy: none
;;============================
public  open_extend_cmos
open_extend_cmos:
        cli
	push	ax
	mov	ah,45h			    ;
	call	read_sio_byte		    ;
	or	al,08h			    ;
	call	write_sio_byte		    ;
	pop	ax
	ret

;;============================
; input         : none
; output        : none
; register destroy: none
;;============================
public  close_extend_cmos
close_extend_cmos:
	push	ax
	mov	ah,45h			    ; enable APC
	call	read_sio_byte		    ;
	and	al,not 08h		    ;
	call	write_sio_byte		    ;
	pop	ax
;        sti
        ret
endif
endif

ifdef   apcmos
if   apcmos

;;============================
; input         : none
; output        : none
; register destroy: none
;;============================
public  open_apc_cmos
open_apc_cmos:
        cli
	push	ax
	mov	ah,44h			    ; enable APC
	call	read_sio_byte		    ;
	or	al,10h		    	    ;
	call	write_sio_byte		    ;

	call	read_sio_byte		    ;
	test	al,10h		    	    ;
	jnz	open_apc_exit		    ;
;A1_type_5595:					    ;
	mov	ah,45h			    ; enable APC
	call	read_sio_byte		    ;
	or	al,02h			    ;
	call	write_sio_byte		    ;
open_apc_exit:
	pop	ax
	ret

;;============================
; input         : none
; output        : none
; register destroy: none
;;============================
public  close_apc_cmos
close_apc_cmos:
	push	ax
	mov	ah,44h			    ; enable APC
	call	read_sio_byte		    ;
	test	al,10h		    	    ;
	jnz	disable_apc_a0		    ;

        mov	ah,45h			    ; enable APC
	call	read_sio_byte		    ;
	and	al,not 02h			    ;
	call	write_sio_byte		    ;
	jmp	close_apc_exit
disable_apc_a0:
	mov	ah,44h			    ; enable APC
	call	read_sio_byte		    ;
	and	al,not 10h			    ;
	call	write_sio_byte		    ;
close_apc_exit:
	pop	ax
;        sti
        ret
endif
endif
if 0
;;============================
; input         : ah - index
; output        : al - data
; register destroy: none
;;============================
read_cmos_byte:
        or      ah,080h
        xchg    ah,al
        out     70h,al
        jmp     $+2
        jmp     $+2
        xchg    ah,al
        in      al,71h
        and     ah,not 080h
        ret
;;============================
; input         : ah - index,al - data
; output        : none
; register destroy: none
;;============================
write_cmos_byte:
        or      ah,080h
        xchg    ah,al
        out     70h,al
        jmp     $+2
        jmp     $+2
        xchg    ah,al
        out     71h,al
        and     ah,not 080h
        ret
endif



