	page	,132
	title	OEM RUNTIME HOOKS
;-----------------------------------------------------------------------;
; This file is derived from RUNTIME.ASM and NRUNTIME.ASM files.		;
; ======================== NOTE === NOTE === NOTE =====================	;
; If the routine name in this file starts with "OEM_", then this routine;
; is called from the corresponding generic chipset hook (in RUNTIME.ASM	;
; or NRUNTIME.ASM file). For example, OEM_SET_INT_40_FLAG routine is	;
; called from SET_INT_40_FLAG hook in RUNTIME.ASM file.			;
; ======================== NOTE === NOTE === NOTE =====================	;
; If the routine name in this file does not start with "OEM_", then this;
; routine is called directly from Core file. For example, NMI_PARITY_CHECK
; is called from core file INT2.ASM.					;
;-----------------------------------------------------------------------;
; NOTE: Do not destroy EBP,FS,GS,SS,DS,ES unless otherwise specified.	;
;-----------------------------------------------------------------------;
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
	include mbiosmac.mac
	include mbiosequ.equ
	include cf.equ
	include setupequ.ext
	include	makeflag.equ
;---------------------------------------;
	extrn	_high_speed_chipset:byte
	extrn	_led_on_8042	:byte
	extrn	_cache_on_chipset:byte
	extrn	_ctrl_alt_plus	:byte
	extrn	_low_speed_chipset:byte
	extrn	_led_off_8042	:byte
	extrn	_cache_off_chipset:byte
	extrn	_ctrl_alt_minus	:byte
	extrn	_ctrl_alt_setup	:byte
	extrn   enable_internal_cache:near
	extrn   disable_internal_cache:near
	extrn   enable_l1_cache:near
	extrn   disable_l1_cache:near
	extrn   flush_internal_cache  :near
	extrn   enable_l2_cache:near
	extrn   disable_l2_cache:near
	extrn	low_speed:near
	extrn	high_speed:near
	extrn   check_cmos_data:near
	extrn   cmos_data_in:near
	extrn   cmos_data_out:near
	extrn   cmos_data_in_x:near
	extrn   cmos_data_out_x:near
	extrn	enable_disable_nmi:near
	extrn   e000_read_rom_write_x:near
	extrn   f000_read_rom_write_x:near
;---------------------------------------;
cgroup  group   _text
_text   segment word    public  'CODE'
	assume  cs:cgroup
.486p
;---------------------------------------;
	public	_OEM_RUNTIME_STARTS
_OEM_RUNTIME_STARTS	 label	 byte	; marks start of module
;-----------------------------------------------------------------------;
;				INT-15.ASM MODULE			;
; this routine is called from SPECIAL_INT_15 in NRUNTIME.ASM.		;
; support any OEM specific int-15 function if any. if you do not have	;
; any OEM special func, simply return control to SPECIAL_INT_15 by RET.	;
; otherwise balance stack, implement the OEM special functions and	;
; return control to caller of INT-15 by IRET or RET 2.			;
;=======================================================================;
; EXAMPLE:  INT15 function to GATE-A20 support.				;
;	    input :	(ah)	24h					;
;			(al)	03h					;
;	    output:	(ah)	return code				;
;				00h  successful				;
;				86h  function not supported		;
;			(NC)	successful				;
;			(CY)	unsuccessful				;
;			if successful					;
;			(bx)	bit 0..0 = GateA20 not supported on 8042;
;				       1 = GateA20 supported on 8042	;
;				bit 1..0 = GateA20 not supported with	;
;					   bit-1 of I/O port 92H	;
;				       1 = GateA20 supported with bit-1	;
;					   of I/O port 92H		;
; Let us assume the chipset concerned has the support for GateA20 thru'	;
; bit-1 of I/O port 92H. In this case OEM_SPECIAL_INT_15 shoule be like	;
; as follows:								;
;									;
; oem_special_int_15:							;
;	cmp	ah,24h			; func# 24h ?			;
;	jnz	si15_00			; no..				;
;	cmp	al,03h			; subfunc# 03h ?		;
;	jnz	si15_00			; no..				;
;	POP	BX			; ===VERY VERY IMPORTANT===	;
;		; discard return address to SPECIAL_INT_15 routine	;
;	POP	BX			; ===VERY VERY IMPORTANT===	;
;		; discard return address to BIOS INT15 ISR		;
;	mov	bx,02h			; bit 1 = 1..GateA20 thru' bit-1;
;					; of I/O port 92H		;
;	sti				; enable interrupt		;
;	xor	ah,ah			; AH = 00..successful		;
;					; NC..successful		;
; x??	proc	far							;
;	ret	0002							;
; x??	endp								;
;									;
; si15_00:								;
;	ret								;
;-----------------------------------------------------------------------;
;			OEM_SPECIAL_INT_15				;
;-----------------------------------------------------------------------;
;  input : 								;
;	AH	function#						;
;	stack	available						;
;  register usage : do not destroy any register other than the registers;
;		    having output values.				;
;-----------------------------------------------------------------------;
	public	oem_special_int_15
