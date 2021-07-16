	page	,132
	title	VUMA / SMBA Shared Frame Buffer Runtime Hooks
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1995, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-263-8181                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;****************************************************************************;

;---------------------------------------;

	include	setupequ.ext
	include rt.equ
	include makeflag.equ

;---------------------------------------;

	public FrameBufSetSize
	public FrameBufGetCurSize
	public FrameBufGetCurAddress
	public FrameBufSetCmosData
	public FrameBufGetCmosData
	public FrameBufMakeInvisible
	public FrameBufMakeVisible
	public FrameBufGetFbBanks
	public FrameBufGetMinMaxSize
	public FrameBufGetBankMemSize
	public FrameBufGetBankMemSpeed
	public FrameBufGetBankMemType
	public FrameBufGetAsymMemInfo

if MKF_VUMA_SUPPORT
	public FrameBufGetAllBanks
	public FrameBufGetCurBanks
	public FrameBufGetVisibility
	public FrameBufGetChipsetInfo
	public FrameBufGetMemCtrlSpeed
	public FrameBufGetBankVoltage
	public FrameBufGetBankTimingInfo
	public FrameBufGetBankAddress
	public FIND_FREQUENCY
	public DRAM_CONTROL_CYCLE
endif

if MKF_SMBA_SUPPORT
	public FrameBufSetMemHoleOverlap
	public FrameBufGetMemHoleInfo
	public FrameBufGetHostBusSpeed
endif

;---------------------------------------;

	extrn	get_cmos_item: near
	extrn	set_cmos_item: near
        extrn	read_pci_byte: near

;---------------------------------------;

cgroup	group	_text
_text 	segment word public 'CODE'
	assume	cs:cgroup
.386


if MKF_SMBA_SUPPORT

;---------------------------------------------------------------------------
; SMBA Memory Bank
;---------------------------------------------------------------------------
	db	'$$CT'			; table signature for BCP
	db	01h			; version number of the table
	db	'SMBA Memory Bank', 0	; ASCIIZ string specifying the chipset
					; name or anything specific like
					; "table for 50MHz clock", etc. this
					; string will be displayed by BCP.
	dw	offset cgroup:SmbaBankNumberEnd ; ptr to end of table+1
	db	00h			; attribute
					; bit-0 = 0..byte register
					;	  1..word register
					; bit-1 = 0..byte data
					;	  1..word data
	db	'Bank #',0
	db	'Reserved',0

SmbaBankNumber	label	byte

;		Bank #		Reserved
;  this should tell BIOS which memory bank is used by SMBA Video
	db	03h,		00h	; bank3 used by SMBA Video
SmbaBankNumberEnd	label	byte

endif

;******************************************************************************;
;                                                                              ;
;                  Chipset Hooks Needed by Both VUMA and SMBA                  ;
;                                                                              ;
;******************************************************************************;

;---------------------------------------;
; FrameBufSetSize                       ;
;---------------------------------------;--------------------------------------;
; This function sets the size and bank usage of the VUMA/SMBA shared frame     ;
; buffer memory area.                                                          ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input:  DX = Size of shared frame buffer memory area in units of 64k         ;
;         BX = Bitmap of memory banks that can be used (0000h if only the top  ;
;              memory bank may be used as in SMBA)                             ;
;                  Bit 0: If set, bank 0 can be used by VUMA/SMBA              ;
;                  Bit 1: If set, bank 1 can be used by VUMA/SMBA              ;
;                  ...                                                         ;
;                  Bit 15: If set, bank 15 can be used by VUMA/SMBA            ;
;                                                                              ;
; Output: CF = Clear if function was successful, set if error                  ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufSetSize	proc near
	stc				;Indicate error
	ret
FrameBufSetSize	endp


;---------------------------------------;
; FrameBufGetCurSize                    ;
;---------------------------------------;--------------------------------------;
; This function gets the current size of the VUMA/SMBA shared frame buffer     ;
; memory area.                                                                 ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: DX = Size of shared frame buffer memory area in units of 64k.  The   ;
;              value 0000h means shared frame buffer is disabled.              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetCurSize	proc near
	push	ax
	push	cx
	xor	dx, dx
        mov     ah, 063h		; DRAM Status Register
        call    read_pci_byte
	test	al,040h
	jz	short @f
	and	al,00110000b
	jz	short @f
	shr	al,4h
	mov     cl,al
	mov	dl,10h			; dx=10h= 16*64K = 1024k = 1M
	shl	dx,cl
