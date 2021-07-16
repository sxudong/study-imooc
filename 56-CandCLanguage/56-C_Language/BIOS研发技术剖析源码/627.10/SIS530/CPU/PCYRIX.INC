;-----------------------------------------------------------------------------;
;
; Cyrix POST routines
;
;-----------------------------------------------------------------------------;

;-----------------------------------------------------------------------------;
; Cyrix P-Rating
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
cyrix_prating	proc
if (CPU_586)
	mov	ax,word ptr cpu_resetid
	mov	dl,00000010b		; CPU string with xxx(MHz)
	mov	dh,'+'			; PRxxx+
	mov	si,offset cx_m1_pr_tbl
	cmp	ah,5			; M1 class ?
	jz	put_prating		; yes..

	xor	dh,dh			; no '+'
	mov	dl,00000011b		; CPU/Clock
	cmp	ah,6			; M2 class ?
	stc
	jnz	cp_exit			; no.. no prating
					; (CPU0018)>
	call	ReadDIR			; ah = DIR1, al = DIR0
	cmp	ah,MII_DIR1_BASE	; DIR1>=08h (MII) ?
	jb	csmc_not_mii
	mov	dl,00000110b		; bit2=1-no cpu clock, bit1=1-CPU with xxx
csmc_not_mii:
					; (CPU0009)>
;;	mov	bx,cgroup:word ptr cpu_freq
;;	cmp	bx,150			; 150 MHz
;;	je	check_special_m2_clock
;;	cmp	bx,166			; 166 MHz
;;	jne	put_prating
;;
;;check_special_m2_clock:
;;; ah = DIR1, al = DIR0
;;;	call	ReadDIR			; ah = DIR1, al = DIR0
;;	mov	cl,al			; cl = DIR0
;;	and	al,not 08h
;;	cmp	al,51h			; DIR0 = 51h/59h ?
;;	jne	put_prating		; no.. not 2x for 150/166Mhz
;;;	mov	si,offset cx_m2_special_pr_tbl

; Check if M2 special PRating first
	mov	cl,al			; cl = DIR0
	and	cl,00000111b		; keep bit2:0 for clock ratio (1/2/3/4/5 = 2/2.5/3/3.5/4)
	mov	ax,cgroup:word ptr cpu_freq
	; ax = detected clock
	; cl = clock ratio index (1/2/3/4 = 2/2.5/3/3.5)
	mov	si,cgroup:offset m2_special_tbl
next_m2_table:
	cmp	ax,(M2_PR_STRUC ptr cgroup:[si]).clock
	jne	not_match		; clock not in table..
	cmp	cl,(M2_PR_STRUC ptr cgroup:[si]).ratio
	jne	not_match		; ratio not match..
					; (CPU0036)>
;	movzx	ax,(M2_PR_STRUC ptr cgroup:[si]).pr_index
;	mov	ch,sizeof (vPRATINGSTRUC)
;	mul	ch
;	add	ax,offset cgroup:cx_m2_pr_tbl + sizeof (vPRATINGSTRUC).wFreq + 2 ; 2 = number of entries
;	mov	si,ax
	add	si,offset (M2_PR_STRUC).pr_clock
					; <(CPU0036)
	or	dl,08h			; DL.3=1 get prating value from DS:SI
	jmp	short put_prating
not_match:
	add	si,sizeof (M2_PR_STRUC)
	cmp	si,offset cgroup:cx_special_tbl_end
	jb	next_m2_table

; Not special case..
	mov	si,offset cgroup:cx_m2_pr_tbl
					; <(CPU0009)
					; <(CPU0018)
put_prating:

	clc
cp_exit:
endif;	if (CPU_586)
	ret
cyrix_prating	endp


if (CPU_586)
;-----------------------------------------------------------------------------;
cx_m1_pr_tbl:
		dw	6

;		PRATINGSTRUC	{ 80,  '90+ ' }
;		PRATINGSTRUC	{ 100, '120+' }
;		PRATINGSTRUC	{ 110, '133+' }
;		PRATINGSTRUC	{ 120, '150+' }
;		PRATINGSTRUC	{ 133, '166+' }
;		PRATINGSTRUC	{ 200, '200+' } ; 150Mhz, <=200
		vPRATINGSTRUC	{ 80,	90  }
		vPRATINGSTRUC	{ 100,	120 }
		vPRATINGSTRUC	{ 110,	133 }
		vPRATINGSTRUC	{ 120,	150 }
		vPRATINGSTRUC	{ 133,	166 }
		vPRATINGSTRUC	{ 200,	200 } ; 150Mhz, <=200

						; (CPU0018+)>
