;-----------------------------------------------------------------------------;
;
; AMD RUNTIME routines
;
;-----------------------------------------------------------------------------;

;�����������������������������������������������������������������������������;


		comment �	[README]
		������������������������������������������
		�					 �
		�  TITLE: AMD CPU DETCTION/PROGRAMMING   �
		�					 �
		�	****  R U N T I M E  ****	 �
		�					 �
		������������������������������������������
		�







		comment �

		��������������������������������������������ͻ
		�	      InitAMDCPU@Shutdown	     �
		��������������������������������������������͹
		�  This routine programs different registers �
		�  of the different AMD CPUs.	 	     �
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


Public	InitAMDCPU@Shutdown
InitAMDCPU@Shutdown		proc	near

	jmp	InitIntelCPU@Shutdown

InitAMDCPU@Shutdown		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableAMDCache 	   �
		    ��������������������������������������͹
		    �  This routine enables the internal   �
		    �  cache for any AMD CPU.	 	   �
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


Public	EnableAMDCache
EnableAMDCache	proc	near

	jmp	EnableIntelCache

EnableAMDCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	         DisableAMDCache	   �
		    ��������������������������������������͹
		    �  This routine disables the internal  �
		    �  cache for any AMD CPU.	 	   �
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


Public	DisableAMDCache
DisableAMDCache	proc	near

	jmp	DisableIntelCache

DisableAMDCache	endp


		    comment �

		    ��������������������������������������ͻ
		    �	           FlushAMDCache	   �
		    ��������������������������������������͹
		    �  This routine invalidates internal   �
		    �  cache for any AMD CPU.	 	   �
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


Public	FlushAMDCache
FlushAMDCache		proc	near

	jmp	FlushCacheStandard

FlushAMDCache		endp


		    comment �

		    ��������������������������������������ͻ
		    �	        DisableAMDBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  AMD CPU.			 	   �
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


Public	DisableAMDBTB
DisableAMDBTB		proc	near

	ret

DisableAMDBTB		endp


		    comment �

		    ��������������������������������������ͻ
		    �	         EnableAMDBTB		   �
		    ��������������������������������������͹
		    �  This routine disable the BTB of the �
		    �  AMD CPU.			 	   �
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


Public	EnableAMDBTB
EnableAMDBTB		proc	near

	ret

EnableAMDBTB		endp


