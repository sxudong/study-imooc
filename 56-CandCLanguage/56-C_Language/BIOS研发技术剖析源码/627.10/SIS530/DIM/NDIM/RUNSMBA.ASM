	page	,132
	title .	SMBA Shared Frame Buffer Runtime Functions
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

;---------------------------------------;

	extrn FrameBufGetAsymMemInfo: near
	extrn FrameBufGetBankMemSize: near
	extrn FrameBufGetBankMemSpeed: near
	extrn FrameBufGetBankMemType: near
	extrn FrameBufGetCmosData: near
	extrn FrameBufGetCurAddress: near
	extrn FrameBufGetCurSize: near
	extrn FrameBufGetFbBanks: near
	extrn FrameBufGetHostBusSpeed: near
	extrn FrameBufGetMemHoleInfo: near
	extrn FrameBufGetMinMaxSize: near
	extrn FrameBufMakeInvisible: near
	extrn FrameBufMakeVisible: near
	extrn FrameBufSetCmosData: near
	extrn FrameBufSetMemHoleOverlap: near
	extrn FrameBufSetSize: near

;---------------------------------------;

SMBA_BIOS_VERSION	equ 10h

;---------------------------------------;

cgroup	group	_text
_text 	segment para public 'CODE'	;BIOS16 structure must be para aligned
	assume	cs:cgroup
.386

;---------------------------------------;
; BIOS16 Service Directory Signature    ;
;---------------------------------------;--------------------------------------;
; This structure marks the position of the BIOS16 Service Directory.  16 bit   ;
; runtime software will search E0000-FFFF0 for the ASCII signature "_16_"      ;
; to find this structure.  If the checksum of the structure is ok, then the 16 ;
; bit runtime software will use the 32 bit absolute address contained in this  ;
; structure to call the BIOS16 Service Directory Function.                     ;
;------------------------------------------------------------------------------;

BIOS16_SD_Signature	db '_16_'
BIOS16_SD_EntryPointOff	dw offset cgroup:BIOS16_Service_Dir
BIOS16_SD_EntryPointSeg	dw 000Fh
BIOS16_SD_RevLevel	db 00h		;Rev 00
BIOS16_SD_Length	db 01h		;In paragraphs
BIOS16_SD_CheckSum	db 00h		;Adjusted during make so sum of this struc is 0
BIOS16_SD_Reserved	db 00h, 00h, 00h, 00h, 00h


;---------------------------------------;
; BIOS16_Service_Dir                    ;
;---------------------------------------;--------------------------------------;
; 16 Bit runtime software will call this function to detect the presence of,   ;
; and the entry point for a given 16 bit BIOS API.  Currently the only 16 bit  ;
; API supported by this directory is the 16 bit SMBA runtime function API.     ;
;                                                                              ;
; Input:  EAX = 4 byte ASCII string describing the 16 bit BIOS API that caller ;
;               needs to access.  Only one value is currently valid:           ;
;                 "_SF_" or 5F46535Fh : SMBA BIOS 16 bit API                   ;
;          BL = Directory function number, currently only one function is      ;
;               supported: 00 - Returns entry point of given 16 bit BIOS API   ;
;                                                                              ;
; Output:  AL = Return code:                                                   ;
;                 00h = Requested API is present                               ;
;                 80h = Requested API is not present                           ;
;                 81h = BL contains an unsupported function number             ;
;         EBX = Absolute segment base of the requested API's entry point (used ;
;               to build a descriptor)                                         ;
;         ECX = The requested API's length (used to build a descriptor)        ;
;         EDX = Offset from base of the requested API's entry point (used to   ;
;               place a far call to the entry point)                           ;
;                                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
BIOS16_Service_Dir	proc far
	cmp	eax, 5F46535Fh		;'_SF_'
	mov	al, 80h			;Return code for unknown API string
	jne	bios16_sd_done		;Br if unknown API string
	mov	al, 81h			;Return code for unknown function
	or	bl, bl
	jnz	bios16_sd_done		;Br if BL has unknown function number

	mov	ebx, 0F0000h		;Base address of 16 bit SMBA API
	mov	ecx, 010000h		;Length of 16 bit SMBA API
	mov	edx, offset SmbaEntryPoint16
	mov	al, 0h			;Return code for success

bios16_sd_done:
	ret
BIOS16_Service_Dir	endp


