
	page	,132
	title	MULTIPLE CPU HANDLER

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



	extrn	GetVendor@Reset			:near
	extrn	InitCPU@Reset			:near
	extrn	GetVendorName			:near
	extrn	copy_string			:near
	extrn	GetCPUID			:near
	extrn	InitCPU@Runtime			:near
	extrn	fill_cpu_name_display_buffer	:near
	extrn	get_smi_seg_size		:near
	extrn	cpu_init_end			:near
	extrn	enable_internal_cache		:near
	extrn	get_memory_info			:near
	extrn	get_shadow_status		:near
	extrn	get_processor_info		:near
	
;-----------------------------------------------------------------------------;

	extrn	cpu_information_ptr		:word
	extrn	smi_info_ptr			:word
	extrn	cpu_resetid			:dword
	extrn	cpu_vendor			:byte
	extrn	detected_cpu_vendor		:byte
	extrn	cpu_vendor_ptr			:word
	extrn	cpu_number			:byte
	extrn	cpu_func_field			:word
	extrn	cpu_extd_func_field		:word
	extrn	cpu_string_ptr			:word
	extrn	cpu_apic_id			:byte
	extrn	cpu_apic_ver			:byte
	extrn	cpu_feature			:dword
	extrn	cpu_name_display_buffer		:byte
	extrn	boot_cpu_info_buffer		:byte
	extrn	smi_info_buffer			:byte
	extrn	ram_segment			:word
	extrn	uncom_segment			:word
	extrn	vendor_post_data_base		:byte

	extrn	EnableFlatMode			:near
	extrn	DisableFlatMode			:near
	extrn	ToAllInit			:near
	extrn	InitLocalAPIC			:near
	extrn	BusDelay			:near
	extrn	WriteICR			:near
	extrn	ReadyStartupCode		:near
	extrn	ClearDest			:near
	extrn	ClearICR			:near
;;;;	extrn	SetShutdownVector		:near
	extrn	CheckPtCPU			:near
	extrn	IncSubChkPt			:near
	extrn	DoInitAPIC			:near

;MP library
	extrn	InitAP				:near
	extrn	WakeUpAP			:near
	extrn	SpinLockBSP			:near
	extrn	SpinLockAP			:near
	extrn	BeginLockSection		:near
	extrn	EndLockSection			:near
	
	extrn	_AP_SEMAPHORE			:byte
	extrn	_NUM_OF_PROC			:byte
	extrn	_AP_NUMBER			:byte
	extrn	_AP_INFO			:byte
	extrn	_AP_SMI_INFO_PTR		:word
	extrn	_NC_REG1_START			:dword
	extrn	_NC_REG1_END			:dword
	extrn	_NC_REG2_START			:dword
	extrn	_NC_REG2_END			:dword
	extrn	_USWC_REG1_START		:dword
	extrn	_USWC_REG1_END			:dword
	extrn	_USWC_REG2_START		:dword
	extrn	_USWC_REG2_END			:dword
	extrn	_TOP_OF_MEM			:dword
	extrn	_L1_CACHE_STATE			:byte
	extrn	_SHADOW_STATE			:byte
	extrn	_USWC_STATE			:byte

;*****************************************************************************;

	INCLUDE	CPUMAC.MAC
	INCLUDE	CPUSTRUC.DEF
	INCLUDE	CPUEQU.EQU


;*****************************************************************************;
cgroup	group	_text
_text   segment word    public  'CODE'
	assume	cs:cgroup
;*****************************************************************************;
	.486p


Public				InitCPU@POST
InitCPU@POST			PROC	NEAR

;;;;	test	bp,8000h			; Soft reset (Ctrl-Alt-Del) ?
;;;;	jnz	skip_init_apic			; Yes.. skip that programming

;-----------------------------------------------;
; PROGRAM BSP APIC AS VIRTUAL WIRE MODE....	;
;-----------------------------------------------;

	mov	ah,0c0h
	call	CheckPtCPU			;==== C0 00 ==================
	call	DoInitAPIC			;==== C0 01 ... 04

