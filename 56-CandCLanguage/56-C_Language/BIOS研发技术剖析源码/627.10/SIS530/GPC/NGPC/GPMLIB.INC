subttl.	Include file for GREEN PC support LIBRARY code....GPMLIB.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

;;	public	vesa_low_power_request		;

;;	public	ide_low_power_request		;

;;	public	save_suspend_date_time		;
;;	public	res_suspend_date_time		;

;;	public	save_lock_kb_cntlr		;
;;	public	res_kb_cntlr			;
;;	public	read_kb_cntlr_data		;
;;	public	write_kb_cntlr_cmd		;
;;	public	get_ami_megakey2_hk_scan_code	;

;;	public	set_rtc_alarm_during_suspend	;
;;	public	restore_rtc_on_resume		;

;;	public	set_apm_resume_timer		;
;;	public	check_apm_resume_date		;
;;	public	is_it_alarm_resume		;

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
;	    CODE TO HANDLE DISPLAY POWER MANAGEMENT		;
;	    CODE TO HANDLE DISPLAY POWER MANAGEMENT		;
;	    CODE TO HANDLE DISPLAY POWER MANAGEMENT		;
;	    CODE TO HANDLE DISPLAY POWER MANAGEMENT		;
;---------------------------------------------------------------;
; All the code from here labelled as 'DISP_POWER_DOWN' to	;
; the label 'DISP_POWER_DOWN_ENDS' should be made active if	;
; you need to use VESA display power down commands.		;
; Following routine needs to be called...			;
;		VESA_LOW_POWER_REQUEST				;
;---------------------------------------------------------------;

IF	VESA_POWER_DOWN_SUPPORT

disp_power_down	label	byte

;---------------------------------------------------------------;
;                  VESA_LOW_POWER_REQUEST                	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(CX) controller unit# (currently 0000h for	;
;				       primary controller)	;
;		(BL) 000h ... get power state			;
;		     0ffh ... set power state &			;
;			(BH) 00h ... ON				;
;			     01h ... STANDBY			;
;			     02h ... SUSPEND			;
;			     04h ... OFF			;
;	Output: (CY) 00h function successful & for get_power_state
;			 request (BH) 00h ... ON		;
;				      01h ... STANDBY		;
;				      02h ... SUSPEND		;
;				      04h ... OFF		;
;		(CY) 01h for error &				;
;			 (AH) 01h ... req vbe/pm func not supported
;			      02h ... req power state not supported
;	Register destroyed : all general purpose registers	;
;---------------------------------------------------------------;

vesa_low_power_request	proc	near

IF	IRQ_HANDLING_SUPPORT
	call	check_irq_apm			; IRQ based APM 16/32 bit function currently being executed ?
	jnz	short vesa_low_power_req_20	; yes...
ENDIF

	mov	si,disp_0_control_struc		; currently assume primary controller support only
	and	bh,vbe_pm_standby_bit or vbe_pm_suspend_bit or vbe_pm_off_bit or vbe_pm_reduced_on_bit
	test	byte ptr [si+disp_misc_control_info],vbe_pm_interface_supported
	jnz	short vesa_low_power_req_10	; VESA VBE/PM interface supported

vesa_low_power_req_20:
	or	bl,bl				; get power state request ?
	jz	short vesa_low_power_req_01	; yes...return with error
	or	bh,bh				; request for 'ON' ?
	jz	short vesa_low_power_req_02	; yes...
	call	disable_video_display_3c0	; disable video for any low power mode
	call	disable_video_display_3c4	; disable video for any low power mode
	call	disable_horz_vert_retrace	; disable horizontal/vertical retrace
vesa_low_power_req_01:
	mov	ah,vbe_pm_req_func_not_supported; requested VBE/PM function not supported
	stc					; (cy) = 01 for error
	ret

vesa_low_power_req_02:
	call	enable_horz_vert_retrace	; enable horizontal/vertical retrace
	call	enable_video_display_3c0	; enable video for ON
	call	enable_video_display_3c4	; enable video for ON
	jmp	short vesa_low_power_req_01	;

;-----------------------------------------------;

vesa_low_power_req_10:
	or	bl,bl				; get power state request ?
	jnz	short vesa_low_power_req_11	; no...
	mov	bl,get_disp_power_state		; get display power state
	call	exec_vesa_vbe_pm_func		;
	ret

;-----------------------------------------------;

vesa_low_power_req_11:
	or	bh,bh				; set power state to 'ON' ?
	jnz	short vesa_low_power_req_12	; no...
	mov	bl,set_disp_power_state		; set display power state
	call	exec_vesa_vbe_pm_func		;
	pushf					;
;;	call	enable_video_display_3c0	; enable video for ON
	call	enable_video_display_3c4	; enable video for ON
;; green monitor can not off when suspend mode
	call	enable_horz_vert_retrace	; enable horizontal/vertical retrace
	call	enable_video_display_3c0	; enable video for ON
	popf					;
	ret

;-----------------------------------------------;

vesa_low_power_req_12:
	test	[si+disp_vbe_supported_power_mode],bh; requested power state mode supported ?
	jz	short vesa_low_power_req_13	; no...

;-----------------------------------------------;
;	TAKE OUT COMMENT FROM FOLLOWING		;
;	CODE IF YOU WANT TO CHECK CURRENT	;
;	POWER SAVING MODE GREATER THAN		;
;	REQUESTED MODE OR NOT.			;
;-----------------------------------------------;
;						;
;	push	bx				; save (bh) = requested power state
;	mov	bl,get_disp_power_state		; get display power state
;	call	exec_vesa_vbe_pm_func		; (bh) = current display power state 
;	and	bh,vbe_pm_standby_bit or vbe_pm_suspend_bit or vbe_pm_off_bit or vbe_pm_reduced_on_bit
;	mov	dh,bh				; (dh) = current display power state
;	pop	bx				; (bh) = requested display power state
;	jc	short vesa_low_power_req_14	; function not supported
;	cmp	dh,bh				; is current power state more power managed ?
;	jae	short vesa_low_power_req_15	; currently doing better power saving
;vesa_low_power_req_14:				;
;						;
;-----------------------------------------------;

	mov	bl,set_disp_power_state		; set display power state
	call	exec_vesa_vbe_pm_func		;
vesa_low_power_req_15:
	pushf					;
;;	call	disable_video_display_3c0	; disable video
	call	disable_video_display_3c4	; disable video
;; green monitor can not off when suspend mode
	call	disable_video_display_3c0	; disable video for any low power mode
	call	disable_horz_vert_retrace	; disable horizontal/vertical retrace
	popf					;
	ret

vesa_low_power_req_13:
	mov	ah,vbe_pm_req_state_not_supported; requested VBE/PM state not supported
	stc					; (cy) = 01 for error
	jmp	short vesa_low_power_req_15	;

vesa_low_power_request	endp

;---------------------------------------------------------------;
;			EXEC_VESA_VBE_PM_FUNC			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(SI) display control info pointer		;
;		(BL) 01h/02h ... set/get power state		;
;		(BH) requested state if (BL) = 01h		;
;	Output: (CY) 00 for no error &				;
;		     (BH) has current state for (BL) = 02h	;
;		(CY) 01h for error &				;
;			 (AH) 01h ... req vbe/pm func not supported
;			      02h ... req power state not supported
;	Register destroyed : all general purpose except (SI)	;
;---------------------------------------------------------------;

exec_vesa_vbe_pm_func	proc	near

	push	si				;
	mov	ax,vesa_ext_func*256+vesa_vbe_pm_services_func; extended VESA VBE/PM function call
	mov	cl,[si+disp_misc_control_info]	;
	and	cx,vbe_pm_cntlr_mask		; (cx) = controller #
	call	smi_int_10h			; issue INT 10H
	pop	si				;
	cmp	al,vesa_ext_func		; VESA VBE/PM function supported ?
	jnz	short exec_vesa_pm_func_00	; no...
	or	ah,ah				; function call failed ?
	mov	ah,vbe_pm_req_state_not_supported; requested state not supported
	jnz	short exec_vesa_pm_func_01	; yes...
	ret

exec_vesa_pm_func_00:
	mov	ah,vbe_pm_req_func_not_supported; requested VESA VBE/PM function not supported
exec_vesa_pm_func_01:
	stc					; (CY) = 01 for error
	ret

exec_vesa_vbe_pm_func	endp
 
;---------------------------------------------------------------;

disp_power_down_ends	label	byte

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
;	    CODE TO HANDLE IDE DRIVE POWER MANAGEMENT		;
;	    CODE TO HANDLE IDE DRIVE POWER MANAGEMENT		;
;	    CODE TO HANDLE IDE DRIVE POWER MANAGEMENT		;
;	    CODE TO HANDLE IDE DRIVE POWER MANAGEMENT		;
;---------------------------------------------------------------;
; All the code from here labelled as 'IDE_POWER_DOWN' to	;
; the label 'IDE_POWER_DOWN_ENDS' should be made active if	;
; you need to use IDE drive power down commands.		;
; Following routine needs to be called...			;
;		IDE_LOW_POWER_REQUEST				;
;---------------------------------------------------------------;

