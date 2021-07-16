;-----------------------------------------------------------------------------;
;
; Intel POST routines
;
;-----------------------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


		comment ๚	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û TITLE: INTEL CPU DETCTION/PROGRAMMING  Û
		Û					 Û
		Û	    ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚



		extrn	GetHandle		:near
		extrn	get_processor_info	:near

		extrn	_USWC_STATE		:byte
		extrn	_L1_CACHE_STATE		:byte
		extrn	_SHADOW_STATE		:word
		extrn	uncom_segment		:word
		extrn	cpu_extd_func_field	:word
		extrn	_TOP_OF_MEM		:dword
		extrn	_NC_REG1_START		:dword
		extrn	_NC_REG1_END		:dword
		extrn	_NC_REG2_START		:dword
		extrn	_NC_REG2_END		:dword
		extrn	_USWC_REG1_START	:dword
		extrn	_USWC_REG1_END		:dword
		extrn	_USWC_REG2_START	:dword
		extrn	_USWC_REG2_END		:dword

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;

		P6MicroCodeBlkSize	EQU	2048

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;



		comment ๚

		ษอออออออออออออออออออออออออออออออออออออออออออป
		บ	    FindIntelFamilyMember	    บ
		ฬอออออออออออออออออออออออออออออออออออออออออออน
		บ This routine detects individual member    บ
		บ from the Intel database. This routine     บ
		บ can detect any kind of Intel CPU at any   บ
		บ instant of time.			    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Environment	 : Stack available	    บ
		บ Invoked	 : from any time	    บ
		บ Restriction	 : DO NOT DESTROY ANY REG.  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Input 	 : CL = 0: no CPUID	    บ
		บ			1: CPUID present    บ
		บ Output	 : AX = CPUHandle	    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ	  Register Destroyed : AX	    บ
		ศอออออออออออออออออออออออออออออออออออออออออออผ

		๚


Public	FindIntelFamilyMember
FindIntelFamilyMember		proc	near

	pushad
	mov	bp,sp
	call	GetResetID		; DX <- CPU ResetID
	mov	ax,dx

	and	al,0f0h			; Stepping info 0, normal CPU
					; $$$CPU0021+ >>>
;---------------------------------------;
if (CPU_686)
	cmp	ax,0650h		; Family=6, Model=5 ?
	jnz	not_celeron		; no..
	push	eax
	push	ecx
        mov     ecx,BBL_CR_CTL3         ; L2 control register 3 (CTL3).
	RD_MSR
        bt	eax,23			; bit23=1 ?
	pop	ecx
	pop	eax
	jnc	not_celeron		; no.. not Celeron
	mov	al,50h			; changed to match table
	jmp	short no_step_f
not_celeron:
;---------------------------------------; (CPU0034+)>
	cmp	ax,0670h		; Katmai or Xenon ?
	jne	not_0670
	push	eax
	push	ecx
	mov	ecx,017h		; MSR 017h
	RD_MSR
	shr	edx,50-32
	and	dl,07h
	pop	ecx
	pop	eax
	cmp	dl,02h			; Slot 2 Processor
	jne	not_xeon
	mov	al,70h			; give id for Xeon in table
	jmp	short no_step_f
not_xeon:
not_0670:
endif;	if (CPU_686)
;---------------------------------------; <(CPU0034+)
					; $$$CPU0021+ <<<
	or	cl,cl			; S-series CPU (CPUID) ?
	jz	no_step_f		; no..
	or	al,0fh			; Steppping info indicates S-Series
no_step_f:
	mov	bx,offset Intel_Family_Data_base
	call	GetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Get back reg, return parameters
	ret

FindIntelFamilyMember		endp



		  comment ๚

		  ษอออออออออออออออออออออออออออออออออออออออป
		  บ	   GetIntelCPUHandle@Reset	  บ
		  ฬอออออออออออออออออออออออออออออออออออออออน
		  บ This routine returns the CPUHandle at บ
		  บ the time of reset.			  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Environment : No stack available	  บ
		  บ		  SS = CS		  บ
		  บ Invoked	: from reset time code	  บ
		  บ Restriction : DO NOT DESTROY ESP+     บ
		  บ		  SP, BP AND UPPER 16 BITSบ
		  บ		  OF EAX, EBX, EDX	  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Input	: DX = ResetID		  บ
		  บ Output	: AX = CPUHandle	  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Register destroyed : AX,BX,CX,DX,ESP+ บ
		  ศอออออออออออออออออออออออออออออออออออออออผ

		  ๚



Public	GetIntelCPUHandle@Reset
GetIntelCPUHandle@Reset 	proc	near

	mov	ax,dx			; AX <- ResetID
	or	al,0fh			; To discard stepping info
	mov	si,sp			; Save current SP
	mov	bx,offset Intel_Family_Data_base
	CallNS	GetHandle		; AX = CPUHandle
	mov	sp,si			; Get back original SP
	mov	dx,cx			; DX = ResetID/CPUID
	ret

GetIntelCPUHandle@Reset 	endp


		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	      InitIntelCPU@Reset	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different Intel CPUs. 	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack not available    บ
		บ		      SS = CS		     บ
		บ  Invoked	    : from reset time code   บ
		บ  Restriction	    : DO NOT DESTROY         บ
		บ		      SP, BP AND UPPER 16    บ
		บ		      BITS OF EAX, EBX, EDX  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : AX = CPUHandle	     บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Register destroyed : EAX, BX, DX, EDI     บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚


Public	InitIntelCPU@Reset
InitIntelCPU@Reset		proc	near

	mov	edi,eax
	mov	bx, offset Intel_Family_Data_Base
	add	bx,4			; Skip the header
	mov	cx,sizeof FAMILYSTRUC
	mul	cx			; AX = offset in the family database
	add	bx,ax
	cmp	cs:[bx].FAMILYSTRUC.bCPUNum,UnknownCPU
	jz	end_init_i2		; Unknown CPU, no need for initialize

	mov	ax,cs:[bx].FAMILYSTRUC.wFuncField
	and	ah,00001110b		; Separate InitCode
	jz	take_i386		; It is a 386 processor, take care
	cmp	ah,InitP6		; P6 style init ?
	jnz	end_init_i2		; No..

;---------------------------------------;
; P6 STYLE INIT....			;
;---------------------------------------;

	if	P6PRESENCE
;	jmp	KlamathInit		; Initialize special regs for Klamath
;AfterKlamathInit::
if (MKF_NCPU eq 1)
	call	ConfigureL2Cache
endif
	mov	eax,cr0			; Read current CR0
	and	eax,9fffffffh
	or	eax,40000000h
	mov	cr0,eax			; Disable cache
	wbinvd				; Flush cache
	mov	eax,cr3
	mov	cr3,eax			; Flush TLB
	mov	ecx,MTRRdefType
	xor	eax,eax
	xor	edx,edx
	WR_MTRR				; Disable all MTRR
;---------------------------------------;
	mov	cx,MTRRfix64K_0000
	WR_MTRR
	add	cl,8
	WR_MTRR
	inc	cx
	WR_MTRR
	mov	cx,MTRRfix4K_C000
	mov	bl,8
init_fix_mtrr:
	WR_MTRR
	inc	cx
	dec	bl
	jnz	init_fix_mtrr
	mov	cx,MTRRphysBase0
	mov	bl,8
init_var_mtrr:
	WR_MTRR
	inc	cx
	WR_MTRR
	inc	cx
	dec	bl
	jnz	init_var_mtrr

	mov	edx,04040404h		; WT cache
	mov	eax,edx
	mov	ecx,MTRRfix64K_0000	; 0KB - 512KB
	WR_MTRR

	mov	ecx,MTRRfix16K_8000	; 512KB - 640KB
	WR_MTRR

;	mov	edx,04040404h		; WT cache
;	mov	eax,edx

;	mov	ecx,MTRRfix4K_E000	; E0000 - E7FFF shadow MTRR
;	WR_MTRR
;	inc	cx			; E8000 - EFFFF shadow MTRR
;	WR_MTRR

	mov	ecx,MTRRfix4K_F000	; F0000 - F7FFF shadow MTRR
	WR_MTRR
	inc	cx			; F8000 - FFFFF shadow MTRR
	WR_MTRR
;---------------------------------------;
	mov	ecx,MTRRdefType
	xor	edx,edx
	mov	eax,00000c00h
	WR_MTRR				; Enable fixed and variable MTRR
	wbinvd				; Flush cache
	mov	eax,cr3
	mov	cr3,eax			; Flush TLB

	mov	eax,cr0			; Read current CR0
	and	eax,9fffffffh
	mov	cr0,eax			; Enable cache
	wbinvd				; Flush cache

	jmp	short end_init_i2
	endif
take_i386:
	mov	eax,cr0
	or	al,10h			; Set 387 bit ( PATCH FOR 386/387 )
	mov	cr0,eax
end_init_i2:
	mov	eax,edi			; EAX restored
	ret

InitIntelCPU@Reset		endp


					; $$$CPU0021+ >>>
;-----------------------------------------------------------------------------;
	if	P6PRESENCE
        extrn           ConfigureL2Cache:near

;------------------------------------------------------------------
;klamath INIT
;------------------------------------------------------------------
;klamath equates
;------------------------------------------------------------------
	tagram_cr0	equ	0	;stepping and device id
	tagram_cr1	equ	1	;manufacture id
	tagram_cr2	equ	2	;l2 cache size
	tagram_cr3	equ	3	;physical cacheable space
	tagram_cr4	equ	4	;latency mode
	tagram_cr5	equ	5	;error type
	tagram_cr6	equ	6	;associativity and sector err

	BBL_CR_ADRL	EQU 	116H
	BBL_CR_D0L	EQU	88H
	BBL_CR_D1L	EQU	89H
	BBL_CR_D2L	EQU	8AH
	BBL_CR_D3L	EQU	8BH
	BBL_CR_DECC	EQU	118H
	BBL_CR_ADDR_L	EQU	116H
	BBL_CR_TRIG	EQU	11AH
	BBL_CR_BUSY	EQU	11BH
	BBL_CR_CTL0	EQU	119H
	BBL_CR_CTL3	EQU	11EH

;L2 COMMAND BITS (Bits 0:4 of ctl0)

	L2_CMD_RLU	EQU	00001100B
	L2_CMD_TRR	EQU	00001110B
