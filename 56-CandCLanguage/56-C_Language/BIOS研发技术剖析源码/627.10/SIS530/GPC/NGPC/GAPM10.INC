Subttl.	Include file for GREEN PC support APM v1.0 code...GAPM10.INC

;-----------------------------------------------;
;  FOLLOWING ROUTINES USED FROM OTHER MODULES	;
;-----------------------------------------------;

	public	apm_version			;

;;	public	apm_call_near			; use the functional support thru near call
;;	public	apm_post			;

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
;*****************************************************************;
;-----------------------------------------------;
;    THIS MODULE HAS THE CODE FOR SUPPORTING	;
;     APM FUNCTIONS AS DEFINED BY MICROSOFT	;
;	    AND INTEL IN V1.0 SPECS		;
;-----------------------------------------------;
;	  ALL CODES ARE REAL MODE CODE		;
;-----------------------------------------------;
;		INCLUDE  FILES			;
;-----------------------------------------------;

	include	gapm.equ			; equate file
	include	gapm.dat			; data file

;-----------------------------------------------;
;	      APM NEAR STACK  EQUATES		;
;-----------------------------------------------;

	off_al_apm		equ	28	;
	off_ah_apm		equ	29	;
	off_ax_apm		equ	28	;
	off_eax_apm		equ	28	;
	off_bl_apm		equ	16	;
	off_bh_apm		equ	17	;
	off_bx_apm		equ	16	;
	off_ebx_apm		equ	16	;
	off_cl_apm		equ	24	;
	off_ch_apm		equ	25	;
	off_cx_apm		equ	24	;
	off_ecx_apm		equ	24	;
	off_dl_apm		equ	20	;
	off_dh_apm		equ	21	;
	off_dx_apm		equ	20	;
	off_edx_apm		equ	20	;
	off_di_apm		equ	00	;
	off_si_apm		equ	04	;
	off_bp_apm		equ	08	;
	off_flag_apm		equ	32	;

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
;		GREEN PC APM CODE VERSION NO.			;
;---------------------------------------------------------------;

apm_version	label	byte

	db	'APM1.0-1.11 ',00h

;---------------------------------------------------------------;
;	     RUN TIME CORE BIOS SMI APM HANDLER CODE		;
;	     RUN TIME CORE BIOS SMI APM HANDLER CODE		;
;	     RUN TIME CORE BIOS SMI APM HANDLER CODE		;
;	     RUN TIME CORE BIOS SMI APM HANDLER CODE		;
;---------------------------------------------------------------;
;			APM_CALL_NEAR				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		(AX),(EBX),(ECX),(DX),(SI) & (EDI) has on	;
;		entry values when APM call was made.		;
;		(BP) bit 0 1 called in real mode		;
;		     bit 1 1 called in 16 bit protected mode	;
;		     bit 2 1 called in 32 bit protected mode	;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error & (AH) has error code		;
;		Registers as specified in function. Possible	;
;		registers are (AX),(EBX),(ECX),(DX),(SI) & (EDI);
;	Register destroyed : NONE except returned parameters in	;
;			     (AX),(EBX),(ECX),(DX),(SI) & (EDI)	;
;---------------------------------------------------------------;

apm_call_near	proc	near

	pushf					; save current CPU flags
	test	al,10000000b			; OEM APM functions ?
	jnz	short apm_near_00		; yes..

;-----------------------------------------------;

	pushad					; save all registers
	call	get_ebp_for_stack_usage		; (ebp) = current stack pointer

;-----------------------------------------------;
;	STACK LAYOUT AT THIS POSITION		;
;-----------------------------------------------;
;		EDI			[EBP+00];
;-----------------------------------------------;
;		ESI			[EBP+04];
;-----------------------------------------------;
;		EBP			[EBP+08];
;-----------------------------------------------;
;		ESP			[EBP+12];
;-----------------------------------------------;
;		EBX			[EBP+16];
;-----------------------------------------------;
;		EDX			[EBP+20];
;-----------------------------------------------;
;		ECX			[EBP+24];
;-----------------------------------------------;
;		EAX			[EBP+28];
;-----------------------------------------------;
;		FLAG			[EBP+32];
;-----------------------------------------------;
;		IP			[EBP+34];
;-----------------------------------------------;

	cmp	al,maxm_apm_v10_func_supported	; valid function (maximum func. no. supported) ?
	ja	short apm_near_01		; no...invalid function

