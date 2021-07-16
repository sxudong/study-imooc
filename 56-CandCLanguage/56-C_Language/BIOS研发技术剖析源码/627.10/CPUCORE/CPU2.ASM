	page	,132
	title	CPU RUNTIME MODULE

;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1996, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;

;*****************************************************************;


	extrn	cpu_vendor		:word
	extrn	cpu_number		:word
	extrn	cpu_extd_func_field	:word
	extrn	cpu_func_field		:word
	extrn	cpu_resetid		:dword
	extrn	cpu_apic_id		:byte
	extrn	_NUM_OF_PROC		:byte
	
	extrn	Vendor_Runtime_Data_Base:word

;*****************************************************************************;
cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
	.486p
;*****************************************************************************;

		INCLUDE 	cpumac.mac	; Macros used
		INCLUDE 	cpuequ.equ	; Equates used
		INCLUDE		cpustruc.def	; Database structure definition

;*****************************************************************************;

	vndr_run_struc_size	db	sizeof VNDRRUNSTRUC

;*****************************************************************************;


		 comment ú
		 ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		 Û					    Û
		 Û   I N T E R F A C E	  R O U T I N E S   Û
		 Û					    Û
		 ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		 ú


Public		CPU2ModuleStart
CPU2ModuleStart:


		comment ú
		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º		 InitCPU@Runtime	     º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º   This routine initializes the CPU at      º
		º   reset time or shutdown. This will save   º
		º   the CPU ResetID [EDX] in reserved area.  º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º   Environment   : no Stack available	     º
		º   Invoked	  : at reset/shutdown	     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º   Input	  : EDX = ResetID	     º
		º   Output	  : AX = VendorHandle	     º
		º		    BX = CPUHandle	     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º   Destroyed: AX, BX, ECX, ESP+, DI	     º
		º   					     º
		º   DO NOT DESTROY SI			     º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		ú

public	InitCPU@Runtime
InitCPU@Runtime:

	cmp	cs:byte ptr cpu_vendor, UnknownVendor
	jz	ret_ics
	mov	es,sp
	mov	ds,si
	mov	cx,cs:word ptr cpu_extd_func_field
	shl	ecx,16
	mov	cx,cs:word ptr cpu_func_field
	xor	bx,bx
	mov	al,cs:byte ptr cpu_vendor
	mul	cs:byte ptr vndr_run_struc_size
	mov	bx,ax			; BX = offset in vendor data base
	mov	al,cs:byte ptr cpu_number
	mov	bx,cs:Vendor_Runtime_Data_Base[bx].VNDRRUNSTRUC.wShtInitProc
	CallNS	bx
	mov	si,ds
	mov	sp,es
	xor	cx,cx
	mov	es,cx
	mov	ds,cx
ret_ics:
	ret


		  comment ú
		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	     EnableInternalCache	    º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º   This routine enables internal cache   º
		  º   for any CPU.			    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Environment  : Stack used		    º
		  º   Invoked	   : At any time	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Input	   : none		    º
		  º   Output	   : CF = 0 (JNC) : OK	    º
		  º			= 1 (JC)  : error   º
		  º			  AH = error code   º
		  º			       0: no cache  º
		  º			       1: denied    º
		  º			       2: unknown   º
		  º			          vendor    º
		  º			       3: unknown   º
		  º			          CPU       º
		  º			       4: vendor notº
		  º			          supported º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º  Registers destroyed : none 	    º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		  ú

public	enable_internal_cache
enable_internal_cache:

EnableInternalCache	proc	near
	pushad
	mov	bx,VNDRRUNSTRUC.wEnbCache; offset of enable routine
DispatchRuntimeProc::
	mov	bp,sp
	smsw	ax			; AX = Machine Status Word
	and	ax,1			; System is in virtual mode ?
	mov	ah,1			; Error Code
	jnz	ret_err_ec		; Yes, Cache enable not possible
	mov	ah,0			; Error Code
	mov	al,cs:byte ptr cpu_vendor
	cmp	al,UnknownVendor	; Unknown vendor ?
	jnz	ok_vndr_cache
;---------------------------------------;
;;	mov	al,2
;;	jmp	short ret_err_ec
	mov	ah,2			; Error Code
	mov	al,Intel		; if unknown vendor, force to Intel
	jmp	short do_vndr_cache
;---------------------------------------;
ok_vndr_cache:
	mov	ah,3			; Error Code
	cmp	cs:byte ptr cpu_number, UnknownCPU
	jz	ret_err_ec
