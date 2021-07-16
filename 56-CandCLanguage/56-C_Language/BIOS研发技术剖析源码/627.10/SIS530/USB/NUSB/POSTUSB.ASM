 	page	,132
	title .	POST USB Routines
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

;---------------------------------------;
	include	rt.equ
	include	usb.equ
;---------------------------------------;
	extrn	usb_device:abs
	extrn	usb_unknown:abs
	extrn	usb_keyboard:abs
	extrn	usb_mouse:abs
	extrn	usb_hub:abs
	extrn	usb_floppy:abs

	extrn	display_message_set0:near
	extrn	display_0d0a:near
;---------------------------------------;
;	C O D E     S E G M E N T	;
;---------------------------------------;
cgroup	group	_text
_text segment word public 'CODE'
	assume	cs:CGROUP
.386

;---------------------------------------;
; DisplayUsbDevices                     ;
;---------------------------------------;--------------------------------------;
; Check point : 38                                                             ;
; This function is called to display USB devices found. This function can be   ;
; called from any time after checkpoint 38 during POST.                        ;
; Input :								       ;
;	stack	available						       ;
; Register usage : Do not destroy any register                                 ;
;------------------------------------------------------------------------------;
DisplayUsbDevices	proc	near
COMMENT ~
	pushad
	mov	ax, 2F00h		;Check USB BIOS Present
	CALL_RT_FUNCTION
	jc	display_usb_done	;No USB BIOS
	movzx	cx, ch			;#of entries in USB device table
	dec	cx			;Skip Device0
	mov	bl, 01h			;Start with device 1
	xor	bp, bp			;BP = 0000 -> display "USB Device(s): "
display_usb_loop:
	push	cx
	push	bx
	mov	ax, 2f09h		;Get Device table entry in SMRAM buffer
	push	bp
	CALL_RT_FUNCTION
	mov	di, DeviceTableEntry.Present
	mov	ax, 2F07h		;Read USB Device table buffer
	CALL_RT_FUNCTION
	pop	bp
	or	bl, bl			;Entry free/used ?
	jz	display_usb_cont	;Br if Entry is free
	mov	di, DeviceTableEntry.BiosDeviceType
	mov	ax, 2F07h		;Read USB Device table buffer
	push	bp
	CALL_RT_FUNCTION
	pop	bp
;  BL = USB Device Type 0/1/2/3/4 for Unknown/Keyboard/Mouse/Hub/Floppy
	movzx	bx, bl
	cmp	bl, offset cgroup:usb_device_string_table_end-offset cgroup:usb_device_string_table
	jb	display_valid_usb
	mov	bl, 00h
display_valid_usb:
	or	bp, bp			;Display "USB Device(s): " ?
	jnz	display_usb		;Br if no
	push	bx
	mov	bh, usb_device
	call	display_message_set0
	pop	bx
	mov	bp, 00ffh		;BP <> 0000 -> "USB Device(s):" displayed
display_usb:
	mov	bh, cgroup:usb_device_string_table[bx];BH = string#
	call	display_message_set0	;Display message
display_usb_cont:
	pop	bx
	pop	cx
	inc	bl			;Next device
	loop	display_usb_loop
	call	display_0d0a
display_usb_done:
	popad
~
	ret

DisplayUsbDevices	endp
COMMENT ~
;------------------------------------------------------------------------------;
usb_device_string_table		label	byte
	db	usb_unknown
	db	usb_keyboard
	db	usb_mouse
	db	usb_hub
	db	usb_floppy
usb_device_string_table_end	label	byte
~
;------------------------------------------------------------------------------;
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
_text ends
end