apm_near_06:
	cbw					; (ax) = function no.
	shl	ax,1				; (ax) = func # * 2
	xchg	ax,di				; RESTORE (DI) IN EACH FUNCTION CALL IF REQUIRED
						; on entry (AX),(DI) destroyed

	and	byte ptr [ebp+off_flag_apm],0feh; clear (CF)
	mov	al,ds:apm_connection_info	; (al) = current apm_connection_info
	call	word ptr cgroup:[di+cgroup:apm_jmp_table - cgroup:smi_code_begin + orgbase ]; execute the function
						; returns (CY) = 0/1 for no error/error

apm_near_03:
	jnc	short apm_near_02		; no error
apm_near_04:
	or	byte ptr [ebp+off_flag_apm],01h	; set (CF)
apm_near_02:
	popad					; restore all registers
	popf					; restore CPU flag
	ret

apm_near_01:
	mov	byte ptr [ebp+off_ah_apm],unsupported_func
	jmp	short apm_near_04		;

;-----------------------------------------------;

apm_near_00:
	popf					; restore on entry CPU flags
	jmp	exec_oem_apm_func		; CHIPSET/OEM HOOK HOOK HOOK...execute OEM APM functions

apm_call_near	endp

;---------------------------------------------------------------;
;			    APM_JMP_TABLE			;
;---------------------------------------------------------------;

apm_jmp_table	label	word

	dw	cgroup:int_15_ah53_al00 - cgroup:smi_code_begin + orgbase; FN# = 00 ... APM installation check
	dw	cgroup:int_15_ah53_al01 - cgroup:smi_code_begin + orgbase; FN# = 01 ... APM real mode interface connect
	dw	cgroup:int_15_ah53_al02 - cgroup:smi_code_begin + orgbase; FN# = 02 ... APM protected mode connect 16 bit
	dw	cgroup:int_15_ah53_al03 - cgroup:smi_code_begin + orgbase; FN# = 03 ... APM protected mode connect 32 bit
	dw	cgroup:int_15_ah53_al04	- cgroup:smi_code_begin + orgbase; FN# = 04 ... APM interface disconnect
	dw	cgroup:int_15_ah53_al05	- cgroup:smi_code_begin + orgbase; FN# = 05 ... APM CPU idle
	dw	cgroup:int_15_ah53_al06	- cgroup:smi_code_begin + orgbase; FN# = 06 ... APM CPU busy
	dw	cgroup:int_15_ah53_al07	- cgroup:smi_code_begin + orgbase; FN# = 07 ... set power state
	dw	cgroup:int_15_ah53_al08	- cgroup:smi_code_begin + orgbase; FN# = 08 ... enable/disable power management
	dw	cgroup:int_15_ah53_al09	- cgroup:smi_code_begin + orgbase; FN# = 09 ... restore power on defaults
	dw	cgroup:int_15_ah53_al0a	- cgroup:smi_code_begin + orgbase; FN# = 0A ... get power status
	dw	cgroup:int_15_ah53_al0b	- cgroup:smi_code_begin + orgbase; FN# = 0B ... get PM event

;---------------------------------------------------------------;
;		FN# 00H ... APM INSTALLATION CHECK		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al00	proc	near

	call	check_real_mode_call		; called in real mode & valid device ID ?
	jc	short int_15_ah53_al00_00	; no...error

;-----------------------------------------------;

	and	al,not (apm_cpu_idle_slow_speed or apm_bios_power_management_disabled)
						; set for CPU STOP clock
						; set for APM BIOS power management enabled

;-----------------------------------------------;

	mov	cx,0000000000000011b		; bit 0 = 1 means 16 bit protected mode interface supported
						; bit 1 = 1 means 32 bit protected mode interface supported

	call	get_apm_cpu_idle_speed		; CHIPSET HOOK HOOK HOOK...APM CPU idle call slows processor clock speed ?
	jnc	short int_15_ah53_al00_05	; no...STOPs CPU clock
	or	cl,00000100b			; inform CPU idle call slows processor clock speed
	or	al,apm_cpu_idle_slow_speed	; keep info APM CPU idle call slows processor clock speed
int_15_ah53_al00_05:
	call	get_apm_bios_pm_status		; APM BIOS power management disabled ?
	jnc	short int_15_ah53_al00_10	; no...
	or	al,apm_bios_power_management_disabled; keep info APM BIOS power management disabled
	or	cl,00001000b			; inform APM BIOS power management disabled
int_15_ah53_al00_10:
	mov	ds:apm_connection_info,al	; update APM_CONNECTION_INFO
	call	set_rom_apm_connection_info	; update ROM_APM_CONNECTION_INFO

	mov	word ptr [ebp+off_ax_apm],0100h	; return (ax) as version no. of APM being supported
	mov	word ptr [ebp+off_bx_apm],'PM'	; return (bx)
	mov	[ebp+off_cx_apm],cx		; return (cx)
	clc					; set (CY) = 00 for no error