;-----------------------------------------------;
; 6x86MX PR Rating Table			;
;-----------------------------------------------;
; Cyrix M II-133	 50*2.0=100		;
; Cyrix M II-133	 55*2.0=110		; ^
; Cyrix M II-150	 60*2.0=120		;
; Cyrix M II-150	 50*2.5=125		; ^
; Cyrix M II-166	 66*2.0=133		;
; Cyrix M II-166	 55*2.5=138		;
; Cyrix M II-166	 50*3.0=150		;
; Cyrix M II-166	 60*2.5=150		; ^
; Cyrix M II-200	 75*2.0=150		; (special)
; Cyrix M II-200	 55*3.0=165		;
; Cyrix M II-200	 66*2.5=166		;
; Cyrix M II-233	 83*2.0=166		; (special)
; Cyrix M II-200	 50*3.5=175		;
; Cyrix M II-200	 60*3.0=180		;
; Cyrix M II-233	 75*2.5=188		; (special)
; Cyrix M II-200	 55*3.5=193		; ^
; Cyrix M II-200	 50*4.0=200		; (special)
; Cyrix M II-266	 66*3.0=200		; (special)	; (CPU0038)
; Cyrix M II-233	100*2.0=200		;
; Cyrix M II-266	 83*2.5=208		; (special)
; Cyrix M II-233	 60*3.5=210		;
; Cyrix M II-233	 55*4.0=220		; ^
; Cyrix M II-300	 75*3.0=225		;
; Cyrix M II-300	 90*2.5=225		;		; (CPU0038+)
; Cyrix M II-300	 66*3.5=233		;
; Cyrix M II-300	 95*2.5=237		;		; (CPU0038+)
; Cyrix M II-300	 60*4.0=240		; ^
; Cyrix M II-366	100*2.5=250		; (special)	; (CPU0036)
; Cyrix M II-333	 83*3.0=250		;
; Cyrix M II-333	 75*3.5=263		;
; Cyrix M II-333	 66*4.0=266		; ^
; Cyrix M II-350	 90*3.0=270		; ^      	; (CPU0038+)
; Cyrix M II-400	 95*3.0=285		; 		; (CPU0040)>,(CPU0038+)
; Cyrix M II-400	 83*3.5=292		;		; (CPU0038)
; Cyrix M II-400	 75*4.0=300		; 		; (CPU0038)
; Cyrix M II-433	100*3.0=300		; ^(special)	; (CPU0038), (CPU0036)
; Cyrix M II-433	 90*3.5=315		; ^		; (CPU0038+)
; Cyrix M II-466	 83*4.0=333		;		; (CPU0038+)
; Cyrix M II-466	 95*3.5=333		; ^		; (CPU0038+)
; Cyrix M II-500	100*3.5=350		;		; (CPU0038+)
; Cyrix M II-500	 90*4.0=360		; ^		; (CPU0038+)
; Cyrix M II-533	 95*4.0=380		; ^		; (CPU0038+)
; Cyrix M II-550	100*4.0=400		; ^		; <(CPU0040),(CPU0038+)
;-----------------------------------------------;
clk_20x		equ	01h
clk_25x		equ	02h
clk_30x		equ	03h
clk_35x		equ	04h
clk_40x		equ	05h
;-----------------------------------------------;
M2_PR_STRUC	struc
	clock		dw	?
	ratio		db	?
	pr_clock	dw	?		; (CPU0036)
M2_PR_STRUC	ends
;-----------------------------------------------;
m2_special_tbl	label	byte
	M2_PR_STRUC	{ 150, clk_20x, 200 }
	M2_PR_STRUC	{ 166, clk_20x, 233 }
	M2_PR_STRUC	{ 188, clk_25x, 233 }
	M2_PR_STRUC	{ 200, clk_40x, 200 }
	M2_PR_STRUC	{ 200, clk_30x, 266 }	; (CPU0038+)
	M2_PR_STRUC	{ 208, clk_25x, 266 }
	M2_PR_STRUC	{ 250, clk_25x, 366 }	; (CPU0036+)
	M2_PR_STRUC	{ 300, clk_30x, 433 }	; (CPU0040),(CPU0036+)
cx_special_tbl_end	label	byte

;-----------------------------------------------;
						; <(CPU0018+)

						; (CPU0018)>
cx_m2_pr_tbl	label	byte
		dw	(offset cgroup:cx_m2_pr_tbl_end - offset cgroup:cx_m2_pr_tbl) / sizeof(vPRATINGSTRUC)	; $$$CPU0017
;		        	  MHz   PR
		vPRATINGSTRUC	{ 110,	133 }
		vPRATINGSTRUC	{ 125,	150 }
		vPRATINGSTRUC	{ 150,	166 }
		vPRATINGSTRUC	{ 192,	200 }
		vPRATINGSTRUC	{ 220,	233 }
				      	      	   		; (CPU0017)>
		vPRATINGSTRUC	{ 208,	266 }
		; MII starts
		vPRATINGSTRUC	{ 240,	300 }
		vPRATINGSTRUC	{ 266,	333 }
				      	      	   		; (CPU0038),(CPU0040)>
		vPRATINGSTRUC	{ 270,	350 }
		vPRATINGSTRUC	{ 300,	400 }
		vPRATINGSTRUC	{ 315,	433 }
		vPRATINGSTRUC	{ 333,	466 }
		vPRATINGSTRUC	{ 360,	500 }
		vPRATINGSTRUC	{ 380,	533 }
		vPRATINGSTRUC	{ 400,	550 }
								; <(CPU0038),(CPU0040)
