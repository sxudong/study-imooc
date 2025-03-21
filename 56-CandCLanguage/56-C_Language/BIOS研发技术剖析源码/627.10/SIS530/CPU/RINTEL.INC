;-----------------------------------------------------------------------------;
;
; Intel RUNTIME routines
;
;-----------------------------------------------------------------------------;



		comment �	[README]
		������������������������������������������
		�					 �
		� TITLE: INTEL CPU DETCTION/PROGRAMMING  �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�



		UnknownCPU	equ	0ffh



		comment �

		��������������������������������������������ͻ
		�	      InitIntelCPU@Shutdown	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different Intel CPUs. 	     �
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


Public	InitIntelCPU@Shutdown
InitIntelCPU@Shutdown		proc	near

	cmp	al,UnknownCPU		; CPU is not detected ?
	jz	end_init_i2		; Yes.. no need for initialize
	test	cl,03h
	jnz	end_init_i2		; Not 386, has cache
	mov	eax,cr0
	or	al,10h			; Set 387 bit ( PATCH FOR 386/387 )
	mov	cr0,eax
end_init_i2:
	ret

InitIntelCPU@Shutdown		endp


		    comment �

		    ��������������������������������������ͻ
		    �	       EnableIntelCache 	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any Intel CPU. 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available 	   �
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


Public	EnableIntelCache
EnableIntelCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	and	eax,9fffffffh		; Enable cache
	mov	cr0,eax 		; Write to CR0
	clc				; CF = 0
	ret

EnableIntelCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	       DisableIntelCache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any Intel CPU. 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available	   �
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


Public	DisableIntelCache
DisableIntelCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	or	eax,60000000h		; Disable cache
	mov	cr0,eax 		; Write to CR0
	wbinvd				; Invalidate WB/WT cache
	clc				; CF = 0
	ret

DisableIntelCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	         FlushIntelCache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any Intel CPU. 	   �
		    ��������������������������������������Ķ
		    �  Environment   : Stack available	   �
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


Public	FlushIntelCache
FlushIntelCache		proc	near

	jmp	FlushCacheStandard

FlushIntelCache		endp


		    comment �

		    ��������������������������������������ͻ
		    �	        DisableIntelBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  Intel CPU.		 	   �
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


Public	DisableIntelBTB
DisableIntelBTB		proc	near

	ret

DisableIntelBTB		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableIntelBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  Intel CPU.		 	   �
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


Public	EnableIntelBTB
EnableIntelBTB		proc	near

	ret

EnableIntelBTB		endp