;-----------------------------------------------;
; FILL CPU BUFFER....				;
;-----------------------------------------------;
skip_init_apic:
	mov	ah,0c1h				;==== C1 00 =================
	call	CheckPtCPU
	mov	cs:word ptr cpu_information_ptr+2,cs
	mov	cs:word ptr smi_info_ptr+2,cs
	push	cs
	pop	es				; ES = CS
	mov	dx,cs:word ptr cpu_resetid	; CPU reset ID
	push	dx
	call	GetVendor@Reset			; AL = cpu vendor number
	call	IncSubChkPt			;==== C1 01 =================
	mov	cs:byte ptr cpu_vendor,al
	call	GetVendorName			; DX:AX = cpu vendor name ptr
						; BL = functional cpu vendor#
						; BH = detected cpu vendor#
	call	IncSubChkPt			;==== C1 02 =================
	mov	cs:byte ptr cpu_vendor,bl
	mov	cs:byte ptr detected_cpu_vendor,bh
	mov	di,cs:cpu_vendor_ptr
	call	copy_string
	call	IncSubChkPt			;==== C1 03 =================
	mov	bx,cs:word ptr cpu_extd_func_field
	shl	ebx,16
	call	GetCPUID			; DX:AX = ptr to cpu string
						; BX = function field
						; CL = cpu number
	call	IncSubChkPt			;==== C1 04 =================
	mov	cs:cpu_number,cl
	mov	cs:cpu_func_field,bx
	test	bh,00010000b			; Supports CPUID instruction ?
	jz	no_cpu_id			; No.. do not update feature
	push	ax
	push	dx
	mov	eax,1
	cpu_id					; Get ResetID and FeatureFlag
	mov	cs:dword ptr cpu_feature,edx	; Store the Feature
	pop	dx
	pop	ax
no_cpu_id:
	pusha
	mov	di,cs:cpu_string_ptr
	call	copy_string
	call	IncSubChkPt			;==== C1 04 =================
	call	fill_cpu_name_display_buffer	; ASCIIZ string cpu name
	call	IncSubChkPt			;==== C1 05 =================
	popa
	pop	dx

;-----------------------------------------------;
; FILL SMI INFO BUFFER....			;
;-----------------------------------------------;

	push	dx
	mov	di,(offset smi_info_buffer + 2)	; ES:DI = smi info ptr
	movzx	ax,cs:byte ptr cpu_vendor	; Functional cpu vendor#
	stosw					; fill boot strap cpu, vendor#
	push	di
	call	get_smi_seg_size		; fill SMI info
	call	IncSubChkPt			;==== C1 05 =================
	pop	di
	stosw					; Save SMI code seg size
	mov	es:dword ptr[di],ebx		; Save SMI code segment
	pop	dx				; CPU reset id

;-----------------------------------------------;
; INITIALIZE BOOT STRAP PROCESSOR....		;
;-----------------------------------------------;

	mov	ah,0c2h				;==== C2 00 =================
	call	CheckPtCPU
	mov	ax,cs
	mov	ss,ax
	CallNS	initcpu@reset			; init cpu
	mov	bx,0030h
	mov	ss,bx
	mov	sp,100h				; set SS, SP again
	mov	ax,0f000h
	mov	cs:word ptr cpu_information_ptr+2,ax
	mov	cs:word ptr smi_info_ptr+2,ax
	call	IncSubChkPt			;==== C2 01 =================

	call	enable_internal_cache
	call	IncSubChkPt			;==== C2 02 =================
	
;-----------------------------------------------;
; INITIALIZE ALL APPLICATION PROCESSORS....	;
;-----------------------------------------------;

	mov	ah,0c3h				;==== C3 00 =================
	call	CheckPtCPU
;;;;	test	bp,8000h			; Soft reset (Ctrl-Alt-Del) ?
;;;;	jnz	skip_init_ap			; Yes.. skip that programming
	call	WakeUpInitAP			; Wake up and initialize AP
	call	AssignProcID			; Assign processor APIC_IDs
	
;-----------------------------------------------;
; ADJUST CPU NAME DISPLAY BUFFER....		;
;-----------------------------------------------;
skip_init_ap:	
	mov	bl,cs:byte ptr _NUM_OF_PROC
	cmp	bl,1				; Only one processor found ?
	jz	short end_adj_disp_buff		; Yes..
	mov	si,offset cpu_name_display_buffer