cx_m2_pr_tbl_end	label	byte
								; <(CPU0017)

;;								; (CPU0009)>
;;cx_m2_special_pr_tbl:
;;		dw	2
;;
;;		vPRATINGSTRUC	{ 150,	200 }	; 75*2 = PR200
;;		vPRATINGSTRUC	{ 166,	233 }	; 83*2 = PR233
;;								; <(CPU0009)
						; <(CPU0018)
;-----------------------------------------------------------------------------;
endif;	(CPU_586)




;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ;



		comment ú	 [README]
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		Û					 Û
		Û TITLE: CYRIX CPU DETCTION/PROGRAMMING  Û
		Û					 Û
		Û	   ****  P O S T  ****		 Û
		Û					 Û
		ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
		ú



		extrn	GetHandle		:near
		extrn	InitCyrixCPU@Shutdown	:near
		extrn	ReadCCR			:near
		extrn	WriteCCR		:near
		extrn	DummyReadCCR		:near
		extrn	get_processor_info	:near
		extrn	DisableCyrixCache	:near




%out ---| Cyrix6x86 table in POSTCPU.ASM |---

	db	'$$CT'			; table signature for BCP
	db	01h			; version number of the table
	db	'Cx6x86 Init', 0; ASCIIZ string specifying the chipset
	dw	offset cgroup:Cx6x86_init_table_end; ptr to end of table+1
	db	00h			; attribute
					; bit-0 = 0..byte register
					;	  1..word register
					; bit-1 = 0..byte data
					;	  1..word data
	db	'Register',0
	db	'Data',0

Cx6x86_init_table	label	byte
	db	0c0h,02h		; NC1 = 1 CCR0

	db	0e8h,17h		; CCR4, DTE_EN=1, IORT to min

	db	0c4h,00h		; ARR0 (A31-A24)
	db	0c5h,0ah		; ARR0 (A23-A16)
	db	0c6h,06h		; ARR0 (A15-A12, BSIZE)
;;	db	0dch,09h		; RCR0
; Fixed: Hang while TATUNG + Cx6x86 installing Windows 95 without cache
	if (MKF_CUSTOMER eq 1169)
	db	0dch,01h		; bit3=0 to solve sis6202 garbage
	else
	db	0dch,09h		; RCR0
	endif
	db	0c7h,00h		; ARR1 (A31-A24)
	db	0c8h,0ch		; ARR1 (A23-A16)
	db	0c9h,07h		; ARR1 (A15-A12, BSIZE)
	db	0ddh,01h		; RCR1

; Fixed: Hangs after SMI generated	;
; by Cyrix 6x86.			;
; This region is duplicated with ARR0 ;
;------------------------------------>>>;
;	db	0cdh,00h		; ARR3 (A31-A24)
;	db	0ceh,0eh		; ARR3 (A23-A16)
;	db	0cfh,04h		; ARR3 (A15-A12, BSIZE)
;<<<------------------------------------;
	db	0dfh,09h		; RCR3

	db	0e0h,00h		; RCR4
	db	0e1h,00h		; RCR5
	db	0e2h,00h		; RCR6

	db	0d9h,00h		; ARR7 (A31-A24)
	db	0dah,00h		; ARR7 (A23-A16)
	db	0dbh,00h		; ARR7 (A15-A12, BSIZE)
	if (MKF_CUSTOMER eq 1223)
	db	0e3h,03h		; RCR7 (bit3 = 0 for BIOSTAR)
	else
	db	0e3h,0bh		; RCR7
	endif

	db	0e9h,21h		; CCR5, Enable All ARRs, enable WT_ALLOC

Cx6x86_init_table_end label	byte

	public	program_cx6x86_regs
program_cx6x86_regs	proc
; Please put this code here.		;
; It set CR0.1=1 (non-cacheable)	;
;------------------------------------>>>;

	pusha

	extrn	ReadCCR :near
	extrn	WriteCCR:near

; Enable MAP
	mov	al,0c3h
	call	ReadCCR

	PUSH	AX			; STORE MAP

	or	ah,10h
	call	WriteCCR

	mov	bx, offset cgroup:Cx6x86_init_table
crb_init_m1:
	mov	ax, cgroup:[bx] 	; al = reg#, ah = value.
	call	WriteCCR
	inc	bx
	inc	bx
	cmp	bx, offset cgroup:Cx6x86_init_table_end
	jb	crb_init_m1

	cmp	byte ptr cgroup:cpu_resetid+1,06	; M2 family ?
	jne	pcr_not_m2
	extrn	@CYRIXSMIPARAMTBL:byte
					; (CPU0039-)>
