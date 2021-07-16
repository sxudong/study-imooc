;-----------------------------------------------------------------------------;
;***************************************************************************;


;лллллллллллллллллллллллллллллллл    EQUATES	лллллллллллллллллллллллллллллл;

;	CPU VENDOR NUMBER EQUATES:
;	-------------------------

Intel		equ	0
Cyrix		equ	1
AMD		equ	2
IBM		equ	3
TI		equ	4
UMC		equ	5
SGSTh		equ	6
Centaur		equ	7		; CPU_IDT
Rise		equ	8		; (CPU0014+)

;	7 - 3F ... Reserved

;-----------------------------------------------------------------------------;


StackPosEDI	equ	0	    ; Position of EDI on PUSHAD
StackPosESI	equ	4	    ; Position of ESI on PUSHAD
StackPosEBP	equ	8	    ; Position of EBP on PUSHAD
StackPosESP	equ	12	    ; Position of old ESP on PUSHAD
StackPosEBX	equ	16	    ; Position of EBX on PUSHAD
StackPosEDX	equ	20	    ; Position of EDX on PUSHAD
StackPosECX	equ	24	    ; Position of ECX on PUSHAD
StackPosEAX	equ	28	    ; Position of EAX on PUSHAD

StackPosDI	equ	0	    ; Position of DI on PUSHA
StackPosSI	equ	2	    ; Position of SI on PUSHA
StackPosBP	equ	4	    ; Position of BP on PUSHA
StackPosSP	equ	6	    ; Position of old SP on PUSHA
StackPosBX	equ	8	    ; Position of BX on PUSHA
StackPosDX	equ	10	    ; Position of DX on PUSHA
StackPosCX	equ	12	    ; Position of CX on PUSHA
StackPosAX	equ	14	    ; Position of AX on PUSHA
IBMID		equ	80h	    ; Describes bit used to detedct an IBM CPU
Dummy		equ	0ffh	    ; Used for dummy entry
UnknownVendor	equ	0ffh	    ; Code used when vendor cannot be detected
UnknownCPU	equ	0ffh	    ; Code used when CPU cannot be detected
Any             equ     'U'         ; Code used for undefined parameters
MinCPUInfoCMOS	equ	34h+80h	    ; CMOS used to keep min CPU info
MinCPUInfoMask	equ	00001111b   ; Bits used in CMOS, MUST BE CONSECUTIVE
ShrBitsInfoCMOS	equ	0	    ; #of bits to be shifted right to make the
				    ; value in cmos right justified
CPU$Set		equ	0	    ; CPU string set


NoSMI		equ	00000000b   ; Mask for CPU has no SMI support
SMI		equ	10000000b   ; Mask for CPU supports SMI
Bus16		equ	00000000b   ; Mask for 16 bit Bus size CPU
Bus32		equ	00100000b   ; Mask for 32 bit Bus size CPU
Bus64		equ	01000000b   ; Mask for 64 bit Bus size CPU
Clk1X		equ	00000000b   ; Mask for CPU with no clock multiplier
Clk2X		equ	00001000b   ; Mask for CPU with clock doubler
Clk3X		equ	00010000b   ; Mask for CPU with clock tripler
Clk4X		equ	00011000b   ; Mask for CPU with clock quadrupler
NoFPU		equ	00000000b   ; Mask for CPU with no integrated FPU
FPU		equ	00000001b   ; Mask for CPU having integrated FPU
NoCache 	equ	11111111b   ; FF -> CPU have no internal cache
NoCachePgm	equ	00000000b   ; No cache related programming needed
CachePgm1	equ	00000001b   ; Cache programming, method-1, WT
CachePgm2	equ	00000010b   ; Cache programming, method-2, WB
CachePgm3	equ	00000011b   ; Cache programming, method-3, WT/WB

