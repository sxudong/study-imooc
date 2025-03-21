;-----------------------------------------------------------------------------;
;
; RiSE RUNTIME routines
;
;-----------------------------------------------------------------------------;
;�����������������������������������������������������������������������������;
; (CPU0014+)>



		comment �	[README]
		������������������������������������������
		�					 �
		�  TITLE: Rise CPU DETCTION/PROGRAMMING  �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�








		comment �


		��������������������������������������������ͻ
		�	      InitRiseCPU@Shutdown	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different Rise CPUs.	 	     �
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



Public	InitRiseCPU@Shutdown
InitRiseCPU@Shutdown		proc	near

	jmp	InitIntelCPU@Shutdown

InitRiseCPU@Shutdown		endp


		    comment �


		    ��������������������������������������ͻ
		    �	         EnableRiseCache   	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any Rise CPU.	 	   �
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



Public	EnableRiseCache
EnableRiseCache	proc	near

	jmp	EnableIntelCache

EnableRiseCache	endp


		    comment �


		    ��������������������������������������ͻ
		    �	         DisableRiseCache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any Rise CPU.	 	   �
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



Public	DisableRiseCache
DisableRiseCache	proc	near

	jmp	DisableIntelCache

DisableRiseCache	endp


		    comment �


		    ��������������������������������������ͻ
		    �	           FlushRiseCache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any Rise CPU.	 	   �
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



Public	FlushRiseCache
FlushRiseCache		proc	near

	jmp	FlushCacheStandard

FlushRiseCache		endp


		    comment �


		    ��������������������������������������ͻ
		    �	        DisableRiseBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  Rise CPU.		 	   �
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



Public	DisableRiseBTB
DisableRiseBTB		proc	near

	ret

DisableRiseBTB		endp


		    comment �


		    ��������������������������������������ͻ
		    �	         EnableRiseBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  Rise CPU.		 	   �
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



Public	EnableRiseBTB
EnableRiseBTB		proc	near

	ret

EnableRiseBTB		endp

; <(CPU0014+)