oem_special_int_15:
	cmp	ax,2403h
        jnz     si15_00                 ; no..                          ;

        POP     BX                      ; ===VERY VERY IMPORTANT===     ;
; discard return address to SPECIAL_INT_15 routine      ;
        POP     BX                      ; ===VERY VERY IMPORTANT===     ;
; discard return address to BIOS INT15 ISR              ;
        mov     bx,01h                  ; bit 0 = 1..GateA20 thru keyboard
        sti                             ; enable interrupt              ;
        xor     ah,ah                   ; AH = 00..successful           ;
                                        ; NC..successful                ;
x??     proc    far                                                     ;
        ret     0002                                                    ;
x??     endp                                                            ;
                                                                       ;
si15_00:                                                              ;
	ret
;-----------------------------------------------------------------------;
;			NMI_PARITY_CHECK				;
;-----------------------------------------------------------------------;
; this routine is always called whenever an INT-2 (NMI) is generated.	;
; this routine can handle parity error by itself (according to the way	;
; it wants to handle NMI) or it can tell BIOS to handle NMI.		;
; input :								;
;	AL	[port 61h] at the time of generation of this NMI	;
;	stack	available						;
;	NMI	disabled						;
; output:								;
;	NC	BIOS will handle the NMI as usual			;
;	CY	this routine handles the NMI. when BIOS gets back control
;		from this routine, BIOS will simply go back to caller.	;
; register usage : do not destroy any register				;
;-----------------------------------------------------------------------;
	public	nmi_parity_check
nmi_parity_check:
	ret
;-----------------------------------------------------------------------;
;			DISPLAY_PARITY_ADDRESS				;
;-----------------------------------------------------------------------;
; this routine is called when an NMI is generated and NMI_PARITY_CHECK	;
; hook returns NC and parity checking is enabled. this routine is to	;
; display the address at which parity error happened. if you do not have;
; any special action simply return. some chipset latches the address of	;
; parity error. in this case, write the routine to display the parity	;
; error address on the screen and then return. on return from this	;
; routine, system will be HALTED.					;
; input :								;
;	none								;
;	stack	available						;
; register usage : can destroy any register except SS, SP		;
;-----------------------------------------------------------------------;
	public	display_parity_address
display_parity_address:
	ret
;-----------------------------------------------------------------------;
;		OEM_PREPARE_CHIPSET_FOR_FLASH_PROGRAMMING		;
;-----------------------------------------------------------------------;
; This routine is called from PREPARE_CHIPSET_FOR_FLASH_PROGRAMMING	;
; routine before flash programming. This function is used by Flash	;
; program utility AMIFLASH.						;
; This routine is called from PREPARE_CHIPSET_FOR_FLASH_PROGRAMMING	;
; after									;
; 1. external cache and internal cache are disabled.			;
; 2. power management is disabled.					;
; 3. all shadow rams are disabled.					;
; 4. E000 and F000 ROMand ROMCS are enabled.				;
; input :								;
;	none								;
;	stack	available						;
; output:								;
;	none								;
; register usage : Do not destroy any register				;
;-----------------------------------------------------------------------;
	public	oem_prepare_chipset_for_flash_programming
oem_prepare_chipset_for_flash_programming:
	ret
;-----------------------------------------------------------------------;
;			OEM_POWER_ON_INIT				;
;-----------------------------------------------------------------------;
;  this routine is invoked from POWER_ON_INIT routine which get control	;
;  just after bios gets control at F000:FFF0 in shadow ram.		;
;  NOTHING IS DEFINED (except EDX) ON ENTRY TO THIS ROUTINE.		;
;  input :								;
;	edx	cpu id if hard reset					;
;	ss	= cs							;
;	stack	not available						;
;  output:								;
;	none								;
;  register usage : can destroy any register except EDX, SS		;
;  Note: This routine can be used to implement any OEM specific stuff at;
;	 power on like resume from 5V suspend, etc.			;
;	 This routine should go back to OEM_POWER_ON_INIT_END label	;
;	 using a JMP instruction.					;
;-----------------------------------------------------------------------;
	public	oem_power_on_init
	extrn	oem_power_on_init_end:near
