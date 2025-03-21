;-----------------------------------------------------------------------------;
;
; SGS RUNTIME routines
;
;-----------------------------------------------------------------------------;

@SGSTHDEFAULTPARAMTBL:

CCRTBLSTRUC	<023h,	000h,	001h,	000h,	018h,	001h,	080h,	003h>

@SGSTHSMIPARAMTBL:

CCRTBLSTRUC	<0A3h,	082h,	081h,	000h,	018h,	001h,	080h,	003h>

;�����������������������������������������������������������������������������;


		comment �	 [README]
		������������������������������������������
		�					 �
		� TITLE: SGSTh CPU DETCTION/PROGRAMMING  �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�





		comment �

		��������������������������������������������ͻ
		�	     InitSGSThCPU@Shutdown	     �
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
		�  Input	    : AL = CPU#		     �
		�		      CX = Functional field  �
		�  Output	    : none		     �
		��������������������������������������������Ķ
		� Reg destroyed : AX, BX, CX, DX, ESI+, EDI+ �
		��������������������������������������������ͼ
		�


;-----------------------------------------------------------------------------;

Public	InitSGSThCPU@Shutdown
InitSGSThCPU@Shutdown		proc	near

	mov	di,offset @SGSTHDefaultParamTbl
	mov	si,offset @SGSTHSMIParamTbl
	jmp	InitCyrixCPU@Shutdown

InitSGSThCPU@Shutdown		endp


		    comment �

		    ��������������������������������������ͻ
		    �	        EnableSGSThCache 	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any SGSTh CPU.	 	   �
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
		    �	   Registers Destroyed: EAX	   �
		    ��������������������������������������ͼ
		    �


Public	EnableSGSThCache
EnableSGSThCache	proc	near

	jmp	EnableCyrixCache

EnableSGSThCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	        DisableSGSThCache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any SGSTh CPU.	 	   �
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
		    �	   Registers Destroyed: EAX	   �
		    ��������������������������������������ͼ
		    �


Public	DisableSGSThCache
DisableSGSThCache	proc	near

	jmp	DisableCyrixCache

DisableSGSThCache	endp



		    comment �

		    ��������������������������������������ͻ
		    �	         FlushSGSThCache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any SGSTh CPU.	 	   �
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


Public	FlushSGSThCache
FlushSGSThCache		proc	near

	jmp	FlushCacheStandard

FlushSGSThCache		endp


		    comment �

		    ��������������������������������������ͻ
		    �	        DisableSGSThBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  SGSTh CPU.		 	   �
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


Public	DisableSGSThBTB
DisableSGSThBTB		proc	near

	ret

DisableSGSThBTB		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableSGSThBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  SGSTh CPU.		 	   �
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


Public	EnableSGSThBTB
EnableSGSThBTB		proc	near

	ret

EnableSGSThBTB		endp


