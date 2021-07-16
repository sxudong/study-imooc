Subttl.	Include file for GREEN PC support APM v1.2 code...GAPM12.INC

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
;	 AND INTEL IN V1.0/V1.1 SPECS		;
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

	db	'APM1.2-1.11 ',00h

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

	cmp	word ptr ds:apm_bios_ver_no,0100h; APM v1.0 ?
	jz	short apm_near_05		; yes...
	cmp	al,apm_func_0e			; function no. 0Eh ?
	jz	short apm_near_06		; yes...

	cmp	word ptr ds:apm_bios_ver_no,0102h; APM v1.2 or above ?
	jb	short apm_near_08		; no...
	cmp	al,apm_func_10			; function no. 10h ?
	jz	short apm_near_06		;
apm_near_08:

	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; active APM v1.0 ?
	jz	short apm_near_05		; yes...
	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_v12; active APM v1.2 ?
	jnz	short apm_near_10		; yes...
	cmp	al,maxm_apm_v11_func_supported	; valid function no. ?
	jmp	short apm_near_07		;

apm_near_10:
	cmp	al,maxm_apm_v12_func_supported	; valid function no. ?
	jmp	short apm_near_07		;

apm_near_05:
	cmp	al,maxm_apm_v10_func_supported	; valid function (maximum func. no. supported) ?
apm_near_07:
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
	dw	cgroup:int_15_ah53_al0c	- cgroup:smi_code_begin + orgbase; FN# = 0C ... get power state (v1.1 only)
	dw	cgroup:int_15_ah53_al0d	- cgroup:smi_code_begin + orgbase; FN# = 0D ... enable/disable device power management(v1.1 only)
	dw	cgroup:int_15_ah53_al0e	- cgroup:smi_code_begin + orgbase; FN# = 0E ... APM driver version (v1.1 only)
	dw	cgroup:int_15_ah53_al0f	- cgroup:smi_code_begin + orgbase; FN# = 0F ... engage/disengage power management(v1.1 only)
	dw	cgroup:int_15_ah53_al10 - cgroup:smi_code_begin + orgbase; FN# = 10 ... get capabilities (v1.2 only)
	dw	cgroup:int_15_ah53_al11 - cgroup:smi_code_begin + orgbase; FN# = 11 ... get/set/disable resume timer (v1.2 only)
	dw	cgroup:int_15_ah53_al12 - cgroup:smi_code_begin + orgbase; FN# = 12 ... enable/disable resume on ring indicator (v1.2 only)
	dw	cgroup:int_15_ah53_al13	- cgroup:smi_code_begin + orgbase; FN# = 13 ... enable/disable timer based requests (v1.2 only)

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
	test	al,apm_bios_active_ver_above_v10; APM v1.0 ?
	jz	short int_15_ah53_al00_06	; yes...
	test	byte ptr ds:apm_state,pm_engaged_by_apm	; APM BIOS power management engaged ?
	jnz	short int_15_ah53_al00_06	; yes...
	or	cl,00010000b			; inform APM BIOS power management disengaged
int_15_ah53_al00_06:
;; Added by Robert at 11/27/97 for power off working when PM disabled!
	push	ax
	mov	al,q_power_management
	call	check_cmos_data_far
	jnz	pm_op_enable
	mov	cl,08h   
pm_op_enable:
	pop	ax
	mov	ds:apm_connection_info,al	; update APM_CONNECTION_INFO
	call	set_rom_apm_connection_info	; update ROM_APM_CONNECTION_INFO

	mov	ax,ds:apm_bios_ver_no		; (ax) = version no. of APM being supported
	mov	[ebp+off_ax_apm],ax		; return (ax)
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
	call	apm_connect_local		; do any local data area updation for APM connect

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
;	  REMOVED TO SUPPORT 'CHICAGO'		;
;-----------------------------------------------;
;	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; APM BIOS active v1.0 ?
;	jz	short apm_connect_common_07	; yes...v1.0
;-----------------------------------------------;

	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_v12; active APM v1.2 ?
	jz	short apm_connect_common_15	; no...
	mov	word ptr [ebp+off_si_apm+2],apm_bios_code_seg_len; (si+) = APM BIOS 16 bit code segment length
						; currently 16 bit/32 bit code segment length same
apm_connect_common_15:

	call	get_apm_bios_data_seg_len	; (di) = APM BIOS data segment length
	mov	[ebp+off_di_apm],di		; return (di)

;-----------------------------------------------;

apm_connect_common_07:
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
	call	apm_disconnect_local		; do any local data area updation for APM disconnect
	clc					; (CY) = 00 for no error
	ret

;-----------------------------------------------;

int_15_ah53_al04_00:
check_apm_connection_00::
	jmp	apm_err_code_03			; ser error APM not connected

int_15_ah53_al04	endp