oem_power_on_init:
	jmp	oem_power_on_init_end
;-----------------------------------------------------------------------;
;			OEM_DISABLE_ALL_CACHE				;
;-----------------------------------------------------------------------;
; check_point		: 05						;
; this routine must disable cache at this time, if system has external  ;
; cache.                                                                ;
; input :                                                               ;
;       stack   available                                               ;
; register usage : can destroy any register except  DS, ES, EBP         ;
; 1. this routine should disable both internal and external cache.      ;
;-----------------------------------------------------------------------;
	extrn	generate_hard_reset:near
	extrn	get_processor_info:near
	extrn	copy_control_to_ram:near
	extrn	f000_read_rom_write_x:near
	public	oem_disable_all_cache
oem_disable_all_cache:
	ret
;-----------------------------------------------------------------------;
;			GET_HD_STANDBY_VALUE_PM				;
;-----------------------------------------------------------------------;
; check point		: 91						;
; this routine is called from hard_disk_setup during POST from HI.ASM.	;
; is used to return standby timer value for primary master hard disk.	;
; input :								;
;	SS	0030H							;
;	DS	0040H							;
;	ES	0000H							;
;	stack	available						;
; output:								;
;	al	hard disk standby timer value in unit of 5sec		;
;		NOTE: a zero (00) value indicates that standby feature	;
;		is disabled.						;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: the following may need to be modified to return the timer value	;
; properly according to setup option in case cmos register is used in	;
; setup to make this timer value user selectable.			;
;-----------------------------------------------------------------------;
;			GET_HD_STANDBY_VALUE_PS				;
;-----------------------------------------------------------------------;
; check point		: 91						;
; this routine is called from hard_disk_setup during POST from HI.ASM.	;
; is used to return standby timer value for primary slave hard disk.	;
; input :								;
;	SS	0030H							;
;	DS	0040H							;
;	ES	0000H							;
;	stack	available						;
; output:								;
;	al	hard disk standby timer value in unit of 5sec		;
;		NOTE: a zero (00) value indicates that standby feature	;
;		is disabled.						;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: the following may need to be modified to return the timer value	;
; properly according to setup option in case cmos register is used in	;
; setup to make this timer value user selectable.			;
;-----------------------------------------------------------------------;
;			GET_HD_STANDBY_VALUE_SM				;
;-----------------------------------------------------------------------;
; check point		: 91						;
; this routine is called from hard_disk_setup during POST from HI.ASM.	;
; is used to return standby timer value for secondary master hard disk.	;
; input :								;
;	SS	0030H							;
;	DS	0040H							;
;	ES	0000H							;
;	stack	available						;
; output:								;
;	al	hard disk standby timer value in unit of 5sec		;
;		NOTE: a zero (00) value indicates that standby feature	;
;		is disabled.						;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: the following may need to be modified to return the timer value	;
; properly according to setup option in case cmos register is used in	;
; setup to make this timer value user selectable.			;
;-----------------------------------------------------------------------;
;			GET_HD_STANDBY_VALUE_SS				;
;-----------------------------------------------------------------------;
; check point		: 91						;
; this routine is called from hard_disk_setup during POST from HI.ASM.	;
; is used to return standby timer value for secondary slave hard disk.	;
; input :								;
;	SS	0030H							;
;	DS	0040H							;
;	ES	0000H							;
;	stack	available						;
; output:								;
;	al	hard disk standby timer value in unit of 5sec		;
;		NOTE: a zero (00) value indicates that standby feature	;
;		is disabled.						;
; register usage : can destroy any register except EBP,DS,ES,FS,GS	;
; NOTE: the following may need to be modified to return the timer value	;
; properly according to setup option in case cmos register is used in	;
; setup to make this timer value user selectable.			;
;-----------------------------------------------------------------------;
	public	get_hd_standby_value_pm
	public	get_hd_standby_value_ps
	public	get_hd_standby_value_sm
	public	get_hd_standby_value_ss
get_hd_standby_value_pm:
get_hd_standby_value_ps:
get_hd_standby_value_sm:
get_hd_standby_value_ss:
COMMENT ~
IF	MKF_GPC_SUPPORT 		; If GPC support, use drive time-out
	mov	al,Q_POWER_MANAGEMENT
	call	check_cmos_data
	jz	short all_timers_disabled; AL = 00 already
	mov	al,Q_IDE_TIME_OUT
	call	check_cmos_data		; AL = time out value in Minutes
	mov	ah,12
	mul	ah			; AL = time out value in unit of 5sec
