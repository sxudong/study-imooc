	page	,132
	title	KB AND PS2 MOUSE CONNECTOR SWAP
;---------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1996, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F Northbelt Parkway, Norcross,		**;
;**								**;
;**	Georgia - 30071, USA. Phone-(770)-246-8600.		**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;---------------------------------------;
cgroup	group	_text
_text	segment	word	public	'CODE'
	assume	cs:cgroup
.486p
;---------------------------------------;
;-----------------------------------------------------------------------;
;		Auto detection of KB/MS using AMI KB-5			;
; This code will allow the connector swap of Keyboard and PS2 Mouse i.e.;
; keyboard can be connected to PS2 Mouse connector and vice-versa.	;
; ====================== NOTE ==== NOTE ==== NOTE =====================	;
; This code should be used only if the motherboard has AMI KB-5 which is;
; also available in IO chipsets having KBC e.g. SMC932, etc.		;
;-----------------------------------------------------------------------;
; Input:								;
;	AMI KB-5 present in the system.					;
;	Keyboard controller BAT complete.				;
;	Stack available.						;
; Output:								;
;    KBC will be configured accordingly					;
; Register Destroyed : None						;
;-----------------------------------------------------------------------;
; NOTE: If you do not have stack:					;
; 1. assume AX, BX, CX can be destroyed.				;
; 2. assume CPU already in CLI mode.					;
; 2. replace all "CALL" with "RET_SP".					;
; 3. remove all PUSH and POP, except replace PUSH CX and POP CX at the	;
;    middle of this routine with MOV BX,CX and MOV CX,BX respectively.	;
;-----------------------------------------------------------------------;
	extrn	ib_free:near
	extrn	ob_full_read:near
	extrn	ob_full_read_timeout:near
	public	auto_detect_kb_ms
auto_detect_kb_ms:
	push	ax
	push	cx
	pushf
	cli
	call	ib_free
	mov	al,60h		; lock KBC
	out	64h,al
	call	ib_free
	in	al,60h		; discard any data
	mov	al,20h		; read command byte
	out	64h,al
	call	ob_full_read
	mov	ah,al		; save command byte
;-------------------------------;
; read KBC version number	;
;-------------------------------;
	mov	al,60h		; write command byte
	out	64h,al
	call	ib_free
	mov	al,74h		; command byte data
	out	60h,al
	call	ib_free
	in	al,60h
	mov	al,0a1h
	out	64h,al
	call	ob_full_read_timeout
	jz	ad_7
	cmp	al,35h		; ver '5' ?
	jnz	ad_7
;-------------------------------;
	mov	al,60h		; write command byte
	out	64h,al
	call	ib_free
;;;;	mov	al,44h		; command byte data..BUG 01/21/97
	mov	al,04h		; command byte data
	out	60h,al
	call	ib_free
;-------------------------------;
; clear KBC data buffer		;
;-------------------------------;
	mov	cx,6		; read 6 bytes maximum
ad_4:
	push	cx
	xor	cx,cx		; timeout
ad_2:
	in	al,64h
	test	al,1
	loopz	ad_2
	pop	cx
	jz	ad_3
	in	al,60h		; discard data
	loop	ad_4
ad_3:
	mov	al,0a7h		; disable MS
	out	64h,al
	call	ib_free
	mov	al,0c8h		; select primary
	out	64h,al
	call	ib_free
;-------------------------------;
; check primary port		;
;-------------------------------;
	mov	al,0f2h		; read ID command
	out	60h,al
	call	ob_full_read
	cmp	al,0f2h
	jz	ad_5		; primary=MS
	cmp	al,0fah
	jnz	ad_6
	call	ob_full_read
	or	al,al
	jz	ad_5		; primary=MS
	call	ob_full_read
ad_6:
	in	al,64h
	test	al,40h
	jz	ad_7		; primary=KB
;-------------------------------;
; check secondary port		;
;-------------------------------;
	mov	al,0d4h
	out	64h,al
	call	ib_free
	mov	al,0f2h		; read ID command
	out	60h,al
	call	ob_full_read
	cmp	al,0f2h
	jz	ad_7		; secondary=MS
	cmp	al,0fah
	jnz	ad_8
	call	ob_full_read
	or	al,al
	jz	ad_7		; secondary=MS
	call	ob_full_read
ad_8:
	in	al,64h
	test	al,40h
	jnz	ad_7		; secondary=NONE
;-------------------------------;
; swap port			;
;-------------------------------;
ad_5:
	mov	al,0c9h		; swap port
	out	64h,al
	call	ib_free
ad_7:
	mov	al,60h		; write command byte
	out	64h,al
	call	ib_free
	mov	al,ah		; restore command byte
	out	60h,al
	call	ib_free
	popf
	pop	cx
	pop	ax
	ret
;-------------------------------;
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
