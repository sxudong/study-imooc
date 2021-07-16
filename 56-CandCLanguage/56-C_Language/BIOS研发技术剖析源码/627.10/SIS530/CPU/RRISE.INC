;-----------------------------------------------------------------------------;
;
; RiSE RUNTIME routines
;
;-----------------------------------------------------------------------------;
;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;
; (CPU0014+)>



		comment ๚	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û  TITLE: Rise CPU DETCTION/PROGRAMMING  Û
		Û					 Û
		Û	****  R U N T I M E  ****	 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚








		comment ๚


		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	      InitRiseCPU@Shutdown	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different Rise CPUs.	 	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack not available    บ
		บ		      SS = CS		     บ
		บ  Invoked	    : from reset time code   บ
		บ  Restriction	    : DO NOT DESTROY ESP+    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : AL   = CPU#	     บ
		บ		      CX   = FuncField       บ
		บ		      ECX+ = Ext. FuncField  บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Register destroyed : EAX		     บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚



Public	InitRiseCPU@Shutdown
InitRiseCPU@Shutdown		proc	near

	jmp	InitIntelCPU@Shutdown

InitRiseCPU@Shutdown		endp


		    comment ๚


		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         EnableRiseCache   	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine enables the internal   บ
		    บ  cache for any Rise CPU.	 	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Environment   : Stack available     บ
		    บ  Invoked	     : At any time	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Input	     : AL   = CPU#	   บ
		    บ		       CX   = FuncField	   บ
		    บ		       ECX+ = Extended	   บ
		    บ			      FuncField	   บ
		    บ		       EDX  = ResetID	   บ
		    บ  Output	     : CF = 0 (JNC) as	   บ
		    บ		       successful	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Registers Destroyed: EAX 	   บ
		    ศออออออออออออออออออออออออออออออออออออออผ
		    ๚



Public	EnableRiseCache
EnableRiseCache	proc	near

	jmp	EnableIntelCache

EnableRiseCache	endp


		    comment ๚


		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         DisableRiseCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disables the internal  บ
		    บ  cache for any Rise CPU.	 	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Environment   : Stack available     บ
		    บ  Invoked	     : At any time	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Input	     : AL   = CPU#	   บ
		    บ		       CX   = FuncField	   บ
		    บ		       ECX+ = Extended	   บ
		    บ			      FuncField	   บ
		    บ		       EDX  = ResetID	   บ
		    บ  Output	     : CF = 0 (JNC) as	   บ
		    บ		       successful	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Registers Destroyed: EAX 	   บ
		    ศออออออออออออออออออออออออออออออออออออออผ
		    ๚



Public	DisableRiseCache
DisableRiseCache	proc	near

	jmp	DisableIntelCache

DisableRiseCache	endp


		    comment ๚


		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	           FlushRiseCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine invalidates internal   บ
		    บ  cache for any Rise CPU.	 	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Environment   : Stack available     บ
		    บ  Invoked	     : At any time	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Input	     : AL   = CPU#	   บ
		    บ		       CX   = FuncField	   บ
		    บ		       ECX+ = Extended	   บ
		    บ			      FuncField	   บ
		    บ		       EDX  = ResetID	   บ
		    บ  Output	     : CF = 0 (JNC) as	   บ
		    บ		       successful	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Registers Destroyed: none 	   บ
		    ศออออออออออออออออออออออออออออออออออออออผ
		    ๚



Public	FlushRiseCache
FlushRiseCache		proc	near

	jmp	FlushCacheStandard

FlushRiseCache		endp


		    comment ๚


		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	        DisableRiseBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  Rise CPU.		 	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Environment   : Stack available	   บ
		    บ  Invoked	     : At any time	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Input	     : AL   = CPU#	   บ
		    บ		       CX   = FuncField	   บ
		    บ		       ECX+ = Extended	   บ
		    บ			      FuncField	   บ
		    บ		       EDX  = ResetID	   บ
		    บ  Output	     : none 		   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Registers Destroyed: none 	   บ
		    ศออออออออออออออออออออออออออออออออออออออผ
		    ๚



Public	DisableRiseBTB
DisableRiseBTB		proc	near

	ret

DisableRiseBTB		endp


		    comment ๚


		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         EnableRiseBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  Rise CPU.		 	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Environment   : Stack available	   บ
		    บ  Invoked	     : At any time	   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Input	     : AL   = CPU#	   บ
		    บ		       CX   = FuncField	   บ
		    บ		       ECX+ = Extended	   บ
		    บ			      FuncField	   บ
		    บ		       EDX  = ResetID	   บ
		    บ  Output	     : none 		   บ
		    วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		    บ  Registers Destroyed: none 	   บ
		    ศออออออออออออออออออออออออออออออออออออออผ
		    ๚



Public	EnableRiseBTB
EnableRiseBTB		proc	near

	ret

EnableRiseBTB		endp

; <(CPU0014+)