;---------------------------------------;
; SmbaEntryPoint16                      ;
;---------------------------------------;--------------------------------------;
; This is the entry point for all SMBA 16-bit runtime functions.               ;
;                                                                              ;
; Input: AL = Function number                                                  ;
;        Other registers are function dependant                                ;
;                                                                              ;
; Output: CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaEntryPoint16	proc far
	push	bp

	movzx	bp, al			;BP = function number
	shl	bp, 1			;BP = 2 * function number
	add	bp, offset cgroup:VumaFuncTableStart
	cmp	bp, offset cgroup:VumaFuncTableEnd
	jae	SmbaInvalidFunction	;Br if func number is too high

	call	word ptr cgroup:[bp]	;Returns CF/AH set if error
	;Do we need to set a return code for success?...........................

SmbaDone:
	pop	bp
	retf

SmbaInvalidFunction:
	xor	ah, ah			;AH = Error code 00h (General failure)
	stc				;Indicate error
	jmp	short SmbaDone

SmbaEntryPoint16	endp



;------------------------------;
; SMBA Run Time Function Table ;
;------------------------------;
VumaFuncTableStart:
		dw	SmbaGetRevision		;SMBA function 00h
		dw	SmbaGetConfig		;SMBA function 01h
		dw	SmbaGetMemInfo		;SMBA function 02h
		dw	SmbaSetMemSize		;SMBA function 03h
		dw	SmbaSetMemHoleOverlap	;SMBA function 04h
		dw	SmbaSetNextBootMemSize	;SMBA function 05h
		dw	SmbaGetNextBootMemSize	;SMBA function 06h
		dw	SmbaOpen		;SMBA function 07h
		dw	SmbaClose		;SMBA function 08h
		dw	SmbaGetInstalledMem	;SMBA function 09h
VumaFuncTableEnd:



;---------------------------------------;
; SmbaGetRevision (00)                  ;
;---------------------------------------;--------------------------------------;
; This function returns the SMBA specification version supported by the BIOS.  ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;                                                                              ;
; Output: BL = SMBA Revision                                                   ;
;         CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaGetRevision	proc near
	mov	bl, SMBA_BIOS_VERSION
	clc
	ret
SmbaGetRevision	endp


;---------------------------------------;
; SmbaGetConfig (01)                    ;
;---------------------------------------;--------------------------------------;
; This function returns information about the SMBA frame buffer sizes that are ;
; supported by the chipset as well as the frame buffer's current address.      ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;                                                                              ;
; Output: BX = Frame buffer sizes supported by the chipset                     ;
;              Bit 0: If set, 0.5 MB frame buffer size is supported            ;
;              Bit 1: If set, 1.0 MB frame buffer size is supported            ;
;              Bit 2: If set, 1.5 MB frame buffer size is supported            ;
;              Bit 3: If set, 2.0 MB frame buffer size is supported            ;
;              Bit 4: If set, 2.5 MB frame buffer size is supported            ;
;              Bit 5: If set, 3.0 MB frame buffer size is supported            ;
;              Bit 6: If set, 3.5 MB frame buffer size is supported            ;
;              Bit 7: If set, 4.0 MB frame buffer size is supported            ;
;              Bit 8-15: Reserved                                              ;
;         ECX = Frame buffer current base address                              ;
;         DX = Memory hole information                                         ;
;              Bit 15: If set, memory hole overlaps frame buffer               ;
;              Bit 14-2: Reserved                                              ;
;              Bit 1-0: 00 = Memory hole is disabled                           ;
;                       01 = Reserved                                          ;
;                       10 = Memory hole is 1MB at 15MB                        ;
;                       11 = Memory hole is 2MB at 14MB                        ;
;         CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaGetConfig	proc near
	push	eax
	push	di

	call	FrameBufGetMinMaxSize	;Returns BX=min, CX=max, DI=gran
	shr	bx, 3			;BX = Min mem size in 512kb units
	dec	bx			;BX = Min mem size (0=0.5MB, 1=1.0MB, ...)
	jns	@f			;Br if min mem size >= 512kb
	xor	bx, bx			;Set min mem size to 512kb
@@:
	shr	cx, 3			;CX = Max mem size in 512kb units
	dec	cx			;CX = Max mem size (0=0.5MB, 1=1.0MB, ...)
	cmp	cx, 7
	jbe	@f			;Br if max size <= 4.0 MB
	mov	cx, 7
@@:
	xor	ax, ax			;Init bit accumulator

