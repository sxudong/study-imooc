Subttl.	Include file for GREEN PC support MISCELLANEOUS subroutines...GPMMISC.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

;;	public	smi_cmos_data_in_x		;
;;	public	smi_cmos_data_out_x		;
;;	public	smi_cmos_data_in		;
;;	public	smi_cmos_data_out		;

;;	public	read_8259_irr_reg		;
;;	public	save_and_mask_intr		;
;;	public	mask_all_8259			;
;;	public	restore_and_unmask_intr		;
;;	public	enquire_intr_pending_system	;
;;	public	irq_apm_save_and_mask_intr	;
;;	public	irq_apm_restore_and_unmask_intr	;

;;	public	disable_video_display_3c0	;
;;	public	enable_video_display_3c0	;

;;	public	disable_video_display_3c4	;
;;	public	enable_video_display_3c4	;

;;	public	disable_horz_vert_retrace	;
;;	public	enable_horz_vert_retrace	;

;;	public	get_ebp_for_stack_usage		;
;;	public	check_irq_pm			;
;;	public	check_irq_apm			;

;;	public	pm_fixed_delay			;

;;	public	single_sht_beep			;

;;	public	bcd_to_binary			;
;;	public	hr_min_sec_to_sec		;
;;	public	sec_to_hr_min_sec		;
;;	public	date_to_binary			;
;;	public	binary_to_bcd			;
;;	public	get_rtc_date			;
;;	public	get_rtc_time			;
;;	public	read_rtc_alarm			;
;;	public	wait_for_update_complete	;
;;	public	cmos_stat_reg_b_read		;
;;	public	cmos_stat_reg_c_read		;

;-----------------------------------------------;
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
;---------------------------------------------------------------;
;	SUPPORTIVE ROUTINES PROVIDED BY GRREN PC CORE BIOS	;
;	SUPPORTIVE ROUTINES PROVIDED BY GRREN PC CORE BIOS	;
;	SUPPORTIVE ROUTINES PROVIDED BY GRREN PC CORE BIOS	;
;	SUPPORTIVE ROUTINES PROVIDED BY GRREN PC CORE BIOS	;
;---------------------------------------------------------------;
;		     SMI_CMOS_DATA_IN_X				;
;---------------------------------------------------------------;
;	Input : (AL) index to read				;
;	Output: (AL) data					;
;	Register destroyed : NONE except (AL)			;
;---------------------------------------------------------------;

smi_cmos_data_in_x	proc	near

	pushf					; save current interrupt status
	cli					; disable interrupts
	out	cmos_address_port,al		; select the index
	smi_io_delay				;
	in	al,cmos_data_port		; (al) = read the data
	popf					; restore interrupt status
	ret

smi_cmos_data_in_x	endp

;---------------------------------------------------------------;
;		     SMI_CMOS_DATA_OUT_X			;
;---------------------------------------------------------------;
;	Input : (AL) index to write				;
;		(AH) data					;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

smi_cmos_data_out_x	proc	near

	pushf					; save interrupt status
	cli					; disable interrupts
	out	cmos_address_port,al		; select the index
	smi_io_delay				;
	xchg	al,ah				; (al) = data
	out	cmos_data_port,al		; write the data
	popf					; restore interrupt status
	xchg	al,ah				;
	ret

smi_cmos_data_out_x	endp

;---------------------------------------------------------------;
;		        SMI_CMOS_DATA_IN			;
;---------------------------------------------------------------;
;	Input : (AL) index to read				;
;	Output: (AL) data					;
;	Register destroyed : NONE except (AL)			;
;---------------------------------------------------------------;

smi_cmos_data_in	proc	near

	pushf					; save current interrupt status
	cli					; disable interrupts

	push	bx				;
	mov	bl,al				; (bl) msb has NMI on/off status
	or	al,10000000b			; make NMI off
	call	smi_cmos_data_in_x		; (al) = read the data
	push	ax				; save the data

;-----------------------------------------------;

smi_cmos_data_inout_00::

	mov	al,cmos_stat_reg_d		; default CMOS I/O reg
	test	bl,10000000b			; NMI off on entry ?
	jz	short smi_cmos_data_in_01	; no...on
	or	al,10000000b			; make NMI off
smi_cmos_data_in_01:
	call	smi_cmos_data_in_x		; dummy read
	pop	ax				;
	pop	bx				;
	popf					;
	ret

smi_cmos_data_in	endp