;       L2_CMD_TWR      EQU     00001011B
;       L2_CMD_TWW      EQU     00011111B
;       L2_CMD_TW       EQU     00010011B
        L2_CMD_TWR      EQU     00001000B
        L2_CMD_TWW      EQU     00011100B
        L2_CMD_TW       EQU     00010000B

	L2_CMD_TR	EQU	00001111B
	L2_CMD_CR	EQU	00000010B
	L2_CMD_CW	EQU	00000011B

	LowLatMode	equ	01h
	BusyWaitCount	equ	800h
	BusyBitSet	equ	1
	BSBHang		equ	42h
	ServerL2	equ	43h
	High32Pattern0	equ	0aaaaaaaah
	low32pattern0	equ	0aaaaaaaah
	high32Patternalias	equ	55555555h
	Low32PatternAlias	equ	55555555h
	MaxCacheSupport	equ	4d*1024d*1024d	;8mb is max cache supported

;--------------------------------------------------------------------
;macros
;--------------------------------------------------------------------

ReadMSR	Macro MSRIndex
	mov	ecx,MSRIndex
	db	0fh,32h		;rdmsr
endm
writeMSR	Macro MSRIndex,Low32bitData,High32BitData
	mov	ecx,MSRIndex
	mov	edx,High32BitData
	mov	eax,Low32BitData
	db	0fh,30h		;wrmsr
endm
ChangeMSR Macro MSRIndex,Low32BitANDPattern,High32bitANDPattern,Low32BitORPattern,High32BitORPattern
	readMSR	MSRIndex
	and	eax,Low32BitANDPattern
	or	eax,Low32BitORPattern
	and	edx,High32bitANDPattern
	or	edx,High32BitORPattern
	db	0fh,30h	;wrmsr
endm

	endif
						; $$$CPU0021+ <<<


		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	    InitIntelCPUBeforeBOOT	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This procedure initialize the registers   บ
		บ  to configure the memory region.	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack available        บ
		บ  Invoked	    : Anytime after InitCPU  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : none		     บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Register destroyed : EAX, EBX, ECX, EDX   บ
		บ                       DS                   บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚


	IntelInitTbl:

		if	P6PRESENCE
		dw	offset ret_iibb		; 386 class
		dw	offset ret_iibb		; 486 class
		dw	offset ret_iibb		; Pentium class
		dw	offset init_p6		; P6 class
		endif

Public	InitIntelCPUBeforeBOOT
InitIntelCPUBeforeBOOT		proc	near

	if	P6PRESENCE
	in	al,21h
	mov	ah,al
	jcxz	$+2
	jcxz	$+2
	in	al,0a1h
	push	ax
	mov	al,0ffh
	out	21h,al
	jcxz	$+2
	out	0a1h,al

	cli
	call	get_processor_info	; AX = FuncField, EDX = ResetID
	and	ax,0e00h		; Seperate Init code
	shr	ax,8
	mov	si,ax
	jmp	cs:word ptr IntelInitTbl[si]

;---------------------------------------;
; MTRR INITIALIZATION FOR P6/P55CT....	;
; EDX = ResetID
;---------------------------------------;
init_p6::

; For Klamath do not cache over 512MB memory
	if	KLAMATH512MBFORCE
	and	dx,0fff0h		; Mask stepping info
	cmp	dx,0630h		; Klamath ?
	jnz	cmn_p6			; No..
	cmp	cs:dword ptr _TOP_OF_MEM,((512*1024)*1024)
	jbe	cmn_p6
	mov	cs:dword ptr _TOP_OF_MEM,((512*1024)*1024)
	endif
cmn_p6:
	mov	eax,cr0			; Read current CR0
	push	eax			; Save it
	and	eax,9fffffffh
	or	eax,40000000h
	mov	cr0,eax			; Disable cache
	wbinvd				; Flush cache
	mov	eax,cr3
	mov	cr3,eax			; Flush TLB
	mov	ecx,MTRRdefType
	xor	eax,eax
	xor	edx,edx
	WR_MTRR				; Disable all MTRR
	cmp	bh,P55CT		; For P55CT no USWC possible
	jz	init_p55ct

;---------------------------------------;
; USWC MTRR....				;
;---------------------------------------;

	test	cs:_USWC_STATE,1	; VGA memory USWC ?
	jz	skip_vga_uswc		; No..
	xor	eax,eax
	xor	edx,edx
	if	A000SEGUSWC
	mov	eax,01010101h		; A000 seg to be USWC
	endif
	if	B000SEGUSWC
	mov	edx,01010101h		; B000 seg to be USWC
	endif
	mov	cx,MTRRfix16K_A000	; For VGA memory
	WR_MTRR
skip_vga_uswc:

;---------------------------------------;
; BASE MEMORY MTRR....			;
;---------------------------------------;
init_p55ct:
	push	40h
	pop	ds			; DS = global data segment
	mov	edx,04040404h		; WT cache
	test	cs:_L1_CACHE_STATE,1
	jz	ok_l1c
	mov	edx,06060606h		; WB cache
ok_l1c:
	mov	eax,edx
	if	BASE512KNC
	push	edx
	push	eax
	xor	edx,edx
	xor	eax,eax
	mov	cx,MTRRfix64K_0000	; For main memory
	WR_MTRR
	pop	eax
	pop	edx
	else
	mov	cx,MTRRfix64K_0000	; For main memory
	WR_MTRR
	endif
	cmp	ds:word ptr[13h],512	; Memory is 512K or 640K ?
	jbe	base_ok			; 512K
	if	BASE512TO640KNC
	xor	edx,edx
	xor	eax,eax
	endif
	mov	cx,MTRRfix16K_8000
	WR_MTRR

