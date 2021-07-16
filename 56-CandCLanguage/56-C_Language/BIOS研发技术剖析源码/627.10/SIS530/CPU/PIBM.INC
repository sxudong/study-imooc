;-----------------------------------------------------------------------------;
;
; IBM POST routines
;
;-----------------------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


		comment ๚	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û  TITLE: IBM CPU DETCTION/PROGRAMMING   Û
		Û					 Û
		Û	    ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚



		extrn	InitIBMCPU@Shutdown	:near
		extrn	get_processor_info	:near




		comment ๚

		ษอออออออออออออออออออออออออออออออออออออออออออป
		บ	     FindIBMFamilyMember	    บ
		ฬอออออออออออออออออออออออออออออออออออออออออออน
		บ This routine detects individual member    บ
		บ from the IBM database. This routine can   บ
		บ detect any kind of IBM CPU at any instant บ
		บ of time.				    บ
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


Public	FindIBMFamilyMember
FindIBMFamilyMember		proc	near

	pushad
	mov	bp,sp
	call	GetResetID		; DX <- CPU reset ID
	test	dh,10000000b		; Old IBM CPU ?
	jz	short new_ibm_group

;---------------------------------------;
;	OLD STYLE IBM CPUS		;
;---------------------------------------;

	mov	ax,dx			; AX = ResetID
	mov	bx,offset IBM_Family_Data_base
	call	GetHandle		; AX <- CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	jmp	short ret_fibmfm

;---------------------------------------;
;    NEW STYLE (CYRIX TYPE) IBM CPUS	;
;---------------------------------------;
new_ibm_group:
	pushf
	mov	di,offset IBM_Family_Data_Base
	call	cGetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popf
ret_fibmfm:
	popad				; Restore regs, return params

	ret

FindIBMFamilyMember		endp



		  comment ๚

		  ษอออออออออออออออออออออออออออออออออออออออป
		  บ	    GetIBMCPUHandle@Reset	  บ
		  ฬอออออออออออออออออออออออออออออออออออออออน
		  บ This routine returns the CPUHandle at บ
		  บ the time of reset.			  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Environment : No stack available	  บ
		  บ		  SS = CS		  บ
		  บ Invoked	: from reset time code	  บ
		  บ Restriction : DO NOT DESTROY SI, DI   บ
		  บ		  SP, BP AND UPPER 16 BITSบ
		  บ		  OF EAX, EBX, EDX	  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Input	: DX = ResetID		  บ
		  บ Output	: AX = CPUHandle	  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Register destroyed : AX,BX,CX,DX,ESP+ บ
		  ศอออออออออออออออออออออออออออออออออออออออผ

		  ๚



Public	GetIBMCPUHandle@Reset
GetIBMCPUHandle@Reset 	proc	near

	test	dh,10000000b		; Old IBM CPU ?
	jnz	old_ibm_group		; Old style ibm cpu

;---------------------------------------;
;   NEW STYLE (CYRIX TYPE) IBM CPU	;
;---------------------------------------;

	mov	cx,sp
	PushNS	ecx			; Save CX
	mov	di,offset IBM_Family_Data_Base
	CallNS	cGetHandle		; AX = CPUHandle
	mov	dx,cx			; DX = ResetID/DIR0, search handle
	PopNS	ecx			; Get back old CX
	mov	sp,cx
	ret

;---------------------------------------;
;	OLD STYLE IBM CPU		;
;---------------------------------------;
old_ibm_group:
	mov	ax,dx			; AX <- ResetID
	PushNS	esp			; Save current SP in ESP+
	mov	bx,offset IBM_Family_Data_base
	CallNS	GetHandle		; AX <- CPUHandle
	mov	dx,cx			; DX <- ResetID
	PopNS	esp			; Get back old SP from ESP+
	ret

GetIBMCPUHandle@Reset 	endp


		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	        InitIBMCPU@Reset	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different IBM CPUs.	 	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack not available    บ
		บ		      SS = CS		     บ
		บ  Invoked	    : from reset time code   บ
		บ  Restriction	    : DO NOT DESTROY         บ
		บ		      SP, BP AND UPPER 16    บ
		บ		      BITS OF EAX, EBX, EDX  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : AX = CPUHandle	     บ
		บ  		    : EAX+ = VendorHandle    บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Register destroyed : AX, BX, DX, EDI+     บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚


Public	InitIBMCPU@Reset
InitIBMCPU@Reset		proc	near

	mov	bx,sizeof FAMILYSTRUC
	mul	bx			; AX = offset to family database
	mov	bx,ax
	add	bx,offset IBM_Family_Data_Base+sizeof FMLYHDRSTRUC
	mov	al,cs:[bx].FAMILYSTRUC.bCPUNum
	mov	cx,cs:[bx].FAMILYSTRUC.wFuncField
	jmp	InitIBMCPU@Shutdown

InitIBMCPU@Reset		endp




		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	    InitIBMCPUBeforeBOOT	     บ
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
		บ  Register destroyed : none		     บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚


extrn	CheckOldIBM:near

Public	InitIBMCPUBeforeBOOT
InitIBMCPUBeforeBOOT		proc	near

	call	get_processor_info
	cmp	bh,UnknownCPU		; Is the CPU detected ?
	jz	ret_iicbb		; Yes..
	push	ax
	mov	al,bh			; AL = old IBM CPU ?
	JmpDI	CheckOldIBM
	pop	ax
	jz	ret_iicbb
	jmp	InitCyrixCPUBeforeBOOT	; Init processor like new style

ret_iicbb:
	ret

InitIBMCPUBeforeBOOT		endp