int_15_ah53_al00_00:
	ret

int_15_ah53_al00	endp

;---------------------------------------------------------------;
;	   FN# 01H ... APM REAL MODE INTERFACE CONNECT		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al01	proc	near

	mov	dl,apm_real_mode_connect_est	; APM real mode connection request
	jmp	short apm_connect_common	;

int_15_ah53_al01	endp

;---------------------------------------------------------------;
;	  FN# 02H ... APM PROTECTED MODE 16 BIT CONNECT		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al02	proc	near

	mov	dl,apm_16bit_mode_connect_est	; APM 16 bit protected mode connect request
	jmp	short apm_connect_common	;

int_15_ah53_al02	endp

;---------------------------------------------------------------;
;	  FN# 03H ... APM PROTECTED MODE 32 BIT CONNECT		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al03	proc	near

	mov	dl,apm_32bit_mode_connect_est	; APM 32 bit protected mode connection request
	jmp	short apm_connect_common	;

int_15_ah53_al03	endp

;---------------------------------------------------------------;
;			APM_CONNECT_COMMON			;
;---------------------------------------------------------------;
;	Input : (DL) bit 0 1 APM real mode connect request	;
;		     bit 1 1 APM 16 bit prot mode connect request
;		     bit 2 1 APM 32 bit prot mode connect request
;		(BX) requested device id			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

apm_connect_common	proc	near

	call	check_real_mode_call		; called in real mode & valid device ID ?
	jc	short apm_connect_common_00	; no...error

;-----------------------------------------------;

	test	al,apm_real_mode_connect_est	; APM real mode connection already established ?
	jnz	short apm_connect_common_02	; yes...error
	test	al,apm_16bit_mode_connect_est	; APM 16 bit protected mode connection already established ?
	jnz	short apm_connect_common_04	; yes...
	test	al,apm_32bit_mode_connect_est	; APM 32 bit protected mode connection already established ?
	jnz	short apm_connect_common_05	; yes...

;-----------------------------------------------;

	or	al,dl				;
	mov	ds:apm_connection_info,al	; set APM_CONNECTION_INFO
	call	set_rom_apm_connection_info	; set ROM_APM_CONNECTION_INFO

	mov	al,process_apm_connect		;
	call	css_entry_std			; call chipset specific module

;-----------------------------------------------;
;   FOLLOWING CODE HAS BEEN ADDED TO HANDLE A	;
;   BUG IN DOS POWER.EXE. THE BUG RELATED TO	;
;   SWITCHING BETWEEN POWER ON/OFF SETTINGS.	;
;-----------------------------------------------;

	push	ebp				;
	mov	ax,53h*256+apm_func_08		; enable/disable power management call
	mov	bx,all_pm_device_id_v10		; all devices power managed by APM BIOS
	mov	cx,enable_power_management	; enable power management
	mov	bp,00000001b			; set for called in real mode
	call	apm_call_near			;
	pop	ebp				;

;-----------------------------------------------;

	mov	al,dl				; (al) = bit 0/1/2 set APM real/16 bit/32 bit mode connection request

	test	al,00000001b			; APM real mode connect request ?
	jnz	short apm_connect_common_10	; yes...
	
;-----------------------------------------------;

	call	get_apm_16_32_bit_code_seg	; (bx) = APM BIOS 16 bit/32 bit protected mode code segment
	mov	[ebp+off_ax_apm],bx		; return (ax)

	call	get_apm_16_32_bit_data_seg	; (dx) = APM BIOS 16 bit/32 bit protected mode data segment

	test	al,00000010b			; APM 16 bit protected mode connect request ?
	jnz	short apm_connect_common_11	; yes...

	mov	[ebp+off_cx_apm],bx		; return (cx)
	mov	[ebp+off_dx_apm],dx		; return (dx)

	call	get_apm_32_bit_entry_point	; NON-SMI CORE BIOS ENTRY POINT...(ebx) = APM bios 32 bit protected mode entry point
	mov	[ebp+off_ebx_apm],ebx		; return (ebx)

	clc					; set (CY) = 00 for no error
apm_connect_common_00:
	ret

apm_connect_common_11:
	mov	[ebp+off_cx_apm],dx		; return (cx)

	call	get_apm_16_bit_entry_point	; NON-SMI CORE BIOS ENTRY POINT...(bx) = APM bios 16 bit protected mode entry point
	mov	[ebp+off_bx_apm],bx		; return (bx)

apm_connect_common_10:
	clc					; set (CY) = 00 for no error
	ret

;-----------------------------------------------;

