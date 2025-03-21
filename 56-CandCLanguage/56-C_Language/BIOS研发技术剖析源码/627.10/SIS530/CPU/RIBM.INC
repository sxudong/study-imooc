;-----------------------------------------------------------------------------;
;
; IBM RUNTIME routines
;
;-----------------------------------------------------------------------------;

@IBMDEFAULTPARAMTBL:

CCRTBLSTRUC	<023h,	000h,	001h,	000h,	018h,	001h,	080h,	003h>

@IBMSMIPARAMTBL:

CCRTBLSTRUC	<0A3h,	082h,	081h,	000h,	018h,	001h,	080h,	003h>


;�����������������������������������������������������������������������������;


		comment �	[README]
		������������������������������������������
		�					 �
		�  TITLE: IBM CPU DETCTION/PROGRAMMING   �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�



		extrn	IsFPU?		:near

		extrn	IBM		:abs

		UnknownCPU	equ	0ffh




		comment �

		��������������������������������������������ͻ
		�	      InitIBMCPU@Shutdown	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different IBM CPUs.	 	     �
		��������������������������������������������Ķ
		�  Environment	    : Stack not available    �
		�		      SS = CS		     �
		�  Invoked	    : from reset time code   �
		�  Restriction	    : DO NOT DESTROY ESP+    �
		��������������������������������������������Ķ
		�  Input	    : AL   = CPU#	     �
		�		      CX   = FuncField       �
		�  Output	    : none		     �
		��������������������������������������������Ķ
		�  Register destroyed : EAX, BX, ECX, EDX    �
		��������������������������������������������ͼ
		�



Public	InitIBMCPU@Shutdown
InitIBMCPU@Shutdown		proc	near


	cmp	al,UnknownCPU		; CPU is not detected ?
	jz	ret_iccs		; Yes.. no need for initalize
	cld
	mov	dx,sp
	JmpDI	CheckOldIBM		; Old style IBM CPU ?
	jnz	new_ibm_@shutdown

;---------------------------------------;
;	OLD STYLE IBM CPU		;
;---------------------------------------;
old_ibm_init:
	mov	si,sp
	mov	ecx,00001000h		; MSR = 1000h
	RD_MSR				; EDX|EAX = current content
	mov	ax,140ah		; Enable EIKN, Cache Parity chk, snoop
	or	al,00100000b		; Set bit-5 (EPWI)
	WR_MSR				; Write back to machine specific reg
	inc	cx			; MSR = 1001h
	mov	edx,0fffffff0h		; All memory above 1MB cacheable
	mov	eax,0f000ffffh		; Seg C,D,E,F read only, 0 - 9 rd/wr
	WR_MSR
	mov	ax,cs:[bx].FAMILYSTRUC.wFuncField
	and	ah,00001110b		; Seperate Init code
	cmp	ah,InitIBM2		; Clock programming needed ?
	jnz	skip_pgm_clk
	inc	cx			; MSR = 1002h
	RD_MSR
	or	eax,03000000h		; CLKMD = 011, means internally double
	WR_MSR
skip_pgm_clk:
	mov	ax,IBM
	PushNS	eax			; Restore EAX = VendorHandle as IBM
	mov	sp,si
ret_iccs:
	ret

;---------------------------------------;
;    NEW STYLE (CYRIX CORE) IBM CPU	;
;---------------------------------------;
new_ibm_@shutdown:

	mov	sp,dx
	cmp	al,UnknownCPU		; CPU is not detected ?
	jz	ret_iics		; Yes.. no need for initalize
	mov	di,offset @IBMDefaultParamTbl
	mov	si,offset @IBMSMIParamTbl
	jmp	CyrixShareInitCode
ret_iics:
	ret

InitIBMCPU@Shutdown		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableIBMCache 	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any IBM CPU.	 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available     �
		    �  Invoked	     : At any time	   �
		    ��������������������������������������Ķ
		    �  Input	     : AL   = CPU#	   �
		    �		       CX   = FuncField	   �
		    �		       ECX+ = Extended	   �
		    �			      FuncField	   �
		    �		       EDX  = ResetID	   �
		    �  Output	     : CF = 0 (JNC) as	   �
		    �		       successful	   �
		    ��������������������������������������Ķ
		    �  Reg. Destroyed: EAX, BX, ECX, EDX   �
		    ��������������������������������������ͼ
		    �


Public	EnableIBMCache
EnableIBMCache	proc	near

	JmpDI	CheckOldIBM		; Check for old style IBM CPUs
	jnz	new_ibm_enb_cache	; New style IBM cache

;---------------------------------------;
;	OLD STYLE IBM CPU		;
;---------------------------------------;

	mov	ecx,00001000h		; MSR = 1000h
	RD_MSR				; EDX|EAX = value of MSR 1000h
	or	al,10000000b		; Bit-7 of 1000h is CacheEnable bit
	WR_MSR				; Write to 1000h, enable cache
	clc				; Successful code
	ret

;---------------------------------------;
;    NEW STYLE (CYRIX CORE) IBM CPU	;
;---------------------------------------;

