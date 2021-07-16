;-----------------------------------------------------------------------------;
;
; IDT POST routines
;
;-----------------------------------------------------------------------------;
; IDT P-Rating
;-----------------------------------------------------------------------------;
; Input:
;	DX	0
; Output:
;	DL	bit 0 = 1 Clock is PRxxx
;		bit 1 = 1 Append Clock to CPU string
;		bit 2 = 1 Don't display clock at checkpoint AA
;	DS:SI	offset of prating table if DL.3=0
;		bit 3 = 1 Get prating value directly from DS:SI
;	DH	ASCII charactor to be append
;		0 = nothing appended
;	CY	no prating
;-----------------------------------------------------------------------------;

idt_struct	struct
	clock		word	?
	multiplier	byte	?
	pr_clock	word	?
idt_struct	ends

idt_2x		equ	08h
idt_233x	equ	15h
idt_25x		equ	0ch
idt_266x	equ	19h
idt_3x		equ	10h
idt_333x	equ	21h
idt_35x		equ	14h
idt_4x		equ	18h
idt_45x		equ	1ch
idt_5x		equ	20h

if (CPU_586)
winchip_2a_pr_tbl:
	idt_struct	{ 200,idt_3x,	200  }
	idt_struct	{ 200,idt_2x,	233  }
	idt_struct	{ 208,idt_25x,	233  }
	idt_struct	{ 233,idt_35x,	233  }
	idt_struct	{ 233,idt_233x,	266  }
	idt_struct	{ 250,idt_3x,	266  }
	idt_struct	{ 250,idt_25x,	300  }
	idt_struct	{ 266,idt_4x,	266  }
	idt_struct	{ 266,idt_266x,	300  }
	dw	00

winchip_3_pr_tbl:
	idt_struct	{ 200,idt_3x,	233  }
	idt_struct	{ 233,idt_35x,	266  }
	idt_struct	{ 233,idt_233x,	300  }
	idt_struct	{ 250,idt_25x,	333  }	; (CPU0042+)
	idt_struct	{ 266,idt_4x,	300  }
	idt_struct	{ 266,idt_266x,	333  }
	idt_struct	{ 285,idt_3x,	350  }
	idt_struct	{ 300,idt_45x,	333  }
	idt_struct	{ 300,idt_3x,	366  }
	idt_struct	{ 316,idt_333x,	380  }
	idt_struct	{ 333,idt_5x,	366  }
	idt_struct	{ 333,idt_333x,	400  }
	dw	00
endif;	if (CPU_586)

idt_prating	proc
	push	cs
	pop	ds			; ds = cs
	mov	si,offset winchip_2a_pr_tbl
	call	check_winchip2ab
	jnc	check_prating
	mov	si,offset winchip_3_pr_tbl
	mov	ax,word ptr cpu_resetid
	and	al,0f0h			; keep model number
	cmp	al,090h			; WinChip 3 ?
	jne	ip_no_pr		; no..
check_prating:
;	mov	ecx,10ah		; FCR4
;	RD_MSR				; edx:eax = value returned
;	and	al,00111111b		; keep bit 5:0
	mov	ecx,147h		; FCR4 workaround in MSR 147h
	RD_MSR
	shr	eax,23-2		; [26:23] = FCR4[5:2]
	and	al,00111100b		; keep bit [5:2]
	push	ax
	mov	ecx,10ah		; FCR4
	RD_MSR				; edx:eax = value returned
	and	al,00000011b		; keep bit 1:0
	pop	bx			; restore [5:2] in BL
	or	al,bl
	mov	bx,word ptr cpu_freq
cmp_next:
	cmp	bx,(idt_struct ptr [si]).clock; clock match ?
	jne	next_entry		; no..
	cmp	al,(idt_struct ptr [si]).multiplier; multiplier match ?
	jne	next_entry		; no..
	add	si,idt_struct.pr_clock	; point to pr_clock
ip_done:
	or	dl,00001110b		; append to CPU string and do not display actual clock, DS:SI = prating value
	clc
	jmp	short ip_exit
