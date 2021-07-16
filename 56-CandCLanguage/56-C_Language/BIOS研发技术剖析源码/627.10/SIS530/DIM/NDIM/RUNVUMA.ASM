	page	,132
	title .	VUMA Shared Frame Buffer Runtime Functions
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

	public	VumaInt15EntryPoint

;---------------------------------------;

	extrn FrameBufGetAllBanks: near
	extrn FrameBufGetAsymMemInfo: near
	extrn FrameBufGetBankAddress: near
	extrn FrameBufGetBankMemSize: near
	extrn FrameBufGetBankMemSpeed: near
	extrn FrameBufGetBankMemType: near
	extrn FrameBufGetBankTimingInfo: near
	extrn FrameBufGetBankVoltage: near
	extrn FrameBufGetChipsetInfo: near
	extrn FrameBufGetCmosData: near
	extrn FrameBufGetCurAddress: near
	extrn FrameBufGetCurBanks: near
	extrn FrameBufGetCurSize: near
	extrn FrameBufGetFbBanks: near
	extrn FrameBufGetMemCtrlSpeed: near
	extrn FrameBufGetMinMaxSize: near
	extrn FrameBufGetVisibility: near
	extrn FrameBufMakeInvisible: near
	extrn FrameBufMakeVisible: near
	extrn FrameBufSetCmosData: near
	extrn FIND_FREQUENCY:near
	extrn DRAM_CONTROL_CYCLE:near

	include	setupequ.ext
;---------------------------------------;

VUMA_BIOS_MAJOR_VERSION	equ 01h
VUMA_BIOS_MINOR_VERSION	equ 00h

;---------------------------------------;

cgroup	group	_text
_text 	segment word public 'CODE'
	assume	cs:cgroup
.386

;---------------------------------------;
; VumaInt15EntryPoint                   ;
;---------------------------------------;--------------------------------------;
; This is the entry point for all VUMA Int 15 runtime functions.               ;
;                                                                              ;
; Input: AX = F401h                                                            ;
;        BL = Subfunction number (valid values are 00h - 08h)                  ;
;        Other registers are subfunction dependant                             ;
;                                                                              ;
; Output: AL = F4h if subfunction is supported, any other value means function ;
;              is not supported.                                               ;
;         AH = 00h if subfunction was successful, any other value means that   ;
;              an error occurred.                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
VumaInt15EntryPoint	proc near
	push	bp

	movzx	bp, bl			;BP = VUMA function number
	shl	bp, 1
	add	bp, offset cgroup:VumaFuncTableStart
	cmp	bp, offset cgroup:VumaFuncTableEnd
	mov	ax, 00FFh		;Return value for not supported
	jae	VumaInt15Done		;Br if func number is too high

	call	word ptr cgroup:[bp]	;Returns CF set if error
	mov	al, 0F4h		;AL = F4 (function supported)
	jc	VumaInt15Done		;Br if function returned with error
	mov	ah, 00h			;AH = 0 (no error)

VumaInt15Done:
	pop	bp
	add	sp, 02h			;Bypass BIOS's Special Int 15 caller
	retf	2			;Return directly to Int 15 caller
VumaInt15EntryPoint	endp



;------------------------------;
; VUMA Run Time Function Table ;
;------------------------------;
VumaFuncTableStart:
		dw	VumaGetChipsetInfo		;VUMA function 00h
		dw	VumaGetMemoryInfo		;VUMA function 01h
		dw	VumaSetNextBootMemSize		;VUMA function 02h
		dw	VumaGetNextBootDeviceMemSize	;VUMA function 03h
		dw	VumaGetNextBootAllMemSize	;VUMA function 04h
		dw	VumaGetCurrentMemSize		;VUMA function 05h
		dw	VumaGetMemorySpeedType		;VUMA function 06h
		dw	VumaMemoryEnableDisable		;VUMA function 07h
		;dw	VumaAuxMemRequestFree		;VUMA function 08h (not supported)
		;dw	VumaAuxMemGetSize		;VUMA function 09h (not supported)
VumaFuncTableEnd:



