;-----------------------------------------------------------------------------;
;
; IDT RUNTIME routines
;
;-----------------------------------------------------------------------------;

;�����������������������������������������������������������������������������;



		comment �	[README]
		������������������������������������������
		�					 �
		�  TITLE: IDT CPU DETCTION/PROGRAMMING   �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�








		comment �


		��������������������������������������������ͻ
		�	      InitIDTCPU@Shutdown	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different IDT CPUs.	 	     �
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



Public	InitIDTCPU@Shutdown
InitIDTCPU@Shutdown		proc	near

	jmp	InitIntelCPU@Shutdown

InitIDTCPU@Shutdown		endp


		    comment �


		    ��������������������������������������ͻ
		    �	         EnableIDTCache	   	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any IDT CPU.	 	   �
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



Public	EnableIDTCache
EnableIDTCache	proc	near

	jmp	EnableIntelCache

EnableIDTCache	endp


		    comment �


		    ��������������������������������������ͻ
		    �	         DisableIDTCache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any IDT CPU.	 	   �
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



Public	DisableIDTCache
DisableIDTCache	proc	near

	jmp	DisableIntelCache

DisableIDTCache	endp


		    comment �


		    ��������������������������������������ͻ
		    �	           FlushIDTCache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any IDT CPU.	 	   �
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



Public	FlushIDTCache
FlushIDTCache		proc	near

	jmp	FlushCacheStandard

FlushIDTCache		endp


		    comment �


		    ��������������������������������������ͻ
		    �	        DisableIDTBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  IDT CPU.			 	   �
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



Public	DisableIDTBTB
DisableIDTBTB		proc	near

	ret

DisableIDTBTB		endp


		    comment �


		    ��������������������������������������ͻ
		    �	         EnableIDTBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  IDT CPU.			 	   �
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



Public	EnableIDTBTB
EnableIDTBTB		proc	near

	ret

EnableIDTBTB		endp


