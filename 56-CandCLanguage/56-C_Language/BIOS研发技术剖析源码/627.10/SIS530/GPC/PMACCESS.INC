prepare_for_shutdown:

;; hot key power on
	mov	bh,05h
	call	read_apc_cmos
	and	bl,not 20h
        test    byte ptr ds:[hot_key_enable_status],01
	jz	short @f
	or	bl,20h
@@:
	call	write_apc_cmos
	
;; keyboard password power on
	mov	ah,05h
	call	read_apc_cmos
	and	al,not 40h			; disable keyboard power on
	call	write_apc_cmos

        test    byte ptr ds:[keyboard_password_status],01
	jz	@f				; no
	mov	ah,45h				; open extend cmos
	call	sread_sio_byte
	or	al,08h
	call	swrite_sio_byte
	
	mov	al,7dh				; get how many char.
	out	70h,al
	jmp	short $+2
	in	al,71h
	inc	al				; if length is ffh, it means no password installed
	jz	@f
	
	call	write_password_to_keyboard
	mov	ah,05h
	call	read_apc_cmos
	or	al,40h
	call	write_apc_cmos
@@:
	mov	ah,45h				; close extend cmos
	call	sread_sio_byte
	and	al,not 08h
	call	swrite_sio_byte

;	mov	al,POWER_CTRL_CMOS+80h	; Save Power Control to CMOS
;	call	smi_cmos_data_in_x
;	mov	ah,al
;	mov	al,POWER_STATE_CMOS+80h	; Report Normal Power State to CMOS
;	call	smi_cmos_data_out_x

;	test	byte ptr ds:[rtc_alarm],1
;	jz	skip_rtc_alarm_setting
;; disable powered up by RTC
	mov	ah,03h
	call	read_apc_cmos
	and	al,not 04h			; disable powered up by RTC
	call	write_apc_cmos

	test	byte ptr ds:[rtc_alarm],01h
	jz	skip_rtc_alarm_setting

	mov	ah,03h
	call	read_apc_cmos
	or	al,04h				; enable powered by RTC
	call	write_apc_cmos

	mov	al,ds:[rtc_alarm_date] 
	or	al,al
	jz	skip_alarm_date
	mov	bx,0fe00h
	
	call	smi_set_rtc_cmos
skip_alarm_date:

	mov	al,ds:[rtc_alarm_hour]
	mov	bh,85h
	call	smi_set_rtc_cmos

	mov	al,ds:[rtc_alarm_minute]
	mov	bh,83h
	call	smi_set_rtc_cmos

	mov	al,ds:[rtc_alarm_second]
	mov	bh,81h
	call	smi_set_rtc_cmos

	mov	ax,08b8bh				; Enable Alarm Inturrupt
	call	smi_cmos_data_in
	or	al,00100000b
	xchg	al,ah
	call	smi_cmos_data_out

;; Enable RTC Power On

skip_rtc_alarm_setting:
;; disable powered-up by ring status
	mov	ah,03h
	call	read_apc_cmos
	and	al,not 20h			; disable ring on
	call	write_apc_cmos
	
        cmp     byte ptr ds:[power_on_by_ri],0
	jz	skip_ring_on_setting
;; Enable Ring Power On Here
	mov	ah,03h
	call	read_apc_cmos
	or	al, 20h				; enable ring power on
	push	ax
        cmp    byte ptr ds:[power_on_by_ri],02h	
	pop	ax
	jnz	low_active
	and	al, not 10h			; high active
	jmp	@f
low_active:
	or	al, 10h				; low active
@@:
	call	write_apc_cmos

skip_ring_on_setting:

;; disable PME0# and PME1#
	mov	ah,04h
	call	read_apc_cmos
	and	al, not 18h		; output mode for GPIO#5, GPIO#10
	or	al,22h			; set GPIO#5 and GPIO#10
	call	write_apc_cmos
	
	mov	ah,03h
	call	read_apc_cmos
	and	al, not 08h		; GPIO#5
	call	write_apc_cmos
	
	mov	ah,07h
	call	read_apc_cmos
	and	al, not 80h		; GPIO#10
	call	write_apc_cmos

	ret