;	and	cgroup:byte ptr @CYRIXSMIPARAMTBL[2],not 02h	; CCR2.1=0, disable SADS for M2
					; <(CPU0039-)
	mov	al,0e9h			; CCR5
	call	ReadCCR
;	or	ah,80h			; Enable FastIO
	and	ah,not 80h		; Disable FastIO but need to enable it in the future
	call	WriteCCR

	mov	al,0e8h			; CCR4
	call	ReadCCR
					; $$$CPU0017+ >>>
	or	cgroup:byte ptr @CYRIXSMIPARAMTBL[4],0c0h; CCR4.6=1->enable toggle mode for M2
	or	ah,0c0h			; Enable CPUID_EN for M2 CPU; bit6=1->TOGGLE=1 for M2
					; $$$CPU0017+ <<<
	call	WriteCCR

	; RCR0-RCR7.1 should be 0, M2 doesn't have WWO bit
	mov	al,0dch			; RCR0
clear_WWO_loop:
	call	ReadCCR
	and	ah,not 02h		; Clear Reserved bit
	call	WriteCCR
	inc	al
	cmp	al,0e3h			; RCR0-RCR7 ?
	jbe	clear_WWO_loop		; yes..

					; (CPU0040+)>
	extern	get_cmos_item		:near
	extern	Q_CYRIX_MII_PERFORMANCE	:abs
	mov	al,0e3h			; RCR7
	call	ReadCCR
	and	ah,not 04h		; clear bit 2 first
	push	ax
	mov	al,Q_CYRIX_MII_PERFORMANCE
	call	get_cmos_item
	pop	ax
	jz	weak_lock_done
	or	ah,04h			; RCR7.2=1 weak lock enabled
weak_lock_done:
	call	WriteCCR
					; <(CPU0040+)
pcr_not_m2:
;<<<------------------------------------;

	call	cx_arr7_btb_far

	POP	AX			; RESTORE MAP
	call	WriteCCR

	popa

	ret

program_cx6x86_regs	endp



;---------------------------------------;
; Note: MAPEN has to be on before call
; this routine.
; This routine will program:
; 1. ARR7 as cacheable region
; 2. ARR6/5/4 as non-cacheable region
; 3. Enable BTB
; 4. Enable Far Hit
;---------------------------------------;
cx_arr7_btb_far:

; Program ARR7
	extrn	get_mem_info:near
	call	get_mem_info		; AX = #of 64KB
	shr	esi,16
	mov	ax,si
	push	ax
	shr	ax,1			; start from 128KB (128/64=2)
	bsr	bx,ax
	mov	cx,bx

search_for_remainder:
	shr	ax,1
	jnc	crb_search_1		; NC - no bit set, continue..
	inc	bl			; there is a remainder, bl = bl + 1
	jmp	short prg_arr7_size
crb_search_1:
	loop	search_for_remainder
prg_arr7_size:
	mov	al,0dbh 		; ARR7 (Size)
	mov	ah,bl
	call	WriteCCR
	xor	edx,edx 		; clear (edx+)
	pop	dx			; dx = total memory in 64KB

; Set an non-cacheable region on ARR6/5/4 for the exceed part	;
; of DRAM should not be cacheable in ARR7.			;
; 042996: Make all ARRs same as Cyrix document			;
;---------------------------------------------------------------;
; bl = size in ARR7

	mov	cl,bl
	inc	cl
	mov	ax,1
	shl	ax,cl			; ax = ARR7 size in 64KB

	mov	si,ax			; si = top address of cacheable memory
	mov	ch,0d8h 		; ch = strat from ARR6
	mov	cl,0e2h 		; cl = RCR6

prg_noncache_regs_loop:
	mov	ax,si
	sub	ax,dx			; dx = total memory installed
	jz	no_noncache		; nonzero.. (no remainder)

	push	cx
	shl	ax,5			; bit 5 = 64KB in ARR6
	bsr	bx,ax			; bl = size in ARR6/5/4
	push	dx
					;$$$CPU0028+>
	cmp	bl,0fh			; remainder greater than 64MB ?
	jb	normal_arr654		; no..
	mov	bl,0eh			; 32MB(0eh).. because 0fh = 4GB, out of range