;---------------------------------------------------------------;
;		       SMI_CMOS_DATA_OUT			;
;---------------------------------------------------------------;
;	Input : (AL) index to write				;
;		(AH) data					;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

smi_cmos_data_out	proc	near

	pushf					; save current interrupt status
	cli					; disable interrupts

	push	bx				;
	push	ax				;
	mov	bl,al				; (bl) msb has NMI on/off status
	or	al,10000000b			; make NMI off
	call	smi_cmos_data_out_x		; write the data
	jmp	short smi_cmos_data_inout_00	;

smi_cmos_data_out	endp

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
;---------------------------------------------------------------;
;                         READ_8259_IRR_REG                     ;
;---------------------------------------------------------------;
;	Input : (AH) IRR bit(s) to be checked			;
;		(DX) 8259 master/slave control reg i/o port	;
;		STACK PRESENT					;
;	Output: (ZF) 01 (ZR) if input IRR bit(s) are clear	;
;		(ZF) 00 (NZ) if any of the IRR bit(s) are set	;
;		(CY) 00 (NC)					;
;		(AL) IRR read value				;
;	Register destroyed : (AL)				;
;								;
; This subroutine is called to read the interrupt request reg of;
; the specified 8259 control register, and test to see if the	;
; specified interrupt request bit(s) are set.                   ;
;---------------------------------------------------------------;

read_8259_irr_reg	proc	near

	pushf                                   ; save current interrupt status
	cli                                     ; disable interrupts
	mov     al, irr_reg_read_cmd            ;
	out     dx, al                          ; send IRR read command to 8259
	smi_io_delay				; i/o delay
	in      al, dx                          ; (al) = read current IRR status
	popf                                    ; restore original interrupt status
	test    al, ah                          ; check for proper IRQ set
						; (CF) cleared
	ret

read_8259_irr_reg	endp

;---------------------------------------------------------------;
;                      SAVE_AND_MASK_INTR                    	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;								;
; This hook is called whenever the system wants to save the 	;
; master and slave interrupt controller masks, and mask all	;
; hardware interrupts. System finally will be in CLI mode	;
;---------------------------------------------------------------;

save_and_mask_intr	proc	near

	cli					; disable interrupts
	push    ax				;

	in      al,mask_8259_master		; (al) = current master mask
	smi_io_delay				; i/o delay
	mov     ah,al				;
	in      al, mask_8259_slave		; (al) = current slave mask
	mov	ds:smi_intr_mask_save_area,ax	; save for later restore

;-----------------------------------------------;

save_and_mask_intr_10::
	smi_io_delay				; i/o delay
	pop     ax				;

;---------------------------------------------------------------;
;                      MASK_ALL_8259                    	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;								;
; This hook is called whenever the system wants to mask all	;
; hardware interrupts. System finally will be in CLI mode	;
;---------------------------------------------------------------;

mask_all_8259	proc	near

	cli					; disable interrupts
	push    ax				;

	mov     al,0ffh				; mask all interrupt levels
	out     mask_8259_master,al		; mask all master interrupt levels
	smi_io_delay				; i/o delay
	out     mask_8259_slave,al		; mask all slave interrupt levels

	pop     ax				;
	ret

mask_all_8259	endp
save_and_mask_intr	endp

;---------------------------------------------------------------;
;                       RESTORE_AND_UNMASK_INTR                 ;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;								;
; This hook is called whenever the system wants to restore the	;
; master and slave interrupt controller masks. System is placed ;
; in CLI mode.							;
;---------------------------------------------------------------;

restore_and_unmask_intr	proc	near

	cli					; disable interrupts
	push    ax				;

	mov     ax,ds:smi_intr_mask_save_area	; (ax) = saved mask for master & slave

;-----------------------------------------------;

restore_and_unmask_intr_10::
	out     mask_8259_slave,al		; restore slave mask
	smi_io_delay				; i/o delay
	mov     al,ah				;
	out     mask_8259_master,al		; restore master mask

	pop     ax				;
	ret

restore_and_unmask_intr	endp

;---------------------------------------------------------------;

IF	IRQ_HANDLING_SUPPORT
;---------------------------------------------------------------;
;		  IRQ_APM_SAVE_AND_MASK_INTR                    ;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;								;
; This hook is called whenever the system wants to save the 	;
; master and slave interrupt controller masks, and mask all	;
; hardware interrupts. System finally will be in CLI mode	;
;---------------------------------------------------------------;