IF	IDE_POWER_DOWN_SUPPORT

ide_power_down	label	byte

;---------------------------------------------------------------;
;                  IDE_LOW_POWER_REQUEST                	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(DL) bit 0 = 1 ... drive 0 of primary controller;
;		     bit 1 = 1 ... drive 1 of primary controller;
;		     bit 2 = 1 ... drive 0 of secondary controller
;		     bit 3 = 1 ... drive 1 of secondary controller
;								;
;		     bit 4 = 1 ... request for standby/standby	;
;				   immediate command		;
;		     bit 5 = 1 ... request for idle/idle	;
;				   immediate command		;
;								;	 
;		(DH) 0ffh do not program timer into sec count reg
;		     <> 0ffh program (dh) in sector count reg	;
;			     actual time = (dh) * 5 seconds	;
;		STACK PRESENT					;
;	Output:	(DL) bit 0 = 1 ... drive 0 of primary controller;
;					* requested and failed	;
;			     0 ... drive 0 of primary controller;
;					* not requested or	;
;					* requested but absent or
;					* requested and passed	;
;		     bit 1 = 1 ... drive 1 of primary controller;
;					* requested and failed	;
;			     0 ... drive 1 of primary controller;
;					* not requested or	;
;					* requested but absent or
;					* requested and passed	;
;		     bit 2 = 1 ... drive 0 of secondary controller
;					* requested and failed	;
;			     0 ... drive 0 of secondary controller
;					* not requested or	;
;					* requested but absent or
;					* requested and passed	;
;		     bit 3 = 1 ... drive 1 of secondary controller
;					* requested and failed	;
;			     0 ... drive 1 of secondary controller
;					* not requested or	;
;					* requested but absent or
;					* requested and passed	;
;		     bit 7-4 ... same as input			;
;	Register destroyed : (AX),(DL)				;
;								;
; This subroutine is called to write low power command to the	;
; ide drive. This routine checks for the drive presence.       	;
;								;
; assumption:   Hardware interrupt for the ide is masked on	;
;		entry to this subroutine.                       ;
;---------------------------------------------------------------;

ide_low_power_request	proc	near

	push	bx				;
	push	cx				;

	mov	ch,no_of_ide_drv_supported	; check for 4 drives
	mov	cl,00000001b			; start with drive 0 of primary controller
	mov	bx,hdd_0_control_struc		; control info pointer for drive 0 of primary controller

low_power_request_00:
	test	dl,cl				; request for current drive ?
	jz	short low_power_request_01	; no...
	call	ide_low_power_cmd_ext		; execute the low power command
	jc	short low_power_request_01	; failed in low power request
	xor	dl,cl				; requested but absent/requested and passed
low_power_request_01:
	shl	cl,1				; position it for next drive
	add	bx,struc_hdd_x_info_size	; control info pointer for next drive
	dec	ch				; decrement # of drives
	jnz	short low_power_request_00	;

	pop	cx				;
	pop	bx				;
	ret

ide_low_power_request	endp

;---------------------------------------------------------------;
;                  IDE_LOW_POWER_CMD_EXT                	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(BX) control information pointer for the drive	;
;		(CL) drive# to be checked in bits 0 thru 3	;
;		(DL) bit 0 = 1 ... drive 0 of primary controller;
;		     bit 1 = 1 ... drive 1 of primary controller;
;		     bit 2 = 1 ... drive 0 of secondary controller
;		     bit 3 = 1 ... drive 1 of secondary controller
;								;
;		     bit 4 = 1 ... request for standby/standby	;
;				   immediate command		;
;		     bit 5 = 1 ... request for idle/idle	;
;				   immediate command		;
;								;	 
;		(DH) 0ffh do not program timer into sec count reg
;		     <> 0ffh program (dh) in sector count reg	;
;			     actual time = (dh) * 5 seconds	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;	Register destroyed : (AX)				;
;								;
; This subroutine is called to write low power command to the	;
; ide drive. This routine checks for the drive presence.       	;
;								;
; assumption:   Hardware interrupt for the ide is masked on	;
;		entry to this subroutine.                       ;
;---------------------------------------------------------------;

ide_low_power_cmd_ext	proc	near

	test	byte ptr [bx+hdd_misc_control_info],hdd_present_bit_equ; current drive present ?
	jz	short low_power_cmd_ext_00	; no...
	test	dl,00010000b			; request for standby/standby immediate ?
	jz	short low_power_cmd_ext_01	; no...
	call	ide_exec_standby_command	; execute standby/standby immediate
low_power_cmd_ext_00:
	ret

low_power_cmd_ext_01:
	test	dl,00100000b			; request for idle/idle immediate ?
	jz	short low_power_cmd_ext_00	; no...
	call	ide_exec_idle_command		; execute idle/idle immediate
	ret

ide_low_power_cmd_ext	endp

;---------------------------------------------------------------;
;                  IDE_EXEC_STANDBY_COMMAND                	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(BX) control information pointer for the drive	;
;		(DH) 0ffh do not program timer into sec count reg
;		     <> 0ffh program (dh) in sector count reg	;
;			     actual time = (dh) * 5 seconds	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;	Register destroyed : (AX)				;
;								;
; This subroutine is called to write standby command to the ide	;
; drive                                                 	;
;								;
; assumption:   Hardware interrupt for the ide is masked on	;
;		entry to this subroutine.                       ;
;---------------------------------------------------------------;

ide_exec_standby_command	proc	near

	push	di				;
	push	cx				;	
	cmp	dh,0ffh				; standby immediate ?
	jz	short exec_standby_cmd_00	; yes...
	mov	cx,standby_old_cmd*256+standby_cmd; STANDBY command with count
						; if count is zero, drive's automatic
						; power management is disabled
	mov	di,hdd_standby_cmd_save		; offset for standby command save
	jmp	short exec_standby_cmd_01	;

exec_standby_cmd_00:
	mov	cx,standby_immediate_old_cmd*256+standby_immediate_cmd; STANDBY command with no count
						; controller should use previous count
	mov	di,hdd_standby_imm_cmd_save	; offset for standby immediate command save
exec_standby_cmd_01:

;-----------------------------------------------;

exec_idle_cmd_01::

	call	ide_exec_power_mode_dup_func	; execute STANDBY command
	pop	cx				;
	pop	di				;
	ret

ide_exec_standby_command	endp

;---------------------------------------------------------------;
;                  IDE_EXEC_IDLE_COMMAND                	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(BX) control information pointer for the drive	;
;		(DH) 0ffh do not program timer into sec count reg
;		     <> 0ffh program (dh) in sector count reg	;
;			     actual time = (dh) * 5 seconds	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;	Register destroyed : (AX)				;
;								;
; This subroutine is called to write idle command to the ide	;
; drive                                                 	;
;								;
; assumption:   Hardware interrupt for the ide is masked on	;
;		entry to this subroutine.                       ;
;---------------------------------------------------------------;

ide_exec_idle_command	proc	near

	push	di				;
	push	cx				;	
	cmp	dh,0ffh				; idle immediate ?
	jz	short exec_idle_cmd_00		; yes...
	mov	cx,idle_old_cmd*256+idle_cmd	; IDLE command with count
						; if count is zero, drive's automatic
						; power management is disabled
	mov	di,hdd_idle_cmd_save		; offset for idle command save
	jmp	short exec_idle_cmd_01		;

exec_idle_cmd_00:
	mov	cx,idle_immediate_old_cmd*256+idle_immediate_cmd; IDLE command with no count
						; controller should use previous count
	mov	di,hdd_idle_imm_cmd_save	; offset for idle immediate command save
	jmp	short exec_idle_cmd_01		;

ide_exec_idle_command	endp

;---------------------------------------------------------------;
;                  IDE_EXEC_POWER_MODE_DUP_FUNC                	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(BX) control information pointer for the drive	;
;		(DI) offset to command save			;
;		(CL) primary command				;
;		(CH) alternate command				;
;		(DH) 0ffh do not program timer into sec count reg
;		     <> 0ffh program (dh) in sector count reg	;
;			     actual time = (dh) * 5 seconds	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;	Register destroyed : (AX)				;
;								;
; This subroutine is called to write a power control command to ;
; the ide drive                                                 ;
;								;
; assumption:   Hardware interrupt for the ide is masked on	;
;		entry to this subroutine.                       ;
;---------------------------------------------------------------;

ide_exec_power_mode_dup_func	proc	near

	mov	al,[bx+di]			; (al) = power management command to be used with the drive
	cmp	al,0ffh				; any command supported by this drive ?
	jz	short exec_dup_func_00		; no...
	cmp	al,00h				; any valid command already established for this drive ?
	jnz	short exec_dup_func_01		; yes...use that command
	mov	al,cl				; (al) = primary command
	call	ide_execute			; execute the command
	jnc	short exec_dup_func_02		; no error
	mov	al,ch				; (al) = alternate command
	call	ide_execute			; execute the command
	jnc	short exec_dup_func_02		; no error...
	mov	byte ptr [bx+di],0ffh		; set for no command supported