normal_arr654:
					;<$$$CPU0028+
	mov	eax,1
	mov	cl,bl
	sub	cl,5
	shl	ax,cl
	sub	si,ax			; ax = size subtracted in 64KB
	mov	dx,si			; si = top address of cacheable memory
	shl	edx,4+4 		; 4 (A12->A16(64K)) + 4 (high nibble)

	mov	ah,dl
	mov	al,ch			; ch = D8/D5/D2 (A15-A12)
	or	ah,bl			; bl = size
	call	WriteCCR
	mov	ah,dh
	dec	al			; D7/D4/D1 (A23-A16)
	call	WriteCCR
	shr	edx,16
	mov	ah,dl
	dec	al			; D6/D3/D0 (A31-A24)
	call	WriteCCR
	pop	dx

	pop	cx

	mov	al,cl			; CL = e2/e1/e0
	call	ReadCCR
	or	ah,1			; set non-cacheable in RCR
	call	WriteCCR

	dec	cl			; next RCR
	sub	ch,3			; next ARR
	cmp	ch,0d2h
	jae	prg_noncache_regs_loop

no_noncache:


	extrn	EnableCyrixBTB:near
	call	EnableCyrixBTB
	ret





;************;
if (CPU_CYRIX)
;************;

		comment ú

		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º	    FindCyrixFamilyMember	    º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º This routine detects individual member    º
		º from the Cyrix database. This routine     º
		º can detect any kind of Cyrix CPU at any   º
		º instant of time.			    º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º Environment	 : Stack available	    º
		º Invoked	 : from any time	    º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º Input 	 : CL = 0: no CPUID	    º
		º			1: CPUID present    º
		º Output	 : AX = CPUHandle	    º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º	  Register Destroyed : AX	    º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

		ú



Public	FindCyrixFamilyMember
FindCyrixFamilyMember	proc	near

	pushf
	pushad
	mov	bp,sp
	call	GetResetID		; DX = ResetID
	mov	di,offset Cyrix_Family_Data_Base
	call	cGetHandle		; AX = CPUHandle
	mov	word ptr[bp+StackPosEAX],ax
	popad				; Restore regs, return params
	popf
	ret

FindCyrixFamilyMember	endp



		  comment ú

		  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		  º	   GetCyrixCPUHandle@Reset	  º
		  ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		  º This routine returns the CPUHandle at º
		  º the time of reset.			  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º Environment : No stack available	  º
		  º		  SS = CS		  º
		  º Invoked	: from reset time code	  º
		  º Restriction : DO NOT DESTROY SI, DI   º
		  º		  SP, BP AND UPPER 16 BITSº
		  º		  OF EAX, EBX, EDX	  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º Input	: DX = ResetID		  º
		  º Output	: AX = CPUHandle	  º
		  ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		  º Register destroyed : AX, BX, CX, DX   º
		  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

		  ú



Public	GetCyrixCPUHandle@Reset
GetCyrixCPUHandle@Reset 	proc	near

	mov	cx,sp
	PushNS	ecx			; Save CX
	mov	di,offset Cyrix_Family_Data_Base
	CallNS	cGetHandle		; AX = CPUHandle
	mov	dx,cx			; DX = ResetID/DIR0, search handle
	PopNS	ecx			; Get back old CX
	mov	sp,cx
	ret

GetCyrixCPUHandle@Reset 	endp



		comment ú

		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º	      InitCyrixCPU@Reset	     º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º  This routine programs different registers º
		º  of the different Cyrix CPUs. 	     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Environment	    : Stack not available    º
		º		      SS = CS		     º
		º  Invoked	    : from reset time code   º
		º  Restriction	    : DO NOT DESTROY SI, DI  º
		º		      SP, BP AND UPPER 16    º
		º		      BITS OF EAX, EBX, EDX  º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Input	    : AX = CPUHandle	     º
		º  Output	    : none		     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º Reg destroyed : AX, BX, CX, DX SI, DI	     º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		ú



Public	InitCyrixCPU@Reset
InitCyrixCPU@Reset		proc	near

	mov	bx,sizeof FAMILYSTRUC
	mul	bx			; AX = offset to family database
	mov	bx,ax
	add	bx,offset Cyrix_Family_Data_Base+sizeof FMLYHDRSTRUC
	mov	al,cs:[bx].FAMILYSTRUC.bCPUNum
	mov	cx,cs:[bx].FAMILYSTRUC.wFuncField
	jmp	InitCyrixCPU@Shutdown

InitCyrixCPU@Reset		endp



		comment ú

		ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
		º	    InitCyrixCPUBeforeBOOT	     º
		ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
		º  This procedure initialize the registers   º
		º  to configure the memory region.	     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Environment	    : Stack available        º
		º  Invoked	    : Anytime after InitCPU  º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Input	    : none		     º
		º  Output	    : none		     º
		ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
		º  Register destroyed : EAX,EBX,ECX,EDX,ESI  º
		º  			EDI		     º
		ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
		ú

;********************;
endif;	if (CPU_CYRIX)
;********************;


extrn	_L1_CACHE_STATE			:byte
extrn	_TOP_OF_MEM			:dword