soft_off:
        ret


smi_set_rtc_cmos:
	aam
	shl	ah,4
	or	ah,al
	mov	al,bh
	call	smi_cmos_data_in
	and	al,bl
	or	ah,al
	mov	al,bh
	call	smi_cmos_data_out
	ret

;---------------------------------------------------------------;
; read_smi_base
;
; input: AH index reg
; output: AL returned value
; AL is destroyed
;---------------------------------------------------------------;
	public	read_smi_base
read_smi_base	proc	near
	push	dx
	mov	dx,MKF_PM_BASE_ADDRESS
	add	dl,ah
	in	al,dx
	jcxz	short $+2
	jcxz	short $+2
	pop	dx
	ret
read_smi_base	endp

;---------------------------------------------------------------;
; write_smi_base
;
; input: AH index reg, AL data
; output: nothing
; destroyed nothing
;---------------------------------------------------------------;
	public	write_smi_base
write_smi_base	proc	near
	push	dx
	mov	dx,MKF_PM_BASE_ADDRESS
	add	dl,ah
	out	dx,al
	jcxz	short $+2
	jcxz	short $+2
	pop	dx
	ret
write_smi_base	endp

read_apc_cmos:
	pushf
	call	open_apc_cmos
	mov	al,ah
	call	smi_cmos_data_in
	call	close_apc_cmos
	popf
	ret

write_apc_cmos:
	pushf
	call	open_apc_cmos
	xchg	al,ah
	call	smi_cmos_data_out
	call	close_apc_cmos
	popf
	ret

;; Input : DL = Bit for function
;;	   DH = OR Value (Enable/Disable)
;; Output: None
;; Destory: AX

timer_wakeup_subroute:
	mov	ah,67h				; Clear status
	mov	al,dl
	call	swrite_pmu_byte			

	mov	ah,63h				
	call	sread_pmu_byte			
	not	dl
	and	al,dl
	not	dl
	or	al,dh
	call	swrite_pmu_byte			
	ret

enable_timer:
        test	byte ptr ds:[standby_timer_value],0ffh
	mov	dx,4040h
	jnz	short pm_enable_timer
						
        test	byte ptr ds:[suspend_timer_value],0ffh
	jz	short timer_init_done
	mov	dx,8080h
pm_enable_timer:				
	call	timer_wakeup_subroute
timer_init_done:
	ret

;; Input AH = 0/1 -> Timer 0/1
;; Output: None
;; Destory: AX
timer_monitor_irq:
        
	shl	ah,1
        add	ah,068h
        mov     al,byte ptr ds:[smi_21_a1_moni_mask];; Master mask b[7:0] = irq[7:0]
        call    swrite_pmu_byte
	inc	ah
        mov     al,byte ptr ds:[smi_21_a1_moni_mask+1] ;; slave mask b[7:0] = irq[15:8]
        call    swrite_pmu_byte
        
	ret

;; Input AH = 0/1 -> Timer 0/1
;; Output: None
;; Destory: AX
timer_wakeup_irq:
	push	dx
	sub	dx,dx

	push	ax
;;;;;;;;;;;;; Note  >>>
;	test	byte ptr ds:[modem_ring],0ffh
;	jz	not_from_modem_ring
;; Mask Modem IRQ
;	movzx	ax, byte ptr ds:[modem_irq]
;;	bts	dx,ax
;	movzx	di,al
;        btr     word ptr ds:[smi_21_a1_wake_mask],di  
;not_from_modem_ring:
;;; <<<
        mov	ah,62h
        call	sread_sio_byte
        test	al,80h				; USBIRQ enable?
        jnz	no_usb_irq_to_wake_up
        test	al,40h				; USB enable?
        jz	no_usb_irq_to_wake_up
        and	al,0fh
        jmp	$+2
        movzx	di,al
        btr     word ptr ds:[smi_21_a1_wake_mask],di  