@@:
	pop	cx
	pop	ax
	ret
FrameBufGetCurSize	endp


;---------------------------------------;
; FrameBufGetCurAddress                 ;
;---------------------------------------;--------------------------------------;
; This function returns the current physical address of VUMA/SMBA shared frame ;
; buffer.                                                                      ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: EAX = Physical address of VUMA/SMBA frame buffer                     ;
;	  CF  = Clear if function was successful, set if error                 ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
	extrn	get_bank_size:near
FrameBufGetCurAddress	proc near
	push	edx
	sub	ax,ax			; RAS 0
	call	get_bank_size
	push	ax
	mov	ah,60h
	call	read_pci_byte
	test	al,20h			; Check Single/Double Sides?
	pop	ax
	jz	short @f
	shr	ax,1
@@:
	shl	eax,20			; change from 1M to physical

	call	FrameBufGetCurSize
	shl	edx,16			; change from 64K to physical

	sub	eax,edx			; CF = 0
	pop	edx
	ret
FrameBufGetCurAddress	endp

;---------------------------------------;
; FrameBufSetCmosData                   ;
;---------------------------------------;--------------------------------------;
; This function writes the given VUMA/SMBA frame buffer size and flags into    ;
; CMOS.  For VUMA and SMBA there should be a setup question that looks like    ;
; the one below (add more size options if the chipset supports them).  Use     ;
; the set_cmos_item function to write to CMOS.                                 ;
;                                                                              ;
;       Question (Q_FRAME_BUF_SIZE)                                            ;
;               Text    = "Frame Buffer Size"                                  ;
;               Options = "Disabled",                                          ;
;                         "1MB":DEFAULT:POWERON,                               ;
;                         "2MB"                                                ;
;       EndQuestion                                                            ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input: CH = Flags                                                            ;
;             Bit 0: If set, frame buffer overlaps memory hole                 ;
;                    If clear, frame buffer does not overlap memory hole       ;
;             Bit 7-1: Reserved                                                ;
;        DX = Size of shared frame buffer memory in units of 64k               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufSetCmosData	proc near
;  DX may be converted to a small number representing one of the values
;     that the chipset supports
;  CH bit 0 needs to be saved in CMOS for SMBA only (it is always 0
;     under VUMA)
	ret
FrameBufSetCmosData	endp


;---------------------------------------;
; FrameBufGetCmosData                   ;
;---------------------------------------;--------------------------------------;
; This function reads the current VUMA/SMBA frame buffer size and flags from   ;
; CMOS.  For VUMA and SMBA there should be a setup question that looks like    ;
; the one below (add more size options if the chipset supports them).  Use     ;
; the get_cmos_item function to read from CMOS.                                ;
;                                                                              ;
;       Question (Q_FRAME_BUF_SIZE)                                            ;
;               Text    = "Frame Buffer Size"                                  ;
;               Options = "Disabled",                                          ;
;                         "1MB":DEFAULT:POWERON,                               ;
;                         "2MB"                                                ;
;       EndQuestion                                                            ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: DX = Size of shared frame buffer memory in units of 64k              ;
;         CH = Flags                                                           ;
;              Bit 0: If set, frame buffer overlaps memory hole                ;
;                     If clear, frame buffer does not overlap memory hole      ;
;              Bit 6-1: Reserved                                               ;
;              Bit 7: If set, BIOS supports VUMA calls                         ;
;                     If clear, BIOS supports SMBA calls                       ;
;                     Both VUMA and SMBA may be supported in one BIOS, but one ;
;                     interface must be the primary interface at any given time;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetCmosData	proc near

;  DX comes from CMOS but not all 16 bits need to be stored because the
;     chipset probably supports only a limited number of possible sizes
;  CH bit 0 comes from CMOS for SMBA only (it can always be returned as
;     0 under VUMA)
;  CH bit 7 can always be returned as 1 for VUMA or 0 for SMBA
	xor	dx, dx
	xor	ch, ch
	ret
FrameBufGetCmosData	endp