exec_dup_func_00:
	stc					; (cy) = 01 for error
exec_dup_func_02:
	ret

exec_dup_func_01:
	call	ide_execute			; execute the command
	ret

ide_exec_power_mode_dup_func	endp

;---------------------------------------------------------------;
;			IDE_EXECUTE				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(BX) control information pointer for the drive	;
;		(DI) offset to command save			;
;		(AL) power mode control command			;
;		(DH) 0ffh do not program timer into sec count reg
;		     <> 0ffh program (dh) in sector count reg	;
;			     actual time = (dh) * 5 seconds	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error & (AH) has error code		;
;	Register destroyed : (AX)				;
;								;
; This subroutine is called to write a power control command to ;
; the ide drive                                                 ;
;								;
; assumption:   Hardware interrupt for the ide is masked on	;
;		entry to this subroutine.                       ;
;---------------------------------------------------------------;

ide_execute	proc	near

	mov	ah,dh				; (ah) = timer information
	mov	[bx+di],al			; save primary/alternate command
	call	ide_exec_power_mode_func	; execute the command
	ret

ide_execute	endp

;---------------------------------------------------------------;
;                     IDE_EXEC_POWER_MODE_FUNC                	;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(BX) control information pointer for the drive	;
;		(AL) power mode control command			;
;		(AH) 0ffh do not program timer into sec count reg
;		     <> 0ffh program (ah) in sector count reg	;
;			     actual time = (ah) * 5 seconds	;
;		STACK PRESENT					;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error & (AH) has error code		;
;	Register destroyed : (AX)				;
;								;
; This subroutine is called to write a power control command to ;
; the ide drive                                                 ;
;								;
; assumption:   Hardware interrupt for the ide is masked on	;
;		entry to this subroutine.                       ;
;---------------------------------------------------------------;

ide_exec_power_mode_func	proc	near

	push    di				;
	push    dx				;
	push    cx				;

	pushf					; save current interrupt status
	cli					; disable interrupts

	push    ax                      	; save (al) = power mode controller command
	mov     di,primary_ide_cntlr	   	; (di) = base address for primary IDE controller
	test    byte ptr [bx+hdd_misc_control_info],hdd_port_select_bit_equ ; secondary IDE controller ?
	jz      short exec_power_mode_func_00	; no..primary IDE controller
	mov     di,secondary_ide_cntlr		; (di) = base address for secondary IDE controller
exec_power_mode_func_00:
	mov	dx,di				; (dx) = base address for IDE controller
	add	dx,status_reg_off		; (dx) = ide status reg (1f7h/177h)
	in	al,dx				; (al) = current status
	test	al,ide_cntlr_busy_bit		; is controller busy ?
	jnz	short exec_power_mode_func_03	; yes...error...exit

	mov     al,10100000b			; drive/head reg data for drive 0
	test    byte ptr [bx+hdd_misc_control_info],hdd_drive_select_bit_equ; drive 0 ?
	jz      short exec_power_mode_func_05	; yes..
	mov     al,10110000b            	; drive/head reg data for drive 1
exec_power_mode_func_05:
	mov	dx,di				; (dx) = base address for IDE controller
	add	dx,drive_head_reg_off		; (dx) = drive/head reg (1f6h/176h)
	out	dx,al				; select the drive
	mov	cx,8				; 120 micro sec delay (TIME might be more if slow refresh)
	call	pm_fixed_delay			;
	mov	dx,di				; (dx) = base address for IDE controller
	add	dx,status_reg_off		; (dx) = ide status reg (1f7h/177h)
	in	al,dx				; (al) = read current status
	and	al,ide_drv_rdy_bit or ide_drv_seek_complete_bit
	cmp	al,ide_drv_rdy_bit or ide_drv_seek_complete_bit; is drive ready and seek complete ?
	jnz	short exec_power_mode_func_03	; no...error...exit

	cmp     ah, 0ffh                	; program sector count ?
	jz      short skip_sector_count_prg	; no...
	mov     dx, di                  	; (dx) = base address for IDE controller
	add     dx, sector_count_reg_off	; (dx) = sector count reg (1f2h/172h)
	mov     al, ah				; (al) = count of 5 seconds IDLE timer
	out     dx, al				; program the counter
	smi_io_delay				; i/o delay
skip_sector_count_prg:  
	pop     ax				; (al) = power mode drive command
	mov	dx,di				; (dx) = base address for IDE controller
	add	dx,command_reg_off		; (dx) = command register (1f7h/177h)
	out	dx,al				; output command to controller

	call    ide_wait_for_interrupt		; interrupt came ?
	jz      short exec_power_mode_func_01	; no...error...exit

	mov	dx,di				; (dx) = base address for IDE controller
	add	dx,status_reg_off		; (dx) = ide status reg (1f7h/177h)
	in	al,dx				; (al) = current status
	test	al,ide_drv_rdy_bit		; drive ready ?
	jz	short exec_power_mode_func_01	; no...error...exit
	test	al,ide_drv_seek_complete_bit	; seek complete ?
	jz	short exec_power_mode_func_01	; no...error...exit
	test	al,ide_drv_wt_fault_bit or ide_data_corrected_bit; write fault or data corrected error ?
	jnz	short exec_power_mode_func_01	; yes...error...exit
	test	al,ide_err_reg_bit		; error reg has any error info
	jz	short exec_power_mode_func_02	; no...eror free completion...(CY) set to (NC)

	mov	dx,di				; (dx) = base address for IDE controller
	add	dx,error_reg_off		; (dx) = error reg (1f7h/177h)
	in	al,dx				; (al) = current error reg status
						; this read will clear the error status

exec_power_mode_func_01:
	mov	ah,undefined_err		; undefined error
exec_power_mode_func_04:
	popf					; restore interrupt status
	stc					; (cy) = 01 for error

exec_power_mode_func_10:
	pop     cx				;
	pop     dx				;
	pop     di				;
	ret

exec_power_mode_func_03:
	pop     ax				;
	mov	ah,time_out_err			; timeout error
	jmp	short exec_power_mode_func_04	;

exec_power_mode_func_02:
	popf					; restore interrupt status
	clc					; (cy) = 00 for no error
	jmp	short exec_power_mode_func_10	;

ide_exec_power_mode_func	endp

;---------------------------------------------------------------;
;                      IDE_WAIT_FOR_INTERRUPT             	;
;---------------------------------------------------------------;
;	Input : (DI) base address for IDE controller		;
;		(DX) command/status reg for IDE controller	;
;		(BX) control information pointer for the drive	;
;		(DS) PM BIOS data segment			;
;		STACK PRESENT					;
;	Output: (ZF) 00 (NZ) interrupt active			;
;		(ZF) 01 (ZR) interrupt not active 		;
;	Register destroyed : (AX),(CX),(DX)			;
;								;
; This subroutine is called after a command is writen to the IDE;
; command port to wait for the interrupt to be returned by the	;
; IDE. It will poll the IDE intr level until an IRQ or time-out.;
;---------------------------------------------------------------;

ide_wait_for_interrupt	proc	near

	push	si				;

IF	IRQ_HANDLING_SUPPORT
	call	check_irq_pm			; IRQ based power management ?
	jnz	short ide_wait_for_interrupt_12	; yes...
ENDIF

	mov     cl,[bx+hdd_misc_control_info]	; (cl) = IDE miscellaneous control information
	mov     dx,control_8259_slave 	        ; (dx) = 8259 slave control port (0a0h)
	test	cl,00001000b			; IRQ level 0 thru 7 ?
	jnz	short ide_wait_for_interrupt_01	; no...level 8 thru 15
	mov     dx,control_8259_master 	        ; (dx) = 8259 master control port (020h)
ide_wait_for_interrupt_01:
	and     cl,00000111b                    ; make the level 0 thru 7
	mov     ah,00000001b			;
	shl     ah,cl                           ; get in proper bit position

ide_wait_for_interrupt_12:
	mov     si,wfiloop                      ; wait for interrupt timeout (16 secs)

ide_wait_for_interrupt_02:
	xor     cx, cx                          ; 1 sec loop count
ide_wait_for_interrupt_03:

IF	IRQ_HANDLING_SUPPORT
	call	check_irq_pm			; IRQ based power management ?
	jnz	short ide_wait_for_interrupt_10	; yes...
ENDIF

	call	read_8259_irr_reg		; interrupt came ?
ide_wait_for_interrupt_11:
	jnz	short ide_wait_for_interrupt_04	; yes....

	push    cx				;
	mov     cx, 2				; give 15 microsec delay
	call    pm_fixed_delay			; PM_FIXED_DELAY ROUTINE MAY NOT BE ABLE TO GIVE 15 MICROSEC DELAY
	pop     cx				;
	loop    short ide_wait_for_interrupt_03	;

 	dec     si                              ; does not disturb (CF)
	jnz     short ide_wait_for_interrupt_02	;
