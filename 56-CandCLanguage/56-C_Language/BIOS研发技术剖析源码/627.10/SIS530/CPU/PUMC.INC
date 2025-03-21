;-----------------------------------------------------------------------------;
;
; UMC POST routines
;
;-----------------------------------------------------------------------------;

;�����������������������������������������������������������������������������;



		comment �	[README]
		������������������������������������������
		�					 �
		�  TITLE: UMC CPU DETCTION/PROGRAMMING   �
		�					 �
		�	    ****  P O S T  ****		 �
		�					 �
		������������������������������������������
		�



		extrn	GetHandle	:near




		comment �

		�������������������������������������������ͻ
		�	     FindUMCFamilyMember	    �
		�������������������������������������������͹
		� This routine detects individual member    �
		� from the UMC database. This routine can   �
		� detect any kind of UMC CPU at any instant �
		� of time.				    �
		�������������������������������������������Ķ
		� Environment	 : Stack available	    �
		� Invoked	 : from any time	    �
		� Restriction	 : DO NOT DESTROY ANY REG.  �
		�������������������������������������������Ķ
		� Input 	 : CL = 0: no CPUID	    �
		�			1: CPUID present    �
		� Output	 : AX = CPUHandle	    �
		�������������������������������������������Ķ
		�	  Register Destroyed : AX	    �
		�������������������������������������������ͼ

		�


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



		  comment �

		  ���������������������������������������ͻ
		  �	    GetUMCCPUHandle@Reset	  �
		  ���������������������������������������͹
		  � This routine returns the CPUHandle at �
		  � the time of reset.			  �
		  ���������������������������������������Ķ
		  � Environment : No stack available	  �
		  �		  SS = CS		  �
		  � Invoked	: from reset time code	  �
		  � Restriction : DO NOT DESTROY SI, DI   �
		  �		  SP, BP AND UPPER 16 BITS�
		  �		  OF EAX, EBX, EDX	  �
		  ���������������������������������������Ķ
		  � Input	: DX = ResetID		  �
		  � Output	: AX = CPUHandle	  �
		  ���������������������������������������Ķ
		  � Register destroyed : AX,BX,CX,DX,ESP+ �
		  ���������������������������������������ͼ

		  �



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


		comment �

		��������������������������������������������ͻ
		�	        InitUMCCPU@Reset	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different UMC CPUs.	 	     �
		��������������������������������������������Ķ
		�  Environment	    : Stack not available    �
		�		      SS = CS		     �
		�  Invoked	    : from reset time code   �
		�  Restriction	    : DO NOT DESTROY         �
		�		      SP, BP AND UPPER 16    �
		�		      BITS OF EAX, EBX, EDX  �
		��������������������������������������������Ķ
		�  Input	    : AX = CPUHandle	     �
		�  Output	    : none		     �
		��������������������������������������������Ķ
		�  Register destroyed : EAX, BX, DX, EDI+    �
		��������������������������������������������ͼ
		�


Public	InitUMCCPU@Reset
InitUMCCPU@Reset		proc	near

	ret

InitUMCCPU@Reset		endp




		comment �

		��������������������������������������������ͻ
		�	    InitUMCCPUBeforeBOOT	     �
		��������������������������������������������͹
		�  This procedure initialize the registers   �
		�  to configure the memory region.	     �
		��������������������������������������������Ķ
		�  Environment	    : Stack available        �
		�  Invoked	    : Anytime after InitCPU  �
		��������������������������������������������Ķ
		�  Input	    : none		     �
		�  Output	    : none		     �
		��������������������������������������������Ķ
		�  Register destroyed : none		     �
		��������������������������������������������ͼ
		�


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