;---------------------------------------;
; FrameBufMakeVisible                   ;
;---------------------------------------;--------------------------------------;
; This function should make the VUMA/SMBA shared frame buffer memory visible   ;
; to the CPU.                                                                  ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufMakeVisible	proc near
	ret
FrameBufMakeVisible	endp


;---------------------------------------;
; FrameBufMakeInvisible                 ;
;---------------------------------------;--------------------------------------;
; This function should make the VUMA/SMBA shared frame buffer memory invisible ;
; to the CPU.                                                                  ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufMakeInvisible	proc near
	ret
FrameBufMakeInvisible	endp


;---------------------------------------;
; FrameBufGetFbBanks                    ;
;---------------------------------------;--------------------------------------;
; This function returns which memory banks can be used by a VUMA/SMBA device.  ;
; The return value may depend on which banks are populated with memory.        ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: AX = Bitmap of memory banks that can support a VUMA/SMBA device.     ;
;              Set this value to 0000h to force VUMA/SMBA support to disabled. ;
;              Otherwise: Bit 0: If set, bank 0 can be used by VUMA/SMBA       ;
;                         Bit 1: If set, bank 1 can be used by VUMA/SMBA       ;
;                         ...                                                  ;
;                         Bit 15: If set, bank 15 can be used by VUMA/SMBA     ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetFbBanks	proc near
	xor	ax, ax
	ret
FrameBufGetFbBanks	endp


;---------------------------------------;
; FrameBufGetMinMaxSize                 ;
;---------------------------------------;--------------------------------------;
; This function returns the minimum and maximum VUMA/SMBA frame buffer size,   ;
; as well as its granularity.                                                  ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: BX = Minimum amount of memory that can be allocated to frame         ;
;              buffer in units of 64K                                          ;
;         CX = Maximum amount of memory that can be allocated to frame         ;
;              buffer in units of 64K                                          ;
;         DI = Granularity of memory that can be allocated to frame            ;
;              buffer in units of 64K                                          ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetMinMaxSize	proc near
	xor	bx, bx			;Assume min mem size is 0
	xor	cx, cx			;Assume max mem size is 0
	xor	di, di			;SMB granularity in 64kb
	ret
FrameBufGetMinMaxSize	endp


;---------------------------------------;
; FrameBufGetBankMemSize                ;
;---------------------------------------;--------------------------------------;
; This function returns the amount of memory installed in the given bank.      ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input:  CL = Memory bank number in the range 00h - 0Fh                       ;
;                                                                              ;
; Output: AX = Amount of memory installed in bank in units of 64K              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetBankMemSize	proc near
	xor	al,al	        ; SiS always using RAS0
	call	get_bank_size   ;; only return ond side size
	shl	ax,4h		; ax in 64k
	ret
FrameBufGetBankMemSize	endp


;---------------------------------------;
; FrameBufGetBankMemSpeed               ;
;---------------------------------------;--------------------------------------;
; This function returns the speed of memory installed in the given bank.  If   ;
; this system supports just one global memory speed setting for all banks (i.e.;
; one setup question for 70ns/60ns), then just ignore the bank number input    ;
; and return the global value.                                                 ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input:  CL = Memory bank number in the range 00h - 0Fh                       ;
;                                                                              ;
; Output: AL = Speed of memory in nanoseconds                                  ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetBankMemSpeed	proc near
	mov	al, 70d			;70ns
	ret
FrameBufGetBankMemSpeed	endp


;---------------------------------------;
; FrameBufGetBankMemType                ;
;---------------------------------------;--------------------------------------;
; This function returns the type of memory that is installed in a given bank.  ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input:  CL = Memory bank number in the range 00h - 0Fh                       ;
;                                                                              ;
; Output: AL = Memory type                                                     ;
;                0 = Empty                                                     ;
;                1 = Fast page mode                                            ;
;                2 = EDO                                                       ;
;                3 = SDRAM                                                     ;
;                4 = PN EDO (Burst EDO)                                        ;
;                5-F = Reserved                                                ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetBankMemType	proc near
	mov	al,03h		; always SDRAM
	ret
FrameBufGetBankMemType	endp


