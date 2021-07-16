;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;****************************************************************************;

;---------------------------------------;
	public ProcessKeyboardData
	public ProcessMouseData
	public EnableKBCTraps
	public Handle60Read
	public Handle64Read
	public Handle60Write
	public Handle64Write


	public	InitUSBKbDataArea
	public	PeriodicInterruptHandler
	public	OneSecondPeriodicHandler

	extrn	DisablePeriodicInterrupt:near
	extrn	EnablePeriodicInterrupt	:near
	extrn	write_kb_cntlr_data	:near
	extrn	USBDeviceRequest	:near
;---------------------------------------;
	include makeflag.equ
	include usb.equ
	if MKF_USB_UHCI
	include uhci.equ
	endif
	if MKF_USB_OHCI
	include ohci.equ
	endif
	include usbdata.dat

cgroup	group	_text
_text 	segment word public 'CODE'

	assume	cs:cgroup
	assume	ds:usbdgroup
	assume	es:usbdgroup
.386
;-------------------------------;
; Called to set keyboard traps	;
; Input:	nothing		;
; Destroys:	nothing		;
; Output:	(CL)		;
;  bit 0 set for 60 read trap	;
;  bit 1 set for 60 write trap	;
;  bit 2 set for 64 read trap	;
;  bit 3 set for 64 write trap	;
;-------------------------------;
EnableKBCTraps	proc	near
ifdef	DOS_DEBUG
	mov	cl,00h
else
;	push	ax
;	extrn	q_usb_6460_emulation:abs
;	mov	al,q_usb_6460_emulation
;	db	9ah			; CALL FAR F000:EED5
;	dw	0eed5h			; check_cmos_data
;	dw	0f000h
;	pop	ax
;	mov	cl,00h
;	jz	ekbt_1
;	mov	cl,0ah
;ekbt_1:
	mov	cl,00h
endif
	ret
EnableKBCTraps	endp

;---------------------------------------;
; ConnectDevice				;
;---------------------------------------;
; This function registers device id.	;
; Input:	DS = ES = HCD Data Area	;
; (al) = device id. (1/2/3/4/5/6/7/8)	;
; (ah) = device type			;
;	01h	HID Boot keyboard	;
;	02h	HID Boot mouse		;
; (dx) = interface number		;
;					;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
ConnectDevice	proc	near
ifdef	DOS_DEBUG
	ret
endif
	cmp	ah,BIOS_DEV_TYPE_KEYBOARD
	jne	@F
   	call	ConnectKeyboard
   	ret
@@:
	cmp	ah,BIOS_DEV_TYPE_MOUSE
	jne	@F
   	call	ConnectMouse
@@:
	ret
ConnectDevice	endp

;---------------------------------------;
; ConnectKeyboard			;
;---------------------------------------;
; This function registers keyboard.	;
; Input:	DS = ES = HCD Data Area	;
; (al) = device id. (1/2/3/4/5/6/7/8)	;
; (ah) = device type			;
; (dx) = interface number		;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
ConnectKeyboard	proc	near
ifdef	DOS_DEBUG
	ret
endif
	pusha
	mov	bl,al		; device id
	xor	bh,bh
	shl	bx,1
	mov	ah,dl		; interface number (dh=0)
	mov	[bx+device_list],ax
	mov	ah,00		; send to endpoint-0
	mov	bx,0a21h	; set-idle, request type = Interface

;;;;	mov	cx,0000h	; wValue, (ch)=0 (infinite wait), (255*4 milisec max)
;;;;	mov	cx,0200h	; wValue, (ch)=2*4 milisec = 8 milisec
	mov	cx,7d00h	; wValue, (ch)=125*4 milisec = 500 milisec

	mov	si,0000h	; wLength = 0
if	ALPS_KBD_0896
%Out For ALPS Keyboard Only.....Other compliant USB Devices May NOT work !!!!!
else
	call	USBDeviceRequest

;; Issue Remote Wakeup Freture (Legacy Mode)
	mov     bx,0300h	;request " set feature", request type
	mov     cx,1		;value
	sub	dx,dx
	call	USBDeviceRequest

;;; Issue Boot Protocol
;;	 BH = Request, BL = Request Type
;	mov	bx,0b21h	; "boot protocol", request type
;;        CX = wValue request parameter (meaning varies with each request type) ;
;;        DX = wIndex request parameter (meaning varies with each request type) ;
;;        SI = wLength request parameter, number of bytes of data to be         ;
;	mov     cx,0		; value
;	sub	dx,dx		; index
;	sub	si,si		; index
;	call	USBDeviceRequest
endif
	call	led_on
	popa
	ret
ConnectKeyboard	endp

;---------------------------------------;
; ConnectMouse				;
;---------------------------------------;
; This function registers mouse.	;
; Input:	DS = ES = HCD Data Area	;
; (al) = device id. (1/2/3/4/5/6/7/8)	;
; (ah) = device type			;
; (dx) = interface number		;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
ConnectMouse	proc	near
	pusha
;; Issue Remote Wakeup Freture (Legacy Mode)
	mov	ah,00		; send to endpoint-0
	mov     bx,0300h	;request " set feature", request type
	mov     cx,1		;value
	sub	dx,dx
	mov	si,0000h	; wLength = 0
	call	USBDeviceRequest
	popa
	ret
ConnectMouse	endp

;---------------------------------------;
; DisconnectDevice			;
;---------------------------------------;
; This function removes device id.	;
; Input:	DS = ES = HCD Data Area	;
; (al) = device id. (1/2/3/4/5/6/7/8)	;
; (ah) = device type			;
;	01h	HID Boot keyboard	;
;	02h	HID Boot mouse		;
;					;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
DisconnectDevice	proc	near
ifdef	DOS_DEBUG
	ret
endif
	cmp	ah,BIOS_DEV_TYPE_KEYBOARD
	jne	@F
   	call	DisconnectKeyboard
   	ret
@@:
	cmp	ah,BIOS_DEV_TYPE_MOUSE
	jne	@F
   	call	DisconnectMouse
@@:
	ret
DisconnectDevice	endp

;---------------------------------------;
; DisconnectKeyboard			;
;---------------------------------------;
; This function removes a keyboard.	;
; Input:	DS = ES = HCD Data Area	;
; (al) = device id. (1/2/3/4/5/6/7/8)	;
;					;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
DisconnectKeyboard	proc	near
	pusha
	mov	bl,al		; device id
	xor	bh,bh
	shl	bx,1
	mov	[bx+device_list],000h	; clear device id, interface number
	mov	ah,al
	mov	si,offset ip_buff_start
	mov	ds:dword ptr [si],0
	mov	ds:dword ptr [si+4],0
	call	scanner
	popa
	ret
DisconnectKeyboard	endp

;---------------------------------------;
; DisconnectMouse			;
;---------------------------------------;
; This function removes a mouse.	;
; Input:	DS = ES = HCD Data Area	;
; (al) = device id. (1/2/3/4/5/6/7/8)	;
;					;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
DisconnectMouse	proc	near
	ret
DisconnectMouse	endp

;---------------------------------------;
; ProcessKeyboardData                   ;
;---------------------------------------;--------------------------------------;
; This function is called at regular intervals with USB keyboard report data.  ;
; This function handles the translation of USB keyboard data into PS/2         ;
; keyboard data, and makes the PS/2 data available to software using ports     ;
; 60/64 to communicate with a PS/2 keyboard.                                   ;
;                                                                              ;
; Input:  DS:DI.TD_Control_Status = packet length - 1	; 0/1/7		       ;
;	  DS:SI = Offset of 8 byte data packet received from USB keyboard      ;
;                   Byte 0: Modifier keys                                      ;
;                   Byte 1: Reserved                                           ;
;                   Byte 2: Keycode of 1st key that is currently pressed       ;
;                   Byte 3: Keycode of 2nd key that is currently pressed       ;
;                   Byte 4: Keycode of 3rd key that is currently pressed       ;
;                   Byte 5: Keycode of 4th key that is currently pressed       ;
;                   Byte 6: Keycode of 5th key that is currently pressed       ;
;                   Byte 7: Keycode of 6th key that is currently pressed       ;
;         AH    = USB device address of the keyboard that supplied the data    ;
;                 (useful if more than one keyboard is active)                 ;
;         CX    = 11 bit time stamp value in units of 1ms (count wraps to 0    ;
;                 after reaching 7FFh)                                         ;
;         DS = ES = usbdseg                                                    ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ProcessKeyboardData:
ifdef DOS_DEBUG
	ret
endif
	if MKF_USB_UHCI
	cmp	ds:byte ptr (Transfer_Descriptor ptr [di]).TD_Control_Status,1
	jz	oldkb2		; 1 = 2 byte format
	jb	oldkb1		; 0 = 1 byte format
	endif
	jmp	scanner		; 7 = 8 byte format
oldkb2:
	pusha
	lodsb			; (al) bit 7..4 = upper 4 bit
	shl	ax,4
	lodsb			; (al) bit 7..4 = lower 4 bit
	shl	ax,4		; (ah) = data
	jmp	oldkb12
oldkb1:
	pusha
	mov	ah,[si]		; (ah) = data
oldkb12:
	mov	al,1
	call	check_cbfull
	jz	pkd_1		; buffer full, exit
	mov	al,ah
	call	put_char_buffer
pkd_1:
	popa
	ret

;---------------------------------------;
; OneSecondPeriodicHandler		;
;---------------------------------------;
; This function called every 1sec.	;
; Input:	DS = ES = HCD Data Area	;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
OneSecondPeriodicHandler:
ifdef	DOS_DEBUG
	ret
endif
	test	kbmsflag,80h
	jnz	osph_5		; already inside LED_ON routine, exit
	pusha
	test	flag_byte_1,80h	; 1=64/60 emulation active
	jnz	osph_0
	push	ds
	xor	ax,ax
	mov	ds,ax
	mov	al,ds:[417h]	; Caps-lock, Num-lock, Scroll-lock (IBM)
	pop	ds
	mov	ah,flag_byte
	and	ax,7070h
	shr	al,1		; Scroll-lock, Caps-lock, Num-lock (USB)
	test	al,08h
	jz	osph_1
	xor	al,48h
	jmp	short osph_1
osph_0:
	mov	al,flag_byte_1
	mov	ah,flag_byte
	and	ax,7070h
osph_1:
	cmp	al,ah
	jz	osph_2
	and	flag_byte,(not caps_lock_bitx+num_lock_bitx+scroll_lock_bitx)
	or	flag_byte,al
	or	kbmsflag,80h ; LED_ON active
	call	led_on
	and	kbmsflag,7fh ; LED_ON over
osph_2:
;-------------------------------;
	mov	al,bk_device_id	; check for breakcode generation
	or	al,al
	jz	osph_4		; do not generate break code
	mov	ah,0
osph_3:
	inc	ah		; form device id (1,2,3,4,5,6,7,8)
	shr	al,1
	jnc	osph_3
	mov	si,offset ip_buff_start	; scratch to generate break code
	mov	ds:dword ptr [si],0
	mov	ds:dword ptr [si+4],0
	call	scanner		; generate break code
osph_4:
	popa
osph_5:
	ret

;---------------------------------------;
; PeriodicInterruptHandler		;
;---------------------------------------;
; This function called every 16 milisec.;
; Input:	DS = ES = HCD Data Area	;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
PeriodicInterruptHandler:
	call	OneSecondPeriodicHandler
	call	OutKeyboardData
	ret

;---------------------------------------;
; OutKeyboardData			;
;---------------------------------------;
; This function called every 2 milisec	;
; by periodic interrupt handler		;
; Send data to system, generate IRQ1.	;
; Input:	DS = ES = HCD Data Area	;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
OutKeyboardData:
ifdef DOS_DEBUG
	ret
endif
	pusha
	call	check_auto_repeat
	cmp	flag_60,0000h
	jnz	klp_04		; 64/60 sequence in progress, exit
	mov	al,kbmsflag
	and	al,30h		; 00/10 => MS..KB
	cmp	al,20h		; 20 => KB..MS
	jnz	klp_10		; check MS... then KB...
;------ check KB... then MS...
	mov	ax,ch_buff_head
	cmp	ax,ch_buff_tail
	mov	ah,0d2h		; KB data
	jnz	klp_00		; character found
	mov	ax,ms_buff_head
	cmp	ax,ms_buff_tail
	mov	ah,0d3h		; MS data
	jnz	klp_00		; character found
	jmp	short klp_11
klp_10:
;------ check MS... then KB...
	mov	ax,ms_buff_head
	cmp	ax,ms_buff_tail
	mov	ah,0d3h		; MS data
	jnz	klp_00		; character found
	mov	ax,ch_buff_head
	cmp	ax,ch_buff_tail
	mov	ah,0d2h		; KB data
	jnz	klp_00		; character found