find_str_end:
	lods	byte ptr[si]
	or	al,al
	jnz	short find_str_end
	mov	cs:byte ptr[si-1],20h
	mov	cs:byte ptr[si], 'x'
	mov	al,bl
	aam					; AH, AL = BCD
	or	al,30h				; ASCII of unit digit
	or	ah,ah				; Two digit number ?
	jz	put_bcd_al			; No..
	or	ah,30h				; ASCII of tens digit
	xchg	al,ah				; AL = tens digit, AH = unit
put_bcd_al:
	mov	cs:word ptr[si+1],ax
	mov	cs:byte ptr[si+3],0		; Null terminated
end_adj_disp_buff:
	
;---------------------------------------;
end_ic@p:
	jmp	cpu_init_end

InitCPU@POST			ENDP


;*****************************************************************************;

Public				init_cpu_before_boot
Public				InitCPUBeforeBOOT


	_BEFORE_BOOT_PROC	dw	offset RetProc


init_cpu_before_boot		PROC
InitCPUBeforeBOOT		PROC

	push	ds
	push	es
	pushad
	push	cs
	cld
	
;-----------------------------------------------;
; COPY BIOS TO SCRATCH SEGMENT....		;
;-----------------------------------------------;
	
	mov	ah,0c8h
	call	CheckPtCPU			;==== C8 00 =================
	xor	si,si
	xor	di,di
	push	cs
	pop	ds
	mov	es,cs:word ptr ram_segment
	mov	cx,4000h
	rep	movsd				; Copy BIOS to 1000 segment
	push	es
	push	offset comeback
	retf					; Execute from 1000 segment
comeback:
	
;-----------------------------------------------;
; EXECUTE BIOS FROM SCRATCH SEGMENT....		;
;-----------------------------------------------;
	
	call	IncSubChkPt			;==== C8 01 =================
	push	0
	push	40h
	pop	ds				; DS = 40h
	pop	es				; ES = 0
	call	get_memory_info			; Get memory hole and UC info
	call	IncSubChkPt			;==== C8 02 =================
	push	cs
	pop	ds
	jc	ret_icap1			; Routine is not implemented
	
;-----------------------------------------------;
; ROUTINE IS IMPLEMENTED, PROGRAM MTRR....	;
;-----------------------------------------------;

	add	edx,ecx
	dec	edx				; EDX = end addr of reg-1
	add	ebx,eax
	dec	ebx				; EBX = end addr of reg-2
	cmp	ecx,eax
	jc	ok_uc_order
	xchg	eax,ecx
	xchg	ebx,edx
ok_uc_order:
	mov	ds:dword ptr _NC_REG1_START,ecx
	mov	ds:dword ptr _NC_REG1_END,edx
	mov	ds:dword ptr _NC_REG2_START,eax
	mov	ds:dword ptr _NC_REG2_END,ebx
	mov	ds:dword ptr _TOP_OF_MEM,esi
	mov	ax,di
	and	al,00001000b			; Bit-3 is the L1 cache info
	shr	al,3
	mov	ds:byte ptr _L1_CACHE_STATE,al
ret_icap1:
	call	get_shadow_status		; AX = shadow memory info
	call	IncSubChkPt			;==== C8 03 =================
	jc	ret_icap2
	add	edx,ecx
	dec	edx				; EDX = end addr of reg-1
	add	ebx,eax
	dec	ebx				; EAX = end addr of reg-2
	cmp	ecx,eax
	jc	ok_us_order
	xchg	eax,ecx
	xchg	ebx,edx
ok_us_order:
	mov	ds:word ptr _SHADOW_STATE,si
	mov	ds:dword ptr _USWC_REG1_START,ecx
	mov	ds:dword ptr _USWC_REG1_END,edx
	mov	ds:dword ptr _USWC_REG2_START,eax
	mov	ds:dword ptr _USWC_REG2_END,ebx
	test	di,0002h			; VGA memory USWC ?
	jz	ret_icap2
	or	ds:byte ptr _USWC_STATE,01h