;---------------------------------------;
; FrameBufGetAsymMemInfo                ;
;---------------------------------------;--------------------------------------;
; This function returns a flag that indicates if the given bank is populated   ;
; with asymetrical memory and the geometry of that memory.                     ;
;                                                                              ;
; NOTE: This function is needed in both VUMA and SMBA.                         ;
;                                                                              ;
; Input:  CL = Memory bank number in the range 00h - 0Fh                       ;
;                                                                              ;
; Output: ;BL = Asymetric flag                                                  ;
;         ;      00h = Normal (symetric memory)                                 ;
;         ;      01h = Asymetric memory                                         ;
;	  BL = MA table delection
;         DL = Number of column address lines in asymetric memory (value is    ;
;              not used if BL=00h)                                             ;
;         DH = Number of row address lines in asymetric memory (value is       ;
;              not used if BL=00h)                                             ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetAsymMemInfo	proc near
	push	ax
	push	bx

        mov     ah,060h
        call    read_pci_byte
        and     ax,0fh			; it is dram type
	shl	ax,1

        mov     bx,offset cgroup:sdram_CASRAS_translate_table
	add	bx,ax
	mov	dx,cs:[bx]
	shr	ax,1
	pop	bx
	mov	bl,al

	pop	ax
	ret
FrameBufGetAsymMemInfo	endp

sdram_CASRAS_translate_table     label   byte
                dw    0c08h               ; 12*8
                dw    0e08h               ; 14*8
                dw    0e08h               ; 14*8
                dw    0f08h               ; 15*8
                dw    0c09h               ; 12*9
                dw    0e09h               ; 14*9
                dw    0e09h               ; 14*9
                dw    0f09h               ; 15*9
                dw    0c0ah               ; 12*10
                dw    0e0ah              ; 14*10
                dw    0e0ah              ; 14*10
                dw    0f0ah              ; 15*10
                dw    0d08h              ; 13*8
sdram_CASRAS_translate_table_end label   byte
;;===================================================

;******************************************************************************;
;                                                                              ;
;                      Chipset Hooks Needed by VUMA Only                       ;
;                                                                              ;
;******************************************************************************;

if MKF_VUMA_SUPPORT

;---------------------------------------;
; FrameBufGetAllBanks                   ;
;---------------------------------------;--------------------------------------;
; This function returns a bitmap indicating which memory banks the chipset     ;
; supports.  This bitmap does not depend on which banks are currently          ;
; populated or empty.                                                          ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: AX = Bitmap of banks supported by chipset                            ;
;                  Bit 0: If set, bank 0 is supported by chipset               ;
;                  Bit 1: If set, bank 1 is supported by chipset               ;
;                  ...                                                         ;
;                  Bit 15: If set, bank 15 is supported by chipset             ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetAllBanks	proc near
	ret
FrameBufGetAllBanks	endp


;---------------------------------------;
; FrameBufGetCurBanks                   ;
;---------------------------------------;--------------------------------------;
; This function returns a bitmap indicating which memory bank(s) are currently ;
; is use by the frame buffer.                                                  ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: CX = Bitmap of banks currently used by frame buffer                  ;
;                  Bit 0: If set, bank 0 is in use by the frame buffer         ;
;                  Bit 1: If set, bank 1 is in use by the frame buffer         ;
;                  ...                                                         ;
;                  Bit 15: If set, bank 15 is in use by the frame buffer       ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetCurBanks	proc near
	mov	cx,01h			; Bank 0
	ret
FrameBufGetCurBanks	endp


;---------------------------------------;
; FrameBufGetVisibility                 ;
;---------------------------------------;--------------------------------------;
; This function returns a flag indicating whether or not the frame buffer is   ;
; currently visible to the CPU.                                                ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: BH = 00h if frame buffer memory is currently not visible to the CPU  ;
;              01h if frame buffer memory is currently visible to the CPU      ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetVisibility	proc near
	xor	bh,bh
	ret
FrameBufGetVisibility	endp


;---------------------------------------;
; FrameBufGetChipsetInfo                ;
;---------------------------------------;--------------------------------------;
; This function return miscellaneous flags and information about the chipset's ;
; capabilities.                                                                ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: DL = Flags                                                           ;
;              Bit 0: Set if chipset supports non-cachable regions             ;
;              Bit 1: Set if chipset supports write-thru cache regions         ;
;              Bit 2: Set if chipset supports enable/disable cache at runtime  ;
;              Bit 3: Set if chipset supports enable/disable write-thru cache  ;
;                     at runtime                                               ;
;              Bit 4: Set if chipset supports snooping (this bit is relevant   ;
;                     only if synchronous DRAM is installed)                   ;
;              Bit 5-7: Reserved                                               ;
;         SI = Chipset's non-cache region granularity in units of 64K          ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetChipsetInfo	proc near
	ret