klp_11:
	cmp	last_scan_index,00h
	jnz	klp_04		; auto repeat, enable periodic interrupt
	mov	ax,sc_buff_ptr
	sub	ax,offset sc_buff_start
	jnz	klp_04		; scanner buffer not empty
	call	DisablePeriodicInterrupt
	jmp	klp_06		; exit
;-------------------------------;
klp_00:
	mov	al,0bh
	out	20h,al
	pusha
	popa
	in	al,20h
	test	al,02h
	jnz	klp_04		; inside IRQ1
	mov	al,0bh
	out	0a0h,al
	pusha
	popa
	in	al,0a0h
	test	al,10h
	jnz	klp_04		; inside IRQ12
klp_00x:
	in	al,64h
	test	al,2
	jnz	klp_00x
; one of these commands must work
;;;;	mov	al,0d1h		; write output port command
;;;;	mov	al,0d4h		; write to aux port command
	mov	al,60h		; write command byte command
	out	64h,al
	jcxz	$+2
klp_05:
	in	al,64h
	test	al,1		; op buffer full ?
	jnz	klp_01		; yes
	test	al,2		; ip buffer free ?
	jnz	klp_05		; no
;-------------------------------;
	add	kbmsflag,10h
	mov	al,kbmsflag
	and	al,30h		; 00/10 = first check MS then KB
	cmp	al,30h		; 20 = first check KB then mouse
	jnz	klp_05y
	and	kbmsflag,0cfh	; reset sequence flag
klp_05y:
;-------------------------------;
	mov	al,20h
	call	out_to_64	; send command to 8042
	call	in_from_60	; read data from 8042
	mov	ccb,al
	test	ah,1
	jnz	klp_05x		; MS data
	test	al,10h
	jnz	klp_04		; keyboard disabled
	call	get_char_buffer
	xchg	al,ah
	call	sis_write_kb_cntlr_data
	jmp	klp_04
;-------------------------------;
klp_05x:
	test	kbmsflag,08h
	jz	klp_07		; USB mouse data buffer has data
	test	al,20h
	jz	klp_04x		; mouse enabled
	mov	ms_buff_head,offset ms_buff_start
	mov	ms_buff_tail,offset ms_buff_start
	jmp	klp_04
klp_04x:
	push	ds
	push	ax
	xor	ax,ax
	mov	ds,ax
	mov	ds,ds:[40eh]
	mov	al,ds:[26h]
	and	al,7
	pop	ax
	pop	ds
	jnz	klp_04		; PS/2 mouse data packet not over
	mov	al,0a7h
	call	out_to_64	; send command to 8042
klp_07:
	call	get_mouse_buffer
	xchg	al,ah
	call	sis_write_kb_cntlr_data
	and	kbmsflag,0f7h	; first byte over
	push	ax
	mov	ax,ms_buff_head
	cmp	ax,ms_buff_tail
	pop	ax
	jnz	klp_04
	jmp	klp_03
klp_01:
	test	al,20h		; 0/1 = kb/mouse data
	mov	al,0aeh		; enable keyboard interface
	jz	klp_02
klp_03:
	test	kbmsflag,08h
	mov	al,0a8h		; enable mouse interface
	jnz	klp_02
	push	ax
	mov	ax,ms_buff_head
	cmp	ax,ms_buff_tail
	pop	ax
	jz	klp_02
	mov	al,0a7h		; disable mouse interface
klp_02:
	call	out_to_64	; send command to 8042
klp_04:
	call	EnablePeriodicInterrupt
klp_06:
	popa
	ret
;---------------------------------------;
check_auto_repeat:
	cmp	last_scan_index,00h
	jz	car_1		; no auto repeat
	inc	repeat_counter
	mov	ax,repeat_counter
	cmp	ax,repeat_rate
	jb	car_1
	mov	al,typematic_rate
	and	ax,1fh		; bit 4..0 = typematic rate
	shl	ax,1
	mov	bx,ax
	mov	ax,[bx+cgroup:tr_table+orgbase]
	mov	repeat_rate,ax
	mov	repeat_counter,0000h
	mov	ax,ch_buff_head
	cmp	ax,ch_buff_tail
	jnz	car_1		; character buffer not empty
	mov	al,last_scan_index
	call	generate_make_code
car_1:
	ret
;---------------------------------------;
; InitUSBKbDataArea			;
;---------------------------------------;
; called once to init USB KB data area	;
; Input:	DS = ES = HCD Data Area	;
; Output:	Nothing			;
; Destroys:	Nothing			;
;---------------------------------------;
InitUSBKbDataArea:
	pusha
	mov	di,offset host_kb_data_start
	mov	cx,offset host_kb_data_end - offset host_kb_data_start
	xor	al,al
        rep	stosb		; clear host keyboard data area
	mov	flag_8042,0ffh	; assume 8042 present
	call	init_typematic_scan_3	; init typematic/rate, scan-3 table
	call	init_scan_char_buff	; init scanner/character buffer
	mov	scanner_flag,02h	; scan code set 2
	mov	ms_buff_head,offset ms_buff_start
	mov	ms_buff_tail,offset ms_buff_start
;-------------------------------;
; restore LED status		;
;-------------------------------;
	test	flag_byte_1,80h	; 1=64/60 emulation active
	jnz	ikbd_0
	push	ds
	xor	ax,ax
	mov	ds,ax
	mov	al,ds:[417h]	; Caps-lock, Num-lock, Scroll-lock (IBM)
	pop	ds
	and	al,70h
	shr	al,1		; Scroll-lock, Caps-lock, Num-lock (USB)
	test	al,08h
	jz	ikbd_1
	xor	al,48h
	jmp	short ikbd_1
ikbd_0:
	mov	al,flag_byte_1
	and	al,70h
ikbd_1:
	mov	flag_byte,al
;-------------------------------;
; restore command byte		;
;-------------------------------;
ikbd_2:
	in	al,64h
	test	al,2
	jnz	ikbd_2
; one of these commands must work
;;;;	mov	al,0d1h		; write output port command
;;;;	mov	al,0d4h		; write to aux port command
	mov	al,60h		; write command byte command
	call	out_to_64	; send command to 8042
	in	al,64h
	mov	ah,al		; save status
	test	al,1
	jz	ikbd_3		; no data
	in	al,60h
ikbd_3:
	push	ax
	mov	al,20h
	call	out_to_64	; send command to 8042
	call	in_from_60	; read data from 8042
	mov	ccb,al
	pop	ax
	xchg	al,ah
	test	al,1
	jz	ikbd_4		; no data exit
	test	al,20h
	mov	al,0d2h		; kb data
	jz	ikbd_5
	mov	al,0d3h		; ms data
ikbd_5:
	call	sis_write_kb_cntlr_data
ikbd_4:
	popa
	ret

sis_write_kb_cntlr_data:
	push	cx
	extrn   pm_fixed_delay:near
	mov     cx,160h
	call    pm_fixed_delay
	pop	cx

	call	write_kb_cntlr_data
	ret

;-------------------------------;
; ProcessMouseData		;
;------------------------------------------------------------------------------;
; This function is called at regular intervals with USB mouse report data.     ;
; This function handles the translation of USB mouse data into PS/2            ;
; mouse data, and makes the PS/2 data available to software using ports        ;
; 60/64 to communicate with a PS/2 mouse.                                      ;
;                                                                              ;
; Input:  DS:SI = Offset of 3 byte data packet received from USB mouse         ;
;                   Byte 0: Modifier keys                                      ;
;                           Bit 0: If set, button 1 is presseed                ;
;                           Bit 1: If set, button 2 is presseed                ;
;                           Bit 2: If set, button 3 is presseed                ;
;                           Bit 3-7: Reserved                                  ;
;                   Byte 1: X displacement                                     ;
;                   Byte 2: Y displacement                                     ;
;         AH    = USB device address of the mouse that supplied the data       ;
;                 (useful if more than one mouse is active)                    ;
;         CX    = 11 bit time stamp value in units of 1ms (count wraps to 0    ;
;                 after reaching 7FFh)                                         ;
;         DS = ES = usbdseg                                                    ;
;                                                                              ;
; Output: Nothing                                                              ;
;                                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
ProcessMouseData	proc near
ifdef DOS_DEBUG
	ret
endif
	push	ds
	push	40h
	pop	ds
	test	byte ptr ds:[10h],04h
	pop	ds
	jnz	pmd_6		; mouse present
pmd_1:
	ret
pmd_6:
	test	flag_byte_1,80h	; 1=64/60 emulation active
	jz	pmd_2
	test	kbmsflag,40h
	jz	pmd_1		; mouse disabled
pmd_2:
	pusha
	mov	ax,ms_buff_head
	cmp	ax,ms_buff_tail
	jnz	pmd_5		; mouse data buffer has data
	mov	al,[si]		; status
	mov	cx,[si+1]	; X,Y
	neg	ch		; Y sign is opposite in USB than PS/2
	and	al,07h		; bit2,1,0 = middle,right,left button
	or	al,08h		; bit-3 always 1
;-------------------------------;
; enable this code to scale X,Y	;
;-------------------------------;
;;;;	push	ax
;;;;	mov	al,2		; X*2
;;;;	mul	cl
;;;;	mov	cl,al
;;;;	mov	al,2		; Y*2
;;;;	mul	ch
;;;;	mov	ch,al
;;;;	pop	ax
;-------------------------------;
	or	cl,cl
	jns	pmd_3
	or	al,10h		; negative X
pmd_3:
	or	ch,ch
	jns	pmd_4
	or	al,20h		; negative Y
pmd_4:
	call	put_mouse_buffer
	mov	al,cl
	call	put_mouse_buffer
	mov	al,ch
	call	put_mouse_buffer
	or	kbmsflag,08h	; mouse data ready
pmd_5:
	popa
	jmp	OutKeyboardData
ProcessMouseData	endp
;-------------------------------;
; PUT MOUSE BUFFER		;
;-------------------------------;
; register used (none).		;
; input:			;
; (al) = character		;
; output:			;
; none				;
; mouse buffer ptr updated	;
;-------------------------------;
put_mouse_buffer:
	push	bx
	mov	bx,ms_buff_head
	mov	[bx],al		; put character in buffer
	inc	bx		; advance buffer pointer
	cmp	bx,offset ms_buff_end
	jnz	pmb_1		; if buff end, back to buff start
	mov	bx,offset ms_buff_start
pmb_1:
	mov	ms_buff_head,bx	; advance head pointer
	pop	bx
	ret
;-------------------------------;
; GET MOUSE BUFFER		;
;-------------------------------;
; register used (none).		;
; input:			;
;	none.			;
; output:			;
;	(al) = character.	;
; mouse buffer ptr updated	;
;-------------------------------;
get_mouse_buffer:
	push	bx
	mov	bx,ms_buff_tail
	mov	al,0
	xchg	al,[bx]		; get data from mouse buffer
	inc	bx		; advance buffer tail pointer
	cmp	bx,offset ms_buff_end
	jnz	gmb_1		; if buff end, back to buff start
	mov	bx,offset ms_buff_start
gmb_1:
	mov	ms_buff_tail,bx	; advance mouse buffer tail pointer
	pop	bx
	ret
;-------------------------------;
;	IN_FROM_60		;
;-------------------------------;
in_from_60:
i60_2:
	in	al,64h
	test	al,1
	jz	i60_2
	in	al,60h
	ret			; (zf) = 1, not valid data
;-------------------------------;
;	OUT_TO_64		;
;-------------------------------;
out_to_64:
	out	64h,al
	push	ax
ot64_2:
	in	al,64h
	test	al,2
	jnz	ot64_2
	pop	ax
	ret
;-------------------------------;
;	OUT_TO_60		;
;-------------------------------;
out_to_60:
	out	60h,al
	push	ax
ot60_2:
	in	al,64h
	test	al,2
	jnz	ot60_2
	pop	ax
	ret
;-------------------------------;
;	LED_ON			;
;-------------------------------;
led_on:
	mov	al,flag_byte
	push	ax		; save flag_byte
	shr	al,4		; bit 2,1,0 = Scroll, Caps, Num
	and	al,07h
	mov	flag_byte,al
	mov	cx,(offset device_list_end - offset device_list)/2
	mov	si,offset device_list
lon_1:
	lodsw			; device id.
	movzx	dx,ah		; (dx) = interface number
	or	al,al
	jz	lon_2		; no device
	push	cx
	push	si
	mov	ah,00		; send to endpoint-0
	mov	si,0001h	; wLength, 1 byte LED data length
	mov	bx,0921h	; set-report, request type = Interface
	mov	cx,0200h	; wValue, (ch) = "report type" = output

	mov	di,offset flag_byte
	call	USBDeviceRequest
	pop	si
	pop	cx
lon_2:
	loop	lon_1
	pop	ax
	mov	flag_byte,al	; restore flag_byte
	ret