apm_connect_common_02:
	mov	ah,real_mode_connect_present	; real mode interface connection already established
	jmp	short apm_connect_common_exit	;

apm_connect_common_04:
	mov	ah,prot_mode_16bit_connect_present; 16 bit protected mode interface already established
	jmp	short apm_connect_common_exit	;

apm_connect_common_05:
	mov	ah,prot_mode_32bit_connect_present; 32 bit protected mode interface already established

apm_connect_common_exit:
	jmp	apm_error_exit			;

apm_connect_common	endp

;---------------------------------------------------------------;
;			CHECK_REAL_MODE_CALL			;
;---------------------------------------------------------------;
;	Input :	(DS) PM bios data segment			;
;		(BX) device ID					;
;		(AL) APM_CONNECTION_INFO			;
;	Output:	(CY) 00 for no error				;
;		(CY) 01 for error...invalid function		;
;				 ...unrecognized device ID	;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

check_real_mode_call	proc	near

	test	byte ptr [ebp+off_bp_apm],00000001b; called in real mode ?
	jz	short check_real_mode_call_00	; no...invalid function
	cmp	bx,system_bios_device_id	; power device ID for APM BIOS ?
	jnz	short check_real_mode_call_01	; no...error
	ret

;-----------------------------------------------;

check_real_mode_call_00::
	mov	ah,unsupported_func		; function not supported
	jmp	apm_error_exit			;

check_real_mode_call_01:
int_15_ah53_al04_01::
	jmp	apm_err_code_09			; unrecognized device ID

check_real_mode_call	endp

;---------------------------------------------------------------;
;	      FN# 04H ... APM INTERFACE DISCONNECT		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al04	proc	near

	test	al,(apm_real_mode_connect_est or apm_16bit_mode_connect_est or apm_32bit_mode_connect_est); is proper APM connection done ?
	jz	short int_15_ah53_al04_00	; no...
	cmp	bx,system_bios_device_id	; power device ID for APM BIOS ?
	jnz	short int_15_ah53_al04_01	; no...error
	and	al,not (apm_real_mode_connect_est or apm_16bit_mode_connect_est or apm_32bit_mode_connect_est); set APM is disconnected
	mov	ds:apm_connection_info,al	; set APM_CONNECTION_INFO
	call	set_rom_apm_connection_info	; set ROM_APM_CONNECTION_INFO

	mov	al,process_apm_disconnect	;
	call	css_entry_std			; call chipset specific module

	clc					; (CY) = 00 for no error
	ret

;-----------------------------------------------;

int_15_ah53_al04_00:
check_apm_connection_00::
	mov	ah,interface_not_connected	; APM driver interface not connected
	jmp	apm_error_exit			;

int_15_ah53_al04	endp

