	page	,132
	title	EXTERNAL FUNCTIONS FOR EVENT LOG IN SETUP
;---------------------------------------------------------------;
; NOTE: Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.
;---------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
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
	include setupequ.ext
	include setupmsg.equ
	include makeflag.equ
	include event.equ
;---------------------------------------;
	extrn	_temp_buffer:byte
	extrn	_common_cmos_buffer:byte
	extrn	_old_cmos_buffer:byte
	extrn	get_cmos_reg_mask_x:near
	extrn	get_cmos_buffer_item:near
	extrn	set_cmos_buffer_item:near
	extrn	Get_Language_No:near
	extrn	Get_$_Ptr:near
	extrn	ZEND:abs

mdear_zlist	db	STR_NO, STR_YES

event_log_type_zlist	label	byte
	db	STR_EVENT_TYPE00
	db	STR_EVENT_TYPE01
	db	STR_EVENT_TYPE02
	db	STR_EVENT_TYPE03
	db	STR_EVENT_TYPE04
	db	STR_EVENT_TYPE05
	db	STR_EVENT_TYPE06
	db	STR_EVENT_TYPE07
	db	STR_EVENT_TYPE08
	db	STR_EVENT_TYPE09
	db	STR_EVENT_TYPE0A
	db	STR_EVENT_TYPE0B
	db	STR_EVENT_TYPE0C
	db	STR_EVENT_TYPE0D
	db	STR_EVENT_TYPE0E
	db	STR_RESERVED
	db	STR_EVENT_TYPE10
	db	STR_EVENT_TYPE11
	db	STR_EVENT_TYPE12
	db	STR_EVENT_TYPE13
	db	STR_EVENT_TYPE14
	db	STR_EVENT_TYPE15
	db	STR_EVENT_TYPE16
	db	STR_EVENT_TYPE17
total_event_log_types	equ	$ - event_log_type_zlist

post_err_1st_zlist		label	byte
	db	STR_TIMER_ERR		; Channel 2 timer error
	db	STR_MATSRE_PIC_ERR	; Master PIC error
	db	STR_SLAVE_PIC_ERR	; Slave PIC error
	db	STR_CMOS_BAT_ERR	; CMOS battery failure
	db	STR_CMOS_OPT_ERR	; CMOS options not set
	db	STR_CMOS_CSUM_ERR	; CMOS checksum error
	db	STR_CMOS_CONF_ERR	; CMOS configuration error
	db	STR_RESERVED		; Mouse/Keyboard swapped
	db	STR_KEYB_LOCK_ERR	; Keyboard locked
	db	STR_KEYB_ERR		; Keyboard not functional
	db	STR_KEYB_CONT_ERR	; Keyboard controller error
	db	STR_CMOS_MEM_DIFF_ERR	; CMOS memory size different
	db	STR_RESERVED		; Memory decreased in size
	db	STR_CACHE_MEM_ERR	; Cache memory error
	db	STR_FLOPPY0_ERR 	; Floppy drive 0 error
	db	STR_FLOPPY1_ERR 	; Floppy drive 1 error
	db	STR_FLOPPY_CONT_ERR	; Floppy controller failure
	db	STR_RESERVED		; ATA drives reduced Error
	db	STR_CMOS_TIME_ERR	; CMOS time not set
;	db	STR_RESERVED		; DDC monitor config change
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; PS/2 mouse error (GVC)
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
;	db	STR_RESERVED		; reserved
	db	ZEND

post_err_2nd_zlist	label	byte
	db	STR_RESERVED		; reserved
	db	STR_RESERVED		; reserved
	db	STR_RESERVED		; reserved
	db	STR_RESERVED		; reserved
	db	STR_RESERVED		; reserved
	db	STR_RESERVED		; reserved
	db	STR_RESERVED		; reserved
	db	STR_PCI_MEM_CONFLICT	; PCI memory conflict
	db	STR_PCI_IO_CONFLICT	; PCI I/O conflict
	db	STR_PCI_IRQ_CONFLICT	; PCI IRQ conflict
	db	STR_RESERVED		; PNP memory conflict
	db	STR_RESERVED		; PNP 32 bit memory conflict
	db	STR_RESERVED		; PNP I/O conflict
	db	STR_RESERVED		; PNP IRQ conflict
	db	STR_RESERVED		; PNP DMA conflict
	db	STR_RESERVED		; Bad PNP serial ID
	db	STR_RESERVED		; Bad PNP resource data
	db	STR_STATIC_CONFLICT	; Static resource conflict
	db	STR_NVRAM_CSUM_ERR	; NVRAM checksum error, NVRAM cleared
	db	STR_RESERVED		; device resource conflict
	db	STR_RESERVED		; Primary output device not found
	db	STR_RESERVED		; Primary input device not found
	db	STR_RESERVED		; Primary boot device not found
	db	STR_RESERVED		; NVRAM cleared by jumper
	db	STR_RESERVED		; NVRAM data invalid, NVRAM cleared
	db	STR_FDC_CONFLICT	; FDC resource conflict
	db	STR_PRI_ATA_CONFLICT	; Primary ATA resource conflict
	db	STR_SEC_ATA_CONFLICT	; Secondary ATA resource conflict
	db	STR_PARALLEL_CONFLICT	; Parallel port resource conflict
	db	STR_SERIAL1_CONFLICT	; Serial port 1 resource conflict
	db	STR_SERIAL2_CONFLICT	; Serial port 2 resource conflict