GetConfigNextSizeBit:
	bts	ax, bx			;Set one of the size bits
	inc	bx			;Next bit number
	cmp	bx, cx			;Compare to max size
	jbe	GetConfigNextSizeBit	;Br if more bits need to be set

	mov	bx, ax			;BX = supported sizes ready for return
	call	FrameBufGetCurAddress	;Returns EAX = cur addr of frame buffer
	mov	ecx, eax		;ECX = address return value

	call	FrameBufGetMemHoleInfo	;Returns DX=mem hole info

	pop	di
	pop	eax
	clc				;Indicate success
	ret
SmbaGetConfig	endp


;---------------------------------------;
; SmbaGetMemInfo (02)                   ;
;---------------------------------------;--------------------------------------;
; This function reports various system attributes such as the amount and type  ;
; of memory installed.                                                         ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;                                                                              ;
; Output: CX = Current SMBA frame buffer size                                  ;
;              Bit 0: If set, 0.5 MB frame buffer size                         ;
;              Bit 1: If set, 1.0 MB frame buffer size                         ;
;              Bit 2: If set, 1.5 MB frame buffer size                         ;
;              Bit 3: If set, 2.0 MB frame buffer size                         ;
;              Bit 4: If set, 2.5 MB frame buffer size                         ;
;              Bit 5: If set, 3.0 MB frame buffer size                         ;
;              Bit 6: If set, 3.5 MB frame buffer size                         ;
;              Bit 7: If set, 4.0 MB frame buffer size                         ;
;              Bit 8-15: Reserved                                              ;
;         BX = Memory information word                                         ;
;              Bit 2-0: Type of memory that is installed in SMBA bank          ;
;                       000 = Memory type unknown                              ;
;                       001 = Fast page mode                                   ;
;                       010 = EDO                                              ;
;                       011 = SDRAM                                            ;
;                       100 = BEDO                                             ;
;                       101 - 111 = Reserved                                   ;
;              Bit 5-3: Host bus clock frequency                               ;
;                       000 = Host bus clock frequency unknown                 ;
;                       001 = 50 MHz                                           ;
;                       010 = 60 MHz                                           ;
;                       011 = 66 MHz                                           ;
;                       100 - 111 = Reserved                                   ;
;              Bit 8-6: Memory speed                                           ;
;                       000 = Memory speed unknown                             ;
;                       001 = 70 ns                                            ;
;                       010 = 60 ns                                            ;
;                       011 = 50 ns                                            ;
;                       100 - 111 = Reserved                                   ;
;             Bit 11-9: Number of rows of memory that are populated            ;
;                       000 = Reserved                                         ;
;                       001 = One row is populated                             ;
;                       010 = Two rows are populated                           ;
;                       011 = Three rows are populated                         ;
;                       100 = Four rows are populated                          ;
;                       101 = Five rows are populated                          ;
;                       110 - 111 = Reserved                                   ;
;            Bit 14-12: Amount of memory installed in shared row               ;
;                       000 = Shared row not populated                         ;
;                       001 = 4 MB                                             ;
;                       010 = 8 MB                                             ;
;                       011 = 16 MB                                            ;
;                       100 = 32 MB                                            ;
;                       101 - 111 = Reserved                                   ;
;               Bit 15: If set, memory is asymetrical                          ;
;                       If clear, memory is symetrical                         ;
;         CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaGetMemInfo	proc near
	push	ax
	push	dx
	push	bp

; Determine SMBA bank's memory type
; Result into BP[2:0]

	call	FrameBufGetFbBanks	;Returns AX=bit map with SMBA bank set
	bsf	cx, ax			;CX = SMBA bank number
	call	FrameBufGetBankMemType	;Returns AL=mem type for bank CL
	and	ax, 07h			;AX = 1/2/3/4 for FPM/EDO/SDRAM/BEDO
	mov	bp, ax			;Put mem type field into BP

; Determine host bus frequency
; Result into BP[5:3]

	call	FrameBufGetHostBusSpeed	;AL = 1/2/3 for 50/60/66 MHz
	and	ax, 00000111b		;Limit host bus speed to 3 bits
	shl	ax, 3
	or	bp, ax			;Put host bus speed field into BP

; Determine memory speed
; Result into BP[8:6]

	call	FrameBufGetBankMemSpeed	;Returns AL=mem speed for bank CL
	mov	dx, 1			;Value for 70ns
	cmp	al, 70d
	je	@f			;Br if 70ns
	inc	dx			;DX = value for 60ns
	cmp	al, 60d
	je	@f			;Br if 60ns
	inc	dx			;DX = value for 50ns
