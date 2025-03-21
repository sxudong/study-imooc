;-----------------------------------------------------------------------------;
;
; SGS Thomson POST routines
;
;-----------------------------------------------------------------------------;

;�����������������������������������������������������������������������������;

		comment �	 [README]
		������������������������������������������
		�					 �
		� TITLE: SGSTh CPU DETCTION/PROGRAMMING  �
		�					 �
		�	   ****  P O S T  ****		 �
		�					 �
		������������������������������������������
		�



		extrn	InitSGSThCPU@Shutdown	:near
		extrn	get_processor_info	:near



		comment �

		�������������������������������������������ͻ
		�	      FindSGSThFamilyMember	    �
		�������������������������������������������͹
		� This routine detects individual member    �
		� from the SGSTh database. This routine	    �
		� can detect any kind of SGSTh CPU at any   �
		� instant of time.			    �
		�������������������������������������������Ķ
		� Environment	 : Stack available	    �
		� Invoked	 : from any time	    �
		�������������������������������������������Ķ
		� Input 	 : CL = 0: no CPUID	    �
		�			1: CPUID present    �
		� Output	 : AX = CPUHandle	    �
		�������������������������������������������Ķ
		�	  Register Destroyed : AX	    �
		�������������������������������������������ͼ

		�



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



		  comment �

		  ���������������������������������������ͻ
		  �	    GetSGSThCPUHandle@Reset	  �
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
		  � Register destroyed : AX, BX, CX, DX   �
		  ���������������������������������������ͼ

		  �



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



		comment �

		��������������������������������������������ͻ
		�	         InitSGSThCPU@Reset	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different SGSTh CPUs.	 	     �
		��������������������������������������������Ķ
		�  Environment	    : Stack not available    �
		�		      SS = CS		     �
		�  Invoked	    : from reset time code   �
		�  Restriction	    : DO NOT DESTROY SI, DI  �
		�		      SP, BP AND UPPER 16    �
		�		      BITS OF EAX, EBX, EDX  �
		��������������������������������������������Ķ
		�  Input	    : AX = CPUHandle	     �
		�  Output	    : none		     �
		��������������������������������������������Ķ
		� Reg destroyed : AX, BX, CX, DX SI, DI	     �
		��������������������������������������������ͼ
		�



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



		comment �

		��������������������������������������������ͻ
		�	     InitSGSThCPUBeforeBOOT	     �
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