all_timers_disabled:
ELSE
	mov	al,00h			; Disabled, e.g. Use timers for NB
ENDIF
~
        xor     al,al
	ret
;-----------------------------------------------------------------------;
;			LPT SUPPORT ROUTINES				;
;-----------------------------------------------------------------------;
;			GET_LPT_IRQ_INFO    				;
;			SET_LPT_IRQ              			;
;			GET_LPT_ECP_DMA_INFO   				;
;			SET_LPT_ECP_DMA_CHANNEL				;
;-----------------------------------------------------------------------;
; - GET_LPT_IRQ_INFO and GET_LPT_ECP_DMA_INFO: The I/O module calls	;
;   these routines to determine if the parallel port IRQ/DMA channel	;
;   is routed by the I/O chip or by the system chipset.			;
;									;
;   If I/O chipset handles the IRQ/DMA routing, clear the carry flag	;
;   and return.								;
;									;
;   If the routing of the parallel port IRQ/DMA channel is handled	;
;   by the system chipset, set the carry flag and return the requested	;
;   IRQ/DMA information.						;
;									;
; - SET_LPT_IRQ and SET_LPT_ECP_DMA_CHANNEL are called only if IRQ or	;
;   ECP DMA is to be routed by system chipset.				;
;-----------------------------------------------------------------------;
;			GET_LPT_IRQ_INFO        			;
;-----------------------------------------------------------------------;
; This routine returns the IRQ routing information of the parallel port	;
; input :								;
;	none								;
;	stack	available						;
; output:								;
;	CF = Clear - LPT IRQ is routed by I/O chipset			;
;	   = Set   - LPT IRQ is routed by system chipset		;
;									;
;	If LPT IRQ is routed by the system chipset then also return:	;
;	   BX = Bit-mask of LPT IRQ currently used.			;
;	   DX = Bit-mask of LPT IRQ available.				;
;									;
; register usage : Do not destroy any register except BX, DX		;
;									;
; Examples:								;
; 1. If IRQ 7 is routed by system chipset with IRQ 5 & IRQ 7 available, ;
;    then return: BX = 0000000010000000b, DX = 0000000010100000b, and	;
;    CF = 1.								;
; 2. If IRQ is routed by I/O chipset, then just clear CF and return.	;
;-----------------------------------------------------------------------;
	public	get_lpt_irq_info
get_lpt_irq_info:
	clc			; LPT IRQ is routed by I/O chipset.
	ret
;-----------------------------------------------------------------------;
;			SET_LPT_IRQ					;
;-----------------------------------------------------------------------;
; This routine programs the system chipset to route the parallel port	;
; IRQ to the channel given in AL.					;
; input :								;
;	AL = IRQ channel number (0 for None)				;
;	stack	available						;
; output:								;
;	none								;
; register usage : Do not destroy any register				;
;									;
; Note: This routine is called only if LPT IRQ is to be routed by	;
;	system chipset.							;
;-----------------------------------------------------------------------;
	public	set_lpt_irq
set_lpt_irq:
	ret
;-----------------------------------------------------------------------;
;			GET_LPT_ECP_DMA_INFO        			;
;-----------------------------------------------------------------------;
; This routine returns the ECP DMA routing information of the parallel	;
; port.									;
; input :								;
;	none								;
;	stack	available						;
; output:								;
;	CF = Clear - ECP DMA is routed by I/O chipset			;
;	   = Set   - ECP DMA is routed by system chipset		;
;									;
;	If ECP DMA is routed by the system chipset then also return:	;
;	   CL = Bit-mask of ECP DMA channel currently used.		;
;	   DL = Bit-mask of DMA channels available.			;
;									;
; register usage : Do not destroy any register except CL and DL		;
;									;
; Examples:								;
; 1. If ECP DMA channel 3 is routed by system chipset with channels 1	;
;    and 3 available, then return: CL = 00001000b, DL = 00001010b	;
;    and CF = 1.							;
; 2. If ECP DMA is routed by I/O chipset, then just clear CF and return.;
;-----------------------------------------------------------------------;
	public	get_lpt_ecp_dma_info
get_lpt_ecp_dma_info:
	clc			; ECP DMA is routed by I/O chipset.
	ret