;---------------------------------------;
; VumaGetChipsetInfo (00)               ;
;---------------------------------------;--------------------------------------;
; This function returns general information about the chipset's capabilities.  ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;         BL = Major VUMA BIOS revision (01h) (yes these two return values are ;
;         BH = Minor VUMA BIOS revision (00h)  defined backwards in the spec)  ;
;         CX = Bank numbers that are supported by chipset (may or may not      ;
;              contain memory)                                                 ;
;              Bit 0: Set if bank 0 is supported by chipset                    ;
;              Bit 1: Set if bank 1 is supported by chipset                    ;
;              ...                                                             ;
;              Bit 15: Set if bank 15 is supported by chipset                  ;
;         DL = Flags                                                           ;
;              Bit 0: Set if chipset supports non-cachable regions             ;
;              Bit 1: Set if chipset supports write-thru cache regions         ;
;              Bit 2: Set if chipset supports enable/disable cache at runtime  ;
;              Bit 3: Set if chipset supports enable/disable write-thru cache  ;
;                     at runtime                                               ;
;              Bit 4: Set if chipset supports snooping (this bit is relevant   ;
;                     only if synchronous DRAM is installed)                   ;
;              Bit 5-7: Reserved                                               ;
;         DH = Speed in nanoseconds of memory controller (00 = unknown)        ;
;         SI = Bitmap of banks that contain memory                             ;
;               Bit 0: Set if bank 0 contains memory                           ;
;               Bit 1: Set if bank 1 contains memory                           ;
;               ...                                                            ;
;               Bit 15: Set if bank 15 contains memory                         ;
;         DI = Memory banks that may be used for VUMA frame buffer and         ;
;              contain memory                                                  ;
;               Bit 0: Set if bank 0 will be used                              ;
;               Bit 1: Set if bank 1 will be used                              ;
;               ...                                                            ;
;               Bit 15: Set if bank 15 will be used                            ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaGetChipsetInfo	proc near

	call	FrameBufGetChipsetInfo	;Returns DL = flags, SI = non cache gran
	call	FrameBufGetMemCtrlSpeed	;Returns DH = speed of memory controller in ns

	mov	cx, 0Fh			;Start with highest possible bank
	xor	si, si			;Init result bitmap to zeros
GetCsInfoNextBank:
	call	FrameBufGetBankMemSize	;Returns AX = size of mem in bank CL in 64k
	or	ax, ax
	jz	@f			;Br if bank is empty
	bts	si, cx			;Set bit in result bitmap
@@:	loop	GetCsInfoNextBank

	call	FrameBufGetFbBanks	;Returns AX = frame buf banks bitmap
	mov	di, ax
	and	di, si			;Zero any banks that don't have memory

	call	FrameBufGetAllBanks	;Returns AX = all banks bitmap
	mov	cx, ax

	mov	bl, VUMA_BIOS_MAJOR_VERSION
	mov	bh, VUMA_BIOS_MINOR_VERSION

	clc
	ret
VumaGetChipsetInfo	endp


;---------------------------------------;
; VumaGetMemoryInfo (01)                ;
;---------------------------------------;--------------------------------------;
; This function reports information on the chipset's VUMA memory capabilities. ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;         BX = Minimum amount of memory that can be allocated to VUMA frame    ;
;              buffer in units of 64K                                          ;
;         CX = Maximum amount of memory that can be allocated to VUMA frame    ;
;              buffer in units of 64K                                          ;
;         SI = Chipset's non-cache region granularity in units of 64K          ;
;         DI = Granularity of memory that can be allocated to VUMA frame       ;
;              buffer in units of 64K                                          ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaGetMemoryInfo	proc near
	push	dx

	call	FrameBufGetChipsetInfo	;Returns DL=flags, SI=non cache gran
	call	FrameBufGetMinMaxSize	;Returns BX=min, CX=max, DI=gran

	pop	dx
	clc
	ret
VumaGetMemoryInfo	endp