;	db	STR_RESERVED		; Audio resource conflict
	db	ZEND

;-----------------------------------------------------------------------;
event_log_capacity	proc	far
	push	ds
	push	LOG_BUFFER_SEG
	pop	ds
	xor	si,si
	mov	bh,STR_SPACE_AVAILABLE
	cmp	(LOG_BUFFER ptr [si]).log_capacity,0; space available?
	je	elc_00
	mov	bh,STR_SPACE_FULL
elc_00::
	call	Common_Return_Opt_$_Proc; DX:BX = ptr to option string
	mov	ah,1			; structure to be shown shadowed.
	pop	ds
	retf
event_log_capacity	endp

;-----------------------------------------------------------------------;
event_log_validity	proc	far
	push	ds
	push	LOG_BUFFER_SEG
	pop	ds
	xor	si,si
	mov	bh,STR_VALID
	cmp	(LOG_BUFFER ptr [si]).log_validity,1; valid?
	je	elc_00
	mov	bh,STR_INVALID
	jmp	short elc_00
event_log_validity	endp

;-----------------------------------------------------------------------;
view_dmi_event_log	proc	far
	push	ds
	push	es

	smsw	ax
	test	al,01h			; in protected mode ?
	jnz	skip_for_bcp

	push	2000h			; 2000:0000 as display buffer
	pop	es
	xor	di,di
	mov	word ptr es:[di],0	; init string #
	inc	di
	inc	di

	push	LOG_BUFFER_SEG
	pop	ds
	xor	si,si
	mov	ax,(LOG_BUFFER ptr [si]).log_size

	or	ax,ax
	jnz	log_buffer_not_empty
no_unread_event:
	call	copy_event_string
	jmp	view_event_done

log_buffer_not_empty:
	mov	si,LOG_BUFFER.log_data	; offset of event log data
check_mark_as_read:
	mov	al,(LOG_RECORD ptr [si]).event_type
	cmp	al,0ffh 		; end event?
	je	log_data_end
	test	(LOG_RECORD ptr [si]).record_len,80h;bit7, mark as read?
	jz	next_event_record	; event has been read
	call	copy_event_string
	call	copy_event_date_time
	cmp	al,POST_ERROR		; POST error event?
	jne	next_event_record

	mov	eax,(LOG_RECORD ptr [si]).var_data1
	mov	dx,offset cs:post_err_1st_zlist
	call	copy_post_error_string
	mov	eax,(LOG_RECORD ptr [si]).var_data2
	mov	dx,offset cs:post_err_2nd_zlist
	call	copy_post_error_string

next_event_record:
	movzx	ax,(LOG_RECORD ptr [si]).record_len
	and	al,07fh 		; mask bit7
	add	si,ax			; ptr to next record
	jmp	check_mark_as_read

log_data_end:
	cmp	word ptr es:[0],0	; string buffer is empty?
	mov	al,0			; no unread event
	je	no_unread_event
view_event_done:
	mov	byte ptr es:[di],0	; double zero to end

skip_for_bcp:
	mov	ah,008h 		; (ah) = display a window
	mov	dx,es			; dx:bx points to the correct zlist.
	xor	bx,bx
	pop	es
	pop	ds
	retf
view_dmi_event_log	endp

;-----------------------------------------------------------------------;
; Input:
;	AL = event type
;	DI = buffer to keep the event string
; Output:
;	DI = ptr to next string buffer
;-----------------------------------------------------------------------;
copy_event_string	proc	near
	push	si
	cmp	al,total_event_log_types
	jae	ces_00			; invalid event type
	movzx	si,al
	mov	bh,cs:event_log_type_zlist[si]	; get zoption string#
	cmp	bh,STR_RESERVED
	je	ces_00			; invalid event type
	call	put_string_to_buffer
	inc	word ptr es:[0] 	; increase total string numbers
ces_00:
	pop	si
	ret
copy_event_string	endp

;-----------------------------------------------------------------------;
; Input:
;	SI = ptr to current LOG_RECORD
;	DI = buffer to keep the data/time field string
; Output:
;	DI = ptr to next string buffer
;-----------------------------------------------------------------------;
copy_event_date_time	proc	near
	push	ax

	mov	byte ptr es:[di-1],' '
	mov	bx,offset cs:event_data_time_order
	mov	cx,(offset cs:event_data_time_order_end-offset cs:event_data_time_order)/2
