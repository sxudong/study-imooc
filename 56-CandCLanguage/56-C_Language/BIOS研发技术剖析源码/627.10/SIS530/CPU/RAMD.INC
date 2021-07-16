;-----------------------------------------------------------------------------;
;
; AMD RUNTIME routines
;
;-----------------------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


		comment ๚	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û  TITLE: AMD CPU DETCTION/PROGRAMMING   Û
		Û					 Û
		Û	****  R U N T I M E  ****	 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚







		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	      InitAMDCPU@Shutdown	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different AMD CPUs.	 	     บ
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


Public	InitAMDCPU@Shutdown
InitAMDCPU@Shutdown		proc	near

	jmp	InitIntelCPU@Shutdown

InitAMDCPU@Shutdown		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         EnableAMDCache 	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine enables the internal   บ
		    บ  cache for any AMD CPU.	 	   บ
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


Public	EnableAMDCache
EnableAMDCache	proc	near

	jmp	EnableIntelCache

EnableAMDCache	endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         DisableAMDCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disables the internal  บ
		    บ  cache for any AMD CPU.	 	   บ
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


Public	DisableAMDCache
DisableAMDCache	proc	near

	jmp	DisableIntelCache

DisableAMDCache	endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	           FlushAMDCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine invalidates internal   บ
		    บ  cache for any AMD CPU.	 	   บ
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


Public	FlushAMDCache
FlushAMDCache		proc	near

	jmp	FlushCacheStandard

FlushAMDCache		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	        DisableAMDBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  AMD CPU.			 	   บ
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


Public	DisableAMDBTB
DisableAMDBTB		proc	near

	ret

DisableAMDBTB		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         EnableAMDBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  AMD CPU.			 	   บ
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


Public	EnableAMDBTB
EnableAMDBTB		proc	near

	ret

EnableAMDBTB		endp