Public	InitCyrixCPUBeforeBOOT
InitCyrixCPUBeforeBOOT		proc	near

	call	get_processor_info	; AX = FuncField
	cmp	bh,UnknownCPU		; CPU is detected ?
	jz	ret_iccbb		; No, do nothing
	and	ah,0eh
	mov	bh,ah
	cmp	bh,InitXLC		; SLC/DLC processor ?
	jz	ret_iccbb		; Yes, nothing to do
	mov	al,0c2h 		; CCR2
	call	ReadCCR 		; AH = current value of CCR2
	and	ah,11111011b		; Unlock NW bit in CR0
	call	WriteCCR		; Write to CCR2
	mov	eax,cr0
	push	eax
	call	DisableCyrixCache	; Disable cache
	pop	eax
	and	eax,0dfffffffh		; NW = 0
	cmp	bh,InitM1		; M1 (6x86) processor ?
	jnz	do_wtwb 		; No..
	or	eax,020000000h		; NW bit has opposite meaning in M1
do_wtwb:
	test	cs:byte ptr _L1_CACHE_STATE,00000001b
	jz	wr_to_cr0		; User set cache as WriteThrough
	xor	eax,020000000h		; User set cache as WriteBack
wr_to_cr0:
	mov	cr0,eax 		; Set cache accordingly
ret_iccbb:


					; $$$CPU0003+ / $$$CPU0005 >>>
if (CPU_586)
	if (SHARED_MEMORY)
	call	program_cx6x86_regs
	endif
endif
					; $$$CPU0003+ / $$$CPU0005 <<<

	ret

InitCyrixCPUBeforeBOOT		endp



;-----------------------------------------------------------------------------;
;				ROUTINES USED				      ;
;-----------------------------------------------------------------------------;

cGetHandle:

;  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;  ³ Routine returns CPUHandle in AX		       ³
;  ³ Input : DX = ResetID as table, DI = database ptr  ³
;  ³ Output: AX = CPUHandle, CX = ResetID/DIR0         ³
;  ³ Register destroyed : BX, DX, ESI+, EDI+, ESP+     ³
;  ³ This routine does not use RAM stack, it creates   ³
;  ³ ROM stack. This routine can be called anytime     ³
;  ³ with or without RAM stack			       ³
;  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

;    Restriction : DO NOT DESTROY SI, DI, EAX+, EBX+, EDX+

	PushNS	esp			; Save SP in ESP+
	PushNS	esi			; Save SI in ESI+
	PushNS	edi			; Save DI in EDI+
	mov	si,ss			; SI = current SS
	mov	ax,cs
	mov	ss,ax			; Use ROM stack in this routine
	if	XLCSPRESENCE
	mov	al,0c2h 		; For checking CCR-2
	mov	cl,00000100b		; Bit 2
	xor	bx,bx			; BL will retain the check result
	JmpDI	CheckRdWR		; CCR-2, bit2 read/writeable ?
	jnz	check_CCR3		; No, CPU may not have DIR0, DIR1
	or	bl,00000001b		; Set bit as check passed
check_CCR3:
	mov	al,0c3h 		; For checking CCR-3
	mov	cl,00000010b		; Bit 1
	JmpDI	CheckRdWR		; CCR-3, bit1 read/writeable ?
	jnz	jmp_dir 		; CPU does not support DIR0, DIR1
	or	bl,00000010b		; Set bit as passed
jmp_dir:
	shl	bx,1			; For offset calculation
	mov	bx,cs:word ptr dir_jmp_tbl[bx]
	jmp	bx			; Jump to take action
dir_jmp_tbl:
	dw	offset check_c_id	; CPU has no DIR, check ResetID in DX
	dw	offset CPU486S_A	; CPU is Cx486S step A
	dw	offset check_dir	; CPU has DIR register
	dw	offset check_dir	; CPU has DIR register
CPU486S_A:
	mov	dx,0440h		; ResetID for Cx486S step A
	jmp	short check_c_id
	endif
check_dir:
	xor	dx,dx
	mov	al,0feh 		; DIR0 index
	CallNS	ReadCCR 		; Read configuration register
if (CPU_586)
	or	ah,0fh
endif
	mov	dl,ah			; DX = DIR content

; Use DIR on high byte to identify 6x86/6x86L
if (CPU_586)
	mov	al,0ffh 		; DIR1 index
	CallNS	ReadCCR 		; Read configuration register
					; $$$CPU0018+ >>>
	cmp	dl,05fh			; MX/MII (DIR0=5x) ?
	jne	cgh_01			; no..
	mov	dh,00h			; DIR1=00 for MX to compare with table
	cmp	ah,MII_DIR1_BASE	; MX (DIR1<08) ?
	jb	cgh_02			; yes..
	mov	dh,MII_DIR1_BASE	; DIR1=08 for MII to compare with table
	jmp	short cgh_02
cgh_01:
	or	ah,0fh
					; $$$CPU0018+ <<<
	mov	dh,ah			; DH = DIR1
cgh_02:
endif

