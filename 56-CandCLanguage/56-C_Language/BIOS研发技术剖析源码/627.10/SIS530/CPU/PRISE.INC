;
; Rise POST routines
;
;-----------------------------------------------------------------------------;

;-----------------------------------------------------------------------------;
; RISE P-Rating
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
rise_prating	proc
if (CPU_586)
	mov	ax,word ptr cpu_resetid	; AX = reset ID
					; (CPU0041.1)>
;	or	al,0fh			; ignore stepping
;	cmp	ax,050fh		; Rise mP6(tm) ?
	cmp	ah,05h			; mP6 or mP6 II ?
					; <(CPU0041.1)
	stc
	jne	rise_exit		; no.. no prating

	mov	dl,00000110b		; dl.1=clock to cpu string, dl.2=not actual clock display
	mov	si,offset cgroup:rise_pr_tbl
	clc
rise_exit:
endif
	ret
rise_prating	endp
;-------------------------------------------------------;
							; (CPU0037+)>
if (CPU_586)
rise_pr_tbl	label	byte
		dw	(offset cgroup:rise_pr_tbl_end - offset cgroup:rise_pr_tbl) / sizeof(vPRATINGSTRUC)	; $$$CPU0017
		vPRATINGSTRUC	{ 133,	133 }		; 66*2
		vPRATINGSTRUC	{ 150,	150 }		; 75*2
		vPRATINGSTRUC	{ 166,	166 }		; 83*2
		vPRATINGSTRUC	{ 190,	233 }		; 95*2
		vPRATINGSTRUC	{ 200,	266 }		; 100*2
							; (CPU0041+)>
		vPRATINGSTRUC	{ 238,	333 }		; 95*2.5
		vPRATINGSTRUC	{ 250,	366 }		; 100*2.5
		vPRATINGSTRUC	{ 285,	380 }		; 95*3
		vPRATINGSTRUC	{ 300,	400 }		; 100*3
		vPRATINGSTRUC	{ 333,	433 }		; 95*3.5
		vPRATINGSTRUC	{ 350,	466 }		; 100*3.5
							; <(CPU0041+)
rise_pr_tbl_end	label	byte
endif
							; <(CPU0037+)

; (CPU0014+)>
;�����������������������������������������������������������������������������;
if (CPU_586)


		comment �	[README]
		������������������������������������������
		�					 �
		�  TITLE: Rise CPU DETCTION/PROGRAMMING  �
		�					 �
		�	    ****  P O S T  ****		 �
		�					 �
		������������������������������������������
		�





		extrn	GetHandle	:near



		comment �


		�������������������������������������������ͻ
		�	     FindRiseFamilyMember	    �
		�������������������������������������������͹
		� This routine detects individual member    �
		� from the Rise database. This routine can  �
		� detect any kind of Rise CPU at any instant�
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



Public	FindRiseFamilyMember
FindRiseFamilyMember		proc	near

	pushad
	mov	bp,sp
	call	GetResetID		; DX <- CPU ResetID
	mov	ax,dx
	and	al,0f0h			; Stepping info 0, normal CPU
;;	or	cl,cl			; S-series CPU (CPUID) ?
;;	jz	no_step_f		; no..
	or	al,0fh			; Steppping info indicates S-Series
;;no_step_f:
;;					; (CPU0041.1-), (CPU0038+)>
;;	cmp	ah,05h			; family = 05h ?
;;	jne	not_05			; no..
;;	cmp	al,0fh			; Rise mP6(tm) ?
;;	je	find_handle		; yes..
;;	cmp	al,8fh			; Rise mP6(tm) II ?
;;	je	find_handle		; yes..
;;	or	al,0f0h			; otherwise.. Rise CPU (adjusted for table)
;;	jmp	short find_handle
;;not_05:
;;	cmp	ah,06h			; family = 06h ?
;;	jne	find_handle		; no..
;;	or	al,0f0h			; Rise CPU (adjusted for table)
;;find_handle:
;;					; <(CPU0041.1-), (CPU0038+)
	mov	bx,offset Rise_Family_Data_base
	call	GetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Get back reg, return parameters
	ret

FindRiseFamilyMember		endp



		  comment �


		  ���������������������������������������ͻ
		  �	    GetRiseCPUHandle@Reset	  �
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