@@:	shl	dx, 6
	or	bp, dx			;Put memory speed field into BP

; Determine symetrical / asymetrical memory
; Result into BP[15]

	call	FrameBufGetAsymMemInfo	;Returns BL=Flag, DL=cols, DH=rows for bank CL
	test	bl, 00000001b		;BL[0] is set if asymetrical
	jz	@f			;Br if symetrical
	or	bp, 8000h		;Set asymetrical bit in BP
@@:

; Determine amount of memory in SMBA bank, if zero then invalidate all
; of the other info in BP so far because it is invaild.
; Result in BP[14:12]

	call	FrameBufGetBankMemSize	;Returns AX=size in 64k of bank CL
	xor	bx, bx
	or	ax, ax			;AX=40h/80h/100h/.. for 4/8/16/.. MB size
	jz	GetMemInfoNoSmbaMem	;Br if no mem is in SMBA bank

	bsf	ax, ax			;AX=6/7/8/9/.. for 4/8/16/32/.. MB size
	sub	ax, 5			;AX=1/2/3/4/.. for 4/8/16/32/.. MB size
	and	ax, 0007h		;Limit result to 3 bits
	shl	ax, 12
	or	bp, ax			;Put SMBA bank mem size field into BP

	mov	bx, bp			;BX = value for return

GetMemInfoNoSmbaMem:

; Determine number of banks containing memory
; Result in BX[11:9]

	xor	dx, dx			;Init populated bank counter
	mov	cx, 15			;Start with highest bank
GetMemNextBank:
	call	FrameBufGetBankMemSize	;Returns AX=size in 64k of bank CL
	or	ax, ax
	jz	@f			;Br if bank CL has no memory
	inc	dx			;Inc populated bank counter
@@:	loop	GetMemNextBank
	and	dl, 07h			;Limit bank count to 3 bits
	shl	dx, 9
	or	bx, dx			;Put # of installed banks field into BX

; Determine current SMBA frame buffer size in SMBA word format
; Result into CX

	push	bx
	call	FrameBufGetCurSize	;Returns DX = cur frame buf size in 64k
	call	Xlat64KbToSmbaWord	;Returns BX=SMBA word format from size DX
	mov	cx, bx			;CX = cur size ready to return
	pop	bx

	clc				;Indicate success
	pop	bp
	pop	dx
	pop	ax
	ret
SmbaGetMemInfo	endp


;---------------------------------------;
; SmbaSetMemSize (03)                   ;
;---------------------------------------;--------------------------------------;
; This function sets the size of the SMBA shared frame buffer.  The new size   ;
; takes effect immediately.  The SMBA frame buffer size setting in CMOS is     ;
; also updated.                                                                ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;         BX = New frame buffer size                                           ;
;              Bit 0: If set, 0.5 MB frame buffer size                         ;
;              Bit 1: If set, 1.0 MB frame buffer size                         ;
;              Bit 2: If set, 1.5 MB frame buffer size                         ;
;              Bit 3: If set, 2.0 MB frame buffer size                         ;
;              Bit 4: If set, 2.5 MB frame buffer size                         ;
;              Bit 5: If set, 3.0 MB frame buffer size                         ;
;              Bit 6: If set, 3.5 MB frame buffer size                         ;
;              Bit 7: If set, 4.0 MB frame buffer size                         ;
;              Bit 8-15: Reserved                                              ;
;                                                                              ;
; Output: CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaSetMemSize	proc near
	push	bx
	push	cx
	push	dx

	call	XlatSmbaWordTo64Kb	;Returns DX=size in 64KB, CF/AH set on error
	jc	SetMemSizeDone		;Br if error

	call	FrameBufGetFbBanks	;Returns AX=bit map with SMBA bank set
	mov	bx, ax
	call	FrameBufSetSize
	xor	ah, ah			;AH = error code in case of error
	jc	SetMemSizeDone		;Br if requested size is invalid

	xor	ch, ch			;Disable mem at boot
	call	FrameBufSetCmosData	;Update CMOS with new size

	clc				;Indicate success

SetMemSizeDone:
	pop	dx
	pop	cx
	pop	bx
	ret
SmbaSetMemSize	endp