FrameBufGetChipsetInfo	endp


;---------------------------------------;
; FrameBufGetMemCtrlSpeed               ;
;---------------------------------------;--------------------------------------;
; This function returns the speed of the system's memory controller in         ;
; nanoseconds.                                                                 ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: DH = Speed of the system's memory controller in nanoseconds          ;
;              (return 00h if unknown)                                         ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetMemCtrlSpeed	proc near
	mov	dh, 0
	ret
FrameBufGetMemCtrlSpeed	endp


;---------------------------------------;
; FrameBufGetBankVoltage                ;
;---------------------------------------;--------------------------------------;
; This function returns the supply voltage of the memory installed in the given;
; memory bank as well as a flag indicating the presence of external buffers on ;
; the given DRAM bank.                                                         ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  CL = Memory bank number in the range 00h - 0Fh                       ;
;                                                                              ;
; Output: AL = Memory voltage in tenths of a volt (i.e. 50d = 5 volts)         ;
;              Return 00h if memory voltage is unknown                         ;
;         AH = External buffering of DRAM bank                                 ;
;                 00h = Unknown                                                ;
;                 01h = Bank has external buffer                               ;
;                 02h = Bank does not have external buffer                     ;
;                 03h = Reserved                                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetBankVoltage	proc near
	xor	ax,ax
	ret
FrameBufGetBankVoltage	endp


;---------------------------------------;
; FrameBufGetBankTimingInfo             ;
;---------------------------------------;--------------------------------------;
; This function returns various timing parameters for the given bank.  If the  ;
; system supports only one set of global timing values for all banks of memory,;
; then ignore the bank number input and always return the global values.       ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  CL = Memory bank number in the range 00h - 0Fh                       ;
;                                                                              ;
; Output: AL = Memory timing information                                       ;
;               Bit 7-5: Reserved                                              ;
;               Bit 4:   Burst order                                           ;
;                          0 = Interleave burst order                          ;
;                          1 = Sequential burst order                          ;
;               Bit 3-2: Burst size                                            ;
;                          00 = 1 Byte                                         ;
;                          01 = 2 Bytes                                        ;
;                          10 = 4 Bytes                                        ;
;                          11 = Unknown                                        ;
;               Bit 1-0: CAS latency in CPU clocks                             ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetBankTimingInfo	proc near
	push	bx
	mov	ah,5dh
	call	read_pci_byte
	and	al,08h
	shr	al,3
	mov	bl,al			; cas latency

	or 	bl,08h			; Burst = 4 bytes

	mov	ah,51h
	call	read_pci_byte
	and	al,04h
	shl	al,2
	xor	al,00010000b		;
	or	bl,al			; linear/toggle= 0/1

	mov	al,bl
	pop	bx
	ret
FrameBufGetBankTimingInfo	endp


;---------------------------------------;
; FrameBufGetBankAddress                ;
;---------------------------------------;--------------------------------------;
; This function returns the start address of the memory occupying the given    ;
; bank.                                                                        ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for VUMA support.  SMBA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  CL = Memory bank number in the range 00h - 0Fh                       ;
;                                                                              ;
; Output: EAX = Absolute 32 bit address of memory in bank CL                   ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetBankAddress	proc near
	ret
FrameBufGetBankAddress	endp


;---------------------------------------;
;       FIND_FREQUENCY                  ;
;---------------------------------------;-------------------------------------;
; Input:  None                                                                ;
; Output: AH = 0/1/2/3 for 66/75/83/100 Mhz                                   ;
; Register destroyed: AX                                                      ;
;-----------------------------------------------------------------------------;
	extrn	check_100mhz_cpu_bus:near
Find_frequency proc near
	call	check_100mhz_cpu_bus
	mov	ah,03			; 100Mhz
	jz	short @f
	mov	ah,0			; 66 Mhz
@@:
        ret
Find_frequency endp


