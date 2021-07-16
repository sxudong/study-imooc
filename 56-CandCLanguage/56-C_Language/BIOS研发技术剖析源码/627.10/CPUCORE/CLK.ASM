	page	60,130
	title	CPU CLOCK DETECTION
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

	extrn	detected_cpu_vendor	:byte
	extrn	_clock_difference_table	:byte

;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
;---------------------------------------;
	public	_CLK_STARTS
_CLK_STARTS	label	byte		; marks start of module
;---------------------------------------;
; this routine is used to determine the system clock speed..
; this routine uses scratch segment..before calling this routine, scratch
; segment must be tested..
;
; include the following equates
;
	Speed_Data	equ	0f000h
	Count_1 	equ	0f800h
	CPU_Speed	equ	0f802h
	Old_Counter	equ	0f804h
	scratch_segment	equ	04000h
;===============================================;
;		CPU_CLOCK			;
;find out the speed is as follows :		;
;	Speed = 1.19 * 10^6 * dC * n / dT	;
;	   dC = difference in no. of clocks for	;
;		the two instructions,		;
;	    n = no. of iterations 		;
;	   dT = difference in timer count	;
;In this particular test i = 1000 and n =8 	;
;instructions selected  "DIV BX" and "DIV BL".	;
;  input :					;
;	none					;
;  output:					;
;	ax	clock in MHz			;
;  register destroyed..ALL except BP DS ES	;
;===============================================;
					;$$$CPU0034->
;;core_clock_table	label	byte
;;; *10
;;	dw	666			; 66.6
;;	dw	600			; 60
;;	dw	750			; 75
;;	dw	833			; 83.3
;;	dw	1000			; 100
;;	dw	952			; 95.25
;;	dw	500			; 50
;;	dw	550			; 55
;;core_clock_table_end	label	byte
;;;---------------------------------------;
;;; *100
;;multiplier_table	label	byte
;;	dw	150			; 1.5x	; $$$CPU0026+
;;	dw	200			; 2x
;;	dw	250			; 2.5x
;;	dw	300			; 3x
;;	dw	350			; 3.5
;;	dw	400			; 4x
;;	dw	450			; 4.5x
;;	dw	500			; 5x
;;	dw	550			; 5.5x
;;	dw	600			; 6.0x
;;	dw	175			; 1.75x
;;multiplier_table_end	label	byte
;;;---------------------------------------;
					;<$$$CPU0034-

	public	cpu_clock
cpu_clock	proc	near

	push	ds				;save ds
	push	es				;save es
	cli					;disable interrupts
	mov	ax,scratch_segment		;scratch area segment address
	mov	es,ax				;get it in es

;...............................................;
.386p
	extrn	fixed_delay:near
	extrn	cpu_resetid:byte

	mov	al,cgroup:detected_cpu_vendor	; al = detected CPU vendor#

						;$$$CPU0027+>
	cmp	al,00h				; Intel?
	jne	cc_not_intel
	mov	ax,word ptr cgroup:cpu_resetid
	or	al,0fh				; discard stepping
	cmp	ax,153fh			; P24T ?
	je	no_tsc				; yes.. no TSC
	cmp	ax,155fh			; P24CT ?
	je	no_tsc				; yes.. no TSC
	and	ah,0fh
	cmp	ah,05h				; 586 ?
	je	tsc_cpu
	cmp	ah,06h				; 686 ?
	je	tsc_cpu
cc_not_intel:
						;<$$$CPU0027+

	mov	ah,cgroup:cpu_resetid+1		; get resetid+
	and	ah,0fh				; ah = family number
						; $$$CPU0030+>
	cmp	al,8				; RiSE CPU ?
	je	TSC_CPU				; (CPU0037)
						; <$$$CPU0030+
						; $$$CPU0008 >>>
	cmp	al,7				; IDT CPU ?
	je	TSC_CPU				; yes..
						; $$$CPU0008 <<<
						; $$$CPU0002 >>>
	cmp	ax,0502h			; AMD 586 ?
	je	TSC_CPU
	cmp	ax,0601h			; Cyrix M2 ?
	jne	no_TSC
TSC_CPU:
						; $$$CPU0002 <<<