ret_icap2:
	call	get_processor_info		; BL = vendor#
	call	IncSubChkPt			;==== C8 04 =================
	cmp	bl,0ffh				; Vendor unknown ?
	jz	ret_icap			; Yes.. do nothing
	mov	al,sizeof VNDRPSTSTRUC
	mul	bl				; AX = Vendor post struc offset
	mov	bx,offset vendor_post_data_base
	add	bx,ax				; BX = structure ptr
	mov	ax,cs:word ptr[bx].VNDRPSTSTRUC.wBootInitProc
	mov	cs:word ptr _BEFORE_BOOT_PROC,ax
ret_icap:
	call	cs:word ptr _BEFORE_BOOT_PROC
;-----------------------------------------------;
; INIT ALL OTHER PROCESSOR EXCEPT BSP....	;
;-----------------------------------------------;

	mov	cs:word ptr _AP_BUSY_FLAG,0
	mov	cs:byte ptr _AP_NUMBER,01h	; Initialize AP number

;-----------------------------------------------;
; STARTUP TO ALL EXCEPT BSP TO PROGRAM MTRR....	;
;-----------------------------------------------;

	mov	ah,0C9h
	call	CheckPtCPU			;==== C9 00 =================
	push	cs
	push	offset InitAPBeforeBoot		; Far* to IPI handler
	push	cs:word ptr uncom_segment	; 64K scratch segment
	call	WakeUpAP			; Wake Up AP
	call	IncSubChkPt			;==== C9 01 =================
	
	mov	al,cs:byte ptr _NUM_OF_PROC	; Total number of processor
wait_till_apbb:
	cmp	cs:byte ptr _AP_NUMBER,al	; AP initilization done ?
	jnz	wait_till_apbb			; No..
	call	IncSubChkPt			;==== C9 02 =================
	call	InitAP				; Init all application proc.
	call	IncSubChkPt			;==== C9 03 =================
	
;-----------------------------------------------;

	push	offset goback
	retf
goback:
	mov	ah,00h
	call	CheckPtCPU			;==== 00 00 =================
	popad
	pop	es
	pop	ds
	ret

InitCPUBeforeBOOT		ENDP
init_cpu_before_boot		ENDP

;-----------------------------------------------------------------------------;

RetProc:
	ret
	


;*****************************************************************************;
;*									     *;
;*			MultiProcessor Support Code			     *;
;*									     *;
;*****************************************************************************;


;-----------------------------------------------------------------------------;
;			    START MULTI-PROCESSING			      ;
;-----------------------------------------------------------------------------;
;	This procedure detects and starts all other processor. This procedure ;
;	also wakes up the application processors and initialize them.	      ;
;									      ;
;	Input	: none							      ;
;	Output	: none							      ;
;	Reg use	: does not destroy any register				      ;
;-----------------------------------------------------------------------------;


WakeUpInitAP			PROC

	pushf
	push	ds
	push	es
	pushad
	cli
	cld
	
	mov	es,cs:word ptr uncom_segment
	mov	ax,cs
	shl	eax,16
	mov	ax,offset ActivityMonitor
	call	ReadyStartupCode		; Make STARTUP_IPI code ready
	
	mov	cs:byte ptr _NUM_OF_PROC,1	; Initialize number of proc
	mov	cs:word ptr _AP_SMI_INFO_PTR, ((offset smi_info_buffer + 2) + sizeof SMIINFOSTRUC)

;-----------------------------------------------;
; SET DS AS FLAT MODE....			;
;-----------------------------------------------;

	push	cs
	call	EnableFlatMode			; DS selector limit = 4GB

;-----------------------------------------------;
; READ BSP ID INFORMATION AND SAVE IT....	;
;-----------------------------------------------;

	mov	ebx,0fee00020h			; Local APIC_ID
	mov	ebp,dword ptr[ebx]		; Read local APIC_ID
	and	ebp,not ClearDestMask		; Keep only ID bits (4 bit)
	mov	edx,ebp
	rol	edx,8				; DL = APIC_ID
	mov	cs:byte ptr cpu_apic_id,dl	; Write BSP APIC_ID
	mov	si,(offset smi_info_buffer + 2)	; BSP SMI info buffer
	mov	cs:[si].SMIINFOSTRUC.bAPICID,dl	; Fill local APIC_ID
	mov	bl,30h				; Local APIC version#
	mov	edx,dword ptr[ebx]		; Read version# register
	mov	cs:byte ptr cpu_apic_ver,dl	; Store the APIC version#

