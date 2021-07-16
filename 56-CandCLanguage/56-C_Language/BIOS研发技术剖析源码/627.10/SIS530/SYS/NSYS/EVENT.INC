;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1999, American Megatrends Inc.        **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**             6145-F, Northbelt Parkway, Norcross,            **;
;**                                                             **;
;**             Georgia - 30071, USA. Phone-(770)-246-8600.     **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;

	include event.equ
	include mbiosequ.equ
	include gpnv.equ
	include pci.equ
	include escd.equ
	include dim.equ
	include dim.dat

	extrn	get_cmos_item:near
	extrn	set_cmos_item_checksum:near
	extrn	read_cmos_8e:near
	extrn	read_gpnv_handle:near
	extrn	ram_segment:word
	extrn	get_gpnv_attribute_information:near
	extrn	update_gpnv_attribute:near

;-----------------------------------------------------------------------;
;			init_event_log_buffer				;
;-----------------------------------------------------------------------;
; This routine will get the last event logs in gpnv and init the buffer ;
; if no previous logs.							;
; input :								;
;	AX:0000 Event log buffer					;
; output:								;
;	buffer updated							;
; register usage : none 						;
;-----------------------------------------------------------------------;

	public	init_event_log_buffer
init_event_log_buffer	proc	near
	push	gs
	push	ds
	push	es
	pusha

	mov	es,ax
	xor	si,si			; offset zero, buffer start point
	mov	(LOG_BUFFER ptr es:[si]).log_size,0; init size to zero
	mov	(LOG_BUFFER ptr es:[si]).log_capacity,0; assume space available
	mov	(LOG_BUFFER ptr es:[si]).log_validity,1; assume valid
	mov	(LOG_BUFFER ptr es:[si]).log_change,0; unchanged
	mov	(LOG_BUFFER ptr es:[si]).gpnv_handle,1; default handle #
	mov	(LOG_BUFFER ptr es:[si]).change_token,0; init change token
	mov	al,Q_EVENT_LOGGING
	call	get_cmos_item
	mov	(LOG_BUFFER ptr es:[si]).logging,al
	mov	(LOG_BUFFER ptr es:[si]).post_err1,0
	mov	(LOG_BUFFER ptr es:[si]).post_err2,0

	mov	al,Q_MARK_DMI_EVENTS_AS_READ
	call	get_cmos_item
	mov	(LOG_BUFFER ptr es:[si]).as_read,al

	mov	al,Q_CLEAR_EVENT_LOG
	call	get_cmos_item
	jz	load_event_log_from_gpnv
	mov	ax,Q_CLEAR_EVENT_LOG	;set to 'No'
	call	set_cmos_item_checksum
	mov	al,LOG_AREA_RESET_CLEARED
	push	es
	pop	ds			; DS = event log buffer
	call	logging_event
	jmp	short ielb_00

load_event_log_from_gpnv:
	push	si
	mov	bx,GPNV_DMI_EVENT_LOG_BIT	; attribute of the concerned GPNV area

	call	get_gpnv_attribute_information	; get the GPNV area details


	pop	si
	jc	ielb_00 		; read information error
	mov	(LOG_BUFFER ptr es:[si]).gpnv_handle,bl; save handle #

;	mov	bx,EVENT_LOG_GPNV_HANDLE; BX = GPNV handle# of event log
	mov	edi,LOG_BUFFER.log_data ; ES:EDI = event log data buffer
	mov	ax,0f000h		; real mode
	mov	ds,ax			; DS = GPNV Selector
	mov	gs,ax			; GS = BIOS Selector
	mov	al,READ_GPNV_DATA_SUBFUNC; AL = read gpnv header+data
	call	read_gpnv_handle	; read the data

	jc	ielb_00 		; read data error

	xor	cx,cx
ielb_04:
	mov	al,(LOG_RECORD ptr es:[di]).event_type
	cmp	al,0ffh 		; end event?
	je	ielb_03
	call	check_supported_event
	jnz	log_data_invalid
	movzx	ax,(LOG_RECORD ptr es:[di]).record_len
	and	al,7fh
	cmp	al,08h			; min. event size >= 8
	jb	log_data_invalid
	add	cx,ax
	inc	(LOG_BUFFER ptr es:[si]).change_token
	test	(LOG_BUFFER ptr es:[si]).as_read,1 ; mark as read?
	jz	keep_current_read_status
	and	(LOG_RECORD ptr es:[di]).record_len,7fh ; mark the event as read
