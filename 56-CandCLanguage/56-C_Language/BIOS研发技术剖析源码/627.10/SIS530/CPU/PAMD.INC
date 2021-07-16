;-----------------------------------------------------------------------------;
;
; AMD POST routines
;
;-----------------------------------------------------------------------------;
; AMD P-Rating
;-----------------------------------------------------------------------------;
; Input:
;	DX	0
; Output:
;	DL	bit 0 = 1 Clock is PRxxx
;		bit 1 = 1 Append Clock to CPU string
;		bit 2 = 1 Don't display clock at checkpoint AA
;	DS:SI	offset of prating table if DL.3=0
;		bit 3 = 1 Get prating value directly from DS:SI
;	DH	ASCII charactor to be append
;		0 = nothing appended
;	CY	no prating
;-----------------------------------------------------------------------------;
if (CPU_586)
;-----------------------------------------------;
amd_m0_pr_tbl:
		dw	4

		vPRATINGSTRUC	{ 66,	75  }
		vPRATINGSTRUC	{ 75,	75  }
;		vPRATINGSTRUC	{ 83,	90  }
		vPRATINGSTRUC	{ 90,	90  }
		vPRATINGSTRUC	{ 200,	100 }	; 100Mhz, <=200
;-----------------------------------------------;
amd_m1_pr_tbl:
		dw	6

		vPRATINGSTRUC	{ 75, 	100 }
;		vPRATINGSTRUC	{ 83, 	100 }
		vPRATINGSTRUC	{ 90, 	120 }
		vPRATINGSTRUC	{ 100,	133 }
		vPRATINGSTRUC	{ 105,	150 }	; 60*1.75 model 2
		vPRATINGSTRUC	{ 117,	166 }	; 66*1.75 model 2
		vPRATINGSTRUC	{ 200,	200 }	; model 3: 133Mhz, <=200
endif;	if (CPU_586)

;-----------------------------------------------;
if (CPU_486)
amd_x5_pr_tbl:
		dw	3

		vPRATINGSTRUC	{ 133,	75 }
		vPRATINGSTRUC	{ 150,	75 }	; '75+'
		vPRATINGSTRUC	{ 160,	90 }
;amd_x5_def_pr:
;		db	'90  '
endif;	if (CPU_486)

;-----------------------------------------------;
amd_prating	proc
if (CPU_586)
	mov	al,byte ptr cpu_resetid
	and	al,0f0h			; skip stepping info
	mov	dl,2			; CPU string with xxx
					; (CPU0020)>>
;	mov	si,offset amd_k6_pr_tbl
	cmp	al,60h			; K6 ?
;					; (CPU0010)>
;;	jz	put_prating		; no PR for K6 cpu
;	jae	put_prating		; no PR for K6 cpu
;					; <(CPU0010)
	jb	not_k6
	push	cs			; DS = CS
	pop	ds
	mov	si,offset cgroup:word ptr cpu_freq; DS:SI = pointed to detected CPU frequency
	or	dl,08h			; bit3=1, get prating value directly from DS:SI
	jmp	short ap_exit
not_k6:
					; <<(CPU0020)
					; (CPU0008)>
if (MKF_CUSTOMER eq 1223)
	mov	dl,2			; CPU string with xxx
else
	mov	dl,1			; Clock = PRxxx
endif
					; <(CPU0008)
	mov	si,offset amd_m0_pr_tbl
	or	al,al			; Model# = 0 ?
	jz	put_prating
	mov	si,offset amd_m1_pr_tbl

put_prating:
	clc
endif;	if (CPU_586)
;---------------------------------------;
if (CPU_486)
	cmp	cgroup:word ptr cpu_freq,150; 150 MHz ?
	jne	not_75_plus
	mov	dh,'+'			; PR75+
not_75_plus:
	mov	dl,2			; CPU string with xxx
	mov	si,offset amd_x5_pr_tbl
	clc
endif;	if (CPU_486)
;---------------------------------------;
ap_exit:
	ret
amd_prating	endp