;-----------------------------------------------;
; INDIVIDUALLY STARTUP....			;
;-----------------------------------------------;	

	mov	cs:byte ptr _AP_NUMBER,0	; Initialize AP#
	xor	edx,edx
	mov	cx,ProcNum			; CX = maximum number of proc.
do_all_startup:
	call	IncSubChkPt			;==== C2 XX =================
	cmp	ebp,edx				; BSP ?
	jz	short skip_startup_ap		; Skip startup for BSP

;;;;	call	SetShutdownVector		; 02/24/97..Not required
	mov	bx,0310h			; ICR-HI
	mov	edi,dword ptr[ebx]		; Current content
	mov	bl,00h				; ICR-LO
	mov	esi,dword ptr[ebx]		; Get current setting

;-----------------------------------------------;
; STARTUP....					;
;-----------------------------------------------;

lock	and	cs:byte ptr _AP_SEMAPHORE,0fch	; Initialize Semaphore
	
	call	ClearDest			; Keep current reserved bits
	or	edi,edx				; Put destination ID bits
	call	ClearICR			; Keep reserved bits in ICR-LO
	or	esi,ORMaskSTARTUP		; STARTUP_IPI
	mov	ax,cs:word ptr uncom_segment
	shr	ax,8				; AX = vector for STARTUP_IPI
	or	si,ax
	call	WriteICR			; First time wake up from sleep

	call	BusDelay			; Wait for IPI handler
	test	cs:byte ptr _AP_SEMAPHORE,01h	; IPI busy flag set ?
	jz	short skip_startup_ap		; Processor not found
wait_ipi_ipi:
	test	cs:byte ptr _AP_SEMAPHORE,02h	; End of IPI handler task ?
	jz	short wait_ipi_ipi		; Wait till IPI handler ends

skip_startup_ap:
	add	edx,01000000h			; Next destination
	loop	do_all_startup			; Complete all processor
	
	call	ToAllINIT			; INIT_IPI to all but BSP

;-----------------------------------------------;
; UPDATE SMI INFO BUFFER....			;
;-----------------------------------------------;
	
	mov	di,((offset smi_info_buffer + 2) + sizeof SMIINFOSTRUC)
	mov	cl,cs:byte ptr _NUM_OF_PROC
	dec	cl
	or	cl,cl				; No AP found ?
	jz	no_usi				; Yes..  do not update SMI info
	mov	si,offset _AP_INFO		; Appl Proc information array
do_usi:
	cmp	cs:word ptr[si],0ffffh		; End of info ?
	jz	no_usi				; Yes..
	inc	si
	inc	si				; Skip chain pointer
	mov	edx,cs:[si].CPUINFOSTRUC.dResetID
	mov	al,cs:[di].SMIINFOSTRUC.bVendor	; Functional cpu vendor#
	mov	ah,cs:[di].SMIINFOSTRUC.bCPULevel
	push	cx
	push	si
	push	di
	mov	bx,cs:[si].CPUINFOSTRUC.wExtdFuncField
	shl	ebx,16
	mov	bx,cs:[si].CPUINFOSTRUC.wFuncField
	mov	cl,cs:[si].CPUINFOSTRUC.bNum
	call	get_smi_seg_size		; Fill SMI info
	pop	di
	pop	si
	pop	cx
	mov	cs:[di].SMIINFOSTRUC.wSMICodeSize,ax
	mov	cs:[di].SMIINFOSTRUC.dSMICodeSeg,ebx
	mov	si,cs:word ptr[si-2]		; Next chain ptr
	add	di,sizeof SMIINFOSTRUC		; Next SMI info ptr
	dec	cl
	jnz	do_usi				; Update SMI info for all AP
	
;-----------------------------------------------;
; RESTORE SEGMENT SELECTORS AND DISABLE GA20....;
;-----------------------------------------------;
no_usi:
	push	cs
	call	DisableFlatMode			; DS selector limit 64KB

;-----------------------------------------------;
; RETURNING....					;
;-----------------------------------------------;

	popad
	pop	es
	pop	ds
	popf
	ret

