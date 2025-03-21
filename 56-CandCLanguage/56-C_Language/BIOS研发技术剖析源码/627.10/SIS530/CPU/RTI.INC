;-----------------------------------------------------------------------------;
;
; TI RUNTIME routines
;
;-----------------------------------------------------------------------------;

@TIDEFAULTPARAMTBL:

CCRTBLSTRUC	<023h,	000h,	001h,	000h,	018h,	001h,	080h,	003h>

@TISMIPARAMTBL:

CCRTBLSTRUC	<0A3h,	082h,	081h,	000h,	018h,	001h,	080h,	003h>


;�����������������������������������������������������������������������������;


		comment �	 [README]
		������������������������������������������
		�					 �
		�   TITLE: TI CPU DETCTION/PROGRAMMING   �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�





		comment �

		��������������������������������������������ͻ
		�	      InitTICPU@Shutdown	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different TI CPUs.	 	     �
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

Public	InitTICPU@Shutdown
InitTICPU@Shutdown		proc	near

	cmp	al,UnknownCPU		; CPU is not detected ?
	jz	ret_itcs		; Yes.. no need for initalize
	mov	di,offset @TIDefaultParamTbl
	mov	si,offset @TISMIParamTbl
	jmp	CyrixShareInitCode
ret_itcs:
	ret

InitTICPU@Shutdown		endp


		    comment �

		    ��������������������������������������ͻ
		    �	          EnableTICache 	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any TI CPU.	 	   �
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


Public	EnableTICache
EnableTICache	proc	near

	jmp	EnableCyrixCache

EnableTICache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	          DisableTICache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any TI CPU.	 	   �
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


Public	DisableTICache
DisableTICache	proc	near

	jmp	DisableCyrixCache

DisableTICache	endp



		    comment �

		    ��������������������������������������ͻ
		    �	            FlushTICache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any TI CPU.	 	   �
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


Public	FlushTICache
FlushTICache		proc	near

	jmp	FlushCacheStandard

FlushTICache		endp


		    comment �

		    ��������������������������������������ͻ
		    �	        DisableTIBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  TI CPU.			 	   �
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


Public	DisableTIBTB
DisableTIBTB		proc	near

	ret

DisableTIBTB		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableTIBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  TI CPU.			 	   �
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


Public	EnableTIBTB
EnableTIBTB		proc	near

	ret

EnableTIBTB		endp