;-------------------------------;
;	INIT_TYPEMATIC_SCAN_3	;
;-------------------------------;
init_typematic_scan_3:
	mov	typematic_rate,2bh	; 500 milisecond, 10.9 characters/sec
	mov	di,offset scan_3_table
	mov	si,offset cgroup:scan_3_table_data+orgbase
	mov	cx,32
	db	2eh		; cs:
	rep	movsb
	ret
;-------------------------------;
;	INIT_SCAN_CHAR_BUFF	;
;	INIT_CHAR_BUFF		;
;-------------------------------;
init_scan_char_buff:
	mov	sc_buff_ptr,offset sc_buff_start
	mov	last_scan_index,00h
	and	typematic_rate,(not auto_repeat_bitx)
init_char_buff:
	mov	ch_buff_head,offset ch_buff_start
	mov	ch_buff_tail,offset ch_buff_start
	ret
;---------------------------------------;
; Handle64Read                          ;
;---------------------------------------;--------------------------------------;
; This trap function is called when any software reads port 64h.               ;
; Input: Nothing                                                               ;
; Output: AL = Simulated data as if read from port 64h                         ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
Handle64Read	proc near
	in	al,64h			;Do actual read for now
	ret
Handle64Read	endp
;---------------------------------------;
; Handle60Read                          ;
;---------------------------------------;--------------------------------------;
; This trap function is called when any software reads port 60h.               ;
; Input: Nothing                                                               ;
; Output: AL = Simulated data as if read from port 60h                         ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
Handle60Read	proc near
	in	al,60h			;Do actual read for now
	mov	port_60_char,al
	ret
Handle60Read	endp
;---------------------------------------;
; Handle60Write                         ;
;---------------------------------------;--------------------------------------;
; This trap function is called when any software writes to port 60h.           ;
; Input: AL = Data to be written to port 60h                                   ;
; Output: Nothing                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
Handle60Write	proc near
	pusha
	call	out_60
	popa
	ret
Handle60Write	endp
;---------------------------------------;
; Handle64Write                         ;
;---------------------------------------;--------------------------------------;
; This trap function is called when any software writes to port 64h.           ;
; Input: AL = Data to be written to port 64h                                   ;
; Output: Nothing                                                              ;
; Destroys: Nothing                                                            ;
;------------------------------------------------------------------------------;
Handle64Write	proc near
	pusha
	call	out_64
	popa
	ret
Handle64Write	endp

;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;

;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;-------------------------------;
; KEYBOARD CONTROLLER / SCANNER	;
;-------------------------------;
lalt		equ	11h	; left alt code (scan code set-2)
lctl		equ	14h	; left control code (scan code set-2)
lsht		equ	12h	; left shift code (scan code set-2)
rsht		equ	59h	; right shift code (scan code set-2)
;-------------------------------;
; BaseCase only			;
;-------------------------------;
ralt		equ	11h+80h	; 91 local code id. (used in scan-2 table also)
rctl		equ	14h+80h	; 94 local code id. (used in scan-2 table also)
lmsft		equ	1fh+80h	; 9F microsoft left key
rmsft		equ	27h+80h	; A7 microsoft right key
amsft		equ	2fh+80h	; AF microsoft application key
renter		equ	5ah+80h	; DA local code id. (used in scan-2 table also)
;-------------------------------;
; BaseCase, Ctrl/Shift, AltCase	;
;-------------------------------;
prtsc		equ	7ch+80h	; FC local code id. (used in scan-2 table also)
;-------------------------------;
; BaseCase, CtrlCase		;
;-------------------------------;
pause		equ	7eh+80h	; FE local code id. (used in scan-2 table also)
;-------------------------------;
; BaseCase, ShiftCase only	;
;-------------------------------;
slash		equ	4ah+80h	; CA local code id. (used in scan-2 table also)
;-------------------------------;
; BaseCase, ShiftCase, NumLock	;
;-------------------------------;
endx		equ	69h+80h	; E9 local code id. (used in scan-2 table also)
left		equ	6bh+80h	; EB local code id. (used in scan-2 table also)
home		equ	6ch+80h	; EC local code id. (used in scan-2 table also)
insr		equ	70h+80h	; F0 local code id. (used in scan-2 table also)
del		equ	71h+80h	; F1 local code id. (used in scan-2 table also)
down		equ	72h+80h	; F2 local code id. (used in scan-2 table also)
rght		equ	74h+80h	; F4 local code id. (used in scan-2 table also)
up		equ	75h+80h	; F5 local code id. (used in scan-2 table also)
pgdn		equ	7ah+80h	; FA local code id. (used in scan-2 table also)
pgup		equ	7dh+80h	; FD local code id. (used in scan-2 table also)
;-------------------------------;
;	KEYBOARD SCANNER	;
;-------------------------------;
; input:			;
;	(ah) = device id.	;
;	   (binary count 1...8)	;
;	(bx) = 0..7FF (milisec)	;
;	(ds,es) = data segment	;
;	(ds:si) = pointer to 8	;
;		 bytes data	;
;-------------------------------;
scanner:
	pusha
	mov	al,80h		; 1/2/3/4/5/6/7/8 ==>> 1/2/4/8/10/20/40/80
next_id:
	rol	al,1
	dec	ah
	jnz	next_id
	mov	device_id,al	; save current device id
;-------------------------------;
; convert bits to 8 KeyCode bytes
;-------------------------------;
	mov	di,offset ip_buff_start
	mov	bx,offset cgroup:modifier_key_table+orgbase
	mov	cx,8		; 8 bits to 8 byte
	lodsb			; modifier byte
alog_2:
	mov	ah,cs:[bx]	; USBKeyCode
	inc	bx
	shr	al,1
	jnc	alog_1		; key not pressed
	mov	[di],ah
	inc	di
alog_1:
	loop	alog_2
	lodsb			; reserved byte (discard)
	mov	cx,6
alog_4:
	lodsb
	or	al,al
	jz	alog_3		; discard 00
	cmp	al,01h		; KeyboardErrorRollOver (overrun)
	jnz	alog_5
	mov	al,00h		; 1 byte to check overrun
	call	check_cbfull
	jz	sc_6		; full, exit
	mov	al,scanner_flag
	and	al,03h
	cmp	al,01h
	mov	al,00h		; 00 =  scan code set 1 overrun code
	jz	alog_6
	mov	al,0ffh		; FF = scan code set 2/3 overrun code
alog_6:
	call	put_char_buffer
	mov	last_scan_index,00h
	jmp	sc_6
alog_5:
	stosb
alog_3:
	loop	alog_4
	mov	al,00h
	stosb			; null terminated
;-------------------------------;
; set breakcode generation flag	;
;-------------------------------;
	mov	cx,di
	mov	di,offset ip_buff_start
	sub	cx,di
	mov	al,00h
	repz	scasb
	jnz	alog_3x		; found
	mov	al,device_id
	or	bk_device_id,al	; set breakcode generation flag
alog_3x:
;-------------------------------;
	mov	si,offset ip_buff_start
sc_3:
	lodsb
	or	al,al
	jz	sc_2		; list over, check break code
	mov	di,offset sc_buff_start
	mov	cx,sc_buff_ptr
	sub	cx,di
	jcxz	sc_5		; scanner buffer empty
	repnz	scasb
	jz	sc_1		; found
	cmp	di,offset sc_buff_end
	jae	sc_2		; scanner buffer full, check break code
sc_5:
	call	generate_make_code
	jz	sc_6		; character buffer full, exit
	mov	last_scan_index,al
	mov	[di],al		; put in scanner buffer
	sub	di,offset sc_buff_start
	add	di,offset dv_flag_start
	mov	al,device_id
	mov	[di],al		; set device info
	sub	di,offset dv_flag_start
	add	di,offset sc_flag_start
	mov	al,flag_byte
	mov	[di],al		; set flag_byte info
	inc	sc_buff_ptr
	mov	al,typematic_rate
	and	ax,60h		; bit 6,5 = typematic rate delay
	shr	ax,4
	mov	bx,ax
	mov	ax,[bx+cgroup:trd_table+orgbase]
	mov	repeat_rate,ax
	mov	repeat_counter,0000h
	jmp	sc_3		; continue
sc_1:
	dec	di
	sub	di,offset sc_buff_start
	add	di,offset dv_flag_start
	mov	al,device_id
	or	[di],al		; set device info
	jmp	sc_3		; continue
;-------------------------------;
; CHECK BREAK CODE GENERATION	;
;-------------------------------;
sc_2:
	dec	si
	sub	si,offset ip_buff_start
	mov	cx,si
	mov	si,offset sc_buff_start
sc_7:
	cmp	si,sc_buff_ptr
	jae	sc_66		; breakcode generation over
	lodsb
	mov	di,offset ip_buff_start
	jcxz	sc_4
	push	cx
	repnz	scasb
	pop	cx
	jz	sc_7		; found, continue
sc_4:
	mov	di,si
	dec	di
	sub	di,offset sc_buff_start
	add	di,offset dv_flag_start
	mov	al,device_id
	not	al
	and	[di],al		; clear device info
	jnz	sc_7		; continue
	sub	di,offset dv_flag_start
	add	di,offset sc_flag_start
	mov	al,[di]
	xchg	al,flag_byte	; modify flag_byte for break code generation
	mov	[di],al
	dec	si
	mov	al,[si]
	call	generate_break_code
	mov	al,[di]
	xchg	al,flag_byte	; restore flag_byte
	mov	[di],al
	jz	sc_6		; char buffer full, exit
	mov	al,[si]
	call	discard_character
	dec	sc_buff_ptr
	xor	last_scan_index,al
	jz	sc_8		; stop auto repeat
	xor	last_scan_index,al
sc_8:
	jmp	sc_7		; continue
sc_66:
	mov	al,device_id
	not	al
	and	bk_device_id,al	; clear breakcode generation flag
sc_6:
	popa
	ret
;-------------------------------;
; DISCARD CHARACTER		;
;-------------------------------;
; input: (di) = points to scanner
;		flag list	;
;-------------------------------;
discard_character:
	pusha
	push	di		; save (di)
	mov	si,di
	inc	si
	mov	cx,offset sc_flag_end
	sub	cx,si
	push	cx
	rep	movsb		; scanner flag list sorted
	pop	cx
	pop	di		; restore (di)
	sub	di,offset sc_flag_start
	push	di		; save (di)
	add	di,offset dv_flag_start
	mov	si,di
	inc	si
	push	cx
	rep	movsb		; device id list sorted
	pop	cx
	pop	di		; restore (di)
	add	di,offset sc_buff_start
	mov	si,di
	inc	si
	rep	movsb		; scanner buffer list sorted
	popa
	ret
;-------------------------------;
; GENERATE_MAKE_CODE		;
;-------------------------------;
generate_make_code:
	mov	make_break_flag,'m'
	jmp	gc_0
;-------------------------------;
; GENERATE_BREAK_CODE		;
;-------------------------------;
generate_break_code:
	mov	make_break_flag,'b'
gc_0:
	pusha
	mov	current_scan_index,al
	call	get_scan_code_2
	mov	tl0,al		; save
;------ alt,ctrl,shift check ---;
	call	check_alt_ctrl_shift
	jz	acs_7		; not found
	cmp	make_break_flag,'m'
	jz	acs_8		; make code
;------ left/right alt,ctl -----;
	test	ch,left_shift_bitx+right_shift_bitx
	jnz	acs_9
	mov	bx,sc_buff_ptr
	jmp	acs_10
acs_11:
	dec	bx		; dec scanner buffer pointer
	mov	al,[bx]
	call	get_scan_code_2
	cmp	al,cl		; other alt/control present ?
	jz	acs_7		; yes, do not clear bit
acs_10:
	cmp	bx,offset sc_buff_start
	jnz	acs_11
acs_9:
	not	ch
	and	flag_byte,ch	; clear proper bit (alt/ctl/shift)
	and	[di],ch		; clear proper bit (alt/ctl/shift)
	jmp	acs_7
acs_8:
	or	flag_byte,ch	; set proper bit (alt/ctl/shift)
;-------------------------------;
;	SCAN CODE 1/2/3		;
;-------------------------------;
acs_7:
	mov	al,scanner_flag
	and	al,03h		; bit 1,0 = scan code set-1/2/3
	cmp	al,03h
	jnz	gc_1		; check for scan code set-1/2
;------ SCAN CODE SET-3 --------;
	mov	al,tl0		; scan code set 2
	cmp	al,pause
	jnz	gc_2
	mov	al,62h		; scan code set-3 for PAUSE key
	jmp	gc_3		; goto common path
gc_2:
	cmp	al,prtsc
	jnz	gc_4
	mov	al,57h		; scan code set-3 for PRTSC key
	jmp	gc_3		; goto common path
gc_4:
	cmp	al,slash
	jnz	gc_5
	mov	al,77h		; scan code set-3 for '/' key
	jmp	gc_3		; goto common path
gc_5:
	call	check_get_num_key_pad
	jnc	gc_3		; found (al) = scan code set 3
	call	check_get_extd_key
	jnc	gc_3		; found (al) = scan code set 3