next_entry:
	add	si,sizeof idt_struct
	cmp     (idt_struct ptr [si]).clock,0; end of table ?
	jne	cmp_next		; not yet..
	mov	si,offset cgroup:word ptr cpu_freq; DS:SI = pointed to detected CPU frequency
	or	dl,08h			; bit3=1, get prating value directly from DS:SI
	jmp	short ip_done		; if not found, get actual clock as prating
ip_no_pr:
	stc
ip_exit:
	ret
idt_prating	endp



;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;
if (CPU_586)


		comment ๚	[README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û  TITLE: IDT CPU DETCTION/PROGRAMMING   Û
		Û					 Û
		Û	    ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		๚





		extrn	GetHandle	:near



		comment ๚


		ษอออออออออออออออออออออออออออออออออออออออออออป
		บ	     FindIDTFamilyMember	    บ
		ฬอออออออออออออออออออออออออออออออออออออออออออน
		บ This routine detects individual member    บ
		บ from the IDT database. This routine can   บ
		บ detect any kind of IDT CPU at any instant บ
		บ of time.				    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Environment	 : Stack available	    บ
		บ Invoked	 : from any time	    บ
		บ Restriction	 : DO NOT DESTROY ANY REG.  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ Input 	 : CL = 0: no CPUID	    บ
		บ			1: CPUID present    บ
		บ Output	 : AX = CPUHandle	    บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ	  Register Destroyed : AX	    บ
		ศอออออออออออออออออออออออออออออออออออออออออออผ


		๚



Public	FindIDTFamilyMember
FindIDTFamilyMember		proc	near

	pushad
	mov	bp,sp
	call	GetResetID		; DX <- CPU ResetID
	mov	ax,dx
	and	al,0f0h			; Stepping info 0, normal CPU
;	or	cl,cl			; S-series CPU (CPUID) ?
;	jz	no_step_f		; no..
					; (CPU0024+)>
	cmp	ax,0580h		; WinChip 2 CPU ?
	jne	not_winchip2		; no..
					; (CPU0042),(CPU0040+)>
	call	check_winchip2ab
	jc	old_winchip2
	; New WinChip 2A, stepping = 07h,08h,09h; 0ah-0fh
	mov	al,87h			; 0587h for WinChip 2A
	and	dl,0fh			; dl = stepping info
	cmp	dl,0ah			; >=0ah ?
	jb	short idt_01		; no.. done
	mov	al,08ah			; 058ah for WinChip 2B
	jmp	short idt_01		; go GetHandle
old_winchip2:
	mov	al,85h			; 0585h for WinChip 2
					; <(CPU0042),(CPU0040+)
	jmp	short idt_01		; (CPU0040+)
not_winchip2:
					; <(CPU0024+)
	or	al,0fh			; Steppping info indicates S-Series
;no_step_f:
idt_01:
	mov	bx,offset IDT_Family_Data_base
	call	GetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Get back reg, return parameters
	ret

FindIDTFamilyMember		endp


;---------------------------------------; (CPU0040+)>
; Output:
;	NC - WinChip 2A/2B
;---------------------------------------;
check_winchip2ab:
	push	dx
	call	GetResetID		; DX <- CPU ResetID
	and	dl,0fh			; dl = stepping info
	cmp	dl,05h			; old WinChip 2 stepping = 05h or 0ah
	je	cw_not_2ab
					; (CORE0042)>
;;	cmp	dl,0ah
;;	je	cw_not_2a
;;	cmp	dl,07h			; stepping = 7,8,9 = WinChip 2A
;;	jb	cw_not_2a
;;	cmp	dl,09h
;;	ja	cw_not_2a
	cmp	dl,07h			; 7,8,9 = WinChip 2A; 0ah-0fh = 2B
	jb	cw_not_2ab
					; <(CORE0042)
	clc
	jmp	short cw_exit
cw_not_2ab:
	stc
cw_exit:
	pop	dx
	ret
;---------------------------------------; <(CPU0040+)



		  comment ๚


		  ษอออออออออออออออออออออออออออออออออออออออป
		  บ	    GetIDTCPUHandle@Reset	  บ
		  ฬอออออออออออออออออออออออออออออออออออออออน
		  บ This routine returns the CPUHandle at บ
		  บ the time of reset.			  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Environment : No stack available	  บ
		  บ		  SS = CS		  บ
		  บ Invoked	: from reset time code	  บ
		  บ Restriction : DO NOT DESTROY SI, DI   บ
		  บ		  SP, BP AND UPPER 16 BITSบ
		  บ		  OF EAX, EBX, EDX	  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Input	: DX = ResetID		  บ
		  บ Output	: AX = CPUHandle	  บ
		  วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		  บ Register destroyed : AX,BX,CX,DX,ESP+ บ
		  ศอออออออออออออออออออออออออออออออออออออออผ


		  ๚




Public	GetIDTCPUHandle@Reset
GetIDTCPUHandle@Reset 	proc	near

	mov	ax,dx			; AX <- ResetID
;;	or	al,0fh			; To discard stepping info (CORE0040-)
	mov	si,sp			; Save current SP
	mov	bx,offset IDT_Family_Data_base
	CallNS	GetHandle		; AX = CPUHandle
	mov	sp,si			; Get back original SP
	mov	dx,cx			; DX = ResetID/CPUID
	ret

GetIDTCPUHandle@Reset 	endp


		comment ๚


		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	        InitIDTCPU@Reset	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This routine programs different registers บ
		บ  of the different IDT CPUs.	 	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack not available    บ
		บ		      SS = CS		     บ
		บ  Invoked	    : from reset time code   บ
		บ  Restriction	    : DO NOT DESTROY         บ
		บ		      SP, BP AND UPPER 16    บ
		บ		      BITS OF EAX, EBX, EDX  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : AX = CPUHandle	     บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Register destroyed : EAX, BX, DX, EDI+    บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚



Public	InitIDTCPU@Reset
InitIDTCPU@Reset		proc	near

;	mov	edi,eax
;	mov	bx, offset IDT_Family_Data_Base
;	add	bx,4			; Skip the header
;	mov	cx,sizeof FAMILYSTRUC
;	mul	cx			; AX = offset in the family database
;	add	bx,ax
;	cmp	cs:[bx].FAMILYSTRUC.bCPUNum,UnknownCPU
;	jz	end_init_a2		; Unknown CPU, no need for initialize
;end_init_a2:
;	mov	eax,edi			; EAX restored
	ret

InitIDTCPU@Reset		endp




		comment ๚


		ษออออออออออออออออออออออออออออออออออออออออออออป
		บ	    InitIDTCPUBeforeBOOT	     บ
		ฬออออออออออออออออออออออออออออออออออออออออออออน
		บ  This procedure initialize the registers   บ
		บ  to configure the memory region.	     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Environment	    : Stack available	     บ
		บ  Invoked	    : Anytime after InitCPU  บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Input	    : none		     บ
		บ  Output	    : none		     บ
		วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
		บ  Register destroyed : none		     บ
		ศออออออออออออออออออออออออออออออออออออออออออออผ
		๚



Public	InitIDTCPUBeforeBOOT
InitIDTCPUBeforeBOOT		proc	near

	pushad
				;CPU0024+>
	call	get_memory_info ; esi = total memory size in bytes
	xor	bp,bp		; bp = 0, no memory hole
	call	if_hole_15_16m
	jnc	iicbb_01
	mov	bp,1		; memory hole enable
iicbb_01:
	mov	edi,esi
	shr	edi,20		; size in 1MB
	call	WinChip_Memory_Features
				;<CPU0024+
				;; $$$CPU0016+ >>>
;%out === Fix for GVC ===
;	mov	edx, 00h
;	mov	eax, 0fffda3c8h
;	mov	ecx, 0142h
;	wr_msr
				;; $$$CPU0016+ <<<
	popad

	ret

InitIDTCPUBeforeBOOT		endp


;===========================================================
; IDT WinChip 2 Write Combining Support
;===========================================================
; base/mask pairs for memory ranges

; 0 - 512K
base_0		equ	00000000000000000000000000000000b
mask_512K	equ	11111111111110000000000000000000b

; 512K 640K
base_512K	equ	00000000000010000000000000000000b
mask_640K	equ	11111111111111100000000000000000b

; 1M - 2M
base_1		equ	00000000000100000000000000000000b
mask_2		equ	11111111111100000000000000000000b

; 2M - 4M
base_2		equ	00000000001000000000000000000000b
mask_4		equ	11111111111000000000000000000000b

; 4M - 8M
base_4		equ	00000000010000000000000000000000b
mask_8		equ	11111111110000000000000000000000b

; 8M - 16M
base_8		equ	00000000100000000000000000000000b
mask_16		equ	11111111100000000000000000000000b
mask_12		equ	11111111110000000000000000000000b

; 16M - 32M
base_16		equ	00000001000000000000000000000000b
mask_32		equ	11111111000000000000000000000000b

; 32M - 64M
base_32		equ	00000010000000000000000000000000b
mask_64		equ	11111110000000000000000000000000b

; 64M - 128M
base_64		equ	00000100000000000000000000000000b
mask_128	equ	11111100000000000000000000000000b

; 128M - 256M
base_128	equ	00001000000000000000000000000000b
mask_256	equ	11111000000000000000000000000000b

; 256M - 512M
base_256	equ	00010000000000000000000000000000b
mask_512	equ	11110000000000000000000000000000b

; 512M - 1024M
base_512	equ	00100000000000000000000000000000b
mask_1024	equ	11100000000000000000000000000000b

; 1024M - 2048M
base_1024	equ	01000000000000000000000000000000b
mask_2048	equ	11000000000000000000000000000000b

; 2048M - 4096M
base_2048	equ	10000000000000000000000000000000b
mask_4096	equ	10000000000000000000000000000000b


; programming table for memory range registers
IDT_MCR_table label dword
	dd	base_2048
	dd	mask_4096

	dd	base_1024
	dd	mask_2048

	dd	base_512
	dd	mask_1024

	dd	base_256
	dd	mask_512

	dd	base_128
	dd	mask_256

	dd	base_64
	dd	mask_128

	dd	base_32
	dd	mask_64

	dd	base_16
	dd	mask_32

	dd	base_8
	dd	mask_16

	dd	base_4
	dd	mask_8

	dd	base_2
	dd	mask_4

	dd	base_1
	dd	mask_2

	dd	base_512K
	dd	mask_640K

	dd	-1
MCRbaseno	equ 	110h
MCR_CTRL	equ 	120h

MCRvalue	equ	1111100000000000000001111b

BCRno		equ	145h
TLOCKbit	equ	3


;=========================================================
;Name : Winchip Memory Features
;
; ** This routine should be called ONLY AFTER an IDT
; WinChip CPU has been identified
;
;Function : To enable the IDT WinChip write combining and
; weak read ordering
;
;Inputs: edi = memory size in MB
; bp = 1 if memory hole exists from 15 to 16MB
; 0 if not
;
;=========================================================

WinChip_Memory_Features	Proc	near

	pushad

; first assume C6
; see memory range descriptors for details

; bh has trait bits, bl = 0 if C6, 1 if WinChip 2
; traits=111b, bl=0

	mov	ebx, 11100000000b

; now check feature level to see if we understand what to do
; we have to skip the programming if we are dealing with the
; wrong levels
					; (CPU0037+)>
	mov	ax,word ptr cgroup:cpu_resetid
	and	ax,0fff0h		; discard stepping info
	cmp	ax,0540h		; C6 ?
	jz	sub_1M			; yes.. bl=0
					; <(CPU0037+)
	mov	ecx, MCR_CTRL
	rd_msr
	and	eax, 111b shl 17	; check [19:17]
	jz	sub_1M			; if 0, it's C6
	cmp	eax, 1 shl 17		; if 1, it's WC2
	jne	No_Memory_Features	;skip if not 1

; here if WinChip 2
; traits to turn on are weak read ordering and byte
; combining
; traits=10001b, bl=1

	mov	ebx, 1000100000001b
sub_1M:

	; always set up 0-512K region

	mov	ecx, MCRbaseno
	mov	edx, base_0
	mov	eax, mask_512K
	or	al, bh 			;OR in the local trait bits
	wr_msr

; now calculate offset into table to program the rest of
; the memory range registers
; bsr returns the bit index of the highest 1 (largest power
; of 2 in the number)

	bsr	ecx, edi
	neg	ecx
	lea	esi, [8*ecx+offset IDT_MCR_table+96]

; esi now contains the offset

	mov	ecx, MCRbaseno+1
program_one_mcr:
	mov	edx, cs:dword ptr [si]
	cmp	edx, -1
	je	short mcr_done
	mov	eax, cs:dword ptr [si+4]
	cmp	edx, base_8
	jne	short around_hole_check
	or	bp, bp
	jz	short around_hole_check
	mov	eax, mask_12 		; if hole enabled
around_hole_check:
	or	al, bh 			;OR in the local trait bits
	wr_msr
	add	si, 8
	inc	ecx
	cmp	ecx, MCRbaseno+8
	jb	program_one_mcr
mcr_done:
; finally set up MCR_CTRL
; no trait mode control for c2c
	mov	edx, 0
	mov	ecx, MCR_CTRL
	test	bl, bl			; check for WinChip 2
	jz	c2cwc			; if C6

; if WinChip 2, need to get trait mode control bits
	rd_msr 				; bits 19:17 trait mode control
; isolate these bits
	and	eax, 111b shl 17
	shr	eax, 11 		; move them to 8:6
	mov	edx, eax 		; save the isolated bits
c2cwc:
	mov	eax, MCRvalue 		; get control value
	or	eax, edx 		; OR in trait mode control
	mov	edx, 0 			; prepare to write back
	wr_msr
	mov	ecx, BCRno
	rd_msr
	or	ax, 1 shl TLOCKbit
	wr_msr
No_Memory_Features:
	popad
	ret

WinChip_Memory_Features	endp


else;	if (CPU_586)

FindIDTFamilyMember:
	call	DummyFindFamilyMember
	ret
FindIDTFamilyMember:
GetIDTCPUHandle@Reset:
InitIDTCPU@Reset:
InitIDTCPUBeforeBOOT:
	ret


endif;	if (CPU_586)

;------------------------------------------------------------------------------;
;
;
; IDT CPU ID tables
;
;
;------------------------------------------------------------------------------;
;	IDT Family Database


;	HEADER:
;	------

	Public	IDT_Family_Data_Base
IDT_Family_Data_Base:
	dw	offset default_idt_entry
	db	CPU$Set
	db	IDT_$

;	FAMILY DATABASE:
;	---------------

if (CPU_586)
db	04fh, 005h, SMI+Bus64+Clk1X+CachePgm3,	  FPU+NoInit+ID+iSMI,	C6_$,		IDTC6
								; (CPU0019+)>
db	085h, 005h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	WinChip2_$,	WinChip2 ; (CPU0040)
;; No 3D string needed anymore.
;;db	081h, 005h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	WinChip2_$,	WinChip2 ; 3D ; (CPU0024+)
								; <(CPU0019+)
								; (CPU0040+)>
db	087h, 005h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	WinChip2A_$,	WinChip2A
db	09fh, 005h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	WinChip3_$,	WinChip3

								; <(CPU0040+)
db	08ah, 005h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	WinChip2A_$,	WinChip2B ; (CPU0042+)
endif

default_idt_entry:
db	0fh, 0ffh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+NoInit+ID+iSMI,	Unknown_$,	0ffh


;------------------------------------------------------------------------------;
;
;
; IDT CPU name strings
;
;
;------------------------------------------------------------------------------;
Create_IDT_CPU_names	macro

if (CPU_586)

        Create_CPU$	IDT_$
			db	'IDT',0


	Create_CPU$	C6_$
			db	' WinChip C6',0	; (CPU0011)

						; (CPU0019+), (CPU0024)>
	Create_CPU$	WinChip2_$
			db	' WinChip 2',0

;	Create_CPU$	WinChip2_3D_$
;			db	' WinChip 2-3D',0
						; <(CPU0019+), (CPU0024)
						; (CPU0040+)>
	Create_CPU$	WinChip2A_$
			db	' WinChip 2 - ',0

	Create_CPU$	WinChip3_$
			db	' WinChip 3 - ',0
						; <(CPU0040+)
endif;	if (CPU_586)

endm;	Create_IDT_CPU_names	macro

