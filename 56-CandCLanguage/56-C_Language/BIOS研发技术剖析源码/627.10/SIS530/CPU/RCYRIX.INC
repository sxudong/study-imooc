;-----------------------------------------------------------------------------;
;
; Cyrix RUNTIME routines
;
;-----------------------------------------------------------------------------;

@CYRIXDEFAULTPARAMTBL:

; (CPU0003)>
CCRTBLSTRUC	<023h,	000h,	001h,	000h,	018h,	001h,	080h,	003h>
;CCRTBLSTRUC	<021h,	000h,	001h,	000h,	000h,	000h,   000h,   000h>
; <(CPU0003)

	public	@CYRIXSMIPARAMTBL

@CYRIXSMIPARAMTBL:

; (CPU0003)>
								; (CPU0039)>
CCRTBLSTRUC	<0A3h,	082h,	081h+(CYRIX_SADS shl 1),	000h,	018h,	001h,	080h,	003h>
;CCRTBLSTRUC	<002h,	082h,	082h,	000h,	000h,	00ah,   000h,   000h>
								; <(CPU0039)
; <(CPU0003)


;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;




		comment ú	 [README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û TITLE: CYRIX CPU DETCTION/PROGRAMMING  Û
		Û					 Û
		Û	****  R U N T I M E  ****	 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		ú



		extrn	IsFPU?		:near

		extrn	Cyrix		:abs

		UnknownCPU	equ	0ffh





		comment ú

		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º	      InitCyrixCPU@Shutdown	     º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º  This routine programs different registers º
		º  of the different Cyrix CPUs. 	     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Environment	    : Stack not available    º
		º		      SS = CS		     º
		º  Invoked	    : from reset time code   º
		º  Restriction	    : DO NOT DESTROY SI, DI  º
		º		      SP, BP AND UPPER 16    º
		º		      BITS OF EAX, EBX, EDX  º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Input	    : AL = CPU#		     º
		º		      CX = Functional field  º
		º  Output	    : none		     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º Reg destroyed : AX, BX, ECX, DX, ESI, EDI  º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		ú


;-----------------------------------------------------------------------------;

Public	CyrixMaskTbl
Public	CyrixMaskTblEnd

CyrixMaskTbl	label	byte

;	      CCR0	 CCR1	    CCR2       CCR3	  CCR4	     CCR5	PCR0	   PMR
;	      ----	 ----	    ----       ----	  ----	     ----	----	   ---

XLCGroup  db  11111111b, 11111111b, 00000000b, 00000000b, 00000000b, 00000000b,	00000000b, 00000000b
SGroup	  db  00000000b, 00010001b, 01110111b, 00000000b, 00000000b, 00000000b, 00000000b, 00000000b
DXGroup	  db  00000000b, 11111111b, 11111110b, 00000011b, 00000000b, 00000000b, 00000000b, 00000000b
;MGroup	  db  00000010b, 10010110b, 10011100b, 00000111b, 10010111b, 00110001b, 00000000b, 00000000b
MGroup	  db  11111111b, 10011110b, 10011110b, 11110011b, 11111111b, 11111111b, 00000000b, 00000000b
M1scGroup db  00000000b, 00001110b, 11011110b, 00001111b, 10011111b, 00000000b, 10000111b, 00000111b


CyrixMaskTblEnd	label	byte

;-----------------------------------------------------------------------------;

CCRNUM		EQU	8	; Number of CCR to program

;-----------------------------------------------------------------------------;

Public	InitCyrixCPU@Shutdown
InitCyrixCPU@Shutdown		proc	near

	cmp	al,UnknownCPU		; CPU is not detected ?
	jz	ret_iccs		; Yes.. no need for initalize
	mov	di,offset @CyrixDefaultParamTbl
	mov	si,offset @CyrixSMIParamTbl
CyrixShareInitCode::
	cld
	mov	dx,sp
	test	cl,SMI			; CPU supports SMI ?
	jz	crx_smi_dis		; No.., do not program for SMI

	mov	bx,cs:word ptr[0fea8h]	; BX = CPU info structure ptr
	mov	ah,cs:[bx].CPUINFOSTRUC.bVndrNum
	mov	bx,cs:word ptr[bx].CPUINFOSTRUC.dSMIInfoPtr
	mov	al,cs:byte ptr[bx].SMIINFOHDRSTRUC.wNUMSMIInfo
	add	bx,sizeof SMIINFOHDRSTRUC
next_crx_scs:
	cmp	cs:[bx].SMIINFOSTRUC.bVendor,ah
	jz	get_crx_scs
	add	bx,sizeof SMIINFOSTRUC
	dec	al
	jnz	next_crx_scs
	jmp	crx_smi_dis
get_crx_scs:
	mov	ax,cs:[bx].SMIINFOSTRUC.wSMICodeSize
	mov	ebx,cs:[bx].SMIINFOSTRUC.dSMICodeSeg
	or	ax,ax
	jz	crx_smi_dis		; Chipset does not support SMI
	JmpDI	prog_smi_addr_size_crx_ti
	mov	di,si			; To program SMI parameters
crx_smi_dis:
	mov	si,cx			; SI = function field
	and	si,0e00h		; Seperate InitCode
	mov	cx,si			; CH = InitCode

;---------------------------------------;
; IF M1/M1sc ENABLE MAP REGISTER....	;
;---------------------------------------;

	cmp	ch,InitM1sc		; M1sc (5x86) CPU ?
	jz	map_enable		; Map enable....
	cmp	ch,InitM1		; M1 style init ?
	jnz	end_men			; No..
map_enable:
	mov	al,0c3h			; CCR3
	CallNS	ReadCCR			; Read current value
	or	ah,010h			; Map Enable
	CallNS	WriteCCR		; Enable all CCR to access
end_men:
;---------------------------------------;
	shr	si,9			; SI = Init code
	imul	si,si,CCRNUM		; SI = Offset in Mask table
	mov	cl,CCRNUM		; CCR0 to CCR5, PCR0, PMR
	xor	bx,bx			; Start CCR
do_pgm_ccr:
	mov	al,cs:byte ptr CCRIndexTbl[bx]
	mov	bh,cs:byte ptr CyrixMaskTbl[si]
	or	bh,bh
	jz	skip_pgm_ccr		; Register is invalid fro this CPU
	CallNS	ReadCCR			; Read current value
	not	bh
	and	ah,bh			; Keep reserved bits unchanged
	not	bh
	and	bh,cs:byte ptr[di]
	or	ah,bh			; AH = data to write, AL = CCR index
	CallNS	WriteCCR		; Program CCR with the value
	xor	bh,bh
skip_pgm_ccr:
	inc	si			; Next mask field
	inc	di			; Next parameter table entry
	inc	bx			; Next CCR
	dec	cl
	jnz	do_pgm_ccr		; Complete programming all CCR
	cmp	ch,InitM1sc		; M1sc (5x86) CPU ?
	jz	prog_m1_regs		; Put Map Enable reg as user defined
	cmp	ch,InitM1		; M1 CPU ?
	jnz	no_m1_regs

prog_m1_regs:
;---------------------------------------;
; program special registers for M1/M1sc	;
;---------------------------------------;

	sub	di,CCRNUM		; DI = CCR Table structure ptr
	mov	al,0c3h			; CCR3, MAP enable register
	mov	ah,cs:byte ptr[di].CCRTBLSTRUC.bCCR3
	CallNS	WriteCCR		; Write user defined value to CCR3

;---------------------------------------;
no_m1_regs:
	cmp	ch,InitS		; 486S CPU ?
	jnz	no_cop_bit		; No.
	CallNS	IsFPU?			; FPU present ?
	jz	no_cop_bit		; Co-processor present, programming OK
	mov	al,0c2h			; CCR2
	CallNS	ReadCCR			; Read CCR2 value in AH
	and	ah,11111110b		; Reset COP bit in CCR2
	CallNS	WriteCCR		; Program CCR2
no_cop_bit:
	mov	sp,dx
ret_iccs:
	ret

InitCyrixCPU@Shutdown		endp


;-----------------------------------------------;
;	PROG_SMI_ADDR_SIZE_CRX_TI ROUTINE	;
;	Input : CX = FuncField			;
;		DI = return address		;
;		AX = SMI code seg size		;
;		EBX= SMI code seg (32 bit)	;
;	Output: NONE				;
;	Register destroyed : ax,ebx		;
;	DO NOT DESTROY DX			;
;	NOTE : COMMON ROUTINE FOR CYRIX/TI CPU	;
;-----------------------------------------------;
Public	prog_smi_addr_size_crx_ti
prog_smi_addr_size_crx_ti	proc	near

	shr	ebx,4				; (bl) high nibble(bits 7-4) A15-A12
						; (bh) (bits 7-0) A23-A16 and so on...
	and	bl,11110000b			; clear if address was not in 4KB boundary
	and	al,00001111b			; (al) = SMI segment size in CYRIX/TI format
	or	bl,al				; (ebx) = SMI code segment address & size
	mov	al,crx_ti_index_reg_cf		; (al) = CYRIX/TI index reg for SMM address region (0cfh)
						; size (bits 3-0) & address bits A15-A12 (bits 7-4)
	mov	ah,bl				; (ah) = data
	CallNS	write_cpu_reg_crx_ti		; write the data
	dec	al				; (al) = CYRIX/TI index reg for SMM address region (0ceh)
						; address bits A23-A16 (bits 7-0)
	shr	ebx,8				;
	mov	ah,bl				; (ah) = data
	CallNS	write_cpu_reg_crx_ti		; write the data
	test	cl,01100000b			; Test for BUS size (16 bit?)
	jz	prog_smi_addr_size_crx_ti_00	; Bus size 16 bit
	dec	al				; (al) = CYRIX/TI index reg for SMM address region (0cdh)
						; address bits A31-A24 (bits 7-0)
	shr	ebx,8				;
	mov	ah,bl				; (ah) = data
	CallNS	write_cpu_reg_crx_ti		; write the data
prog_smi_addr_size_crx_ti_00:
	jmp	di

prog_smi_addr_size_crx_ti	endp


		    comment ú

		    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		    º	       EnableCyrixCache 	   º
		    ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		    º  This routine enables the internal   º
		    º  cache for any Cyrix CPU. 	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Environment   : Stack available     º
		    º  Invoked	     : At any time	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Input	     : AL   = CPU#	   º
		    º		       CX   = FuncField	   º
		    º		       ECX+ = Extended	   º
		    º			      FuncField	   º
		    º		       EDX  = ResetID	   º
		    º  Output	     : CF = 0 (JNC) as	   º
		    º		       successful	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º	   Registers Destroyed: EAX	   º
		    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		    ú


Public	EnableCyrixCache
EnableCyrixCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	and	eax,0bfffffffh		; Enable cache
	mov	cr0,eax 		; Write to CR0
	clc				; CF = 0
	ret

EnableCyrixCache	endp


		    comment ú

		    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		    º	       DisableCyrixCache	   º
		    ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		    º  This routine disables the internal  º
		    º  cache for any Cyrix CPU. 	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Environment   : Stack available     º
		    º  Invoked	     : At any time	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Input	     : AL   = CPU#	   º
		    º		       CX   = FuncField	   º
		    º		       ECX+ = Extended	   º
		    º			      FuncField	   º
		    º		       EDX  = ResetID	   º
		    º  Output	     : CF = 0 (JNC) as	   º
		    º		       successful	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º	   Registers Destroyed: EAX	   º
		    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		    ú


Public	DisableCyrixCache
DisableCyrixCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	or	eax,40000000h		; Disable cache
	mov	cr0,eax 		; Write to CR0
	wbinvd				; Invalidate WB/WT cache
	clc				; CF = 0
	ret

DisableCyrixCache	endp


		    comment ú

		    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		    º	         FlushCyrixCache	   º
		    ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		    º  This routine invalidates internal   º
		    º  cache for any Cyrix CPU. 	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Environment   : Stack available     º
		    º  Invoked	     : At any time	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Input	     : AL   = CPU#	   º
		    º		       CX   = FuncField	   º
		    º		       ECX+ = Extended	   º
		    º			      FuncField	   º
		    º		       EDX  = ResetID	   º
		    º  Output	     : CF = 0 (JNC) as	   º
		    º		       successful	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Registers Destroyed: none 	   º
		    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		    ú


Public	FlushCyrixCache
FlushCyrixCache		proc	near

	jmp	FlushCacheStandard

FlushCyrixCache		endp


		    comment ú

		    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		    º	        DisableCyrixBTB		   º
		    ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		    º  This routine disable the BTB of the º
		    º  Cyrix CPU.		 	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Environment   : Stack available	   º
		    º  Invoked	     : At any time	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Input	     : AL   = CPU#	   º
		    º		       CX   = FuncField	   º
		    º		       ECX+ = Extended	   º
		    º			      FuncField	   º
		    º		       EDX  = ResetID	   º
		    º  Output	     : none 		   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Registers Destroyed: none 	   º
		    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		    ú


Public	DisableCyrixBTB
DisableCyrixBTB		proc	near

	push	bx
	mov	bl,0			; Disable code
	call	EnDisBTB
	pop	bx
	ret

DisableCyrixBTB		endp


		    comment ú

		    ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		    º	         EnableCyrixBTB		   º
		    ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		    º  This routine disable the BTB of the º
		    º  Cyrix CPU.		 	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Environment   : Stack available	   º
		    º  Invoked	     : At any time	   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Input	     : AL   = CPU#	   º
		    º		       CX   = FuncField	   º
		    º		       ECX+ = Extended	   º
		    º			      FuncField	   º
		    º		       EDX  = ResetID	   º
		    º  Output	     : none 		   º
		    ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		    º  Registers Destroyed: none 	   º
		    ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		    ú


Public	EnableCyrixBTB
EnableCyrixBTB		proc	near

	push	bx
	mov	bl,1			; Disable code
	call	EnDisBTB
	pop	bx
	ret

EnableCyrixBTB		endp


;-----------------------------------------------------------------------------;
;				ROUTINES USED				      ;
;-----------------------------------------------------------------------------;

Public	read_cpu_reg_crx_ti
Public	ReadCCR

read_cpu_reg_crx_ti:
ReadCCR:
;---------------------------------------;
;  Read Configuration Control register	;
;  Input  : AL = CCR index		;
;  Output : AH = register value		;
;---------------------------------------;
;  AL will be restored, no register destroyed

	cli
	out	22h,al			; Out Index
	io_delay
	mov	ah,al
	in	al,23h			; Get data
	io_delay
	xchg	al,ah			; AH = data, AL = Index
	ret
;---------------------------------------;

Public	write_cpu_reg_crx_ti
Public	WriteCCR

write_cpu_reg_crx_ti:
WriteCCR:
;---------------------------------------;
;  Write Configuration Control Register	;
;  Input  : AL = Index, AH = data	;
;  Output : none			;
;---------------------------------------;
;  AX will be restored, no register destroyed


	cli				; Disable interrupts
	out	22h,al			; Out Index
	io_delay
	xchg	al,ah			; AL = data to write, AH = Index
	out	23h,al			; Write CCR
	io_delay
	xchg	al,ah			; Restore AX
	ret
;---------------------------------------;

Public	DummyReadCCR
DummyReadCCR:

	if	XLCSPRESENCE
	cli
	mov	ah,al			; AH = current CCR to test
	mov	al,0c0h 		; Dummy read for CCR-0
	out	22h,al			; Out Index
	io_delay
	in	al,23h			; Get CCR0 value
	io_delay
	mov	al,ah			; AL = current CCR to test
	ret
	endif

;---------------------------------------;

EnDisBTB:
;---------------------------------------;
; This routine Enables or Disables BTB	;
; Input	: BL = 0: disable		;
;	     = 1: enable		;
;---------------------------------------;

	if	M1PRESENCE
	push	eax
	push	cx
	and	ch,00001110b		; Separate Init code
;CHIPA - Removed for space, only supporting M1 style Cyrix cpu's
;	cmp	ch,InitM1		; M1 style CPU ?
;	jnz	ret_dcbtb		; No..
	mov	al,0c3h
	call	ReadCCR			; Read current CCR3 in AH
	push	ax
	and	ah,0fh
	or	ah,10h			; To enable all CCR access
	call	WriteCCR		; MAPEN, all CCR
	mov	al,30h
	call	ReadCCR			; Read DEBUG REG in AH
	push	ax
	or	ah,01000000b		; Set bit 6
	call	WriteCCR
	mov	eax,28h
	MovEAXtoTR1			; Select Index 5
	MovTR2toEAX			; EAX = Index 5
;	mov	cl,al			;   052996: CL = read from TR1
	and	al,11110000b
	or	bl,bl			; Disable or Enable ?
	jnz	do_btb			; Enable
	or	al,00001111b
do_btb:
	MovEAXtoTR2			; Write new data
	mov	eax,3
	MovEAXtoTR1			; Set BTB flush
	mov	al,0
	MovEAXtoTR1			; Clear BTB flush
	pop	ax			; AH = old DEBUG REG val, AL = 30h
	call	WriteCCR		; Restore DEBUG REG
	pop	ax			; AH = old MAPEN val, AL = CCR3 index
	call	WriteCCR		; Restore MAPEN reg
ret_dcbtb:
;	mov	bl,cl			;   052996
;	and	bl,1			; keep bit0
;	xor	bl,1			; convert to: 0 = disabled, 1 = enabled
	pop	cx
	pop	eax


	endif
	ret