;---------------------------------------;
; VumaSetNextBootMemSize (02)           ;
;---------------------------------------;--------------------------------------;
; This function sets the size of the VUMA frame buffer for one device for the  ;
; next boot.                                                                   ;
;                                                                              ;
; Input: CL = PCI Device/Function number of VUMA device                        ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        CH = PCI Bus number of VUMA device                                    ;
;        DX = Memory banks supported by VUMA device                            ;
;              Bit 0: Set if bank 0 is supported                               ;
;              Bit 1: Set if bank 1 is supported                               ;
;              ...                                                             ;
;              Bit 15: Set if bank 15 is supported                             ;
;        SI = VUMA frame buffer memory size requested in units of 64KB         ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;         DX = Actual size of VUMA frame buffer memory that will be used       ;
;              (The BIOS may round the requested amount up if needed)          ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaSetNextBootMemSize	proc near
	push	bx
	push	cx
	push	di
	push	si

	call	FrameBufGetMinMaxSize	;Returns BX=min, CX=max, DI=gran

	dec	di			;DI = chipset's mem gran - 1 (...0001111...)
	add	si, di			;Round up request
	not	di			;DI = 10000h - mem gran (...111000...)
	and	di, si			;DI = rounded up mem request

	call	FrameBufGetCmosData	;DX=Mem Size, CH=Flags
	mov	dx, di
	call	FrameBufSetCmosData	;Save DX=Mem Size, CH=Flags in CMOS

	pop	si
	pop	di
	pop	cx
	pop	bx
	clc
	ret
VumaSetNextBootMemSize	endp


;---------------------------------------;
; VumaGetNextBootDeviceMemSize (03)     ;
;---------------------------------------;--------------------------------------;
; This function returns the amount of memory that will be allocated to a given ;
; VUMA device on the next boot.                                                ;
;                                                                              ;
; Input: CL = PCI Device/Function number of VUMA device                        ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        CH = PCI Bus number of VUMA device                                    ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;         DX = Size of VUMA frame buffer memory that will be allocated on next ;
;              boot for the given VUMA device in units of 64KB                 ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaGetNextBootDeviceMemSize	proc near
	push	cx

	call	FrameBufGetCmosData	;DX=Mem Size, CH=Flags

	pop	cx
	clc
	ret
VumaGetNextBootDeviceMemSize	endp


;---------------------------------------;
; VumaGetNextBootAllMemSize (04)        ;
;---------------------------------------;--------------------------------------;
; This function returns the amount of memory that will be allocated to all     ;
; VUMA devices on the next boot.                                               ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;         DX = Size of VUMA frame buffer memory that will be allocated on next ;
;              boot for all VUMA devices in units of 64KB                      ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaGetNextBootAllMemSize	proc near
	call	VumaGetNextBootDeviceMemSize ;See above
	ret
VumaGetNextBootAllMemSize	endp


;---------------------------------------;
; VumaGetCurrentMemSize (05)            ;
;---------------------------------------;--------------------------------------;
; This function returns the current size and address of VUMA frame buffer      ;
; memory for a given VUMA device or for all VUMA devices.                      ;
;                                                                              ;
; Input: CL = PCI Device/Function number of VUMA device (FF means all devices) ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        CH = PCI Bus number of VUMA device (FF means all devices)             ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;         DX = Size of VUMA frame buffer memory that is currently active       ;
;              in units of 64KB                                                ;
;         BH = 00: VUMA memory is not visible to the CPU                       ;
;              01: VUMA memory is visible to the CPU                           ;
;         CX = Memory banks in use by VUMA frame buffer                        ;
;               Bit 0: Set if bank 0 is used                                   ;
;               Bit 1: Set if bank 1 is used                                   ;
;               ...                                                            ;
;               Bit 15: Set if bank 15 is used                                 ;
;         SI = Upper 16 bits VUMA frame buffer's physical address              ;
;         DI = Lower 16 bits VUMA frame buffer's physical address              ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaGetCurrentMemSize	proc near

	call	FrameBufGetCurSize	;Returns DX = cur frame buf size in 64k
	or	dx,dx
	mov	ah,05h			; FrameBuffer not support error
	jz	func_05_error

	call	FrameBufGetCurAddress	;Returns EAX = cur addr of frame buffer
	mov	ebx,eax
	mov	ah,04h
	jc	func_05_error
	mov	di, bx			;DI = lower half of addr
	shr	ebx, 16
	mov	si, bx			;SI = upper half of addr

	call	FrameBufGetVisibility	;Returns BH = 0/1 for invisible/visible
	call	FrameBufGetCurBanks	;Returns CX = bitmap of banks in use as frame buffer

	clc
	jmp	short func_05_done

func_05_error:
	stc

func_05_done:
	ret
VumaGetCurrentMemSize	endp