check_c_id:
	xchg	ax,dx			; AX = ResetID
	PopNS	edi			; Get back old DI
	mov	bx,di			; BX = Family database ptr
	CallNS	GetHandle		; AX = CPUHandle
	mov	ss,si			; Get back old SS
	PopNS	esi			; Get back old SI
	PopNS	esp			; Get bacl old SP
	ret

;-----------------------------------------------------------------------------;

CheckRdWR:
;-------------------------------------------------------;
;  To check CCR in al, bit in BL is read/writable	;
;  Input    : AL = CCR, CL = bit to test		;
;  Output   : ZF = 0(JNZ) = not read/writeable		;
;		 = 1(JZ)  = read/writeable		;
;  Register destroyed: AX, CH				;
;-------------------------------------------------------;

	if	XLCSPRESENCE
	mov	ch,al			; CH = CCR to test
	CallNS	ReadCCR 		; Read CCR set in AL
	mov	dx,ax			; Save currrent content in upper word
	mov	al,ch			; Set AL = CCR index
	mov	ch,cl
	not	ch
	CallNS	ReadCCR 		; AH = CCR value
	and	ah,ch			; Set test bit = 0
	CallNS	WriteCCR		; Write this value
	CallNS	DummyReadCCR		; Dummy read to clear Bus
	CallNS	ReadCCR 		; AH = CCR value
	test	ah,cl			; Test requested bit
	jnz	ret_crw 		; Not read/writeable
	or	ah,cl			; Set test bit = 1
	CallNS	WriteCCR		; Write to CCR set in AL
	CallNS	DummyReadCCR		; Clear Bus
	CallNS	ReadCCR 		; Read CCR set in AL
	test	ah,cl			; Test bit, set flag accordingly
	jz	ret_crw 		; Not read/writeable
	mov	ax,dx			; Get back original CCR Index/value
	CallNS	WriteCCR		; Set it back
	xor	ax,ax			; ZF = 1, JZ
	jmp	di
ret_crw:
	mov	ax,dx			; Get back original CCR Index/value
	CallNS	WriteCCR		; Set it back
	or	al,0ffh 		; ZF = 0, JNZ
	jmp	di
	endif

;------------------------------------------------------------------------------;
;
;
; Cyrix CPU ID tables
;
;
;------------------------------------------------------------------------------;
;************;
if (CPU_CYRIX)
;************;
;	Cyrix Family Database


;	HEADER:
;	------

	Public	Cyrix_Family_Data_Base
Cyrix_Family_Data_Base:
	dw	offset default_cyrix_entry
	db	CPU$Set
	db	Cyrix_$

;	FAMILY DATABASE:
;	---------------

	if (CPU_386)
db	010h, 004h, NoSMI+Bus16+Clk1X+CachePgm1,  NoFPU+InitXLC,	Cx486SLC_$,	Cx486SLC
db	000h, 000h, NoSMI+Bus16+Clk1X+CachePgm1,  NoFPU+InitXLC,	Cx486SLC_$,	Cx486SLC
db	004h, 000h, NoSMI+Bus16+Clk1X+CachePgm1,  NoFPU+InitXLC,	Cx486SLC_$,	Cx486SLC
db	020h, 004h, NoSMI+Bus32+Clk1X+CachePgm1,  NoFPU+InitXLC,	Cx486DLC_$,	Cx486DLC
db	001h, 000h, NoSMI+Bus32+Clk1X+CachePgm1,  NoFPU+InitXLC,	Cx486DLC_$,	Cx486DLC
db	005h, 000h, NoSMI+Bus32+Clk1X+CachePgm1,  NoFPU+InitXLC,	Cx486DLC_$,	Cx486DLC
db	011h, 004h, SMI+Bus16+Clk1X+CachePgm1,	  NoFPU+InitXLC+CxSMI,	Cx486SLCe_$,	Cx486SLCe
db	021h, 004h, SMI+Bus32+Clk1X+CachePgm1,	  NoFPU+InitXLC+CxSMI,	Cx486DLCe_$,	Cx486DLCe
db	006h, 000h, NoSMI+Bus16+Clk2X+CachePgm1,  NoFPU+InitXLC,	Cx486SLC2_$,	Cx486SLC2
db	007h, 000h, NoSMI+Bus32+Clk2X+CachePgm1,  NoFPU+InitXLC,	Cx486DLC2_$,	Cx486DLC2
db	040h, 004h, NoSMI+Bus32+Clk1X+CachePgm3,  NoFPU+InitS,		Cx486SA_$,	Cx486SA1
db	050h, 004h, NoSMI+Bus32+Clk1X+CachePgm3,  NoFPU+InitS,		Cx486SA_$,	Cx486SA2
db	010h, 000h, SMI+Bus32+Clk1X+CachePgm3,	  NoFPU+InitS+CxSMI,	Cx486SB_$,	Cx486SB
	endif

	if (CPU_486)
