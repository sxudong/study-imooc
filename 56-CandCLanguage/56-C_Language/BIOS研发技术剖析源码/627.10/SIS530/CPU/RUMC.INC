;-----------------------------------------------------------------------------;
;
; UMC RUNTIME routines
;
;-----------------------------------------------------------------------------;

;�����������������������������������������������������������������������������;


		comment �	[README]
		������������������������������������������
		�					 �
		�  TITLE: UMC CPU DETCTION/PROGRAMMING   �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�




		UnknownCPU	equ	0ffh



		comment �

		��������������������������������������������ͻ
		�	      InitUMCCPU@Shutdown	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different UMC CPUs.	 	     �
		��������������������������������������������Ķ
		�  Environment	    : Stack not available    �
		�		      SS = CS		     �
		�  Invoked	    : from reset time code   �
		�  Restriction	    : DO NOT DESTROY ESP+    �
		��������������������������������������������Ķ
		�  Input	    : AL   = CPU#	     �
		�		      CX   = FuncField       �
		�		      ECX+ = Ext. FuncField  �
		�  Output	    : none		     �
		��������������������������������������������Ķ
		�  Register destroyed : EAX		     �
		��������������������������������������������ͼ
		�


Public	InitUMCCPU@Shutdown
InitUMCCPU@Shutdown		proc	near

	ret

InitUMCCPU@Shutdown		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableUMCCache 	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any UMC CPU.	 	   �
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
		    �  Registers Destroyed: EAX 	   �
		    ��������������������������������������ͼ
		    �


Public	EnableUMCCache
EnableUMCCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	and	eax,9fffffffh		; Enable cache
	mov	cr0,eax 		; Write to CR0
	clc				; CF = 0
	ret

EnableUMCCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	         DisableUMCCache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any UMC CPU.	 	   �
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
		    �  Registers Destroyed: EAX 	   �
		    ��������������������������������������ͼ
		    �


Public	DisableUMCCache
DisableUMCCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	or	eax,60000000h		; Disable cache
	mov	cr0,eax 		; Write to CR0
	wbinvd				; Invalidate entire cache
	clc				; CF = 0
	ret

DisableUMCCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	           FlushUMCCache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any UMC CPU.	 	   �
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


Public	FlushUMCCache
FlushUMCCache		proc	near

	jmp	FlushCacheStandard

FlushUMCCache		endp


		    comment �

		    ��������������������������������������ͻ
		    �	        DisableUMCBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  UMC CPU.			 	   �
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


Public	DisableUMCBTB
DisableUMCBTB		proc	near

	ret

DisableUMCBTB		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableUMCBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  UMC CPU.			 	   �
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


Public	EnableUMCBTB
EnableUMCBTB		proc	near

	ret

EnableUMCBTB		endp