new_ibm_enb_cache:

	jmp	EnableCyrixCache

EnableIBMCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	         DisableIBMCache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any IBM CPU.	 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available     �
		    �  Invoked	     : At any time	   �
		    ��������������������������������������Ķ
		    �  Input	     : AL   = CPU#	   �
		    �		       CX   = FuncField	   �
		    �		       ECX+ = Extended	   �
		    �			      FuncField	   �
		    �		       EDX  = ResetID	   �
		    �  Output	     : CF = 0 (JNC) as	   �
		    �		       successful	   �
		    ��������������������������������������Ķ
		    �  Registers Destroyed: EAX, ECX, EDX  �
		    ��������������������������������������ͼ
		    �


Public	DisableIBMCache
DisableIBMCache	proc	near

	JmpDI	CheckOldIBM		; Check for old style IBM CPUs
	jnz	new_ibm_dis_cache	; New style IBM cache

;---------------------------------------;
;	OLD STYLE IBM CPU		;
;---------------------------------------;

	mov	ecx,00001000h
	RD_MSR				; EDX|EAX = value of MSR 1000h
	and	al,01111111b		; Bit-7 of 1000h is CacheEnable bit
	WR_MSR				; Write to 1000h, disable cache
	wbinvd				; Flush cache, invalidate
	clc				; Successful code
	ret

;---------------------------------------;
;    NEW STYLE (CYRIX CORE) IBM CPU	;
;---------------------------------------;

new_ibm_dis_cache:

	jmp	DisableCyrixCache

DisableIBMCache	endp



		    comment �

		    ��������������������������������������ͻ
		    �	           FlushIBMCache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any IBM CPU.	 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available     �
		    �  Invoked	     : At any time	   �
		    ��������������������������������������Ķ
		    �  Input	     : AL   = CPU#	   �
		    �		       CX   = FuncField	   �
		    �		       ECX+ = Extended	   �
		    �			      FuncField	   �
		    �		       EDX  = ResetID	   �
		    �  Output	     : CF = 0 (JNC) as	   �
		    �		       successful	   �
		    ��������������������������������������Ķ
		    �  Registers Destroyed: none 	   �
		    ��������������������������������������ͼ
		    �


Public	FlushIBMCache
FlushIBMCache		proc	near

	jmp	FlushCacheStandard

FlushIBMCache		endp


		    comment �

		    ��������������������������������������ͻ
		    �	        DisableIBMBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  IBM CPU.			 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available	   �
		    �  Invoked	     : At any time	   �
		    ��������������������������������������Ķ
		    �  Input	     : AL   = CPU#	   �
		    �		       CX   = FuncField	   �
		    �		       ECX+ = Extended	   �
		    �			      FuncField	   �
		    �		       EDX  = ResetID	   �
		    �  Output	     : none 		   �
		    ��������������������������������������Ķ
		    �  Registers Destroyed: none 	   �
		    ��������������������������������������ͼ
		    �


Public	DisableIBMBTB
DisableIBMBTB		proc	near

	ret

DisableIBMBTB		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableIBMBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  IBM CPU.			 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available	   �
		    �  Invoked	     : At any time	   �
		    ��������������������������������������Ķ
		    �  Input	     : AL   = CPU#	   �
		    �		       CX   = FuncField	   �
		    �		       ECX+ = Extended	   �
		    �			      FuncField	   �
		    �		       EDX  = ResetID	   �
		    �  Output	     : none 		   �
		    ��������������������������������������Ķ
		    �  Registers Destroyed: none 	   �
		    ��������������������������������������ͼ
		    �


Public	EnableIBMBTB
EnableIBMBTB		proc	near

	ret

EnableIBMBTB		endp


;-----------------------------------------------------------------------------;

old_group_chk_tbl:

; This table describes the IBM CPUs which are old style, not with
; Cyrix core. And they have different init method.

	db	IBM386SLC, IBM486SLC, IBM486SLC2

old_group_chk_tbl_end:

;-----------------------------------------------------------------------------;


Public	CheckOldIBM
CheckOldIBM:
;---------------------------------------;
; This routine determines an old IBM	;
; CPU, not new Cyrix core		;
;					;
;	Input	: al = CPU#		;
;		  DI = return address	;
;	Output	: ZF = 0 (JNZ): new	;
;		  ZF = 1 (JZ) : old	;
;---------------------------------------;
; reg usage : BX will be destroyed !	;
; Do not destroy any other registers	;
;---------------------------------------;
;  DO NOT USE STACK, MAY BE CALLED WHEN ;
;  USING ROM STACK (SS = CS)		;
;---------------------------------------;

	mov	bx,offset old_group_chk_tbl
next_init_chk:
	cmp	bx,offset old_group_chk_tbl_end
	jz	coi_00			; A new style CPU to initialize
	cmp	cs:byte ptr[bx],al	; Old CPU ?
	jz	coi_01
	inc	bx
	jmp	short next_init_chk
coi_00:
	or	bl,0ffh			; ZF = 0 (JNZ) new IBM CPU
coi_01:
	jmp	di