;---------------------------------------;
; SmbaSetMemHoleOverlap (04)            ;
;---------------------------------------;--------------------------------------;
; This function determines if the SMBA shared frame buffer overlaps the memory ;
; hole.  The new setting takes effect immediately and is saved into CMOS for   ;
; the next boot.                                                               ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;         BX = Bit 0: If set, frame buffer overlaps memory hole                ;
;                     If clear, frame buffer does not overlap memory hole      ;
;              Bit 1-15: Reserved                                              ;
;                                                                              ;
; Output: CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaSetMemHoleOverlap	proc near
	pusha

	call	FrameBufSetMemHoleOverlap

	mov	al, bl			;AL bit 0 = hole overlap setting
	and	al, 1			;Clear all other bits

	call	FrameBufGetCmosData
	and	ch, 0FEh		;Clear overlap flag
	or	ch, al			;Set hole overlap flag if needed (bit 1)
	call	FrameBufSetCmosData

	popa
	clc				;Indicate success
	ret
SmbaSetMemHoleOverlap	endp


;---------------------------------------;
; SmbaSetNextBootMemSize (05)           ;
;---------------------------------------;--------------------------------------;
; This function sets the size of the SMBA shared frame buffer for the next     ;
; boot.  No chipset register should be affected, the size should only be saved ;
; to CMOS.                                                                     ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;         BX = New frame buffer size                                           ;
;              Bit 0: If set, 0.5 MB frame buffer size                         ;
;              Bit 1: If set, 1.0 MB frame buffer size                         ;
;              Bit 2: If set, 1.5 MB frame buffer size                         ;
;              Bit 3: If set, 2.0 MB frame buffer size                         ;
;              Bit 4: If set, 2.5 MB frame buffer size                         ;
;              Bit 5: If set, 3.0 MB frame buffer size                         ;
;              Bit 6: If set, 3.5 MB frame buffer size                         ;
;              Bit 7: If set, 4.0 MB frame buffer size                         ;
;              Bit 8-15: Reserved                                              ;
;                                                                              ;
; Output: CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaSetNextBootMemSize	proc near
	push	bx
	push	cx
	push	dx

	call	XlatSmbaWordTo64Kb	;Returns DX=size in 64KB, CF/AH set on error
	jc	SetNbMemSizeDone	;Br if error

	xor	ch, ch			;Primary (only) SMBA device, disable mem at boot
	call	FrameBufSetCmosData

	clc				;Indicate success

SetNbMemSizeDone:
	pop	dx
	pop	cx
	pop	bx
	ret
SmbaSetNextBootMemSize	endp


;---------------------------------------;
; SmbaGetNextBootMemSize (06)           ;
;---------------------------------------;--------------------------------------;
; This function reports the size of the SMBA shared frame buffer that will be  ;
; used on the next boot.  This information is read from CMOS.                  ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;                                                                              ;
; Output: BX = New frame buffer size on next boot                              ;
;              Bit 0: If set, 0.5 MB frame buffer size                         ;
;              Bit 1: If set, 1.0 MB frame buffer size                         ;
;              Bit 2: If set, 1.5 MB frame buffer size                         ;
;              Bit 3: If set, 2.0 MB frame buffer size                         ;
;              Bit 4: If set, 2.5 MB frame buffer size                         ;
;              Bit 5: If set, 3.0 MB frame buffer size                         ;
;              Bit 6: If set, 3.5 MB frame buffer size                         ;
;              Bit 7: If set, 4.0 MB frame buffer size                         ;
;              Bit 8-15: Reserved                                              ;
;         CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaGetNextBootMemSize	proc near
	push	cx
	push	dx

	call	FrameBufGetCmosData	;Returns DX=size in 64kb, CH=flags
	call	Xlat64KbToSmbaWord	;Returns BX=SMBA word format from size DX

	pop	dx
	pop	cx
	clc				;Indicate success
	ret
SmbaGetNextBootMemSize	endp


;---------------------------------------;
; SmbaOpen (07)                         ;
;---------------------------------------;--------------------------------------;
; This function makes the SMBA shared frame buffer memory region visible to    ;
; the CPU.                                                                     ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;                                                                              ;
; Output: CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaOpen	proc near
	call	FrameBufMakeVisible
	clc				;Indicate success
	ret
SmbaOpen	endp


;---------------------------------------;
; SmbaClose (08)                        ;
;---------------------------------------;--------------------------------------;
; This function makes the SMBA shared frame buffer memory region invisible to  ;
; the CPU.                                                                     ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;                                                                              ;
; Output: CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaClose	proc near
	call	FrameBufMakeInvisible
	clc				;Indicate success
	ret
SmbaClose	endp


