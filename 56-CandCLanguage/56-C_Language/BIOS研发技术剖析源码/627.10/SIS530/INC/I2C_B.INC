	include makeflag.equ
;------------------------------------------------------------------------------;
;			READ_I2C_DATA_BYTE				       ;
;------------------------------------------------------------------------------;
; Input:    AH = Slave address						       ;
;	    AL = device register index (command code)			       ;
; Output:   ZF = 0 : fail						       ;
;	    ZF = 1 : success and CL = byte data read			       ;
; Modified: CL								       ;
;------------------------------------------------------------------------------;
	public	read_i2c_data_byte
read_i2c_data_byte		proc	near
;	pushf
	push	ax
	push	dx

	cli

	or	ah,01h			; Read Command
	call	reset_smbus_host
	jnz	read_i2c_byte_error

	mov	al,14h			;byte access
	call	access_i2c_device
	jnz	read_i2c_byte_error

	mov	ah,08h	      		;SMBus Data0 Register 
	call	read_smbus_reg
	mov	cl,al
	cmp	sp,sp			;ZF = 1 for success

read_i2c_byte_error:
	pop	dx
	pop	ax
;	popf
	ret
read_i2c_data_byte		endp
;------------------------------------------------------------------------------;
;			READ_I2C_DATA_WORD				       ;
;------------------------------------------------------------------------------;
; Input:    AH = Slave address						       ;
;	    AL = device register index (command code)			       ;
; Output:   ZF = 0 : fail						       ;
;	    ZF = 1 : success and CX = word data read			       ;
; Modified: CX								       ;
;------------------------------------------------------------------------------;
	public	read_i2c_data_word
read_i2c_data_word		proc	near
;	pushf
	push	ax
	push	dx

	cli

	or	ah,01h			; Read Command
	call	reset_smbus_host
	jnz	read_i2c_word_error

	mov	al,16h			;word access
	call	access_i2c_device
	jnz	read_i2c_word_error

	mov	ah,08h	      		;SMBus Data0 Register 
	call	read_smbus_reg
	mov	cl,al

	mov	ah,09h	      		;SMBus Data1 Register 
	call	read_smbus_reg
	mov	ch,al
	cmp	sp,sp			;ZF = 1 for success

read_i2c_word_error:
	pop	dx
	pop	ax
;	popf
	ret
read_i2c_data_word		endp
;------------------------------------------------------------------------------;
;			WRITE_I2C_DATA_BYTE				       ;
;------------------------------------------------------------------------------;
; Input:    AH = Slave address						       ;
;	    AL = device register index (command code)			       ;
;	    CL = byte data to write					       ;
; Output:   ZF = 0 : fail						       ;
;	    ZF = 1 : success						       ;
; Modified: nothing							       ;
;------------------------------------------------------------------------------;
	public	write_i2c_data_byte
write_i2c_data_byte		proc	near
;	pushf
	push	ax
	push	dx

	cli

	call	reset_smbus_host
	jnz	write_i2c_byte_error

	push	ax
	mov	al,cl
	mov	ah,08h			     ;SMBus Data0 Register 
	call	write_smbus_reg
	pop	ax

	mov	al,14h			;byte access
	call	access_i2c_device
;	jnz	write_i2c_byte_error

;	cmp	sp,sp			;ZF = 1 for success

write_i2c_byte_error:
	pop	dx
	pop	ax
;	popf
	ret
write_i2c_data_byte		endp
;------------------------------------------------------------------------------;
;			WRITE_I2C_DATA_WORD				       ;
;------------------------------------------------------------------------------;
; Input:    AH = Slave address						       ;
;	    AL = device register index (command code)			       ;
;	    CX = word data to write					       ;
; Output:   ZF = 0 : fail						       ;
;	    ZF = 1 : success 						       ;
; Modified: None							       ;
;------------------------------------------------------------------------------;
	public	write_i2c_data_word
