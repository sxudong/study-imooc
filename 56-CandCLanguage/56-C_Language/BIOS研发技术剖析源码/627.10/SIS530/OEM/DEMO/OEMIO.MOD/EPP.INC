;;	page	,132
;;	title	EPP support routines
.386
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1995, American Megatrends Inc.	**;
;**								**;
;**			All Rights Reserved.			**;
;**								**;
;**		6145-F, Northbelt Parkway, Norcross,		**;
;**								**;
;**		Georgia - 30071, USA. Phone-(770)-263-8181.	**;
;**								**;
;*****************************************************************;
;*****************************************************************;
;---------------------------------------;
;	IO_DELAY MACRO			;
;---------------------------------------;
io_delay	macro
	jcxz	short $+2
	jcxz	short $+2
endm

parallel_time_max	equ	78h

;---------------------------------------;
; Error code:

epp_Successful		equ	00h
epp_io_timeout		equ	01h
epp_cmd_not_supported	equ	02h
epp_mux_locked		equ	10h
epp_mux_not_present	equ	20h
;---------------------------------------;

version_string	db	'American Megatrends, Inc. EPP BIOS 00.32',0
version_id	db	03h		; version 0.3

epp_call_table	label	word
	dw	offset cgroup:epp_00	; Query Config
	dw	offset cgroup:epp_01	; Set Mode
	dw	offset cgroup:epp_02	; Get Mode
	dw	offset cgroup:epp_03	; Interrupt Control
	dw	offset cgroup:epp_04	; EPP Reset
	dw	offset cgroup:epp_05	; Address Write
	dw	offset cgroup:epp_06	; Address Read
	dw	offset cgroup:epp_07	; Write Byte
	dw	offset cgroup:epp_08	; Write Block
	dw	offset cgroup:epp_09	; Read Byte
	dw	offset cgroup:epp_0A	; Read Block
	dw	offset cgroup:epp_0B	; Address/Byte Read
	dw	offset cgroup:epp_0C	; Address/Byte Write
	dw	offset cgroup:epp_0D	; Address/Block Read
	dw	offset cgroup:epp_0E	; Address/Block Write
	dw	offset cgroup:epp_0F	; Lock Port
	dw	offset cgroup:epp_10	; Unlock Port
	dw	offset cgroup:epp_11	; Device Interrupt
	dw	offset cgroup:epp_12	; Real Time Mode
;---------------------------------------;

;-----------------------------------------------------------------------
; int_17_epp	Installation Check
;
;		Installation Check is used to test for the present of
;		an EPP port. This call returns a far pointer to the
;		EPP BIOS entry point - the EPP Vector.
;-----------------------------------------------------------------------
;
; Input:	Int 17
;		AH = 2
;		AL = 0
;		CH = 45 ('E')
;		BH = 50 ('P')
;		BL = 50 ('P')
;		DX = LPT port number (0-2)
;
; Output:	AH = 0
;		If EPP present
;			AL = 45 ('E')
;			CL = 50 ('P')
;			CH = 50 ('P')
;		DX:BX = EPP BIOS entry point - EPP Vector
;
; Register Usage: AX, BX, CX, DX
;
; Note: This added for EPP support hook in INT-17, MUST BE HOOKED
;	INTO PM.INC (set_int17_flag).
;
;-----------------------------------------------------------------------
;	public	int_17_epp
int_17_epp	proc	near	private
	cmp	ax,0200h		; check if function 2, subfunction 0
	jne	int_17_epp_exit		; no, continue with INT 17h
	cmp	ch,45h			; CH = 'E' ?
	jne	int_17_epp_exit		; no, continue with INT 17h
	cmp	bx,5050h		; BX = 'PP' ?
	jne	int_17_epp_exit		; no, continue with INT 17h
	call	get_io_lpt_port_addr	; DX = I/O LPT port address
	or	dx,dx
	jz	int_17_epp_exit		; LPT address = 0, continue with INT 17h
	cmp	dx,3bch
	je	int_17_epp_exit		; can not run EPP at 3BC
;	mov	al,4			; set I/O LPT port to EPP mode
;	call	set_io_lpt_port_mode
	mov	ax,0045h		; AH = 0, AL = 'E'
	mov	cx,5050h		; 'PP'
	mov	dx,cs
	mov	bx,offset epp_vector	; DX:BX = EPP Vector
int_17_epp_exit:
	jmp	dword ptr cgroup:[OldInt17Vector]
;	ret
int_17_epp	endp