;---------------------------------------------------------------;
;			CHECK_APM_CONNECTION			;
;---------------------------------------------------------------;
;	Input :	(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output:	(CY) 00 for no error				;
;		(CY) 01 for error...APM not connected		;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

check_apm_connection	proc	near

	test	al,[ebp+off_bp_apm]		; is proper APM connection done ?
	jz	short check_apm_connection_00	; no...(cy) = 00 for no error
	ret

check_apm_connection	endp

;---------------------------------------------------------------;
;		     FN# 05H ... CPU IDLE			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al05	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al05_00	; no...

	mov	al,set_pre_cpu_idle_environment	; setup before going for cpu slow/stop clock
	call	css_entry_std			;

	mov	al,apm_cpu_idle_call		; set stop clock/slow clock
	call	css_entry_std			;

	mov	al,set_post_cpu_idle_environment; setup after coming out of stop clock
	call	css_entry_std			;
	clc					; set (CY) = 00 for no error

int_15_ah53_al05_00:
	ret

int_15_ah53_al05	endp

;---------------------------------------------------------------;
;		    FN# 06H ... APM CPU BUSY			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al06	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al06_00	; no...

	mov	al,apm_cpu_busy_call		; set to full processor clock speed
	call	css_entry_std			;
	clc					; set (CY) = 00 for no error
int_15_ah53_al06_00:
	ret

int_15_ah53_al06	endp

;---------------------------------------------------------------;
;		   FN# 07H ... SET POWER STATE			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al07	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al07_00	; no...

	test	al,apm_bios_power_management_disabled; APM BIOS power management disabled ?
	jnz	short int_15_ah53_al07_01	; yes...

	cmp	bh,serial_port_device_id	; valid device ID ?
	ja	short int_15_ah53_al07_03	; no...

	mov	dl,not apm_on_state		; clear APM state

	cmp	cx,apm_suspend			; set APM suspend state ?
	jz	short int_15_ah53_al07_02	; yes...

	mov	dh,apm_standby_state		;
	mov	al,off_set_apm_standby_fn	; set APM standby state
	cmp	cx,apm_standby			; set APM standby state ?
	jz	short int_15_ah53_al07_08	; yes...

	mov	dh,apm_enabled_state		;
	mov	al,off_set_apm_enabled_fn	; set APM enabled state
	cmp	cx,apm_enabled			; set APM enabled state ?
	jz	short int_15_ah53_al07_04	; yes...

	mov	dh,apm_off_state		; 
	mov	al,off_set_apm_off_fn		; set APM off state
	cmp	cx,apm_off			; set APM off state ?
	jnz	short int_15_ah53_al07_05	; no...error

int_15_ah53_al07_04:
	cmp	bx,all_power_managed_device_id	; all devices power managed by APM BIOS ?
	jz	short int_15_ah53_al07_10	; yes...unable to enter requested state
	jmp	short int_15_ah53_al07_08	;

int_15_ah53_al07_02:

;-----------------------------------------------;
;	AS FOR SYSTEM SUSPEND CALL, WHILE	;
;	IT RETURNS TO CALLER, THE SYSTEM	;
;	SHOULD RESUME FROM SUSPEND, SO		;
;	THE SYSTEM STATE SHOULD BE PLACED	;
;	     IN 'apm_enabled' STATE		;
;-----------------------------------------------;

	mov	dh,apm_enabled_state		;
	mov	al,off_set_apm_suspend_fn	; set APM suspend state

	cmp	bh,system_device_id		; is request for system ?
	jz	short int_15_ah53_al07_08	; yes...
	mov	dh,apm_suspend_state		;

int_15_ah53_al07_08:
	jmp	exec_apm_common			; execute the function

int_15_ah53_al07_00:
int_15_ah53_al08_00::
	ret

;-----------------------------------------------;

int_15_ah53_al07_03:
	jmp	apm_err_code_09			; unrecognized device ID

int_15_ah53_al07_01:
	jmp	apm_err_code_01			; power management functionality disabled

int_15_ah53_al07_10:
	mov	ah,unable_to_enter_req_state	; unable to enter requested state
	jmp	short int_15_ah53_al07_50	;

int_15_ah53_al07_05:
int_15_ah53_al08_05::
	mov	ah,parameter_out_of_range	; parameter value out of range

int_15_ah53_al07_50:
	jmp	apm_error_exit			;

int_15_ah53_al07	endp

;---------------------------------------------------------------;
;	   FN# 08H ... ENABLE/DISABLE POWER MANAGEMENT		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al08	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al08_00	; no...
	test	al,apm_bios_power_management_disabled; APM BIOS power management disabled ?
	jnz	short int_15_ah53_al08_01	; yes...

	cmp	bx,all_pm_device_id_v10		; all power managed device ID for v1.0 ?
	jnz	short int_15_ah53_al08_03	; no...invalid device ID
	mov	bx,all_power_managed_device_id	; convert it to v1.1 ID

	mov	dl,not pm_enabled_by_apm	; clear pm enabled by APM bit

	mov	dh,pm_enabled_by_apm		; set pm enabled by APM bit
	mov	al,off_enable_dev_pm_fn		; execute enable power management
	cmp	cx,enable_power_management	; enable power management ?
	jz	short int_15_ah53_al08_08	; yes...
	cmp	cx,disable_power_management	; disable power management ?
	jnz	short int_15_ah53_al08_05	; no...error

;-----------------------------------------------;
;	FOLLOWING CODE IN BLOCK IS ADDED TO	;
;	     PASS INTEL APM TEST SUITE		;
;-----------------------------------------------;

	test	byte ptr ds:apm_state,pm_enabled_by_apm	; power management enabled by APM ?
	jz	short int_15_ah53_al08_01	; no...

;-----------------------------------------------;

	mov	dh,00000000b			; disable power management
	mov	al,off_disable_dev_pm_fn	; execute disable power management

int_15_ah53_al08_08:
	jmp	short exec_apm_common		; execute the function

;-----------------------------------------------;

int_15_ah53_al08_03:
int_15_ah53_al09_03::
int_15_ah53_al0a_03::
	jmp	short apm_err_code_09		; unrecognized device ID

int_15_ah53_al08_01:
	jmp	short apm_err_code_01		; power management functionality disabled

int_15_ah53_al08	endp

;---------------------------------------------------------------;
;	      FN# 09H ... RESTORE POWER ON DEFAULTS		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al09	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al09_00	; no...

	cmp	bx,all_pm_device_id_v10		; all power managed device ID for v1.0 ?
	jnz	short int_15_ah53_al09_03	; no...invalid device ID

	mov	al,set_power_on_defaults	; set power on defaults for power management
	call	css_entry_std			; execute in chipset specific module

	call	set_dev_state			; set device states to power on default
	mov	al,ds:apm_state			;
	call	set_rom_apm_state		; update ROM_APM_STATE
	clc					; set (cy) = 00 for no error
int_15_ah53_al09_00:
	ret

int_15_ah53_al09	endp

;---------------------------------------------------------------;
;		  FN# 0AH ... GET POWER STATUS			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al0a	proc	near

	cmp	bx,all_power_managed_device_id	; valid device ID ?
	jnz	short int_15_ah53_al0a_03	; no...
	call	get_ac_battery_status		; CHIPSET HOOK HOOK HOOK...returns AC line status & battery status in (bx),(cx) & (dx)
	cmp	bh,02h				; AC line status is 'On backup power' ?
	jnz	short int_15_ah53_al0a_00	; no...
	mov	bh,00h				; set AC line status as 'Off-line'

int_15_ah53_al0a_00:
	mov	[ebp+off_bx_apm],bx		; return (bx)
	mov	[ebp+off_cl_apm],cl		; return (cl)
	clc					; (CY) = 00 for no error
	ret

int_15_ah53_al0a	endp

;---------------------------------------------------------------;
;		    FN# 0BH ... GET PM EVENT			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al0b	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al0b_00	; no...

	mov	ax,ds:pending_apm_event		;
	and	ax,valid_v10_event_mask		; consider APM v1.0 events only
	bsr	bx,ax				; any event pending ?
	jz	short int_15_ah53_al0b_02	; no...
	btr	ax,bx				; clear pending APM event
	mov	ds:pending_apm_event,ax		; update PENDING_APM_EVENT
	call	set_rom_pending_apm_event	; update ROM_PENDING_APM_EVENT

	inc	bx				; translated APM event
	mov	[ebp+off_bx_apm],bx		; return (bx)
	mov	al,notify_pm_event_posted	; notify chipset specific module about PM event posted to OS
	call	css_entry_std			;
	clc					; (CY) = 00 for no error
int_15_ah53_al0b_00:
	ret

;-----------------------------------------------;

int_15_ah53_al0b_02:
	mov	ah,no_pm_event_pending		; no power management event pending
	jmp	short apm_error_exit		;

int_15_ah53_al0b	endp

;---------------------------------------------------------------;
;		   SUBROUTINES USED BY APM BIOS			;
;---------------------------------------------------------------;
;			     APM_ERROR				;
;	Input : NONE						;
;	Output: Error code in (AH) updated in stack		;
;	Register destroyed : (AH)				;
;---------------------------------------------------------------;

apm_error	proc	near

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

apm_err_code_01	proc	near

	mov	ah,power_management_disabled	; power management functionality disabled
	jmp	short apm_error_exit		;

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

apm_err_code_09	proc	near

	mov	ah,invalid_device_id		; unrecognized device ID

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

apm_error_exit	proc	near

	mov	[ebp+off_ah_apm],ah		; return (ah)
	stc					; (CY) = 01 for error
	ret

apm_error_exit	endp
apm_err_code_09	endp
apm_err_code_01	endp
apm_error	endp

;---------------------------------------------------------------;
;			   EXEC_APM_COMMON			;
;---------------------------------------------------------------;
;	Input : (DL) to be ANDed to dev state			;
;		(DH) to be ORed to dev state			;
;		(AL) offeset for function exec			;
;		(BH) device #					;
;		(BL) unit #					;
;	Output: (CY) = 00 for no error				;
;		(CY) = 01 for error & error code in (AH) updated;
;				      in stack.			;
;	Register destroyed : (EAX),(BX),(CX),(SI),(DI)		;
;---------------------------------------------------------------;

exec_apm_common	proc	near

	movzx	si,al				; (si) = offset for function execution
	cmp	bh,system_device_id		; system ?
	jnz	short apm_common_01		; no...other device
	cmp	bx,all_power_managed_device_id	; all devices power managed by APM BIOS ?
	jnz	short apm_common_02		; no...error

	mov	bl,0ffh				; set it for all units
	call	handle_apm_dev			; handle the requested device

	pushf					;
	push	ax				;
	mov	al,ds:apm_state			;
	call	set_rom_apm_state		; update ROM_APM_STATE
	pop	ax				;
	popf					;	

	ret

apm_common_01:
	call	handle_apm_dev			; handle the requested device
	ret

;-----------------------------------------------;

apm_common_02:
	jmp	short apm_err_code_09		; unrecognized device ID

exec_apm_common	endp

;---------------------------------------------------------------;
;			HANDLE_APM_DEV				;
;---------------------------------------------------------------;
;	Input : (DL) to be ANDed to dev state			;
;		(DH) to be ORed to dev state			;
;		(SI) offeset for function exec			;
;		(BH) device #					;
;		(BL) unit #, 0ffh means all units		;
;	Output: (CY) = 00 for no error				;
;		(CY) = 01 for error & error code in (AH) updated;
;				      in stack.			;
;	Register destroyed : (EAX),(BX),(CX),(DI)		;
;---------------------------------------------------------------;

handle_apm_dev	proc	near

	mov	al,bh				; (al) = device #
	mov	cl,no_of_units_for_each_dev	; (cl) = # of units for each device
	mul	cl				; (ax) = device # * # of units for each device
	mov	di,ax				;
	add	di,apm_state			; (di) = points to requested device state

	mov	ch,[ebp+off_al_apm]		; (ch) = APM fn#

	call	verify_apm_unit			;
	jc	short handle_apm_dev_01		; error...
	jz	short handle_apm_dev_11		; do not need to update APM data area or do not need to call chipset specific module

	push	dx				;
	mov	ax,si				; (al) = function#
	mov	dx,bx				; (dl) = unit#, (dh) = device#
	call	css_entry_std			; execute the function in APM chipset specific module
	pop	dx				;
	jc	short handle_apm_dev_00		; error...
handle_apm_dev_03:
	call	update_apm_global		; update global
handle_apm_dev_11:
	clc					; (cy) = 00 for no error
handle_apm_dev_01:
	ret

handle_apm_dev_00:
	cmp	ch,apm_func_07			; set power state function ?
	jnz	short handle_apm_dev_03		; no...ignore the error

	mov	ah,unable_to_enter_req_state	; unable to enter requested state
	jmp	short apm_error_exit		;

handle_apm_dev	endp

;---------------------------------------------------------------;
;			VERIFY_APM_UNIT				;
;---------------------------------------------------------------;
;	Input : (DI) pointer to info for the dev		;
;		(BH) device #					;
;		(BL) unit #, 0ffh means all units		;
;		(CL) # of units for each device			;
;		(CH) APM fn#					;
;	Output: (CY) = 00 for no error				;
;		       (ZF) set..do not need chipset module call;
;		       (ZF) not set..needs chipset module call	;
;		(CY) = 01 for error & error code in (AH) updated;
;				      in stack.			;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

verify_apm_unit	proc	near

	cmp	bl,0ffh				; all units ?
	jz	short verify_apm_unit_00	; yes...
	cmp	bl,no_of_units_for_each_dev	; valid unit # ?
	jb	short verify_apm_unit_00	; yes...
	xor	bl,bl				; set the unit # to 00
verify_apm_unit_00:
	cmp	ch,apm_func_08			; enable/disable power management function ?
	jz	short verify_apm_unit_02	; yes...
	push	bx				;
	mov	al,[di]				; for all units, consider unit # 00
	cmp	bl,0ffh				; all units ?
	jz	short verify_apm_unit_03	; yes...
	xor	bh,bh				; (bx) = unit #
	mov	al,[di+bx]			;
verify_apm_unit_03:
	pop	bx				;
	test	al,pm_enabled_by_apm		; power management enabled by APM for this device/unit ?
	jz	short verify_apm_unit_01	; no...
verify_apm_unit_02:
	or	sp,sp				; set (NZF) so that call goes to CSS module
	clc					; (cy) = 00 for no error
	ret

verify_apm_unit_01:
	jmp	apm_err_code_01			; power management disabled

verify_apm_unit	endp

;---------------------------------------------------------------;
;			UPDATE_APM_GLOBAL			;
;---------------------------------------------------------------;
;	Input : (DI) pointer to info for the dev		;
;		(DL) to be ANDed to dev state			;
;		(DH) to be ORed to dev state			;
;		(BH) device #					;
;		(BL) unit #, 0ffh means all units		;
;		(CL) # of units for each device			;
;		(CH) APM fn#					;
;	Output: NONE						;
;	Register destroyed : NONE except (AL),(BX),(DI)		;
;---------------------------------------------------------------;

update_apm_global	proc	near

	cmp	bh,system_device_id		; system ?
	jnz	short update_apm_global_00	; no...

	mov	al,no_of_total_dev_v10		; total # of device supported
update_apm_global_01:
	call	cntrl_dev_class			; handle current device
	add	di,no_of_units_for_each_dev	; points to next device
	dec	al				;
	jnz	short update_apm_global_01	;
	ret

update_apm_global_00:
	cmp	bl,0ffh				; all units of the class ?
	jz	short update_apm_global_02	; yes...
	xor	bh,bh				; (bx) = unit #
	and	[di+bx],dl			; clear the required bits
	or	[di+bx],dh			; update required bits
	ret

update_apm_global_02:
	call	cntrl_dev_class			; handle all units for the device
	ret

update_apm_global	endp

;---------------------------------------------------------------;
;			CNTRL_DEV_CLASS				;
;---------------------------------------------------------------;
;	Input : (DI) pointer to info for the dev		;
;		(DL) to be ANDed to dev state			;
;		(DH) to be ORed to dev state			;
;		(CL) # of units for each device			;
;		(CH) APM fn#					;
;	Output: NONE						;
;	Register destroyed : NONE except (BX)			;
;---------------------------------------------------------------;

cntrl_dev_class	proc	near

	push	cx				;
	xor	bx,bx				; start with unit# 00
cntrl_dev_class_06:
	cmp	ch,apm_func_08			; enable/disable power mgt func ?
	jz	short cntrl_dev_class_11	; yes...
	test	byte ptr [di+bx],pm_enabled_by_apm; power mgt enabled by APM for this dev/unit ?
	jz	short cntrl_dev_class_04	; no...
cntrl_dev_class_11:
	and	[di+bx],dl			; clear the required bits
	or	[di+bx],dh			; update required bits
cntrl_dev_class_04:
	inc	bx				; next unit#
	dec	cl				; decrement # of units
	jnz	short cntrl_dev_class_06	;
	pop	cx				;
	ret

cntrl_dev_class	endp

;---------------------------------------------------------------;
;			CSS_ENTRY_STD				;
;---------------------------------------------------------------;
;	Input : (AL) func# to execute				;
;		(DS) PM bios data segment			;
;		(DI) pointer to dev state for some functions	;
;		(DH) device# for some functions			;
;		(DL) unit# for some functions,0ffh for all units;
;		(CL) # of units for each device for some funcs	;
;		(BX) PM event code posted for some function	;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;	Register destroyed : NONE except (EAX)			;
;---------------------------------------------------------------;

css_entry_std	proc	near

	pushad					;
	mov	ch,[ebp+off_bp_apm]		; (ch) = info about func called in real/16/32 mode
	call	apm_css_entry			; CHIPSET HOOK HOOK HOOK...execute in APM chipset specific module
	call	get_ebp_for_stack_usage		; (ebp) = current stack pointer
	mov	[ebp+28],eax			; put returned (eax) on stack
	popad					;
	ret

css_entry_std	endp

;---------------------------------------------------------------;
;		   GET_APM_BIOS_PM_STATUS			;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;		STACK PRESENT					;
;	Output: (CY) 00 for APM BIOS power management enabled	;
;		(CY) 01 for APM BIOS power management disabled	;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

get_apm_bios_pm_status	proc	near

;-----------------------------------------------;
;   FOLLOWING PIECE OF CODE HAS BEEN REMOVED	;
;   AND REPLACED BY 'CLC' & 'RET' AS WE ARE	;
;   EXECUTING APM ONLY IF SMI/IRQ BASED POWER	;
;   MANAGEMENT IS ACTIVE, WHICH MEANS IT WILL	;
;   ALWAYS RETURN POWER MANAGEMENT ENABLED.	;
;-----------------------------------------------;

	clc					; (CY) = 00 for APM BIOS power management enabled
	ret

get_apm_bios_pm_status	endp

;---------------------------------------------------------------;
;			  APM_POST				;
;---------------------------------------------------------------;
;	Input : (DS) PM BIOS data segment			;
;	Output: NONE						;
;	Register destroyed : (AL),(DI)				;
;---------------------------------------------------------------;

apm_post	proc	near

	mov	word ptr ds:apm_bios_ver_no,0100h; set to v1.0

	mov	byte ptr ds:apm_connection_info,00000000b; no APM connection
						; APM BIOS active version v1.0

	mov	word ptr ds:pending_apm_event,0000h

;---------------------------------------------------------------;
;			  SET_DEV_STATE				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : (AL),(DI)				;
;---------------------------------------------------------------;

set_dev_state	proc	near

	push	cx				;
	mov	cx,no_of_total_dev_v10 * no_of_units_for_each_dev; (cx) = total # of device info bytes
	mov	di,apm_state			; (di) = APM device state pointer
	mov	al,apm_dev or pm_engaged_by_apm or pm_enabled_by_apm
set_dev_state_00:
	mov	[di],al				; set the device/unit state
	inc	di				; points to next device/unit
	loop	set_dev_state_00		;
	pop	cx				;
	ret
	
set_dev_state	endp
apm_post	endp

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