keep_current_read_status:
	add	di,ax			; ptr to next record
	jmp	ielb_04
ielb_03:
	mov	(LOG_BUFFER ptr es:[si]).log_size,cx; save the size
	cmp	cx,MAX_LOG_SIZE
	jb	ielb_00
	mov	(LOG_BUFFER ptr es:[si]).log_capacity,1; space full

ielb_00:
	popa
	pop	es
	pop	ds
	pop	gs
	ret

log_data_invalid:
	mov	(LOG_BUFFER ptr es:[si]).log_validity,0; invalid
	jmp	ielb_00

init_event_log_buffer	endp
;-----------------------------------------------------------------------;
;			CHECK_SUPPORTED_EVENT				;
;-----------------------------------------------------------------------;
; This routine varify the supported event type. 			;
; input :								;
;	AL = event type 						;
; output:								;
;	NZ	the event type is supported				;
;	ZR	the event type is NOT supported 			;
; register usage : none 						;
;-----------------------------------------------------------------------;
check_supported_event	proc	near
	push	cx
	push	si
	mov	cx,(offset cs:event_type_supported_table_end-offset cs:event_type_supported_table)
	mov	si,offset cs:event_type_supported_table
cse_01:
	cmp	al,cs:[si]
	jz	cse_00			;supported
	inc	si
	loop	cse_01
	or	sp,sp			;not supported
cse_00:
	pop	si
	pop	cx
	ret
check_supported_event	endp
;-----------------------------------------------------------------------;
;			EVENT_TYPE_SUPPORTED_TABLE			;
;-----------------------------------------------------------------------;
; List of the supported event type, it should be synchronize with the	;
; event type supported list of SMBIOS type 15 (system evnet type).	;
;-----------------------------------------------------------------------;
event_type_supported_table	label	byte
	db	POST_ERROR
	db	LOG_AREA_RESET_CLEARED
event_type_supported_table_end	label	byte
;-----------------------------------------------------------------------;
;			LOGGING_POST_ERROR1				;
;-----------------------------------------------------------------------;
; check point		: 85						;
; This routine will log the POST error event.				;
; input :								;
;	Code segment writeable						;
; output:								;
;	cgroup:first_bp = 1st set post error				;
; register usage : none 						;
;-----------------------------------------------------------------------;
logging_post_error1	proc	near
	mov	cgroup:first_bp,bp
	ret
logging_post_error1	endp
;-----------------------------------------------------------------------;
;			LOGGING_POST_ERROR2				;
;-----------------------------------------------------------------------;
; This routine will log the POST error event.				;
; input :								;
;	BP = 2nd set post error 					;
; output:								;
;	none								;
; register usage : none 						;
;-----------------------------------------------------------------------;
;;logging_post_error2	proc	near
;;	ret
;;logging_post_error2	endp
;-----------------------------------------------------------------------;
;			LOGGING_POST_ERROR3				;
;-----------------------------------------------------------------------;
; check point		: 38						;
; This routine will log the DIM POST error event.			;
; input :								;
;	DS = DIMDATASEG 						;
;	Code segment writeable						;
; output:								;
;	cgroup:dim_SysStatus						;
; register usage : eax							;
;-----------------------------------------------------------------------;
logging_post_error3	proc	near
	mov	eax,ds:SysStatus
	mov	cgroup:dim_SysStatus,eax
	mov	eax,ds:IsaStatus
	mov	cgroup:dim_IsaStatus,eax
	mov	eax,ds:PciStatus
	mov	cgroup:dim_PciStatus,eax
	ret
logging_post_error3	endp
;-----------------------------------------------------------------------;
;			LOGGING_POST_ERROR				;
;-----------------------------------------------------------------------;
; This routine will log the post error event if exist.			;
; input :								;
;	AX:0000	used as buffer						;
; output:								;
;	none								;
; register usage : none 						;
;-----------------------------------------------------------------------;
logging_post_error	proc	near
	push	eax
	push	ds
	mov	ds,ax
	xor	si,si			; DS:SI = event log buffer

	call	parse_all_post_errors_to_buffer

	mov	eax,(LOG_BUFFER ptr [si]).post_err1
	add	eax,(LOG_BUFFER ptr [si]).post_err2
	jz	no_post_error
	mov	al,POST_ERROR
	call	logging_event
no_post_error:
	pop	ds
	pop	eax
	ret
