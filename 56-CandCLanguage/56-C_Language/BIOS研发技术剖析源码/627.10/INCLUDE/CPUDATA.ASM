	page	,132
	title	CPU/FPU INFORMATION DATA AREA IN CODE SEGMENT
	.286p
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
;-----------------------------------------------------------------;
;*****************************************************************;
;---------------------------------------;
	include	cpustruc.def
	include	cpumac.mac
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
;---------------------------------------;
	public	_CID_STARTS
_CID_STARTS	label	byte		; marks start of module

;---------------------------------------;
	public	cpu_freq
	public	cpu_freq_x100
cpu_freq	dw	0ffffh		; CPU clock in MHz
cpu_freq_x100	dw	0ffffh		; CPU Clock * 100 in MHz
;---------------------------------------;

; $$$CORE0061 >>>
	extrn	cpu_freq_table				:word
	extrn	cpu_freq_table_end			:word

	extern	cyrix_freq(cpu_freq_table)		:word
	extern	cyrix_freq_end(cpu_freq_table_end)	:word

	extern	amd_freq(cpu_freq_table)		:word
	extern	amd_freq_end(cpu_freq_table_end)	:word

	extern	ibm_freq(cpu_freq_table)		:word
	extern	ibm_freq_end(cpu_freq_table_end)	:word

	extern	ti_freq(cpu_freq_table)			:word
	extern	ti_freq_end(cpu_freq_table_end)		:word

	extern	umc_freq(cpu_freq_table)		:word
	extern	umc_freq_end(cpu_freq_table_end)	:word

	extern	sgs_freq(cpu_freq_table)		:word
	extern	sgs_freq_end(cpu_freq_table_end)	:word

	extern	idt_freq(cpu_freq_table)		:word
	extern	idt_freq_end(cpu_freq_table_end)	:word

	extern	rise_freq(cpu_freq_table)		:word
	extern	rise_freq_end(cpu_freq_table_end)	:word

	public	freq_offset_table
freq_offset_table	label	word
	dw	cpu_freq_table			; Intel
	dw	cpu_freq_table_end
	dw	cyrix_freq			; Cyrix
	dw	cyrix_freq_end
	dw	amd_freq			; AMD
	dw	amd_freq_end
	dw	ibm_freq			; IBM
	dw	ibm_freq_end
	dw	ti_freq				; TI
	dw	ti_freq_end
	dw	umc_freq			; UMC
	dw	umc_freq_end
	dw	sgs_freq			; SGS
	dw	sgs_freq_end
	dw	idt_freq			; IDT
	dw	idt_freq_end
	dw	rise_freq			; Rise
	dw	rise_freq_end


;-----------------------------------------------------------------------------;
;			BOOT STRAP PROCESSOR DATA AREA			      ;
;-----------------------------------------------------------------------------;

	public	boot_cpu_info_buffer
	public	cpu_string_ptr
	public	cpu_vendor_ptr
	public	cpu_vendor
	public	cpu_number
	public	cpu_func_field
	public	cpu_extd_func_field
	public	cpu_resetid
	public	detected_cpu_vendor
	public	smi_info_ptr
	public	cpu_apic_id
	public	cpu_apic_ver
	public	cpu_feature

boot_cpu_info_buffer	label	byte
cpu_string_ptr		dw	offset cgroup:cpu_name	; CPU name string ptr
	      		dw	0f000h
cpu_vendor_ptr		dw	offset cgroup:cpu_vendor_name
			dw	0f000h
cpu_vendor		db	00h	; functional CPU vendor# considering
					; override option
cpu_number		db	00h	; CPU number
cpu_func_field		dw	0000h	; CPU function field
cpu_resetid		dd	00000000h; CPUID at reset in EDX
cpu_extd_func_field	dw	0000h	; CPU extended function field
detected_cpu_vendor 	db	00h	; detected CPU vendor# as found in reset
smi_info_ptr		dw	offset cgroup:smi_info_buffer; ptr to smi info area
			dw	0f000h
cpu_apic_id		db	00h	; CPU local APIC_ID (for multiproc sys)
cpu_apic_ver		db	00h	; CPU local APIC_VER(  ''  )
; $$$LDCM0001 >>>
cpu_feature		dd	55h	; CPU feature flag
; $$$LDCM0001 <<<

;---------------------------------------;
	public	cpu_vendor_name
	public	cpu_name
	public	cpu_name_display_buffer
	public	cpu_name_display_buffer_end
	public	fpu_vendor_name
	public	fpu_name
	public	smi_info_buffer
        public	pr_string		;   122696
cpu_vendor_name	label	byte
	db	8 dup (00h)
	db	00h
cpu_name	label	byte
;$$$CORE0069>
;	db	'Generic-X86',0,0,0,0
	db	'Generic-X86',(25-11) dup (0)
