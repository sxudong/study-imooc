;; LM78 Read/Write subrouting

;; Read_LM78_Reg
;; Input:
;; 	AL= Index Register
;; Output:
;; 	AL= Value
	public	read_lm78_reg
read_lm78_reg:
	push	cx
	push	dx
	mov	dx,295h
	out	dx,al
	mov	cx,8000h
	loop	$
	inc	dx
	in	al,dx
	mov	ch,80h
	loop	$
	pop	dx
	pop	cx
	ret

;; Write_LM78_Reg
;; Input:
;; 	AL= Index Register
;; 	AH= Write to Register Value
;; Output:
;; 	None
	public	write_lm78_reg
write_lm78_reg:
	push	cx
	push	dx
	mov	dx,295h
	out	dx,al
	mov	cx,8000h
	loop	$
	inc	dx
	xchg	al,ah
	out	dx,al
	mov	ch,80h
	loop	$
	xchg	al,ah
	pop	dx
	pop	cx
	ret