;-----------------------------------------------------------------------;
;			SET_LPT_ECP_DMA_CHANNEL				;
;-----------------------------------------------------------------------;
; This routine programs the system chipset to route the papallel port	;
; ECP DMA to the channel given in AL.					;
; input :								;
;	AL = DMA channel number (0-7, 4 for None)			;
;	AH = Previous DMA channel number (0-7, 4 for None)		;
;	stack	available						;
; output:								;
;	none								;
; register usage : Do not destroy any register				;
;									;
; Note: This routine is called only if LPT IRQ is to be routed by	;
;	system chipset.							;
;-----------------------------------------------------------------------;
	public	set_lpt_ecp_dma_channel
set_lpt_ecp_dma_channel:
	ret
;-----------------------------------------------------------------------;
;			OEM_SET_INT_40_FLAG				;
;			OEM_CLEAR_INT_40_FLAG				;
;			OEM_SET_INT_13_FLAG				;
;			OEM_CLEAR_INT_13_FLAG				;
; These SET routines are called from the respective INT ISR at the	;
; start of ISR. The SET routines can be used to implement any OEM	;
; specific requirements.						;
; These CLEAR routines are called from the respective INT ISR at the	;
; end of ISR. The CLEAR routines can be used to clear the status which	;
; has been set in the SET routines.					;
; Input of SET routines:						;
;	As input to the respective INT ISR				;
; Input of CLEAR routines:						;
;	As output of the respective INT ISR				;
; Register Usage : Do not destroy any register including Flags		;
;									;
; EXAMPLE : This will give the idea of how these SET and CLEAR routines	;
; are invoked.								;
;									;
; The following code is in the respective INT ISR routine e.g. INT_40	;
; in FD.ASM file.							;
;									;
; INT_XX:								;
;	CALL	SET_INT_XX_FLAG		; in RUNTIME.ASM		;
; ; execute INT-XX ISR							;
;	|	|	|	|	; Start of INT-XX ISR		;
;	|	|	|	|					;
;	|	|	|	|					;
;	|	|	|	|					;
;	|	|	|	|					;
;	|	|	|	|					;
; ; INT-XX ISR has been executed					;
; ; all registers & flag have the value as output of INT-XX ISR		;
;	CALL	CLEAR_INT_XX_FLAG	; in RUNTIME.ASM		;
;	IRET								;
;									;
; The RUNTIME.ASM has the SET and CLEAR routines as follows:		;
;									;
; SET_INT_XX_FLAG:							;
;	CALL	OEM_SET_INT_XX_FLAG					;
;	RET								;
;									;
; CLEAR_INT_XX_FLAG:							;
;	CALL	OEM_CLEAR_INT_XX_FLAG					;
;	RET								;
;									;
; NOTE: If anything specific needs to be implemented in SET routines and;
; the implementation needs to return the control back to the caller of	;
; INT-XX then stack must be balanced properly before returning the	;
; control back to the caller of INT-XX.					;
;-----------------------------------------------------------------------;
        public  oem_set_int_40_flag
oem_set_int_40_flag:
	ret
;-----------------------------------------------------------------------;
        public  oem_clear_int_40_flag
oem_clear_int_40_flag:
	ret
;-----------------------------------------------------------------------;
        public  oem_set_int_13_flag
oem_set_int_13_flag:
	ret
;-----------------------------------------------------------------------;
        public  oem_clear_int_13_flag
oem_clear_int_13_flag:
	ret
bios_revision_string	db	'BIOS version 1.0',0
	public	show_bios_revision
show_bios_revision:
	push	cs
	pop	dx
	mov	bx,offset bios_revision_string		       
	ret
	
;-----------------------------------------------------------------------;
;*****************************************************************;
;*****************************************************************;
;**                                                             **;
;**     (C)Copyright 1985-1995, American Megatrends Inc.        **;
;**                                                             **;
;**                     All Rights Reserved.                    **;
;**                                                             **;
;**             6145-F, Northbelt Parkway, Norcross,            **;
;**                                                             **;
;**             Georgia - 30071, USA. Phone-(770)-263-8181.     **;
;**                                                             **;
;*****************************************************************;
;*****************************************************************;
;-----------------------------------------------------------------------;
;			CHECK_CONTROLLER_PRESENCE			;
;-----------------------------------------------------------------------;
; Check point	: 83, 87, 91						;
; This routine checks for the presence of concerned IDE controller and	;
; is called from the following routines:				;
; *  CHECK_PRESENCE_OF_ATAPI_DEVICES at check point 83			;
;    during the checking of ATAPI device presence at POST.		;
; *  AUTO_HD_TYPE, DETECT_HDD_CDROM at check point 87			;
;    during the auto-detection of ATA/ATAPI devices at SETUP.		;
; *  AUTO_HD_TYPE, DETECT_HDD_CDROM at check point 91			;
;    during the auto-detection of ATA/ATAPI devices at POST.		;
; input :								;
;	BX	IDE controller base address (e.g. 1F0, 170, etc.)	;
;	DH	Drive selection parameter (A0 for Master, B0 for Slave)	;
;	stack	available						;
; output:								;
;	NC	controller present					;
;	CY	controller not present					;
; register usage : Do not destroy any register.				;
;-----------------------------------------------------------------------;
	extrn	fixed_delay:near
	extrn	read_status_reg:near
	extrn	select_drive_read_status:near
	public	check_controller_presence