;-----------------------------------------------------------------------
; epp_vector	This procedure serves as the Application Program
;		Interface, API, for all underlying EPP services.
;		All EPP BIOS calls are executed by making a far
;		call to this procedure.
;
; NOTE: Upon entry DL holds LPT port number (0-2) which is used
;	to get the LPT port address from BIOS data area and saved
;	in DX early in this routine before the actual function is
;	called.
;-----------------------------------------------------------------------
epp_vector	proc	far	private
	pushf				; always save flags
	push	dx
	
; Check for valid API function
;	cmp	ah,0eh				; max. func limit
;	ja	epp_no_cmd
	
	cmp	ah,12h				; max. func limit
	ja	epp_no_mux
	
	or	ah,ah
	jnz	ev_func_not0
	call	epp_00
	jmp	short epp_vector_exit

ev_func_not0:
	push	bx
	push	ax
	mov	al,ah				; save API function #
	xor	ah,ah
	mov	bx,ax				; prepare index into call table
	shl	bx,1
	pop	ax
	cmp	ah,0ch				; Address/Byte write call
	jz	epp_vector_call
	
	call	get_io_lpt_port_addr		; DX = LPT address from hardware

epp_vector_call:
	call	cgroup:epp_call_table[bx]	; call each function
	pop	bx
	
epp_vector_exit:
	pop	dx
	popf
	retf
	
epp_no_mux:
	mov	ah,epp_mux_not_present
	jmp	short epp_vector_exit
	
epp_no_cmd:
	mov	ah,epp_cmd_not_supported
	jmp	short epp_vector_exit
	
epp_vector	endp

;-----------------------------------------------------------------------
; epp_00	Query Config
;
;		Returns the EPP port's configuration.
;-----------------------------------------------------------------------
;
; Input:	AH = 0
;		DX = LPT I/O port base address
;
; Output:	AH = error code
;		AL = Interrupt level of EPP port (0-15)
;		   = FF if interrupts not supported
;		BH = EPP BIOS version (MMMMnnnn or M.n)
;					i.e: 10 for version 1.0
;		BL = I/O Capabilities
;			bit 0 = Multiplexor present
;			bit 1 = PS/2 bi-directional capable
;			bit 2 = Daisy chain present
;			bit 3 = ECP capable
;		CX = SPP I/O Base Address
;		ES:DI = EPP BIOS manufacturer's version string (zero terminated)
;
; Register Usage: AX, BX, CX, DI, ES
;
; Note:	Fast Centronics uses the EPP Block Write call to send data to a
;	standard Centronics printer. The Set Mode command is used to
;	enable this I/O mode.
;
;-----------------------------------------------------------------------
epp_00	proc	near	private
	call	get_io_lpt_port_addr	; DX = LPT address from hardware
	mov	cx,dx			; CX = LPT port base address
	call	get_io_lpt_port_info	; routine in EPPIO.INC
					; return: AL interrupt level
					;	     = FF if interrupts not support
					;	  BL.0 Multiplexor present
					;	  BL.1 PS/2 bi-directional capable
					;	  BL.2 Daisy chain present
					;	  BL.3 ECP capable
	xor	ah,ah			; no error
	mov	bh,cgroup:version_id
	push	cs
	pop	es
	mov	di,offset cgroup:version_string
	ret
epp_00	endp

;-----------------------------------------------------------------------
; epp_01	Set Mode
;
;		Set the operating mode for the EPP port.
;-----------------------------------------------------------------------
;
; Input:	AH = 01
;		AL = mode bits
;			0 - compatibility mode
;			1 - Bi-directional mode
;			2 - EPP mode
;			3 - ECP mode
;			4 - EPP software emulation
;		DX = LPT I/O port base address
;
; Output:	AH = error code
;
; Register Usage: AX, BX
;
;-----------------------------------------------------------------------
epp_01	proc	near	private
	call	set_io_lpt_port_mode	; routine in EPPIO.INC
	ret
epp_01	endp

;-----------------------------------------------------------------------
; epp_02	Get Mode
;
;		Returns the current operating mode of the EPP port.
;-----------------------------------------------------------------------
;
; Input:	AH = 02
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;		AL = current mode (bits)
;			0 - compatibility mode
;			1 - Bi-directional mode
;			2 - Epp mode
;			3 - ECP mode
;			4 - EPP software emulation
;			7 - EPP port interrupts enabled
;
; Register Usage: AX, BX
;
;-----------------------------------------------------------------------
epp_02	proc	near	private
	call	get_io_lpt_port_mode	; routine in EPPIO.INC
	ret
epp_02	endp

