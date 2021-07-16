	page	,132
	title .	VUMA / SMBA Shared Frame Buffer POST Functions
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

	include	rt.equ

;---------------------------------------;

	public	FrameBufAdjustSize
	public	FrameBufEnableDisableBoot

;---------------------------------------;

	extern	SmbaVgaBusDevFuncNumber(DummySmbaVgaBDFNumber):word

;---------------------------------------;

; VUMA Option ROM Signature Structure
;------------------------------------------------------------------------------
VumaRomSig		struc
VumaSignature		db 6 dup (?)	;Contains ASCII "_VUMA_" signature
MajorVersion		dw ?		;Major version number
MinorVersion		dw ?		;Minor version number
MinMemorySize		dw ?		;Minimum frame buffer size in KB
SupportedBanks		dw ?		;Bitmap of memory banks supported
SupportedDram		dw ?		;See VUMA_MEM_TYPE_???? constants below
VumaRomSig		ends

VUMA_MEM_TYPE_FAST_PAGE		equ 1	;Bit 0: If set, supports fast fage mode DRAM
VUMA_MEM_TYPE_EDO		equ 2	;Bit 1: If set, supports EDO DRAM
VUMA_MEM_TYPE_SYNC_DRAM		equ 4	;Bit 2: If set, supports synchronous DRAM
VUMA_MEM_TYPE_PN_EDO		equ 8	;Bit 3: If set, supports PN EDO DRAM (burst EDO)

;---------------------------------------;


cgroup	group	_text
_text 	segment word public 'CODE'
	assume	cs:cgroup
.386

public DummySmbaVgaBDFNumber
DummySmbaVgaBDFNumber	label word
	db	0FFh, 0FFh

;---------------------------------------;
; FrameBufAdjustSize                    ;
;---------------------------------------;--------------------------------------;
; This function is called just before giving control to the C000 VGA option    ;
; ROM.  The following things are done by this function:                        ;
;                                                                              ;
; 1. If SMBA support is active, get memory size from CMOS and goto step 8      ;
; 2. Scan option ROM for _VUMA_ signature, if not found, set frame buf size to ;
;    zero goto step number 8                                                   ;
; 3. Get minimum memory size field from option ROM                             ;
; 4. Get bus/dev/func number from CMOS, if does not match VGA device, then     ;
;    update CMOS with device's bus/dev/func number and minimum memory size     ;
; 5. Get current memory size from CMOS, update CMOS with minimum if too small  ;
; 6. Call chipset hook to get chipset's supported memory bank bitmap           ;
; 7. Make sure chipset's bank support and VGA device's bank support are        ;
;    compatible, if not, then set memory size to zero                          ;
; 8. Call chipset hook to set shared frame buffer size and bank connection     ;
;                                                                              ;
; Input: AL = Device/Function number device that owns the option ROM           ;
;                Bits 7-3: PCI device number                                   ;
;                Bits 2-0: Function number within the device                   ;
;        AH = Bus number of device that owns the option ROM                    ;
;       EBP = Segment/offset of ROM about to get control (example C0000003h)   ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufAdjustSize	proc near
	pusha
	push	ds

	cmp	ebp, 0C0000003h
	jne	AdjustSizeDone		;Br if not initing VGA option ROM

; If SMBA is active, then set minimum memory size to 0 (no minimum)
; and skip to reading memory size value from CMOS.

	push	ax
	mov	ah, RT_FB_GET_CMOS_DATA
	CALL_RT_FUNCTION		;DX=Mem Size, CH=Flags
	pop	ax

	test	ch, 80h
	jnz	SmbaNotActive		;Br if SMBA interface is not active

	cmp	ax, cs:SmbaVgaBusDevFuncNumber
	je	@f			;Br if using on board SMBA VGA
	xor	dx, dx			;Set SMAB size to 0 for off board VGA
@@:
	xor	ax, ax			;Bank bitmap = 0 (use SMBA bank)
	jmp	short AdjustSizeSetSize	;Memory size is in DX

SmbaNotActive:

; Search for _VUMA_ signature in the option ROM.  If not found set current
; memory size to zero in CMOS and skip to programming the chipset.

	push	ebp			;Set DS = upper word of EBP (ROM segment)
	pop	ds
	pop	ds

	mov	si, 2
	mov	cl, byte ptr [si]	;CL = size of option ROM / 512
	shl	cx, 9			;CX = size of option ROM in bytes