check_controller_presence:
	pusha
	call	select_drive_read_status; select drive and read status reg
	cmp	al,0ffh
	jz	ccp_00			; CY, controller not found
;  reading of status register return a non-FF value
	mov	cx,350			; time out 21ms (350*60us=21000us=21ms)
ccp_01:
	mov	ah,al			; save current status in AH
	push	cx
	mov	cx,04h			; 60us delay
	call	fixed_delay
	pop	cx
	call	read_status_reg		; read status register
	test	al,80h			; controller free ?
	jz	ccp_02			; yes, so controller present
;  status register return a non-FF value and controller is not free (bit7 = 1)
	or	al,ah
	and	al,11001001b		; keep bits7,6,3,0
	cmp	al,11001001b
	loopnz	ccp_01			; continue checking
	jnz	ccp_02			; bus not floating, controller present
;  bus may be floating, do R/W test on 1x6
	mov	al,dh
	push	dx
	mov	dx,bx
	add	dx,06h			; 1x6
	push	dx
	out	dx,al			; 1x6 <- drive selection parameter
	mov	cx,0004h		; 60us io delay
	call	fixed_delay
	sub	dx,04h			; 1x2
	mov	al,0ffh
	out	dx,al
	io_delay			; 1x2 <- FF
	pop	dx			; 1x6
	in	al,dx			; read 1x6
	pop	dx
	cmp	al,dh			; R/W on 1x6 successful ?
	jnz	ccp_00			; no, controller not present
ccp_02:
	clc
ccp_exit:
	popa
	ret
ccp_00:
	stc				; CY, controller not found
	jmp	short ccp_exit
;-----------------------------------------------------------------------;
;				CPU_FREQ_TABLE				;
; This table can be modified according to OEM requirement.		;
; For example, if P6 CPU is used only, which starts from 133MHz, the	;
; entries below 133MHz can be deleted which will create some space.	;
;-----------------------------------------------------------------------;
	public	cpu_freq_table
	public	cpu_freq_table_end
cpu_freq_table		label	byte
;		X * 100		X
	dw	14300,		133
	dw	17600,		166
	dw	21000,		200
	dw	24300,		233
	dw	27600,		266
	dw	31000,		300
        dw      34300,          333
	dw	36000,		350
        dw      41000,          400
	dw	46000,		450
	dw	51000,		500
	dw	56000,		550
	dw	61000,		600
cpu_freq_table_end	label	byte
;-----------------------------------------------------------------------;
;				CHANGE_SPEED				;
;-----------------------------------------------------------------------;
;  this is called from INT-9 ISR. this is in INT-9.ASM.			;
;  input :								;
;	ds	0040H							;
;	stack	available						;
;  register usage : do not destroy any register				;
;=================== NOTE ==== NOTE ==== NOTE =========================	;
;  this routine is moved here from NRUNTIME.ASM file. The generic code	;
;  of this routine takes much space so we decided to disable the generic;
;  code. If any OEM needs this generic code, then activate the generic	;
;  code.								;
;  Default implementation : <CTRL><ALT> keystrokes are not supported.	;
;  To support <CTRL><ALT> : Activate the generic code.			;
;-----------------------------------------------------------------------;
IF	MKF_CTRL_ALT			; generic code for <CTRL><ALT>
	public	change_speed		; change CPU speed/cache etc
change_speed:
	cli
	cmp	al,cgroup:_ctrl_alt_minus
	jnz	cs_1
	test	ds:byte ptr [17h],00000011b
	jz	cs_3
	call	cache_off		; <ctrl><alt><shift><->
	jmp	short cs_2
cs_3:
	call	frequency_low		; <ctrl><alt><->
	jmp	short cs_2