; get time stamp ...

	mov	cx, 2
	call	fixed_delay		; to ensure next sampling of signal
					; will be done at start of the pulse

        db      0fh, 031h               ; RDTSC returns in edx:eax
        mov     ebx, eax
					; $$$CPU0025 >>>
        mov     cx, 66			; 66 decimal ...
        call    fixed_delay             ; wait ~ 990us
        db      0fh, 031h               ; RDTSC returns in edx:eax
        sub     eax,ebx
        xor     edx,edx
        mov     ecx,66*15		; 66*15us
        div     ecx                     ; divide by fixed time...
	mov	bx,ax			; BX = Actual clock in Mhz
	mov	ax,100
	mul	bx			; AX = cpu clock * 100
	jmp	cc_02			; go compare tables
					; $$$CPU0034->
no_TSC:
.286p
;<<<--------------------------------------------;

	mov	di,0				;di=0
	mov	ax,0f3f7h			;instruction = div bx, clocks=22
	push	ax				;save the instruction
	cld					;clear direction flag
;  #of interations..1000
	mov	cx,1000				;no. of words to be filled up

	rep	stosw				;fill up the area
	mov	al,0cbh				;return far instruction
	stosb					;store it at the end of the series
	pop	ax				;get back the instruction
	dec	ax				;instruction = div bl, clocks=14
;  the following DI content may have to be changed
;  if #of iterations is changed..
	mov	di,800h

	cld					;clear direction flag
;  #of interations..1000
	mov	cx,1000				;no. of words to be filled up

	rep	stosw				;fill up the area
	mov	al,0cbh				;return far instruction
	stosb					;store it at the end of the
	mov	ax,es				;get ds in ax
	mov	ds,ax				;put it in es
	call	get_count_difference		;Dummy execution to ensure cache hit
	mov	di,speed_data			;data storage area
	mov	cx,40				;no. of times test
get_speed_data:
	push	cx				;save test count
	push	di				;save storage offset address
	call	get_count_difference		;get the difference in clock
	pop	di				;get back storage address
	stosw					;save the difference in the
	pop	cx				;get test count back
	loop	get_speed_data			;continue fetching data and
	mov	si,speed_data			;storage area start offset addr
	mov	cx,40				;no. of times test was
	push	cx				;save test count
	sub	ax,ax				;initialize ax
	sub	dx,dx				;initialize dx
get_average:
	add	ax,[si]				;add sum with the next data
	adc	dx,+0				;result should be in dx:ax
	add	si,2				;point to the next data
	loop	get_average			;add up all the data
	pop	cx				;get the test count back
	div	cx				;divide the sum in DX:AX
	mov	cx,ax				;get the average value in cx
	mov	word ptr ds:[count_1],ax	;save it
;-----------------------------------------------;
;;;;;  1.1931 * 10^6 * diff in #of clocks / #of iterations
;;;;;  = (1.1931 * 10^6 * 8 / 1000)
;;;;;  = 9544.8
;;;;;  Now 9544.8 * 100 = 954480
;;;;;  and decimal 954480 = hex E9070
;;;;	mov	dx,000eh			;initialize dx
;;;;	mov	ax,9070				;1.1931 * 10^6 * 8 (i.e. diff.
;;;;						;in no. of clocks) / 1000 (i.e.
;;;;						;no. of iteratios)
;  1.1931 * 10^6 * diff in #of clocks / #of iterations
;  = (1.1931 * 10^6 * X / 1000)
;  = 1193.1 * X
;  Now 1193.1 * X * 100 = 119310 * X
;  and decimal 119310 = hex 1d20e
.386p
	mov	eax,1d20eh
	xor	ebx,ebx
	mov	bl,cgroup:detected_cpu_vendor	; detected CPU vendor#
	mov	bl,[cgroup:_clock_difference_table+bx]; diff in #of clocks
						; between DIV BX and DIV BL
	mul	ebx
	push	eax
	pop	edx
	shr	edx,16				; DX:AX = value
.286p
;-----------------------------------------------;
	div	cx				;divide by the average value
;-----------------------------------------------;
;-----------------------------------------------;
;;	shr	cx,1
;;	cmp	dx,cx				; 1/2 of the (difference in clocks)
;;	jb	@F				; Round down, remainder less than half
;;	inc	ax				; Round up, remainder greater than half
;;@@:
;---------------------------------------;
cc_02::
;
; AX = cpu clock *100
;
						; $$$CPU0015 >>>
	extrn	freq_offset_table:word