irq_apm_save_and_mask_intr	proc	near

	cli					; disable interrupts
	push    ax				;

	in      al,mask_8259_master		; (al) = current master mask
	smi_io_delay				; i/o delay
	mov     ah,al				;
	in      al, mask_8259_slave		; (al) = current slave mask
	mov	ds:irq_apm_intr_mask_save_area,ax; save for later restore
	jmp	short save_and_mask_intr_10	;

irq_apm_save_and_mask_intr	endp

;---------------------------------------------------------------;
;		IRQ_APM_RESTORE_AND_UNMASK_INTR                 ;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;								;
; This hook is called whenever the system wants to restore the	;
; master and slave interrupt controller masks. System is placed ;
; in CLI mode.							;
;---------------------------------------------------------------;

irq_apm_restore_and_unmask_intr	proc	near

	cli					; disable interrupts
	push    ax				;

	mov     ax,ds:irq_apm_intr_mask_save_area; (ax) = saved mask for master & slave
	jmp	short restore_and_unmask_intr_10;

irq_apm_restore_and_unmask_intr	endp

;---------------------------------------------------------------;
ENDIF

;---------------------------------------------------------------;
;		ENQUIRE_INTR_PENDING_SYSTEM			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (ZF) set means no interrupt pending.		;
;		(ZF) clear means interrupt pending &		;
;		     (AL) has master pending interrupts info	;
;		     (AH) has slave pending interrupts info	;
;	Register destroyed : (AX),(DX)				;
;---------------------------------------------------------------;

enquire_intr_pending_system	proc	near

	mov	dx,control_8259_slave		;
	call	read_8259_irr_reg		; (al) = interrupt pending status for slave
	mov	ah,al				; (ah) = interrupt pending status for slave
	mov	dx,control_8259_master		;
	call	read_8259_irr_reg		; (al) = interrupt pending status for master
	mov	dx,ax				; (dl) = (al) = interrupt pending status for master
						; (dh) = (ah) = interrupt pending status for slave
	or	dl,dh				; set/clear (ZF)
	ret

enquire_intr_pending_system	endp

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
;---------------------------------------------------------------;
;		DISABLE_VIDEO_DISPLAY_3C0			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

disable_video_display_3c0	proc	near

	push	ax				;
	mov	ah,00000000b			; screen off
	jmp	short enable_display_3c0_00	;

disable_video_display_3c0	endp

;---------------------------------------------------------------;
;		   ENABLE_VIDEO_DISPLAY_3C0			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

enable_video_display_3c0	proc	near

	push	ax				;
	mov	ah,00100000b			; screen on

;-----------------------------------------------;

enable_display_3c0_00::

	call	video_display_3c0_on_off	;
	pop	ax				;
	ret

enable_video_display_3c0	endp

;---------------------------------------------------------------;
;		   VIDEO_DISPLAY_3C0_ON_OFF			;
;---------------------------------------------------------------;
;	Input : (AH) 00100000b display on			;
;		     00000000b display off			;
;	Output: NONE						;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

video_display_3c0_on_off	proc	near

	push	dx				;

	call	clear_attribute_flipflop	; clear attribute flipflop

	mov	dx,attribute_addr_reg		; (dx) = ATTRIBUTE address reg (3C0H)
	in	al,dx				; (al) = current index

	and	al,11011111b			; clear display on/off bit
	or	al,ah				; display on/off

	call	clear_attribute_flipflop	; clear attribute flipflop
	out	dx,al				; display on/off

	pop	dx				;
	ret

video_display_3c0_on_off	endp

;---------------------------------------------------------------;
;		   CLEAR_ATTRIBUTE_FLIPFLOP			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

clear_attribute_flipflop	proc	near

	push	ax				;
	push	dx				;

	mov	dx,input_status_reg_1_color_reg	; (dx) = input status reg 1 color (3DAH)
	in	al,dx				; clear attribute flipflop
	smi_io_delay				; i/o delay
	mov	dl,low input_status_reg_1_mono_reg; (dx) = input status reg 1 mono (3BAH)
	in	al,dx				; clear attribute flipflop

	pop	dx				;
	pop	ax
	ret

clear_attribute_flipflop	endp

;---------------------------------------------------------------;
;		    DISABLE_VIDEO_DISPLAY_3C4			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

disable_video_display_3c4	proc	near

	push	ax				;
	mov	ah,00100000b			; screen off
	jmp	short enable_display_3c4_00	;