cs_1:
	cmp	al,cgroup:_ctrl_alt_plus
	jnz	cs_5
	test	ds:byte ptr [17h],00000011b
	jz	cs_4
	call	cache_on		; <ctrl><alt><shift><+>
	jmp	short cs_2
cs_4:
	call	frequency_high		; <ctrl><alt><->
	jmp	short cs_2
cs_5:
;---------------------------------------;
COMMENT !
;  if hot-key setup is needed, activate the following code..
	cmp	al,cgroup:_ctrl_alt_setup; hot key setup
	jnz	cs_2			; no
	test	cgroup:misc_info,hot_key_setup_bit; hot key setup enabled ?
	jz	cs_2			; no
;  verify that lower 32k of rom is present..
	push	ax
	push	es
	push	di
	push	si
	push	cx
	push	cs
	pop	es
	mov	di,offset cgroup:_bios_name; ES:DI = ptr to normal bios name
	xor	si,si			; CS:SI = ptr to name present at CS:0000h
	mov	cx,0008h		; 8bytes name
	push	si
	push	cx
	db	2eh			; segcs
	repz	cmpsb
	pop	cx
	pop	si
;;;;	jz	cs_7			; setup present in lower 32k
;;;;	mov	di,offset cgroup:_setup_name; ES:DI = ptr to compressed setup name
;;;;	db	2eh			; segcs
;;;;	repz	cmpsb
;;;;cs_7:
	pop	cx
	pop	si
	pop	di
	pop	es
	jnz	cs_0			; not present
	mov	ax,ds:word ptr [72h]
	cmp	al,'S'			; in setup ?
	jz	cs_0			; yes
	cmp	al,'H'			; in hot-key setup ?
	jz	cs_0			; yes
	cmp	ah,'P'			; in password checking ?
	jz	cs_0			; yes
	or	ax,ax
	jnz	cs_0
	mov	ds:byte ptr [72h],'h'	; indicate to invoke hot-key setup
cs_0:
	pop	ax
!
;---------------------------------------;
cs_2:
	sti
	ret
;-----------------------------------------------------------------------;
; all registers must be saved except CX. (ds) = 40h always set, this	;
; routine is also called from INT-8, INT-16, be careful about registers.;
;-----------------------------------------------------------------------;
	public	frequency_low
frequency_low:
	push	si
	push	dx
	push	ax
	mov	si,offset cgroup:_low_speed_chipset
	mov	dx,offset cgroup:low_speed
	mov	ax,2000h		; AL = 00 for low speed
					; AH = OR value, bit-5 = 1..low speed
freq_cache_common:
	call	freq_low_high_cache_on_off
freq_cache_common_exit:
	pop	ax
	pop	dx
	pop	si
	ret
;-----------------------------------------------------------------------;
	public	frequency_high
frequency_high:
	push	si
	push	dx
	push	ax
	mov	si,offset cgroup:_high_speed_chipset
	mov	dx,offset cgroup:high_speed
	mov	ax,0df01h		; AL = 01 for high speed
					; AH = AND value, bit-5 = 0..high speed
	jmp	short freq_cache_common
;-----------------------------------------------------------------------;
	public	cache_on
cache_on:
	pushad
	call	enable_l1_cache
	popad
	push	si
	push	dx
	push	ax
	mov	si,offset cgroup:_cache_on_chipset
	mov	dx,offset cgroup:enable_l2_cache
	mov	ax,1002h		; AL = 02 for cache on
					; AH = OR value, bit-4 = 1..cache on
	jmp	short freq_cache_common
;-----------------------------------------------------------------------;
	public	cache_off
cache_off:
	push	si
	push	dx
	push	ax
	mov	si,offset cgroup:_cache_off_chipset
	mov	dx,offset cgroup:disable_l2_cache
	mov	ax,0ef03h		; AL = 03 for cache off
					; AH = AND value, bit-4 = 0..cache off
	call	freq_low_high_cache_on_off
	pushad
	call	disable_l1_cache
	popad
	jmp	short freq_cache_common_exit
;-----------------------------------------------------------------------;
freq_low_high_cache_on_off:
	push	ax
	xor	cx,cx			; func not done
	cmp	cgroup:byte ptr [si],0
	jz	fc_01			; no chipset used
	call	dx
fc_01:
	mov	al,cgroup:[si+1]
	or	al,al
	jz	fc_02			; no 8042 pin used
	out	64h,al