;<$$$CORE0069
	db	00h
cpu_name_display_buffer		label	byte
;$$$CORE0069>
;	db	'Generic-X86',0,0,0,0
	db	'Generic-X86',(25-11) dup (0)
;<$$$CORE0069
	db	00h
pr_string	db	'PR',0,0,0,0,0,0; '2-xxx '
	db	00h
cpu_name_display_buffer_end	label	byte

;---------------------------------------;
;	FPU DATA AREA			;
;---------------------------------------;
	public	fpu_info_buffer
	public	fpu_string_ptr
	public	fpu_vendor_ptr
fpu_info_buffer	label	byte
fpu_string_ptr	dw	offset cgroup:fpu_name; ptr to fpu name ASCIIZ string
		dw	0f000h
fpu_vendor_ptr	dw	offset cgroup:fpu_vendor_name
		dw	0f000h
;---------------------------------------;
fpu_vendor_name	label	byte
;;;;	db	08 dup (00h)
	db	00h
fpu_name	label	byte
;;;;	db	15 dup (00h)
	db	00h

;-----------------------------------------------------------------------------;
;			SMI INFORMATION DATA AREA			      ;
;-----------------------------------------------------------------------------;

public	smi_info_buffer
smi_info_buffer:

CreateSMIInfo	PC			; PC is the number of processor
					; in the motherboard. This is given
					; from commandline at assembly time
					; by /D option.


;-----------------------------------------------------------------------------;
;			MEMORY REGION INFORMATION			      ;
;-----------------------------------------------------------------------------;

Public	_NC_REG1_START
Public	_NC_REG1_END
Public	_NC_REG2_START
Public	_NC_REG2_END
Public	_USWC_REG1_START
Public	_USWC_REG1_END
Public	_USWC_REG2_START
Public	_USWC_REG2_END
Public	_TOP_OF_MEM
Public	_L1_CACHE_STATE
Public	_SHADOW_STATE
Public	_USWC_STATE

_NC_REG1_START		dword	?	; Keeps the non cacheable reg-1 start
_NC_REG1_END		dword	?	; Keeps the non cacheable reg-1 end
_NC_REG2_START		dword	?	; Keeps the non cacheable reg-2 start
_NC_REG2_END		dword	?	; Keeps the non cacheable reg-2 end
_USWC_REG1_START	dword	?	; Keeps the USWC reg-1 start
_USWC_REG1_END		dword	?	; Keeps the USWC reg-1 end
_USWC_REG2_START	dword	?	; Keeps the USWC reg-2 start
_USWC_REG2_END		dword	?	; Keeps the USWC reg-2 end
_TOP_OF_MEM		dword	?	; Keeps the top of the memory found
_L1_CACHE_STATE		byte	?	; Keeps the L1 cache information
_SHADOW_STATE		word	?	; Keeps the shadow information
_USWC_STATE		byte	?	; Keeps the VGA USWC memory info


;-----------------------------------------------------------------------------;
;			MULTI-PROCESSOR DATA AREA			      ;
;-----------------------------------------------------------------------------;

Public	_AP_SEMAPHORE
_AP_SEMAPHORE			db	00h	; Semaphore used by APs

;	ÚÄÂÄÂÄÂÄÂÄÂÄÂÄÂÄ¿
;	³7³6³5³4³3³2³1³0³
;	ÀÄÁÄÁÄÁÄÁÄÁÄÁÄÁÄÙ
;                    ÀÂÙ
;		      ³
;
;		      00 :IPI handler is free to execute........ set by BSP
;		      01 :IPI handler is started................ set by AP
;		      10 :IPI handler is allowed to INIT self... set by BSP
;			  (This combination is reserved for future use)
;		      11 :IPI handler is waiting for INIT self.. set by AP

;-----------------------------------------------------------------------------;

Public	_AP_NUMBER
_AP_NUMBER			db	00h	; Keeps AP# while init

;-----------------------------------------------------------------------------;

Public	_NUM_OF_PROC
_NUM_OF_PROC			db	01h	; Keeps number of proc found

;-----------------------------------------------------------------------------;

public	application_cpu_info_buffer
Public	_AP_INFO
application_cpu_info_buffer:
_AP_INFO:

	CreateAPInfo	(PC-1)

						; Create Appln Proc data area.
						; PC is the number given
						; in assembly time (/D). This
						; is the total number of proc
						; in the system. So number of
						; AP will be (PC-1)

;-----------------------------------------------------------------------------;

Public	_AP_SMI_INFO_PTR
_AP_SMI_INFO_PTR		dw	0000h	; Keeps AP SMI info ptr



;*****************************************************************************;

	public	_CID_ENDS
_CID_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end