NoInit		equ	00000000b   ; Code for no initialization
Init386		equ	00000000b   ; CPU initialization method for 386 class
Init486		equ	00000010b   ; CPU initialization method for 486 class
InitP5		equ	00000100b   ; CPU initialization method for Pentium
InitP6		equ	00000110b   ; CPU initialization method for P6

InitXLC		equ	00000000b   ; CPU init code for Cyrix SLC/DLC CPUs
InitS		equ	00000010b   ; CPU init code for Cyrix S series CPUs
InitDX		equ	00000100b   ; CPU init code for Cyrix DX/DX2 CPUs
InitM1		equ	00000110b   ; CPU init code for Cyrix M1 CPU
InitM1sc	equ	00001000b   ; CPU init code for Cyrix M1sc CPU

InitK5		equ	00000100b   ; CPU init code for AMD K5 class CPU

InitIBM1	equ	00000000b   ; CPU init code for IBMSLC/SLC2 CPUs
InitIBM2	equ	00000010b   ; CPU init code for IBMSLC 1X/2X CPUs

ID		equ	00010000b   ; CPUID presence
iSMI		equ	00000000b   ; Intel style SMI
CxSMI		equ	00100000b   ; Cyrix style SMI
AmSMI		equ	01000000b   ; AMD style SMI

MTRRdefType	equ	02ffh	    ; Default MTRR reg index
MTRRfix64K_0000	equ	0250h	    ; Fixed range MTRR index, for 00000 - 7FFFF
MTRRfix16K_8000	equ	0258h	    ; Fixed range MTRR index, for 80000 - 9FFFF
MTRRfix16K_A000	equ	0259h	    ; Fixed range MTRR index, for A0000 - BFFFF
MTRRfix4K_C000	equ	0268h	    ; Fixed range MTRR index, for C0000 - C7FFF
MTRRfix4K_C800	equ	0269h	    ; Fixed range MTRR index, for C8000 - CFFFF
MTRRfix4K_D000	equ	026Ah	    ; Fixed range MTRR index, for D0000 - C7FFF
MTRRfix4K_D800	equ	026Bh	    ; Fixed range MTRR index, for D8000 - CFFFF
MTRRfix4K_E000	equ	026Ch	    ; Fixed range MTRR index, for E0000 - C7FFF
MTRRfix4K_E800	equ	026Dh	    ; Fixed range MTRR index, for E8000 - CFFFF
MTRRfix4K_F000	equ	026Eh	    ; Fixed range MTRR index, for F0000 - C7FFF
MTRRfix4K_F800	equ	026Fh	    ; Fixed range MTRR index, for F8000 - CFFFF
MTRRphysBase0	equ	0200h	    ; Variable range MTRR base0
MTRRphysMask0	equ	0201h	    ; Variable range MTRR mask0
MTRRphysBase1	equ	0202h	    ; Variable range MTRR base1
MTRRphysMask1	equ	0203h	    ; Variable range MTRR mask1
MTRRphysBase2	equ	0204h	    ; Variable range MTRR base2
MTRRphysMask2	equ	0205h	    ; Variable range MTRR mask2
MTRRphysBase3	equ	0206h	    ; Variable range MTRR base3
MTRRphysMask3	equ	0207h	    ; Variable range MTRR mask3
MTRRphysBase4	equ	0208h	    ; Variable range MTRR base4
MTRRphysMask4	equ	0209h	    ; Variable range MTRR mask4
MTRRphysBase5	equ	020Ah	    ; Variable range MTRR base5
MTRRphysMask5	equ	020Bh	    ; Variable range MTRR mask5
MTRRphysBase6	equ	020Ch	    ; Variable range MTRR base6
MTRRphysMask6	equ	020Dh	    ; Variable range MTRR mask6
MTRRphysBase7	equ	020Eh	    ; Variable range MTRR base7
MTRRphysMask7	equ	020Fh	    ; Variable range MTRR mask7

; AbsOverwriteByte masks definitions:
; ----------------------------------