fc_06:
	jcxz	short $+2		; i/o delay
	in	al,64h
	test	al,00000001b		; wait for o/b full
	jz	fc_06
	in	al,60h
	mov	cl,0ffh			; CX <>00..func done
fc_02:
	mov	dx,cgroup:[si+2]
	or	dx,dx
	jz	fc_03			; no external port used
	in	al,dx
	jcxz	short $+2		; i/o delay
	jcxz	short $+2		; i/o delay
	and	al,cgroup:[si+5]
	or	al,cgroup:[si+4]
	out	dx,al
	mov	cl,0ffh			; CX <>00..func done
fc_03:
	pop	ax
	jcxz	fc_04			; CX = 00..func not done
	test	al,1			; bit- 0 = 0/1..OR/AND
	jz	fc_05
	and	ds:byte ptr [0016h],ah
	jmp	short fc_04
fc_05:
	or	ds:byte ptr [0016h],ah
fc_04:
	ret
;-----------------------------------------------------------------------;
ELSE					; <CTRL><ALT> support not needed
;-----------------------------------------------------------------------;
	public	change_speed		; change CPU speed/cache etc
change_speed:
	ret
COMMENT ~
;-----------------------------------------------------------------------;
; all registers must be saved except CX. (ds) = 40h always set, this	;
; routine is also called from INT-8, INT-16, be careful about registers.;
;-----------------------------------------------------------------------;
	public	frequency_low
frequency_low:
	push	dx
	push	ax
	call	low_speed
	mov	ax,0df20h		; AH, AL = AND, OR value
fl_01:
	jcxz	short fl_00		; CX = 00..func not done
fl_02:
	and	ds:byte ptr [0016h],ah
	or	ds:byte ptr [0016h],al
fl_00:
	pop	ax
	pop	dx
	ret
;-----------------------------------------------------------------------;
	public	frequency_high
frequency_high:
	push	dx
	push	ax
	call	high_speed
	mov	ax,0df00h		; AH, AL = AND, OR value
	jmp	short fl_01
;-----------------------------------------------------------------------;
	public	cache_on
cache_on:
	pushad
	call	enable_l1_cache
	popad
	push	dx
	push	ax
	call	enable_l2_cache
	mov	ax,0ef10h		; AH, AL = AND, OR value
					; bit-4 = 1..cache on
	jmp	short fl_02
;-----------------------------------------------------------------------;
	public	cache_off
cache_off:
	push	dx
	push	ax
	call	disable_l2_cache
	mov	ax,0ef00h		; AH, AL = AND, OR value
					; bit-4 = 0..cache off
	pushad
	call	disable_l1_cache
	popad
	jmp	short fl_02
~
	public	frequency_high
	public	frequency_low
frequency_high:
frequency_low:
	ret

;-----------------------------------------------------------------------;
ENDIF
;-----------------------------------------------------------------------;
;			TIMER_INTERRUPT_INT8				;
;-----------------------------------------------------------------------;
; This routine will get control in every timer tick, any special turbo	;
; switch can be done here. this is called from INT-8 ISR in INT8.INC.	;
; input :								;
;	DS	40H							;
;	stack	available						;
; output:								;
;	none								;
; register usage : DO NOT destroy any register				;
; Note: This routine can be used to implement the turbo switch using	;
; OEM specific stuff. The following code uses KB controller pin.	;
;-----------------------------------------------------------------------;
	public	timer_interrupt_int8
	extrn	timer_interrupt_int8_end:near
timer_interrupt_int8:
IF	MKF_TURBO_SWITCH
	extrn	turbo_switch:near
	public	turbo_switch_end
	jmp	turbo_switch
turbo_switch_end:
ENDIF					; No Turbo Switch support
;	push	ax
;	mov	al,0ah
;	call	cmos_data_in_x
;	test	al,080h			; CMOS0A.7=1 (time update in progress) ?
;	jnz	update_in_progress	; yes..

;       mov	al,032h			; Century byte
;	call	cmos_data_in_x
;	mov	ah,al
;	mov	al,009h			; RTC year
;	call	cmos_data_in_x
;	cmp	ax,1900h		; AC1900 ?
;	jne	update_in_progress
;	mov	ax,20h*256+32h
;	call	cmos_data_out_x		; 1900 -> 2000, (06/27/1995)
;update_in_progress:
; 	pop	ax

	jmp	timer_interrupt_int8_end
;-----------------------------------------------------------------------;
	public	_OEM_RUNTIME_ENDS
_OEM_RUNTIME_ENDS	label	 byte	; marks end of module
;---------------------------------------;
_text   ends
	end
