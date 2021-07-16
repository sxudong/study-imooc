;-----------------------------------------------------------------------------;
;
; TI POST routines
;
;-----------------------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;

		comment ๚	 [README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û   TITLE: TI CPU DETCTION/PROGRAMMING   Û
		Û					 Û
		Û	   ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚



		extrn	InitTICPU@Shutdown	:near
		extrn	get_processor_info	:near



		comment ๚

		ษอออออออออออออออออออออออออออออออออออออออออออป
		บ	      FindTIFamilyMember	    บ
		ฬอออออออออออออออออออออออออออออออออออออออออออน
		บ This routine detects individual member    บ
		บ from the TI database. This routine	    บ
		บ can detect any kind of TI CPU at any      บ
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



Public	FindTIFamilyMember
FindTIFamilyMember	proc	near

if (CPU_386) or (CPU_486)
	pushf
	pushad
	mov	bp,sp
	call	GetResetID		; DX = ResetID
	mov	di,offset TI_Family_Data_Base
	call	cGetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Restore regs, return params
	popf
else
	call	DummyFindFamilyMember
endif
	ret

FindTIFamilyMember	endp



		  comment ๚

		  ษอออออออออออออออออออออออออออออออออออออออป
		  บ	    GetTICPUHandle@Reset	  บ
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



Public	GetTICPUHandle@Reset
GetTICPUHandle@Reset 	proc	near

if (CPU_386) or (CPU_486)
	mov	cx,sp
	PushNS	ecx			; Save CX
	mov	di,offset TI_Family_Data_Base
	CallNS	cGetHandle		; AX = CPUHandle
	mov	dx,cx			; DX = ResetID/DIR0, search handle
	PopNS	ecx			; Get back old CX
	mov	sp,cx
endif;	if (CPU_486)
	ret

GetTICPUHandle@Reset 	endp



		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	         InitTICPU@Reset	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different TI CPUs.	 	     บ
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



Public	InitTICPU@Reset
InitTICPU@Reset		proc	near

if (CPU_386) or (CPU_486)
	mov	bx,sizeof FAMILYSTRUC
	mul	bx			; AX = offset to family database
	mov	bx,ax
	add	bx,offset TI_Family_Data_Base+sizeof FMLYHDRSTRUC
	mov	al,cs:[bx].FAMILYSTRUC.bCPUNum
	mov	cx,cs:[bx].FAMILYSTRUC.wFuncField
	jmp	InitTICPU@Shutdown
else
	ret
endif


InitTICPU@Reset		endp



		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	     InitTICPUBeforeBOOT	     บ
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


Public	InitTICPUBeforeBOOT
InitTICPUBeforeBOOT		proc	near

	jmp	InitCyrixCPUBeforeBOOT

InitTICPUBeforeBOOT		endp

;------------------------------------------------------------------------------;
;
;
; TI CPU ID tables
;
;
;------------------------------------------------------------------------------;

;	TI Family Database


;	HEADER:
;	------

	Public	TI_Family_Data_Base
TI_Family_Data_Base:
	dw	offset default_ti_entry
	db	CPU$Set
	db	TI_$

;	FAMILY DATABASE:
;	---------------

	if (CPU_386)
db	010h, 004h, NoSMI+Bus16+Clk1X+CachePgm1,  NoFPU+InitXLC,	TI486SLC_$,	TI486SLC
db	020h, 004h, NoSMI+Bus32+Clk1X+CachePgm1,  NoFPU+InitXLC,	TI486DLC_$,	TI486DLC
db	011h, 004h, SMI+Bus16+Clk1X+CachePgm1,	  NoFPU+InitXLC+CxSMI,	TI486SLCe_$,	TI486SLCe
db	021h, 004h, SMI+Bus32+Clk1X+CachePgm1,	  NoFPU+InitXLC+CxSMI,	TI486DLCe_$,	TI486DLCe
	endif

	if (CPU_486)
db	01ah, 000h, SMI+Bus32+Clk2X+CachePgm3,	  NoFPU+InitDX+CxSMI,	TI486DX_$,	TI486DX
db	01bh, 000h, SMI+Bus32+Clk2X+CachePgm3,	  NoFPU+InitDX+CxSMI,	TI486DX2_$,	TI486DX2
db	081h, 000h, SMI+Bus32+Clk4X+CachePgm3,	  NoFPU+InitDX+CxSMI,	TI486DX4_$,	TI486DX4
	endif
default_ti_entry:
db	0ffh, 0ffh, SMI+Bus32+Clk4X+CachePgm3,	  NoFPU+InitDX+CxSMI,	Unknown_$,	0ffh

;------------------------------------------------------------------------------;
;
;
; TI CPU name strings
;
;
;------------------------------------------------------------------------------;

Create_TI_CPU_names	macro

	Create_CPU$	TI_$
			db	'TI',0

if (CPU_386)
	Create_CPU$	TI486SLC_$
			db	'486SLC',0

	Create_CPU$	TI486DLC_$
			db	'486DLC',0

	Create_CPU$	TI486SLCe_$
			db	'486SLC/e',0

	Create_CPU$	TI486DLCe_$
			db	'486DLC/e',0
endif

if (CPU_486)
	Create_CPU$	TI486DX_$
			db	'486DX',0

	Create_CPU$	TI486DX2_$
			db	'486DX2',0

	Create_CPU$	TI486DX4_$
			db	'486DX4',0
endif

endm;	Create_TI_CPU_names	macro