;---------------------------------------;
;       DRAM CONTROLL CYCLE             ;
;---------------------------------------;-------------------------------------;
; Input:  None                                                                ;
; Output: AL(bit0) = 1 enabe one cycle read				      ;
;         AL(bit1) = 1 enabe one cycle write			              ;
; Register destroyed: AX                                                      ;
;-----------------------------------------------------------------------------;
dram_control_cycle proc near
if (MKF_CUSTOMER eq 7788)
	xor	ah,ah
	mov	al,Q_VGA_WRITE_CYCLE
	call	check_cmos_data_far	; AL = 00 disabled, 01 enabled
	shl	al,01h
	or	ah,al

	mov	al,Q_VGA_READ_CYCLE
	call	check_cmos_data_far	; AL = 00 disabled, 01 enabled
	xor	al,01h
	or 	ah,al
else
	mov	ah,63h
	call	read_pci_byte
	and	al,7
	cmp	al,7
	jz	disable_read_write_cycle
	mov	ah,02h
	jmp	short @f
disable_read_write_cycle:
	mov	ah,01h
@@:
endif
        ret
dram_control_cycle endp

;---------------------------------------;
; check_cmos_data_far                   ;
;---------------------------------------;--------------------------------------;
; This function returns the value of the given setup item.                     ;
;                                                                              ;
; Input:  AL = setup question structure#                                       ;
;                                                                              ;
; Output: ZF = Set if it is disabled in CMOS setup                             ;
;              Clear if it is enabled in CMOS setup                            ;
;	  AL = right justified value of the given setup item                   ;
;                                                                              ;
; Destroys: AX                                                                 ;
;------------------------------------------------------------------------------;
	public	check_cmos_data_far
check_cmos_data_far	proc	near
	db	9ah			; CALL FAR F000:EED5
	dw	0eed5h
	dw	0f000h
	ret
check_cmos_data_far	endp

endif  ; MKF_VUMA_SUPPORT

;******************************************************************************;
;                                                                              ;
;                      Chipset Hooks Needed by SMBA Only                       ;
;                                                                              ;
;******************************************************************************;

if MKF_SMBA_SUPPORT

;---------------------------------------;
; FrameBufSetMemHoleOverlap             ;
;---------------------------------------;--------------------------------------;
; This function determines if the SMBA shared frame buffer overlaps the memory ;
; hole.  The new setting takes effect immediately.  This function does not     ;
; need to modify the overlap setting in CMOS (the caller will handle this).    ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for SMBA support.  VUMA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  BX = Bit 0: If set, frame buffer overlaps memory hole                ;
;                     If clear, frame buffer does not overlap memory hole      ;
;              Bit 1-15: Reserved                                              ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufSetMemHoleOverlap	proc near
	ret
FrameBufSetMemHoleOverlap	endp

;---------------------------------------;
; FrameBufGetMemHoleInfo                ;
;---------------------------------------;--------------------------------------;
; This function returns information about the current state of the memory hole.;
;                                                                              ;
; NOTE: This function only needs to be implemeted for SMBA support.  VUMA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: DX = Memory hole information                                         ;
;              Bit 15: If set, memory hole overlaps frame buffer               ;
;              Bit 14-2: Reserved                                              ;
;              Bit 1-0: 00 = Memory hole is disabled                           ;
;                       01 = Reserved                                          ;
;                       10 = Memory hole is 1MB at 15MB                        ;
;                       11 = Memory hole is 2MB at 14MB                        ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetMemHoleInfo	proc near
	xor	dx, dx
	ret
FrameBufGetMemHoleInfo	endp

;---------------------------------------;
; FrameBufGetHostBusSpeed               ;
;---------------------------------------;--------------------------------------;
; This function returns the speed of the system's host bus (CPU bus).          ;
;                                                                              ;
; NOTE: This function only needs to be implemeted for SMBA support.  VUMA      ;
;       support does not use this function.                                    ;
;                                                                              ;
; Input:  Nothing                                                              ;
;                                                                              ;
; Output: AL =  Host bus clock frequency                                       ;
;                 00h = Host bus clock frequency unknown                       ;
;                 01h = 50 MHz                                                 ;
;                 02h = 60 MHz                                                 ;
;                 03h = 66 MHz                                                 ;
;                 04h - FFh = Reserved                                         ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufGetHostBusSpeed	proc near
	xor	al, al
	ret
FrameBufGetHostBusSpeed	endp

endif     ; MKF_SMBA_SUPPORT

;---------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1995, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-263-8181                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
_text	ends
	end