;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;




		comment ú	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û  TITLE: AMD CPU DETCTION/PROGRAMMING   Û
		Û					 Û
		Û	    ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		ú




		extrn	GetHandle	:near



		comment ú

		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º	     FindAMDFamilyMember	    º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º This routine detects individual member    º
		º from the AMD database. This routine can   º
		º detect any kind of AMD CPU at any instant º
		º of time.				    º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º Environment	 : Stack available	    º
		º Invoked	 : from any time	    º
		º Restriction	 : DO NOT DESTROY ANY REG.  º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º Input 	 : CL = 0: no CPUID	    º
		º			1: CPUID present    º
		º Output	 : AX = CPUHandle	    º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º	  Register Destroyed : AX	    º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

		ú


Public	FindAMDFamilyMember
FindAMDFamilyMember		proc	near

	pushad
	mov	bp,sp
	call	GetResetID		; DX <- CPU ResetID
	mov	ax,dx
	and	al,0f0h			; Stepping info 0, normal CPU
	or	cl,cl			; S-series CPU (CPUID) ?
	jz	no_step_f		; no..
	or	al,0fh			; Steppping info indicates S-Series
no_step_f:
	mov	bx,offset AMD_Family_Data_base
	call	GetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Get back reg, return parameters
	ret

FindAMDFamilyMember		endp



		  comment ú

		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	    GetAMDCPUHandle@Reset	  º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º This routine returns the CPUHandle at º
		  º the time of reset.			  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º Environment : No stack available	  º
		  º		  SS = CS		  º
		  º Invoked	: from reset time code	  º
		  º Restriction : DO NOT DESTROY SI, DI   º
		  º		  SP, BP AND UPPER 16 BITSº
		  º		  OF EAX, EBX, EDX	  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º Input	: DX = ResetID		  º
		  º Output	: AX = CPUHandle	  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º Register destroyed : AX,BX,CX,DX,ESP+ º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

		  ú



Public	GetAMDCPUHandle@Reset
GetAMDCPUHandle@Reset 	proc	near

	mov	ax,dx			; AX <- ResetID
	or	al,0fh			; To discard stepping info
	mov	si,sp			; Save current SP
	mov	bx,offset AMD_Family_Data_base
	CallNS	GetHandle		; AX = CPUHandle
	mov	sp,si			; Get back original SP
	mov	dx,cx			; DX = ResetID/CPUID
	ret

GetAMDCPUHandle@Reset 	endp


		comment ú

		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º	        InitAMDCPU@Reset	     º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º  This routine programs different registers º
		º  of the different AMD CPUs.	 	     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Environment	    : Stack not available    º
		º		      SS = CS		     º
		º  Invoked	    : from reset time code   º
		º  Restriction	    : DO NOT DESTROY         º
		º		      SP, BP AND UPPER 16    º
		º		      BITS OF EAX, EBX, EDX  º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Input	    : AX = CPUHandle	     º
		º  Output	    : none		     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Register destroyed : EAX, BX, DX, EDI+    º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		ú


Public	InitAMDCPU@Reset
InitAMDCPU@Reset		proc	near

	mov	edi,eax
	mov	bx, offset AMD_Family_Data_Base
	add	bx,4			; Skip the header
	mov	cx,sizeof FAMILYSTRUC
	mul	cx			; AX = offset in the family database
	add	bx,ax
	cmp	cs:[bx].FAMILYSTRUC.bCPUNum,UnknownCPU
	jz	end_init_a2		; Unknown CPU, no need for initialize
; CHIPA - removed for space, Not supporting 386 CPUs
if (CPU_386)
	test	cs:[bx].FAMILYSTRUC.wFuncField,0003h
	jnz	end_init_a2		; Not 386, has cache
	mov	eax,cr0
	or	al,10h			; Set 387 bit ( PATCH FOR 386/387 )
	mov	cr0,eax
endif
end_init_a2:
	mov	eax,edi			; EAX restored
	ret

InitAMDCPU@Reset		endp




		comment ú

		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º	    InitAMDCPUBeforeBOOT	     º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º  This procedure initialize the registers   º
		º  to configure the memory region.	     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Environment	    : Stack available        º
		º  Invoked	    : Anytime after InitCPU  º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Input	    : none		     º
		º  Output	    : none		     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Register destroyed : none		     º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		ú


