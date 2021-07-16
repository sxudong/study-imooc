	page	,132
	title	EXTERNAL FUNCTIONS IN SETUP
;---------------------------------------------------------------;
; NOTE:	Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.
;---------------------------------------------------------------;
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
;---------------------------------------;
	include	setupequ.ext
	include	setupmsg.equ
	include	makeflag.equ
;---------------------------------------;
;---------------------------------------;
;;Core BIOS Externs
	extrn	_temp_buffer:byte
	extrn	_common_cmos_buffer:byte
	extrn	_old_cmos_buffer:byte
	extrn	get_cmos_reg_mask_x:near
	extrn	get_cmos_buffer_item:near
	extrn	set_cmos_buffer_item:near
	extrn	Get_Language_No:near

	extrn	Get_$_Ptr:near
;---------------------------------------;
;;Chipset BIOS Externs
	extrn	get_vendor_name:near
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
	public	_EXTFUNC_STARTS
_EXTFUNC_STARTS	label	byte		; marks start of module
;-----------------------------------------------------------------------;

;---------------------------------------------------------------------------;
;                Share memory size					    ;
;---------------------------------------------------------------------------;
SHARE_MEMORY_zlist label	byte
db 	STR_RESERVED,STR_2MB,STR_4MB,STR_8MB,STR_END
NA_zlist label	byte
;db 	STR_IT8661F_NA,STR_IT8661F_NA,STR_IT8661F_NA,STR_IT8661F_NA
db 	STR_WIN877_NA,STR_WIN877_NA,STR_WIN877_NA,STR_WIN877_NA

Share_memory	proc near
	mov	ax,cs
	cmp	ax,0f000h
	mov	ah,2
	mov	bx,offset cgroup:SHARE_MEMORY_zlist
	jnz	short setting_done
	mov	al,Q_SHARE_MEMORY
	call	get_cmos_buffer_item
	jnz	setting_done
	mov	ah,3
	mov	bx,offset cgroup:NA_zlist
setting_done:
	mov	dx,cs
	retf
Share_memory	endp
if (MKF_CUSTOMER eq 7788)
;;---------------------------------------------------------------------------;
;;                Share memory size					    ;
;;---------------------------------------------------------------------------;
DISABLE_ENABLE_zlist label	byte
db 	STR_DISABLE,STR_ENABLE
VGA_WRITE_CYCLE	proc near
	mov	al,Q_SHARE_MEMORY
	call	get_cmos_buffer_item
	mov	ah,2			;default is Normal
	jnz	short @f

	mov	ax,Q_VGA_READ_CYCLE
	call	set_cmos_buffer_item

	mov	ax,Q_VGA_WRITE_CYCLE
	call	set_cmos_buffer_item

	mov	ah,3
@@:
	mov	bx,offset cgroup:DISABLE_ENABLE_zlist
	mov	dx,cs
	retf
VGA_WRITE_CYCLE	endp
endif
COMMENT ~
;---------------------------------------------------------------------------;
;                Single_read						    ;
;---------------------------------------------------------------------------;
SINGLE_READ_zlist label	byte
db 	STR_DISABLED,STR_ENABLED,str_end

Single_read	proc near
 	call	get_vendor_name
	cmp	bl,01
	mov	ah,2			;default is Normal
	jne	@f
	mov	al,Q_SINGLE_READ
	xor	ah,ah
	call	set_cmos_buffer_item
	mov	ah,3
@@:
	mov	bx,offset cgroup:SINGLE_READ_zlist
	mov	dx,cs
	retf
Single_read	endp
~

everyday db	"Every Day",0
;-----------------------------------------------------------------------;
rtc_resmue_date_ef	proc near
	mov	ah,Q_RESUME_BY_RTC_DATE
	mov	bx,1f00h		; BH=High Limit/BL=Low limit
	call	show_decimal
	retf
rtc_resmue_date_ef	endp
rtc_resmue_hour_ef	proc near
	mov	ah,Q_RESUME_BY_RTC_HOUR
	mov	bx,1700h		; BH=High Limit/BL=Low limit
	call	show_decimal
	retf
rtc_resmue_hour_ef	endp
rtc_resmue_minute_ef	proc near
	mov	ah,Q_RESUME_BY_RTC_MINUTE
	mov	bx,3B00h		; BH=High Limit/BL=Low limit
	call	show_decimal
	retf
rtc_resmue_minute_ef	endp
rtc_resmue_second_ef	proc near
	mov	ah,Q_RESUME_BY_RTC_SECOND
	mov	bx,3B00h		; BH=High Limit/BL=Low limit
	call	show_decimal
	retf
rtc_resmue_second_ef	endp
        public  show_decimal
show_decimal    proc    near
	push	es
	push	ds
	pop	es

	call	clear_temp_buffer

	xchg	al,ah			; AH=+/-1 AL=Question
	push	ax
	call	get_cmos_buffer_item
	pop	dx
	add	al,dh

	cmp	al,bl
	jae	@f
	mov	al,bh
@@:	cmp	al,bh
	jbe	@f
	mov	al,bl
	or	dh,dh
	jns	@f
	mov	al,bh
@@:
	mov	dh,al

	mov	ax,dx
        call    set_cmos_buffer_item
	mov	bx,offset _temp_buffer
	cmp	ax,Q_RESUME_BY_RTC_DATE
	jnz	everyday_done
	mov	si,offset cgroup:everyday
	mov	cx,5
	mov	di,bx
	db	02eh
	rep	movsw
	jmp	short skip_number