do_vndr_cache:
	mul	cs:byte ptr vndr_run_struc_size
	add	bx,ax
	mov	cx,cs:word ptr cpu_extd_func_field
	shl	ecx,16
	mov	cx,cs:word ptr cpu_func_field
	test	cl,03h
	jz	ret_err_ec		; no internal cache
;---------------------------------------;
;;	mov	al,cs:byte ptr cpu_number
;;	cmp	al,UnknownCPU		; CPU is not detected ?
;;	jnz	ok_cpu_cache
;;	mov	al,3
;;	jmp	short ret_err_ec
;---------------------------------------;
ok_cpu_cache:
	mov	edx,cs:dword ptr cpu_resetid
	mov	al,cs:byte ptr cpu_number
	call	cs:Vendor_Runtime_Data_Base[bx]
	popad
	ret
ret_err_ec:
	mov	byte ptr[bp+StackPosEAX+1],ah
	stc
	popad				; Error, set carry flag
	ret
EnableInternalCache	endp


		  comment ú
		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	     DisableInternalCache	    º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º   This routine disables internal cache  º
		  º   for any CPU.			    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Environment  : Stack used		    º
		  º   Invoked	   : At any time	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Input	   : none		    º
		  º   Output	   : CF = 0 (JNC) : OK	    º
		  º			= 1 (JC)  : error   º
		  º			  AH = error code   º
		  º			       0: no cache  º
		  º			       1: denied    º
		  º			       2: unknown   º
		  º			          vendor    º
		  º			       3: unknown   º
		  º			          CPU       º
		  º			       4: vendor notº
		  º			          supported º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º  Registers destroyed : none 	    º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		  ú

public	disable_internal_cache
disable_internal_cache:

DisableInternalCache	proc	near

	call	FlushInternalCache		; Flush cache (take care WB..)
	pushad
	mov	bx,VNDRRUNSTRUC.wDisCache	; offset of disable routine
	jmp	short DispatchRuntimeProc

DisableInternalCache	endp




		  comment ú
		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	      FlushInternalCache	    º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º   This routine invalidates existing     º
		  º   internal cache of the CPU.	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Environment  : Stack used		    º
		  º   Invoked	   : At any time	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Input	   : none		    º
		  º   Output	   : CF = 0 (JNC) : OK	    º
		  º			= 1 (JC)  : error   º
		  º			  AH = error code   º
		  º			       0: no cache  º
		  º			       1: denied    º
		  º			       2: unknown   º
		  º			          vendor    º
		  º			       3: unknown   º
		  º			          CPU       º
		  º			       4: vendor notº
		  º			          supported º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º  Registers destroyed : none 	    º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		  ú

Public				flush_internal_cache
flush_internal_cache:
FlushInternalCache		PROC	NEAR

	pushad
	mov	bx,VNDRRUNSTRUC.wFlushCache	; offset of flush cache routine
	jmp	short DispatchRuntimeProc

FlushInternalCache		ENDP



		  comment ú
		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	      	  DisableBTB		    º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º   This routine disables BTB of the CPU  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Environment  : Stack used		    º
		  º   Invoked	   : At any time	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Input	   : none		    º
		  º   Output	   : CF = 0 (JNC) : OK	    º
		  º			= 1 (JC)  : error   º
		  º			  AH = error code   º
		  º			       0: no cache  º
		  º			       1: denied    º
		  º			       2: unknown   º
		  º			          vendor    º
		  º			       3: unknown   º
		  º			          CPU       º
		  º			       4: vendor notº
		  º			          supported º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º  Registers destroyed : none 	    º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		  ú

Public	DisableBTB
DisableBTB			PROC	NEAR

	pushad
	mov	bx,VNDRRUNSTRUC.wDisBTB		; offset of enable routine
	jmp	DispatchRuntimeProc

DisableBTB			ENDP


		  comment ú
		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	      	  EnableBTB		    º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º   This routine disables BTB of the CPU  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Environment  : Stack used		    º
		  º   Invoked	   : At any time	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Input	   : none		    º
		  º   Output	   : CF = 0 (JNC) : OK	    º
		  º			= 1 (JC)  : error   º
		  º			  AH = error code   º
		  º			       0: no cache  º
		  º			       1: denied    º
		  º			       2: unknown   º
		  º			          vendor    º
		  º			       3: unknown   º
		  º			          CPU       º
		  º			       4: vendor notº
		  º			          supported º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º  Registers destroyed : none		    º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		  ú