;------ SCAN CODE-3 TABLE ------;
	mov	al,tl0		; scan code set-2
	call	get_scan_code_3	; SCAN CODE-2 -> SCAN CODE-3
gc_3:
	mov	th0,al		; save scan code-3
	test	al,80h
	jz	gc_3x
	call	check_get_extd_scan_3_new
gc_3x:
	call	read_code_3_value ; read scan code-3 type value
	and	al,03h		; bit-1,0 = 0/1/2/3
;-------------------------------------------------------;
;  (A)	| MAKE CODE	| AUTO REPEAT	| BREAK CODE	;
;-------------------------------------------------------;
;  00	|	1	|	0	|	0	;
;-------------------------------------------------------;
;  01	|	1	|	0	|	1	;
;-------------------------------------------------------;
;  10	|	1	|	1	|	0	;
;-------------------------------------------------------;
;  11	|	1	|	1	|	1	;
;-------------------------------------------------------;
	jz	gc_11_0		; make code, no auto repeat, no break code
	dec	al
	jz	gc_11_1		; make code, no auto repeat, break code
	dec	al
	jz	gc_11_2		; make code, auto repeat, no break code
;------ MAKE, AUTO, BREAK ------;
	cmp	make_break_flag,'m'
	jnz	gc_11_4		; break code
	jmp	gc_11_0x	; make code
gc_11_2:
;------ MAKE, AUTO, NO BREAK ---;
	cmp	make_break_flag,'m'
	jnz	gc_11_6		; no break code, ret
	jmp	gc_11_0x	; make code
gc_11_1:
;------ MAKE, NO AUTO, BREAK ---;
	cmp	make_break_flag,'m'
	jz	gc_11_0y	; make code
gc_11_4:
;------ BREAK CODE GENERATION --;
	mov	al,02h		; 2 bytes required
	test	ccb,40h
	jz	gc_11_3		; no conversion
	mov	al,01h		; 1 byte required
gc_11_3:
	call	check_cbfull	; check if character buffer full ?
	jz	gc_11_6		; character buffer full, error
	test	ccb,40h
	jnz	gc_11_7
	mov	al,0f0h
	call	put_char_buffer	; put character in character buffer
	jmp	gc_11_5
gc_11_7:
	mov	al,th0		; restore scan code-3
	call	get_scan_code_1
	or	al,80h		; break code, bit-7 = 1
	call	put_char_buffer	; put data to character buffer
	jmp	gc_over
gc_11_0:
;------ MAKE, NO AUTO, NO BREAK-;
	cmp	make_break_flag,'m'
	jnz	gc_11_6		; no break code, ret
gc_11_0y:
	mov	al,last_scan_index
	cmp	al,current_scan_index
	jnz	gc_11_0x	; no auto repeat
	call	get_scan_code_2
	cmp	al,tl0
	jnz	gc_11_0x	; if current code = last scan code then
	or	sp,sp
	jmp	gc_11_6		; auto repeat, no make code
gc_11_0x:
;------ MAKE CODE GENERATION ---;
	mov	al,01h
	call	check_cbfull	; check if character buffer full ?
	jz	gc_11_6		; character buffer full, error
gc_11_5:
	mov	al,th0		; restore scan code-3
	test	ccb,40h
	jz	gc_11_8		; no conversion
	call	get_scan_code_1
gc_11_8:
	call	put_char_buffer	; put character in character buffer
gc_11_6:
	jmp	gc_over
;-------------------------------;
; CHECK FOR SCAN CODE SET-1/2	;
;-------------------------------;
gc_1:
	mov	al,tl0		; scan code set 2
	cmp	al,pause
	jnz	gc_20
;------ PAUSE KEY PROCESSING ---;
	cmp	make_break_flag,'m'
	jnz	gc_over		; no BREAK CODE for pause_key
	mov	al,last_scan_index
	cmp	al,current_scan_index
	jnz	gc_19
	call	get_scan_code_2
	cmp	al,tl0
	jnz	gc_19		; if current code = last scan code then exit
	or	sp,sp
	jmp	gc_over		; no AUTO REPEAT for pause_key
gc_19:
	mov	bx,offset cgroup:t4500+orgbase	; CtrlCase PAUSE
	test	flag_byte,ctl_key_bitx
	jnz	gc_23
	mov	bx,offset cgroup:t6800+orgbase	; BaseCase PAUSE
	jmp	gc_23
gc_20:
	cmp	al,prtsc
	jnz	gc_24
;------ PRTSC KEY PROCESSING ---;
	mov	bx,offset cgroup:t1112+orgbase	; AltCase PRTSC
	test	flag_byte,alt_key_bitx
	jnz	gc_23
	mov	bx,offset cgroup:t2223+orgbase	; CtrlShift PRTSC
	test	flag_byte,ctl_key_bitx+left_shift_bitx+right_shift_bitx
	jnz	gc_23
	mov	bx,offset cgroup:t4446+orgbase	; BaseCase PRTSC
	jmp	gc_23
gc_24:
	call	check_get_num_key_pad
	jc	gc_25		; not inside num key pad
;------ NUMERIC KEY PROCESSING -;
	mov	bx,offset cgroup:t2223+orgbase	; BaseCase num key pad
	test	flag_byte,num_lock_bitx+left_shift_bitx+right_shift_bitx
	jz	gc_23
	mov	bx,offset cgroup:t4446+orgbase	; NumLock num key pad
	test	flag_byte,num_lock_bitx
	jnz	gc_23
	mov	bx,offset cgroup:t4545+orgbase	; ShiftCase num key pad
	jmp	gc_23
gc_25:
	call	check_get_extd_key
	mov	bx,offset cgroup:t2223+orgbase	; BaseCase extended key
	jnc	gc_23
;------ EXTENDED KEY PROCESSING ;
	cmp	tl0,slash
	jnz	gc_21
	test	flag_byte,left_shift_bitx+right_shift_bitx
	jz	gc_23
	mov	bx,offset cgroup:t4545+orgbase	; ShiftCase '/'
	jmp	gc_23
gc_21:
	mov	bx,offset cgroup:t1112+orgbase	; BaseCase regular key
;-------------------------------;
gc_23:
	mov	al,00h		; offset in xlat table
	cmp	make_break_flag,'b'
	jnz	gc_23x
	mov	al,02h		; offset in xlat table
gc_23x:
	test	ccb,40h		; conversion required ?
	jnz	gc_32		; yes
	inc	al
gc_32:
	db	2eh		; CS:
	xlat
	call	check_cbfull
	jz	gc_over		; buffer full, error exit
;-------------------------------;
; CODE GENERATION		;
;-------------------------------;
	mov	al,tl0		; scan code set-2
	cmp	al,pause
	jnz	gc_40
	test	flag_byte,ctl_key_bitx
	jnz	gc_41		; Control key on
;-------------------------------;
;	BaseCase PAUSE key	;
;-------------------------------;
	mov	al,0e1h
	call	put_char_buffer	; E1
	mov	tl0,14h
	call	make_code_1	; 14
	mov	tl0,77h
	call	make_code_1	; 77
	mov	al,0e1h
	call	put_char_buffer	; E1
	mov	tl0,14h
	call	break_code_1	; F0,14
	mov	tl0,77h
	call	break_code_1	; F0,77
	jmp	gc_over
;-------------------------------;
;	CtrlCase PAUSE key	;
;-------------------------------;
gc_41:
	mov	tl0,7eh		; PAUSE scan code set 2
	call	make_code_2	; E0,7E
	call	break_code_2	; E0,F0,7E
	jmp	gc_over
;-------------------------------;
gc_40:
	cmp	al,prtsc
	jnz	gc_45
	mov	tl0,7ch		; PRTSC scan code set 2
	test	flag_byte,alt_key_bitx
	jnz	gc_46
	test	flag_byte,ctl_key_bitx+left_shift_bitx+right_shift_bitx
	jnz	gc_43
;-------------------------------;
;	BaseCase PRTSC key	;
;-------------------------------;
;	NumLockCase NUM key pad	;
;-------------------------------;
;(E0,12,E0,xx)(E0,F0,xx,E0,F0,12)
;-------------------------------;
gc_57:
	cmp	make_break_flag,'m'
	jnz	gc_58		; break code
	mov	al,tl0		; save scan code set-2
	push	ax
	mov	tl0,12h
	call	make_code_2	; E0,12
	pop	ax
	mov	tl0,al		; restore scan code set-2
gc_53:
	call	make_code_2	; E0,TL0
	jmp	gc_over
gc_58:
	call	break_code_2	; E0,F0,TL0
	mov	tl0,12h
gc_54:
	call	break_code_2	; E0,F0,12
	jmp	gc_over
;-------------------------------;
;	AltCase PRTSC key	;
;-------------------------------;
gc_46:
	mov	tl0,84h		; ALT PRTSC scan code set-2
;-------------------------------;
;	regular MAKE/BREAK	;
;-------------------------------;
;	(xx)(F0,xx)		;
;-------------------------------;
gc_59:
	cmp	make_break_flag,'m'; 0/2 = make/break
	jnz	gc_60
	call	make_code_1	; TL0
	jmp	gc_over
gc_60:
	call	break_code_1	; F0,TL0
	jmp	gc_over
;-------NUMERIC KEY-------------;
gc_45:
	call	check_get_num_key_pad
	jc	gc_48		; not inside num key pad
	and	tl0,7fh
	test	flag_byte,num_lock_bitx+left_shift_bitx+right_shift_bitx
	jz	gc_43		; (E0,xx)(E0,F0,xx)
	test	flag_byte,num_lock_bitx
	jnz	gc_57		; (E0,12,E0,xx)(E0,F0,xx,E0,F0,12)
;-------------------------------;
;	ShiftCase NUM KEY pad	;
;-------------------------------;
;(E0,F0,12/59,E0,xx)(E0,F0,xx,E0,12/59)
;-------------------------------;
gc_52:
	cmp	make_break_flag,'m'; 0/2 = make/break
	jnz	gc_51		; break code
	mov	al,tl0		; save scan code set-2
	push	ax
	call	break_code_left	; E0,F0,12
	call	break_code_right; E0,F0,59
	pop	ax
	mov	tl0,al		; restore scan code set-2
	call	make_code_2	; E0,TL0
	jmp	gc_over
gc_51:
	call	break_code_2	; E0,F0,TL0
	call	make_code_right	; E0,59
	call	make_code_left	; E0,12
	jmp	gc_over
;-------EXTENDED KEY------------;
gc_48:
	call	check_get_extd_key
	jc	gc_55		; not inside extended key
	and	tl0,7fh
;------ MAKE/BREAK EXTENDED ----;
;-------------------------------;
;	Ctrl/ShiftCase PRTSC	;
;-------------------------------;
;	BaseCase NUM KEY pad	;
;-------------------------------;
;	(E0,xx)(E0,F0,xx)	;
;-------------------------------;
gc_43:
	cmp	make_break_flag,'m'
	jnz	gc_54		; break code
	jmp	gc_53		; make code
;-------------------------------;
gc_55:
	cmp	tl0,slash	; scan code set 2
	jnz	gc_59		; regular key
;-------------------------------;
;	extended '/' key	;
;-------------------------------;
	mov	tl0,4ah		; '/' key scan code set 2
	test	flag_byte,left_shift_bitx+right_shift_bitx
	jz	gc_43		; (E0,xx)(E0,F0,xx)
	jmp	gc_52		; (E0,F0,12/59,E0,XX)(E0,F0,XX,E0,12/59)
;-------------------------------;
gc_over:
	popa
	ret
;-------------------------------;
;	CHECK_ALT_CTRL_SHIFT	;
;-------------------------------;
; registers used (ch,cl)	;
;-------------------------------;
; input: (al) = scan code 2	;
; output: (zf) = 1 ; not found	;
;		 0 ; found	;
;	  (ch,cl) = code	;
;-------------------------------;
check_alt_ctrl_shift:
	mov	ch,00h
	cmp	al,lsht
	jnz	acs_1
	mov	ch,left_shift_bitx
acs_1:
	cmp	al,rsht
	jnz	acs_2
	mov	ch,right_shift_bitx
acs_2:
	cmp	al,lctl
	jnz	acs_3
	mov	ch,ctl_key_bitx
	mov	cl,rctl
acs_3:
	cmp	al,rctl
	jnz	acs_4
	mov	ch,ctl_key_bitx
	mov	cl,lctl
acs_4:
	cmp	al,lalt
	jnz	acs_5
	mov	ch,alt_key_bitx
	mov	cl,ralt
acs_5:
	cmp	al,ralt
	jnz	acs_6
	mov	ch,alt_key_bitx
	mov	cl,lalt
acs_6:
	or	ch,ch
	ret
;-------------------------------;
; GET_SCAN_CODE_2		;
;-------------------------------;
get_scan_code_2:
	push	bx
	mov	bx,offset cgroup:USBKeyCode_to_Scan_2_table+orgbase
	db	2eh		; CS:
	xlat
	pop	bx
	ret