logging_post_error	endp
;-----------------------------------------------------------------------;
;			LOGGING_EVENT					;
;-----------------------------------------------------------------------;
; This routine will add a event to the event log data area.		;
; input :								;
;	AL = event type 						;
; output:								;
;	none								;
; note: 								;
;	DS:0000	will be used as the buffer for event log,		;
;	see event.equ for the format.					;
; register usage : none 						;
;-----------------------------------------------------------------------;
	public	logging_event
logging_event	proc	near
	push	ds
	pushad

	xor	si,si			;SI = event log buffer start address
	cmp	(LOG_BUFFER ptr [si]).log_validity,0; invalid?
	jz	logging_event_end
	cmp	(LOG_BUFFER ptr [si]).logging,0;logging disabled?
	jz	logging_event_end
	mov	di,(LOG_BUFFER ptr [si]).log_size;DI = current log size
	cmp	di,MAX_LOG_SIZE
	jae	log_space_full
	add	di,LOG_BUFFER.log_data	;DI = end of the event log data

	mov	(LOG_RECORD ptr [di]).event_type,al	;set event type
	mov	(LOG_RECORD ptr [di]).record_len,88h	;assume length=8, bit7=1: has NOT been read
	cmp	al,POST_ERROR		;event type = POST error?
	jnz	not_post_error
	mov	(LOG_RECORD ptr [di]).record_len,90h;length=16, bit7=1: has NOT been read
	mov	eax,(LOG_BUFFER ptr [si]).post_err1;first POST results bitmap
	mov	(LOG_RECORD ptr [di]).var_data1,eax
	mov	eax,(LOG_BUFFER ptr [si]).post_err2;second POST results bitmap
	mov	(LOG_RECORD ptr [di]).var_data2,eax
not_post_error:
	movzx	bx,(LOG_RECORD ptr [di]).record_len
	and	bl,7fh			;bit6-0=length
	add	(LOG_BUFFER ptr [si]).log_size,bx
	mov	(LOG_BUFFER ptr [si]).log_change,1; changed
	mov	byte ptr [di+bx],0ffh;end event log indicator
	call	logging_date_time

	mov	ax,Q_MARK_DMI_EVENTS_AS_READ	;set to 'No' if new event happen
	call	set_cmos_item_checksum
	jmp	logging_event_end

log_space_full:
	mov	(LOG_BUFFER ptr [si]).log_capacity,1; space full

logging_event_end:
	popad
	pop	ds
	ret
logging_event	endp
;-----------------------------------------------------------------------;
;			LOGGING_DATE_TIME				;
;-----------------------------------------------------------------------;
; This routine will read the current date/time from CMOS and put into	;
; the event log buffer. 						;
; input :								;
;	DS:DI = event log to be updated 				;
; output:								;
;	none								;
; register usage : can be all except ES 				;
;-----------------------------------------------------------------------;
logging_date_time	proc	near
	add	di,LOG_RECORD.year	;offset of date/time field
	mov	bx,offset cs:date_time_cmos_reg
	mov	cx,(offset cs:date_time_cmos_reg_end - offset cs:date_time_cmos_reg)
set_date_time_field:
	mov	al,cs:[bx]
	call	read_cmos_date_time
	mov	[di],al
	inc	bx
	inc	di
	loop	set_date_time_field
	ret
logging_date_time	endp
;-----------------------------------------------------------------------;
;			READ_CMOS_DATE_TIME				;
;-----------------------------------------------------------------------;
; This routine will read the date/time field from CMOS. 		;
; input :								;
;	AL	index							;
; output:								;
;	AL	data							;
; register usage : none 						;
;-----------------------------------------------------------------------;
read_cmos_date_time	proc	near
	push	ax
update_complete_01:
	mov	al,8ah				; NMI off
	call	cmos_data_in_xx 		; (al) = read the data
	test	al,80h				; update in progress ?
	jnz	update_complete_01		; yes...
	pop	ax

cmos_data_in_xx:
	pushf					; save current interrupt status
	cli					; disable interrupts
	out	70h,al
	jcxz	$+2
	jcxz	$+2
	in	al,71h
	popf
	ret
read_cmos_date_time	endp
;-----------------------------------------------------------------------;
;			DATE_TIME_CMOS_REG				;
;-----------------------------------------------------------------------;
; CMOS map for data/time field						;
;-----------------------------------------------------------------------;
date_time_cmos_reg		label	byte
	db	89h		;CMOS year
	db	88h		;CMOS month
	db	87h		;CMOS day
	db	84h		;CMOS hour
	db	82h		;CMOS minute
	db	80h		;CMOS second