;-----------------------------------------------------------------------
; epp_03	Interrupt Control
;
;		Interrupt control is used to enable or disable the
;		interrupt associated with the EPP port. When interrupts
;		are enabled/disabled both the port and the interrupt
;		controller (interrupt mask) are enabled/disabled.
;-----------------------------------------------------------------------
;
; Input:	AH = 03
;		AL = 0	to disable EPP port interrupts
;		   = 1	to enable EPP port interrupts
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;
; Register Usage: AH
;
;-----------------------------------------------------------------------
epp_03	proc	near	private
	cli
	push	ax
	add	dx,2		; LPT port control
	xchg	ah,al		; save AL
	in	al,dx		; read/modify/write control port
	io_delay
	shl	ah,4		; position to bit 4 (interrupt enable)
	and	al,11101111b
	or	al,ah
	out	dx,al
	pop	ax
	xor	ah,ah		; no error code
	sti
	ret
epp_03	endp

;-----------------------------------------------------------------------
; epp_04	EPP Reset
;
;		EPP Reset is used to reset the peripheral device
;		connected to the EPP port. This is performed by
;		asserting the INIT line on the parallel port.
;-----------------------------------------------------------------------
;
; Input:	AH = 04
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;
; Register Usage: AH
;
;-----------------------------------------------------------------------
extrn	fixed_delay:near

epp_04	proc	near	private
	cli
	push	ax
	add	dx,2		; LPT port control
	in	al,dx		; read/modify/write control port
	io_delay
	and	al,11111011b	; send INIT signal to LPT port
	out	dx,al
	push	cx
	mov	cx,5		; 5*15us = 75us delay
	call	fixed_delay
	pop	cx
	or	al,00000100b	; reset INIT signal
	out	dx,al
	pop	ax
	xor	ah,ah		; no error code
	sti
	ret
epp_04	endp

;-----------------------------------------------------------------------
; epp_05	Address Write
;
;		Address Write is used to perform an address-write/
;		device-select I/O cycle.
;-----------------------------------------------------------------------
;
; Input:	AH = 05
;		AL = device address
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;
; Register Usage: AH
;
;-----------------------------------------------------------------------
epp_05	proc	near	private
;	call	lpt_write_enable
	push	dx
	add	dx,3		; address port
	out	dx,al		; send device address to address port
	io_delay
	pop	dx
	xor	ah,ah		; no error code
	ret
epp_05	endp

;-----------------------------------------------------------------------
; epp_06	Address Read
;
;		Address Read is used to perform an address read I/O
;		cycle.
;-----------------------------------------------------------------------
;
; Input:	Ah = 06
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;		Al = returned address/device data
;
; Register Usage: AH
;
;-----------------------------------------------------------------------
epp_06	proc	near	private
;	call	lpt_read_enable
	add	dx,3		; address port
	in	al,dx		; read device address from address port
	io_delay
	xor	ah,ah		; no error code
	ret
epp_06	endp

;-----------------------------------------------------------------------
; epp_07	Write Byte
;
;		Write Byte is used to output a single byte via the
;		EPP data port.
;-----------------------------------------------------------------------
;
; Input:	AH = 07
;		AL = data byte
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;
; Register Usage: AH
;
;-----------------------------------------------------------------------
epp_07	proc	near	private
;	call	lpt_write_enable
	add	dx,4		; LPT EPP data port
	out	dx,al		; write data byte
	io_delay
	xor	ah,ah		; no error code
	ret
epp_07	endp

;-----------------------------------------------------------------------
; epp_08	Write Block
;
;		Write Block is used to output the contents of a
;		client-defined buffer via the EPP data port. This 
;		can be used in Fast Centronics mode to perform block
;		I/O to Centronics printer.
;-----------------------------------------------------------------------
;
; Input:	AH = 08
;		CX = number of bytes to write (0=64K bytes)
;		DX = LPT I/O port base address
;		ES:SI = client buffer
;
; Output:	AH = Error code
;		CX = bytes remaining (=0 if no error)
;
; Register Usage: AH, CX, SI
;
;-----------------------------------------------------------------------
epp_08	proc	near	private
;	call	lpt_write_enable
	add	dx,4		; LPT EPP data port
	cld
rep	outs	dx,byte ptr es:[si]	; write data block
	xor	ah,ah		; no error code
	ret
epp_08	endp

;-----------------------------------------------------------------------
; epp_09	Read Byte
;
;		Read Byte is used to input a single byte via the
;		EPP data port.
;-----------------------------------------------------------------------
;
; Input:	AH = 09
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;		AL = data byte read
;
; Register Usage: AX
;
;-----------------------------------------------------------------------
epp_09	proc	near	private
;	call	lpt_read_enable
	add	dx,4		; LPT EPP data port
	in	al,dx		; read byte
	io_delay
	xor	ah,ah		; no error code
	ret