WakeUpInitAP			ENDP


;*****************************************************************************;
;*									     *;
;*			     S U B R O U T I N E S			     *;
;*									     *;
;*****************************************************************************;


;-----------------------------------------------------------------------------;
;				ACTIVITY MONITOR			      ;
;-----------------------------------------------------------------------------;
;	This procedure monitors the activity of the processors.		      ;
;	This procedure is a shared code for all CPUs. Memory access locking   ;
;	is maintained accordingly.					      ;
;	Input	: none							      ;
;	Output	: none							      ;
;	Reg use	: MUST NOT DESTROY ANY REGISTER				      ;
;									      ;
;	* Semaphore CS:_CPU_Flag is used				      ;
;	  This procedure is invoked through STARTUP_IPI			      ;
;-----------------------------------------------------------------------------;
;	Currently this code will not terminate!!			      ;
;-----------------------------------------------------------------------------;


ActivityMonitor			PROC

;-----------------------------------------------;
; SET SEMAPHORE....				;
;-----------------------------------------------;

lock	or	cs:byte ptr _AP_SEMAPHORE,01h	; IPI handler is started

;-----------------------------------------------;
; FILL CPU INFO BUFFER....			;
;-----------------------------------------------;

	cli
	cld
	mov	ax,cs
	mov	ds,ax
	mov	es,ax				; DS = ES = SS = CS
	mov	di,offset _AP_INFO		; AP data area ptr
	mov	al,byte ptr _NUM_OF_PROC	; AL = AP# (1 based)
next_ap_area:
	cmp	word ptr[di],0ffffh		; End of AP data area ?
	jz	end_init_ap			; Yes..
	dec	al				; This is the ptr ?
	jz	do_fill_ap			; Yes..
	mov	di,word ptr[di]			; Next chain ptr
	jmp	short next_ap_area		; Search for correct data area
do_fill_ap:
	inc	di
	inc	di				; DI = CPUINFOSTRUC ptr
	mov	bx,di				; Save ptr
	mov	si,offset boot_cpu_info_buffer	; BSP data area ptr
	mov	cx,sizeof CPUINFOSTRUC		; # of bytes to move
rep	movsb					; Copy BSP info first
	mov	di,bx				; DI = CPUINFOSTRUC ptr
	mov	eax,1				; Get ResetID and feature flag
	cpu_id					; Execute CPUID instruction
	mov	[di].CPUINFOSTRUC.dResetID,eax	; Update ResetID
	mov	[di].CPUINFOSTRUC.dFeature,edx	; Store CPU feature flag

;-----------------------------------------------;
; FILL SMI INFO BUFFER....			;
;-----------------------------------------------;

	push	eax				; Save ResetID
	mov	si,word ptr _AP_SMI_INFO_PTR
	mov	al,[di].CPUINFOSTRUC.bVndrNum	; Vendor#
	mov	[si].SMIINFOSTRUC.bVendor,al	; Fill vendor#
	push	cs
	call	EnableFlatMode
	mov	ebx,0fee00020h			; APIC_ID reg
	mov	eax,dword ptr[ebx]		; Get Local APIC_ID
	and	eax, not ClearDestMask		; Seperate 4 bit APIC_ID
	rol	eax,8				; AL = local APIC_ID
	mov	cs:[di].CPUINFOSTRUC.bCPUAPICID,al
	mov	cs:[si].SMIINFOSTRUC.bAPICID,al	; Fill APIC_ID
	mov	bl,30h				; APIC Version register
	mov	eax,dword ptr[ebx]		; AL = APIC version
	mov	cs:[di].CPUINFOSTRUC.bCPUAPICVER,al
	
;-----------------------------------------------;
; DO CPU INITIALIZATION....			;
;-----------------------------------------------;

	pop	edx				; EDX = ResetID
	mov	ax,cs
	mov	ss,ax				; SS = CS, ROM Stack
	CallNS	initcpu@reset			; init cpu

;-----------------------------------------------;
; SET SEMAPHORE....				;
;-----------------------------------------------;

lock	add	cs:word ptr _AP_SMI_INFO_PTR,sizeof SMIINFOSTRUC
lock	inc	cs:byte ptr _NUM_OF_PROC	; Increment number of processor