date_time_cmos_reg_end		label	byte
;-----------------------------------------------------------------------;
;			WRITE_EVENT_LOG_DATA_TO_GPNV			;
; this routine writes the EVENT LOG data to GPNV.			;
; input :								;
;	AX:0000	used as buffer						;
; output:								;
;	NC	writing to GPNV is successful				;
;	CY	writing to GPNV is not successful			;
;  registers destroyted: none						;
;-----------------------------------------------------------------------;
	public	write_event_log_data_to_gpnv
write_event_log_data_to_gpnv:
	push	ds
	push	es
	pushad
	mov	es,ax
	xor	si,si
	cmp	(LOG_BUFFER ptr es:[si]).log_validity,0; invalid?
	jz	weldtg_00		; current log data in GPNV is invalid
	cmp	(LOG_BUFFER ptr es:[si]).log_change,0; changed?
	jz	weldtg_00		; Br. if event log didn't change
	mov	cx,(LOG_BUFFER ptr es:[si]).log_size;size of event log data
	jcxz	weldtg_00		; Br. if event log buffer is empty
	inc	cx			; include the end indicator 0ffh
	mov	si,LOG_BUFFER.log_data	; SI = start of the event log data

	push	gs
	mov	bx,GPNV_DMI_EVENT_LOG_BIT	; attribute of the concerned GPNV area
; DS:SI = ptr to EVENT LOG data
	push	si
	push	cx
	push	bx
	push	0f000h
	pop	gs				; GS = BIOS selector
	call	get_gpnv_attribute_information	; get the GPNV area details


; BX = handle# of GPNV area if it exists
	pop	dx				; DX = attribute
	pop	cx				; CX = # of bytes
	movzx	ecx,cx				; ECX = # of bytes
	pop	di				; ES:DI = ptr to EVENT LOG data
	movzx	edi,di				; ES:EDI = ptr to EVENT LGO data
; ES:EDI = ptr to buffer containing the DMI data structures
; ECX	 = DMI data structures size in BYTEs
; BX	 = handle# of GPNV area if it exists
; DX	 = attribute of GPNV area
	mov	ax,cgroup:ram_segment
	sub	ah,10h
	mov	ds,ax
	xor	esi,esi
; DS:ESI = ptr to scratch buffer long enough to contain the whole GPNV area
; ES:EDI = ptr to buffer containing the data of the GPNV area
; ECX	 = size of the data in BYTEs
; BX	 = handle# of GPNV area
; DX	 = attribute of GPNV area
; GS	 = BIOS selector
	call	update_gpnv_attribute		; update GPNV area

	pop	gs
weldtg_00:
	popad
	pop	es
	pop	ds
	ret


;-----------------------------------------------------------------------;
;			parse_all_post_errors_to_buffer 		;
;-----------------------------------------------------------------------;
; This routine parse all post error bits record previously and save the ;
; analyzed bits to event log buffer					;
; input :								;
;	cgroup:first_bp 	1st set of POST errors			;
;	bp			2nd set of POST errors			;
;	cgroup:dim_SysStatus	DIM POST errors 			;
;	DS:0000			Event log buffer			;
; output:								;
;	buffer updated							;
; register usage : none 						;
;-----------------------------------------------------------------------;
parse_all_post_errors_to_buffer proc

	push	ds
	push	es
	pushad

;---------------------------------------;
; 1st set of POST errors		;
;---------------------------------------;
; Flag - cgroup:first_bp
	mov	bx,cgroup:first_bp	; get 1st set of POST error
	xor	si,si			; SI = event log buffer start address

	test	bx,cache_memory_err_bit
	jz	lpe1_00
	or	(LOG_BUFFER ptr [si]).post_err1,CACHE_MEMORY_ERROR
lpe1_00:
;; GVC
;;	test	bx,power_on_bit 	; for ps/2 mouse error
;;	jz	lpe1_01
;;	or	(LOG_BUFFER ptr [si]).post_err1,PS2_MOUSE_ERROR
;;lpe1_01:
;;	and	bx,not (soft_reset_bit+cache_memory_err_bit+end_key_err_bit+power_on_bit+ins_key_err_bit)
	and	bx,not (power_on_bit+soft_reset_bit+cache_memory_err_bit+end_key_err_bit+power_on_bit+ins_key_err_bit)
	or	word ptr (LOG_BUFFER ptr [si]).post_err1,bx