AbsVendorBit	equ	00000001b   ; Bit used for absolute vendor overwrite
AbsCPUBit	equ	00000010b   ; Bit used for absolute CPU overwrite

;*****************************************************************************;


crx_ti_index_reg		equ	022h	; index register
crx_ti_data_reg			equ	023h	; data register

crx_ti_index_reg_c0		equ	0c0h	; CCR0 (0c0h)
crx_ti_index_reg_c1		equ	0c1h	; CCR1 (0c1h)
crx_ti_index_reg_c2		equ	0c2h	; CCR2 (0c2h)
crx_ti_index_reg_c3		equ	0c3h	; CCR3 (0c3h)
crx_ti_index_reg_c4		equ	0c4h	; ARR1/NCR1 (0c4h,0c5h,0c6h)
crx_ti_index_reg_c5		equ	0c5h	;
crx_ti_index_reg_c6		equ	0c6h	;
crx_ti_index_reg_c7		equ	0c7h	; ARR2/NCR2 (0c7h,0c8h,0c9h)
crx_ti_index_reg_c8		equ	0c8h	;
crx_ti_index_reg_c9		equ	0c9h	;
crx_ti_index_reg_ca		equ	0cah	; ARR3/NCR3 (0cah,0cbh,0cch)
crx_ti_index_reg_cb		equ	0cbh	;
crx_ti_index_reg_cc		equ	0cch	;
crx_ti_index_reg_cd		equ	0cdh	; ARR4/NCR4/SMAR (0cdh,0ceh,0cfh)
crx_ti_index_reg_ce		equ	0ceh	;
crx_ti_index_reg_cf		equ	0cfh	;

;-----------------------------------------------;
;      CYRIX/TI CCR1 (0c1h) REG BIT EQUATES	;
;    Cx486SLCe,Cx486SLC2e,Cx486DLCe,Cx486DLC2e	;
;	Cx486Se,Cx486S2e,Cx486DX,Cx486DX2	;
;	 TI POTOMAC TI486SLCe,TI486SLC2e	;
;	 TI POTOMAC TI486DLCe,TI486DLC2e	;
;	     TI 486SXLCe,TI 486SXLC2e		;
;	      TI 486SXLe,TI 486SXL2e		;
;-----------------------------------------------;

crx_ti_ccr1_smi_bit	equ	00000010b	; enable SMI bit
crx_ti_ccr1_smac_bit	equ	00000100b	; system management memory access (SMAC) bit
crx_ti_ccr1_mmac_bit	equ	00001000b	; main memory access (MMAC) bit
crx_ti_ccr1_sm4_bit	equ	10000000b	; address region 4 control (SM4) bit

;-----------------------------------------------;
;       CYRIX CCR3 (0c3h) REG BIT EQUATES	;
;	Cx486Se,Cx486S2e,Cx486DX,Cx486DX2	;
;-----------------------------------------------;

crx_ccr3_smi_lock	equ	00000001b	; SMM register lock (SMI_LOCK) bit
crx_ccr3_nmien		equ	00000010b	; NMI enable (NMIEN) bit

						; (CPU0018+)>
;-----------------------------------------------;
; Cyrix MII CPU equates				;
;-----------------------------------------------;
MII_DIR1_BASE	        equ	08h		; MII CPU DIR1>=08h
						; <(CPU0018+)

;*****************************************************************************;
;		MULTI PROCESSOR EQUATES....				      ;
;*****************************************************************************;


	ProcNum		EQU	15		; Maximum number of processor
	ClearDestMask	EQU	0f0ffffffh	; AND mask for dest rsvrd bits
	ClearICRMask	EQU	0fff33000h	; AND mask for ICR rsvrd bits

	ORMaskNMI	EQU	000000400h	; OR mask to send NMI_IPI
	ORMaskINIT	EQU	000000500h	; OR mask to send INIT_IPI
	ORMaskSTARTUP	EQU	000004600h	; OR mask to send STARTUP_IPI