;---------------------------------------;
; VumaGetMemorySpeedType (06)           ;
;---------------------------------------;--------------------------------------;
; This function returns information on the memory installed in a given bank.   ;
;                                                                              ;
; Input: CX = Memory bank number                                               ;
;             Bit 0: Set if bank 0 is requested                                ;
;             Bit 1: Set if bank 1 is requested                                ;
;             ...                                                              ;
;             Bit 15: Set if bank 15 is requested                              ;
;        DX = Iteration number for the above bank                              ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;         EBX = Bit 31-18: Reserved                                            ;
;               Bit 17-16: External buffering of DRAM bank                     ;
;                            00 = Unknown                                      ;
;                            01 = Bank has external buffer                     ;
;                            10 = Bank does not have external buffer           ;
;                            11 = Reserved                                     ;
;               Bit 15:    Reserved                                            ;
;               Bit 14:    Set if bank (or this portion of bank) is used as    ;
;                          VUMA memory                                         ;
;               Bit 13-7:  Speed of memory in nanoseconds (00=unknown)         ;
;               Bit 6-0:   Reserved                                            ;
;         ECX = Bit 31-24: If bank contains asymetrical DRAM, number of rows   ;
;               Bit 23-16: If bank contains asymetrical DRAM, number of columns;
;               Bit 15-9:  Memory supply voltage in tenths of a volt (00 =     ;
;                          unknown)                                            ;
;               Bit 8:     Burst order                                         ;
;                            0 = Interleave burst order                        ;
;                            1 = Sequential burst order                        ;
;               Bit 7-6:   Burst size                                          ;
;                            00 = 1 Byte                                       ;
;                            01 = 2 Bytes                                      ;
;                            10 = 4 Bytes                                      ;
;                            11 = Unknown                                      ;
;               Bit 5-4:   CAS latency in CPU clocks                           ;
;               Bit 3-0:   Type of memory                                      ;
;                            0 = Unknown                                       ;
;                            1 = Fast page mode                                ;
;                            2 = EDO                                           ;
;                            3 = SDRAM                                         ;
;                            4 = PN EDO (Burst EDO)                            ;
;                            5-F = Reserved                                    ;
;         EDX = Amount of memory installed in bank in units of 64kb            ;
;         SI = Upper 16 bits memory bank's physical address                    ;
;         DI = Lower 16 bits memory bank's physical address                    ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaGetMemorySpeedType	proc near
	push	bp
	push	eax

;; SiS VUMA not support iteration
;	push	dx			;Save iteration value


;; SiS VUMA using RAS0 if not then return error message
	bsf	cx, cx			;CL = Bank number
	or	cx,cx
	jnz	GetMemError

; EDX[32:24]/[23:16] = Asynchronous mem row/col count
; EBX[31:28] = MA scrambling table selection[3:0]

	call	FrameBufGetAsymMemInfo	;Returns BL=MA table, DL=cols, DH=rows for bank CL
	shl	edx, 16			;EDX[31:24]/[23:16] = asym rows/cols
	shl	ebx, 28			; EBX[31:28] = MA table

; EBX[14] = Main VUMA memory
	or	ebx,4000h

; SiS reserved
; EBX[17:16] = Ext buffer flags
; EDX[15:9]  = Bank voltage
;	call	FrameBufGetBankVoltage	;Returns AL=Voltage, AH=Ext buffer flags for bank CL
;	and	ah, 00000011b
;	movzx	ebx, ah
;	shl	ebx, 16			;EBX[17:16] = Ext buffer flags

;	and	al, 01111111b		;Limit voltage info to 7 bits
;	shl	ax, 9			;AX[15:9] = Voltage
;	or	dx, ax			;EDX[15:9] = Voltage

; EDX[8]/[7:6]/[5:4] = Burst order, burst size, and CAS latency

	call	FrameBufGetBankTimingInfo ;Returns AL[4],[3:2],[1:0] = timing info for bank CL
	and	ax, 001Fh		;Limit timing info to 5 bits
	shl	ax, 4
	or	dx, ax			;EDX[8]/[7:6]/[5:4] = timing info

; EDX[3:0] = Type of memory

	call	FrameBufGetBankMemType	;Returns AL=mem type for bank CL
	and	al, 0Fh			;Limit mem type to 4 bits
	or	dl, al			;EDX[3:0] = mem type

; EBX[5:4] = DRAM controller write/read cycle
	call	dram_control_cycle	;Returns AH[1:0]= write/read cycle
	shl	ah,4
	or	bl,ah

; EBX[3:0] = M/B frequency
	call	find_frequency		;Returns AH=0/1/2/3/4 60/66/75/83/100 MHz
	or	bl,ah