epp_09	endp

;-----------------------------------------------------------------------
; epp_0A	Read Block
;
;		Read Block is used to input a stream of bytes into
;		a client buffer via the EPP data port.
;-----------------------------------------------------------------------
;
; Input:	AH = 0A
;		CX = number of bytes to read (0=64K bytes)
;		DX = LPT I/O port base address
;		ES:DI = client buffer
;
; Output:	AH = Error code
;		CX = bytes not transferred (=0 if no error)
;
; Register Usage: AX, CX, DI
;
;-----------------------------------------------------------------------
epp_0A	proc	near	private
;	call	lpt_read_enable
	add	dx,4		; LPT EPP data port
	cld
	rep	insb		; read data block
	xor	ah,ah		; no error code
	ret
epp_0A	endp

;-----------------------------------------------------------------------
; epp_0B	Address/Byte Read
;
;		Address/Byte Read combines the Address Write and
;		Read Byte APIs into a single call.
;-----------------------------------------------------------------------
;
; Input:	AH = 0B
;		AL = device address
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;		AL = data byte read
;
; Register Usage: AX
;
;-----------------------------------------------------------------------
epp_0B	proc	near	private
	call	epp_05		; adrress write
;	io_delay
	call	epp_09		; read byte
	ret
epp_0B	endp

;-----------------------------------------------------------------------
; epp_0C	Address/Byte Write
;
;		Address/Byte Write combines the Address Write and
;		Write Byte APIs into a single call.
;-----------------------------------------------------------------------
;
; Input:	AH = 0C
;		AL = device address
;		DL = LPT port number (0-2)
;		DH = Data byte
;
; Output:	AH = Error code
;
; Register Usage: AH
;
;-----------------------------------------------------------------------
epp_0C	proc	near	private
	push	cx
	mov	cl,dh			; CL = data byte
	call	get_io_lpt_port_addr	; DX = LPT address from hardware
	call	epp_05		; address write
	push	ax
	mov	al,cl
;	io_delay
	call	epp_07		; write byte
	pop	ax
	xor	ah,ah
	pop	cx
	ret
epp_0C	endp

;-----------------------------------------------------------------------
; epp_0D	Address/Block Read
;
;		Address/Block Read combines the Address Write and
;		Read Block APIs into a single call.
;-----------------------------------------------------------------------
;
; Input:	AH = 0D
;		AL = device address
;		CX = number of bytes to read (0=64K bytes)
;		DX = LPT I/O port base address
;		ES:DI = client buffer
;
; Output:	AH = Error code
;		CX = bytes not tranferred (=0 if no error)
;
; Register Usage: AX, CX, DI
;
;-----------------------------------------------------------------------
epp_0D	proc	near	private
	call	epp_05		; address write
;	io_delay
	call	epp_0A		; read block
	ret
epp_0D	endp

;-----------------------------------------------------------------------
; epp_0E	Address/Block Write
;
;		Address/Block Write combines the Address Write and
;		Write Byte APIs into a single call.
;-----------------------------------------------------------------------
;
; Input:	AH = 0E
;		AL = device address
;		CX = number of bytes to write
;		DX = LPT I/O port base address
;		ES:SI = client buffer
;
; Output:	AH = Error code
;		CX = bytes not tranferred (=0 if no error)
;
; Register Usage: AH, CX, SI
;
;-----------------------------------------------------------------------
epp_0E	proc	near	private
	call	epp_05		; address write
;	io_delay
	call	epp_08		; write block
	ret
epp_0E	endp

;-----------------------------------------------------------------------
; epp_0F	Lock Port
;		Lock Port is used to serialize I/O access to the I/O
;		port. If an EPP multiplexor is not present this call
;		will always succeed. If an EPP multiplexor is present
;		this call will fail if the port is currently locked.
;		Lock port is used to select a multiplexor device port.
;-----------------------------------------------------------------------
;
; Input:	AH = 0F
;		BL = multiplexor port
;			0 - if EPP multiplexor not present
;			otherwise:
;				bits 7-4 = Daisy Chain Port #
;				bits 3-0 = Mux Device Port #
;
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;
; Register Usage: AX, BX
;
;-----------------------------------------------------------------------
epp_0F	proc	near	private
;	call	lock_port		; routine in EPPIO.INC
	xor	ah,ah
	ret
epp_0F	endp

;-----------------------------------------------------------------------
; epp_10	Unlock Port
;
;		Unlock Port will release the EPP port resource for
;		use by other EPP device drivers.
;-----------------------------------------------------------------------
;
; Input:	AH = 10h
;		AL = multiplex port
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;
; Register Usage: AX, BX
;
; Note: A device driver MUST unlock the port after all EPP I/O
;	transactions have been performed.
;
;-----------------------------------------------------------------------
epp_10	proc	near	private
;	call	unlock_port		; routine in EPPIO.INC
	xor	ah,ah			; no error
	ret