write_i2c_data_word		proc	near
;	pushf
	push	ax
	push	dx

	cli

	call	reset_smbus_host
	jnz	write_i2c_word_error


	push	ax
	mov	al,cl
	mov	ah,08h			     ;SMBus Data0 Register 
	call	write_smbus_reg
	mov	al,ch
	mov	ah,09h			     ;SMBus Data1 Register  
	call	write_smbus_reg
	pop	ax

	mov	al,16h			;word access
	call	access_i2c_device
;	jnz	write_i2c_word_error

;	cmp	sp,sp			;ZF = 1 for success

write_i2c_word_error:
	pop	dx
	pop	ax
;	popf
	ret
write_i2c_data_word		endp
;------------------------------------------------------------------------------;
;				ACCESS_I2C_DEVICE			       ;
;------------------------------------------------------------------------------;
; Input:    AH = Slave address						       ;
;	    AL = 14h/16h for byte/word					       ;
; Output:   ZF = 0 : fail						       ;
;	    ZF = 1 : success						       ;
; Modified: None							       ;
;------------------------------------------------------------------------------;
access_i2c_device		proc	near

	xchg	al,ah
	push	ax
	mov	ah,04h				; SMBus Address Register
	call	write_smbus_reg
	pop	ax

	xchg	al,ah
	push	ax
	mov	ah,02h				; SMBus Control REgister 
	call	write_smbus_reg
	pop	ax

	push	ax
	push	cx
	xor	cx,cx

check_host_status:
	mov	ah,00h
	call	read_smbus_reg
	dec	cx
	jz	time_out

	test	al,00000100b		;busy?
	jnz	check_host_status	;ZF = 0 for fail

	test	al,00110000b		;error?
	jnz	access_i2c_device_error

	test	al,01000000b		; Completed?
	jz	check_host_status

	call	write_smbus_reg		;Reset Host Status Registers 

	cmp	sp,sp			;ZF = 1 for success
	
access_i2c_device_error:

	pop	cx
	pop	ax

	ret
time_out:
	or	al,0ffh
	jmp	short access_i2c_device_error
access_i2c_device		endp
;------------------------------------------------------------------------------;
;				RESET_SMBUS_HOST			       ;
;------------------------------------------------------------------------------;
; Input:    AL = command byte						       ;
; Output:   nothing							       ;
; Modified: nothing							       ;
;------------------------------------------------------------------------------;
reset_smbus_host		proc	near
	push	ax
	mov	ax,0107h			; Clear Status High Byte
	call	write_smbus_reg
	mov	ax,00f0h			; Clear Status Low Byte
	call	write_smbus_reg

	mov	ah,00h				; Check Host Master Idle?
	call	read_smbus_reg
	test	al,02h				 
	pop	ax
	jnz	reset_smbus_hont_done 

	push	ax
	mov	ah,05h				; SMBbus Command 
	call	write_smbus_reg
	pop	ax
	cmp	sp,sp
reset_smbus_hont_done:
	ret
reset_smbus_host		endp

read_smbus_reg proc near
;; Input:
;; AH = SMBus Register Index
;; Output:
;; AL = Read Value
;; Modified: None							       ;
	push	dx
	mov	dx,MKF_PM_BASE_ADDRESS+38h
	mov	al,ah
	out	dx,al
	jcxz	short $+2
	jcxz	short $+2
	inc	dx
	in	al,dx
	pop	dx
	ret
read_smbus_reg endp

write_smbus_reg proc near
;; Input:
;; AH = SMBus Register Index
;; AL = Write Value
;; Modified: None							       ;
	push	dx
	mov	dx,MKF_PM_BASE_ADDRESS+38h
	xchg	al,ah
	out	dx,al
	jcxz	short $+2
	jcxz	short $+2
	inc	dx
	xchg	al,ah
	out	dx,al
	pop	dx
	ret
write_smbus_reg endp


