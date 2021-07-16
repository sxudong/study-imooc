;-----------------------------------------------------------------------;
;			ECC test begin					;
;-----------------------------------------------------------------------;
ECC_PATTERN1           EQU     0FFFFFFFEH
ECC_PATTERN2           EQU     0FFFFFFFFH
;-----------------------------------------------------------------------;
	extrn	read_pci_byte:near
	extrn	write_pci_byte:near
	extrn	open_extend_cmos:near
	extrn	close_extend_cmos:near
ecc_test:
;; ECC test begin			;
	jmp_di	ecc_parity_test		; Z=1 no bank have parity bit
	jz  	ecc_test_exit    
;; Enable_ecc_function
	jmp_di	enable_ecc_function	; input = bh
	jz  	ecc_test_exit    

ecc_init:
;; Clear 0 ~ 704k  (00000h ~ AFFFFh)
	mov	ax,6ad0h		; Enable SMRAM Writeable
	jmp_di	write_pci_byte_x

	mov	ah,64h			; A20# Enable
	jmp_di	read_sio_byte_x
	or	al,02h
	jmp_di	write_sio_byte_x

	sub	eax,eax
        xor	edi,edi
	mov	ecx,0b0000h/4
	db	67h
	rep	stosd

;; Clear B0000h~B7FFFFh
	mov	ax,6a90h		
	jmp_di	write_pci_byte_x

	sub	eax,eax
	mov	edi,0e0000h	   ; e000:0 ==> b000:0
	mov	ecx,8000h/4
	db	67h
	rep	stosd

	mov	ax,6a00h		; Disable SMRAM Writeable
	jmp_di	write_pci_byte_x

	mov	ah,64h			; Disable A20#
	jmp_di	read_sio_byte_x
	and	al,not 02h
	jmp_di	write_sio_byte_x

	mov	ax,072ffh		; write enable shadow ram C~D
	jmp_di	write_pci_byte_x
	mov	ax,0731fh		; write enable shadow ram E~F
	jmp_di	write_pci_byte_x

;; Clear C0000h~FFFFFh
	sub	eax,eax
	mov	edi,0c0000h
	mov	ecx,40000h/4
	db	67h
	rep	stosd

	mov	ax,07200h		; write disable shadow ram C~D
	jmp_di	write_pci_byte_x
	mov	ax,07300h		; write disable shadow ram E~F
	jmp_di	write_pci_byte_x

;; Clear 100000h~Top Memory
	sub	eax,eax
	mov	edi,100000h		;
	sub	esi,100000h 		; total size in esi
	shr	esi,2
	mov	ecx,esi
	db	67h
	rep	stosd

ecc_test_exit:
	jmp 	ecc_test_end

;----------------------------------------------------------------;
;	Enbale ECC test function 				 ;
;	Output : bh ( Bank enable number)			 ;
;                Bank0 : bit 0 = 1				 ;
;                Bank1 : bit 1 = 1				 ;
;                Bank2 : bit 2 = 1				 ;
;----------------------------------------------------------------;
ecc_parity_test:
.586p
	bswap	edi
.486p
	xor	ebx,ebx

	mov	ah,63h			; read bank register
	jmp_di	read_pci_byte_x		;

        ror	ebx,16			; store in high word of ebx
	mov	bx,ax			;
	ror	ebx,16			;

        mov	ah,74h			;
	jmp_di	read_pci_byte_x		;
	or	al,00111111b
	jmp_di	write_pci_byte_x	;

        ror	ebx,16			; store in high word of ebx
	mov	ax,bx			;
	ror	ebx,16			;
;;;;;;;;;;;
	mov	bl,01h			; don't change bl,cl
bank_test:				; test bank exit or not?
	test	al,bl			; AL read from bank register(63h)
	jnz	short parity_test		; BL bank test bit
	test	bl,08h			; if no bank exit
	jnz	bank_test_exit		;
	shl	bl,1			;
	jmp	short bank_test		;

parity_test:				;
	mov	al,bl			;
	mov	ah,63h
	jmp_di	write_pci_byte_x	; enable only one bank

        MOV     DWORD PTR ES:[00h], ECC_PATTERN1   ;WRITE MEMORY
        MOV     DWORD PTR ES:[04h], ECC_PATTERN2   ;WRITE MEMORY

        mov	ah,75h			; Enbale ECC test Data for test mode
	jmp_di	read_pci_byte_x		;
        or	al,80h			;
	jmp_di	write_pci_byte_x	;

        mov	ah,74h			; Enable ECC test mode
	jmp_di	read_pci_byte_x		;
        or	al,40h			;
	jmp_di	write_pci_byte_x	;

        CMP     DWORD PTR ES:[00h], ECC_PATTERN1   ;Z=1 mean Parity bit exist
	jnz	@f
        CMP     DWORD PTR ES:[04h], ECC_PATTERN2   ;Z=1 mean Parity bit exist
	jnz	@f
	or	bh,bl