;---------------------------------------;
; ROM SHADOW MTRR....			;
;---------------------------------------;
base_ok:
	mov	si,cs:word ptr _SHADOW_STATE
	push	ds
	push	0c000h
	pop	ds
	mov	al,ds:[02h]
	pop	ds
	cmp	al,40h			; 32KB
	jbe	short vgalessthanequal32k
	test	si,03h			; Video Cahceable?
	jz	short vgalessthanequal32k
	cmp	al,60h			; 48KB
	jb	short vgalessthanequal32k
	or	si,04h			; C800-CBFF
vgalessthanequal32k:

	mov	bl,8			; Eight 32K define MTRR
	mov	cx,MTRRfix4K_F800	; Start from shadow F8000 - FFFFF
do_shdw_mtrr:
	xor	edx,edx
	xor	eax,eax
	shl	si,1			; This 16K shadow cacheable ?
	jnc	no_sc1			; No..
	or	edx,05050505h		; This 16K WP cache
no_sc1:
	shl	si,1			; This 16K shadow cacheable ?
	jnc	no_sc2			; No..
	or	eax,05050505h		; This 16K WP shadow
no_sc2:
	WR_MTRR
	dec	cx			; Previous 32K shadow define MTRR
	dec	bl
	jnz	do_shdw_mtrr		; Complete all shadow MTRR

;---------------------------------------;
; ABOVE 1MB VARIABLE MTRR....		;
;---------------------------------------;

	mov	bl,04h			; Type WT cache
	test	cs:byte ptr _L1_CACHE_STATE,1
	jz	ok_eml1c
	mov	bl,06h			; Type WB cache
ok_eml1c:
	mov	bh,6			; Maximum we can use 6 MTRR
	mov	esi,0			; Start address offset
	mov	edi,cs:_TOP_OF_MEM	; Top of memory address
	mov	cx,BBL_CR_CTL3
	db	0fh,32h			; rdmsr
	mov	edx,20000000h		; 512MB
	shr	eax,20
	and	al,07h			; Check Bits 22:20
	cmp	al,03h			; >=4GB
	jae	check_cacheable_range_done
	mov	cl,al
	shl	edx,cl
	cmp	edi,edx
	jbe	check_cacheable_range_done
	mov	edi,edx
check_cacheable_range_done:
	mov	cx,MTRRphysBase0
	xor	edx,edx
next_mtrr:
	call	GetNextPowerOfTwo	; EDI = possible power of two value
	add	edi,esi			; EDI = top of region
	push	eax			; Save the remaining part
	mov	eax,esi			; Start address
	or	al,bl			; Put cache info
	push	edi
;;;;	dec	edi			; End address
	call	WrVarMTRR_X
	pop	esi			; ESI = offset to start address
	pop	edi			; Remaining size
	or	edi,edi
	jz	end_var_mtrr_job	; End of MTRR programming
	dec	bh
	jnz	next_mtrr

;---------------------------------------;
; USWC MEMORY....			;
; USWC region is always power of 2	;
;---------------------------------------;
end_var_mtrr_job:

	mov	bl,01			; USWC type
	mov	eax,_USWC_REG1_START
	mov	edi,_USWC_REG1_END
;;;;	dec	edi
	or	al,bl			; Cache info
	call	WrVarMTRR_X		; First USWC MTRR

	mov	eax,_USWC_REG2_START
	mov	edi,_USWC_REG2_END
;;;;	dec	edi
	or	al,bl			; Cache info
	call	WrVarMTRR_X		; First USWC MTRR

;---------------------------------------;
; UC MTRR....				;
;---------------------------------------;

	mov	eax,cs:dword ptr _NC_REG1_START
	mov	edi,cs:dword ptr _NC_REG1_END
	call	WrUCMTRR
	mov	eax,cs:dword ptr _NC_REG2_START
	mov	edi,cs:dword ptr _NC_REG2_END
	call	WrUCMTRR

;---------------------------------------;
; RESTORE CR0....			;
;---------------------------------------;

end_mtrr_job:
	mov	ecx,MTRRdefType
	xor	edx,edx
	mov	eax,00000c00h
	WR_MTRR				; Enable fixed and variable MTRR
	wbinvd				; Flush cache
	mov	eax,cr3
	mov	cr3,eax			; Flush TLB
	pop	eax
	mov	cr0,eax

	call	LoadP6MicroCode		; Load P6 patch ๆcode....

ret_iibb::
	pop	ax
	out	0a1h,al
	jcxz	$+2
	mov	al,ah
	out	21h,al
					; (CPU0035+)>
	extern	Q_P3_SERIAL_NO(zero_equ):abs
	call	GetResetID		; DX <- CPU ResetID
	and	dl,0f0h
	cmp	dx,0670h		; Pentium III and later ?
	jb	short p3_serial_no_done	; no..
	mov	al,Q_P3_SERIAL_NO
	or	al,al			; question exist in SSP ?
	jz	p3_serial_no_done	; no.. done
	call	get_cmos_item
	jnz	short p3_serial_no_done
        mov     ecx,0119h
	RD_MSR
        bts	eax,21			; Disable Processor Serial Number
	WR_MSR
p3_serial_no_done:
					; <(CPU0035+)
	endif
	ret

InitIntelCPUBeforeBOOT		endp

;---------------------------------------;
; WRITE VARIABLE MTRR AS UC TYPE....	;
;---------------------------------------;
; Input : EAX = start region address	;
;	  EDI = end region address	;
;	  EDX = set to 00000000h	;
; Output: CF  = 0 (NC): no error in reg ;
;	 	1 (CY): error, invalid	;
;			region		;
;---------------------------------------;

	if	P6PRESENCE