;------------------------------------------------------------------------------;
;
;
; IBM CPU ID tables
;
;
;------------------------------------------------------------------------------;
;	IBM Family Database


;	HEADER:
;	------

	Public	IBM_Family_Data_Base
IBM_Family_Data_Base:
	dw	offset default_ibm_entry
	db	CPU$Set
	db	IBM_$

;	FAMILY DATABASE:
;	---------------

	if (CPU_386)
db	001h, 0a3h, NoSMI+Bus16+Clk1X+CachePgm1,  NoFPU+InitIBM1,	IBM386SLC_$,	IBM386SLC
db	011h, 0a4h, NoSMI+Bus16+Clk1X+CachePgm1,  NoFPU+InitIBM1,	IBM486SLC_$,	IBM486SLC
db	021h, 0a4h, NoSMI+Bus16+Clk2X+CachePgm1,  NoFPU+InitIBM1,	IBM486SLC2_$,	IBM486SLC2
db	022h, 0a4h, NoSMI+Bus16+Clk2X+CachePgm1,  NoFPU+InitIBM2,	IBM486SLC2_$,	IBM486SLC2
db	038h, 084h, NoSMI+Bus16+Clk2X+CachePgm1,  NoFPU+InitIBM2,	IBM486DLC2_$,	IBM486DLC2
db	039h, 084h, NoSMI+Bus16+Clk3X+CachePgm1,  NoFPU+InitIBM2,	IBM486DLC3_$,	IBM486DLC3
	endif

	if (CPU_486)
db	018h, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitDX+CxSMI,	IBM486DX_$,	IBM486DX
db	01ah, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitDX+CxSMI,	IBM486DX_$,	IBM486DX
db	019h, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitDX+CxSMI,	IBM486DX2_$,	IBM486DX2
db	01bh, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitDX+CxSMI,	IBM486DX2_$,	IBM486DX2
db	028h, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
db	02ah, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
db	029h, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
db	02bh, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
db	02dh, 000h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
db	02fh, 000h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
db	02ch, 000h, SMI+Bus32+Clk4X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
db	02eh, 000h, SMI+Bus32+Clk4X+CachePgm3,	  FPU+InitM1sc+CxSMI,	IBMM1sc_$,	IBMM1sc_M9_5x86
	endif

	if (CPU_586)
								; $$$CPU0022 >>>
;db	030h, 000h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+InitM1+CxSMI,	IBMM1_$,	IBMM1_6x86
;db	032h, 000h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+InitM1+CxSMI,	IBMM1_$,	IBMM1_6x86
;db	031h, 000h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitM1+CxSMI,	IBMM1_$,	IBMM1_6x86
;db	033h, 000h, SMI+Bus64+Clk2X+CachePgm3,	  FPU+InitM1+CxSMI,	IBMM1_$,	IBMM1_6x86
;db	035h, 000h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+CxSMI,	IBMM1_$,	IBMM1_6x86
;db	037h, 000h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+CxSMI,	IBMM1_$,	IBMM1_6x86
; Use DIR on high byte to identify 6x86/6x86L
;	DIR0  DIR1
db      02fh, 00fh, SMI+Bus64+Clk3X+CachePgm3,    FPU+InitM1+ID+CxSMI,  IBMM1_$,	IBMM1_6x86
db      02fh, 01fh, SMI+Bus64+Clk3X+CachePgm3,    FPU+InitM1+ID+CxSMI,  IBMM1_$,	IBMM1_6x86
db	03fh, 00fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	IBMM1_$,	IBMM1_6x86
db	03fh, 01fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	IBMM1_$,	IBMM1_6x86
db	03fh, 02fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	IBMM1L_$,	IBMM1_6x86L
db	05fh, 000h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	IBMM2_$,        IBMM2
db	05fh, MII_DIR1_BASE, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	IBMMII_$,        IBMMII
								; $$$CPU0022 <<<
	endif

default_ibm_entry:
db	0ffh, 0ffh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	Unknown_$,	0ffh

;db	0BCh,	09Ah,	0D3h,	057h,	NEW003_$,	0F0h


;------------------------------------------------------------------------------;
;
;
; IBM CPU name strings
;
;
;------------------------------------------------------------------------------;
Create_IBM_CPU_names	macro

	Create_CPU$	IBM_$
			db	'IBM',0

if (CPU_386)
	Create_CPU$	IBM386SLC_$
			db	'386SLC',0

	Create_CPU$	IBM486SLC_$
			db	'486SLC',0

	Create_CPU$	IBM486SLC2_$
			db	'486SLC2',0

	Create_CPU$	IBM486DLC2_$
			db	'486DLC2',0

	Create_CPU$	IBM486DLC3_$
			db	'486DLC3',0
endif

if (CPU_486)
	Create_CPU$	IBM486DX_$
			db	'BL486DX',0

	Create_CPU$	IBM486DX2_$
			db	'BL486DX2',0

	Create_CPU$	IBMM1sc_$
			db	'5x86(M1sc)',0
endif


if (CPU_586)
						; (CPU0022)>
	if (CPU_CYRIX)

	IBMM1_$		equ	CxM1_$
	IBMM1L_$	equ	CxM1L_$
	IBMM2_$		equ	CxM2_$

	else;	if (CPU_CYRIX)

	Create_CPU$	IBMM1_$
			db	'6x86-PR',0

	Create_CPU$	IBMM1L_$
			db	'6x86L-PR',0

	Create_CPU$	IBMM2_$
			db	'6x86MX-PR',0

	endif;	if (CPU_CYRIX)

	IBMMII_$	equ	IBMM2_$
						; <(CPU0022)
endif

endm;	Create_IBM_CPU_names	macro