disable_video_display_3c4	endp

;---------------------------------------------------------------;
;		    ENABLE_VIDEO_DISPLAY_3C4			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

enable_video_display_3c4	proc	near

	push	ax				;
	mov	ah,00000000b			; screen on

;-----------------------------------------------;

enable_display_3c4_00::

	call	video_display_3c4_on_off	;
	pop	ax				;
	ret

enable_video_display_3c4	endp

;---------------------------------------------------------------;
;		     VIDEO_DISPLAY_3C4_ON_OFF			;
;---------------------------------------------------------------;
;	Input : (AH) 00000000b display on			;
;		     00100000b display off			;
;	Output: NONE						;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

video_display_3c4_on_off	proc	near

	push	dx				;

	mov	dx,sequencer_addr_reg		; (dx) = sequencer address reg (3C4H)
	in	al,dx				; (al) = read current index select
	smi_io_delay				; i/o delay
	push	ax				; save for later restore

	mov	al,clocking_mode_reg_idx	; (al) = clocking mode reg of sequencer (3C5.01)
	out	dx,al				; select the index
	smi_io_delay				; i/o delay
	inc	dx				; data register (3C5H)
	in	al,dx				; (al) = read current programmed value
	and	al,11011111b			;

;-----------------------------------------------;

enb_dis_horz_vert_retrace_10::

	or	al,ah				; screen on/off
	out	dx,al				;
	smi_io_delay				; i/o delay

	dec	dx				; (dx) = sequencer address reg (3C4H)
	pop	ax				; (al) = read current index select
	out	dx,al				; restore index

	pop	dx				;
	ret

video_display_3c4_on_off	endp

;---------------------------------------------------------------;
;		    DISABLE_HORZ_VERT_RETRACE			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

disable_horz_vert_retrace	proc	near

	push	ax				;
	mov	ah,00000000b			; disable horizontal & vertical retrace
	jmp	short enable_horz_vert_retrace_00

disable_horz_vert_retrace	endp

;---------------------------------------------------------------;
;		    ENABLE_HORZ_VERT_RETRACE			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

enable_horz_vert_retrace	proc	near

	push	ax				;
	mov	ah,10000000b			; enable horizontal & vertical retrace

;-----------------------------------------------;

enable_horz_vert_retrace_00::

	call	enb_dis_horz_vert_retrace	;
	pop	ax				;
	ret

enable_horz_vert_retrace	endp

;---------------------------------------------------------------;
;		    ENB_DIS_HORZ_VERT_RETRACE			;
;---------------------------------------------------------------;
;	Input : (AH) 00000000b disable horizontal/vert retrace	;
;		     10000000b enable horizontal/vert retrace	;
;	Output: NONE						;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

enb_dis_horz_vert_retrace	proc	near 

	push	dx				;
	mov	dx,miscellaneous_out_reg_read_mode; miscellaneous output reg (3C2H) in read mode (3CCH)
	in	al,dx				; (al) = current programmed value
	test	al,00000001b			; set for color ?
	mov	dl,low crt_addr_reg_mono	; CRT control reg for mono (3B4H)
	jz	short enb_dis_horz_vert_retrace_01; no...mono
	mov	dl,low crt_addr_reg_color	; CRT control reg for color (3D4H)
enb_dis_horz_vert_retrace_01:
	in	al,dx				; (al) = read current index
	smi_io_delay				; i/o delay
	push	ax				; save it for later restore
	mov	al,crtc_mode_cntl_reg_index	; CRT mode control reg (3B4H/3D4H.17H)
	out	dx,al				;
	smi_io_delay				; i/o delay
	inc	dx				;
	in	al,dx				; (al) = current programmed value
	and	al,01111111b			; clear horizontal/vertical retrace bit
	jmp	short enb_dis_horz_vert_retrace_10

enb_dis_horz_vert_retrace	endp

;---------------------------------------------------------------;
;			SMI_INT_10H				;
;---------------------------------------------------------------;
;	Input : as required by the function requested		;
;	Output: as required by the function requested		;
;	Register destroyed : all general purpose		;
;---------------------------------------------------------------;

smi_int_10h	proc	near

	pushf					; save current interrupt enable/disable status

	call	set_vector_before_int_exec	; set interrupt vectors before executing any software interrupt

	pushf					; for IRET in INT 10H
	call	dword ptr ds:vga_bios_entry	; execute INT 10H

	call	res_vector_after_int_exec	; restore interrupt vectors after executing software interrupts

	popf					; restore interrupt enable/disable status
	ret