;-------------------------------;
; GET_SCAN_CODE_3		;
;-------------------------------;
get_scan_code_3:
	push	bx
	mov	bx,offset cgroup:set_2_to_3+orgbase
	jmp	gsc_1_3
;-------------------------------;
; GET_SCAN_CODE_1		;
;-------------------------------;
get_scan_code_1:
	push	bx
	mov	bx,offset cgroup:set_2_to_1+orgbase
gsc_1_3:
	db	2eh		; CS:
	xlat
	mov	ah,al
	and	ax,0ff0h
	shr	ax,4
	rol	al,1
	not	al
	pop	bx
	ret
;-------------------------------;
; CHECK_GET_NUM_KEY_PAD		;
;-------------------------------;
; registers used: (ah,bx,al)	;
; input:			;
;	(TL0) = scan code set 2	;
; output:			;
;	(cf) = 1, not found	;
;	(cf) = 0, found		;
;	      (al) = scan 3 data;
;-------------------------------;
check_get_num_key_pad:
	mov	bx,offset cgroup:key_pad_scan_2_table - 1 +orgbase
	mov	ah,offset key_pad_scan_2_table_end-offset key_pad_scan_2_table
cnkp_1:
	mov	al,ah
	db	2eh		; CS:
	xlat			; get scan-2 code for extended key
	xor	al,tl0		; (tl0) = current scan code-2
	jz	cnkp_2		; found
	dec	ah
	jnz	cnkp_1
	stc
	ret
cnkp_2:
	mov	bx,offset cgroup:key_pad_scan_3_table - 1 +orgbase
	mov	al,ah
	db	2eh		; CS:
	xlat			; scan code 3
	clc
	ret
;-------------------------------;
; CHECK_GET_EXTD_KEY		;
;-------------------------------;
; registers used: (ah,bx,al)	;
; input:			;
;	(TL0) = scan code set 2	;
; output:			;
;	(cf) = 1, not found	;
;	(cf) = 0, found		;
;	      (al) = scan 3 data;
;-------------------------------;
check_get_extd_key:
	mov	bx,offset cgroup:extd_key_scan_2_table - 1 +orgbase
	mov	ah,offset extd_key_scan_2_table_end-offset extd_key_scan_2_table
cnkp_3:
	mov	al,ah
	db	2eh		; CS:
	xlat			; get scan-2 code for extended key
	xor	al,tl0		; (tl0) = current scan code-2
	jz	cnkp_4		; found
	dec	ah
	jnz	cnkp_3
	stc
	ret
cnkp_4:
	mov	bx,offset cgroup:extd_key_scan_3_table - 1 +orgbase
	mov	al,ah
	db	2eh		; CS:
	xlat			; scan code 3
	clc
	ret
;-------------------------------;
; CHECK_GET_EXTD_SCAN_3_NEW	;
;-------------------------------;
; registers used: (ah,bx,al)	;
; input:			;
;	th0 = scan code set 3;
; output:			;
;	(cf) = 1, not found	;
;	(cf) = 0, found		;
;	      (al) = scan 3 index
;-------------------------------;
check_get_extd_scan_3_new:
	mov	bx,offset cgroup:extd_scan_3_data - 1 +orgbase
	mov	ah,offset extd_scan_3_data_end-offset extd_scan_3_data
cnkp_5:
	mov	al,ah
	db	2eh		; CS:
	xlat			; get scan-3 code for extended key
	xor	al,th0		; (buffer) = current scan code-3
	jz	cnkp_6		; found
	dec	ah
	jnz	cnkp_5
	stc
	ret
cnkp_6:
	mov	bx,offset cgroup:extd_scan_3_new - 1 +orgbase
	mov	al,ah
	db	2eh		; CS:
	xlat			; scan code 3 index
	clc
	ret
;-------------------------------;
; MAKE CODE LEFT (LEFT SHIFT)	;
; MAKE CODE RIGHT (RIGHT SHIFT)	;
; BREAK CODE LEFT (LEFT SHIFT)	;
; BREAK CODE RIGHT (RIGHT SHIFT);
;-------------------------------;
; registers used: (al,TL0,ah)	;
; input:			;
;	none.			;
; output:			;
;	none.			;
; code generated:		;
;	E0,12			;
;	E0,59			;
;	E0,F0,12		;
;	E0,F0,59		;
;-------------------------------;
make_code_left:
	test	flag_byte,left_shift_bitx
	jz	mblr_1
	mov	tl0,12h
	jmp	make_code_2	; E0,12
make_code_right:
	test	flag_byte,right_shift_bitx
	jz	mblr_1
	mov	tl0,59h
	jmp	make_code_2	; E0,59
break_code_left:
	test	flag_byte,left_shift_bitx
	jz	mblr_1
	mov	tl0,12h
	jmp	break_code_2	; E0,F0,12
break_code_right:
	test	flag_byte,right_shift_bitx
	jz	mblr_1
	mov	tl0,59h
	jmp	break_code_2	; E0,F0,59
mblr_1:
	or	sp,sp		; (zf) = 0
	ret
;-------------------------------;
; BREAK CODE 2			;
; BREAK CODE 1			;
; MAKE CODE 2			;
; MAKE CODE 1			;
;-------------------------------;
; registers used: (al,ah)	;
; input:			;
;	(TL0) = scan code set-2	;
; output:			;
;	none.			;
; generated code:		;
;	E0,F0,TL0		;
;	TL0			;
;	E0,TL0			;
;	TL0			;
;-------------------------------;
break_code_2:
	mov	al,0e0h
	call	put_char_buffer	; E0
break_code_1:
	mov	al,scanner_flag
	and	al,03h		; possible value = scan code set-1/2
	cmp	al,02h
	jnz	mcbc_1		; scan code set-1
	test	ccb,40h
	jnz	mcbc_1		; conversion required
	mov	al,0f0h
	call	put_char_buffer	; F0
mcbc_3:
	mov	al,tl0
	jmp	put_char_buffer	; no conversion
mcbc_1:
	mov	al,tl0
	call	get_scan_code_1	; get scan code set-1
	or	al,80h
	jmp	put_char_buffer	; break code
make_code_2:
	mov	al,0e0h
	call	put_char_buffer	; E0
make_code_1:
	mov	al,scanner_flag
	and	al,03h		; possible value = scan code set-1/2
	cmp	al,02h
	jnz	mcbc_2		; scan code set-1
	test	ccb,40h
	jz	mcbc_3		; no conversion
mcbc_2:
	mov	al,tl0
	call	get_scan_code_1	; get scan code set-1
	jmp	put_char_buffer
;-------------------------------;
; WRITE CODE 3 VALUE		;
;-------------------------------;
; registers used (bx,ax)	;
; input:			;
;	(al) = scan code-3	;
;		(00..7F)	;
;	(ah) = action value	;
;		(0,1,2,3)	;
; output:			;
;	none.			;
;	action value written in	;
;	corresponding memory	;
;-------------------------------;
write_code_3_value:
	push	cx
	push	ax
	call	read_code_3_value	; A, BUFFER
	mov	cl,al
	pop	ax
	and	al,03h
	inc	al
	xchg	al,cl
	and	al,0fch		; clear last 2 bits
	or	al,ah		; insert new value
	jmp	wc3v_1
wc3v_2:
	rol	al,2		; position 2 bits
wc3v_1:
	dec	cl
	jnz	wc3v_2
	mov	[bx],al		; write back action value
	pop	cx
	ret
;-------------------------------;
; READ CODE 3 VALUE		;
;-------------------------------;
; registers used (bx,ax)	;
; input:			;
;	(al) = scan code-3	;
;		(00..7F)	;
; output:			;
;	(bx) = address		;
;	(al) = scan code-3 action;
;		in bit-1,0	;
;		xxxx xx..	;
;-------------------------------;
read_code_3_value:
	push	cx
	mov	cl,al
	and	al,03		; 0,1,2,3
	inc	al		; 1,2,3,4
	xchg	al,cl
	ror	al,2		; prepare index
	and	al,1fh		; memory address 00..1F
	cbw
	add	ax,offset scan_3_table
	mov	bx,ax		; return value
	mov	al,[bx]
	jmp	rc3v_1
rc3v_2:
	ror	al,2		; position 2 bits
rc3v_1:
	dec	cl
	jnz	rc3v_2
	pop	cx
	ret
;-------------------------------;
; CHECK CHARACTER BUFFER FULL	;
;-------------------------------;
; register used (al).		;
; input:			;
; al = # bytes needed		;
; output:			;
; (zf) = 1, buffer full		;
; (zf) = 0, buffer not full.	;
; (al) changed			;
;-------------------------------;
check_cbfull:
	push	bx
	mov	bx,ch_buff_head	; check for character buffer full
	inc	al		; 1 more byte for overrun character
ccbf_2:
	inc	bx
	cmp	bx,offset ch_buff_end
	jnz	ccbf_1		; if head pointer reached buffer end
	mov	bx,offset ch_buff_start; then initialize to buffer start
ccbf_1:
	cmp	bx,ch_buff_tail
	jz	ccbf_4		; yes, character buffer full
	dec	al
	jnz	ccbf_2		; continue
ccbf_4:
	xor	bx,ch_buff_tail	; (zf) = x
	pop	bx
	ret
;-------------------------------;
; PUT CHAR BUFFER		;
;-------------------------------;
; register used (none).		;
; input:			;
; (al) = character		;
; output:			;
; (zf) = 0:ok			;
; character buffer ptr updated	;
;-------------------------------;
put_char_buffer:
	push	bx
	mov	bx,ch_buff_head
	mov	[bx],al		; put character in buffer
	inc	bx		; advance buffer pointer
	cmp	bx,offset ch_buff_end
	jnz	pcb_1		; if buff end, back to buff start
	mov	bx,offset ch_buff_start
pcb_1:
	mov	ch_buff_head,bx	; advance head pointer
	call	EnablePeriodicInterrupt
	pop	bx
	or	sp,sp		; (zf) = 0
	ret
;-------------------------------;
; GET CHAR BUFFER		;
;-------------------------------;
; register used (none).		;
; input:			;
;	none.			;
; output:			;
;	(al) = character.	;
; character buffer ptr updated	;
;-------------------------------;
get_char_buffer:
	push	bx
	mov	bx,ch_buff_tail
	mov	al,[bx]		; get character from character buffer
	inc	bx		; advance buffer tail pointer
	cmp	bx,offset ch_buff_end
	jnz	gcb_1		; if buff end, back to buff start
	mov	bx,offset ch_buff_start
gcb_1:
	mov	ch_buff_tail,bx	; advance character buffer tail pointer
	pop	bx
	ret
;-------------------------------;
; Interrupt comes every 2 milisec
;-------------------------------;
trd_table:			; typematic rate delay 250/500/750/1000 milisec
%out periodic interrupt every 16 milisec
;;;;	dw	125,250,375,500
	dw	16,32,48,64
tr_table:			; typematic rate 2..30 characters/sec
%out repeat rate is always 30 char/sec
;;;;	dw	016,020,025,031,038,046,055,064,	072,080,088,096,104,112,120,128
;;;;	dw	136,144,152,160,168,176,184,192,	200,208,216,224,232,240,248,256
	dw	2,2,2,2,	2,2,2,2,	2,2,2,2,	2,2,2,2
	dw	2,2,2,2,	2,2,2,2,	2,2,2,2,	2,2,2,2
;-------------------------------;
key_pad_scan_2_table:
	db	endx, left, home, insr, del, down, rght, up, pgdn, pgup
key_pad_scan_2_table_end:
key_pad_scan_3_table:
	db	65h, 61h, 6eh, 67h, 64h, 60h, 6ah, 63h, 6dh, 6fh
key_pad_scan_3_table_end:
;-------------------------------;
extd_key_scan_2_table:
	db	ralt, rctl, renter, lmsft, rmsft, amsft
extd_key_scan_2_table_end:
extd_key_scan_3_table:
	db	39h, 58h, 79h, 8bh, 8ch, 8dh
extd_key_scan_3_table_end:
;-------------------------------;
extd_scan_3_data:
	db	84h,85h,86h,87h
	db	8bh,8ch,8dh
extd_scan_3_data_end:
extd_scan_3_new:
	db	0,1,2,3,4,5,6
extd_scan_3_new_end:
;-------------------------------;
modifier_key_table:
	db	0e0h,0e1h,0e2h,0e3h,0e4h,0e5h,0e6h,0e7h
;-------------------------------;
scan_3_table_data:
	db	000h,015h,000h,028h,094h,029h,0a4h,02ah
	db	0a8h,02ah,0a8h,02ah,0a8h,02ah,0a0h,02ah
	db	0a8h,02ah,0a8h,02ah,0a8h,00ah,0a4h,00ah
	db	08ah,022h,020h,000h,000h,000h,000h,002h