;	mov	si,offset cgroup:cpu_freq_table
.386p
	movzx	si,byte ptr cgroup:detected_cpu_vendor
.286p
	shl	si,2
	mov	cx,cgroup:freq_offset_table[si+2]	; offset of END
	mov	si,cgroup:freq_offset_table[si]
						; $$$CPU0015 <<<
ok_01:
						; $$$CPU0015 >>>
;	cmp	si,offset cgroup:cpu_freq_table_end
	cmp	si,cx
						; $$$CPU0015 <<<
	jae	ok_00
	mov	bx,cs:[si+2]
	cmp	ax,cs:[si]
	jbe	ok_00
	add	si,04h
	jmp	short ok_01
ok_00:
	push	ax			; found freq * 100
	push	bx			; rounded cpu clock in MHz
;  clear the segment used..
	xor	di,di
	mov	cx,8000h		; 64k bytes
	xor	ax,ax
	rep	stosw
	pop	ax			; AX = cpu clock in MHz
	pop	bx			; BX = found cpu clock * 100
	pop	es			; get back es
	pop	ds			; get back ds
	ret				; return to the caller
cpu_clock	endp
;===============================================;
;	PROCEDURE GET_COUNT_DIFFERENCE		;
;===============================================;
get_count_difference	proc	near
	cli					;disable interrupt
	in	al,61h				;read portB value
	mov	byte ptr ds:[old_counter],al	;save it
	call	pgm_timer			;program counter-2 in mode 2
	mov	bx,0ffffh			;initialize bx for division
	mov	al,byte ptr ds:[old_counter]	;get port B value
	or	al,1				;enable gate
	out	61h,al				;start the timer
;	call	far ptr XXXX:0000h 		;test loop 1
	db	09ah				;call far code
	dw	0				;offset
	dw	scratch_segment			;segment address
	mov	al,byte ptr ds:[old_counter]	;get port B value
	and	al,0fch				;disable gate
	out	61h,al				;stop the timer
	jmp	short $+2			;I/O delay
	call	get_count			;get clock count in ax
	mov	word ptr ds:[count_1],ax	;save the test loop 1 count
	in	al,61h				;read portB value
	mov	byte ptr ds:[old_counter],al	;save it
	call	pgm_timer			;program counter-2 in mode 2
	mov	bx,0ffffh			;initialize bx for division
	mov	al,byte ptr ds:[old_counter]	;get port B value
	or	al,1				;enable gate
	out	61h,al				;start the timer
;;;;	call	far ptr XXXX:0800h		;test loop 2
	db	09ah				;call far code
	dw	800h				;offset address
	dw	scratch_segment			;segment address
	mov	al,byte ptr ds:[old_counter]	;get counter value
	and	al,0fch				;disable gate
	out	61h,al				;stop the timer
	jmp	short $+2			;I/O delay
	call	get_count			;get clock count in ax
	sub	word ptr ds:[count_1],ax	;get difference in count
	mov	ax,word ptr ds:[count_1]	;get difference in ax
	ret					;return to the caller
get_count_difference	endp
;===============================================;
;	Read count from counter-2.		;
;===============================================;
get_count	proc	near
	in	al,42h				;read lsb
	jmp	short $+2			;I/O delay+bus_settle
	jmp	short $+2			;I/O delay
	mov	ah,al				;save lsb
	in	al,42h				;read msb
	xchg	ah,al				;get msb in ah and lsb in al
	neg	ax				;initial count was 0
	ret					;return to the caller
get_count	endp
;===============================================;
;	Program counter-2 in mode 2		;
;===============================================;
pgm_timer	proc	near
	in	al,61h				;read portB
	and	al,0fch				;disable speaker and gate
	out	61h,al				;write to portB
	jmp	short $+2			;I/O delay+bus_settle
	mov	al,0b4h				;counter 2,lsb,msb,mode 2,
						;binary
	out	43h,al				;program the counter
	jmp	short $+2			;I/O delay+bus_settle
	sub	al,al				;lsb=0
	out	42h,al				;write it
	jmp	short $+2			;I/O delay+bus_settle
	jmp	short $+2			;I/O delay+bus_settle
	out	42h,al				;msb=0
	ret					;return to the caller
pgm_timer	endp
;-----------------------------------------------;


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
;---------------------------------------;
	public	_CLK_ENDS
_CLK_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end