smi_int_10h	endp

;---------------------------------------------------------------;
;		   SET_VECTOR_BEFORE_INT_EXEC			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

set_vector_before_int_exec	proc	near

	pushad					;
	mov	di,save_current_vga_vector	;
	call	save_int10_vectors		; save current vectors
	mov	si,save_post_vga_vector		;
	call	res_int10_vectors		; restore POST time vectors
	popad					;
	ret

set_vector_before_int_exec	endp

;---------------------------------------------------------------;
;		   RES_VECTOR_AFTER_INT_EXEC			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

res_vector_after_int_exec	proc	near

	pushf					;
	pushad					;
	mov	si,save_current_vga_vector	;
	call	res_int10_vectors		;
	popad					;
	popf					;
	ret

res_vector_after_int_exec	endp

;---------------------------------------------------------------;
;			SAVE_INT10_VECTORS			;
;---------------------------------------------------------------;
;	Input : (DS:DI) vectors save area			;
;	Output: NONE						;
;	Register destroyed : (EAX)				;
;---------------------------------------------------------------;

save_int10_vectors	proc	near

	push	ds				;
	push	es				;
	push	ds				;
	pop	es				; (ES) = (DS)
	xor	ax,ax				;
	mov	ds,ax				; (DS) = interrupt vector segment
	mov	eax,ds:[0040h]			; INT 10h
	stosd					; save
	mov	eax,ds:[01b4h]			; INT 6Dh
	stosd					; save
	mov	eax,ds:[04a8h]			; [0:4A8h]
	stosd					; save
	pop	es				;
	pop	ds				;
	ret

save_int10_vectors	endp

;---------------------------------------------------------------;
;			RES_INT10_VECTORS			;
;---------------------------------------------------------------;
;	Input : (DS:SI) vectors save area			;
;	Output: NONE						;
;	Register destroyed : (EAX)				;
;---------------------------------------------------------------;

res_int10_vectors	proc	near

	push	es				;
	xor	ax,ax				;
	mov	es,ax				; (ES) = interrupt vector segment
	lodsd					; INT 10h data
	mov	es:[0040h],eax			; restore
	lodsd					; INT 6Dh data
	mov	es:[01b4h],eax			; restore
	lodsd					; [0:4A8h] data
	mov	es:[04a8h],eax			; restore
	pop	es				;
	ret

res_int10_vectors	endp

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
;---------------------------------------------------------------;
;		     GET_EBP_FOR_STACK_USAGE			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (EBP) current stack pointer			;
;	Register destroyed : (EBP)				;
;---------------------------------------------------------------;

get_ebp_for_stack_usage	proc	near

	push	esp				;
	mov	ebp,esp				;
	movzx	esp,sp				;
	db	66h				;
	leave					; (e)sp <-- (e)bp then pop (ebp)
	xchg	ebp,esp				;
	pushf					;
	add	ebp,2				; take care of CALL
	popf					;
	ret

get_ebp_for_stack_usage	endp

;---------------------------------------------------------------;

IF	IRQ_HANDLING_SUPPORT
;---------------------------------------------------------------;
;			   CHECK_IRQ_PM				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (ZF) 00 (NZ) IRQ based power management active	;
;		(ZF) 01 (ZR) SMI based power management active	;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

check_irq_pm	proc	near

	test	byte ptr ds:misc_proc_smi_info,irq_power_management; IRQ based power management ?
	ret

check_irq_pm	endp

;---------------------------------------------------------------;
;			   CHECK_IRQ_APM			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (ZF) 00 (NZ) IRQ based APM 16/32 bit function	;
;			     currently being executed		;
;		(ZF) 01 (ZR) IRQ based APM 16/32 bit function	;
;			     currently is not being executed	;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

check_irq_apm	proc	near

	call	check_irq_pm			; IRQ based power management currently being active ?
	jz	short check_irq_apm_00		; no...
	cmp	byte ptr ds:irq_apm_in_progress,00h; IRQ based APM currently active ?
	jz	short check_irq_apm_00		; no...
	test	byte ptr ds:apm_connection_info,apm_16bit_mode_connect_est or apm_32bit_mode_connect_est
check_irq_apm_00:
	ret

check_irq_apm	endp