WrVarMTRR:
	and	ax,0f000h		; Type UC
WrVarMTRR_X:

;---------------------------------------;
; WRITE VARIABLE MTRR WITH USER TYPE..	;
;---------------------------------------;

	cmp	ecx,MTRRPhysBase6	; Cannot use 6 & 7 (reserved for OS)
	jge	ret_wvm
	call	CheckValidReg		; Is a valid region ?
	jc	ret_wvm			; No.. skip doing this
	WR_MTRR
	inc	cx			; Mask MTRR

	sub	edi,eax			; EDI = range

	not	edi			; Inverse address
;;;;;	or	eax,edi			; For old algorithm...
	mov	eax,edi			; For new MTRR layout (P6, step B0/C0)

	and	ax,0f000h		; EDI = MaskMTRR value to write
	or	ah,00001000b		; Set VE = 1, enable this MTRR
	push	dx
	or	dl,0fh			; Bit 32-35 = 0 for address (1 in mask)
	WR_MTRR
	pop	dx
	inc	cx			; Next Physical base MTRR
	clc				; MTRR programming OK
	ret
ret_wvm:
	stc				; ERROR! MTRR is not programmed
	ret

;---------------------------------------;
; SET UC HOLE IN THE MTRR....		;
;---------------------------------------;
; Input : EAX = start region address	;
;	  EDI = end region address	;
;	  EDX = set to 00000000h	;
; Output: CF  = 0 (NC): no error in reg ;
;	 	1 (CY): error, invalid	;
;			region		;
;---------------------------------------;

WrUCMTRR:
	push	ecx
	call	CheckValidReg		; Is a valid region ?
	jc	chk_next_uc		; No.. skip doing this
	cmp	eax,(1024*1024)		; UC memory below 1MB ?
	jnc	above_1m_uc		; No..
	call	AdjustBelow1MB		; Take care below 1MB memory regions
	jmp	short chk_next_uc
above_1m_uc:
	call	WrVarMTRR
chk_next_uc:
	pop	ecx
	ret

;---------------------------------------;
; CHECK REGION VALIDITY....		;
;---------------------------------------;
; Input : EAX = start region address	;
;	  EDI = end region address	;
; Output: CF  = 0 (NC): no error in reg ;
;	 	1 (CY): error, invalid	;
;			region		;
;---------------------------------------;

CheckValidReg:
	cmp	edi,0ffffffffh		; Top region defined ?
	jz	ret_cvr			; No.. skip
	cmp	edi,eax			; End address is greater than start ?
	jbe	ret_cvr			; No.. skip
	ret
ret_cvr:
	stc
	ret

;---------------------------------------;
; SET UC HOLE IN BELOW 1MB MTRR....	;
;---------------------------------------;
; Input : EAX = start region address	;
;	  EDI = end region address	;
; Output: none				;
;---------------------------------------;

MTRRSTRUC	STRUCT

	dAddr	dword	?		; Block address
	dMaskH	dword	?		; High Mask
	dMaskL	dword	?		; Low Mask
	wMTRR	word	?		; MTRR Index

MTRRSTRUC	ENDS


_mtrr_tbl:

;		Addr	Mask-high	Mask-Low	mtrr
;		----	---------	--------	----

MTRRSTRUC     { 00000h,	0ffffffffh,	0ffffff00h,	MTRRfix64K_0000 }
MTRRSTRUC     { 10000h,	0ffffffffh,	0ffff00ffh,	MTRRfix64K_0000 }
MTRRSTRUC     { 20000h,	0ffffffffh,	0ff00ffffh,	MTRRfix64K_0000 }
MTRRSTRUC     { 30000h,	0ffffffffh,	000ffffffh,	MTRRfix64K_0000 }
MTRRSTRUC     { 40000h,	0ffffff00h,	0ffffffffh,	MTRRfix64K_0000 }
MTRRSTRUC     { 50000h,	0ffff00ffh,	0ffffffffh,	MTRRfix64K_0000 }
MTRRSTRUC     { 60000h,	0ff00ffffh,	0ffffffffh,	MTRRfix64K_0000 }
MTRRSTRUC     { 70000h,	000ffffffh,	0ffffffffh,	MTRRfix64K_0000 }
MTRRSTRUC     { 80000h,	0ffffffffh,	000000000h,	MTRRfix16K_8000 }
MTRRSTRUC     { 90000h,	000000000h,	0ffffffffh,	MTRRfix16K_8000 }
MTRRSTRUC     { 0A0000h,0ffffffffh,	000000000h,	MTRRfix16K_A000 }
MTRRSTRUC     { 0B0000h,000000000h,	0ffffffffh,	MTRRfix16K_A000 }
MTRRSTRUC     { 0C0000h,000000000h,	000000000h,	MTRRfix4K_C000  }
MTRRSTRUC     { 0C8000h,000000000h,	000000000h,	MTRRfix4K_C800  }
MTRRSTRUC     { 0D0000h,000000000h,	000000000h,	MTRRfix4K_D000  }
MTRRSTRUC     { 0D8000h,000000000h,	000000000h,	MTRRfix4K_D800  }
MTRRSTRUC     { 0E0000h,000000000h,	000000000h,	MTRRfix4K_E000  }
MTRRSTRUC     { 0E8000h,000000000h,	000000000h,	MTRRfix4K_E800  }
MTRRSTRUC     { 0F0000h,000000000h,	000000000h,	MTRRfix4K_F000  }
MTRRSTRUC     { 0F8000h,000000000h,	000000000h,	MTRRfix4K_F800  }