ide_wait_for_interrupt_04:
	pop	si				;
	ret

IF	IRQ_HANDLING_SUPPORT
ide_wait_for_interrupt_10:
	in	al,dx				; (al) = current status
	not	al				;
	test	al,ide_cntlr_busy_bit		; controller busy ?
	jmp	short ide_wait_for_interrupt_11	;
ENDIF

ide_wait_for_interrupt	endp

;---------------------------------------------------------------;

ide_power_down_ends	label	byte

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
;		  CODE TO UPDATE DOS DATE/TIME			;
;		  CODE TO UPDATE DOS DATE/TIME			;
;		  CODE TO UPDATE DOS DATE/TIME			;
;		  CODE TO UPDATE DOS DATE/TIME			;
;---------------------------------------------------------------;
; All the code from here labelled as 'DOS_DATE_TIME_RESTORE' to	;
; the label 'DOS_DATE_TIME_RESTORE_ENDS' should be made active if
; dos date/time needs to be updated during sleep & suspend. The ;
; chipset should update date/time if chipset porting stops cpu	;
; clock for more than one timer ticks. The following routines	;
; can update dos date/time only.......				;
; Please take the comment out in between the above mentioned	;
; labels if you want to use this routines.			;
; In this scenario where system date/time needs to be updated, you
; should setup proper apm events (if apm is enabled) depending on
; apm V1.0 & v1.1, so that dos/windows automatically updates the;
; system date/time.						;
; Following two routines needs to be called...			;
;		SAVE_SUSPEND_DATE_TIME				;
;		RES_SUSPEND_DATE_TIME				;
;	CALL 'save_suspend_date_time' while going to SLEEP/SUSPEND
;	CALL 'res_suspend_date_time' while coming out of	;
;	SLEEP/SUSDPEND						;
;---------------------------------------------------------------;

IF	DATE_TIME_UPDATION_SUPPORT

dos_date_time_restore	label	byte

;---------------------------------------------------------------;
;		    SAVE_SUSPEND_DATE_TIME			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for err..RTC inoperational		;
;	Register destroyed : NONE				;
; NOTE : Saves date on suspend in local SUSPEND_DATE structure	;
;---------------------------------------------------------------;

save_suspend_date_time	proc	near

IF	IRQ_HANDLING_SUPPORT
	call	check_irq_apm			; IRQ based APM 16/32 bit function currently being executed ?
	jnz	short save_suspend_date_time_20	; yes...
ENDIF

        pushad					;	

        call    get_rtc_date			; Read RTC Date
						; returns (ch) = century, (cl) = year
						; (dh) = month, (dl) = date
        call    date_to_binary			; (eax) = century/year/month/day in BINARY
        mov     ds:suspend_date,eax 		; save in local data area
        clc					; (cy) = 00 for no error
	popad					;

save_suspend_date_time_20:
        ret

save_suspend_date_time	endp

;---------------------------------------------------------------;
;		    RES_SUSPEND_DATE_TIME			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for err..RTC inoperational		;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

res_suspend_date_time	proc	near

IF	IRQ_HANDLING_SUPPORT
	call	check_irq_apm			; IRQ based APM 16/32 bit function currently being executed ?
	jnz	short res_suspend_date_time_20	; yes...
ENDIF

	call	set_dos_time			;
	call	set_dos_date			;

res_suspend_date_time_20:
	ret

res_suspend_date_time	endp

;---------------------------------------------------------------;
;		         SET_DOS_TIME				;
;---------------------------------------------------------------;
;	Input : NONE						;	
;	Output: (CY) 00 for no error				;
;		(CY) 01 for err..RTC inoperational		;
;	Register destroyed : NONE				;
;  NOTE : Sets DOS TIME in BIOS global based on current RTC time;
;---------------------------------------------------------------;

set_dos_time	proc	near

	pushad					;
	call	get_rtc_time			; Read RTC time
						; returns (ch) = hour, (cl) = minute
						; (dh) = seconds
	call	hr_min_sec_to_sec		; (eax) = total seconds in BINARY
	call	seconds_to_timer_ticks		; (eax) = total timer ticks

	push	ds				; save on entry (ds)
	push	bios_data_seg			; BIOS standard data segment
	pop	ds				;
	mov	dword ptr timer_low_count,eax	; set DOS time
	pop	ds				; restore on entry (ds)

	clc					; set (cy) = 00 for no error
	popad					;
	ret

set_dos_time	endp

;---------------------------------------------------------------;
;		        SET_DOS_DATE				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for err..RTC inoperational		;
;	Register destroyed : NONE				;
;  NOTE : Update the BIOS global data area based on # of days	;
;	  passed in suspend					;
;---------------------------------------------------------------;

set_dos_date	proc	near

	pushad					;
	call	get_rtc_date			; Read RTC Date
						; returns (ch) = century, (cl) = year
						; (dh) = month, (dl) = date
	call	date_to_binary			; (eax) = century/year/month/day in BINARY
	push	eax				;
	pop	dx				; (dh) = month in BINARY, (dl) = day in BINARY
	pop	cx				; (ch) = century in BINARY, (cl) = year in BINARY
	mov	eax,ds:suspend_date		;
	mov	bx,ax				; (bl) = old DAY in BINARY, (bh) = old MONTH in BINARY
	shr	eax,16				; (al) = old YEAR in BINARY, (ah) = old CENTURY in BINARY
	call	days_in_suspend			; (ax) = # of full days in suspend

	push	ds				; save on entry (ds)
	push	bios_data_seg			; BIOS standard data segment
	pop	ds				;
	mov	timer_count_rolled,al		;
	pop	ds				; restore on entry (ds)

	clc					; set (cy) = 00 for no error
	popad					;
	ret

set_dos_date	endp

;---------------------------------------------------------------;
;		    SECONDS_TO_TIMER_TICKS			;
;---------------------------------------------------------------;
;	Input : (EAX) seconds in BINARY				;
;	Output: (EAX) timer ticks				;
;	Register destroyed : (EAX),(EBX),(EDX)			;
;  NOTE : Input frequency is 1.19318 MHz & the divisor is 65536	;
;	  which means 18.20648 interrupts every second.		;
;	  We will compute total ticks as :			;
;	       <01> 18*total seconds +				;
;	       <02> .20648*65536*total seconds &		;
;		     ignore the lower word			;
;---------------------------------------------------------------;

seconds_to_timer_ticks	proc	near

	mov	ebx,eax				; (eax) = (ebx) = total seconds
	mov	edx,18				;
	mul	edx				; (eax) = total seconds * 18
	xchg	eax,ebx				; (eax) = total seconds
						; (ebx) = total seconds * 18
	mov	edx,13532			; 0.20648*65536
	mul	edx				; (eax) = 0.20648*65536*total seconds
	shr	eax,16				; (eax) = 0.20648*65536*total seconds/65536
	add	eax,ebx				; (eax) = total timer ticks
	ret

seconds_to_timer_ticks	endp

;---------------------------------------------------------------;
;		       DAYS_IN_SUSPEND				;
;---------------------------------------------------------------;
;	Input : (CH) current century in BINARY			;
;		(CL) current year in BINARY			;
;		(DH) current month in BINARY			;
;		(DL) current day in BINARY			;
;		(AH) old century in BINARY			;
;		(AL) old year in BINARY				;
;		(BH) old month in BINARY			;
;		(BL) old day in BINARY				;
;	Output: (AX) # of days in suspend			;
;	Register destroyed : (AX),(BX),(CX),(DX),(SI),(DI)	;
;  NOTE : <01> Assumption of maximum 99 years in suspend.	;
;	  <02> Century updation support from 20th century	;
;	       to 29th century					;
;	  <03> Maximum 255 days updation			;
;---------------------------------------------------------------;

days_in_suspend	proc	near

	cmp	cl,al				; current year = old year ?
	jz	short days_in_suspend_10	; yes...
	ja	short days_in_suspend_30	; current year > old year
	cmp	ch,ah				; current century = old century ?
	jnz	short days_in_suspend_01	; no...century already updated
	inc	ch				; increment century 
	push	ax				;
	mov	al,ch				; (al) = century in BINARY
	call	binary_to_bcd			; (al) = century in BCD
	mov	ah,al				; (ah) = century in BCD
	mov	al,cmos_century or 10000000b	; NMI off
	call	smi_cmos_data_out		; write to CMOS
	pop	ax				;

;-----------------------------------------------;

days_in_suspend_01:
	cmp	cl,00h				; current year 00 ?
	jz	short days_in_suspend_40	; yes...
days_in_suspend_31:
	mov	ax,255				; maximum 255 days updation possible
						; because of byte
	ret

;-----------------------------------------------;

