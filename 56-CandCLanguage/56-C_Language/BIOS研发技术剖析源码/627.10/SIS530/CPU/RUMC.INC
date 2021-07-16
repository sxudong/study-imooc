;-----------------------------------------------------------------------------;
;
; UMC RUNTIME routines
;
;-----------------------------------------------------------------------------;

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


		comment ๚	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û  TITLE: UMC CPU DETCTION/PROGRAMMING   Û
		Û					 Û
		Û	****  R U N T I M E  ****	 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚




		UnknownCPU	equ	0ffh



		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	      InitUMCCPU@Shutdown	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different UMC CPUs.	 	     บ
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


Public	InitUMCCPU@Shutdown
InitUMCCPU@Shutdown		proc	near

	ret

InitUMCCPU@Shutdown		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         EnableUMCCache 	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine enables the internal   บ
		    บ  cache for any UMC CPU.	 	   บ
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


Public	EnableUMCCache
EnableUMCCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	and	eax,9fffffffh		; Enable cache
	mov	cr0,eax 		; Write to CR0
	clc				; CF = 0
	ret

EnableUMCCache	endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         DisableUMCCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disables the internal  บ
		    บ  cache for any UMC CPU.	 	   บ
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


Public	DisableUMCCache
DisableUMCCache	proc	near

	mov	eax,cr0 		; Get current control reg0
	or	eax,60000000h		; Disable cache
	mov	cr0,eax 		; Write to CR0
	wbinvd				; Invalidate entire cache
	clc				; CF = 0
	ret

DisableUMCCache	endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	           FlushUMCCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine invalidates internal   บ
		    บ  cache for any UMC CPU.	 	   บ
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


Public	FlushUMCCache
FlushUMCCache		proc	near

	jmp	FlushCacheStandard

FlushUMCCache		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	        DisableUMCBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  UMC CPU.			 	   บ
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


Public	DisableUMCBTB
DisableUMCBTB		proc	near

	ret

DisableUMCBTB		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         EnableUMCBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  UMC CPU.			 	   บ
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


Public	EnableUMCBTB
EnableUMCBTB		proc	near

	ret

EnableUMCBTB		endp