;---------------------------------------;
; 2nd set of POST errors		;
;---------------------------------------;
; DS:SI = event log buffer
; Flag - BP
	test	bp,floppy_disk_ctl_err_bit
	jz	lpe2_00
	or	(LOG_BUFFER ptr [si]).post_err1,FLOPPY_CONTROLLER_FAILURE
lpe2_00:
	test	bp,floppy_disk_0_err_bit
	jz	lpe2_01
	or	(LOG_BUFFER ptr [si]).post_err1,FLOPPY_DRIVE_0_ERROR
lpe2_01:
	test	bp,floppy_disk_1_err_bit
	jz	lpe2_02
	or	(LOG_BUFFER ptr [si]).post_err1,FLOPPY_DRIVE_1_ERROR
lpe2_02:
	test	bp,cmos_time_err_bit
	jz	lpe2_03
	or	(LOG_BUFFER ptr [si]).post_err1,CMOS_TIME_NOT_SET
lpe2_03:

;---------------------------------------;
; DIM POST errors			;
;---------------------------------------;
; DS:SI = event log buffer
; Flag - cgroup:dim_sysStatus

	mov	eax,dword ptr cgroup:dim_SysStatus
	and	eax,7fh
	jz	lpe3_00
	shl	eax,18
	or	(LOG_BUFFER ptr [si]).post_err2,eax
lpe3_00:
	mov	ebx,dword ptr cgroup:dim_SysStatus	; EBX = System status
	test	ebx,STAT_SYS_CONF_LPT
	jz	lpe3_02
	or	(LOG_BUFFER ptr [si]).post_err2,PARALLEL_PORT_RESOURCE_CONFLICT
lpe3_02:
	test	ebx,STAT_SYS_CONF_COM
	jz	lpe3_03
	or	(LOG_BUFFER ptr [si]).post_err2,SERIAL_PORT_1_RESOURCE_CONFLICT
	or	(LOG_BUFFER ptr [si]).post_err2,SERIAL_PORT_2_RESOURCE_CONFLICT
lpe3_03:
	test	ebx,STAT_SYS_CONF_FLOPPY
	jz	lpe3_04
	or	(LOG_BUFFER ptr [si]).post_err2,FDC_RESOURCE_CONFLICT
lpe3_04:
	test	ebx,STAT_SYS_CONF_IDE
	jz	lpe3_05
	or	(LOG_BUFFER ptr [si]).post_err2,PRIMARY_ATA_RESOURCE_CONFLICT
	or	(LOG_BUFFER ptr [si]).post_err2,SECONDARY_ATA_RESOURCE_CONFLICT
lpe3_05:
	mov	ebx,cgroup:dim_IsaStatus	; EBX = ISA status
	test	ebx,STAT_ISA_CONFLICT
	jz	lpe3_06
	or	(LOG_BUFFER ptr [si]).post_err2,STATIC_RESOURCE_CONFLICT
lpe3_06:

	mov	ebx,cgroup:dim_PciStatus	; EBX = PCI status
	test	ebx,STAT_PCI_IO_CONFLICT
	jz	lpe3_07
	or	(LOG_BUFFER ptr [si]).post_err2,PCI_IO_CONFLICT
lpe3_07:
	test	ebx,STAT_PCI_MEM_CONFLICT
	jz	lpe3_08
	or	(LOG_BUFFER ptr [si]).post_err2,PCI_MEMORY_CONFLICT
lpe3_08:
	test	ebx,STAT_PCI_IRQ_CONFLICT
	jz	lpe3_09
	or	(LOG_BUFFER ptr [si]).post_err2,PCI_IRQ_CONFLICT
lpe3_09:

	cmp	(LOG_BUFFER ptr [si]).post_err2,0
	jz	lpe3_01
	or	(LOG_BUFFER ptr [si]).post_err1,SECOND_DWORD_HAS_VALID_DATA
lpe3_01:

	popad
	pop	es
	pop	ds
	ret

parse_all_post_errors_to_buffer endp


;-----------------------------------------------------------------------;
; Temporary data area used in code segment				;
;-----------------------------------------------------------------------;
first_bp	dw	0
dim_SysStatus	dd	0
dim_IsaStatus	dd	0
dim_PciStatus	dd	0

;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1999, American Megatrends Inc.        **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**             6145-F, Northbelt Parkway, Norcross,            **;
;**                                                             **;
;**             Georgia - 30071, USA. Phone-(770)-246-8600.     **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;