_mtrr_tbl_end:


AdjustBelow1MB:
	xor	ecx,ecx
	mov	si,offset _mtrr_tbl
next_mtrr_start:
	cmp	eax,cs:[si].MTRRSTRUC.dAddr
	jg	inc_chk_addr			; Region not found yet, try..
next_mtrr_end:
	mov	cx,cs:[si].MTRRSTRUC.wMTRR
	RD_MTRR					; EDX|EAX = current MTRR value
	and	edx,cs:[si].MTRRSTRUC.dMaskH
	and	eax,cs:[si].MTRRSTRUC.dMaskL
	WR_MTRR
	add	si,sizeof MTRRSTRUC
	cmp	si,offset _mtrr_tbl_end		; End of below 1MB adjust ?
	jz	ret_ab1m			; Yes..
	cmp	edi,cs:[si].MTRRSTRUC.dAddr
	jg	next_mtrr_end
	jmp	short ret_ab1m
inc_chk_addr:
	add	si,sizeof MTRRSTRUC
	jmp	short next_mtrr_start
ret_ab1m:
	ret

;-----------------------------------------------;
; GET NEXT POWER OF TWO:			;
;						;
; This routine finds next possible value which	;
; is a power of two.				;
;	input	: EDI = input address value	;
;	output	: EDI = an address value >= 	;
;			input EDI which is a	;
;			power of two.		;
;		  EAX = difference between the	;
;			output and input values	;
;-----------------------------------------------;

GetNextPowerOfTwo	PROC	NEAR

	push	ebx
	mov	eax,edi			; EAX = input address value
	bsr	ebx,edi			; EBX = bit pos of first 1 from left
	jz	ret_gnpt		; Memory not implemented
	xor	edi,edi
	bts	edi,ebx			; EDI = largest 2^n memory block
ret_gnpt:
	sub	eax,edi			; EAX = remaining, EDI = 2^n
	pop	ebx
	ret

GetNextPowerOfTwo	ENDP


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;


;---------------------------------------;
; P6 MICRO CODE UPDATE HEADER STRCTURE	;
;---------------------------------------;

P6MICROCODEHDRSTRUC	STRUCT

  dVersion	dword	?		; Header version#
  dPatchRev	dword	?		; Update patch revision
  dDate		dword	?		; Update date
  dCPUID	dword	?		; Family/Model/Stepping of processor
  dChecksum	dword	?		; Checksum of update data & header
  dLoaderRev	dword	?		; Loader version# for this update
  sReserved	byte	24 dup(?)	; Reserved fields

P6MICROCODEHDRSTRUC	ENDS

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;

	;---------------------------------------------------------------;
	;			LOAD P6 MICRO CODE			;
	;---------------------------------------------------------------;
	; This procedure loads the P6 update microcode into the proc.	;
	;---------------------------------------------------------------;
	;	Input	: none						;
	;		  cs:update_blocks	 = number of update 	;
	;					   ๆcode blocks		;
	;		  cs:start_update_blocks = start address of the ;
	;					   ๆcode blocks. This	;
	;					   is 32 bit flat addr	;
	;	Output	: CY = 0 (JNC): no error			;
	;		  CY = 1 (JC) : error, microcode not loaded	;
	;	Env.	: Stack available				;
	;		  Processor is in real mode. 			;
	;	Reg use	: Does not destroy any register			;
	;---------------------------------------------------------------;
	;	Note	: This code will be executed by all processors	;
	;		  in the system (one processor at a time)	;
	;---------------------------------------------------------------;


Int15FarAddr	dw	0f859h		; Offset
		dw	0f000h		; Segment


LoadP6MicroCode		PROC	Public

	push	ds
	push	es
	pushad
	mov	ax,0d042h
	mov	bl,0				; BU_UPGRADE presence test
	pushf
	call	cs:dword ptr Int15FarAddr
	jc	ret_lmc				; Not supported

;-----------------------------------------------;
; EBX|ECX	= 'INTELPEP'			;
; SI		= # of update blocks (1 based)	;
;-----------------------------------------------;

	cmp	ebx,'INTE'
	jnz	ret_lmc
	cmp	ecx,'LPEP'
	jnz	ret_lmc
	mov	cx,si
	jcxz	ret_lmc				; No update blocks present
	push	cx
	mov	ax,0d042h
;;	mov	bl,2				; BU_UPGRADE control func test
;;	mov	bh,2				; Query
	mov	bx,0302h			; Old INT-15 spec. BH = 3
	if	NEWBUPSPEC
	mov	bh,02h				; New INT-15 spec. BH = 3 to 2
	endif
	pushf
	call	cs:dword ptr Int15FarAddr
	pop	cx				; CX = number of update blks
	jc	ret_lmc				; Not supported

;-----------------------------------------------;
; BL = 1: upgrade function enabled		;
;      2: disabled				;
;-----------------------------------------------;

	cmp	bl,1				; Enabled ?
	jnz	ret_lmc				; No..

;-----------------------------------------------;
; Read and search ๆcode presence....		;
;-----------------------------------------------;

	mov	eax,00000001h			; Get ResetID and Feature Flag
	push	cx
	cpu_id	  	      			; EAX = ResetID (CPU ID)
	pop	cx
	mov	es,cs:word ptr uncom_segment
	mov	di,0c000h			; ES:DI = pointer to read buff
	xor	si,si				; Read block# (0 based)