db	011h, 000h, SMI+Bus32+Clk2X+CachePgm3,	  NoFPU+InitS+CxSMI,	Cx486S2_$,	Cx486S2
db	012h, 000h, SMI+Bus32+Clk1X+CachePgm3,	  NoFPU+InitS+CxSMI,	Cx486Se_$,	Cx486Se
db	013h, 000h, SMI+Bus32+Clk2X+CachePgm3,	  NoFPU+InitS+CxSMI,	Cx486S2e_$,	Cx486S2e
db	018h, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitDX+CxSMI,	Cx486DX_$,	CxM7_486DX
db	01ah, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitDX+CxSMI,	Cx486DX_$,	CxM7_486DX
db	019h, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitDX+CxSMI,	Cx486DX2_$,	CxM7_486DX2
db	01bh, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitDX+CxSMI,	Cx486DX2_$,	CxM7_486DX2
db	01fh, 000h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+InitDX+CxSMI,	Cx486DX4_$,	CxM7_486DX4
db	028h, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
db	02ah, 000h, SMI+Bus32+Clk1X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
db	029h, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
db	02bh, 000h, SMI+Bus32+Clk2X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
db	02dh, 000h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
db	02fh, 000h, SMI+Bus32+Clk3X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
db	02ch, 000h, SMI+Bus32+Clk4X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
db	02eh, 000h, SMI+Bus32+Clk4X+CachePgm3,	  FPU+InitM1sc+CxSMI,	CxM1sc_$,	CxM1sc_M9_5x86
	endif

	if (CPU_586)
db      02fh, 00fh, SMI+Bus64+Clk3X+CachePgm3,    FPU+InitM1+ID+CxSMI,  CxM1_$,         CxM1_6x86
db      02fh, 01fh, SMI+Bus64+Clk3X+CachePgm3,    FPU+InitM1+ID+CxSMI,  CxM1_$,         CxM1_6x86
db	03fh, 00fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	CxM1_$,         CxM1_6x86
db	03fh, 01fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	CxM1_$,         CxM1_6x86
db	03fh, 02fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	CxM1L_$,	CxM1_6x86L
								; (CPU0018)>
;db	05fh, 00fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	CxM2_$,         CxM2
;db	05fh, 01fh, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	CxM2_$,         CxM2
db	05fh, 000h, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	CxM2_$,         CxM2
db	05fh, MII_DIR1_BASE, SMI+Bus64+Clk3X+CachePgm3,	  FPU+InitM1+ID+CxSMI,	CxMII_$,        CxMII
								; <(CPU0018)
	endif

default_cyrix_entry:
db	0ffh,	0ffh,	SMI+Bus32+Clk3X+CachePgm3,	FPU+InitM1+ID+CxSMI,	Unknown_$,	0ffh

;********************;
endif;	if (CPU_CYRIX)
;********************;

;------------------------------------------------------------------------------;
;
;
; Cyrix CPU name strings
;
;
;------------------------------------------------------------------------------;
Create_Cyrix_CPU_names	macro

	Create_CPU$	Cyrix_$
			db	'Cx',0

if (CPU_386)
	Create_CPU$	Cx486SLC_$
			db	'486SLC',0

	Create_CPU$	Cx486DLC_$
			db	'486DLC',0

	Create_CPU$	Cx486SLCe_$
			db	'486SLC/e',0

	Create_CPU$	Cx486DLCe_$
			db	'486DLC/e',0

	Create_CPU$	Cx486SLC2_$
			db	'486SLC2',0

	Create_CPU$	Cx486DLC2_$
			db	'486DLC2',0

	Create_CPU$	Cx486SA_$
			db	'486S-A',0

	Create_CPU$	Cx486SB_$
			db	'486S-B',0
endif

if (CPU_486)
	Create_CPU$	Cx486S2_$
			db	'486S2(M6)',0

	Create_CPU$	Cx486Se_$
			db	'486Se(M6)',0

	Create_CPU$	Cx486S2e_$
			db	'486S2e(M6)',0

	Create_CPU$	Cx486DX_$
			db	'486DX(M7)',0

	Create_CPU$	Cx486DX2_$
			db	'486DX2(M7)',0

	Create_CPU$	Cx486DX4_$
			db	'486DX4(M7)',0

	Create_CPU$	CxM1sc_$
			db	'5x86(M1sc)',0
endif

if (CPU_586)
	Create_CPU$	CxM1_$
			db	'6x86-PR',0

	Create_CPU$	CxM1L_$
CxM1L_$_string:
			db	'6x86L-PR',0

	Create_CPU$	CxM2_$
								; (CPU0002)>
;			db	'M2',0
			db	'6x86MX-PR',0
								; <(CPU0002)

						; (CPU0018+),(CPU0029)>
	Create_CPU$	CxMII_$
			db	'Cyrix M II-',0
;			db	'Cyrix M II/IBM6x86MX-',0
						; <(CPU0018+),(CPU0029)
endif

endm;	Create_Cyrix_CPU_names	macro