;-------------------------------;
t2223:
	db	2,2,2,3
t6800:
	db	6,8,0,0
t4500:
	db	4,5,0,0
t4545:
	db	4,5,4,5
t4446:
	db	4,4,4,6
t1112:
	db	1,1,1,2
;===============================;
USBKeyCode_to_Scan_2_table:
;------ USA ENGLISH keyboard -------; USBKeyCode to ScanCodeSet-2
	db    00h,00h,00h,00h,1ch,32h,21h,23h,	24h,2bh,34h,33h,43h,3bh,42h,4bh
	db    3ah,31h,44h,4dh,15h,2dh,1bh,2ch,	3ch,2ah,1dh,22h,35h,1ah,16h,1eh
	db    26h,25h,2eh,36h,3dh,3eh,46h,45h,	5ah,76h,66h,0dh,29h,4eh,55h,54h
	db    5bh,5dh,5dh,4ch,52h,0eh,41h,49h,	4ah,58h,05h,06h,04h,0ch,03h,0bh
	db  83h,0ah,01h,09h,78h,07h,prtsc,7eh,	pause,insr,home,pgup,del,endx,pgdn,rght
	db left,down,up,77h,slash,7ch,7bh,79h,	renter,69h,72h,7ah,6bh,73h,74h,6ch
	db  75h,7dh,70h,71h,61h,amsft,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h
	db    00h,00h,00h,00h,00h,00h,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h

	db    00h,00h,00h,00h,00h,00h,00h,51h,	13h,6ah,64h,67h,00h,00h,00h,00h
	db    00h,00h,00h,00h,00h,00h,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h
	db    00h,00h,00h,00h,00h,00h,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h
	db    00h,00h,00h,00h,00h,00h,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h
	db    00h,00h,00h,00h,00h,00h,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h
	db    00h,00h,00h,00h,00h,00h,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h
	db 14h,12h,11h,lmsft,rctl,59h,ralt,rmsft,	00h,00h,00h,00h,00h,00h,00h,00h
	db    00h,00h,00h,00h,00h,00h,00h,00h,	00h,00h,00h,00h,00h,00h,00h,00h
;===============================;
;-------------------------------;
set_2_to_1:
;-------------------------------;
KEY0		db	000h	;
KEY1		db	0E5h	;
KEY2		db	0F5h	;
KEY3		db	006h	;
KEY4		db	016h	;
KEY5		db	026h	;
KEY6		db	01Eh	;
KEY7		db	03Dh	;
KEY8		db	0DCh	;
KEY9		db	0DDh	;
KEYA		db	0EDh	;
KEYB		db	0FDh	;
KEYC		db	00Eh	;
KEYD		db	087h	;
KEYE		db	0B6h	;
KEYF		db	035h	;
KEY10		db	0D4h	;
KEY11		db	03Eh	;
KEY12		db	0AEh	;
KEY13		db	07Ch	;
KEY14		db	017h	;
KEY15		db	07Fh	;
KEY16		db	0EFh	;
KEY17		db	02Dh	;
KEY18		db	0CCh	;
KEY19		db	074h	;
KEY1A		db	09Eh	;
KEY1B		db	007h	;
KEY1C		db	00Fh	;
KEY1D		db	077h	;
KEY1E		db	0E7h	;
KEY1F		db	025h	;
KEY20		db	0C4h	;
KEY21		db	08Eh	;
KEY22		db	096h	;
KEY23		db	0FEh	;
KEY24		db	06Fh	;
KEY25		db	0D7h	;
KEY26		db	0DFh	;
KEY27		db	01Dh	;
KEY28		db	0BCh	;
KEY29		db	036h	;
KEY2A		db	086h	;
KEY2B		db	0F6h	;
KEY2C		db	05Fh	;
KEY2D		db	067h	;
KEY2E		db	0CFh	;
KEY2F		db	015h	;
KEY30		db	0B4h	;
KEY31		db	076h	;
KEY32		db	07Eh	;
KEY33		db	0E6h	;
KEY34		db	0EEh	;
KEY35		db	057h	;
KEY36		db	0C7h	;
KEY37		db	00Dh	;
KEY38		db	0ACh	;
KEY39		db	06Ch	;
KEY3A		db	06Eh	;
KEY3B		db	0DEh	;
KEY3C		db	04Fh	;
KEY3D		db	0BFh	;
KEY3E		db	0B7h	;
KEY3F		db	005h	;
KEY40		db	0A4h	;
KEY41		db	066h	;
KEY42		db	0D6h	;
KEY43		db	047h	;
KEY44		db	03Fh	;
KEY45		db	0A7h	;
KEY46		db	0AFh	;
KEY47		db	0FCh	;
KEY48		db	09Ch	;
KEY49		db	05Eh	;
KEY4A		db	056h	;
KEY4B		db	0CEh	;
KEY4C		db	0C6h	;
KEY4D		db	037h	;
KEY4E		db	09Fh	;
KEY4F		db	0F4h	;
KEY50		db	094h	;
KEY51		db	064h	;
KEY52		db	0BEh	;
KEY53		db	05Ch	;
KEY54		db	02Fh	;
KEY55		db	097h	;
KEY56		db	0ECh	;
KEY57		db	08Ch	;
KEY58		db	02Eh	;
KEY59		db	04Eh	;
KEY5A		db	01Fh	;
KEY5B		db	027h	;
KEY5C		db	054h	;
KEY5D		db	0A6h	;
KEY5E		db	0E4h	;
KEY5F		db	04Ch	;
KEY60		db	055h	;
KEY61		db	04Dh	;
KEY62		db	044h	;
KEY63		db	03Ch	;
KEY64		db	034h	;
KEY65		db	02Ch	;
KEY66		db	08Fh	;
KEY67		db	024h	;
KEY68		db	01Ch	;
KEY69		db	085h	;
KEY6A		db	014h	;
KEY6B		db	0A5h	;
KEY6C		db	0C5h	;
KEY6D		db	00Ch	;
KEY6E		db	004h	;
KEY6F		db	084h	;
KEY70		db	06Dh	;
KEY71		db	065h	;
KEY72		db	07Dh	;
KEY73		db	09Dh	;
KEY74		db	095h	;
KEY75		db	0BDh	;
KEY76		db	0F7h	;
KEY77		db	0D5h	;
KEY78		db	045h	;
KEY79		db	08Dh	;
KEY7A		db	075h	;
KEY7B		db	0ADh	;
KEY7C		db	046h	;
KEY7D		db	0B5h	;
KEY7E		db	0CDh	;
KEY7F		db	05Dh	;
KEY80		db	0FBh	;
KEY81		db	0F3h	;
KEY82		db	0EBh	;
KEY83		db	0F5h	;
KEY84		db	05Dh	;
;-------------------------------;
set_2_to_3:
;-------------------------------;
YKEY0		db	000h	;
YKEY1		db	0C5h	;
YKEY2		db	046h	;
YKEY3		db	0C6h	;
YKEY4		db	047h	;
YKEY5		db	0C7h	;
YKEY6		db	087h	;
YKEY7		db	00Dh	;
YKEY8		db	0BFh	;
YKEY9		db	085h	;
YKEYA		db	006h	;
YKEYB		db	086h	;
YKEYC		db	007h	;
YKEYD		db	097h	;
YKEYE		db	08Fh	;
YKEYF		db	087h	;
YKEY10		db	07Fh	;
YKEY11		db	037h	;
YKEY12		db	06Fh	;
YKEY13		db	0C3h	;
YKEY14		db	077h	;
YKEY15		db	057h	;
YKEY16		db	04Fh	;
YKEY17		db	047h	;
YKEY18		db	03Fh	;
YKEY19		db	037h	;
YKEY1A		db	02Fh	;
YKEY1B		db	027h	;
YKEY1C		db	01Fh	;
YKEY1D		db	017h	;
YKEY1E		db	00Fh	;
YKEY1F		db	0A3h	;
YKEY20		db	0FEh	;
YKEY21		db	0F6h	;
YKEY22		db	0EEh	;
YKEY23		db	0E6h	;
YKEY24		db	0DEh	;
YKEY25		db	0D6h	;
YKEY26		db	0CEh	;
YKEY27		db	09Bh	;
YKEY28		db	0BEh	;
YKEY29		db	0B6h	;
YKEY2A		db	0AEh	;
YKEY2B		db	0A6h	;
YKEY2C		db	09Eh	;
YKEY2D		db	096h	;
YKEY2E		db	08Eh	;
YKEY2F		db	093h	;
YKEY30		db	07Eh	;
YKEY31		db	076h	;
YKEY32		db	06Eh	;
YKEY33		db	066h	;
YKEY34		db	05Eh	;
YKEY35		db	056h	;
YKEY36		db	04Eh	;
YKEY37		db	046h	;
YKEY38		db	03Eh	;
YKEY39		db	036h	;
YKEY3A		db	02Eh	;
YKEY3B		db	026h	;
YKEY3C		db	01Eh	;
YKEY3D		db	016h	;
YKEY3E		db	00Eh	;
YKEY3F		db	006h	;
YKEY40		db	0FDh	;
YKEY41		db	0F5h	;
YKEY42		db	0EDh	;
YKEY43		db	0E5h	;
YKEY44		db	0DDh	;
YKEY45		db	0D5h	;
YKEY46		db	0CDh	;
YKEY47		db	0C5h	;
YKEY48		db	0BDh	;
YKEY49		db	0B5h	;
YKEY4A		db	0ADh	;
YKEY4B		db	0A5h	;
YKEY4C		db	09Dh	;
YKEY4D		db	095h	;
YKEY4E		db	08Dh	;
YKEY4F		db	085h	;
YKEY50		db	07Dh	;
YKEY51		db	075h	;
YKEY52		db	06Dh	;
YKEY53		db	065h	;
YKEY54		db	05Dh	;
YKEY55		db	055h	;
YKEY56		db	04Dh	;
YKEY57		db	045h	;
YKEY58		db	05Fh	;
YKEY59		db	035h	;
YKEY5A		db	02Dh	;
YKEY5B		db	025h	;
YKEY5C		db	01Dh	;
YKEY5D		db	065h	;
YKEY5E		db	00Dh	;
YKEY5F		db	005h	;
YKEY60		db	0FCh	;
YKEY61		db	067h	;
YKEY62		db	0ECh	;
YKEY63		db	0E4h	;
YKEY64		db	0CBh	;
YKEY65		db	0D4h	;
YKEY66		db	0CCh	;
YKEY67		db	0D3h	;
YKEY68		db	0BCh	;
YKEY69		db	0B4h	;
YKEY6A		db	015h	;
YKEY6B		db	0A4h	;
YKEY6C		db	09Ch	;
YKEY6D		db	094h	;
YKEY6E		db	08Ch	;
YKEY6F		db	084h	;
YKEY70		db	07Ch	;
YKEY71		db	074h	;
YKEY72		db	06Ch	;
YKEY73		db	064h	;
YKEY74		db	05Ch	;
YKEY75		db	054h	;
YKEY76		db	0BFh	;
YKEY77		db	04Ch	;
YKEY78		db	04Dh	;
YKEY79		db	01Ch	;
YKEY7A		db	02Ch	;
YKEY7B		db	0DBh	;
YKEY7C		db	00Ch	;
YKEY7D		db	014h	;
YKEY7E		db	005h	;
YKEY7F		db	05Dh	;
YKEY80		db	0FBh	;
YKEY81		db	0F3h	;
YKEY82		db	0EBh	;
YKEY83		db	046h	;
YKEY84		db	045h	;
;===============================;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;-------------------------------;
;-------------------------------;
;===============================;
;-------------------------------;
; 00..1F	READ RAM	;
; 20..3F	READ RAM	;
; 40..5F	WRITE RAM	;
; 60..7F	WRITE RAM	;
; 80..9F	INVALID		;
; A0..FF	COMMAND		;
;-------------------------------;
out_64:
	or	flag_byte_1,80h	; 1=64/60 emulation active
	mov	flag_60,0000h	; clear flag
	or	al,al
	js	o64_0		; 80..FF
	cmp	al,40h
	jae	o64_1		; 40..7F write RAM
;===============================;
; WindowsNT gets timeout error	;
; since data is returned after	;
; 1 to 2 milisec inside periodic;
; interrupt. so send call to
; 8042 now, we will see later	;
; what can be done when 8042 is	;
; not there in the mother board.;
;===============================;
;;;;	and	al,1fh
;;;;	mov	bx,offset ccb
;;;;	xlat			; read RAM
;;;;	jmp	kb_sys		; output to system as keyboard data
;===============================;
	call	out_to_64	; send command to 8042
	ret			; exit
o64_1:
	call	out_to_64	; send command to 8042
	and	al,1fh
	mov	ram_address,al	; save RAM address
	mov	flag_60,offset cgroup:o64_2+orgbase
	ret			; exit