;---------------------------------------;
; SmbaGetInstalledMem (09)              ;
;---------------------------------------;--------------------------------------;
; This function reports the total amount of memory installed in the system as  ;
; well as the amount that is installed in the last row.                        ;
;                                                                              ;
; Input:  AL = Function number                                                 ;
;                                                                              ;
; Output: EBX = Amount of memory in last row (in bytes)                        ;
;         ECX = Total amount of memory installed in system (in bytes)          ;
;         CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
SmbaGetInstalledMem	proc near
	push	eax

	xor	ebx, ebx		;Init memory accumulator
	mov	cx, 15			;Start with highest bank

GetMemNextBank:
	call	FrameBufGetBankMemSize	;Returns AX=size in 64k of bank CL
	shl	eax, 16			;EAX = size in bytes of bank CL
	add	ebx, eax		;EBX = total memory so far
	loop	GetMemNextBank

	call	FrameBufGetFbBanks	;Returns AX=bit map with SMBA bank set
	bsf	cx, ax			;CX = SMBA bank number
	call	FrameBufGetBankMemSize	;Returns AX=size in 64k of bank CL
	shl	eax, 16			;EAX = size in bytes of bank CL

	mov	ecx, ebx		;ECX = total memory ready to return
	mov	ebx, eax		;EBX = total memory in SMBA bank

	pop	eax
	clc
	ret
SmbaGetInstalledMem	endp



;---------------------------------------;
; XlatSmbaWordTo64Kb                    ;
;---------------------------------------;--------------------------------------;
; This function reports the total amount of memory installed in the system as  ;
; well as the amount that is installed in the last row.                        ;
;                                                                              ;
; Input:  BX = Frame buffer size                                               ;
;              Bit 0: If set, 0.5 MB frame buffer size                         ;
;              Bit 1: If set, 1.0 MB frame buffer size                         ;
;              Bit 2: If set, 1.5 MB frame buffer size                         ;
;              Bit 3: If set, 2.0 MB frame buffer size                         ;
;              Bit 4: If set, 2.5 MB frame buffer size                         ;
;              Bit 5: If set, 3.0 MB frame buffer size                         ;
;              Bit 6: If set, 3.5 MB frame buffer size                         ;
;              Bit 7: If set, 4.0 MB frame buffer size                         ;
;              Bit 8-15: Reserved                                              ;
;                                                                              ;
; Output: DX = Frame buffer size in units of 64k                               ;
;         CF = Clear if function was successful, set if error                  ;
;         AH = If CF set, contains an error code                               ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
XlatSmbaWordTo64Kb	proc near

	test	bx, 00FFh
	mov	ah, 0			;Error code
	stc				;Indicate error
	jz	XlatMemSizeDone		;Br if no legal bits are set

	bsr	dx, bx			;BX = mem size (0=0.5MB, 1=1.0MB, ...)
	inc	dx			;BX = mem size (1=0.5MB, 2=1.0MB, ...)
	shl	dx, 3			;BX = mem size in 64kB

XlatMemSizeDone:
	ret
XlatSmbaWordTo64Kb	endp


;---------------------------------------;
; Xlat64KbToSmbaWord                    ;
;---------------------------------------;--------------------------------------;
; This function reports the total amount of memory installed in the system as  ;
; well as the amount that is installed in the last row.                        ;
;                                                                              ;
; Input:  DX = Frame buffer size in units of 64kb                              ;
;                                                                              ;
; Output: BX = Frame buffer size                                               ;
;              Bit 0: If set, 0.5 MB frame buffer size                         ;
;              Bit 1: If set, 1.0 MB frame buffer size                         ;
;              Bit 2: If set, 1.5 MB frame buffer size                         ;
;              Bit 3: If set, 2.0 MB frame buffer size                         ;
;              Bit 4: If set, 2.5 MB frame buffer size                         ;
;              Bit 5: If set, 3.0 MB frame buffer size                         ;
;              Bit 6: If set, 3.5 MB frame buffer size                         ;
;              Bit 7: If set, 4.0 MB frame buffer size                         ;
;              Bit 8-15: Reserved                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
Xlat64KbToSmbaWord	proc near
	push	dx
	
	xor	bx, bx
	shr	dx, 3			;DX = mem size in 512kb units
	dec	dx			;DX = mem size (0=0.5MB, 1=1.0MB, ...)
	js	@f			;Br if mem size < 512kb
	bts	bx, dx			;Set proper bit in BX
@@:
	pop	dx
	ret
Xlat64KbToSmbaWord	endp


_text	ends
	end
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
