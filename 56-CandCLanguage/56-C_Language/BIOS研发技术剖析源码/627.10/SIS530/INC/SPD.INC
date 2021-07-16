;------------------------------------------------------------------------------;
; Input : AH = index (command code)
; 	  CL = Row number (0 Base)
; Destroyed : AX,DX
	extrn	dimm_i2c_address:byte
read_i2c_data		proc	near
	mov	dx,MKF_SMB_BASE_ADDRESS	;base address
clear_all_status:
	mov	al,1eh
	out	dx,al			;Reset Host Status Registers
	jmp	short $+2
	jmp	short $+2
	in	al,dx
	test	al,1eh
	jnz	clear_all_status

	test	al,00000001b		;busy?
	jnz	read_spd_done 

	or	dl,SMB_HST_CMD		;base + 03h
	mov	al,ah			;AL = AH = index to read
	out	dx,al			;Program the index
	jmp	short $+2

	mov	ax,di
	mov	dl,ch
	mov	di,offset cgroup:dimm_i2c_address
	sub	ch,ch
	add	di,cx
	mov	ch,dl
	db	02eh			; CS:
	mov	dl,[di]
	mov	di,ax
	mov	al,dl
	mov	dx,MKF_SMB_BASE_ADDRESS+SMB_HST_ADD;base + 04h
	out	dx,al			;Program the Address
	jmp	short $+2

	mov	dx,MKF_SMB_BASE_ADDRESS+SMB_HST_CNT;base + 02h
	mov	al,48h			;Start the read/write command
	out	dx,al
	jmp	short $+2

	sub	ah,ah

	and	dl,0f0h			;base + 00h
check_host_status:
	in	al,dx
	jmp	short $+2

	test	al,00000100b		;error?
	jnz	access_i2c_device_error	;ZF = 0 for fail

	dec	ah
	jz	timeout

	test	al,00000001b		;busy?
	jnz	check_host_status

	test	al,00000010b		;interrupt?
	jz	check_host_status

	or	dl,SMB_HST_DAT_0
	in	al,dx

	cmp	al,0ffh			; Bad data
	jz	timeout

	cmp	al,al			;ZF = 1 for success
access_i2c_device_error:
	mov	ah,al
	mov	al,1eh
	mov	dx,MKF_SMB_BASE_ADDRESS	;base + 00h
	out	dx,al			;Reset Host Status Registers
	mov	al,ah

read_spd_done:
	jmp	di
timeout:
	or	al,0ffh			; Reset ZF
	jmp	di

read_i2c_data		endp