Public	GetRiseCPUHandle@Reset
GetRiseCPUHandle@Reset 	proc	near

	mov	ax,dx			; AX <- ResetID
	or	al,0fh			; To discard stepping info
	mov	si,sp			; Save current SP
	mov	bx,offset Rise_Family_Data_base
	CallNS	GetHandle		; AX = CPUHandle
	mov	sp,si			; Get back original SP
	mov	dx,cx			; DX = ResetID/CPUID
	ret

GetRiseCPUHandle@Reset 	endp


		comment �


		��������������������������������������������ͻ
		�	        InitRiseCPU@Reset	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different Rise CPUs.	 	     �
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



Public	InitRiseCPU@Reset
InitRiseCPU@Reset		proc	near

	mov	edi,eax
;	mov	bx, offset Rise_Family_Data_Base
;	add	bx,4			; Skip the header
;	mov	cx,sizeof FAMILYSTRUC
;	mul	cx			; AX = offset in the family database
;	add	bx,ax
;	cmp	cs:[bx].FAMILYSTRUC.bCPUNum,UnknownCPU
;	jz	end_init_a2		; Unknown CPU, no need for initialize

					; (CPU0037)>
					; (CPU0036+)>
;;	mov     eax,240290a0h
;;	mov     ecx,4b495749h
;;	mov     edx,4d494b45h
;;	wr_msr
;;	mov     eax,00800000h
;;	mov     ecx,49525348h
;;	mov     edx,4d494b45h
;;	wr_msr
					; <(CPU0036+)
	; Purpose: For configuration setup of mP6 family
	; Comment: This should be used to do configuration setup on mp6
	mov	eax,6363452ah
	mov	ecx,3231206ch
	mov	edx,2a32313ah
	cpu_id
	mov	eax,63634523h
	mov	ecx,32315f6ch
	mov	edx,2333313ah
	cpu_id
					; <(CPU0037)
end_init_a2:
	mov	eax,edi			; EAX restored
	ret

InitRiseCPU@Reset		endp




		comment �


		��������������������������������������������ͻ
		�	    InitRiseCPUBeforeBOOT	     �
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



Public	InitRiseCPUBeforeBOOT
InitRiseCPUBeforeBOOT		proc	near

	ret

InitRiseCPUBeforeBOOT		endp

else;	if (CPU_586)

FindIDTFamilyMember:
	call	DummyFindFamilyMember
	ret
FindIDTFamilyMember:
GetIDTCPUHandle@Reset:
InitIDTCPU@Reset:
InitIDTCPUBeforeBOOT:
	ret

endif	;if (CPU_586)
; <(CPU0014+)

;------------------------------------------------------------------------------;
;
;
; RISE CPU ID tables
;
;
;------------------------------------------------------------------------------;

								; (CPU0014+)>
;	Rise Family Database


;	HEADER:
;	------

	Public	Rise_Family_Data_Base
Rise_Family_Data_Base:
	dw	offset default_rise_entry
	db	CPU$Set
	db	Rise_$

;	FAMILY DATABASE:
;	---------------

if (CPU_586)
								; (CPU0041.1), (CPU0038)>
db	00fh, 005h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+NoInit+ID+iSMI,	RisemP6_$,	RisemP6
db	02fh, 005h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+NoInit+ID+iSMI,	RisemP6_$,	RisemP6
db	08fh, 005h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+NoInit+ID+iSMI,	RiseII_$,	RiseII
db	09fh, 005h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+NoInit+ID+iSMI,	RiseII_$,	RiseII
db	0ffh, 006h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+NoInit+ID+iSMI,	RiseCPU_$,	RiseCPU
								; <(CPU0041.1), (CPU0038)
endif
default_rise_entry:
db	0ffh, 005h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+NoInit+ID+iSMI,	RiseCPU_$,	RiseCPU

								; <(CPU0014+)

;------------------------------------------------------------------------------;
;
;
; RISE CPU name strings
;
;
;------------------------------------------------------------------------------;

Create_RISE_CPU_names	macro
						; (CPU0014+)>
if (CPU_586)
        Create_CPU$	Rise_$
			db	'Rise',0

			       			; (CPU0038)>
        Create_CPU$	RisemP6_$
			db	' mP6(tm)-',0		; (CPU0037)

        Create_CPU$	RiseII_$
			db	' mP6(tm) II',0

        Create_CPU$	RiseCPU_$
			db	' CPU ',0

			       			; <(CPU0038)
endif;	if (CPU_586)
						; <(CPU0014+)

endm;	Create_RISE_CPU_names	macro