cedt_00:
	push	si
	movzx	ax,byte ptr cs:[bx]
	inc	bx
	add	si,ax
	mov	ah,byte ptr [si]
	call	ah_to_ascii
	mov	al,byte ptr cs:[bx]
	inc	bx
	mov	byte ptr es:[di],al
	inc	di
	pop	si
	loop	cedt_00
	pop	ax
	ret
copy_event_date_time	endp

event_data_time_order		label	byte
	db	LOG_RECORD.month,	'/'
	db	LOG_RECORD.day, 	'/'
	db	LOG_RECORD.year,	' '
	db	LOG_RECORD.hour,	':'
	db	LOG_RECORD.minute,	':'
	db	LOG_RECORD.second,	00h
event_data_time_order_end	label	byte

;-----------------------------------------------------------------------;
; Input:
;	AH	hex value to convert to char.
;	ES:DI	result buffer for ASCII code
; Output:
;	ES:DI	next in buffer
;-----------------------------------------------------------------------;
ah_to_ascii	proc	near
	mov	al,ah
	and	al,0f0h
	shr	al,4
	add	al,'0'
	mov	byte ptr es:[di],al
	inc	di
	and	ah,0fh
	add	ah,'0'
	mov	byte ptr es:[di],ah
	inc	di
	ret
ah_to_ascii	endp

;-----------------------------------------------------------------------;
; Input:
;	EAX	bits containing the events
;	ES:DI	buffer of strings to be displayed
;	DX	ptr to table containing the string numbers
; Output:
; Registers destroyed: EAX BX DI
;-----------------------------------------------------------------------;
copy_post_error_string	proc	near
	push	si
	mov	si,dx			; si points to table
cpes_next_error:
	shr	eax,1
	jnc	skip_this_msg		; NC - no event
	mov	bh,cs:[si]		; get string #
	cmp	bh,STR_RESERVED 	; reserved (not supported) ?
	jz	skip_this_msg		; yes.. skip
	call	put_string_to_buffer
	inc	word ptr es:[0] 	; increase total string numbers
skip_this_msg:
	inc	si
	cmp	byte ptr cs:[si],ZEND	; end of table ?
	jne	cpes_next_error 	; no..
	pop	si
	ret
copy_post_error_string	endp

;-----------------------------------------------------------------------;
; Input:
;	BH	string #
;	ES:DI	destination pointer to string
; Output:
;	string copied to buffer
;	ES:DI	buffer pointer moved
; Registers destroyed: none
;-----------------------------------------------------------------------;
put_string_to_buffer	proc
	push	ds
	push	dx
	push	bx
	push	ax
	push	si
	call	Common_Return_Opt_$_Proc; DX:BX = ptr to option string
	mov	ds,dx
	mov	si,bx			; DS:SI = string ptr
copy_next_byte:
	lodsb
	stosb
	or	al,al			; end of string ?
	jnz	copy_next_byte		; no..
	pop	si
	pop	ax
	pop	bx
	pop	dx
	pop	ds
	ret
put_string_to_buffer	endp

;-----------------------------------------------------------------------;
mark_dmi_events_as_read proc	far
	mov	al,Q_MARK_DMI_EVENTS_AS_READ
	call	get_cmos_buffer_item
	mov	ah,12h			; display normal
	jz	mdear_no
	push	ds
	push	LOG_BUFFER_SEG
	pop	ds
	xor	si,si
	mov	(LOG_BUFFER ptr [si]).log_change,1; changed
	cmp	(LOG_BUFFER ptr [si]).log_size,0; log size is zero?
	je	mdear_done
	mov	si,LOG_BUFFER.log_data	; offset of event log data
mdear_next_record:
	cmp	(LOG_RECORD ptr [si]).event_type,0ffh;end log data?
	je	mdear_done
	and	(LOG_RECORD ptr [si]).record_len,07fh;clear bit7, mark as read
	movzx	ax,(LOG_RECORD ptr [si]).record_len
	add	si,ax
	jmp	mdear_next_record
mdear_done:
	pop	ds
	mov	ah,13h			; display shadowed
mdear_no:
	mov	bx,offset cs:mdear_zlist
	mov	dx,cs			; dx:bx points to the correct zlist.
	retf
mark_dmi_events_as_read endp
;---------------------------------------;
; Input:				;
;	bh	Zoption number		;
; Output:				;
;	DX:BX	string ptr		;
;---------------------------------------;
Common_Return_Opt_$_Proc	proc
	mov	bl,2			; Use string set #2, option list.
	call	Get_Language_No 	; Get current language #.
	call	Get_$_Ptr		; Get string ptr in dx:ax
	mov	bx,ax			; Put string ptr in dx:bx
	ret
Common_Return_Opt_$_Proc	endp
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**								**;
;**	(C)Copyright 1985-1999, American Megatrends Inc.	**;
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