AdjustSizeSearchSig:
	cmp	dword ptr [si], '_VUM'
	je	AdjustSizeFoundSig1	;Br if found first part of _VUMA_ signature
AdjustSizeSearchNext:
	inc	si
	loop	AdjustSizeSearchSig
	jmp	short AdjustSizeToZero

AdjustSizeFoundSig1:
	cmp	word ptr [si+4], 'A_'
	jne	AdjustSizeSearchNext	;Br if entire signature is not present

; The _VUMA_ signature was found.
; Read CMOS to get the current VUMA memory size.  Compare this size against
; the minimum memory size needed by the VUMA device and update CMOS if needed.

	mov	ah, RT_FB_GET_CMOS_DATA
	CALL_RT_FUNCTION		;DX=Mem Size/64k, CH=Flags

	mov	bx, (VumaRomSig ptr [si]).MinMemorySize  ;BX = min memory size/64k
	cmp	dx, bx
	jae	AdjustSizeOk		;Br if current mem size is ok

	mov	dx, bx			;BX = min memory size/64k
	mov	ah, RT_FB_SET_CMOS_DATA
	CALL_RT_FUNCTION		;Update CMOS with new minimum mem size

AdjustSizeOk:

; Frame buffer data in CMOS has been completely validated and fixed if needed.
; Call chipset hook to get chipset's supported memory bank bitmap and validate
; the bank bitmap with the VGA device's bank bitmap.  If they are not compatible
; then set the memory size to 0.  Otherwise call a chipset hook to set the
; current frame buffer memory size and bank.
; DX = current memory size, DS:SI = ptr to VumaRomSig struc

	mov	ah, RT_FB_GET_SUP_BANKS
	CALL_RT_FUNCTION		;AX = banks supported by chipset
	and	ax, (VumaRomSig ptr [si]).SupportedBanks
	jz	AdjustSizeToZero	;Br if chipset and VUMA device's banks
					;   aren't compatible
AdjustSizeSetSize:
	mov	bx, ax			;BX = memory bank bitmap
	mov	ah, RT_FB_SET_SIZE
	CALL_RT_FUNCTION		;Sets size of shared frame buffer memory
					;If error, there is nothing to do
	mov	ah, RT_FB_MAKE_INVISIBLE
	CALL_RT_FUNCTION		;Set frame buffer to visible/invisible

	;Need to set memory hole overlap here if SMBA.........................

AdjustSizeDone:
	pop	ds
	popa
	ret

AdjustSizeToZero:
	xor	dx, dx			;Set memory size to 0
	xor	ch, ch			;CH=Flags
	mov	ah, RT_FB_SET_CMOS_DATA
	CALL_RT_FUNCTION		;Set VUMA/SMBA to not installed
	xor	ax, ax			;Set bank bitmap to all disabled
	jmp	short	AdjustSizeSetSize

FrameBufAdjustSize	endp


;---------------------------------------;
; FrameBufEnableDisableBoot             ;
;---------------------------------------;--------------------------------------;
; This function is called after C800 option ROM control to set the state of    ;
; the shared frame buffer at boot time.  This function should make the shared  ;
; frame buffer area either visible or invisible to the CPU according to the    ;
; current setting stored in CMOS.                                              ;
;                                                                              ;
; Input: Nothing                                                               ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
FrameBufEnableDisableBoot	proc near
;;;;	pusha
;;;;
;;;;	mov	cl, 0			;Get primary VUMA/SMBA entry from CMOS
;;;;	mov	ah, RT_FB_GET_CMOS_DATA
;;;;	CALL_RT_FUNCTION		;DX=Mem Size, CH=Flags
;;;;
;;;;	mov	ah, RT_FB_MAKE_VISIBLE
;;;;	test	ch, 0
;;;;	jnz	@f			;Br if frame buffer should be enabled
;;;;	mov	ah, RT_FB_MAKE_INVISIBLE
;;;;@@:	CALL_RT_FUNCTION		;Set frame buffer to visible/invisible
;;;;
;;;;	popa
	ret
FrameBufEnableDisableBoot	endp



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