;---------------------------------------------------------------;
ENDIF

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
;---------------------------------------------------------------;
;                           PM_FIXED_DELAY                      ;
;---------------------------------------------------------------;
;	Input : (CX) count of 15 microseconds to wait		;
;		STACK PRESENT					;
;	Output: NONE						;
;	Register destroyed : (CX)				;
;								;
; This routine is called to wait for 15 microseconds * count in ;
; (CX), then return.  Gives a programmed software delay.        ;
;---------------------------------------------------------------;

pm_fixed_delay	proc	near

	push    ax				;

	in      al,refresh_port			;
	smi_io_delay				; i/o delay
	and     al,refresh_bit			;
	mov     ah,al				;
pm_fixed_delay_1:
	in      al,refresh_port			;
	smi_io_delay				; i/o delay
	and     al,refresh_bit			;
	cmp     al,ah				;
	jz     short pm_fixed_delay_1		;
	mov     ah,al				;
	loop    short pm_fixed_delay_1		;

	pop     ax				;
	ret

pm_fixed_delay	endp

;---------------------------------------------------------------;
;			SINGLE_SHT_BEEP				;
;---------------------------------------------------------------;
;	Input : (BX) no. of short beeps				;
;	Output: NONE						;
;	Register destroyed : (AX),(BX),(CX)			;
; NOTE : This routine assumes port 61h & 8254 timer controller	;
;        counter 2 count and command byte have been saved before;
;	 calling this routine					;
;---------------------------------------------------------------;

single_sht_beep	proc	near

	mov	al,10110110b			; initialise timer #2
	out	timer_cntlr_1_cmd_reg,al	;
	smi_io_delay				; i/o delay
	mov	al,05h				; (al) = frequency low byte
	out	timer_cntlr_1_count2_reg,al	;
	smi_io_delay				; i/o delay
	out	timer_cntlr_1_count2_reg,al	; frequency high byte
	smi_io_delay				; i/o delay

next_beep:
	in	al,speaker_port			; (al) = read current status
	smi_io_delay				; i/o delay
	push	ax				;
	or	al,00000011b			; speaker gate, speaker bit
	out	speaker_port,al			; start the beep
	smi_io_delay				; i/o delay
	mov	cx,1000h			; beep duration
	call	pm_fixed_delay			;
	pop	ax				;
	and	al,11111101b			; reset speaker bit
	out	speaker_port,al			; no beep
	smi_io_delay				; i/o delay
	mov	cx,2000h			; no beep duration
	call	pm_fixed_delay			;
	dec	bx				; any more beep ?
	jnz	short next_beep			;
	ret

single_sht_beep	endp

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
;---------------------------------------------------------------;
;		       BCD_TO_BINARY				;
;---------------------------------------------------------------;
;	Input : (AL) BCD					;
;	Output: (AX) BINARY, (AH) = 00				;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

bcd_to_binary	proc	near

	mov	ah,al				; (ah) = (al) = BCD
	shr	ah,4				; (ah) = upper nibble of BCD
	and	al,00001111b			; (al) = lower nibble of BCD
	aad					; (al) = (ah)*10+(al)
						; (ah) = 00
	ret

bcd_to_binary	endp

;---------------------------------------------------------------;
;		     HR_MIN_SEC_TO_SEC				;
;---------------------------------------------------------------;
;	Input : (CH) hours in BCD				;
;		(CL) minutes in BCD				;
;		(DH) seconds in BCD				;
;	Output: (EAX) seconds in BINARY				;
;	Register destroyed : (EAX),(EDX),(BX),(CX)		;
;---------------------------------------------------------------;

hr_min_sec_to_sec	proc	near

	xchg	dh,ch				; (dh) = hours, (ch) = seconds
	mov	al,dh				; (al) = hours in BCD
	call	bcd_to_binary			; (ax) = hours in BINARY
	mov	bx,60				; 60 mins/hour, 60 secs/min
	mul	bl				; (ax) = hours converted to minutes in BINARY
	mov	dx,ax				;
	mov	al,cl				; (al) = minutes in BCD
	call	bcd_to_binary			; (ax) = minutes in BINARY
	add	ax,dx				; (ax) = total minutes in BINARY
	mul	bx				; (dx):(ax) = minutes converted to secs in BINARY
	shl	edx,16				;
	mov	dx,ax				; (edx) = secs in BINARY
	mov	al,ch				; (al) = seconds in BCD
	call	bcd_to_binary			; (ax) = seconds in BINARY
	movzx	eax,ax				;
	add	eax,edx				; (eax) = converted seconds in BINARY
	ret