;*****************************************************************************;


;-----------------------------------------------------------------------------;
;				INTEL CPU NUMBERS			      ;
;-----------------------------------------------------------------------------;

	i386DX			equ	0
	i386SX			equ	i386DX+1
	i486DX			equ	i386SX+1
	i486SX			equ	i486DX+1
	i486DX2 		equ	i486SX+1
	i386SL			equ	i486DX2+1
	i486SL			equ	i386SL+1
	i486DXS 		equ	i486SL+1
	i486SXS 		equ	i486DXS+1
	i486DX2S		equ	i486SXS+1
	P24D			equ	i486DX2S+1
	i486DX4 		equ	P24D+1
	Pentium 		equ	i486DX4+1
	P54C			equ	Pentium+1
	P54CT			equ	P54C+1
	P24T			equ	P54CT+1
	P54CM			equ	P24T+1
	i486SX2S		equ	P54CM+1
	P55C			equ	i486SX2S+1
	P5T			equ	P55C+1
	P24CT			equ	P5T+1
	i486DX4OverDrive	equ	P24CT+1
	PentiumPro_P6		equ	i486DX4OverDrive+1
	P55CT			equ	PentiumPro_P6+1
	P6T			equ	P55CT+1
							; (CPU0021+)>
	Klamath_PentiumII	equ	P6T+1
	Deschutes		equ	Klamath_PentiumII+1
	Talimook		equ	Deschutes+1
	Celeron			equ	Talimook+1
							; <(CPU0021+)
	Mendocino		equ	Celeron+1	; (CPU0031+)
	Katmai			equ	Mendocino+1	; (CPU0033+)
	Xeon			equ	Katmai+1	; (CPU0034+)

;-----------------------------------------------------------------------------;
;				AMD CPU NUMBERS				      ;
;-----------------------------------------------------------------------------;

	Am386SXLV		equ	0
	Am386DXLV		equ	Am386SXLV+1
	Am486DXLV		equ	Am386DXLV+1
	Am486SXLV		equ	Am486DXLV+1
	Am386SXL		equ	Am486SXLV+1
	Am386DXL		equ	Am386SXL+1
	Am486SXL		equ	Am386DXL+1
	Am486DXL		equ	Am486SXL+1
	Am486SXL2		equ	Am486DXL+1
	Am486DXL2		equ	Am486SXL2+1
	Am486SXLV2		equ	Am486DXL2+1
	Am486DXLV2		equ	Am486SXLV2+1
	Am486SXPlus		equ	Am486DXLV2+1
	Am486DXPlus		equ	Am486SXPlus+1
	Am486DX2Plus		equ	Am486DXPlus+1
	Am486DX4_X5_5x86	equ	Am486DX2Plus+1
	AmK5_5k86_m0		equ	Am486DX4_X5_5x86+1	; Model 0
	AmK5_5k86_m1		equ	AmK5_5k86_m0+1		; Model 1
	AmK6			equ	AmK5_5k86_m1+1


;-----------------------------------------------------------------------------;
;				CYRIX CPU NUMBERS			      ;
;-----------------------------------------------------------------------------;

	Cx486SLC_old		equ	0
	Cx486DLC_old		equ	Cx486SLC_old+1
	Cx486SLCe		equ	Cx486DLC_old+1
	Cx486DLCe		equ	Cx486SLCe+1
	Cx486Se 		equ	Cx486DLCe+1
	CxM7_486DX		equ	Cx486Se+1
	Cx486SLC_new		equ	CxM7_486DX+1
	Cx486DLC_new		equ	Cx486SLC_new+1
	Cx486SLC		equ	Cx486DLC_new+1
	Cx486DLC		equ	Cx486SLC+1
	Cx486SLC2	 	equ	Cx486DLC+1
	Cx486DLC2	 	equ	Cx486SLC2+1
	Cx486SA1		equ	Cx486DLC2+1
	Cx486SA2		equ	Cx486SA1+1
	Cx486SB 		equ	Cx486SA2+1
	Cx486S2 		equ	Cx486SB+1
	Cx486S2e		equ	Cx486S2+1
	CxM7_486DX2		equ	Cx486S2e+1
	CxM1_6x86		equ	CxM7_486DX2+1
	CxM7_486DX4		equ	CxM1_6x86+1
	CxM1sc_M9_5x86		equ	CxM7_486DX4+1
	CxM2			equ	CxM1sc_M9_5x86+1	;   012897
	CxM1_6x86L		equ	CxM2+1			;   030497
	CxMII			equ	CxM1_6x86L+1		; (CPU0018+)