;------------------------------------------------------------------------------;
; NOTES:
; Please refer to the following data sheet.
; Application Note AMD-K6 Processor BIOS Design
; (Publication #21329, Rev:I, Issue Date: July 1998)
;------------------------------------------------------------------------------;
Public	InitAMDCPUBeforeBOOT
InitAMDCPUBeforeBOOT		proc	near

if (CPU_586)

	pushad
	call	GetResetID	; DX <- CPU ResetID
	cmp	dl,10h		; model >= 1 ?
	jb	model_below_1	; no..
	cmp	dl,60h		; k6=056x
	jae	it_is_k6	; yes..
	and	dl,00fh		; keep stepping info
	cmp	dl,4		; >=4 ?
	jb	stepping_below_4; no..

;===============================;
; K5 Write Allocate		;
;===============================;
	mov	ecx,85h		; MSR 85h
	RD_MSR
	or	eax,(1 shl 16)	; enable FRE (Fixed Range Enable)
	WR_MSR

	extrn	get_memory_info:near
	call	get_memory_info	; esi = total memory size in bytes
	shr	esi,16
	mov	ecx,85h		; MSR 85h
	RD_MSR
	or	eax,(1 shl 18)	; enable TME (Top-of-Memory Enable)
	and	eax,not 0ffffh	; clear bit0-15
	or	eax,esi
	xor	edx,edx
	WR_MSR

	mov	ecx,83h		; MSR 83h (HWCR: Hardware Configuration Register)
	RD_MSR
	or	al,10h		; Write Allocate Enable
	WR_MSR

	jmp	short iacbb_exit

it_is_k6:
				; (CPU0032+)>
;===============================;
; K6 Write Allocate		;
;===============================;
; Page40: WCDE bit should be set to 0 for model 6,7,8/[7:0](stepping).
; Model 8/[f:8] and 9 do not support this bit.
	; DX = CPU reset ID
	cmp	dl,88h		; model 6,7,8/[7:0] ?
	jb	k6_678		; yes..

;-------------------------------;
; Model 8/[f:8] and 9 (above)	;
;-------------------------------;
	call	get_memory_info	; esi = total memory size in bytes
	mov	eax,esi
	and	eax,0ffc00000h	; keep bit 31:22 (4MB unit from bit 22) and clear other bits
	call	if_hole_15_16m	; 15-16M memory hole enabled ?
	jc	memory_hole_enabled_0; yes.. don't enable write allocate in 15-16M
	or	eax,00010000h	; set bit 16 write allocate in 15-16M
 				; (CPU0035)>
;;	jmp	short write_k6_whcr
memory_hole_enabled_0:
; Program Write Allocate
	mov	ecx,0c0000082h	; WHCR
	xor	edx,edx		; bit 63:32(EDX) are zero
	wbinvd			; wbinvd first
	WR_MSR

; Program UWCCR register for video buffer (write combinable)
	mov	ecx,0c0000085h	; UWCCR
	xor	edx,edx		; Address 1 = 0
	mov	eax,000a0000h + (0111111111111111b) shl 2 + 10b; A0000 128K WC
	WR_MSR
	jmp	short iacbb_exit
 				; (CPU0035)<
k6_678:
;-------------------------------;
; Model 6,7,8/[7:0]		;
;-------------------------------;
				; <(CPU0032+)
	call	get_memory_info	; esi = total memory size in bytes
	shr	esi,21		; in 4MB unit from bit 0
	mov	eax,esi
	and	ax,0fefeh	; WCDE=0, WAE15M=0
	call	if_hole_15_16m	; 15-16M memory hole enabled ?
	jc	memory_hole_enabled_1; yes.. don't enable write allocate in 15-16M
	or	al,1		; enable write allocate in 15-16M
memory_hole_enabled_1:
write_k6_whcr:
	mov	ecx,0c0000082h	; WHCR
	xor	edx,edx		; bit 63:32(EDX) are zero
	wbinvd			; wbinvd first
	WR_MSR

stepping_below_4:
model_below_1:


iacbb_exit:
	popad
endif;	if (CPU_586)

	ret

InitAMDCPUBeforeBOOT		endp

;------------------------------------------------------------------------------;
;
;
; AMD CPU ID tables
;
;
;------------------------------------------------------------------------------;
;	AMD Family Database


;	HEADER:
;	------

	Public	AMD_Family_Data_Base
AMD_Family_Data_Base:
	dw	offset default_amd_entry
	db	CPU$Set
	db	AMD_$

;	FAMILY DATABASE:
;	---------------

	if (CPU_386)
db	000h, 003h, SMI+Bus32+Clk1X+NoCachePgm,	  NoFPU+Init386+AmSMI,	Am386DXLV_$,	Am386DXLV
db	000h, 023h, SMI+Bus16+Clk1X+NoCachePgm,	  NoFPU+Init386+AmSMI,	Am386SXLV_$,	Am386SXLV
	endif

	if (CPU_486)
db	000h, 004h, SMI+Bus32+Clk1X+CachePgm1,	  FPU+Init486+AmSMI,	Am486DXLV_$,	Am486DXLV
db	010h, 004h, SMI+Bus32+Clk1X+CachePgm1,	  FPU+Init486+AmSMI,	Am486DXLV_$,	Am486DXLV
db	020h, 004h, SMI+Bus32+Clk1X+CachePgm1,	  NoFPU+Init486+AmSMI,	Am486SXLV_$,	Am486SXLV
db	030h, 004h, SMI+Bus32+Clk2X+CachePgm1,	  FPU+Init486+AmSMI,	Am486DXLV2_$,	Am486DXLV2
db	030h, 004h, SMI+Bus32+Clk2X+CachePgm1,	  FPU+Init486+AmSMI,	Am486SXLV2_$,	Am486SXLV2
db	030h, 004h, SMI+Bus32+Clk2X+CachePgm1,	  FPU+Init486+AmSMI,	Am486DXL2_$,	Am486DXL2
db	030h, 004h, SMI+Bus32+Clk2X+CachePgm1,	  FPU+Init486+AmSMI,	Am486SXL2_$,	Am486SXL2
db	01fh, 004h, SMI+Bus32+Clk1X+CachePgm1,	  FPU+Init486+ID+iSMI,	Am486DXP_$,	Am486DXPlus
db	010h, 014h, SMI+Bus32+Clk1X+CachePgm2,	  FPU+Init486+ID+iSMI,	Am486DXP_$,	Am486DXPlus
db	01fh, 014h, SMI+Bus32+Clk1X+CachePgm2,	  FPU+Init486+ID+iSMI,	Am486DXP_$,	Am486DXPlus
db	02fh, 004h, SMI+Bus32+Clk1X+CachePgm1,	  NoFPU+Init486+ID+iSMI,Am486SXP_$,	Am486SXPlus
db	020h, 014h, SMI+Bus32+Clk1X+CachePgm2,	  NoFPU+Init486+ID+iSMI,Am486SXP_$,	Am486SXPlus
db	02fh, 014h, SMI+Bus32+Clk1X+CachePgm2,	  NoFPU+Init486+ID+iSMI,Am486SXP_$,	Am486SXPlus
db	03fh, 004h, SMI+Bus32+Clk2X+CachePgm1,	  FPU+Init486+ID+iSMI,	Am486DX2P_$,	Am486DX2Plus
db	07fh, 004h, SMI+Bus32+Clk2X+CachePgm2,	  FPU+Init486+ID+iSMI,	Am486DX2P_$,	Am486DX2Plus
db	030h, 014h, SMI+Bus32+Clk2X+CachePgm2,	  FPU+Init486+ID+iSMI,	Am486DX2P_$,	Am486DX2Plus
db	03fh, 014h, SMI+Bus32+Clk2X+CachePgm2,	  FPU+Init486+ID+iSMI,	Am486DX2P_$,	Am486DX2Plus
db	08fh, 004h, SMI+Bus32+Clk3X+CachePgm1,	  FPU+Init486+ID+iSMI,	Am486DX4P_$,	Am486DX4_X5_5x86
db	09fh, 004h, SMI+Bus32+Clk3X+CachePgm2,	  FPU+Init486+ID+iSMI,	Am486DX4P_$,	Am486DX4_X5_5x86
db	0efh, 004h, SMI+Bus32+Clk4X+CachePgm1,	  FPU+Init486+ID+iSMI,	Am486DX4P_$,	Am486DX4_X5_5x86
db	0ffh, 004h, SMI+Bus32+Clk4X+CachePgm2,	  FPU+Init486+ID+iSMI,	Am486DX4P_$,	Am486DX4_X5_5x86
	endif

	if (CPU_586)
;--------------------------------------------;
; Contents of EAX for AMD 586 CPUs	     ;
; bit 3-0	Stepping		     ;
; bit 7-4	Model			     ;
; bit 11-8	Instruction Family	     ;
;--------------------------------------------;
db	00fh, 005h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitK5+ID+iSMI,	AmK5_$,		AmK5_5k86_m0
db	01fh, 005h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitK5+ID+iSMI,	AmK5_$,		AmK5_5k86_m1
db	02fh, 005h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitK5+ID+iSMI,	AmK5_$,         AmK5_5k86_m1
db	03fh, 005h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitK5+ID+iSMI,	AmK5_$,         AmK5_5k86_m1
db	06fh, 005h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+NoInit+ID+iSMI,	AmK6_$,		AmK6
								; $$$CPU0010+ >>>
db	07fh, 005h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+NoInit+ID+iSMI,	AmK6_$,		AmK6
db	08fh, 005h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	AmK6_2$,	AmK6	; $$$CPU0023
db	09fh, 005h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	AmK6_3$,	AmK6	; $$$CPU0023
								; $$$CPU0010+ <<<
	endif
default_amd_entry:
db	0ffh,	0ffh,	SMI+Bus32+Clk2X+CachePgm3,	FPU+NoInit+ID+iSMI,	Unknown_$,	0ffh


;------------------------------------------------------------------------------;
;
;
; AMD CPU name strings
;
;
;------------------------------------------------------------------------------;
Create_AMD_CPU_names	macro

	Create_CPU$	AMD_$
			db	'AMD',0

if (CPU_386)
	Create_CPU$	Am386DXLV_$
			db	'386DXLV',0

	Create_CPU$	Am386SXLV_$
			db	'386SXLV',0
endif


if (CPU_486)
	Create_CPU$	Am486DXLV_$
			db	'486DX',0

	Create_CPU$	Am486SXLV_$
			db	'486SX',0

	Create_CPU$	Am486DXLV2_$
			db	'486DX2',0

	Create_CPU$	Am486SXLV2_$
			db	'486SX2',0

	Create_CPU$	Am486DXL2_$
			db	'486DX2',0

	Create_CPU$	Am486SXL2_$
			db	'486SX2',0

	Create_CPU$	Am486DXP_$
			db	'486DXE',0

	Create_CPU$	Am486SXP_$
			db	'486SXE',0

	Create_CPU$	Am486DX2P_$
			db	'486DX2E',0

	Create_CPU$	Am486DX4P_$
			db	'5x86',0
endif

if (CPU_586)

	Create_CPU$	AmK5_$
						; $$$CPU0008 >>>
if (MKF_CUSTOMER eq 1223)
			db	'-K5-PR',0
else
			db	'-K5',0		;   120696
endif
						; $$$CPU0008 <<<

	;   081396
	Create_CPU$	AmK6_$
						; $$$CPU0001 >>>
;			db	'-K6/PR2-',0
			db	'-K6(tm)/',0
						; $$$CPU0001 <<<

						; $$$CPU0023 >>>
						; $$$CPU0013+ >>>
	Create_CPU$	AmK6_2$
			db	'-K6(tm)-2/',0
						; $$$CPU0013+ <<<
	Create_CPU$	AmK6_3$
			db	'-K6(tm)-III/',0; (CPU0036)
						; $$$CPU0023 <<<

endif

endm;	Create_AMD_CPU_names	macro

