	page	,132
	title	TURBO SWITCH HANDLER THROUGH KBC PIN
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
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
;	TURBO_SWITCH FROM INT-8		;
;---------------------------------------;
; input	status		status		;
; pin#	0=High speed	1=High speed	;
; 27	01		81		;
; 28	02		82		;
; 29	04		84		;
; 30	08		88		;
; 31	10		90		;
; 33	40		C0		;
;---------------------------------------;
; pin-23/24 can not be used as turbo	;
; switch input pin selection. because	;
; during GA20 on/off, if turbo switch	;
; is pressed, these pins may become	;
; 0 and will remain 0, can never be	;
; made 1.				;
; however pin-23,24 can be used as	;
; output pin.				;
;---------------------------------------;
; if bit-7 = 1 then			;
;	if pin-x = 1 then high speed	;
;			else low speed	;
; otherwise				;
;	if pin-x = 1 then low speed	;
;			else high speed	;
;---------------------------------------;
; pin-32 (DIAG PIN) can not be used	;
; pin-34 (KB-LOCK PIN) can not be used	;
;---------------------------------------;
	extrn	_led_on_8042:byte
	extrn	ob_full_read:near
	extrn	read_interrupt_level:near
	extrn	frequency_low:near
	extrn	frequency_high:near
	extrn	turbo_switch_end:near
	public	turbo_switch
turbo_switch:
	push	ax
	push	cx
	push	dx
	mov	ah,cgroup:_led_on_8042
	or	ah,ah
	jz	ts_3			; no turbo switch selected
	mov	al,ds:[16h]
	test	al,40h			; if bit-6 = 1 then func is active
	jz	ts_3
	and	al,3			; sample every 4 timer tick
	cmp	al,3
	jnz	ts_2			; sample time
	mov	dx,20h
	call	read_interrupt_level
	test	al,00000010b
	jnz	ts_3			; from INT-9, exit
	mov	dl,0a0h
	call	read_interrupt_level
	test	al,00010000b
	jnz	ts_3			; from INT-74, exit
	in	al,64h
	test	al,03h
	jnz	ts_3			; ib/ob full, exit
	mov	al,0cbh			; mov	al,0afh (AF is now a valid command)
	call	ibfree_64
	jnz	ts_33			; jnz	ts_3 ; o/b full, exit
	cli				; 03/24/94
	in	al,21h			; 03/24/94
	jcxz	$+2			; 03/24/94
	mov	dh,al			; save [port21h] ; 03/24/94
	or	al,02h			; disable IRQ1 ; 03/24/94
	out	21h,al			; 03/24/94
	mov	al,0c0h			; read input port
	call	ibfree_64
	call	ob_full_read
	and	al,ah
	and	al,01111111b
	mov	al,ds:[16h]
	jz	ts_6			; switch bit = 0
	xor	ax,8080h
ts_6:
	test	al,10000000b
	jz	ts_7			; no change, exit
	mov	al,20h			; read 8042 command byte
	call	ibfree_64
	call	ob_full_read
	push	ax
	mov	dl,al
	mov	al,60h			; write 8042 command byte
	call	ibfree_64
	mov	al,dl
	or	al,00110000b		; disable keyboard, mouse
	call	ibfree_60
	or	ah,ah
	js	ts_8
	call	frequency_high		; goto high speed
	jmp	short ts_9
ts_33:
	mov	al,0ffh
	call	ibfree_64
	jmp	short ts_3
ts_2:
	inc	ds:byte ptr [16h]
ts_3:
	pop	dx
	pop	cx
	pop	ax
	jmp	turbo_switch_end
;---------------------------------------;
ts_8:
	call	frequency_low		; goto low speed
ts_9:
	mov	al,60h			; restore command byte
	call	ibfree_64
	pop	ax
	call	ibfree_60
	xor	ds:byte ptr [16h],10000000b
ts_7:
	and	ds:byte ptr [16h],11111100b
	mov	al,dh			; restore [port21h] ; 03/24/94
	out	21h,al			; 03/24/94
	jmp	short ts_3
;---------------------------------------;
ibfree_64:
	out	64h,al
	jmp	short ibfree
ibfree_60:
	out	60h,al
ibfree:
	jcxz	short $+2
	in	al,64h
	test	al,1
	jnz	ibfree_2
	test	al,2
	jnz	ibfree
ibfree_2:
	ret
;---------------------------------------;
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
_text	ends
end