epp_10	endp

;-----------------------------------------------------------------------
; epp_11	Device Interrupt
;
;		Device Interrupt allows an EPP device driver to install
;		an interrupt event handler, to be called whenever an
;		EPP device interrupt occurs. The handler is called with
;		interrupts diabled and should return via an FAR RETURN
;		instruction. While operating under device interrupt the
;		handler is not required to explicitly lock/unlock the
;		EPP BIOS.
;		Interrupts are handled in two styles: reentrant and
;		non-reentrant servicing. If reentrant servicing is
;		specified then the end-of-interrupt (EOI) is sent to
;		the interrupt controller before the user's event handler
;		is called. For non-reentrant servicing the EOI is sent
;		after the user's event handler returns (FAR) to the BIOS.
;-----------------------------------------------------------------------
;
; Input:	AH = 11h
;		AL = 0 - disable device interrupts
;		     1 - enable device interrupts
;		DX = LPT I/O port base address
;		ES:DI = far pointer to interrupt event handler
;
; Output:	AH = Error code
;
; Register Usage: AX, BX
;
; Note: If an EPP multiplexor is present it is the EPP Mux device driver
;	that dispatches the handler. The EPP Mux device driver will defer
;	calling the handler until the device port causing the interrupt
;	can be selected/locked.
;
;-----------------------------------------------------------------------
epp_11	proc	near	private
	push	cx
	mov	ch,al			; CH = interrupt cmd
	call	get_io_lpt_port_info	; routine in EPPIO.INC
					; return: AL = interrupt level
	mov	ah,epp_cmd_not_supported
	cmp	al,5			; LPT IRQ 5 ?
	je	epp_11_int_ok
	cmp	al,7			; LPT IRQ 7 ?
	jne	epp_11_exit		; error, exit
epp_11_int_ok:
	push	bx
	push	ds
	mov	cl,al			;CL = interrupt level
	movzx	bx,al			;BX = 5/7 for IRQ5/IRQ7
	add	bl,8			;For IRQ-5 = INT D, IRQ-7 = INT F
	shl	bx,2			;BX = LPT INT Vector offset
		    		    	;     (34h/3Ch for IRQ5/IRQ7)
	push	0
	pop	ds			;DS = 0 segment
	mov	ds:[bx],di		;Set interupt vector
	mov	ds:[bx+2],es
	pop	ds
	pop	bx
	and	ch,1			;keep bit 0 only
	shl	ch,cl
	cli
	in	al,21h			;read interrupt mask register
	cmp	cl,5
	jne	epp_11_irq7
	and	al,11011111b
	jmp	short epp_11_00
epp_11_irq7:
	and	al,01111111b
epp_11_00:
	or	al,ch			;disable/enable device interupt
	out	21h,al
	sti
	pop	cx
	xor	ah,ah
epp_11_exit:
	ret
epp_11	endp

;-----------------------------------------------------------------------
; epp_12	Real Time Mode
;
;		Real Time Mode is used to permit a device driver to
;		advertise whether it is supporting a peripheral device
;		with stringent interrupt latency requirements. Using
;		this call a device driver can also query if any real-time
;		devices are currently running on a device port. This
;		allows drivers to adjust the amount of I/O they perform
;		while the channel is locked: If a real-time device is
;		present then device drivers use a small I/O block size;
;		otherwise they may use a much larger block size,
;		maximizing the I/O cahnnel bandwidth.
;-----------------------------------------------------------------------
;
; Input:	AH = 12h
;		AL = 0 - query if any real time device present 
;		   = 1 - add (advertise) real-time device
;		   = 2 - remove real-time device
;		DX = LPT I/O port base address
;
; Output:	AH = Error code
;		If input AL = 0 then:
;			AL = 0 - if no real-time devices present
;			   = 1 - if one or more real-time devices present
;
; Register Usage: AX, BX
;
; Note:	Block devices that would normally hold the port locked for
;	extended periods while performing device I/O should query
;	(AL = 0) if any real-time devices are currently operating
;	after locking the port. If any real-time devices are present,
;	then the block driver should minimize the time the port is
;	locked, by unlocking the port whenever possible.
;
;-----------------------------------------------------------------------
epp_12	proc	near	private
;	call	real_time_mode
	xor	ah,ah		; set to no error for now
	ret
epp_12	endp
;-----------------------------------------------------------------------

include	eppio.inc
