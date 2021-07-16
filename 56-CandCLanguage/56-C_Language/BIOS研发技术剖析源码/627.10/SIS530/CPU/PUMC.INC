;-----------------------------------------------------------------------------;
;
; UMC POST routines
;
;-----------------------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;



		comment ๚	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û  TITLE: UMC CPU DETCTION/PROGRAMMING   Û
		Û					 Û
		Û	    ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚



		extrn	GetHandle	:near




		comment ๚

		ษอออออออออออออออออออออออออออออออออออออออออออป
		บ	     FindUMCFamilyMember	    บ
		ฬอออออออออออออออออออออออออออออออออออออออออออน
		บ This routine detects individual member    บ
		บ from the UMC database. This routine can   บ
		บ detect any kind of UMC CPU at any instant บ
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


Public	FindUMCFamilyMember
FindUMCFamilyMember		proc	near

if (CPU_486)
	pushad
	mov	bp,sp
	call	GetResetID		; DX <- CPU ResetID
	mov	ax,dx
	and	al,0f0h			; Stepping info 0, normal CPU
	or	cl,cl			; S-series CPU (CPUID) ?
	jz	no_step_f		; no..
	or	al,0fh			; Steppping info indicates S-Series
no_step_f:
	mov	bx,offset UMC_Family_Data_base
	call	GetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Get back reg, return parameters
else
	call	DummyFindFamilyMember
endif
	ret

FindUMCFamilyMember		endp



		  comment ๚

		  ษอออออออออออออออออออออออออออออออออออออออป
		  บ	    GetUMCCPUHandle@Reset	  บ
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



Public	GetUMCCPUHandle@Reset
GetUMCCPUHandle@Reset 	proc	near

if (CPU_486)
	mov	ax,dx			; AX <- ResetID
	or	al,0fh			; To discard stepping info
	mov	si,sp			; Save current SP
	mov	bx,offset UMC_Family_Data_base
	CallNS	GetHandle		; AX = CPUHandle
	mov	sp,si			; Get back original SP
	mov	dx,cx			; DX = ResetID/CPUID
endif
	ret

GetUMCCPUHandle@Reset 	endp


		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	        InitUMCCPU@Reset	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different UMC CPUs.	 	     บ
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
		บ  Register destroyed : EAX, BX, DX, EDI+    บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚


Public	InitUMCCPU@Reset
InitUMCCPU@Reset		proc	near

	ret

InitUMCCPU@Reset		endp




		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	    InitUMCCPUBeforeBOOT	     บ
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


Public	InitUMCCPUBeforeBOOT
InitUMCCPUBeforeBOOT		proc	near

	ret

InitUMCCPUBeforeBOOT		endp

;------------------------------------------------------------------------------;
;
;
; UMC CPU ID tables
;
;
;------------------------------------------------------------------------------;
;	UMC Family Database


;	HEADER:
;	------

	Public	UMC_Family_Data_Base
UMC_Family_Data_Base:
	dw	offset default_umc_entry
	db	CPU$Set
	db	UMC_$

;	FAMILY DATABASE:
;	---------------

if (CPU_486)
db	02fh, 004h, SMI+Bus32+Clk1X+CachePgm1,	  NoFPU+Init486+ID+iSMI,UMCU5S_$,	UMCU5S
endif
default_umc_entry:
db	02fh, 004h, SMI+Bus32+Clk1X+CachePgm1,	  NoFPU+Init486+ID+iSMI,UMCU5S_$,	UMCU5S


;------------------------------------------------------------------------------;
;
;
; UMC CPU name strings
;
;
;------------------------------------------------------------------------------;

Create_UMC_CPU_names	macro

	Create_CPU$	UMC_$
       			db	'UMC',0

if (CPU_486)
	Create_CPU$	UMCU5S_$
			db	'U5S',0
endif

endm;	Create_UMC_CPU_names	macro