hr_min_sec_to_sec	endp

;---------------------------------------------------------------;
;			 SEC_TO_HR_MIN_SEC			;
;---------------------------------------------------------------;
;	Input : (EAX) seconds in BINARY				;
;	Output: (CH) hours in BCD				;
;		(CL) minutes in BCD				;
;		(DH) seconds in BCD				;
;	Register destroyed : (EAX),(BX),(CX),(DX)		;
;---------------------------------------------------------------;

sec_to_hr_min_sec	proc	near

	mov	dx,ax				;
	shr	eax,16				;
	xchg	ax,dx				;
	mov	bx,60				; 60 mins/hour, 60 secs/min
	div	bx				; (ax) = minutes in BINARY
						; (dx) = seconds in BINARY
	div	bl				; (al) = hours in BINARY
						; (ah) = minutes in BINARY
	call	binary_to_bcd			; (al) = hours in BCD
	mov	ch,al				; (ch) = hours in BCD
	mov	al,ah				; (al) = minutes in BINARY
	call	binary_to_bcd			; (al) = minutes in BCD
	mov	cl,al				; (cl) = minutes in BCD
	mov	al,dl				; (al) = seconds in BINARY
	call	binary_to_bcd			; (al) = seconds in BCD
	mov	dh,al				; (dh) = seconds in BCD
	ret

sec_to_hr_min_sec	endp

;---------------------------------------------------------------;
;		       DATE_TO_BINARY				;
;---------------------------------------------------------------;
;	Input : (CH) century in BCD				;
;		(CL) year in BCD				;
;		(DH) month in BCD				;
;		(DL) day in BCD					;
;	Output: (AH)++ century in BINARY			;
;		(AH)+  year in BINARY				;
;		(AH)   month in BINARY				;
;		(AL)   day in BINARY				;
;	Register destroyed : (EAX),(CX),(DX)			;
;---------------------------------------------------------------;

date_to_binary	proc	near

	mov	al,ch				; (al) = century in BCD
	call	bcd_to_binary			; (al) = century in BINARY
	xchg	al,cl				; (cl) = century in BINARY
						; (al) = year in BCD
	call	bcd_to_binary			; (al) = year in BINARY
	mov	ah,cl				; (ah) = century in BINARY
	shl	eax,16				; (ah)++ = century in BINARY
						; (ah)+ = year in BINARY
	mov	al,dh				; (al) = month in BCD
	call	bcd_to_binary			; (al) = month in BINARY
	xchg	al,dl				; (dl) = month in BINARY
						; (al) = day in BCD
	call	bcd_to_binary			; (al) = day in BINARY
	mov	ah,dl				; (ah) = month in BINARY
	ret

date_to_binary	endp

;---------------------------------------------------------------;
;		        BINARY_TO_BCD				;
;---------------------------------------------------------------;
;	Input : (AL) BINARY					;
;	Output: (AL) BCD					;
;	Register destroyed : (AL)				;
;---------------------------------------------------------------;

binary_to_bcd	proc	near

	push	cx				;
	mov	ch,ah				; save (ah) in (ch)	
	xor	ah,ah				; (ax) = BINARY
	mov	cl,10				;
	div	cl				; (al) = quotient, (ah) = remainder
	shl	al,4				;
	and	ah,00001111b			;
	or	al,ah				; (al) = BCD
	mov	ah,ch				; restore (ah)
	pop	cx				;
	ret

binary_to_bcd	endp

;---------------------------------------------------------------;
;		        GET_RTC_DATE				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (DL) date					;
;		(DH) month					;
;		(CL) year					;
;		(CH) century					;
;	Register destroyed : (AX),(CX),(DX)			;
;---------------------------------------------------------------;

get_rtc_date	proc	near

	call	wait_for_update_complete	; wait for RTC update over

	mov	cl,cmos_century or 10000000b	; CMOS address for century with NMI off
	mov	dx,(cmos_year or 10000000b)*256+(cmos_month or 10000000b); CMOS address for year,mon with NMI off
	mov	al,cmos_date or 10000000b	; CMOS address for date with NMI off
	call	smi_cmos_data_in_x		;
	xchg	al,dl				; (DL) = date
	jmp	short get_rtc_date_10		;

get_rtc_date	endp