try_next_blk:
	push	eax
	push	cx
	mov	ax,0d042h
	mov	bl,3				; Read blocks
	pushf
	call	cs:dword ptr Int15FarAddr
	pop	cx				; Current loop count
	pop	eax				; EAX = CPU ResetID
	jc	ret_lmc				; Error....

;-----------------------------------------------;
; ES:DI = pointer to data buffer (ๆcode)	;
;-----------------------------------------------;

	inc	si				; Next block search
	cmp	es:dword ptr[di].P6MICROCODEHDRSTRUC.dCPUID,eax
	loopnz	try_next_blk			; Try for the next ๆcode blk
	jnz	ret_lmc				; No block found to load

;-----------------------------------------------;
; LOAD ๆCODE NOW....				;
;-----------------------------------------------;

	mov	ecx,00000079h			; MSR#
	xor	eax,eax
	mov	ax,es
	shl	eax,4
	movzx	edi,di
	add	eax,edi
	add	eax,sizeof P6MICROCODEHDRSTRUC	; EDX:EAX = ๆcode flat addr
	xor	edx,edx
	WR_MSR					; Load the microcode
	clc					; No error, OK
	jmp	ret_lmc1
ret_lmc:
	or	cs:word ptr cpu_extd_func_field,0001h
	stc					; Error, microcode not loaded
ret_lmc1:
	popad
	pop	es
	pop	ds
	ret

LoadP6MicroCode		ENDP

	else

LoadP6MicroCode		PROC	Public

	ret

LoadP6MicroCode		ENDP

	endif

;------------------------------------------------------------------------------;
;
;
; Intel CPU ID tables
;
;
;------------------------------------------------------------------------------;

;	Intel Family Database


;	HEADER:
;	------

	Public	Intel_Family_Data_Base
Intel_Family_Data_Base:
	dw	offset default_intel_entry
	db	CPU$Set
	db	Intel_$

;	FAMILY DATABASE:
;	---------------

	if (CPU_386)
db	000h, 003h, NoSMI+Bus32+Clk1X+NoCachePgm, NoFPU+Init386,	i386DX_$,	i386DX
db	040h, 003h, SMI+Bus32+Clk1X+NoCachePgm,	  NoFPU+Init386+iSMI,	i386SL_$,	i386SL
db	000h, 023h, NoSMI+Bus16+Clk1X+NoCachePgm, NoFPU+Init386,	i386SX_$,	i386SX
	endif

	if (CPU_486)
db	000h, 004h, NoSMI+Bus32+Clk1X+CachePgm1,  FPU+Init486,		i486DX_$,	i486DX
db	010h, 004h, NoSMI+Bus32+Clk1X+CachePgm1,  FPU+Init486,		i486DX_$,	i486DX
db	040h, 004h, SMI+Bus32+Clk1X+CachePgm1,	  FPU+Init486+iSMI,	i486SL_$,	i486SL
db	020h, 004h, NoSMI+Bus32+Clk1X+CachePgm1,  NoFPU+Init486,	i486SX_$,	i486SX
db	030h, 004h, NoSMI+Bus32+Clk2X+CachePgm1,  FPU+Init486,		i486DX2_$,	i486DX2
db	00fh, 004h, SMI+Bus32+Clk1X+CachePgm1,    FPU+Init486+ID+iSMI,	i486DXS_$,	i486DXS
db	01fh, 004h, SMI+Bus32+Clk1X+CachePgm1, 	  FPU+Init486+ID+iSMI,	i486DXS_$,	i486DXS
db	02fh, 004h, SMI+Bus32+Clk1X+CachePgm1,	  FPU+Init486+ID+iSMI,	i486SXS_$,	i486SXS
db	03fh, 004h, SMI+Bus32+Clk2X+CachePgm1,	  FPU+Init486+ID+iSMI,	i486DX2S_$,	i486DX2S
db	05fh, 004h, SMI+Bus32+Clk2X+CachePgm1,	  FPU+Init486+ID+iSMI,	i486SX2S_$,	i486SX2S
db	07fh, 004h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+Init486+ID+iSMI,	P24D_$,		P24D
db	08fh, 004h, SMI+Bus32+Clk3X+CachePgm1,	  FPU+Init486+ID+iSMI,	i486DX4_$,	i486DX4
db	09fh, 004h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+Init486+ID+iSMI,	i486DX4_$,	i486DX4
db	08fh, 014h, SMI+Bus32+Clk3X+CachePgm1,	  FPU+Init486+ID+iSMI,	i486DX4ODP_$,	i486DX4OverDrive
db	03fh, 015h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+Init486+ID+iSMI,	P24T_$,		P24T
db	05fh, 015h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+Init486+ID+iSMI,	P24T_$,		P24CT
	endif

	if (CPU_586)
db	01fh, 005h, SMI+Bus64+Clk1X+CachePgm2,	  FPU+InitP5+ID+iSMI,	Pentium_$,	Pentium
db	02fh, 005h, SMI+Bus64+Clk2X+CachePgm2,	  FPU+InitP5+ID+iSMI,	P54C_$,		P54C
db	03fh, 015h, SMI+Bus64+Clk2X+CachePgm2,	  FPU+InitP5+ID+iSMI,	P54C_$,		P54C
db	07fh, 005h, SMI+Bus64+Clk2X+CachePgm2,	  FPU+InitP5+ID+iSMI,	P54C_$,		P54C
								; (CPU0012)>