;---------------------------------------------------------------;
;			CHECK_APM_CONNECTION			;
;---------------------------------------------------------------;
;	Input :	(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output:	(CY) 00 for no error				;
;		(CY) 01 for error...APM not connected		;
;				 ...APM not engaged		;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

check_apm_connection	proc	near

	test	al,[ebp+off_bp_apm]		; is proper APM connection done ?
	jz	short check_apm_connection_00	; no...

	test	al,apm_bios_active_ver_above_v10; APM v1.0 ?
	jz	short check_apm_connection_01	; yes...(CY) = 00
	test	byte ptr ds:apm_state,pm_engaged_by_apm	; power management engaged by APM ?
	jz	short check_apm_connection_06	; no...(CY) = 00

check_apm_connection_01:
	ret

;-----------------------------------------------;

check_apm_connection_06:
	jmp	apm_err_code_0b			; interface not engaged

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


	call	check_apm_dev			; check validity of device and interface
	jc	short int_15_ah53_al07_50	; error...(ah) already has error code updated in stack
	test	al,apm_bios_active_ver_above_v10; APM BIOS active v1.0 ?
	jz	short int_15_ah53_al07_11	; yes...

	mov	al,processing_last_pm_req_notify;
	cmp	cx,apm_last_req_processing_notify; last APM BIOS request is being processed notification ?
	jz	short int_15_ah53_al07_20	; yes...
	mov	al,last_pm_req_rejected		;
	cmp	cx,apm_last_req_rejected	; last APM BIOS request rejected notification ?
	jnz	short int_15_ah53_al07_11	; no...

;-----------------------------------------------;

int_15_ah53_al07_20:
	cmp	bx,all_power_managed_device_id	; all devices power managed by APM BIOS ?
	jnz	short int_15_ah53_al07_09	; no...invalid device ID
	test	byte ptr ds:apm_state,pm_engaged_by_apm	; power management engaged by APM ?
	jz	short int_15_ah53_al07_24	; no...
	call	css_entry_std			; process in chipset specific module
	clc					; (cy) = 00 for no error
int_15_ah53_al07_50:
	ret

;-----------------------------------------------;

int_15_ah53_al07_11:
	mov	dl,not (apm_on_state or apm_fn0c_enabled); clear APM state & func 0Ch enabled

	cmp	cx,apm_suspend			; set APM suspend state ?
	jz	short int_15_ah53_al07_02	; yes...

	mov	dh,apm_standby_state or apm_fn0c_enabled
	mov	al,off_set_apm_standby_fn	; set APM standby state
	cmp	cx,apm_standby			; set APM standby state ?
	jz	short int_15_ah53_al07_08	; yes...

	mov	dh,apm_enabled_state or apm_fn0c_enabled
	mov	al,off_set_apm_enabled_fn	; set APM enabled state
	cmp	cx,apm_enabled			; set APM enabled state ?
	jz	short int_15_ah53_al07_04	; yes...

	mov	dh,apm_off_state or apm_fn0c_enabled
	mov	al,off_set_apm_off_fn		; set APM off state
	cmp	cx,apm_off			; set APM off state ?
	jnz	short int_15_ah53_al07_05	; no...error

	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; APM BIOS active v1.0 ?
	jnz	short int_15_ah53_al07_08	; no...

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

	mov	dh,apm_enabled_state or apm_fn0c_enabled
	mov	al,off_set_apm_suspend_fn	; set APM suspend state

	cmp	bh,system_device_id		; is request for system ?
	jz	short int_15_ah53_al07_08	; yes...
	mov	dh,apm_suspend_state or apm_fn0c_enabled

int_15_ah53_al07_08:
	jmp	exec_apm_common			; execute the function

;-----------------------------------------------;

int_15_ah53_al07_24:
	jmp	apm_err_code_0b			; interface not engaged

int_15_ah53_al07_09:
	jmp	apm_err_code_09			; unrecognized device ID

int_15_ah53_al07_10:
	mov	ah,unable_to_enter_req_state	; unable to enter requested state
	jmp	apm_error_exit			;

int_15_ah53_al07_05:
	jmp	apm_err_code_0a			; parameter value out of range

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

	test	al,[ebp+off_bp_apm]		; is proper APM connection done ?
	jz	short int_15_ah53_al08_00	; no...

;-----------------------------------------------;

	test	al,apm_bios_power_management_disabled; APM BIOS power management disabled ?
	jnz	short int_15_ah53_al08_01	; yes...

	cmp	bx,all_pm_device_id_v10		; all power managed device ID for v1.0 ?
	jnz	short int_15_ah53_al08_02	; no...
	mov	bx,all_power_managed_device_id	; convert it to v1.1 ID
int_15_ah53_al08_02:
	cmp	bx,all_power_managed_device_id	; system ID ?
	jnz	short int_15_ah53_al08_03	; no...invalid device ID

	jmp	int_15_ah53_al080d		; execute like func 0Dh

;-----------------------------------------------;

int_15_ah53_al08_03:
int_15_ah53_al09_03::
int_15_ah53_al0a_03::
	jmp	apm_err_code_09			; unrecognized device ID

int_15_ah53_al08_01:
	jmp	apm_err_code_01			; power management functionality disabled

int_15_ah53_al08_00:
	jmp	apm_err_code_03			; interface not connected

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
	jnz	short int_15_ah53_al09_02	; no...
	mov	bx,all_power_managed_device_id	; convert it to v1.1 ID
int_15_ah53_al09_02:
	cmp	bx,all_power_managed_device_id	; system ID ?
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
	jz	short int_15_ah53_al0a_07	; yes...

	test	al,apm_bios_active_ver_v12	; APM BIOS v1.2 active ?
	jz	short int_15_ah53_al0a_03	; no...

	push	bx				;
	and	bx,0ff00h			; clear unit #
	cmp	bx,8000h			; valid ?
	pop	bx				;
	jnz	short int_15_ah53_al0a_03	; no...

	and	bx,00ffh			; get unit #
	jz	short int_15_ah53_al0a_03	; invalid unit#
	cmp	bl,ds:apm_no_of_battery_units	; valid unit# ?
	ja	short int_15_ah53_al0a_03	; invalid unit#

	call	get_ac_battery_status_v12	; OEM HOOK HOOK HOOK...returns AC line status &
						; battery status in (bx),(cx),(dx) & (si)

	mov	[ebp+off_si_apm],si		; return (si)
	jmp	short int_15_ah53_al0a_02	;

int_15_ah53_al0a_07:
	call	get_ac_battery_status		; CHIPSET HOOK HOOK HOOK...returns AC line status &
						; battery status in (bx),(cx) & (dx)
	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; acive APM v1.0 ?
	jnz	short int_15_ah53_al0a_02	; no...v1.1
	cmp	bh,02h				; AC line status is 'On backup power' ?
	jnz	short int_15_ah53_al0a_00	; no...
	mov	bh,00h				; set AC line status as 'Off-line'
	jmp	short int_15_ah53_al0a_00	;

int_15_ah53_al0a_02:
	mov	[ebp+off_dx_apm],dx		; return (dx)
	mov	[ebp+off_ch_apm],ch		; return (ch)
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

	mov	bx,valid_v10_event_mask		; consider APM v1.0 APM events only
	test	al,apm_bios_active_ver_above_v10; APM BIOS v1.0 ?
	jz	short int_15_ah53_al0b_07	; yes
	mov	bx,valid_v11_event_mask		; consider APM v1.1 APM events only
	test	al,apm_bios_active_ver_v12	; active APM v1.2 ?
	jz	short int_15_ah53_al0b_07	; no...
	mov	bx,valid_v12_event_mask		; consider APM v1.2 APM events only
int_15_ah53_al0b_07:

	mov	ax,ds:pending_apm_event		;
	and	ax,bx				; consider valid APM events
	bsr	bx,ax				; any event pending ?
	jz	short int_15_ah53_al0b_02	; no...
	xor	dx,dx				;
	bts	dx,bx				; set event to be posted bit in (dx)
	btr	ax,bx				; clear pending APM event
	inc	bx				; translated APM event

	push	ax				;
	mov	al,notify_pm_event_posted	; notify chipset specific module about PM event posted to OS
	call	css_entry_std			;
;;	or	al,al				; OK to post event ?
	pop	ax				;
;;	jz	short int_15_ah53_al0b_02	; no...do not post event...post later

	mov	ds:pending_apm_event,ax		; update PENDING_APM_EVENT
	call	set_rom_pending_apm_event	; update ROM_PENDING_APM_EVENT

	mov	[ebp+off_bx_apm],bx		; return (bx)

	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_v12; active APM v1.2 ?
	jz	short int_15_ah53_al0b_10	; no...
	test	dx,normal_resume_sys_bit or critical_resume_sys_bit ; normal resume system notification or critical resume system notification ?
	jz	short int_15_ah53_al0b_10	; no...

	call	get_pcmcia_socket_power_down_info; OEM HOOK HOOK HOOK...return (cx) = PCMCIA socket power on/off info
						; while posting normal resume system notification (0003h) or crtical resume system notification (0004h)
	mov	[ebp+off_cx_apm],cx		; return (cx)

int_15_ah53_al0b_10:
	clc					; (CY) = 00 for no error
int_15_ah53_al0b_00:
	ret

;-----------------------------------------------;

int_15_ah53_al0b_02:
	mov	ah,no_pm_event_pending		; no power management event pending
	jmp	apm_error_exit			;

int_15_ah53_al0b	endp

;---------------------------------------------------------------;
;		   FN# 0CH ... GET POWER STATE			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al0c	proc	near

	call	check_apm_dev_fn0c		; check validity of device
	jc	short int_15_ah53_al0c_50	; error...(ah) already has error code updated in stack

;-----------------------------------------------;

	mov	al,off_get_power_state		; execute get power state

	call	exec_apm_common			; execute the function
	jc	short int_15_ah53_al0c_50	; error...(ah) already has error code updated in stack
	mov	[ebp+off_cx_apm],ax		; return the state
int_15_ah53_al0c_50:
	ret

int_15_ah53_al0c	endp

;---------------------------------------------------------------;
;	FN# 0DH ... ENABLE/DISABLE DEVICE POWER MANAGEMENT	;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al0d	proc	near

	call	check_apm_dev			; check validity of device and interface
	jnc	short int_15_ah53_al080d	; no error
	ret					; error...(ah) already has error code

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

int_15_ah53_al080d	proc	near

	mov	dl,not pm_enabled_by_apm	; clear pm enabled by APM bit

	mov	dh,pm_enabled_by_apm		; set pm enabled by APM bit
	mov	al,off_enable_dev_pm_fn		; execute enable power management
	cmp	cx,enable_power_management	; enable power management ?
	jz	short int_15_ah53_al0d_08	; yes...
	cmp	cx,disable_power_management	; disable power management ?
	jnz	short int_15_ah53_al0d_05	; no...error

;-----------------------------------------------;
;	FOLLOWING CODE IN BLOCK IS ADDED TO	;
;	     PASS INTEL APM TEST SUITE		;
;-----------------------------------------------;

	test	byte ptr ds:apm_state,pm_enabled_by_apm	; power management enabled by APM ?
	jz	short int_15_ah53_al0d_06	; no...

;-----------------------------------------------;

	mov	dh,00000000b			; disable power management
	mov	al,off_disable_dev_pm_fn	; execute disable power management

int_15_ah53_al0d_08:
	jmp	exec_apm_common			; execute the function

;-----------------------------------------------;

int_15_ah53_al0d_06:
	jmp	apm_err_code_01			; power management functionality disabled

int_15_ah53_al0d_05:
int_15_ah53_al0f_05::
	jmp	apm_err_code_0a			; parameter value out of range

int_15_ah53_al080d	endp
int_15_ah53_al0d	endp

;---------------------------------------------------------------;
;		FN# 0EH ... APM DRIVER VERSION			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al0e	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al0e_00	; no...

	cmp	bx,system_bios_device_id	; device ID for APM BIOS ?
	jnz	short int_15_ah53_al0e_01	; no...

	and	al,not (apm_bios_active_ver_above_v10 or apm_bios_active_ver_v12); set to APM BIOS active version v1.0
	cmp	cx,0100h			; APM drive v1.0 ?
	jz	short int_15_ah53_al0e_02	; yes...
	or	al,apm_bios_active_ver_above_v10; set it to above v1.0
	cmp	cx,0101h			; APM drive v1.1 ?
	jz	short int_15_ah53_al0e_02	; yes...
	or	al,apm_bios_active_ver_v12	; set it to v1.2
int_15_ah53_al0e_02:
	mov	ds:apm_connection_info,al	; set APM_CONNECTION_INFO
	call	set_rom_apm_connection_info	; set ROM_APM_CONNECTION_INFO

	mov	[ebp+off_ax_apm],cx		; return APM connection major/minor version no.

	call	add_del_v11_apm_dev		; add/delete v1.1 APM devices according to driver version no.
	clc					; set (CY) = 00 for no error
int_15_ah53_al0e_00:
	ret

;-----------------------------------------------;

int_15_ah53_al0e_01:
	jmp	apm_err_code_09			; invalid device ID

int_15_ah53_al0e	endp

;---------------------------------------------------------------;
;	FN# 0FH ... ENGAGE/DISENGAGE POWER MANAGEMENT		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al0f	proc	near

	call	check_apm_dev			; check validity of device and interface
	jnc	short int_15_ah53_al0f_01	; no error...
	ret					; error...(ah) already has error code updated in stack

;-----------------------------------------------;

int_15_ah53_al0f_01:
	mov	dl,not pm_engaged_by_apm	; clear power management engaged bit

	mov	dh,00000000b			; disengage power management
	mov	al,off_disengage_pm_fn		; execute disengage power management
	cmp	cx,disengage_power_management	; disengage power management ?
	jz	short int_15_ah53_al0f_08	; yes...
	cmp	cx,engage_power_management	; engage power management ?
	jnz	short int_15_ah53_al0f_05	; no...error
	mov	dh,pm_engaged_by_apm		; engage power management
	mov	al,off_engage_pm_fn		; execute engage power management

int_15_ah53_al0f_08:
	jmp	exec_apm_common			; execute the function

int_15_ah53_al0f	endp

;---------------------------------------------------------------;
;		  FN# 10H ... GET CAPABILITIES			;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al10	proc	near

	cmp	bx,system_bios_device_id	; power device ID for APM BIOS ?
	jnz	int_15_ah53_al10_03		; no...invalid device ID

	call	get_pm_capabilities		; OEM HOOK HOOK HOOK...return power management capabilities in (BL) & (CX)

	mov	ds:apm_no_of_battery_units,bl	;
	mov	ds:apm_pm_capabilities,cx	;

	mov	[ebp+off_bl_apm],bl		; return (bl)
	mov	[ebp+off_cx_apm],cx		; return (cx)

	clc					; (CF) = (NC) for no error
	ret

int_15_ah53_al10	endp

;---------------------------------------------------------------;
;	     FN# 11H ... GET/SET/DISABLE RESUME TIMER		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al11	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al11_00	; no...

	cmp	bx,system_bios_device_id	; power device ID for APM BIOS ?
	jnz	short int_15_ah53_al11_03	; no...invalid device ID

	test	word ptr ds:apm_pm_capabilities,apm_resume_timer_standby or apm_resume_timer_suspend
	jz	short int_15_ah53_al11_04	; resume timer not supported

	cmp	cl,set_resume_timer		; valid request ?
	ja	short int_15_ah53_al11_05	; error...invalid request
	jz	short int_15_ah53_al11_10	; set resume timer

	cmp	cl,disable_resume_timer		; disable resume timer ?
	jz	short int_15_ah53_al11_20	; yes...

	test	byte ptr ds:apm_misc_info,resume_timer_enabled_by_apm; resume timer enabled ?
	jz	short int_15_ah53_al11_07	; no...disabled...(CF) = (NC)

	mov	ch,ds:apm_12_resume_sec_bcd	; get seconds
	mov	dx,word ptr ds:apm_12_resume_min_bcd; get mins & hours
	mov	si,word ptr ds:apm_12_resume_day_bcd; get day & month
	mov	di,word ptr ds:apm_12_resume_year_bcd; get year & century

	mov	[ebp+off_ch_apm],ch		; return (ch)
	mov	[ebp+off_dx_apm],dx		; return (dx)
	mov	[ebp+off_si_apm],si		; return (si)
	mov	[ebp+off_di_apm],di		; return (di)

;;	clc					; set (CF) = (NC) for no error
int_15_ah53_al11_00:
	ret

;-----------------------------------------------;

int_15_ah53_al11_20:
	and	byte ptr ds:apm_misc_info,not resume_timer_enabled_by_apm; disable resume timer
						; (CF) = (NC)
	ret

;-----------------------------------------------;

int_15_ah53_al11_10:
	mov	di,[ebp+off_di_apm]		; get on entry (di) from stack
	call	check_resume_timer_data		; valid data ?
	jc	short int_15_ah53_al11_05	; error...invalid request
	mov	ds:apm_12_resume_sec_bcd,ch	; set seconds
	mov	word ptr ds:apm_12_resume_min_bcd,dx; set mins & hours
	mov	word ptr ds:apm_12_resume_day_bcd,si; set day & month
	mov	word ptr ds:apm_12_resume_year_bcd,di; set year & century
	or	byte ptr ds:apm_misc_info,resume_timer_enabled_by_apm; enable resume timer
						; (CF) = (NC)
	ret

;-----------------------------------------------;
int_15_ah53_al11_07:
	mov	ah,apm_resume_timer_disabled	; APM resume timer disabled
	jmp	apm_error_exit			;

int_15_ah53_al11_04:
int_15_ah53_al12_04::
	mov	ah,apm_12_func_not_supported	; APM special function not supported
	jmp	apm_error_exit			;

int_15_ah53_al10_03::
int_15_ah53_al11_03:
int_15_ah53_al12_03::
int_15_ah53_al13_03::
	jmp	short apm_err_code_09		; unrecognized device ID

int_15_ah53_al11_05:
int_15_ah53_al12_05::
int_15_ah53_al13_05::
	jmp	apm_err_code_0a			; parameter value out of range

int_15_ah53_al11	endp

;---------------------------------------------------------------;
;	FN# 12H ... ENABLE/DISABLE RESUME ON RING INDICATOR	;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al12	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al12_00	; no...

	cmp	bx,system_bios_device_id	; power device ID for APM BIOS ?
	jnz	short int_15_ah53_al12_03	; no...invalid device ID

	test	word ptr ds:apm_pm_capabilities,apm_resume_ring_standby or apm_resume_ring_suspend or apm_resume_pcmcia_ring_standby or apm_resume_pcmcia_ring_suspend
	jz	short int_15_ah53_al12_04	; resume on ring indicator not supported

	cmp	cx,get_status_resume_on_ring	; valid request ?
	ja	short int_15_ah53_al12_05	; error...invalid request
	jz	short int_15_ah53_al12_10	; get status request

	and	byte ptr ds:apm_misc_info,not resume_on_ring_enabled_by_apm; disable resume on ring indicator
	cmp	cx,disable_resume_on_ring	; disable resume on ring indicator ?
	jz	short int_15_ah53_al12_20	; yes...
	or	byte ptr ds:apm_misc_info,resume_on_ring_enabled_by_apm; enable resume on ring indicator
int_15_ah53_al12_20:
	call	enable_disable_resume_on_ring_indicator; OEM HOOK HOOK HOOK...enable/disable resume on ring indicator

	clc					; set (CF) = (NC) for no error
int_15_ah53_al12_00:
	ret

;-----------------------------------------------;

int_15_ah53_al12_10:
	xor	cx,cx				; set for currently disabled status
	test	byte ptr ds:apm_misc_info,resume_on_ring_enabled_by_apm; resume on ring enabled by APM ?
	jz	short int_15_ah53_al12_11	; no...(CF) = (NC)
	or	cl,00000001b			; set for currently enabled state
						; (CF) = (NC)
int_15_ah53_al12_11:
	mov	[ebp+off_cx_apm],cx		; return (cx)
	ret

int_15_ah53_al12	endp

;---------------------------------------------------------------;
;	FN# 13H ... ENABLE/DISABLE TIMER BASED REQUESTS		;
;---------------------------------------------------------------;
;	Input : As specified in function			;
;		(DS) PM bios data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error				;
;		Required returned registers are updated in stack;
;	Register destroyed : ALL GENERAL PURPOSE except (EBP)	;
;---------------------------------------------------------------;

int_15_ah53_al13	proc	near

	call	check_apm_connection		; is proper APM connection done ?
	jc	short int_15_ah53_al13_00	; no...

	cmp	bx,system_bios_device_id	; power device ID for APM BIOS ?
	jnz	short int_15_ah53_al13_03	; no...invalid device ID

	cmp	cx,get_status_timer_based_req	; valid request ?
	ja	short int_15_ah53_al13_05	; error...invalid request
	jz	short int_15_ah53_al13_10	; get status request

	and	byte ptr ds:apm_misc_info,not timer_based_req_enabled_by_apm; disable timer based req
	cmp	cx,disable_timer_based_req	; disable timer based request ?
	jz	short int_15_ah53_al13_20	; yes...
	or	byte ptr ds:apm_misc_info,timer_based_req_enabled_by_apm; enable timer based request
int_15_ah53_al13_20:
	call	enable_disable_timer_based_req	; OEM HOOK HOOK HOOK...enable/disable timer based request

	clc					; set (CF) = (NC) for no error
int_15_ah53_al13_00:
	ret

;-----------------------------------------------;

int_15_ah53_al13_10:
	xor	cx,cx				; set for currently disabled status
	test	byte ptr ds:apm_misc_info,timer_based_req_enabled_by_apm; timer based request enabled by APM ?
	jz	short int_15_ah53_al13_11	; no...(CF) = (NC)
	or	cl,00000001b			; set for currently enabled state
						; (CF) = (NC)
int_15_ah53_al13_11:
	mov	[ebp+off_cx_apm],cx		; return (cx)
	ret

int_15_ah53_al13	endp

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

apm_err_code_03	proc	near

	mov	ah,interface_not_connected	; APM driver interface not connected
	jmp	short apm_error_exit		;

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

apm_err_code_09	proc	near

	mov	ah,invalid_device_id		; unrecognized device ID
	jmp	short apm_error_exit		;

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

apm_err_code_0a	proc	near

	mov	ah,parameter_out_of_range	; parameter value out of range
	jmp	short apm_error_exit		;

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

apm_err_code_0b	proc	near

	mov	ah,interface_not_engaged	; APM interface not engaged

;-----------------------------------------------;
;	DUMMY PROCEDURE TO SUBSTITUTE '::'	;
;-----------------------------------------------;

apm_error_exit	proc	near

	mov	[ebp+off_ah_apm],ah		; return (ah)
	stc					; (CY) = 01 for error
	ret

apm_error_exit	endp
apm_err_code_0b	endp
apm_err_code_0a	endp
apm_err_code_09	endp
apm_err_code_03	endp
apm_err_code_01	endp
apm_error	endp

;---------------------------------------------------------------;
;			APM_CONNECT_LOCAL			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : (AX),(CX),(DI)			;
;---------------------------------------------------------------;

apm_connect_local	proc	near

	mov	al,not pm_engaged_by_apm	; clear power management engaged by APM info
	mov	ah,pm_engaged_by_apm		; set power management engaged by APM
	jmp	short apm_con_discon		;

apm_connect_local	endp

;---------------------------------------------------------------;
;		      APM_DISCONNECT_LOCAL			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : (AX),(CX),(DI)			;
;---------------------------------------------------------------;

apm_disconnect_local	proc	near

	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; APM v1.0 ?
	jnz	short apm_disconnect_local_00	; no...
	ret

apm_disconnect_local_00:
	mov	al,not pm_engaged_by_apm	; clear power management engaged by APM info
	mov	ah,00000000b			; set power management disengaged by APM
	jmp	short apm_con_discon		;

apm_disconnect_local	endp

;---------------------------------------------------------------;
;			  APM_CON_DISCON			;
;---------------------------------------------------------------;
;	input : (al) to be ANDed to dev state			;
;		(ah) to be ORed to dev state			;
;	Output: NONE						;
;	Register destroyed : (AL),(CX),(DI)			;
;---------------------------------------------------------------;

apm_con_discon	proc	near

	mov	cx,no_of_total_dev_v11 * no_of_units_for_each_dev; (cx) = total no. of device info bytes
	mov	di,apm_state			; (di) = APM device state pointer

apm_con_discon_02:
	test	byte ptr [di],apm_dev		; APM device ?
	jz	short apm_con_discon_01		; no...
	and	[di],al				;
	or	[di],ah				;
apm_con_discon_01:
	inc	di				; points to next device/unit
	loop	apm_con_discon_02		;
	mov	al,ds:apm_state			;
	call	set_rom_apm_state		; update ROM_APM_STATE
	ret

apm_con_discon	endp

;---------------------------------------------------------------;
;			   EXEC_APM_COMMON			;
;---------------------------------------------------------------;
;	Input : (DL) to be ANDed to dev state...not required for;
;					      APM function# 0Ch	;
;		(DH) to be ORed to dev state...not required for	;
;					      APM function# 0Ch	;
;		(AL) offeset for function exec			;
;		(BH) device #					;
;		(BL) unit #					;
;	Output: (CY) = 00 for no error				;
;		(CY) = 01 for error & error code in (AH) updated;
;				      in stack.			;
;			  For no error & APM FN# 0Ch (Get power	;
;			  state), (AX) will contain power state	;
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
;			  HANDLE_APM_DEV			;
;---------------------------------------------------------------;
;	Input : (DL) to be ANDed to dev state...not required for;
;					      APM function# 0Ch	;
;		(DH) to be ORed to dev state...not required for	;
;					      APM function# 0Ch	;
;		(SI) offeset for function exec			;
;		(BH) device #					;
;		(BL) unit #, 0ffh means all units		;
;	Output: (CY) = 00 for no error				;
;		(CY) = 01 for error & error code in (AH) updated;
;				      in stack.			;
;			  For no error & APM FN# 0Ch (Get power	;
;			  state), (AX) will contain power state	;
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
	cmp	ch,apm_func_0c			; get power state function ?
	jnz	short handle_apm_dev_04		; no...