;---------------------------------------------------------------;
;		          GET_RTC_TIME				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (DH) seconds					;
;		(CL) minutes					;
;		(CH) hour					;
;	Register destroyed : (AX),(CX),(DX)			;
;---------------------------------------------------------------;

get_rtc_time	proc	near

	call	wait_for_update_complete	; wait for RTC update over

	mov	cl,cmos_hours or 10000000b	; CMOS address for hours with NMI off
	mov	dh,cmos_minutes	or 10000000b	; CMOS address for min with NMI off
	mov	al,cmos_seconds	or 10000000b	; CMOS address for sec with NMI off

;-----------------------------------------------;

get_rtc_date_10::
	call	smi_cmos_data_in_x		;
	xchg	al,dh				; (DH) = seconds/month
	call	smi_cmos_data_in_x		;
	xchg	al,cl				; (CL) = minutes/year
	call	smi_cmos_data_in		;
	xchg	al,ch				; (CH) = hours/century
	ret

get_rtc_time	endp

;---------------------------------------------------------------;
;			   READ_RTC_ALARM			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (CF) (CY) error...CMOS inoperational		;
;		(CF) (NC) no error &				;
;		     (ZF) (ZR) alarm disabled			;
;		     (ZF) (NZ) alarm enabled &			;
;				(CH) alarm hour in BCD		;
;				(CL) alarm minutes in BCD	;
;				(DH) alarm seconds in BCD	;
;	Register destroyed : (AX),(CX),(DX)			;
;---------------------------------------------------------------;

read_rtc_alarm	proc	near

	call	wait_for_update_complete	; update complete ?
	jnz	short read_rtc_alarm_01		; no...

	mov	al,cmos_alarm_hour or 10000000b	; NMI off
	mov	cx,(cmos_alarm_minute or 10000000b)*256+(cmos_alarm_second or 10000000b); NMI off

	call	smi_cmos_data_in_x		; (al) = read the data
	xchg	al,ch				; (ch) = first data
						; (al) = next CMOS index to read
	call	smi_cmos_data_in_x		; (al) = read the data
	xchg	al,cl				; (cl) = second data
						; (al) = next CMOS index to read
	call	smi_cmos_data_in_x		; (al) = read the data
	xchg	al,dh				; (dh) = third data

	call	cmos_stat_reg_b_read		; (al) = read status reg 0Bh data
	test	al,alarm_intr_bit		; alarm interrupt enabled ?
						; (cy) = 00 for no error
	ret

;-----------------------------------------------;

read_rtc_alarm_01:
	stc					; set (cy) = 01 for error
	ret

read_rtc_alarm	endp

;---------------------------------------------------------------;
;		   WAIT_FOR_UPDATE_COMPLETE			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (ZF) set means update complete			;
;		(ZF) NZ means update in progress		;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

wait_for_update_complete	proc	near

	push	cx				;
	push	ax				;
	mov	cx,upd_check_loop_time		; update in progress check loop count
update_complete_01:
	mov	al,cmos_stat_reg_a or 10000000b	; NMI off
	call	smi_cmos_data_in_x		; (al) = read the data
	test	al,update_in_progress_bit	; update in progress ?
	loopnz	update_complete_01		; yes...
	pop	ax				;
	pop	cx				;
	ret

wait_for_update_complete	endp

;---------------------------------------------------------------;
;			CMOS_STAT_REG_B_READ			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (AL) data read					;
;	Register destroyed : (AL)				;
;---------------------------------------------------------------;

cmos_stat_reg_b_read	proc	near

	mov	al,cmos_stat_reg_b or 10000000b	; NMI off
	jmp	short cmos_stat_reg_read	; (al) = read the data

cmos_stat_reg_b_read	endp

;---------------------------------------------------------------;
;			CMOS_STAT_REG_C_READ			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (AL) data read					;
;	Register destroyed : (AL)				;
;---------------------------------------------------------------;

cmos_stat_reg_c_read	proc	near

	mov	al,cmos_stat_reg_c or 10000000b	; NMI off

;---------------------------------------------------------------;
;			CMOS_STAT_REG_READ			;
;---------------------------------------------------------------;
;	Input : (AL) CMOS status register to read		;
;	Output: (AL) data read					;
;	Register destroyed : (AL)				;
;---------------------------------------------------------------;

cmos_stat_reg_read	proc	near

	call	smi_cmos_data_in		; (al) = read the data
	ret

cmos_stat_reg_read	endp
cmos_stat_reg_c_read	endp

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
;---------------------------------------------------------------;