days_in_suspend_10:
	cmp	dh,bh				; current month = old month ?
	jz	short days_in_suspend_11	; yes...
	mov	di,(offset cgroup:month_table - offset cgroup:smi_code_begin + orgbase)
	test	al,00000011b			; old year leap year ?
	jnz	short days_in_suspend_12	; no...
	mov	di,(offset cgroup:month_table_leap_year - offset cgroup:smi_code_begin + orgbase)
days_in_suspend_12:
	mov	ah,bl				; (ah) = old day
	mov	bl,bh				; (bl) = old month
	xor	bh,bh				; (bx) = old month
	mov	al,cgroup:[di+bx-1]		; (al) = # of days in old month
	sub	al,ah				; (al) = # of days in suspend in old month
	xor	ah,ah				; (ax) = # of days in suspend calculated so far
	sub	dh,bl				; (dh) = current month - old month
	dec	dh				; (dh) = # of full months in suspend
	jz	short days_in_suspend_13	; no full month in suspend 
days_in_suspend_14:
	movzx	cx,byte ptr cgroup:[di+bx]	; (cx) = # of days for this month
	add	ax,cx				; (ax) = # of days in suspend calculated so far
	inc	bx				;
	dec	dh				;
	jnz	short days_in_suspend_14	;
days_in_suspend_13:
	add	ax,dx				; (ax) = total days in suspend
days_in_suspend_16:
	cmp	ax,255				; more than 255 days ?
	jbe	short days_in_suspend_15	; no...
	mov	ax,255				; maximum 255 days supported
days_in_suspend_15:
	ret

days_in_suspend_11:
	sub	dl,bl				; current day - old day
	movzx	ax,dl				; (ax) = # of days in suspend
	ret

;-----------------------------------------------;

days_in_suspend_30:
	mov	ch,cl				; (ch) = (cl) = current year
	sub	ch,al				; current year - old year
	cmp	ch,1				; suspend time more than a year ?
	ja	short days_in_suspend_31	; yes...

;-----------------------------------------------;

days_in_suspend_40:
	mov	di,(offset cgroup:month_table - offset cgroup:smi_code_begin + orgbase)
	test	al,00000011b			; old year leap year ?
	jnz	short days_in_suspend_41	; no...
	mov	di,(offset cgroup:month_table_leap_year - offset cgroup:smi_code_begin + orgbase)
days_in_suspend_41:
	mov	ah,bl				; (ah) = old day
	mov	bl,bh				; (bl) = old month
	xor	bh,bh				; (bx) = old monmth
	mov	al,cgroup:[di+bx-1]		; (al) = # of days in old month
	sub	al,ah				; (al) = # of days in suspend in old month
	xor	ah,ah				; (ax) = # of days in suspend calculated so far
	push	dx				;
	mov	dh,12				; 12 months in a year
	sub	dh,bl				; (dh) = # of full months in old year in suspend
	jz	short days_in_suspend_42	; no full month in old year in suspend
days_in_suspend_43:
	movzx	si,byte ptr cgroup:[di+bx]	; (si) = # of days for this month
	add	ax,si				;
	inc	bx				;
	dec	dh				;
	jnz	short days_in_suspend_43	;
days_in_suspend_42:
	pop	dx				;

	mov	di,(offset cgroup:month_table - offset cgroup:smi_code_begin + orgbase)
	test	cl,00000011b			; current year leap year ?
	jnz	short days_in_suspend_44	; no...
	mov	di,(offset cgroup:month_table_leap_year - offset cgroup:smi_code_begin + orgbase)
days_in_suspend_44:
	dec	dh				; (dh) = # of full months in current year in suspend
	jz	short days_in_suspend_45	; no full month in current year in suspend
	xor	bx,bx				; start with month 1
days_in_suspend_46:
	movzx	si,byte ptr cgroup:[di+bx]	; (si) = # of days for this month
	add	ax,si				;
	inc	bx				;
	dec	dh				;
	jnz	short days_in_suspend_46	;
days_in_suspend_45:
	add	ax,dx				; (ax) = total days in suspend
	jmp	short days_in_suspend_16	;

days_in_suspend	endp

;---------------------------------------------------------------;
;			MONTH_TABLE				;
;---------------------------------------------------------------;

month_table	label	byte

	db	31				; JANUARY
	db	28				; FEBRUARY
	db	31				; MARCH
	db	30				; APRIL
	db	31				; MAY
	db	30				; JUNE
	db	31				; JULY
	db	31				; AUGUST
	db	30				; SEPTEMBER
	db	31				; OCTOBER
	db	30				; NOVEMBER
	db	31				; DECEMBER

;---------------------------------------------------------------;
;		      MONTH_TABLE_LEAP_YEAR			;
;---------------------------------------------------------------;

month_table_leap_year	label	byte

	db	31				; JANUARY
	db	29				; FEBRUARY
	db	31				; MARCH
	db	30				; APRIL
	db	31				; MAY
	db	30				; JUNE
	db	31				; JULY
	db	31				; AUGUST
	db	30				; SEPTEMBER
	db	31				; OCTOBER
	db	30				; NOVEMBER
	db	31				; DECEMBER

;---------------------------------------------------------------;

dos_date_time_restore_ends	label	byte

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
;		CODE TO HANDLE KEYBOARD CONTROLLER		;
;		CODE TO HANDLE KEYBOARD CONTROLLER		;
;		CODE TO HANDLE KEYBOARD CONTROLLER		;
;		CODE TO HANDLE KEYBOARD CONTROLLER		;
;---------------------------------------------------------------;

IF	KB_CNTLR_HANDLING_SUPPORT

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
;			SAVE_LOCK_KB_CNTLR			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (CY) 01 error input buf full/output buf empty	;
;		(CY) 00 no error				;
;	Register destroyed : (AX),(CX),(SI)			;
; NOTE : Call this routine before issuing any command to the	;
;	 keyboard controller which has at least one  response 	;
;	 byte from keyboard controller. If you call this routine,
;	 you must call 'RES_KB_CNTLR' routine after you are done;
;	 with keyboard controller usage.			;
;---------------------------------------------------------------;

save_lock_kb_cntlr	proc	near

	mov	si,kb_cntlr_data		; (si) = keyboard controller data save area

;---------------------------------------------------------------;
;		    SAVE_LOCK_KB_CNTLR_EXT			;
;---------------------------------------------------------------;
;	Input : (SI) keyboard controller data save area		;
;	Output: (CY) 01 error input buf full/output buf empty	;
;		(CY) 00 no error				;
;	Register destroyed : (AX),(CX)				;
;---------------------------------------------------------------;

save_lock_kb_cntlr_ext	proc	near

	mov	al,wrt_kb_cntlr_cmd_byte_cmd	; write command byte (60H)
	call	write_kb_cntlr_cmd		; should lock the keyboard controller
	jnz	short lock_kb_cntlr_01		; no...input buffer full
	in	al,kb_stat_port			; (al) = read keyboard controller status
	mov	ah,al				;
	test	al,kb_output_buf_full		; keyboard controller output buffer full ?
	jz	short lock_kb_cntlr_02		; no...
	in	al,kb_data_port			; (al) = read the data
lock_kb_cntlr_02:
	mov	[si+kb_cntlr_output_buf_data],ax; save keyboard controller output buffer data and status byte

	mov	al,read_kb_cntlr_cmd_byte_cmd	; read command byte (20H)
	call	read_kb_cntlr_data		; (al) = keyboard controller command byte
	jc	short lock_kb_cntlr_01		; error...input buffer full/output buffer empty
	mov	[si+kb_cntlr_cmd_byte],al	; save keyboard controller command byte

	mov	ah,al				; (ah) = (al) = command byte
	or	ah,disable_keyboard_bit or disable_aux_dev_bit; disable keyboard & auxiliary device data xfer

res_kb_cntlr_05::
	mov	al,wrt_kb_cntlr_cmd_byte_cmd	; write command byte (60H)
	call	write_kb_cntlr_data		; program the command byte
	jz	short lock_kb_cntlr_03		; no error...(cy) = 00

res_kb_cntlr_01::
lock_kb_cntlr_01:
	stc					; (cy) = 01 for error
lock_kb_cntlr_03:
	ret

save_lock_kb_cntlr_ext	endp
save_lock_kb_cntlr	endp

;---------------------------------------------------------------;
;			   RES_KB_CNTLR				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (CY) 01 error input buf full/output buf empty	;
;		(CY) 00 no error				;
;	Register destroyed : (AX),(CX),(SI)			;
; NOTE : Call this routine after you are done with keyboard	;
;	 controller usage. You should not call this routine	;
;	 unless you have called 'SAVE_LOCK_KB_CNTLR' routine	;
;	 before.						; 
;---------------------------------------------------------------;

res_kb_cntlr	proc	near

	mov	si,kb_cntlr_data		; (si) = keyboard controller data save area