handle_apm_dev_11:
	and	ax,apm_dev_state		; consider the device state part only for function # 0Ch
	clc					; (cy) = 00 for no error
	ret

handle_apm_dev_04:
	call	update_apm_global		; update global
	clc					; (cy) = 00 for no error
handle_apm_dev_01:
	ret

handle_apm_dev_00:
	cmp	ch,apm_func_07			; set power state function ?
	jnz	short handle_apm_dev_03		; no...ignore the error

	mov	ah,unable_to_enter_req_state	; unable to enter requested state
	jmp	apm_error_exit			;

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
;			  For no error & APM FN# 0Ch (Get power	;
;			  state), (AX) will contain power state	;
;	Register destroyed : (AX)				;
;---------------------------------------------------------------;

verify_apm_unit	proc	near

	cmp	bl,0ffh				; all units ?
	jz	short verify_apm_unit_00	; yes...
	cmp	bl,no_of_units_for_each_dev	; valid unit # ?
	jb	short verify_apm_unit_00	; yes...
	xor	bl,bl				; set the unit # to 00
verify_apm_unit_00:
	push	bx				;
	mov	al,[di]				; for all units, consider unit # 00
	cmp	bl,0ffh				; all units ?
	jz	short verify_apm_unit_03	; yes...
	xor	bh,bh				; (bx) = unit #
	mov	al,[di+bx]			;
