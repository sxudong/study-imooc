;-----------------------------------------------------------------------------;
;  S T R U C T U R E   D E F I N I T I O N S   F O R   C P U   M O D U L E    ;
;-----------------------------------------------------------------------------;

;---------------------------------------;
;     VENDOR POST DATABASE STRUC	;
;---------------------------------------;

VNDRPSTSTRUC		STRUCT

	wMemProc	word	?	; Family member detection proc ptr
	wMemDBase	word	?	; Family member database ptr
	wRstMemProc	word	?	; Reset time member detection proc ptr
	wRstInitProc	word	?	; Reset time init routine address
	wBootInitProc	word	?	; Before BOOT init procedure address

VNDRPSTSTRUC		ENDS

;---------------------------------------;
;     VENDOR RUNTIME DATABASE STRUC	;
;---------------------------------------;

VNDRRUNSTRUC		STRUCT

	wEnbCache	word	?	; Enable cache procedure address
	wDisCache	word	?	; Disable acche procedure address
	wShtInitProc	word	?	; Shutdown initialize procedure
	wFlushCache	word	?	; Flush cache procedure address
	wDisBTB		word	?	; Disable BTB procedure address
	wEnbBTB		word	?	; Enable BTB procedure address

VNDRRUNSTRUC		ENDS

;---------------------------------------;
;	VENDOR CHECK LIST STRUC		;
;---------------------------------------;

VNDRCHKSTRUC		STRUCT

	wVndrChkProc	word	?	; Vendor check proc address
	wVndrHndl	word	?	; VendorHandle

VNDRCHKSTRUC		ENDS

;---------------------------------------;
;	FAMILY DATABASE STRUC		;
;---------------------------------------;

FAMILYSTRUC		STRUCT

	wHndlID		word	?	; ResetID/DIR.. for the CPU
	wFuncField	word	?	; Functional field for the CPU
	b$Num		byte	?	; String# for the CPU
	bCPUNum		byte	?	; Assigned CPU# for the CPU

FAMILYSTRUC		ENDS

;---------------------------------------;
;     FAMILY DATABSE HEADER STRUC	;
;---------------------------------------;

FMLYHDRSTRUC		STRUCT

	wFamilyEnd	word	?	; End pointer of Family database
	bFmly$Set	byte	?	; Family string set
	bFmly$Num	byte	?	; Vendor(family) name string#

FMLYHDRSTRUC		ENDS

;---------------------------------------;
;	NEW CPU CHECK STRUCTURE		;
;---------------------------------------;

CPUCHECKSTRUC		STRUCT

	wVndrHndl	word	?	; VendorHandle
	wChkProc	word	?	; Check routine for that vendor
	wChkTblStart	word	?	; CPU table offset
	wChkTblEnd	word	?	; CPU table offset end

CPUCHECKSTRUC		ENDS

;---------------------------------------;
;	CPU INFORMATION STRUCTURE	;
;---------------------------------------;

CPUINFOSTRUC		STRUCT

	d$Ptr		dword	?	; CPU name string far pointer
	dVndr$Ptr	dword	?	; CPU Vendor name string far pointer
	bVndrNum	byte	?	; CPU Vendor number
	bNum		byte	?	; CPU number
	wFuncField	word	?	; CPU function field
	dResetID	dword	?	; CPU hard reset ID (EDX)
	wExtdFuncField	word	?	; CPU extended function field
	bDetectedVndr	byte	?	; Detected CPU vendor
	dSMIInfoPtr	dword	?	; SMI information pointer
	bCPUAPICID	byte	?	; APIC_ID (for multiproc system)
	bCPUAPICVer	byte	?	; APIC version#
	dFeature	dword	?	; CPU feature flag

CPUINFOSTRUC		ENDS

;---------------------------------------;
;	SMI INFO HEADER STRUCTURE	;
;---------------------------------------;

SMIINFOHDRSTRUC		STRUCT

	wNumSMIInfo	word	?	; Number of SMI information

SMIINFOHDRSTRUC		ENDS

;---------------------------------------;
;	SMI INFO IN CPU INFORMATION	;
;---------------------------------------;

SMIINFOSTRUC		STRUCT

	bVendor		byte	?	; CPU vendor#
	bCPULevel	byte	?	; 0 for boot strap
	wSMICodeSize	word	?	; SMI code segment size
	dSMICodeSeg	dword	?	; SMI code segment

SMIINFOSTRUC		ENDS

;---------------------------------------;
;	FPU INFORMATION STRUCTURE	;
;---------------------------------------;

FPUINFOSTRUC		STRUCT

	dFPU$Ptr	dword	?	; CPU name string far pointer
	dFPUVndr$Ptr	dword	?	; CPU Vendor name string far pointer

FPUINFOSTRUC		ENDS

;---------------------------------------;
;	CCR TABLE STRUCTURE		;
;---------------------------------------;

CCRTBLSTRUC		STRUCT

	bCCR0		byte	?	; CCR0 value for Cyrix/TI/IBM CPU
	bCCR1		byte	?	; CCR1 value for Cyrix/TI/IBM CPU
	bCCR2		byte	?	; CCR2 value for Cyrix/TI/IBM CPU
	bCCR3		byte	?	; CCR3 value for Cyrix/TI/IBM CPU
	bCCR4		byte	?	; CCR4 value for Cyrix/TI/IBM CPU
	bCCR5		byte	?	; CCR5 value for Cyrix/TI/IBM CPU
	bPCR0		byte	?	; Performance Control Register value
	bPMR		byte	?	; Power Management Register value

CCRTBLSTRUC		ENDS

;*****************************************************************************;

PRATINGSTRUC	STRUCT

	wFreq	word	?
	sRating byte	?, ?, ?, ?

PRATINGSTRUC	ENDS

;---------------------------------------;

VPRATINGSTRUC	STRUCT

	wFreq	word	?
	sRating	word	?

VPRATINGSTRUC	ENDS