end_init_ap:

lock	or	cs:byte ptr _AP_SEMAPHORE,02h	; IPI ends, waits for INIT

;-----------------------------------------------;
; WAIT TILL BSP DOES INIT_IPI....		;
;-----------------------------------------------;

halt_cpu:
	jmp	$
	
ActivityMonitor			ENDP



;-----------------------------------------------------------------------------;
;			      INIT AP BEFORE BOOT			      ;
;-----------------------------------------------------------------------------;
;	This procedure initializes the Application Processors before boot.    ;
;	This initialization includes programming MTRR and LocalAPIC.	      ;
;	** This code is executed by all application processors simultaneously.;
;	   CS is writable at that time.					      ;
;-----------------------------------------------------------------------------;
;	Input	: none							      ;
;	Output	: none							      ;
;	Reg use	: can destroy any register				      ;
;-----------------------------------------------------------------------------;

	_AP_STACK_TOP	dw	8000h
	_AP_BUSY_FLAG	dw	0000h

InitAPBeforeBOOT		PROC

lock	bts	cs:word ptr _AP_BUSY_FLAG,0
	jc	InitAPBeforeBOOT		; Wait till another AP busy

	call	cs:word ptr _BEFORE_BOOT_PROC	; Before boot init procedure
	
lock	inc	cs:byte ptr _AP_NUMBER
lock	and	cs:_AP_BUSY_FLAG,0fffeh		; Free busy flag
	jmp	$

InitAPBeforeBOOT		ENDP

;-----------------------------------------------------------------------------;


AssignProcID		PROC	Public
Assign_Proc_ID		PROC	Public

	push	ds
	pushad
	mov	bl,0
	mov	cs:byte ptr _AP_NUMBER,bl
	call	AssignProcNumber
	push	cs
	push	offset AssignAPID		; Address where all APs will go
	push	cs:word ptr uncom_segment	; 64K scratch segment
	call	WakeupAP			; Give control to all APs
	push	cs:word ptr uncom_segment	; 64K scratch segment
	call	SpinLockBSP			; Wait until all APs are done
	call	InitAP				; Initialize all APs
	popad
	pop	ds
	ret

Assign_Proc_ID		ENDP
AssignProcID		ENDP

AssignAPID		PROC	Private

	call	BeginLockSection		; Lock next critical section
	inc	cs:byte ptr _AP_NUMBER
	mov	bl,cs:byte ptr _AP_NUMBER
	call	AssignProcNumber		; Assign the AP number
	call	SpinLockAP			; Register as done
	call	EndLockSection			; Allow next AP to execute
	jmp	$

AssignAPID		ENDP	

;-----------------------------------------------------------------------------;

AssignProcNumber	PROC	Public
Extern				EnableFlatMode	:near
Extern				DisableFlatMode	:near

	push	esi
	push	ebx
	movzx	ebx,bl				; EBX = aissignment#
	push	bx
	push	cs
	call	EnableFlatMode
	mov	esi,0fee00020h
	mov	eax,dword ptr[esi]		; Local APICID
	and	eax,0f0ffffffh
	ror	ebx,8
	or	eax,ebx
	mov	dword ptr[esi],eax		; Write it back
	push	cs
	call	DisableFlatMode
	pop	bx				; BX = assignment#

; Change global structures
	mov	cs:byte ptr cpu_apic_id,0	; BSP = 0, always
	mov	ax,bx				; AX = 1 based AP number
	or	bx,bx				; This time assigning for BSP ?
	jz	smi_apn				; Yes..
	dec	bx
	imul	bx,bx,(sizeof(CPUINFOSTRUC)+2)	; Skip AP structures (offset)
	add	bx,offset _AP_INFO
	mov	cs:[bx+2].CPUINFOSTRUC.bCPUAPICID,al
smi_apn:
	mov	bx,ax
	imul	bx,bx,sizeof(SMIINFOSTRUC)
	add	bx, sizeof(SMIINFOHDRSTRUC)
	add	bx,offset smi_info_buffer
	mov	cs:[bx].SMIINFOSTRUC.bAPICID,al
	
ret_apn:
	pop	ebx
	pop	esi
	ret
	
AssignProcNumber	ENDP




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