Public	EnableBTB
EnableBTB			PROC	NEAR

	pushad
	mov	bx,VNDRRUNSTRUC.wEnbBTB		; offset of enable routine
	jmp	DispatchRuntimeProc

EnableBTB			ENDP


;-----------------------------------------------------------------------;
;			RUNTIME HELP FUNCTIONS				;
;-----------------------------------------------------------------------;
;			GET_PROCESSOR_INFO				;
;		       GET_CURRENT_PROC_INFO				;
;  This routine can be called at any time in runtime and returns the	;
;  current information of the cpu.					;
;  input :								;
;	none								;
;	CL = processor# (incase of GET_CURRENT_PROC_INFO only)		;
;	     0.... for BSP						;
;	     >=1.. for AP						;
;  output:								;
;	CY	0 (JNC).... No error, following is the output		;
;	  eax	bit15-0 (AX)..CPU function field			;
;		bit31-16......CPU extended function field		;
;	  ebx	bit7-0  (BL)..CPU vendor number (FF means invalid)	;
;		bit15-8 (BH)..CPU number (FF means invalid)		;
;		bit31-16......reserved (set to 0)			;
;	  ecx	bit0-7 (CL)...number of CPU found in the system		;
;		bit8-11(CH)...LOCAL APIC_ID of BSP			;
;		bit12-31......Reserved (set to 0)			;
;	  edx	CPU power on reset ID					;
;	  esi	pointer to bootstrap CPU information array in		;
;		segment:offset form					;
;		bit15-0 (SI)..segment					;
;		bit31-16......offset					;
;	  edi	pointer to secondary CPU information array in		;
;		segment:offset form					;
;		bit15-0 (DI)..segment					;
;		bit31-16......offset					;
;									;
;	CY	1 (JC).... Error, following error code will be in AL	;
;	  al	1 ........ Processor# is invalid			;
;		2 ........ BIOS does not support multiprocessor		;
;-----------------------------------------------------------------------;
;  register destroyed..EAX EBX ECX EDX ESI EDI				;
;-----------------------------------------------------------------------;

	public	get_processor_info
	public	get_current_proc_info

get_processor_info	proc	near

	mov	cl,0				; Get BSP information