; SiS reserved
; EBX[13:7] = Memory speed in ns
;	call	FrameBufGetBankMemSpeed	;Returns AL=mem speed for bank CL
;	and	ax, 007Fh		;Limit mem speed to 7 bits
;	shl	ax, 7			;AX[13:7] = mem speed
;	or	bx, ax			;EBX[13:7] = mem speed, EBX ready to return

;; SI/DI = Start address of bank's memory
;	call	FrameBufGetBankAddress	;Returns EAX = start addr of bank CL
;	mov	di, ax			;DI = lower half of addr
;	shr	eax, 16
;	mov	si, ax			;SI = upper half of addr

; EDX = Amount of memory installed in bank
;	call	FrameBufGetBankMemSize	;Returns AX = size of mem in bank CL in 64k

	mov	bp, cx			;BP = bank number
	mov	ecx, edx		;ECX = memory bank info ready to return

; Check the iteration value passed in by the caller.  If it is non-zero, then
; this bank should be the bank that contains the frame buffer (return error
; if this is not true).  Also if the iteration value is higher than 0001h, it
; is an illegal value, so return an error.  If the iteration value is 0001h and
; the frame buffer is using this bank of memory then update the start address
; in SI/DI and set bit 14 in EBX.

;	pop	ax			;Restore iteration value
;	push	cx			;Save values ready to be returned
;
;	call	FrameBufGetCurBanks	;Returns CX = bitmap of banks in use as frame buffer

;	or	ax, ax
;	jz	GetMemFirstIteration	;Br if iteration value is zero
;	cmp	ax, 1
;	ja	GetMemError		;Br if iteration value is > 1

;	bts	cx, bp			;Sets CF = bit number BP of CX
;	jnc	GetMemError		;Br if this bank is not frame buffer bank

; EDX = Amount of memory installed in bank(RAS0 - share)
; SI/DI = Start address of memory
	call	FrameBufGetCurAddress	;Returns EAX = cur addr of frame buffer
	mov	di, ax			;DI = lower half of addr
	shr	eax, 16
	mov	si, ax			;SI = upper half of addr
	movzx	edx, ax			;EDX = amount of mem ready to return

GetMemDone:
;; for TV out
	push	ax
	mov	al,Q_MONITOR_DEVICE
	extrn	get_cmos_item:near
	call	get_cmos_item
	ror	ebx,24
	and	bx,not 07h
	or	bl,al
	rol	ebx,24
	pop	ax
	clc				;Indicate success
GetMemExit:
;	pop	cx			;Restore CX return value

	pop	bp			;Lower half of EAX on entry (discard this)
	pop	bp			;Upper half of EAX on entry (put this back)
	ror	eax, 16
	mov	ax, bp
	ror	eax, 16
	pop	bp
	ret

; If the frame buffer starts in this memory bank, return with CF set and AH=80h
; This will inform the caller to make another call with iteration value = 01h

;GetMemFirstIteration:
;	bts	cx, bp			;Sets CF = bit number BP of CX
;	jnc	GetMemDone		;Br if this bank is not frame buffer bank
;	mov	ah, 080h		;Indicate another iteration is needed
;	stc
;	jmp	short GetMemExit

GetMemError:
	mov	ah, 004h		;Error return code.......................
	stc
	jmp	short GetMemExit

VumaGetMemorySpeedType	endp


;---------------------------------------;
; VumaMemoryEnableDisable (07)          ;
;---------------------------------------;--------------------------------------;
; This function enables or disables CPU access to the VUMA frame buffer memory.;
;                                                                              ;
; Input: BH = Bit 0: Set if memory should me made visible to the CPU           ;
;                    Clear if memory should me made invisible to the CPU       ;
;             Bit 1-7: Reserved                                                ;
;                                                                              ;
; Output: CF = Set if error, clear if successful                               ;
;         AH = Nonzero return code if function was not successful              ;
;              (value is "don't care" if function is successful)               ;
;                                                                              ;
; Destroys: AL, AH (if successful)                                             ;
;------------------------------------------------------------------------------;
VumaMemoryEnableDisable	proc near

	test	bh, 1
	jnz	@f			;Br if frame buffer should be enabled
	call	FrameBufMakeInvisible
	jmp	short EnableDisableDone
@@:	call	FrameBufMakeVisible

EnableDisableDone:
	clc
	ret
VumaMemoryEnableDisable	endp


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
