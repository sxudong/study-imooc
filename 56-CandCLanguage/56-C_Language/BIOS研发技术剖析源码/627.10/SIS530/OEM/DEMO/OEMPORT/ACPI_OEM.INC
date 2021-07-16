;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1997, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;

;*****************************************************************;
; OEM Porting Functions For ACPI Support - REQUIRED               ;
;   This file is required for proper ACPI support. This file is   ;
;   included by ACPITBL.ASM, and contains OEM hooks.              ;
;*****************************************************************;

;*****************************************************************;
; Porting Step #1 - Before porting hooks in this file, go to      ;
;                   ACPI_OEM.EQU. Define additional chipset       ;
;                   specific equates which are located in         ;
;                   ACPI_OEM.EQU (REQUIRED for ACPITBL.ASM)       ;
;*****************************************************************;

;*****************************************************************;
; Porting Step #2 - Implement the functions below. They will be   ;
;                   called by ACPITBL.ASM when the ACPI Tables    ;
;                   are built during POST.                        ;
;                   NOTE: Use Int 1Ah to access PCI Config Space. ;
;*****************************************************************;
;-----------------------------------------------------------------------;
; Set/Reset the equates according to the hardware capabilities.		;
; Each equate has the detail description along with it.			;
;-----------------------------------------------------------------------;
WBINVD_FLAG	equ	0		; WBINVD instruction correctly flushes the processor
					; caches, maintains memory coherency, and upon completion
					; of the instruction, all caches for the current processor
					; contain no cached data other than what the OS references
					; and allows to be cached. If this flag is not set, the
					; ACPI OS is responsible for disabling all ACPI features
					; that need this function. (bit 0 of 32)
WBINVD_FLUSH	equ	0		; If set, indicates that the hardware flushes all caches
					; on the WBINVD instruction and maintains memory coherency,
					; but does not guarantee the caches are invalidated. If
					; neither of the WBINVD flags are set, the system will
					; require FLUSH_SIZE and FLUSH_STRIDE to support sleeping
					; states. If the FLUSH parameters are also not supported,
					; the machine cannot support sleeping states S1, S2, or S3.
					; (bit 1 of 32)
PROC_C1		equ	0		; A one indicates that the C1 power state is supported on
					; all processors. (bit 2 of 32)
P_LVL2_UP	equ	0		; A zero indicates that the C2 power state is configured to
					; only work on a UP system. A one indicates that the C2
					; power state is configured to work on a UP or MP system.
					; (bit 3 of 32)
PWR_BUTTON	equ	0		; A zero indicates the power button is handled as a fixed
					; feature programming model. (bit 4 of 32)
SLP_BUTTON	equ	1		; A zero indicates the sleep button is handled as a fixed
					; feature programming model. (bit 5 of 32)
FIX_RTC		equ	0		; A zero indicates the RTC wake-up status is supported in
					; fixed register space. (bit 6 of 32)
RTC_S4		equ	0		; Indicates whether the RTC alarm function can wake the
					; system from the S4 state. The RTC must be able to wake
					; the system from S1, S2, or S3. (bit 7 of 32)
TMR_VAL_EXT	equ	0		; A zero indicates TMR_VAL is implemented as a 24-bit value.
					; A one indicates TMR_VAL is implemented as a 32-bit value.
					; (bit 8 of 32)
DCK_CAP		equ	0		; A zero indicates the platform does not support docking.
					; A one indicates the platform can support docking.
					; NOTE: This bit does not indicate the presence of a
					; docking station (bit 9 of 32 - defined in Errata 11/7/97)
					; Bits 10-32 reserved in ACPI v1.0
;-----------------------------------------------------------------------;
; acpi_oem_set_facp_flags (PORTING REQUIRED)				;
;									;
;	Input:		none						;
;	Output:		EDX						;
;	Destroys:	EDX						;
;  	DO NOT DESTROY ANY OTHER REGISTERS				;
;-----------------------------------------------------------------------;
acpi_oem_set_facp_flags		proc	private
	xor	edx, edx		; use equates above to form 32-bit FACP Flags register
	or	edx, WBINVD_FLAG + 2*WBINVD_FLUSH + 4*PROC_C1 + 8*P_LVL2_UP + 16*PWR_BUTTON + 32*SLP_BUTTON + 64*FIX_RTC + 128*RTC_S4 + 256*TMR_VAL_EXT + 512*DCK_CAP

	ret
acpi_oem_set_facp_flags		endp

;-----------------------------------------------------------------------;
; acpi_oem_clear_status_flags (PORTING OPTIONAL)			;
;									;
;  Clear ACPI status Flags before building the tables			;
;  This is for OEM/Platform specific changes not addressed in chipset	;
;  hook (acpi_css_clear_status_flags).					;
;									;
;  No input, no output, no registers destroyed				;
;-----------------------------------------------------------------------;
acpi_oem_clear_status_flags	proc	private

	ret
acpi_oem_clear_status_flags	endp

;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1997, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;