no_usb_irq_to_wake_up:
	pop	ax

	shl	ah,1
        add	ah,068h
        mov     al,byte ptr ds:[smi_21_a1_wake_mask];; Master mask b[7:0] = irq[7:0]
	or	al,dl
        call    swrite_pmu_byte
	inc	ah
        mov     al,byte ptr ds:[smi_21_a1_wake_mask+1] ;; slave mask b[7:0] = irq[15:8]
	or	al,dh
        call    swrite_pmu_byte
	pop	dx
	ret

; APM1.2: Resume timer				;
; Program RTC alarm wakeup according to the	;
; parameters passed by APM			;
;-----------------------------------------------;
set_resume_base_timer	proc	near		;
        mov     ch,ds:apm_12_resume_sec_bcd     ; get seconds
        mov     dx,word ptr ds:apm_12_resume_min_bcd; get mins & hours
        mov     si,word ptr ds:apm_12_resume_day_bcd; get day & month
        mov     di,word ptr ds:apm_12_resume_year_bcd; get year & century
        call    check_resume_timer_data         ; valid data ?
        jc      @f                              ; error...invalid request
						;
        mov     dh,ds:apm_12_resume_sec_bcd     ; get seconds
        mov     cx,word ptr ds:apm_12_resume_min_bcd; get mins & hours
;       mov     si,word ptr ds:apm_12_resume_day_bcd; get day & month
;       mov     di,word ptr ds:apm_12_resume_year_bcd; get year & century
        mov     dl,2h                           ; use alarm
        call    set_rtc_alarm_during_suspend	;

        mov     ah,069h
        call    sread_pmu_byte
	and	al,0feh				; Enable IRQ 8
	call	swrite_pmu_byte

@@:						;
	ret					;	
set_resume_base_timer	endp			;
;<<<--------------------------------------------;
; APM1.2: Resume timer				;
; Restore RTC after we programmed		;
;-----------------------------------------------;
restore_resume_timer	proc	near		;
        mov     ch,ds:apm_12_resume_sec_bcd     ; get seconds
        mov     dx,word ptr ds:apm_12_resume_min_bcd; get mins & hours
        mov     si,word ptr ds:apm_12_resume_day_bcd; get day & month
        mov     di,word ptr ds:apm_12_resume_year_bcd; get year & century
        call    check_resume_timer_data         ; valid data ?
        jc      @f                              ; error...invalid request
        call    restore_rtc_during_resume	;
@@:						;
	ret					;
restore_resume_timer	endp			;

open_apc_cmos:
        cli
	push	ax
;	mov	ah,44h			    
;	call	sread_sio_byte		    
;	or	al,10h		    	    
;	call	swrite_sio_byte		    
;
;	call	sread_sio_byte		    
;	test	al,10h		    	    
;	jnz	open_apc_exit		    
;;A1_type_5595:				    
	mov	ah,45h			    
	call	sread_sio_byte		    
	or	al,02h			    
	call	swrite_sio_byte		    
open_apc_exit:
	pop	ax
	ret

close_apc_cmos:
	push	ax
;	mov	ah,44h			    ; enable APC
;	call	sread_sio_byte		    ;
;	test	al,10h		    	    ;
;	jnz	disable_apc_a0		    ;

        mov	ah,45h			    ; enable APC
	call	sread_sio_byte		    ;
	and	al,not 02h			    ;
	call	swrite_sio_byte		    ;
;	jmp	short close_apc_exit
;disable_apc_a0:
;	mov	ah,44h			    ; enable APC
;	call	sread_sio_byte		    ;
;	and	al,not 10h			    ;
;	call	swrite_sio_byte		    ;
;close_apc_exit:
	pop	ax
        ret

check_sb_revision:
;; Output : NZ = 5595B1 or Later
;; 	    ZR = 5595A2	   
	push	ax
	mov	ah,08h
	call	sread_sio_byte
	cmp	al,01h 		; Rev A2?
	pop	ax
	ret

sread_usb_byte:
	push	dx
	mov	dx,0a00h
	jmp	short common_read_byte