;---------------------------------------------------------------;
;			RES_KB_CNTLR_EXT			;
;---------------------------------------------------------------;
;	Input : (SI) keyboard controller data save area		;
;	Output: (CY) 01 error input buf full/output buf empty	;
;		(CY) 00 no error				;
;	Register destroyed : (AX),(CX)				;
;---------------------------------------------------------------;

res_kb_cntlr_ext	proc	near

	mov	ax,[si+kb_cntlr_output_buf_data]; (al) = output buffer data, (ah) = keyboard controller status byte
	xchg	al,ah				; (al) = keyboard controller status byte, (ah) = output buffer data
	test	al,kb_output_buf_full		; output buffer full ?
	jz	short res_kb_cntlr_04		; no...
	test	al,kb_aux_output_buf_full	; auxiliary output buffer full ?
	mov	al,wrt_kb_output_buf_cmd	; write to output buffer as if initiated by keyboard
	jz	short res_kb_cntlr_02		; no...
	mov	al,wrt_kb_aux_output_buf_cmd	; write to output buffer as if initiated by auxiliary device
res_kb_cntlr_02:
	call	write_kb_cntlr_data		;
	jnz	short res_kb_cntlr_01		; error...input buffer full
res_kb_cntlr_04:
	mov	ah,[si+kb_cntlr_cmd_byte]	; (ah) = keyboard controller command byte
	jmp	short res_kb_cntlr_05		;
	
res_kb_cntlr_ext	endp
res_kb_cntlr	endp

;---------------------------------------------------------------;
;			READ_KB_CNTLR_DATA			;
;---------------------------------------------------------------;
;	Input : (AL) kb cntlr command				;
;	Output: (CY) 01 error input buf full/output buf empty	;
;		(CY) 00 no error &				;
;			(AL) data received from kb cntlr	;
;	Register destroyed : (AL),(CX)				;
; NOTE : This routines sends the command in (AL) to keyboard	;
;	 controller, then it receives the response byte for the ;
;	 command from the keyboard cntlr. The response byte is	;
;	 returned in (AL).					;
;---------------------------------------------------------------;

read_kb_cntlr_data	proc	near

	call	write_kb_cntlr_cmd		;
	jnz	short read_kb_cntlr_data_01	; error...input buffer full
	call	read_8042_data			; (al) = data received from keyboard controller
	jnz	short read_kb_cntlr_data_02	; no error...(cy) = 00
read_kb_cntlr_data_01:
	stc					; (cy) = 01 for error
read_kb_cntlr_data_02:
	ret

read_kb_cntlr_data	endp

;---------------------------------------------------------------;
;			WRITE_KB_CNTLR_CMD			;
;---------------------------------------------------------------;
;	Input : (AL) comand to keyboard cntlr			;
;	Output: (NZF) error...input buffer full			;
;		(ZF) no error...input buffer empty		;
;		(CY) 00 always for error/no error		;
;	Register destroyed : (CX)				;
; NOTE : This routine sends the command byte in (AL) to the	;
;	 keyboard controller.					;
;---------------------------------------------------------------;

write_kb_cntlr_cmd	proc	near

	call	empty_kb_cntlr_ibuf		; input buffer empty ?
	jnz	short write_kb_cntlr_cmd_01	; no...full
	out	kb_cmd_port,al			; output the command
	call	empty_kb_cntlr_ibuf		; wait for input buffer empty
write_kb_cntlr_cmd_01:
	ret

write_kb_cntlr_cmd	endp

;---------------------------------------------------------------;
;		  GET_AMI_MEGAKEY2_HK_SCAN_CODE			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (CY) 01 error input buf full/output buf empty/	;
;			      no hotkey code found.		;
;		(CY) 00 no error &				;
;			(AL) has hot key scan code.		;
;	Register destroyed : (AX),(CX)				;
; NOTE : Use this routine if you are using AMI MEGAKEY II &	;
;	 external SMI is generated due to keyboard hotkey & you	;
;	 want to know which hotkey has been used.		;
;	 This routine assumes that 'SAVE_LOCK_KB_CNTLR' routine	;
;	 has been called before and 'RES_KB_CNTLR' routine will	;
;	 be called afterwards.					;
;---------------------------------------------------------------;

get_ami_megakey2_hk_scan_code	proc	near

	mov	ah,18h				; read ram location 18h
	call	read_ami_megakey2_ram_loc	; (al) = content of the ram location
	jc	short megakey2_hk_code_01	; error...input buffer full/output buffer empty

	test	al,00000010b			; is the hot key present ?
	mov	ah,50h				; corressponding ram location for hot key scan code
	jnz	short megakey2_hk_code_02	; yes...

	mov	ah,19h				; read ram location 19h
	call	read_ami_megakey2_ram_loc	; (al) = content of the ram location
	jc	short megakey2_hk_code_01	; error...input buffer full/output buffer empty

	mov	cx,5				; check for 5 hot keys
	mov	ah,54h				; start ram location for corressponding hot key scan code
megakey2_hk_code_03:
	shr	al,1				; is the hot key present ?
	jc	short megakey2_hk_code_02	; yes...
	add	ah,2				; next ram location for corressponding hot key scan code
	loop	megakey2_hk_code_03		;
megakey2_hk_code_01:
	stc					; (cy) = 00 for error
	ret

megakey2_hk_code_02:
	call	read_ami_megakey2_ram_loc	; (al) = hot key scan code
	ret

get_ami_megakey2_hk_scan_code	endp

;---------------------------------------------------------------;
;		    READ_AMI_MEGAKEY2_RAM_LOC			;
;---------------------------------------------------------------;
;	Input : (AH) RAM location to read			;
;	Output: (CY) 01 error...input buf full/output buf empty	;
;		(CY) 00 no error &				;
;			(AL) content of the RAM location	;
;	Register destroyed : (AL),(CX)				;
;---------------------------------------------------------------;

read_ami_megakey2_ram_loc	proc	near

	mov	al,ami_megakey2_rd_ram_cmd 	; (al) = AMI MEGAKEY II read ram command
	call	write_kb_cntlr_data		;
	jnz	short megakey2_ram_loc_01	; error...input buffer full
	call	read_8042_data			; (al) has corresponding ram content
	jnz	short megakey2_ram_loc_02	; no error...(cy) = 00
megakey2_ram_loc_01:
	stc					; (cy) = 01 for error
megakey2_ram_loc_02:
	ret

read_ami_megakey2_ram_loc	endp
	
;---------------------------------------------------------------;
;		    WRITE_AMI_MEGAKEY2_RAM_LOC			;
;---------------------------------------------------------------;
;	Input : (AH) RAM location to write			;
;		(AL) data to write to the RAM location		;
;	Output: (CY) 01 error...input buf full			;
;		(CY) 00 no error				;
;	Register destroyed : (CX)				;
;---------------------------------------------------------------;

write_ami_megakey2_ram_loc	proc	near

	push	ax				;
	mov	al,ami_megakey2_wt_ram_cmd 	; (al) = AMI MEGAKEY II write ram command
	call	write_kb_cntlr_data		;
	pop	ax				; (al) has data to write to corressponding RAM location
	jnz	short wt_megakey2_ram_loc_01	; error...input buffer full
	call	write_8042_data			;
	jz	short wt_megakey2_ram_loc_02	; no error...(cy) = 00
wt_megakey2_ram_loc_01:
	stc					; (cy) = 01 for error
wt_megakey2_ram_loc_02:
	ret

write_ami_megakey2_ram_loc	endp
	
;---------------------------------------------------------------;
;			EMPTY_KB_CNTLR_IBUF			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (NZF) error...input buffer full			;
;		(ZF) no error...input buffer empty		;
;		(CY) 00 always for error/no error		;
;	Register destroyed : (CX)				;
; NOTE : Wait for input buffer empty				;
;---------------------------------------------------------------;

empty_kb_cntlr_ibuf	proc	near

	push	ax				;
	mov	cx,16				;
empty_kb_cntlr_ibuf_01:
	push	cx				;
	xor	cx,cx				;
empty_kb_cntlr_ibuf_02:
	in	al,kb_stat_port			; (al) = read keyboard controller status
	test	al,kb_input_buf_full		; input buffer full ?
	loopnz	empty_kb_cntlr_ibuf_02		; yes...
	pop	cx				;
	loopnz	empty_kb_cntlr_ibuf_01		;
	pop	ax				;
	ret

empty_kb_cntlr_ibuf	endp

;---------------------------------------------------------------;
;			FULL_KB_CNTLR_OBUF			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (NZF) no error...output buffer full		;
;		(ZF) error...output buffer empty		;
;		(CY) 00 always for error/no error		;
;	Register destroyed : (CX)				;
; NOTE : Wait for output buffer full				;
;---------------------------------------------------------------;

full_kb_cntlr_obuf	proc	near

	push	ax				;
	mov	cx,16				;
full_kb_cntlr_obuf_01:
	push	cx				;
	xor	cx,cx				;
