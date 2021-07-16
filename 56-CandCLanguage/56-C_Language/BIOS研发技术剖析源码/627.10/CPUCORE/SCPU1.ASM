
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


;  
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
	extrn	cpu_name_display_buffer		:byte
	extrn	boot_cpu_info_buffer		:byte
	extrn	smi_info_buffer			:byte
	extrn	ram_segment			:byte
	extrn	vendor_post_data_base		:byte
	
	extrn	CheckPtCPU			:near
	extrn	IncSubChkPt			:near
	extrn	DoInitAPIC			:near
	
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

	call	DoInitAPIC
;;;;	test	bp,8000h			; Soft reset (Ctrl-Alt-Del) ?
;;;;	jnz	end_ic@p			; Yes.. skip that programming

;-----------------------------------------------;
; FILL CPU BUFFER....				;
;-----------------------------------------------;

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
	mov	di,cs:smi_info_ptr		; ES:DI = smi info buffer ptr
	mov	ax,0001h
	stosw					; #of entry in SMI info buffer
	mov	al,cs:cpu_vendor		; Functional cpu vendor#
;;;;	mov	ah,00h				; 0 for BSP ..AH is already 0
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

;---------------------------------------;
end_ic@p:
	jmp	cpu_init_end

InitCPU@POST			ENDP

;*****************************************************************************;

extrn				get_memory_info		:near
extrn				get_shadow_status	:near
extrn				get_processor_info	:near
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