verify_apm_unit_03:
	pop	bx				;
	cmp	ch,apm_func_0c			; get power state function ?
	jz	short verify_apm_unit_30	; yes...

;-----------------------------------------------;
;	   SET POWER STATE (FN# 07h)		;
;   ENABLE/DISABLE POWER MANAGEMENT (FN# 08h)	;
;ENABLE/DISABLE DEVICE POWER MANAGEMENT (FN# 0Dh)
;  ENGAGE/DISENGAGE POWER MANAGEMENT (FN# 0Fh)	;
;-----------------------------------------------;

	cmp	ch,apm_func_08			; enable/disable power management function ?
	jz	short verify_apm_unit_09	; yes...
	cmp	ch,apm_func_0d			; enable/disable device power management function ?
	jz	short verify_apm_unit_09	; yes...

;-----------------------------------------------;
;     FOR CHICAGO 'pm_enabled_by_apm' CHECK	;
;	   HAS BEEN REMOVED FOR FN# 0Fh		;
;-----------------------------------------------;
;						;
;	cmp	ch,apm_func_0f			; engage/disengage power management ?
;	jz	short verify_apm_unit_07	; yes...
;	test	al,pm_enabled_by_apm		; power management enabled by APM for this dev ?
;	jz	short verify_apm_unit_01	; no...
;						;
;-----------------------------------------------;
;      'pm_enabled_by_apm' CHECK IS BROUGHT	;
;	BACK ON 122895 TO SUPPORT HCT TEST	;
;	FOR APM v1.2 & APPARENTLY IT SEEMS	;
;	WINDOWS 95 HAS CORRECTED THE BUG	;
;-----------------------------------------------;

	test	al,pm_enabled_by_apm		; power management enabled by APM for this dev ?
	jz	short verify_apm_unit_01	; no...
	cmp	ch,apm_func_0f			; engage/disengage power management ?
	jz	short verify_apm_unit_07	; yes...
						;
;-----------------------------------------------;

verify_apm_unit_09:
	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; APM v1.0 ?
	jz	short verify_apm_unit_07	; yes...
	test	al,pm_engaged_by_apm		; power management engaged ?
	jz	short verify_apm_unit_06	; no...

verify_apm_unit_07:
	or	sp,sp				; set (NZF) so that call goes to CSS module
	clc					; set (CY) = 00 for no error
	ret

;-----------------------------------------------;

verify_apm_unit_01:
check_apm_dev_01::
	jmp	apm_err_code_01			; power management disabled

verify_apm_unit_06:
	jmp	apm_err_code_0b			; interface not engaged

verify_apm_unit_08:
check_apm_dev_03::
	jmp	apm_err_code_09			; unrecognized device ID

;-----------------------------------------------;
;	   GET POWER STATE (FN# 0Ch)		;
;-----------------------------------------------;

verify_apm_unit_30:
	test	al,pm_enabled_by_apm		; power management enabled by APM for this dev ?
	jz	short verify_apm_unit_01	; no...
	test	al,apm_fn0c_enabled		; function 0Ch enabled for this class ?
	jz	short verify_apm_unit_08	; no...
	test	al,pm_engaged_by_apm		; power management engaged ?
	jz	short verify_apm_unit_07	; no...power state available at chipset module
	and	al,apm_dev_state		;
	xor	ah,ah				; (CY) = 00 and (ZF) set
	ret

verify_apm_unit	endp

;---------------------------------------------------------------;
;			   CHECK_APM_DEV			;
;---------------------------------------------------------------;
;	Input : (BH) device #					;
;		(BL) unit #					;
;		(DS) PM BIOS data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error & error code in (AH) updated	;
;				    in stack.			;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

check_apm_dev	proc	near

	test	al,[ebp+off_bp_apm]		; is proper APM connection done ?
	jz	short check_apm_dev_00		; no...

;---------------------------------------------------------------;
;			CHECK_APM_DEV_FN0C			;
;---------------------------------------------------------------;
;	Input : (BH) device #					;
;		(BL) unit #					;
;		(DS) PM BIOS data segment			;
;		(AL) APM_CONNECTION_INFO			;
;	Output: (CY) 00 for no error				;
;		(CY) 01 for error & (ah) has error code		;
;	Register destroyed : (AH) for error			;
;---------------------------------------------------------------;

check_apm_dev_fn0c	proc	near

	test	al,apm_bios_power_management_disabled; APM BIOS power management disabled ?
	jnz	short check_apm_dev_01		; yes...
	test	al,apm_bios_active_ver_above_v10; active APM v1.0 ?
	jnz	short check_apm_dev_10		; no...v1.1
	cmp	bh,serial_port_device_id	; valid device ID ?

check_apm_dev_11:
	ja	short check_apm_dev_03		; no...

check_apm_dev_02:
	clc					; set (CY) = 00 for no error
	ret

check_apm_dev_10:
	cmp	bh,pcmcia_socket_device_id	; valid device ID ?
	jmp	short check_apm_dev_11		;

;-----------------------------------------------;

check_apm_dev_00::
	jmp	apm_err_code_03			; interface not connected

check_apm_dev_fn0c	endp
check_apm_dev	endp

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

	mov	al,no_of_total_dev_v11		; total # of device supported
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
	test	byte ptr [di+bx],apm_dev	; APM device ?
	jz	short cntrl_dev_class_04	; no...
	cmp	ch,apm_func_08			; enable/disable power mgt func ?
	jz	short cntrl_dev_class_11	; yes...
	cmp	ch,apm_func_0d			; enable/disable dev power mgt func ?
	jz	short cntrl_dev_class_11	; yes...

;-----------------------------------------------;
;     FOR CHICAGO 'pm_enabled_by_apm' CHECK	;
;	   HAS BEEN REMOVED FOR FN# 0Fh		;
;-----------------------------------------------;
;						;
;	cmp	ch,apm_func_0f			; engage/disengage power mgt ?
;	jz	short cntrl_dev_class_05	; yes...
;	test	byte ptr [di+bx],pm_enabled_by_apm; power mgt enabled by APM for this dev ?
;	jz	short cntrl_dev_class_04	; no...
;						;
;-----------------------------------------------;
;      'pm_enabled_by_apm' CHECK IS BROUGHT	;
;	BACK ON 122895 TO SUPPORT HCT TEST	;
;	FOR APM v1.2 & APPARENTLY IT SEEMS	;
;	WINDOWS 95 HAS CORRECTED THE BUG	;
;-----------------------------------------------;

	test	byte ptr [di+bx],pm_enabled_by_apm; power mgt enabled by APM for this dev ?
	jz	short cntrl_dev_class_04	; no...
	cmp	ch,apm_func_0f			; engage/disengage power mgt ?
	jz	short cntrl_dev_class_05	; yes...

;-----------------------------------------------;

cntrl_dev_class_11:
	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; APM v1.0 ?
	jz	short cntrl_dev_class_05	; yes...
	test	byte ptr [di+bx],pm_engaged_by_apm; power mgt engaged ?
	jz	short cntrl_dev_class_04	;
cntrl_dev_class_05:
	and	[di+bx],dl			; clear the required bits
	or	[di+bx],dh			; engage/disengage power management for the unit
cntrl_dev_class_04:
	inc	bx				; next unit#
	dec	cl				; decrement # of units
	jnz	short cntrl_dev_class_06	;
	pop	cx				;
	ret

cntrl_dev_class	endp

;---------------------------------------------------------------;
;			ADD_DEL_V11_APM_DEV			;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : (AX),(CX),(DI)			;
;---------------------------------------------------------------;

add_del_v11_apm_dev	proc	near

	mov	di,apm_state			;
	add	di,apm_net_adapter_state	; (di) = pointer to network adapter state
	mov	cx,(no_of_total_dev_v11 - no_of_total_dev_v10) * no_of_units_for_each_dev

	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; APM v1.0 ?
	jz	short del_v11_apm_dev		; yes...

;-----------------------------------------------;

	test	byte ptr [di],apm_dev		; is network adapter & pcmcia socket already apm device ?
	jnz	short add_v11_apm_dev_00	; yes...exit

	mov	al,notify_add_v11_apm_dev	; notify chipset specific module for new APM device
	call	css_entry_std			;

add_v11_apm_dev_01:
	or	byte ptr [di],apm_dev or pm_enabled_by_apm or pm_engaged_by_apm
	inc	di				; points to next device/unit
	loop	add_v11_apm_dev_01		;

add_v11_apm_dev_00:
	ret

;-----------------------------------------------;

del_v11_apm_dev:
	test	byte ptr [di],apm_dev		; is network adapter & pcmcia socket already apm device ?
	jz	short del_v11_apm_dev_00	; no...exit

	mov	al,notify_del_v11_apm_dev	; notify chipset specific module for deleting v1.1 APM device
	call	css_entry_std			;

del_v11_apm_dev_01:
	and	byte ptr [di],not (apm_dev or pm_enabled_by_apm or pm_engaged_by_apm)
	inc	di				; points to next device/unit
	loop	del_v11_apm_dev_01		;

del_v11_apm_dev_00:
	ret

add_del_v11_apm_dev	endp

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
;			CHECK_RESUME_TIMER_DATA			;
;---------------------------------------------------------------;
;	Input : (CH) seconds in BCD				;
;		(DH) hours in BCD				;
;		(DL) minutes in BCD				;
;		(SI) day in BCD					;
;		(SI)+ month in BCD				;
;		(DI) year in BCD				;
;		(DI)+ century in BCD				;
;	Output: (CF) (CY) error...date/time not valid		;
;		(CF) (NC) successful...date/time valid		;
;	Register destroyed : (AL)				;
;---------------------------------------------------------------;

check_resume_timer_data	proc	near

	mov	al,ch				; (al) = seconds in BCD
	call	check_apm_bcd_data		; is it BCD ?
	jc	short check_resume_timer_data_00; no...error
	cmp	al,59h				; valid seconds (0 to 59) ?
	ja	short check_resume_timer_data_00; no...error

	mov	al,dl				; (al) = minutes in BCD
	call	check_apm_bcd_data		; is it BCD ?
	jc	short check_resume_timer_data_00; no...error
	cmp	al,59h				; valid minutes (0 to 59) ?
	ja	short check_resume_timer_data_00; no...error

	mov	al,dh				; (al) = hours in BCD
	call	check_apm_bcd_data		; is it BCD ?
	jc	short check_resume_timer_data_00; no...error
	cmp	al,23h				; valid hours (0 to 23) ?
	ja	short check_resume_timer_data_00; no...error

	mov	ax,si				; (al) = day in BCD
						; (ah) = month in BCD
	call	check_apm_bcd_data		; is day in BCD ?
	jc	short check_resume_timer_data_00; no...error
	or	al,al				; valid day (1 to 31) ?
	jz	short check_resume_timer_data_00; no...error
	cmp	al,31h				; valid day (1 to 31) ?
	ja	short check_resume_timer_data_00; no...error

	mov	al,ah				; (al) = month in BCD
	call	check_apm_bcd_data		; is month in BCD ?
	jc	short check_resume_timer_data_00; no...error
	or	al,al				; valid month (1 to 12) ?
	jz	short check_resume_timer_data_00; no...error
	cmp	al,12h				; valid day (1 to 12) ?
	ja	short check_resume_timer_data_00; no...error

	mov	ax,di				; (al) = year in BCD
						; (ah) = century in BCD
	call	check_apm_bcd_data		; is year in BCD ?
	jc	short check_resume_timer_data_00; no...error
	mov	al,ah				; (al) = century in BCD
	call	check_apm_bcd_data		; is century in BCD ?
	jc	short check_resume_timer_data_00; no...error
	cmp	di,1995h			; valid year (1995 onwards...) ?
	ret					; (CF) = (CY)/(NC) set accordingly

check_resume_timer_data_00:
	stc					; (CF) = (CY) for error
	ret

check_resume_timer_data	endp

;---------------------------------------------------------------;
;			CHECK_APM_BCD_DATA			;
;---------------------------------------------------------------;
;	Input : (AL) BCD data to be checked			;
;	Output: (CF) (CY) error...data is not BCD		;
;		(CF) (NC) successful...data is BCD		;
;	Register destroyed : NONE				;
;---------------------------------------------------------------;

check_apm_bcd_data	proc	near

	push	ax				;
	and	al,00001111b			; consider lower nibble
	cmp	al,0ah				; BCD data ?
	pop	ax				;
	jae	short check_apm_bcd_data_00	; no...
	push	ax				;
	shr	al,4				; consider upper nibble
	cmp	al,0ah				;
	pop	ax				;
check_apm_bcd_data_00:
	cmc					; set (CF) properly
	ret

check_apm_bcd_data	endp

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

;;	push	ds				;
;;	push	ax				;
;;	push	bios_data_seg			;
;;	pop	ds				; (ds) = bios standard data segment (40H)
;;	mov	al,sys_info			;
;;	and	al,00110000b			; consider bits 5 & 4 only
;;	jz	short get_apm_bios_pm_status_01	; power management disabled
;;	cmp	al,00100000b			; hardware auto power management ?
;;get_apm_bios_pm_status_01:
;;	pop	ax				;
;;	pop	ds				;
;;	stc					; (CY) = 01 for APM BIOS power management disabled
;;	jz	short get_apm_bios_pm_status_00	;
;;	clc					; (CY) = 00 for APM BIOS power management enabled
;;get_apm_bios_pm_status_00:
;;	ret

	clc
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

	mov	word ptr ds:apm_bios_ver_no,0102h; set to v1.2

	mov	byte ptr ds:apm_connection_info,00000000b; no APM connection
						; APM BIOS active version set to v1.0

	mov	word ptr ds:pending_apm_event,0000h

;---------------------------------------------------------------;
;			  SET_DEV_STATE				;
;---------------------------------------------------------------;
;	Input : NONE						;
;	Output: NONE						;
;	Register destroyed : (AL),(DI)				;
;---------------------------------------------------------------;

set_dev_state	proc	near

	pushad					;
	call	get_pm_capabilities		; OEM HOOK HOOK HOOK...return power management capabilities in (BL) & (CX)
	mov	ds:apm_no_of_battery_units,bl	;
	mov	ds:apm_pm_capabilities,cx	;
	popad					;

	mov	byte ptr ds:apm_misc_info,00000100b; resume timer disabled by APM
						; resume on ring disabled by APM
						; timer based req is enabled by APM
;-----------------------------------------------;

	push	cx				;
	mov	cx,no_of_total_dev_v10 * no_of_units_for_each_dev; (cx) = total # of device info bytes
	mov	di,apm_state			; (di) = APM device state pointer
	mov	al,apm_dev or pm_engaged_by_apm or pm_enabled_by_apm
set_dev_state_00:
	mov	[di],al				; set the device/unit state
	inc	di				; points to next device/unit
	loop	set_dev_state_00		;

	mov	cx,(no_of_total_dev_v11 - no_of_total_dev_v10) * no_of_units_for_each_dev
	test	byte ptr ds:apm_connection_info,apm_bios_active_ver_above_v10; APM v1.0 ?
	jnz	short set_dev_state_01		; no...
	xor	al,al				; clear device state
set_dev_state_01:
	mov	[di],al				; set the device/unit state
	inc	di				; points to next device/unit
	loop	set_dev_state_01		;
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
