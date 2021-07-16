;-----------------------------------------------------------------------------;
;
; SGS RUNTIME routines
;
;-----------------------------------------------------------------------------;

@SGSTHDEFAULTPARAMTBL:

CCRTBLSTRUC	<023h,	000h,	001h,	000h,	018h,	001h,	080h,	003h>

@SGSTHSMIPARAMTBL:

CCRTBLSTRUC	<0A3h,	082h,	081h,	000h,	018h,	001h,	080h,	003h>

;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;


		comment ๚	 [README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û TITLE: SGSTh CPU DETCTION/PROGRAMMING  Û
		Û					 Û
		Û	****  R U N T I M E  ****	 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚





		comment ๚

		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	     InitSGSThCPU@Shutdown	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different SGSTh CPUs.	 	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack not available    บ
		บ		      SS = CS		     บ
		บ  Invoked	    : from reset time code   บ
		บ  Restriction	    : DO NOT DESTROY SI, DI  บ
		บ		      SP, BP AND UPPER 16    บ
		บ		      BITS OF EAX, EBX, EDX  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : AL = CPU#		     บ
		บ		      CX = Functional field  บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Reg destroyed : AX, BX, CX, DX, ESI+, EDI+ บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚


;-----------------------------------------------------------------------------;

Public	InitSGSThCPU@Shutdown
InitSGSThCPU@Shutdown		proc	near

	mov	di,offset @SGSTHDefaultParamTbl
	mov	si,offset @SGSTHSMIParamTbl
	jmp	InitCyrixCPU@Shutdown

InitSGSThCPU@Shutdown		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	        EnableSGSThCache 	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine enables the internal   บ
		    บ  cache for any SGSTh CPU.	 	   บ
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
		    บ	   Registers Destroyed: EAX	   บ
		    ศออออออออออออออออออออออออออออออออออออออผ
		    ๚


Public	EnableSGSThCache
EnableSGSThCache	proc	near

	jmp	EnableCyrixCache

EnableSGSThCache	endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	        DisableSGSThCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disables the internal  บ
		    บ  cache for any SGSTh CPU.	 	   บ
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
		    บ	   Registers Destroyed: EAX	   บ
		    ศออออออออออออออออออออออออออออออออออออออผ
		    ๚


Public	DisableSGSThCache
DisableSGSThCache	proc	near

	jmp	DisableCyrixCache

DisableSGSThCache	endp



		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         FlushSGSThCache	   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine invalidates internal   บ
		    บ  cache for any SGSTh CPU.	 	   บ
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


Public	FlushSGSThCache
FlushSGSThCache		proc	near

	jmp	FlushCacheStandard

FlushSGSThCache		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	        DisableSGSThBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  SGSTh CPU.		 	   บ
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


Public	DisableSGSThBTB
DisableSGSThBTB		proc	near

	ret

DisableSGSThBTB		endp


		    comment ๚

		    ษออออออออออออออออออออออออออออออออออออออป
		    บ	         EnableSGSThBTB		   บ
		    ฬออออออออออออออออออออออออออออออออออออออน
		    บ  This routine disable the BTB of the บ
		    บ  SGSTh CPU.		 	   บ
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


Public	EnableSGSThBTB
EnableSGSThBTB		proc	near

	ret

EnableSGSThBTB		endp