;db	042h, 015h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitP5+ID+iSMI,	P54CTB_$,	P54CTB	;  : MSI
;db	04fh, 015h, SMI+Bus64+Clk2X+CachePgm2,	  FPU+InitP5+ID+iSMI,	P54C_$,		P54C
db	04fh, 015h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitP5+ID+iSMI,	P54CTB_$,	P54C
								; <(CPU0012)
db	03fh, 005h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitP5+ID+iSMI,	P5T_$,		P5T
db	02fh, 015h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitP5+ID+iSMI,	P5T_$,		P5T
db	04fh, 015h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitP5+ID+iSMI,	P54CT_$,	P54CT
db	02fh, 025h, SMI+Bus64+Clk2X+CachePgm2,	  FPU+InitP5+ID+iSMI,	P54CM_$,	P54CM
db	04fh, 005h, SMI+Bus64+Clk3X+CachePgm2,	  FPU+InitP5+ID+iSMI,	P55C_$,		P55C
db	04fh, 025h, SMI+Bus64+Clk3X+CachePgm2,	  FPU+InitP5+ID+iSMI,	P55C_$,		P55C
db	04fh, 016h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	P55CT_$,	P55CT
;db	08fh, 005h, SMI+Bus64+Clk2X+CachePgm2,	  FPU+InitP5+ID+iSMI,	Talimook_$,	Talimook
	endif

	if (CPU_686)
								; (CPU0021)>
;db	03fh, 016h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	P6T_$,		P6T
;db	05fh, 016h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	P6T_$,		P6T
;db	04fh, 026h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	P6T_$,		P6T
db	03fh, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	PentiumII_$,	Klamath_PentiumII
db	05Fh, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	PentiumII_$,	Deschutes
db	050h, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	Celeron_$,	Celeron
								; <(CPU0021)
db	01fh, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	P6_$,		PentiumPro_P6
								; (CPU0031+)>
db	06Fh, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	Celeron_$, 	Mendocino
								; <(CPU0031+)
								; (CPU0033+)>
db	07Fh, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	PentiumIII_$,	Katmai
db	08Fh, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	PentiumIII_$,	Katmai
								; <(CPU0033+)
db	070h, 006h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	Xeon_$,	Xeon	; (CPU0034+)
	endif

default_intel_entry:
db	0ffh, 0ffh, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitP6+ID+iSMI,	Unknown_$,	0ffh


;------------------------------------------------------------------------------;
;
;
; Intel CPU name strings
;
;
;------------------------------------------------------------------------------;

Create_Intel_CPU_names	macro

	Create_CPU$	Intel_$
			db	'i',0

if (CPU_386)
	Create_CPU$	i386DX_$
			db	'386DX',0

	Create_CPU$	i386SL_$
			db	'386SL',0

	Create_CPU$	i386SX_$
			db	'386SX',0
endif


if (CPU_486)
	Create_CPU$	i486DX_$
			db	'486DX',0

	Create_CPU$	i486SL_$
			db	'486SL',0

	Create_CPU$	i486SX_$
			db	'486SX',0

	Create_CPU$	i486DX2_$
			db	'486DX2',0

	Create_CPU$	i486DXS_$
			db	'486DX-S',0

	Create_CPU$	i486SXS_$
			db	'486SX-S',0

	Create_CPU$	i486DX2S_$
			db	'486DX2-S',0

	Create_CPU$	i486SX2S_$
			db	'486SX2-S',0

	Create_CPU$	P24D_$
			db	'P24D',0

	Create_CPU$	i486DX4_$
			db	'486DX4',0

	Create_CPU$	i486DX4ODP_$
			db	'486DX4-ODP',0

	Create_CPU$	P24T_$
			db	'P24T',0
endif


if (CPU_586)
	Create_CPU$	Pentium_$
			db	'Pentium(P5)',0

	Create_CPU$	P54C_$
			db	'Pentium(P54C)',0

	Create_CPU$	P5T_$
			db	'Pentium(P5T)',0

	Create_CPU$	P54CT_$
			db	'Pentium-MMX',0

	Create_CPU$	P54CM_$
			db	'P54CM',0

	Create_CPU$	P55C_$
			db	'Pentium-MMX',0

	Create_CPU$	P55CT_$
			db	'Pentium-MMX',0

	Create_CPU$	P54CTB_$
	if (MKF_CUSTOMER eq 1223)
			db	'P54CT ODP-MMX',0
	else
			db	'Pentium ODP-MMX',0
	endif

;	Create_CPU$	Talimook_$
;			db	'Talimook',0

endif

if (CPU_686)
	Create_CPU$	P6_$
			db	'PentiumPro',0

	Create_CPU$	P6T_$
			db	'PentiumPro(T)',0

;;	Create_CPU$	Klamath_$
;;			db	'Pentium II',0
;;
;;	Create_CPU$	Deschutes_$
;;;			db	'Deschutes',0
;;			db	'Pentium II',0
	Create_CPU$	PentiumII_$
			db	'Pentium II',0

	Create_CPU$	Celeron_$
			db	'Intel Celeron(tm)',0


	Create_CPU$	PentiumIII_$	; (CPU0033+)
			db	'Pentium III',0

	Create_CPU$	Xeon_$		; (CPU0034+)
			db	'Pentium III Xeon',0

endif

endm;	Create_Intel_CPU_names	macro