everyday_done:
	xchg	al,ah
	aam
	or	ax,3030h
	xchg	al,ah
	mov	ds:[bx],ax
skip_number:
	mov	al,Q_RESUME_BY_RTC
	call	get_cmos_buffer_item
	xor	al,01
	mov	ah,al
	mov	dx,ds
	pop	es
        ret
show_decimal    endp

clear_temp_buffer	proc	near
	push	ax
	mov	cx,05
	xor	ax,ax
	mov	di,offset _temp_buffer
	rep	stosw
	pop	ax
	ret
clear_temp_buffer	endp

conv_ax  proc    near
        mov     cx,10
lop5:   xor     dx,dx
        div     cx
        or      ax,ax
        jz      lab5
        push    dx
        call    lop5
        pop     dx
lab5:   mov	al,dl
	add	al,30h
	stosb
        ret
conv_ax  endp

sys_temp_proc	proc 	far
	push	es
	push	ds
	pop	es
	call	clear_temp_buffer
	mov	ax,27h
	call	read_lm78_reg
	jnz	lm78_absent
	mov	di,offset _temp_buffer
	mov	bx,di
; Jeff, Wed 09-30-1998 >>>
	test	al,80h		;temp(C)=(reading*140+8792)/168.7
	pushf
	jz	positive_value1
	neg	al
positive_value1:
	mov	ah,140
	mul	ah
	mov	cx,8792
	popf
	jz	positive_value2
	sub	cx,ax
	mov	ax,cx
	jmp	process_div
positive_value2:
	add	ax,cx
process_div:
	mov	cx,10
	mul	cx
	mov	cx,1687
	div	cx
; Jeff, Wed 09-30-1998 <<<
	push	ax
	call	conv_ax
	mov	eax,2f43f8h
	stosd
	dec	di
	pop	ax
	mov	ah,9
	mul	ah
	xor	dx,dx
	mov	cx,5
	div	cx
	add	ax,32
	call	conv_ax
	mov	ax,046f8h
	stosw
lm78_absent:
	mov	ah,1
	mov	dx,ds
	pop	es
	retf
sys_temp_proc	endp

cpu_fan_proc	proc 	far
	mov	ax,0228h
	call	common_fan
	retf
cpu_fan_proc	endp

sys_fan_proc	proc 	far
	mov	ax,0229h
	call	common_fan
	retf
sys_fan_proc	endp

common_fan	proc	near
	push	es
	push	ds
	pop	es
	call	clear_temp_buffer
	call	read_lm78_reg
	jnz	fan_lm78_absent
        mul     ah
        mov     bx,ax
        cmp     ax, 254*2                               ; Check if FAN take out!
        mov     ax,0
        jae     short no_cpu_fan
;	or	bx,bx
;	jz	short no_cpu_fan
	cmp	bx,15h
	jb	short no_cpu_fan
        mov     dx,14h
        mov     ax,9970h
        div     bx
no_cpu_fan:
	mov	di,offset _temp_buffer
	mov	bx,di
	call	conv_ax
	mov	eax,'MPR '
	stosd
fan_lm78_absent:
	mov	ah,1
	mov	dx,ds
	pop	es
	ret
common_fan	endp

in0_proc	proc 	far
	mov	al,020h
	mov	bx,595
	call	common_in
	retf
in0_proc	endp

in1_proc	proc 	far
	mov	al,021h
	mov	bx,1000
	call	common_in
	retf
in1_proc	endp

in2_proc	proc 	far
	mov	al,022h
	mov	bx,1000
	call	common_in
	retf
in2_proc	endp

in3_proc	proc 	far
	mov	al,023h
	mov	bx,1000
	call	common_in
	retf
in3_proc	endp

common_in	proc	near
	push	es
	push	ds
	pop	es
	call	clear_temp_buffer
	mov	ah,al
	push	bx
        call    read_lm78_reg
	pop	bx
	jnz	in_lm78_absent
	mov	di,offset _temp_buffer
	cmp	ah,25h
	jb	@f
	push	ax
	mov	al,'-'
	stosb
	pop	ax
@@:
        mov     ah,10h
        mul     ah
        xor     dx,dx
        div     bx
	push	dx
	call	conv_ax
        mov     al,'.'
	stosb
        pop     ax
	xor	dx,dx
	mov	si,1000
        mul     si
        div     bx
        mov     dx,ax
        cmp     ax,100
        ja      @f
        mov     al,'0'
	stosb
        cmp     dx,10
        ja      @f
	stosb
@@:
        mov     ax,dx
	call	conv_ax
	mov	ax,'V '
	stosw
in_lm78_absent:
	mov	bx,offset _temp_buffer
	mov	ah,1
	mov	dx,ds
	pop	es
	ret
common_in	endp

read_lm78_reg	proc	near
	push	dx
	mov	dx,cs
	cmp	dx,0f000h
	jnz	not_in_bios
	mov	dx,295h
	out	dx,al
	mov	ch,80h
	loop	$
	inc	dx
	in	al,dx
	mov	ch,80h
	loop	$
	cmp	al,al
not_in_bios:
	mov	bx,offset _temp_buffer
	pop	dx
	ret
read_lm78_reg	endp

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
;-----------------------------------------------------------------------;
if (MKF_EVENT_LOG)			; (CORE0218+)>
	include eventfun.inc
endif					; <(CORE0218+)

	public	_EXTFUNC_ENDS
_EXTFUNC_ENDS	label	byte			; marks end of module
;---------------------------------------;
_text	ends
	end
