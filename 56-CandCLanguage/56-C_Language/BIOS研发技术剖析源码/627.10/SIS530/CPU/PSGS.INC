;-----------------------------------------------------------------------------;
;
; SGS Thomson POST routines
;
;-----------------------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

		comment ๚	 [README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û TITLE: SGSTh CPU DETCTION/PROGRAMMING  Û
		Û					 Û
		Û	   ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚



		extrn	InitSGSThCPU@Shutdown	:near
		extrn	get_processor_info	:near



		comment ๚

		ษอออออออออออออออออออออออออออออออออออออออออออป
		บ	      FindSGSThFamilyMember	    บ
		ฬอออออออออออออออออออออออออออออออออออออออออออน
		บ This routine detects individual member    บ
		บ from the SGSTh database. This routine	    บ
		บ can detect any kind of SGSTh CPU at any   บ
		บ instant of time.			    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Environment	 : Stack available	    บ
		บ Invoked	 : from any time	    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Input 	 : CL = 0: no CPUID	    บ
		บ			1: CPUID present    บ
		บ Output	 : AX = CPUHandle	    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ	  Register Destroyed : AX	    บ
		ศอออออออออออออออออออออออออออออออออออออออออออผ

		๚



Public	FindSGSThFamilyMember
FindSGSThFamilyMember	proc	near

if (CPU_486)
	pushf
	pushad
	mov	bp,sp
	call	GetResetID		; DX = ResetID
	mov	di,offset SGSTh_Family_Data_Base
	call	cGetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Restore regs, return params
	popf
else
	call	DummyFindFamilyMember
endif
	ret

FindSGSThFamilyMember	endp



		  comment ๚

		  ษอออออออออออออออออออออออออออออออออออออออป
		  บ	    GetSGSThCPUHandle@Reset	  บ
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
		  บ Register destroyed : AX, BX, CX, DX   บ
		  ศอออออออออออออออออออออออออออออออออออออออผ

		  ๚



Public	GetSGSThCPUHandle@Reset
GetSGSThCPUHandle@Reset 	proc	near

if (CPU_486)
	mov	cx,sp
	PushNS	ecx			; Save CX
	mov	di,offset SGSTh_Family_Data_Base
	CallNS	cGetHandle		; AX = CPUHandle
	mov	dx,cx			; DX = ResetID/DIR0, search handle
	PopNS	ecx			; Get back old CX
	mov	sp,cx
endif
	ret

GetSGSThCPUHandle@Reset 	endp



		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	         InitSGSThCPU@Reset	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different SGSTh CPUs.	 	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack not available    บ
		บ		      SS = CS		     บ
		บ  Invoked	    : from reset time code   บ
		บ  Restriction	    : DO NOT DESTROY SI, DI  บ
		บ		      SP, BP AND UPPER 16    บ
		บ		      BITS OF EAX, EBX, EDX  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : AX = CPUHandle	     บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Reg destroyed : AX, BX, CX, DX SI, DI	     บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚



Public	InitSGSThCPU@Reset
InitSGSThCPU@Reset		proc	near

if (CPU_486)
	mov	bx,sizeof FAMILYSTRUC
	mul	bx			; AX = offset to family database
	mov	bx,ax
	add	bx,offset SGSTh_Family_Data_Base+sizeof FMLYHDRSTRUC
	mov	al,cs:[bx].FAMILYSTRUC.bCPUNum
	mov	cx,cs:[bx].FAMILYSTRUC.wFuncField
	jmp	InitSGSThCPU@Shutdown
else
	ret
endif


InitSGSThCPU@Reset		endp



		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	     InitSGSThCPUBeforeBOOT	     บ
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


Public	InitSGSThCPUBeforeBOOT
InitSGSThCPUBeforeBOOT		proc	near

	jmp	InitCyrixCPUBeforeBOOT

InitSGSThCPUBeforeBOOT		endp

;------------------------------------------------------------------------------;
;
;
; SGS CPU ID tables
;
;
;------------------------------------------------------------------------------;
;	SGSTh Family Database


;	HEADER:
;	------

	Public	SGSTh_Family_Data_Base
SGSTh_Family_Data_Base:
	dw	offset default_sgs_entry
	db	CPU$Set
	db	SGSTh_$

;	FAMILY DATABASE:
;	---------------

if (CPU_486)
db	01ah, 000h, SMI+Bus32+Clk2X+CachePgm3,	  NoFPU+InitDX+CxSMI,	ST486DX_$,	ST486DX
db	01bh, 000h, SMI+Bus32+Clk2X+CachePgm3,	  NoFPU+InitDX+CxSMI,	ST486DX2_$,	ST486DX2
endif
default_sgs_entry:
db	0ffh, 0ffh, SMI+Bus32+Clk2X+CachePgm3,	  NoFPU+InitDX+CxSMI,	Unknown_$,	0ffh

;------------------------------------------------------------------------------;
;
;
; SGS CPU name strings
;
;
;------------------------------------------------------------------------------;

Create_SGS_CPU_names	macro

	Create_CPU$	SGSTh_$
			db	'ST',0

if (CPU_486)
	Create_CPU$	ST486DX_$
			db	'486DX',0


	Create_CPU$	ST486DX2_$
			db	'486DX2',0
endif

endm;	Create_SGS_CPU_names	macro