full_kb_cntlr_obuf_02:
	in	al,kb_stat_port			; (al) = read keyboard controller status
	test	al,kb_output_buf_full		; output buffer full ?
	loopz	full_kb_cntlr_obuf_02		; no...
	pop	cx				;
	loopz	full_kb_cntlr_obuf_01		;
	pop	ax				;
	ret

full_kb_cntlr_obuf	endp

;---------------------------------------------------------------;
;			WRITE_KB_CNTLR_DATA			;
;---------------------------------------------------------------;
;	Input : (AL) kb cntlr command				;
;		(AH) data for the command			;
;	Output: (NZF) error...input buffer full			;
;		(ZF) no error					;
;		(CY) 00 always for error/no error		;
;	Register destroyed : (AL),(CX)				;
; NOTE : This routines sends the command in (AL) to keyboard	;
;	 controller, then it sends the data byte in (AH) for the;
;	 command to the keyboard controller.			;
;---------------------------------------------------------------;

write_kb_cntlr_data	proc	near

	call	write_kb_cntlr_cmd		;
	jnz	short write_kb_cntlr_data_01	; error...input buffer full
	mov	al,ah				; (al) = data to be sent to keyboard controller
	call	write_8042_data			; send data to keyboard controller
write_kb_cntlr_data_01:
	ret

write_kb_cntlr_data	endp

;---------------------------------------------------------------;
;			  WRITE_8042_DATA			;
;			WRITE_KB_MOUSE_DATA			;
;---------------------------------------------------------------;
;	Input : (AL) keyboard controller/mouse/keyboard data	;
;	Output: (NZF) error...input buffer full			;
;		(ZF) no error...input buffer empty		;
;		(CY) 00 always for error/no error		;
;	Register destroyed : (CX)				;
; NOTE : This routine sends the data byte in (AL) to the	;
;	 keyboard controller/mouse/keyboard.			;
;---------------------------------------------------------------;

write_8042_data	proc	near
write_kb_mouse_data	proc	near

	call	empty_kb_cntlr_ibuf		; input buffer empty ?
	jnz	short write_kb_mouse_data_01	; no...full
	out	kb_data_port,al			; output the data to keyboard/mouse
	call	empty_kb_cntlr_ibuf		; wait for input buffer empty
write_kb_mouse_data_01:
	ret

write_kb_mouse_data	endp
write_8042_data	endp

;---------------------------------------------------------------;
;			   READ_KB_DATA				;
;			  READ_8042_DATA			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: (NZF) no error &				;
;			(AL) data read from keyboard controller/;
;			     keyboard				;
;		(ZF) error...output buffer empty		;
;		(CY) 00 always for error/no error		;
;	Register destroyed : (AL),(CX)				;
; NOTE : This routine receives the data byte in (AL) from the	;
;	 keyboard controller/keyboard.				;
;---------------------------------------------------------------;

read_kb_data	proc	near
read_8042_data	proc	near

	call	full_kb_cntlr_obuf		; keyboard controller output buffer full ?
	jz	short read_kb_data_01		; no...
	in	al,kb_data_port			; (al) = read keyboard data
read_kb_data_01:
	ret

read_8042_data	endp
read_kb_data	endp

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
;		    CODE TO HANDLE RTC ALARM			;
;		    CODE TO HANDLE RTC ALARM			;
;		    CODE TO HANDLE RTC ALARM			;
;		    CODE TO HANDLE RTC ALARM			;
;---------------------------------------------------------------;
; All the code from here labelled as 'RTC_ALARM_SUPPORT' to	;
; the label 'RTC_ALARM_SUPPORT_ENDS' should be made active if	;
; you need to use RTC ALARM resume.				;
; Following routine needs to be called...			;
;		SET_RTC_ALARM_DURING_SUSPEND			;
;		RESTORE_RTC_DURING_RESUME			;
;---------------------------------------------------------------;

IF	RTC_ALARM_HANDLING_SUPPORT

rtc_alarm_support	label	byte

;---------------------------------------------------------------;
;		   SET_RTC_ALARM_DURING_SUSPEND			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(DL) bit 0 set...use USER ALARM as resume ALARM	;
;		     bit 1 set...use specified ALARM time in	;
;				 (CH),(CL),(DH) as resume ALARM	;
;		     bit 6-2...reserved				;
;		     bit 7 set...valid only when bit 0 also set,;
;				 but no USER ALARM is set...will;
;				 do SAVE RTC and clear periodic	;
;				 interrupt enable bit.		;
;		(CH) alarm hour	in BCD				;
;		(CL) alarm minutes in BCD			;
;		(DH) alarm seconds in BCD...set to 00		;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error and any of the following...	;
;			....CMOS inoperational			;
;			....No USER ALARM set for (DL) bit 0 set;
;			    but RTC will be saved and periodic	;
;			    interrupt will be disabled if (DL)	;
;			    bit 7 is set at input.		;
;	Register destroyed : (AX),(CX),(DX)			;
; NOTE :							;
;  *  No error checking done for unspecified bit(s) of (DL) set	;
;  *  No error checking done for multiple bits of (DL) set	;
;  *  If no bit of (DL) is set, no ALARM usage for RESUME	;
;  *  If bit 0 of (DL) is set but no USER ALARM is set, then	;
;     if bit 7 of (DL) is set, RTC is saved and periodic 	;
;     interrupt is disabled.					;
;  *  If you call this routine during standby/sleep/suspend,	;
;     the 'RESTORE_RTC_DURING_RESUME' must be called during	;
;     resume.							;
;---------------------------------------------------------------;

set_rtc_alarm_during_suspend	proc	near

	mov	byte ptr ds:gpm_alarm_flag,00000000b; clear the FLAG
	test	dl,00000001b			; use USER ALARM as resume alarm ?
	jz	short set_rtc_alarm_suspend_10	; no...
	push	dx				; save on entry (DL)
	call	read_rtc_alarm			; get user alarm time if enabled in (CH),(CL),(DH)
	pop	ax				; (AL) has on entry (DL)
	jc	short set_rtc_alarm_suspend_02	; error...CMOS inoperational
	jnz	short set_rtc_alarm_suspend_14	; USER ALARM enabled...program USER ALARM as resume alarm
	test	al,10000000b			; save RTC & disable periodic interrupt ?
	jz	short set_rtc_alarm_suspend_03	; no...
	or	byte ptr ds:gpm_alarm_flag,restore_rtc_on_resume
	call	save_rtc			; save RTC
set_rtc_alarm_suspend_03:
	stc					; (cy) = 01 for error
set_rtc_alarm_suspend_02:
	ret

;-----------------------------------------------;

set_rtc_alarm_suspend_10:
	test	dl,00000010b			; any time specified as resume alarm ?
	jz	short set_rtc_alarm_suspend_02	; no...EXIT...(cy) = 00
	push	cx				;
	push	dx				;
	call	read_rtc_alarm			; get user alarm time if enabled in (CH),(CL),(DH)
	jc	short set_rtc_alarm_suspend_11	; error...CMOS inoperational
	jz	short set_rtc_alarm_suspend_12	; USER ALARM disabled...
	or	byte ptr ds:gpm_alarm_flag,restore_user_alarm_on_resume
	mov	ds:user_alarm_save_area,cx	; save USER ALARM HOUR & MINUTE
	mov	byte ptr ds:user_alarm_save_area+2,dh; save USER ALARM SECOND
set_rtc_alarm_suspend_12:
	pop	dx				;
	pop	cx				;
set_rtc_alarm_suspend_14:
	cli					; disable interrupts
	or	byte ptr ds:gpm_alarm_flag,restore_rtc_on_resume
	call	save_rtc			; save RTC
	call	reset_rtc_alarm			; clear previous USER ALARM
	call	set_rtc_alarm			; set new ALARM for resume

	push	ax
	mov	ax,word ptr ds:apm_12_resume_day_bcd; get day & month

	push	ax		;save month (ah)

	mov	ah,al
	mov	al,0feh	  	;CMOS 7eh day of the day alarm
	call	smi_cmos_data_in
	and	al,0c0h
	or	ah,al
	mov	al,0feh
	call	smi_cmos_data_out

	pop	ax	   	;restor month (ah)
	
	mov	al,0ffh	  	;CMOS 7fh day of the Month alarm
	call	smi_cmos_data_in
     	and	al,0c0h
	or	ah,al
	
	mov	al,0ffh
	call	smi_cmos_data_out

	pop	ax

	clc					; (cy) = 00 for no error
	ret

set_rtc_alarm_suspend_11:
	pop	dx				;
	pop	cx				;
	ret

set_rtc_alarm_during_suspend	endp

;---------------------------------------------------------------;
;		    RESTORE_RTC_DURING_RESUME			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (ZF) (ZR) RTC alarm interrupt was not active at	;
;			  the time of calling this routine	;
;		(ZF) (NZ) RTC alarm interrupt was active at the	;
;			  time of calling this routine		;
;	Register destroyed : (AX),(CX),(DX)			;
;---------------------------------------------------------------;