sread_pmu_byte:
	push	dx
	mov	dx,0900h
	jmp	short common_read_byte
sread_pci_byte:
        push    dx
        mov     dx,0000h
	jmp	short common_read_byte
sread_sio_byte:
        push    dx
        mov     dx,0800h

common_read_byte:
        push    cx
        push    eax
        mov     cx,ax
        movzx	eax,ah
        and     al,0fch
        or	eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     ch,03h
        add     dl,ch
        in      al,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     cl,al
;        mov     dx,0cf8h
;        and     eax,07fffffffh
;        out     dx,eax
        pop     eax
        mov     al,cl
        pop     cx
        pop     dx
        ret

sread_pmu_dword:
        push    dx
        push    eax
        movzx	eax,ah
        or      eax,80000900h           ; AD16 , DEV 5
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        in      eax,dx
        jcxz    short $+2
        jcxz    short $+2
        mov     ebx,eax
;        mov     dx,0cf8h
;        and     eax,07fffffffh
;        out     dx,eax
        pop     eax
        pop     dx
        ret

swrite_pmu_byte:
	push	dx
	mov	dx,0900h
	jmp	short common_write_byte
swrite_pci_byte:
        push    dx
        mov     dx,0000h
        jmp     short common_write_byte 
swrite_sio_byte:
        push    dx
        mov     dx,0800h
common_write_byte:
        push    cx
        push    eax
        mov     cx,ax
        movzx	eax,ah
        and     al,0fch
        or	eax,80000000h
        or      ax,dx
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        and     ch,03h
        add     dl,ch
        mov     al,cl                           ; Restore AH (data)
        out     dx,al
;        mov     dx,0cf8h
;        and     eax,07fffffffh
;        out     dx,eax
        pop     eax
        pop     cx
        pop     dx
        ret

swrite_pmu_dword:
        push    dx
        push    eax
        movzx	eax,ah
        or      eax,80000900h
        mov     dx,0cf8h
        out     dx,eax
        jcxz    short $+2
        jcxz    short $+2
        mov     dl,0fch
        mov     eax,ebx
        out     dx,eax
;        mov     dx,0cf8h
;        and     eax,07fffffffh
;        out     dx,eax
        pop     eax
        pop     dx
        ret

;        public  read_22_23
;        public  read_isa_reg
;read_isa_reg:
read_22_23:
        mov     al,ah
        out     22h,al
        jmp     $+2
        jmp     $+2
        in      al,23h
        jmp     $+2
        jmp     $+2
        ret

;        public  write_22_23
;        public  write_isa_reg
;write_isa_reg:
write_22_23:
        xchg    ah,al
        out     22h,al
        jmp     $+2
        jmp     $+2
        xchg    ah,al
        out     23h,al
        jmp     $+2
        jmp     $+2
        ret

enable_a20:
        mov     ah,064h        	;; Enable A20M#
        call    sread_sio_byte
        or	al, 00000010b   
        call    swrite_sio_byte
	ret
	
disable_a20:
        mov     ah,064h        ;; Disable A20M#
        call    sread_sio_byte
        and     al,11111101b   
        call    swrite_sio_byte
	ret

write_password_to_keyboard:
	mov	al,0a5h
	out	64h,al
	jmp	short $+2

	mov	ah,45h				; open extend cmos
	call	sread_sio_byte
	or	al,08h
	call	swrite_sio_byte
	
	mov	al,7dh
	out	70h,al
	jmp	short $+2
	in	al,71h
	jmp	short $+2
	xor	ch,ch
	mov	cl,al				; cl = password length
	mov	ah,7ch				; first character
@@:
	xchg	al,ah
	out	70h,al				; get extend cmos data
	jmp	short $+2
	xchg	al,ah
	in	al,71h
	jmp	short $+2
	
	out	60h,al
	jmp	short $+2
	dec	ah				; next character
	loop	@b

	mov	al,0
	out	60h,al
	jmp	short $+2
	
	mov	ah,45h				; close extend cmos
	call	sread_sio_byte
	and	al,not 08h
	call	swrite_sio_byte
	ret