get_current_proc_info	proc	near

	push	ds
	push	cs
	pop	ds
	mov	edi,ds:dword ptr [0feb0h]	; bbit15-0 = off of AP array
					 	; bit31-16 = seg of AP array
	lds	si,ds:dword ptr [0fea8h]	; DS:SI ptr to CPU info array
	or	cl,cl
	jz	get_info			; For BSP...
	mov	al,1				; Error code #1
	cmp	cl,byte ptr _NUM_OF_PROC	; Number of proc <= asked# ?
	jge	error_gpi			; No... error (code#1)
	inc	al				; Error code#2
	cmp	word ptr[di],0ffffh		; BIOS does not support MP ?
	jz	error_gpi			; Yes... error (code#2)
	mov	si,di				; SI = AP start array pointer
next_ap_chain:
	inc	si
	inc	si				; SI = pointer to CPUINFOSTRUC
	dec	cl
	jz	get_info			; Get information for this AP
	mov	si,word ptr[si-2]		; Next chain addess
	jmp	next_ap_chain
error_gpi:
	stc	
	jmp	ret_gpi
get_info:
	call	SetProcInfoRegs			; Set the regs for output
	clc					; No error
ret_gpi:
	pop	ds
	ret

get_current_proc_info	endp
get_processor_info	endp


;-----------------------------------------------------------------------;
;			SET PROCESSOR INFO REGISTERS			;
;-----------------------------------------------------------------------;
;  This routine can be called at any time in runtime and returns the	;
;  current information of the cpu.					;
;  input :								;
;	DS:SI	pointer to the CPU information structure		;
;	EDI	bit 31-16 : Segment of AP array				;
;		bit 15-0  : Offset of AP array				;
;  output:								;
;	eax	bit15-0 (AX)..CPU function field			;
;		bit31-16......CPU extended function field		;
;	ebx	bit7-0  (BL)..CPU vendor number (FF means invalid)	;
;		bit15-8 (BH)..CPU number (FF means invalid)		;
;		bit31-16......reserved (set to 0)			;
;	ecx	bit0-7 (CL)...number of CPU found in the system		;
;		bit8-11(CH)...LOCAL APIC_ID of BSP			;
;		bit12-31......Reserved (set to 0)			;
;	edx	CPU power on reset ID					;
;	esi	pointer to bootstrap CPU information array in		;
;		segment:offset form					;
;		bit15-0 (SI)..segment					;
;		bit31-16......offset					;
;	edi	pointer to secondary CPU information array in		;
;		segment:offset form					;
;		bit15-0 (DI)..segment					;
;		bit31-16......offset					;
;  register destroyed..EAX EBX ECX EDX ESI EDI				;
;-----------------------------------------------------------------------;

SetProcInfoRegs		PROC	NEAR
	
	rol	edi,16			 ; EDI bit31-16 = offset of appl CPU array
					 ; EDI bit15-0  = segment of appl CPU array
	xor	ecx,ecx
	xor	ebx,ebx
	mov	bl,[si].CPUINFOSTRUC.bVndrNum; CPU vendor number
	mov	bh,[si].CPUINFOSTRUC.bNum; CPU number
	mov	ax,[si].CPUINFOSTRUC.wExtdFuncField; CPU extd function field
	shl	eax,16
	mov	ax,[si].CPUINFOSTRUC.wFuncField; CPU function field
	mov	edx,[si].CPUINFOSTRUC.dResetID; CPU reset ID
	mov	ch,[si].CPUINFOSTRUC.bCPUAPICID	; CPU local APIC_ID
	mov	cl,byte ptr _NUM_OF_PROC	; Number of processors
	shl	esi,16			; ESI bit31-16 = offset of CPU array
	mov	si,ds			; ESI bit15-0  = segment of CPU array
	ret
	
SetProcInfoRegs		ENDP



		  comment ú
		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	     	   GetResetID		    º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º   This routine returns power on cpu     º
		  º   reset id (EDX).			    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Environment  : stack can be used	    º
		  º   Invoked	   : At any time	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º   Input	   : none		    º
		  º   Output	   : DX = reset id	    º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º  Registers destroyed : DX		    º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		  ú

Public	GetResetID
Public	get_reset_id
get_reset_id:
GetResetID		proc	near		  
	push	ds
	push	si
	push	cs
	pop	ds
	lds	si,ds:dword ptr[0fea8h]
	mov	dx,word ptr[si].CPUINFOSTRUC.dResetID
	pop	si
	pop	ds
	ret
GetResetID		endp

;-----------------------------------------------------------------------;
;			COMPATIBLE ROUTINES				;
;-----------------------------------------------------------------------;
;			GET_CPU_ID					;
;  This routine returns the cpu information.				;
;  Input :								;
;	none								;
;	stack	available						;
;  Output:								;
;	DX:AX	pointer to ASCIIZ cpu name string			;
;	BX	function field (described below)			;
;	CL	CPU number (described below)				;
;  Register destroyed : AX BX CX DX					;
;  Usage	      : MUST be invoked as CALL				;
;-----------------------------------------------------------------------;
	public	get_cpu_id
get_cpu_id	proc	near
	push	es
	push	ds
	push	si
	push	cs
	pop	ds
	lds	si,ds:dword ptr[0fea8h]
	les	ax,[si].CPUINFOSTRUC.d$Ptr
	mov	dx,es
	mov	bx,[si].CPUINFOSTRUC.wFuncField
	mov	cl,[si].CPUINFOSTRUC.bNum
	pop	si
	pop	ds
	pop	es
	ret
get_cpu_id	endp
;-----------------------------------------------------------------------;
;			GET_VENDOR_NAME					;
; This routine returns the cpu vendor information.			;
; Input :								;
;	none								;
;	stack	available						;
; Output:								;
;	DX:AX	pointer to ASCIIZ cpu vendor string			;
;	BL	CPU vendor number					;
;		0 = Intel						;
;		1 = Cyrix						;
;		2 = AMD							;
;		3 = IBM							;
;		4 = TI							;
;		5 = UMC							;
;		6-FF = Reserved for future use				;
; Register destroyed : AX BX DX						;
; Usage		     : MUST be invoked as CALL				;
;-----------------------------------------------------------------------;
	public	get_vendor_name
get_vendor_name	proc	near
	push	es
	push	ds
	push	si
	push	cs
	pop	ds
	lds	si,ds:dword ptr[0fea8h]
	les	ax,[si].CPUINFOSTRUC.dVndr$Ptr
	mov	dx,es
	mov	bl,[si].CPUINFOSTRUC.bVndrNum
	pop	si
	pop	ds
	pop	es
	ret
get_vendor_name	endp
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1996, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-246-8600.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
_text	ends
	end