;-----------------------------------------------------------------------------;
;				IBM CPU NUMBERS				      ;
;-----------------------------------------------------------------------------;

	IBM386SLC		equ	0
	IBM486SLC		equ	IBM386SLC+1
	IBM486SLC2		equ	IBM486SLC+1
	IBM486DLC2		equ	IBM486SLC2+1
	IBM486DLC3		equ	IBM486DLC2+1

	; New kind IBM (Cyrix type) starts from 16 onwards
	;-------------------------------------------------
	IBM486DX		equ	16
	IBM486DX2		equ	IBM486DX+1
	IBMM1_6x86		equ	IBM486DX2+1
	IBMM1sc_M9_5x86		equ	IBMM1_6x86+1
							; (CPU0022+)>
	IBMM1_6x86L		equ	IBMM1sc_M9_5x86+1
	IBMM2			equ	IBMM1_6x86L+1
	IBMMII			equ	IBMM2+1
							; <(CPU0022+)
;-----------------------------------------------------------------------------;
;				TI CPU NUMBERS				      ;
;-----------------------------------------------------------------------------;

	TI486SLC		equ	0
	TI486DLC		equ	TI486SLC+1
	TI486SXL		equ	TI486DLC+1	; Also known as Potomac
	TI486SLCe		equ	TI486SXL+1
	TI486DLCe		equ	TI486SLCe+1
	TI486DX			equ	TI486DLCe+1
	TI486DX2		equ	TI486DX+1
	TI486DX4		equ	TI486DX2+1

;-----------------------------------------------------------------------------;
;				UMC CPU NUMBERS				      ;
;-----------------------------------------------------------------------------;

	UMCU5S			equ	0

;-----------------------------------------------------------------------------;
;			SGS-THOMSON CPU NUMBERS				      ;
;-----------------------------------------------------------------------------;

	ST486DX			equ	0
	ST486DX2		equ	ST486DX+1


;-----------------------------------------------------------------------------;
;				IDT CPU NUMBERS				      ;
;-----------------------------------------------------------------------------;

	IDTC6			equ	0
	WinChip2		equ	1	; (CPU0019+)
	WinChip2A		equ	2	; (CPU0040+)
	WinChip3		equ	3	; (CPU0040+)
	WinChip2B		equ	4	; (CPU0042+)

;-----------------------------------------------------------------------------;
;				Rise CPU NUMBERS				      ;
;-----------------------------------------------------------------------------;

						; (CPU0038)>
	RisemP6			equ	0	; (CPU0014+)
	RiseII			equ	RisemP6+1
	RiseCPU			equ	RiseII+1
						; <(CPU0038)




;-----------------------------------------------------------------------------;
;		P6PRESENCE	EQU	1
;		XLCSPRESENCE	EQU	1
;		M1PRESENCE	EQU	1

;  : Don't touch the following switches

	P6PRESENCE	=	0
	XLCSPRESENCE	=	0
	M1PRESENCE	=	0

if (CPU_686) and (CPU_INTEL)
	P6PRESENCE	=	1
endif

if (CPU_CYRIX) and (CPU_386)
	XLCSPRESENCE	=	1
endif

if (CPU_CYRIX) and (CPU_586)
	M1PRESENCE	=	1
endif