restore_rtc_during_resume	proc	near

	cli					; disable interrupts

	call	is_it_alarm_resume		; is RTC alarm interrupt active ?
	pushf					; (zf) = (nz)/(zr) for RTC alarm interrupt active/not active

	test	byte ptr ds:gpm_alarm_flag,restore_user_alarm_on_resume; restore USER ALARM on resume ?
	jz	short restore_rtc_resume_01	; no...
	mov	cx,ds:user_alarm_save_area	; (CH) = USER ALARM HOUR, (CL) USER ALARM MINUTE
	mov	dh, byte ptr ds:user_alarm_save_area+2; (DH) = USER ALARM SECOND
	call	set_rtc_alarm			; set USER ALARM
restore_rtc_resume_01:
	test	byte ptr ds:gpm_alarm_flag,restore_rtc_on_resume; restore RTC on resume ?
	jz	short restore_rtc_resume_02	; no...
	call	restore_rtc			; restore RTC
restore_rtc_resume_02:
	popf					; (zf) = (nz)/(zr) for RTC alarm interrupt active/not active
	ret

restore_rtc_during_resume	endp

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
;			  SET_RTC_ALARM				;
;---------------------------------------------------------------;
;	Input : (CH) alarm hour	in BCD				;
;		(CL) alarm minutes in BCD			;
;		(DH) alarm seconds in BCD			;
;	Output:	(CY) 00 no error				;
;		(CY) 01 error...CMOS inoperational		;
;	Register destroyed : (AX),(CX),(DX)			;
;---------------------------------------------------------------;

set_rtc_alarm	proc	near

	call	cmos_stat_reg_c_read		; read status reg 0Ch to clear any previous alarm

	call	wait_for_update_complete	; update complete ?
	jnz	short set_rtc_alarm_01		; no...

	mov	ax,(cmos_alarm_hour or 10000000b)*256+(cmos_alarm_minute or 10000000b); NMI off
	mov	dl,cmos_alarm_second or 10000000b; NMI off

	xchg	ah,cl				; (al) = index, (ah) = data
	call	smi_cmos_data_out_x		; write the first set of data
	xchg	ax,cx				; (al) = index, (ah) = data
	call	smi_cmos_data_out_x		; write second set of data
	xchg	ax,dx				; (al) = index, (ah) = data
	call	smi_cmos_data_out_x		; write third set of data

	in	al,mask_8259_slave		; 8259 slave mask port
	smi_io_delay				; i/o delay
	and	al,not rtc_intr_bit		; unmask RTC interrupt
	out	mask_8259_slave,al		;
	smi_io_delay				; i/o delay
	in	al,mask_8259_master		; 8259 master mask port
	smi_io_delay				; i/o delay
	and	al,11111011b			; unmask master to slave
	out	mask_8259_master,al		;

	call	cmos_stat_reg_b_read		; (al) = read status reg 0Bh data
	and	al,not set_bit			; clear set bit
	or	al,alarm_intr_bit		; enable alarm interrupt
	jmp	short set_rtc_alarm_10		;

set_rtc_alarm_01:
	stc					; set (cy) = 01 for error
	ret

set_rtc_alarm	endp

;---------------------------------------------------------------;
;			RESET_RTC_ALARM				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output:	(CY) 00 no error				;
;		(CY) 01 error...CMOS inoperational		;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

reset_rtc_alarm	proc	near

	call	cmos_stat_reg_c_read		; read status reg 0Ch to clear any previous alarm

	call	cmos_stat_reg_b_read		; (al) = read status reg 0Bh data
	and	al, not (set_bit or alarm_intr_bit or square_wave_enable_bit)

;-----------------------------------------------;

save_rtc_10::
set_rtc_alarm_10::
	mov	ah,al				;

;-----------------------------------------------;

restore_rtc_10::
	mov	al,cmos_stat_reg_b or 10000000b	; NMI off
	call	smi_cmos_data_out		;
	clc					; (cy) = 00 for no error
	ret

reset_rtc_alarm	endp

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
;		ROUTINES FOR SAVING/RESTORING RTC		;
;---------------------------------------------------------------;
;			      SAVE_RTC				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

save_rtc	proc	near

	call	cmos_stat_reg_b_read		; (al) = current programmed value for CMOS status reg B
	mov	ds:rtc_stat_reg_b_save_area,al	; save CMOS status reg B
	and	al, not (periodic_intr_bit or update_ended_intr_bit)
						; clear periodic interrupt
						; clear update ended interrupt
	jmp	short save_rtc_10		;

save_rtc	endp

;---------------------------------------------------------------;
;			    RESTORE_RTC				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

restore_rtc	proc	near

	call	cmos_stat_reg_c_read		; read to clear any pending interrupt
	mov	ah,ds:rtc_stat_reg_b_save_area	; (ah) = CMOS status reg B data
	jmp	short restore_rtc_10		;

restore_rtc	endp

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
;	      APM 1.2 ALARM RESUME SUPPORT ROUTINES		;
;---------------------------------------------------------------;
;			SET_APM_RESUME_TIMER			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (CF) (NC) APM resume timer is set for alarm	;
;		(CF) (CY) CMOS inoperational or			;
;			  APM resume timer is disabled		;
;	Register destroyed : (AX),(CX),(DX)			;
; Note :							;
;  * Use this routine to set the APM resume timer.		;
;  * This routine does not set APM resume DATE as standard RTC	;
;    does not support DATE ALARM. So alarm DATE programming needs
;    to be done at OEM/CHIPSET programming level based on the	;
;    support of the hardware. If no support is available for	;
;    DATE alarm support, use 'check_apm_resume_date' routine	;
;    during alarm resume to check whether appropriate APM alarm	;
;    date is reached or not. If appropriate APM alarm DATE is not
;    reached, go back to previous standby/suspend state.	;
;  * If you use this routine to set APM resume timer (alarm	;
;    resume), use 'RESTORE_RTC_DURING_RESUME' routine later	;
;    during final resume process.				;
;---------------------------------------------------------------;

set_apm_resume_timer	proc	near

	test	byte ptr ds:apm_misc_info,resume_timer_enabled_by_apm; APM resume timer enabled ?
	stc					; (CF) = (CY) for resume timer disabled
	jz	short set_apm_resume_timer_00	; no...disabled

	mov	cx,ds:apm_12_resume_min_bcd	; (CL) = APM resume minute in BCD, (CH) = APM resume hour in BCD
	mov	dh,ds:apm_12_resume_sec_bcd	; (DH) = APM resume second in BCD
	mov	dl,00000010b			; set alarm as specified in (CH),(CL),(DH)
	call	set_rtc_alarm_during_suspend	; set the alarm...returns (CF)
set_apm_resume_timer_00:
	ret

set_apm_resume_timer	endp

;---------------------------------------------------------------;
;			IS_IT_ALARM_RESUME			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (ZF) (NZ) RTC alarm active			;
;		(ZF) (ZR) RTC alarm not active			;
;	Register destroyed : (AX),(DX)				;
;---------------------------------------------------------------;

is_it_alarm_resume	proc	near

	mov	dx,control_8259_slave		; 8259 slave control port (0a0h)
	mov	ah,00000001b			; check for RTC alarm interrupt
	call	read_8259_irr_reg		; check for interrupt pending...(ZF) set accordingly
	ret

is_it_alarm_resume	endp

;---------------------------------------------------------------;
;			CHECK_APM_RESUME_DATE			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: (ZF) (ZR) APM resume date reached		;
;		(ZF) (NZ) APM resume date not reached		;
;	Register destroyed : NONE				;
; Note :							;
;  * If the RTC chip used for your implementation supports DATE	;
;    alarm, you don't need to use this routine.			;
;  * If the RTC chip used for your implementation does not	;
;    support DATE alarm, use this routine while you resume by	;
;    alarm to check whether proper APM resume date is reached or;
;    not. If APM resume date is not reached, go to standby or	;
;    suspend again.						;
;---------------------------------------------------------------;

check_apm_resume_date	proc	near

	pushad					;

	call	get_rtc_date			; (CH) = century in BCD, (CL) = year in BCD
						; (DH) = month in BCD, (DL) = day in BCD
	call	date_to_binary			; (eax) = century/year/month/day in BINARY
	mov	ebx,eax				; (ebx) = current century/year/month/day in BINARY
	mov	dx,ds:apm_12_resume_day_bcd	; (DH) = APM resume month in BCD, (DL) = APM resume day in BCD
	mov	cx,ds:apm_12_resume_year_bcd	; (CH) = APM resume century in BCD, (CL) = APM resume year in BCD
	call	date_to_binary			; (eax) = APM resume century/year/month/day in BINARY
	cmp	eax,ebx				; is current DATE = APM resume DATE ?

	popad					;
	ret

check_apm_resume_date	endp

;---------------------------------------------------------------;

rtc_alarm_support_ends	label	byte

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