o64_2:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	mov	bl,ram_address
	xor	bh,bh
	mov	[bx+ccb],al	; store data
o64_3:
	ret			; exit
o64_0:
	mov	bl,al		; save (al)
	sub	al,0a0h
	jc	o64_3		; 80..9F invalid command
	cbw
	shl	ax,1
	xchg	ax,bx		; (al) = A0..FF
	jmp	[bx+cgroup:table_64+orgbase]	; A0..FF
;===============================;
xa0:
xa1:
xa2:
xa3:

xb0:
xb1:
xb2:
xb3:
xb4:
xb5:
xb6:
xb7:
xb8:
xb9:
xba:
xbb:
xbc:
xbd:
xbe:
xbf:

xc2:
xc3:
xc4:
xc5:
xc6:
xc7:
xc8:
xc9:
xca:

xcc:
xcd:
xce:
xcf:

xd5:
xd6:
xd7:
xd8:
xd9:
xda:
xdb:
xdc:
xdd:
xde:
xdf:

xe1:
xe2:
xe3:
xe4:
xe5:
xe6:
xe7:
xe8:
xe9:
xea:
xeb:
xec:
xed:
xee:
xef:
xf0:
xf1:
xf2:
xf3:
xf4:
xf5:
xf6:
xf7:
xf8:
xf9:
xfa:
xfb:
xfc:
xfd:
xfe:
xff:
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xa4:
;===============================;
;;;;	cmp	password_start,00h
;;;;	mov	al,0f1h
;;;;	jz	xa4_1		; F1 = password not installed
;;;;	mov	al,0fah		; FA = password installed
;;;;xa4_1:
;;;;	jmp	kb_sys		; output to system as keyboard data
;===============================;
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xa5:
	call	out_to_64	; send command to 8042
	mov	password_ptr,offset password_start
	mov	flag_60,offset cgroup:xa5_1+orgbase
	ret			; exit
xa5_1:
	call	out_to_60	; send data to 8042
	mov	di,password_ptr
	stosb
	or	al,al
	jz	xa5_2		; password load over
	mov	password_ptr,di
	cmp	di,offset password_end
	jnz	xa5_3
	mov	password_ptr,offset password_start
xa5_2:
	and	scanner_flag,(not a6_flag_bitx); A6 flag = 0, password inactive
	mov	flag_60,0000h	; clear flag
xa5_3:
	ret			; exit
;-------------------------------;
xa6:
	call	out_to_64	; send command to 8042
	cmp	password_start,00h
	jz	xa5_3		; no password, exit
	or	scanner_flag,a6_flag_bitx	; A6 flag = 1, password active
	mov	password_ptr,offset password_start
	ret			; exit
;-------------------------------;
xa7:
	or	ccb,20h		; disable mouse
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xa8:
	and	ccb,0dfh	; enable mouse
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xa9:
;;;;	mov	al,00h
;;;;	jmp	kb_sys		; output to system as keyboard data
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xaa:
	mov	password_start,00h	; clear password
	mov	output_port,0dfh
	mov	ccb,030h	; disable mouse,KB
;===============================;
;;;;	out	64h,al		; send command to 8042
;;;;	xor	cx,cx
;;;;xaa_1:
;;;;	in	al,64h
;;;;	test	al,1
;;;;	loopz	xaa_1
;;;;	mov	flag_8042,00h	; 8042 not present
;;;;	jz	xaa_2
;;;;	in	al,60h
;;;;	cmp	al,55h
;;;;	jnz	xaa_2
;;;;	mov	flag_8042,0ffh	; 8042 present
;;;;xaa_2:
;;;;	mov	al,55h
;;;;	jmp	kb_sys		; output to system as keyboard data
;===============================;
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xab:
;;;;	mov	al,00h
;;;;	jmp	kb_sys		; output to system as keyboard data
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xac:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xac_1+orgbase
	ret			; exit
xac_1:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	ret
;-------------------------------;
xad:
	or	ccb,10h		; disable keyboard
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xae:
	and	ccb,0efh	; enable keyboard
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xaf:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xaf_1+orgbase
	ret			; exit
xaf_1:
	call	out_to_60	; send data to 8042
	mov	flag_60,offset cgroup:xaf_2+orgbase
	ret			; exit
xaf_2:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	ret
;-------------------------------;
xc0:
;;;;	mov	ah,0ffh		; input port data
;;;;	jmp	xc0xd0_1
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xc1:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xc1_1+orgbase
	ret			; exit
xc1_1:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	ret
;-------------------------------;
xcb:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xcb_1+orgbase
	ret			; exit
xcb_1:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	ret
;-------------------------------;
xd0:
;;;;	mov	ah,output_port	; output port data
;;;;xc0xd0_1:
;;;;	call	out_to_64	; send command to 8042
;;;;	call	in_from_60	; read data from 8042
;;;;	jnz	xc0xd0_2
;;;;	mov	al,ah
;;;;xc0xd0_2:
;;;;	jmp	kb_sys		; output to system as keyboard data
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
xd1:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xd1_1+orgbase
	ret			; exit
xd1_1:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	mov	output_port,al
	ret			; exit
;-------------------------------;
xd2:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xd2_1+orgbase
	ret			; exit
xd2_1:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	ret			; exit
;-------------------------------;
xd3:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xd3_1+orgbase
	ret			; exit
xd3_1:
	mov	flag_60,0000h	; clear flag
	call	out_to_60	; send data to 8042
	ret			; exit
;-------------------------------;
xd4:
	call	out_to_64	; send command to 8042
	mov	flag_60,offset cgroup:xd4_1+orgbase
	ret			; exit
xd4_1:
	mov	flag_60,0000h	; clear flag
	and	ccb,0dfh	; enable mouse
;;;;	call	out_to_60	; send data to 8042
	call	process_mouse
	ret			; exit
;-------------------------------;
xe0:
;;;;	mov	al,00h
;;;;	jmp	kb_sys		; output to system as keyboard data
	call	out_to_64	; send command to 8042
	ret			; exit
;-------------------------------;
;===============================;
;-------------------------------;
out_60:
	or	flag_byte_1,80h	; 1=64/60 emulation active
	cmp	flag_60,0000h
	jz	o60_1		; no routine address
	jmp	flag_60		; goto proper routine
o60_1:
	and	ccb,0efh	; enable keyboard interface
	mov	bx,ax		; save 60 command
	call	out_to_60	; send data to 8042
	in	al,64h
	mov	ah,al		; save status
	test	al,1
	jz	o60_3		; no data
	in	al,60h
o60_3:
	xchg	al,ah
	push	ax		; save data, status
	call	in_from_60	; read data from 8042
	jnz	o60_2		; valid data
	mov	al,0feh		; timeout
o60_2:
	mov	ext_kb_char,al	; save output
	mov	ax,bx		; restore 60 command
	push	ax
	sub	al,0edh
	mov	bx,offset cgroup:jmp_table_60+orgbase
	jnc	ibf_60x		; command (ED...FF)
	mov	al,kbms_command_status
	and	al,07h		; non-zero means command followed by data
	mov	bx,offset cgroup:jmp_table_60_60+orgbase
ibf_60x:
	and	kbms_command_status,0f8h ; clear kb command flag
	cbw
	shl	ax,1
	add	bx,ax
	pop	ax
	call	cs:word ptr[bx]
	pop	ax		; restore data, status
	test	al,01h
	jz	o60_5		; no data
	test	al,20h
	mov	al,0d2h		; keyboard data
	jz	o60_4
	mov	al,0d3h		; mouse data
o60_4:
	call	sis_write_kb_cntlr_data
o60_5:
	ret
;-------------------------------;
zef:
zf1:
zed_ff_00:
zed_ff_07:
;'	mov	ah,ext_kb_char	; restore external keyboard response
;'	mov	al,0d2h
;'	call	sis_write_kb_cntlr_data
;'	ret
;===============================;
	mov	al,01h		; 1 byte required
	call	check_cbfull
	jz	zef_0		; character buffer full, error
	mov	al,ext_kb_char	; restore external keyboard response
	call	put_char_buffer
zef_0:
	ret			; exit
;===============================;
;-------------------------------;
zed:				; set/reset LED status indicator
	mov	al,ed_flag
	jmp	zed_ff		; send FA
zed_60:
;===============================;
;;;;	mov	ah,al		; save data, valid data 0..7
;;;;	add	al,0f8h		; Caps-lock, Num-lock, Scroll-lock (IBM)
;;;;	jc	zed_ff_00	; out of range
;;;;	mov	al,ah		; restore data
;===============================;
	and	al,07h
	shr	al,1		; convert to Scroll-lock, Caps-lock, Num-lock
	jnc	zed_60_1
	or	al,04h
zed_60_1:
	shl	al,4
	and	flag_byte_1,08fh
	or	flag_byte_1,al
	call	OneSecondPeriodicHandler
	jmp	zed_ff_1	; send FA
;-------------------------------;
zee:				; echo
;'	mov	ax,0eed2h
;'	call	sis_write_kb_cntlr_data
;'	ret
;===============================;
	mov	al,01h		; 1 byte required
	call	check_cbfull
	jz	zee_0		; character buffer full, error
	mov	al,0eeh		; echo
	call	put_char_buffer
zee_0:
	ret			; exit
;===============================;
;-------------------------------;
zf0:				; select alternate scan code
	mov	al,f0_flag
	jmp	zed_ff		; send FA
zf0_60:
	mov	ah,al		; valid data = 0..3
	add	al,0fch
	jc	zed_ff_00	; out of range
	mov	al,ah
	or	al,al
	jz	zf0_60_1	; return current scan code
	and	scanner_flag,0fch
	or	scanner_flag,al	; set new scan code
	jmp	zed_ff_1	; send FA
zf0_60_1:
	call	consume_ext_kb_char; consume external keyboard data (current scan code set)
	call	put_char_fa	; send FA first
	mov	al,01h		; 1 byte required
	call	check_cbfull
	jz	zf0_60_2	; character buffer full, error
	mov	al,scanner_flag
	and	al,03h		; current scan code set-1/2/3
	test	ccb,40h
	jz	zf0_60_3	; do not convert to scan code set 1
	call	get_scan_code_1
zf0_60_3:
	call	put_char_buffer
zf0_60_2:
	ret
;-------------------------------;
zf2:				; read keyboard id
	call	consume_ext_kb_char; consume external keyboard data (AB)
	call	consume_ext_kb_char; consume external keyboard data (83/41)
	call	put_char_fa	; send FA first
	mov	al,02h		; 2 byte required
	call	check_cbfull
	jz	zf2_1		; character buffer full, error
	mov	al,0abh		; first id. = AB
	call	put_char_buffer
	mov	al,83h		; second id. = 83 or 41
	test	ccb,40h
	jz	zf2_2		; do not convert to scan code set 1
	call	get_scan_code_1
zf2_2:
	call	put_char_buffer
zf2_1:
	ret
;-------------------------------;
zf3:				; set typematic/rate delay
	mov	al,f3_flag
	jmp	zed_ff		; send FA
zf3_60:
	or	al,al		; valid data = 00..7F
	js	zed_ff_00	; out of range
	and	typematic_rate,auto_repeat_bitx
	or	typematic_rate,al
	jmp	zed_ff_1	; send FA
;-------------------------------;
zf4:
	and	scanner_flag,(not scanner_bitx); enable scanner
	call	enable_usb_scanner
	jmp	zf4_fa
;-------------------------------;
zf5:
	or	scanner_flag,scanner_bitx	; disable scanner
	call	disable_usb_scanner
zf6:
	call	init_typematic_scan_3	; init typematic/rate, scan-3 table
	jmp	zf4_fa
;-------------------------------;
zf7:				; set all keys to Typematic
	mov	al,0aah
	jmp	zf7_fa
zf8:				; set all keys to Make/Break
	mov	al,055h
	jmp	zf7_fa
zf9:				; set all keys to Make
	mov	al,000h
	jmp	zf7_fa
zfa:				; set all keys to Typematic/Make/Break
	mov	al,0ffh
zf7_fa:
	mov	di,offset scan_3_table
	mov	cx,32		; 32 * 4 = 128 scan codes
	rep	stosb
zf4_fa:
	call	init_char_buff	; init character buffer
	jmp	zed_ff_1	; send FA
;-------------------------------;
zfb:				; set key type = Typematic
	mov	al,fb_flag
	jmp	zed_ff		; send FA
zfb_60:
	mov	ah,02h		; TYPEMATIC
	jmp	zfb_fd
;-------------------------------;
zfc:				; set key type = Make/Break
	mov	al,fc_flag
	jmp	zed_ff		; send FA
zfc_60:
	mov	ah,01h		; MAKE/ BREAK
	jmp	zfb_fd
;-------------------------------;
zfd:				; set key type = Make
	mov	al,fd_flag
	jmp	zed_ff		; send FA
zfd_60:
	mov	ah,00h		; MAKE