@@:
        mov	ah,75h			; disable ECC test Data for test mode
	jmp_di	read_pci_byte_x		;
        and	al,not 80h		;
	jmp_di	write_pci_byte_x	;

        mov	ah,74h			; disable ECC Test Mode And Function
	jmp_di	read_pci_byte_x		;
        and	al,not 40h		;
	jmp_di	write_pci_byte_x	;

	shl	bl,1  			;
	ror	ebx,16
	mov	ax,bx
	ror	ebx,16
	jmp	bank_test

bank_test_exit:
	jmp_di	write_pci_byte_x	; store EAX back to bank register

        mov	ah,74h			; enable ECC FUNCTION
	jmp_di	read_pci_byte_x		;
	and	al,11000000b
	jmp_di	write_pci_byte_x		;

.586p
	bswap	edi
.486p
	or	bh,bh
	jmp	di
;----------------------------------------------------------------;
;----------------------------------------------------------------;
;----------------------------------------------------------------;
enable_ecc_function:
.586p
	bswap	edi
.486p
;; check coms check_cmos_8e
	mov	al,8eh			; cmos reg 0Eh
	ret_sp	cmos_data_in
	test	al,0c0h	    		; CMOS Good?
	jnz	close_extend_cmos_for_ecc; Br, if CMOS Bad

;;;open_extend_cmos
	mov	ah,45h
	jmp_di	read_sio_byte_x
	or	al,08h
	jmp_di	write_sio_byte_x

	mov	al,080h			
	ret_sp	cmos_data_in
;	mov	ah,al
;	shr	ah,4
;	and	al,0fh
	db	0d4h,10h			; AAM 10h
	xor	ah,al
	cmp	ah,0fh
	mov	bl,0				; ECC Disable
	jnz	short close_extend_cmos_for_ecc 
	shr	al,1
	and	bh,al
	jz	short close_extend_cmos_for_ecc

	sub	ax,ax
	mov	bl,0c0h
	mov	cx,03h
@@:
	rol	bl,02h
	shr	bh,01h
	jnc	next
	or 	al,bl
next:
	loop	@b

	mov	bl,al
        mov	ah,74h			; enable ECC FUNCTION
	jmp_di	read_pci_byte_x		;
	and	al,11000000b
        or	al,bl			;
	jmp_di	write_pci_byte_x		;

close_extend_cmos_for_ecc:
;;;close_extend_cmos
	mov	ah,45h
	jmp_di	read_sio_byte_x
	and	al,not 08h
	jmp_di	write_sio_byte_x
.586p
	bswap	edi
.486p
	or	bl,bl
	jmp	di

get_total_memory_size:
	sub	si,si

	mov	ah,60h
get_bank_size:
	mov	bx,ax
	mov	ah,63h
        jmp_di	read_pci_byte_x
	mov	dx,ax
	mov	ax,bx
	movzx	cx,ah
	sub	cl,60h
	bt	dx,cx
	jnc	no_dram_installed
;; Read DRAM Size
	jmp_di	read_pci_byte_x
	mov	cl,al
	mov	ch,al			; CH for check DRAM side
        and     al,0fh			; it is DRAM Type

        test    cl,80h                  ; Check DRAM Mode
        jnz     mode_is_sdram
;;the bank is EDO or FP
        mov     bx,offset cgroup:dram_size_translate_table
        jmp     short get_size
mode_is_sdram:
;;the bank is SDRAM
        mov     bx,offset cgroup:sdram_size_translate_table 
get_size:
        db      2eh			; CS:
    	xlat

	movzx	dx,al

	shl	dx,1

	test	ch,00100000b
	jz	got_dram_size
	shl	dx,1
got_dram_size:
	add	si,dx
no_dram_installed:

	inc	ah
	cmp	ah,63h
	jb	get_bank_size
        shl	esi,20
	ret

dram_size_translate_table     label   byte
                db   1                   ; 9*9
                db   4                   ; 10*10
                db   16                  ; 11*11
                db   64                  ; 12*12
                db   4                   ; 12*8
                db   8                   ; 12*9
                db   16                  ; 12*10
                db   32                  ; 12*11
                db   2                   ; 10*9
                db   4                   ; 11*9
                db   8                   ; 11*10
dram_size_translate_table_end label   byte
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