zfb_fd:
	or	al,al		; valid data = 00..7f,84,85,86,87,8B,8C,8D
	jns	zfb_fd_1
	call	check_get_extd_scan_3_new
zfb_fd_1:
	call	write_code_3_value
	or	scanner_flag,scanner_bitx	; disable scanner
	call	disable_usb_scanner
	jmp	zed_ff_1	; send FA
;===============================;
zed_ff:
	and	kbms_command_status,0f8h
	or	kbms_command_status,al
zed_ff_1:
;'	mov	ax,0fad2h
;'	call	sis_write_kb_cntlr_data
;'	ret
;===============================;
put_char_fa:
	mov	al,01h		; 1 byte required
	call	check_cbfull
	jz	zed_ff_2	; character buffer full, error
	mov	al,0fah		; FA acknowledge
	call	put_char_buffer
zed_ff_2:
	ret			; exit
;===============================;
;-------------------------------;
zfe:				; resend
	mov	al,port_60_char
	jmp	kb_sys		; output to system as keyboard data
;-------------------------------;
zff:
	call	consume_ext_kb_char; consume external keyboard data
	and	scanner_flag,0fch
	or	scanner_flag,02h ; default scan code set-2
	and	flag_byte_1,80h
	mov	flag_byte,00h	; led,alt,ctrl,shift status = 0
	call	init_typematic_scan_3	; init typematic/rate, scan-3 table
	call	init_scan_char_buff	; init scanner/character buffer
	and	scanner_flag,(not scanner_bitx)	; enable scanner
	call	enable_usb_scanner
	mov	cx,offset device_list_end - offset device_list
	mov	di,offset device_list
	mov	al,00h
	repz	scasb
	jnz	zff_2		; device found
	cmp	ext_kb_char,0fah ; response from external keyboard
	jz	zff_2		; if ACK, assume ext. kb present
	mov	al,0feh
	call	put_char_buffer
	ret
zff_2:
	call	put_char_fa	; send FA first
	mov	al,01h		; 1 byte required
	call	check_cbfull
	jz	zff_1		; character buffer full, error
	mov	al,0aah		; bat result = AA
	call	put_char_buffer
zff_1:
	ret
;-------------------------------;
;===============================;
;-------------------------------;
;	KB_SYS			;
;-------------------------------;
kb_sys:
	mov	ah,al
	mov	al,01h		; 1 byte required
	call	check_cbfull
	jz	kbsys_1		; character buffer full, error
	mov	al,ah
	call	put_char_buffer
kbsys_1:
	ret
;-------------------------------;
;	CONSUME_EXT_KB_CHAR	;
;-------------------------------;
consume_ext_kb_char:
	cmp	ext_kb_char,0fah ; response from external keyboard
	jnz	cec_5		; if no ACK, assume no ext. kb
	call	in_from_60	; read data from 8042
cec_5:
	ret
;-------------------------------;
;	ENABLE_USB SCANNER	;
;	DISABLE_USB SCANNER	;
;-------------------------------;
enable_usb_scanner:
	ret
disable_usb_scanner:
	ret
;-------------------------------;
;	PROCESS MOUSE		;
;-------------------------------;
process_mouse:
	mov	ms_buff_head,offset ms_buff_start
	mov	ms_buff_tail,offset ms_buff_start
	mov	bx,offset ms_buff_start
	mov	byte ptr ds:[bx],0fah	; ACK
	add	bx,1
	cmp	al,0e9h		; return status
	jnz	pm_2
	mov	byte ptr ds:[bx],00h
	mov	word ptr ds:[bx+1],2803h
	add	bx,3
	jmp	short pm_0
pm_2:
	cmp	al,0ebh		; read data
	jnz	pm_3
	mov	byte ptr ds:[bx],00h
	mov	word ptr ds:[bx+1],0000h
	add	bx,3
	jmp	short pm_0
pm_3:
	cmp	al,0f2h		; read device type
	jnz	pm_4
	mov	byte ptr ds:[bx],00h
	add	bx,1
	jmp	short pm_0
pm_4:
	cmp	al,0ffh		; device reset
	jnz	pm_5
	mov	word ptr ds:[bx],00aah
	add	bx,2
	jmp	short pm_7
pm_5:
	cmp	al,0f4h		; enable device
	jnz	pm_6
	or	kbmsflag,40h	; enable mouse
	jmp	short pm_0
pm_6:
	cmp	al,0f5h		; set default
	jz	pm_7
	cmp	al,0f6h		; disable device
	jnz	pm_0
pm_7:
	and	kbmsflag,0bfh	; disable mouse
pm_0:
	push	ds
	push	0f000h
	pop	ds
	test	byte ptr ds:[0e2c2h],40h ; true PS/2 mouse
	pop	ds
	jnz	pm_1		; PS/2 mouse present
	push	ds
	push	40h
	pop	ds
	test	byte ptr ds:[10h],04h	; USB mouse
	pop	ds
	jz	pm_1		; both mouse absent
	mov	ms_buff_head,bx	; update mouse buffer
	or	kbmsflag,08h	; mouse data ready
	mov	al,0a8h
	call	out_to_64	; enable mouse interface
	call	EnablePeriodicInterrupt
	ret
pm_1:
	call	out_to_60	; send data to 8042
	ret
;-------------------------------;
;===============================;
table_64	label	word
	dw	offset cgroup:xa0+orgbase	; A0
	dw	offset cgroup:xa1+orgbase	; A1
	dw	offset cgroup:xa2+orgbase	; A2
	dw	offset cgroup:xa3+orgbase	; A3
	dw	offset cgroup:xa4+orgbase	; A4
	dw	offset cgroup:xa5+orgbase	; A5
	dw	offset cgroup:xa6+orgbase	; A6
	dw	offset cgroup:xa7+orgbase	; A7
	dw	offset cgroup:xa8+orgbase	; A8
	dw	offset cgroup:xa9+orgbase	; A9
	dw	offset cgroup:xaa+orgbase	; AA
	dw	offset cgroup:xab+orgbase	; AB
	dw	offset cgroup:xac+orgbase	; AC
	dw	offset cgroup:xad+orgbase	; AD
	dw	offset cgroup:xae+orgbase	; AE
	dw	offset cgroup:xaf+orgbase	; AF
	dw	offset cgroup:xb0+orgbase	; B0
	dw	offset cgroup:xb1+orgbase	; B1
	dw	offset cgroup:xb2+orgbase	; B2
	dw	offset cgroup:xb3+orgbase	; B3
	dw	offset cgroup:xb4+orgbase	; B4
	dw	offset cgroup:xb5+orgbase	; B5
	dw	offset cgroup:xb6+orgbase	; B6
	dw	offset cgroup:xb7+orgbase	; B7
	dw	offset cgroup:xb8+orgbase	; B8
	dw	offset cgroup:xb9+orgbase	; B9
	dw	offset cgroup:xba+orgbase	; BA
	dw	offset cgroup:xbb+orgbase	; BB
	dw	offset cgroup:xbc+orgbase	; BC
	dw	offset cgroup:xbd+orgbase	; BD
	dw	offset cgroup:xbe+orgbase	; BE
	dw	offset cgroup:xbf+orgbase	; BF
	dw	offset cgroup:xc0+orgbase	; C0
	dw	offset cgroup:xc1+orgbase	; C1
	dw	offset cgroup:xc2+orgbase	; C2
	dw	offset cgroup:xc3+orgbase	; C3
	dw	offset cgroup:xc4+orgbase	; C4
	dw	offset cgroup:xc5+orgbase	; C5
	dw	offset cgroup:xc6+orgbase	; C6
	dw	offset cgroup:xc7+orgbase	; C7
	dw	offset cgroup:xc8+orgbase	; C8
	dw	offset cgroup:xc9+orgbase	; C9
	dw	offset cgroup:xca+orgbase	; CA
	dw	offset cgroup:xcb+orgbase	; CB
	dw	offset cgroup:xcc+orgbase	; CC
	dw	offset cgroup:xcd+orgbase	; CD
	dw	offset cgroup:xce+orgbase	; CE
	dw	offset cgroup:xcf+orgbase	; CF
	dw	offset cgroup:xd0+orgbase	; D0
	dw	offset cgroup:xd1+orgbase	; D1
	dw	offset cgroup:xd2+orgbase	; D2
	dw	offset cgroup:xd3+orgbase	; D3
	dw	offset cgroup:xd4+orgbase	; D4
	dw	offset cgroup:xd5+orgbase	; D5
	dw	offset cgroup:xd6+orgbase	; D6
	dw	offset cgroup:xd7+orgbase	; D7
	dw	offset cgroup:xd8+orgbase	; D8
	dw	offset cgroup:xd9+orgbase	; D9
	dw	offset cgroup:xda+orgbase	; DA
	dw	offset cgroup:xdb+orgbase	; DB
	dw	offset cgroup:xdc+orgbase	; DC
	dw	offset cgroup:xdd+orgbase	; DD
	dw	offset cgroup:xde+orgbase	; DE
	dw	offset cgroup:xdf+orgbase	; DF
	dw	offset cgroup:xe0+orgbase	; E0
	dw	offset cgroup:xe1+orgbase	; E1
	dw	offset cgroup:xe2+orgbase	; E2
	dw	offset cgroup:xe3+orgbase	; E3
	dw	offset cgroup:xe4+orgbase	; E4
	dw	offset cgroup:xe5+orgbase	; E5
	dw	offset cgroup:xe6+orgbase	; E6
	dw	offset cgroup:xe7+orgbase	; E7
	dw	offset cgroup:xe8+orgbase	; E8
	dw	offset cgroup:xe9+orgbase	; E9
	dw	offset cgroup:xea+orgbase	; EA
	dw	offset cgroup:xeb+orgbase	; EB
	dw	offset cgroup:xec+orgbase	; EC
	dw	offset cgroup:xed+orgbase	; ED
	dw	offset cgroup:xee+orgbase	; EE
	dw	offset cgroup:xef+orgbase	; EF
	dw	offset cgroup:xf0+orgbase	; F0
	dw	offset cgroup:xf1+orgbase	; F1
	dw	offset cgroup:xf2+orgbase	; F2
	dw	offset cgroup:xf3+orgbase	; F3
	dw	offset cgroup:xf4+orgbase	; F4
	dw	offset cgroup:xf5+orgbase	; F5
	dw	offset cgroup:xf6+orgbase	; F6
	dw	offset cgroup:xf7+orgbase	; F7
	dw	offset cgroup:xf8+orgbase	; F8
	dw	offset cgroup:xf9+orgbase	; F9
	dw	offset cgroup:xfa+orgbase	; FA
	dw	offset cgroup:xfb+orgbase	; FB
	dw	offset cgroup:xfc+orgbase	; FC
	dw	offset cgroup:xfd+orgbase	; FD
	dw	offset cgroup:xfe+orgbase	; FE
	dw	offset cgroup:xff+orgbase	; FF
;-------------------------------;
jmp_table_60:
	dw	offset cgroup:zed+orgbase	; ED
	dw	offset cgroup:zee+orgbase	; EE
	dw	offset cgroup:zef+orgbase	; EF
	dw	offset cgroup:zf0+orgbase	; F0
	dw	offset cgroup:zf1+orgbase	; F1
	dw	offset cgroup:zf2+orgbase	; F2
	dw	offset cgroup:zf3+orgbase	; F3
	dw	offset cgroup:zf4+orgbase	; F4
	dw	offset cgroup:zf5+orgbase	; F5
	dw	offset cgroup:zf6+orgbase	; F6
	dw	offset cgroup:zf7+orgbase	; F7
	dw	offset cgroup:zf8+orgbase	; F8
	dw	offset cgroup:zf9+orgbase	; F9
	dw	offset cgroup:zfa+orgbase	; FA
	dw	offset cgroup:zfb+orgbase	; FB
	dw	offset cgroup:zfc+orgbase	; FC
	dw	offset cgroup:zfd+orgbase	; FD
	dw	offset cgroup:zfe+orgbase	; FE
	dw	offset cgroup:zff+orgbase	; FF
;-------------------------------;
jmp_table_60_60:
	dw	offset cgroup:zed_ff_00+orgbase	; invalid
	dw	offset cgroup:zed_60+orgbase	; ED
	dw	offset cgroup:zf0_60+orgbase	; F0
	dw	offset cgroup:zf3_60+orgbase	; F3
	dw	offset cgroup:zfb_60+orgbase	; FB
	dw	offset cgroup:zfc_60+orgbase	; FC
	dw	offset cgroup:zfd_60+orgbase	; FD
	dw	offset cgroup:zed_ff_07+orgbase	; invalid
;-------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**      (C)Copyright 1985-1996, American Megatrends, Inc.      **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**           6145-F Northbelt Pkwy, Norcross, GA 30071         **;
;**                                                             **;
;**                     Phone (770)-246-8600                    **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
	assume	ds:nothing
	assume	es:nothing
	assume	cs:nothing
_text	ends
	end
